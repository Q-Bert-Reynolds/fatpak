-- The SNES mouse in fullscreen (snes/mouse.s) through the real SGB BIOS and Mesen's mouse in port 2: once the
-- synthetic session's pages are in (tests/sgb/text_replay.py build), the mouse moves, clicks, drags and lets go.
-- The kernel's mailbox must publish MOVE, DOWN, DRAG and UP with the right buttons, row and x, the pointer (OAM
-- entry 1, tile 2) must follow it, and the pad's port 1 keep working.
local result=assert(io.open('result.txt','w'))
local symbols=dofile('kernel-symbols.lua')
local W=emu.memType.snesWorkRam
local frame,entered,done_at,finished=0,nil,nil,false
local events={}
local function finish(ok,message)
 if finished then return end;finished=true
 result:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');result:close()
 local f=assert(io.open('mouse.png','wb'));f:write(emu.takeScreenshot());f:close()
 emu.stop(ok and 0 or 1)
end
local function byte(name)return emu.read(symbols[name],W)end
local mailbox={0,0,0,0}
for _,bank in ipairs({0,0x800000}) do
 emu.addMemoryCallback(function(a,v)
  local i=(a&7)-3 -- $6004..$6007: 1..4
  mailbox[i]=v
  if i==1 and v~=0 and v<128 then -- the commit: the sequence written again without its busy bit
   local t=mailbox[2]
   if t==2 or t==3 or t==4 or t==8 then
    local last=events[#events]
    if not last or last.seq~=v then events[#events+1]={seq=v,type=t,a=mailbox[3],b=mailbox[4]} end
   end
  end
 end,emu.callbackType.write,bank+0x6004,bank+0x6007,emu.cpuType.snes,emu.memType.snesMemory)
end
emu.addMemoryCallback(function()if not entered then entered=frame end end,emu.callbackType.exec,0x7f0000,0x7f0000,emu.cpuType.snes)
if os.getenv('MOUSE_TRACE') then -- writes to $7F:1000-$1012 (Capture's flags, if called with DBR $7F)
 local seen={}
 emu.addMemoryCallback(function(a,v)
  local s=emu.getState();local k=string.format('%02X:%04X DBR %02X',s['cpu.k'],s['cpu.pc'],s['cpu.dbr'])
  if not seen[k] then seen[k]=true;local f=io.open('mouse.txt','a');f:write(string.format('write %05X by %s\n',a,k));f:close() end
 end,emu.callbackType.write,0x11000,0x11012,emu.cpuType.snes,W)
end
if os.getenv('MOUSE_TRACE') then -- each read: the frame, its line, the last motion and the pointer
 local n=0
 emu.addMemoryCallback(function()
  if not done_at or n>60 then return end
  n=n+1
  local f=io.open('mouse.txt','a')
  f:write(string.format('t%d V%d motion %02X%02X x%d y%d\n',frame-done_at,emu.getState()['ppu.scanline'],
   emu.read(symbols['MouseX']+5,W),emu.read(symbols['MouseX']+4,W),emu.read(symbols['MouseX'],W),emu.read(symbols['MouseY'],W)))
  f:close()
 end,emu.callbackType.exec,0x7E0000+symbols['MouseRead'],0x7E0000+symbols['MouseRead'],emu.cpuType.snes)
end
emu.addEventCallback(function(c)
 if c~=emu.cpuType.snes or not done_at then return end
 local t=frame-done_at
 local m={xOffset=0,yOffset=0,left=false,right=false}
 if t>=10 and t<20 then m.xOffset=3;m.yOffset=2 end -- hover: 30 right, 20 down
 if t>=40 and t<50 then m.left=true end
 if t>=50 and t<60 then m.left=true;m.xOffset=-2 end -- drag 20 left
 if t>=90 and t<100 then m.right=true end
 emu.setInput(m,1,1)
end,emu.eventType.inputPolled)
emu.addEventCallback(function(c)
 if c~=emu.cpuType.snes or finished then return end;frame=frame+1
 if not entered then if frame>3000 then finish(false,'JUMP timeout') end;return end
 if not done_at then
  -- the replay pauses at its checkpoints ($C117: text.lua's screenshots): go on at once
  if emu.read(0xC117,emu.memType.gameboyMemory)==1 then emu.write(0xC117,0,emu.memType.gameboyMemory) end
  -- the replay is done when the GB's stage is 6 (tests/sgb/kernel.asm)
  if emu.read(0xC100,emu.memType.gameboyMemory)==6 then done_at=frame;events={} end
  if frame-entered>20000 then finish(false,'the replay did not finish') end
  return
 end
 local t=frame-done_at
 if t==35 then
  local x,y=emu.read(symbols['MouseX'],W),emu.read(symbols['MouseY'],W)
  if x~=158 or y~=132 then finish(false,string.format('pointer at %d,%d, not 158,132',x,y));return end
  local oam={}
  for i=0,3 do oam[i]=emu.read(4+i,emu.memType.snesSpriteRam) end
  if oam[0]~=158 or oam[1]~=131 or oam[2]~=2 then finish(false,string.format('OAM entry 1: %d,%d tile %d',oam[0],oam[1],oam[2]));return end
  if byte('_text_mode')==0 then -- 256x224: window 1 takes BG3 (menus) away under the arrow's pixels, HDMA 5's table
   local want={127,255,0, 5,255,0}
   for i,w in ipairs({0,1,2,3,4,5,3,1}) do want[#want+1]=1;want[#want+1]=158;want[#want+1]=158+w end
   for _,v in ipairs({1,255,0, 0}) do want[#want+1]=v end
   for i,v in ipairs(want) do
    local got=emu.read(symbols['Window']+i-1,W)
    if got~=v then finish(false,string.format('pointer window table byte %d: %d, not %d',i-1,got,v));return end
   end
  end
 end
 if t==140 then
  local cells=byte('_text_mode')~=0
  local function row(y)return cells and (y>>2) or (y>>3) end
  local want={{8,0,row(132),158},{2,1,row(132),158},{3,1,row(132),138},{4,0,row(132),138},{2,2,row(132),138},{4,0,row(132),138}}
  local got={}
  for _,e in ipairs(events) do got[#got+1]=string.format('%d/%d/%d/%d',e.type,e.a>>6,e.a&63,e.b) end
  -- motion is coalesced: the last MOVE and DRAG carry the final position
  local merged={}
  for _,e in ipairs(events) do
   local p=merged[#merged]
   if p and p.type==e.type and (e.type==3 or e.type==8) and (p.a>>6)==(e.a>>6) then p.a=e.a;p.b=e.b else merged[#merged+1]={type=e.type,a=e.a,b=e.b} end
  end
  if #merged~=#want then finish(false,'events '..table.concat(got,' '));return end
  for i,w in ipairs(want) do
   local e=merged[i]
   if e.type~=w[1] or (e.a>>6)~=w[2] or (e.a&63)~=w[3] or e.b~=w[4] then finish(false,'events '..table.concat(got,' '));return end
  end
  finish(true,string.format('SNES mouse: MOVE, DOWN, DRAG, UP, a right click, %d mailbox events, row %d (%s), pointer OAM entry 1',
   #events,row(132),cells and '512x448 text' or '256x224'))
 end
end,emu.eventType.endFrame)
