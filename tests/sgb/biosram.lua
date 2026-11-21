-- Phase 0c follow-up: what must survive for the fullscreen kernel to return to the SGB BIOS.
-- Runs the handoff probe (JUMP, then a bank-0 RTS back into the BIOS). At JUMP it snapshots the
-- BIOS's WRAM, VRAM, CGRAM, OAM and CPU registers; after the return it records which WRAM bytes the
-- BIOS reads before writing (its live state) and which PPU/DMA/ICD2 registers it writes again.
-- The report goes to result.txt (summary) and metrics.json (ranges).
local frame,entered,returned=0,nil,nil
local finished=false
local W=emu.memType.snesWorkRam
local at={wram={},vram={},cgram={},oam={}}
local written,live,touched={}, {}, {}
local regs={}
local dma={}
local cpu={}
local FRAMES=tonumber(os.getenv('BIOSRAM_FRAMES') or '900')

local function snap(memType,size,into)
 for i=0,size-1 do into[i]=emu.read(i,memType) end
end

local function ranges(set,size)
 local out,start={},nil
 for i=0,size do
  if set[i] and not start then start=i
  elseif not set[i] and start then out[#out+1]={start,i-1};start=nil end
 end
 return out
end

local function fmt(list,base)
 local parts={}
 for _,r in ipairs(list) do
  parts[#parts+1]=string.format('%06X-%06X(%d)',(base or 0)+r[1],(base or 0)+r[2],r[2]-r[1]+1)
 end
 return table.concat(parts,' ')
end

local function count(list)
 local n=0
 for _,r in ipairs(list) do n=n+r[2]-r[1]+1 end
 return n
end

-- The kernel's WRAM (offsets into the 128 KiB): DP $0000-00BF, its stack below $1FFF (sized
-- generously at $1E00-1FFF), $7E:2000-FFFF and all of $7F.
local function kernel(i)
 return i<0xC0 or (i>=0x1E00 and i<0x2000) or i>=0x2000
end

local function finish(ok,message)
 if finished then return end
 finished=true
 local out=assert(io.open('result.txt','w'))
 out:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n')
 if ok then
  local liveR=ranges(live,0x1FFFF)
  local clash={}
  for i in pairs(live) do if kernel(i) then clash[i]=true end end
  local clashR=ranges(clash,0x1FFFF)
  local used={}
  for i=0,0x1FFFF do if at.wram[i]~=0 then used[i]=true end end
  local usedR=ranges(used,0x1FFFF)
  local vused={}
  for i=0,0xFFFF do if at.vram[i]~=0 then vused[i]=true end end
  local touchR=ranges(touched,0x1FFFF)
  out:write(string.format('CPU at JUMP: %s\n',table.concat(cpu,' ')))
  out:write(string.format('WRAM nonzero at JUMP: %d bytes in %d ranges\n',count(usedR),#usedR))
  out:write(string.format('WRAM the BIOS accessed in %d frames after return: %d bytes\n',FRAMES,count(touchR)))
  out:write(string.format('WRAM live (read before written): %d bytes: %s\n',count(liveR),fmt(liveR,0x7E0000)))
  out:write(string.format('  of which the kernel overwrites: %d bytes: %s\n',count(clashR),fmt(clashR,0x7E0000)))
  out:write(string.format('VRAM nonzero at JUMP: %d bytes: %s\n',count(ranges(vused,0xFFFF)),fmt(ranges(vused,0xFFFF))))
  local cg=0 for i=0,511 do if at.cgram[i]~=0 then cg=cg+1 end end
  out:write(string.format('CGRAM nonzero at JUMP: %d of 512\n',cg))
  local names={}
  for a,v in pairs(regs) do names[#names+1]=string.format('%04X=%02X',a,v) end
  table.sort(names)
  out:write('Registers written after return (last value): '..table.concat(names,' ')..'\n')
  local d={}
  for k in pairs(dma) do d[#d+1]=k end
  table.sort(d)
  out:write('DMA after return (channel bbus src size): '..table.concat(d,' ')..'\n')
  local m=assert(io.open('metrics.json','w'))
  m:write('{"live":[')
  for n,r in ipairs(liveR) do m:write((n>1 and ',' or '')..string.format('[%d,%d]',r[1],r[2])) end
  m:write('],"touched":[')
  for n,r in ipairs(touchR) do m:write((n>1 and ',' or '')..string.format('[%d,%d]',r[1],r[2])) end
  m:write('],"wram":"')
  for i=0,0x1FFFF do m:write(string.format('%02x',at.wram[i])) end
  m:write('","vram":"')
  for i=0,0xFFFF do m:write(string.format('%02x',at.vram[i])) end
  m:write('","cgram":"')
  for i=0,511 do m:write(string.format('%02x',at.cgram[i])) end
  m:write('","oam":"')
  for i=0,543 do m:write(string.format('%02x',at.oam[i])) end
  m:write('"}\n')
  m:close()
 end
 out:close()
 local image=assert(io.open('handoff.png','wb'));image:write(emu.takeScreenshot());image:close()
 emu.stop(ok and 0 or 1)
end

emu.addMemoryCallback(function()
 if entered then return end
 entered=frame
 snap(W,0x20000,at.wram)
 snap(emu.memType.snesVideoRam,0x10000,at.vram)
 snap(emu.memType.snesCgRam,512,at.cgram)
 snap(emu.memType.snesSpriteRam,544,at.oam)
 local s=emu.getState()
 for _,k in ipairs({'sp','d','dbr','k','ps','emulationMode'}) do cpu[#cpu+1]=k..'='..tostring(s['cpu.'..k]) end
end,emu.callbackType.exec,0x7f0000,0x7f0000,emu.cpuType.snes)

-- BIOSRAM_CLOBBER=1: on the return, the kernel's whole WRAM footprint gets garbage except the bytes the
-- kernel would save (SAVE), and VRAM/CGRAM/OAM are wiped then put back from the JUMP snapshot (as a
-- kernel restoring video would). The BIOS must still draw the GB and process the queued command.
local SAVE={{0x28,0x29},{0x5000,0x506F},{0xC000,0xC08F},{0xCBF0,0xCC2B}}
local FOOT={{0x20,0xFF},{0x1000,0x11FF},{0x1F00,0x1FFF},{0x2000,0x1FFFF}}
local function clobber()
 local keep={}
 for _,r in ipairs(SAVE) do for i=r[1],r[2] do keep[i]=emu.read(i,W) end end
 for _,r in ipairs(FOOT) do for i=r[1],r[2] do emu.write(i,(i*37+0x5A)&255,W) end end
 for i,v in pairs(keep) do emu.write(i,v,W) end
 local video={{emu.memType.snesVideoRam,at.vram,0x10000},{emu.memType.snesCgRam,at.cgram,512},{emu.memType.snesSpriteRam,at.oam,544}}
 for _,m in ipairs(video) do
  for i=0,m[3]-1 do emu.write(i,0xA5,m[1]) end
  if os.getenv('BIOSRAM_VIDEO')~='0' then for i=0,m[3]-1 do emu.write(i,m[2][i],m[1]) end end
 end
 -- BIOSRAM_SKIP=C000-DFFF,8000-9FFF: VRAM byte ranges left wiped (to see what the BIOS rebuilds itself)
 for a,b in (os.getenv('BIOSRAM_SKIP') or ''):gmatch('(%x+)-(%x+)') do
  for i=tonumber(a,16),tonumber(b,16) do emu.write(i,0,emu.memType.snesVideoRam) end
 end
end
emu.addMemoryCallback(function()
 if not entered or returned then return end
 returned=frame
 if os.getenv('BIOSRAM_CLOBBER')=='1' then clobber() end
 emu.addMemoryCallback(function(a)
  touched[a]=true
  if not written[a] then live[a]=true end
 end,emu.callbackType.read,0,0x1FFFF,emu.cpuType.snes,W)
 emu.addMemoryCallback(function(a)
  touched[a]=true
  written[a]=true
 end,emu.callbackType.write,0,0x1FFFF,emu.cpuType.snes,W)
 -- (the BIOS runs FastROM from bank $80, so its register writes land in $80:xxxx)
 local function hook(f,lo,hi)
  for _,bank in ipairs({0,0x800000}) do
   emu.addMemoryCallback(function(a,v) f(a&0xFFFF,v) end,emu.callbackType.write,bank+lo,bank+hi,emu.cpuType.snes,emu.memType.snesMemory)
  end
 end
 local function reg(a,v) regs[a]=v end
 hook(reg,0x2100,0x2103);hook(reg,0x2105,0x2117);hook(reg,0x211A,0x2121);hook(reg,0x2123,0x2133)
 hook(reg,0x4200,0x420A);hook(reg,0x420C,0x420D);hook(reg,0x6000,0x6007)
 hook(function(a,v)
  if a==0x420B and v~=0 then
   for ch=0,7 do
    if v&(1<<ch)~=0 then
     local b=0x4300+ch*16
     local r=function(o) return regs[b+o] or 0 end
     dma[string.format('%d:21%02X:%02X%02X%02X:%04X',ch,r(1),r(4),r(3),r(2),r(5)|(r(6)<<8))]=true
    end
   end
  end
 end,0x4300,0x437F)
 hook(function(a,v) regs[a]=v
  if v==0 then return end
  for ch=0,7 do
   if v&(1<<ch)~=0 then
    local b=0x4300+ch*16
    local r=function(o) return regs[b+o] or 0 end
    dma[string.format('%d:21%02X:%02X%02X%02X:%04X',ch,r(1),r(4),r(3),r(2),r(5)|(r(6)<<8))]=true
   end
  end
 end,0x420B,0x420B)
end,emu.callbackType.exec,0x1800,0x1800,emu.cpuType.snes)

local function gb(a) return emu.read(a,emu.memType.gameboyMemory) end
local frozen
-- BIOSRAM_MENU=1: L+R held from 60 frames after the return for 20 frames (the BIOS's menu); screenshots
-- menu.png 120 frames after the return
emu.addEventCallback(function(c)
 if c~=emu.cpuType.snes or not returned then return end
 local menu=os.getenv('BIOSRAM_MENU')=='1' and frame-returned>=60 and frame-returned<(tonumber(os.getenv("BIOSRAM_MENU_HOLD") or "20")+60)
 emu.setInput({b=not menu,l=menu,r=menu},0,0)
 if os.getenv('BIOSRAM_MENU')=='1' and frame-returned==tonumber(os.getenv("BIOSRAM_MENU_SHOT") or "120") then
  local image=assert(io.open('menu.png','wb'));image:write(emu.takeScreenshot());image:close()
 end
end,emu.eventType.inputPolled)
emu.addEventCallback(function(c)
 if c~=emu.cpuType.snes or finished then return end
 frame=frame+1
 if entered and frame-entered==1 then frozen=emu.getScreenBuffer()[100*emu.getScreenSize().width+101] end
 if not returned then
  if frame>1100 then finish(false,'BIOS return timeout') end
  return
 end
 if frame-returned<FRAMES then return end
 -- as handoff.lua: the GB still polls the pad through the BIOS, and the BIOS ran the queued MASK_EN cancel
 if gb(0xc100)~=5 or gb(0xc102)==0xa5 or gb(0xc102)==0 or gb(0xc102)==255 then
  finish(false,'GB did not resume pad polling through the BIOS: '..gb(0xc102));return
 end
 local pixels=emu.getScreenBuffer()
 local varied=false
 for i=2,#pixels do if pixels[i]~=pixels[1] then varied=true;break end end
 if not varied or pixels[100*emu.getScreenSize().width+101]==frozen then finish(false,'BIOS did not unfreeze the GB picture');return end
 finish(true,'BIOS resumed'..(os.getenv('BIOSRAM_CLOBBER')=='1' and ' after the kernel footprint was overwritten' or '')..'; '..FRAMES..' frames recorded')
end,emu.eventType.endFrame)
