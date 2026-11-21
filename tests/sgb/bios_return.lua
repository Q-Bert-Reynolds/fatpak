-- EXIT (snes/bios.s) through the real SGB BIOS: run_sgb_bios_return.sh. At JUMP the BIOS's VRAM, CGRAM, OAM,
-- WRAM and ARAM are snapshotted; after the kernel's session and EXIT they must be back (the GB screen's tiles
-- are the BIOS's to refresh; the NMI pointer is the BIOS's own again), the CPU in the BIOS, the ICD2 at one
-- player, the border on screen as before JUMP, and L+R must open the BIOS's menu.
local result=assert(io.open('result.txt','w'))
local symbols=dofile('kernel-symbols.lua')
local W,V,C,O,A=emu.memType.snesWorkRam,emu.memType.snesVideoRam,emu.memType.snesCgRam,emu.memType.snesSpriteRam,emu.memType.spcRam
local frame,entered,main,returned,finished=0,nil,nil,nil,false
local at={wram={},vram={},cgram={},oam={},aram={}}
local before
local function finish(ok,message)
 if finished then return end;finished=true
 result:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');result:close();emu.stop(ok and 0 or 1)
end
local function shot(name)local f=assert(io.open(name,'wb'));f:write(emu.takeScreenshot());f:close()end
local function snap(t,m,n)for i=0,n-1 do t[i]=emu.read(i,m)end end
-- the border's pixels (the GB's 160x144 window, 48..207 x 40..183 of 256x224, is the GB's to change)
local function border()
 local p,size=emu.getScreenBuffer(),emu.getScreenSize();local scale=size.height//224;local out={}
 for y=0,223 do for x=0,255 do
  if x<48 or x>=208 or y<40 or y>=184 then out[#out+1]=p[y*scale*size.width+x*scale+1] end
 end end
 return out
end
emu.addMemoryCallback(function()
 if entered then return end
 entered=frame;before=border()
 snap(at.wram,W,0x20000);snap(at.vram,V,0x10000);snap(at.cgram,C,512);snap(at.oam,O,544);snap(at.aram,A,0x10000)
 shot('bios-before.png')
end,emu.callbackType.exec,0x7f0000,0x7f0000,emu.cpuType.snes)
emu.addMemoryCallback(function()if entered and not main then main=frame end end,
 emu.callbackType.exec,0x7f0000+symbols['_main'],0x7f0000+symbols['_main'],emu.cpuType.snes)
-- the return: the BIOS's RTS (bios.s BIOS_RTS) once the kernel has run
local memory_checked,exit_at
emu.addMemoryCallback(function()if not exit_at then exit_at=frame end end,
 emu.callbackType.exec,0x7f0000+symbols['_BiosReturn'],0x7f0000+symbols['_BiosReturn'],emu.cpuType.snes)
local check_memory
emu.addMemoryCallback(function()
 if main and not returned then returned=frame;check_memory() end
end,emu.callbackType.exec,0x00AC88,0x00AC88,emu.cpuType.snes)
local function differ(t,m,from,to,skip)
 local n,first=0,nil
 for i=from,to do
  if not (skip and skip(i)) and emu.read(i,m)~=t[i] then n=n+1;first=first or i end
 end
 return n,first
end
local menu_shot
local trace,irqs={},0
if os.getenv('BIOS_RETURN_TRACE') then
 for _,bank in ipairs({0,0x800000}) do
  emu.addMemoryCallback(function() if returned then irqs=irqs+1 end end,emu.callbackType.exec,bank+0xB50A,bank+0xB50A,emu.cpuType.snes)
 end
 emu.addEventCallback(function(c)
  if c~=emu.cpuType.snes or not returned or frame-returned>40 then return end
  local s=emu.getState()
  trace[#trace+1]=string.format('%02X:%04X p%02X i%d irqen%s%s t%d/%d',s['cpu.k'],s['cpu.pc'],s['cpu.ps'],irqs,tostring(s['internalRegisters.enableHorizontalIrq']),tostring(s['internalRegisters.enableVerticalIrq']),s['internalRegisters.horizontalTimer'],s['internalRegisters.verticalTimer'])
  if frame-returned==40 then local f=io.open('bios-trace.txt','w');f:write(table.concat(trace,' ')..'\n');f:close() end
 end,emu.eventType.endFrame)
end
emu.addEventCallback(function(c)
 if c~=emu.cpuType.snes or not returned then return end
 local hold=frame-returned>=120 and frame-returned<200
 emu.setInput({l=hold,r=hold},0,0)
end,emu.eventType.inputPolled)
emu.addEventCallback(function(c)
 if c~=emu.cpuType.snes or finished then return end;frame=frame+1
 if not entered then if frame>3000 then finish(false,'JUMP timeout') end;return end
 if not returned then
  if frame-entered>4000 then finish(false,string.format('no return to the BIOS (main after %s frames, good pages %d)',
   tostring(main and main-entered),emu.read(symbols['_good_pages'],W)+256*emu.read(symbols['_good_pages']+1,W)))end
  return
 end
end,emu.eventType.endFrame)
-- (at the return, before the BIOS runs again)
check_memory=function()
  local checks={
   {'VRAM',at.vram,V,0,0xFFFF,function(i)return i>=0xE000 and i<0xF800 end}, -- (the GB screen's tiles)
   {'CGRAM',at.cgram,C,0,511},{'OAM',at.oam,O,0,543},
   {'WRAM low',at.wram,W,0,0x1FFF,function(i)return (i>=0xBB and i<=0xBD) or (i>=0x0F00 and i<0x1000) or (i>=0x1800 and i<0x1900) end},
   {'WRAM $5000',at.wram,W,0x5000,0x53FF},{'WRAM $C000',at.wram,W,0xC000,0xC0FF},{'WRAM $CB00',at.wram,W,0xCB00,0xCCFF},
   {'ARAM driver',at.aram,A,0x0400,0x4AFF},{'ARAM samples',at.aram,A,0x4B00,0xEEEF}}
  local bad={}
  for _,k in ipairs(checks) do
   local n,first=differ(k[2],k[3],k[4],k[5],k[6])
   if n>0 then bad[#bad+1]=string.format('%s: %d bytes differ from JUMP, first at %04X',k[1],n,first) end
  end
  if os.getenv('BIOS_RETURN_DUMP') then
   local f=assert(io.open('bios-vram.txt','w'))
   for i=0,0xFFFF do f:write(string.format('%02x%02x',at.vram[i],emu.read(i,V))) end
   f:close()
  end
  if #bad>0 then finish(false,table.concat(bad,'; '));return end
  local nmi=emu.read(0xBB,W)+256*emu.read(0xBC,W)+65536*emu.read(0xBD,W)
  if nmi~=0x00B50A then finish(false,string.format('NMI pointer %06X',nmi));return end
  memory_checked=true
end
emu.addEventCallback(function(c)
 if c~=emu.cpuType.snes or finished or not returned then return end
 if frame-returned==60 then
  local after=border();local n=0
  for i=1,#before do if before[i]~=after[i] then n=n+1 end end
  if n>0 then shot('bios-after.png');finish(false,n..' border pixels differ from before JUMP');return end
  local s=emu.getState()
  if s['cpu.k']~=0 and s['cpu.k']~=0x80 then finish(false,string.format('CPU in bank %02X, not the BIOS',s['cpu.k']));return end
  shot('bios-after.png')
  if emu.read(0xC100,emu.memType.gameboyMemory)~=8 then
   finish(false,'the GB did not see one player and unfreeze the BIOS (stage '..emu.read(0xC100,emu.memType.gameboyMemory)..')');return
  end
  result:write(string.format('BIOS saved in %d SNES frames; EXIT took %d\n',main-entered,returned-(exit_at or returned)))
 end
 if frame-returned==260 then
  shot('bios-menu.png')
  local after=border();local n=0
  for i=1,#before do if before[i]~=after[i] then n=n+1 end end
  if n<500 then finish(false,'L+R: the BIOS menu did not open ('..n..' border pixels changed)');return end
  finish(true,'EXIT: the BIOS back with its video, WRAM, ARAM (samples and driver) and NMI pointer as at JUMP, its border; '..
   'the GB saw one player and unfroze it; L+R opens its menu')
 end
end,emu.eventType.endFrame)
