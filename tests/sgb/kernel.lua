local result=assert(io.open('result.txt','w'))
local fixture=assert(io.open('kernel.bin','rb'));local expected=fixture:read('*a');fixture:close()
local frame,entered,finished=0,nil,false
local stable=0
local baseline,baseline_drawn,closed_saved=nil,nil,false
local sent_at,last_good,max_ack,last_sent=nil,0,0,0
local function finish(ok,message)
 if finished then return end;finished=true
 result:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');result:close()
 local image=assert(io.open('kernel.png','wb'));image:write(emu.takeScreenshot());image:close()
 emu.stop(ok and 0 or 1)
end
emu.addMemoryCallback(function()if not entered then entered=frame end end,emu.callbackType.exec,0x7f0000,0x7f0000,emu.cpuType.snes)


local symbols=dofile('kernel-symbols.lua')
local ui_test=symbols._test_pages>102
local function byte(name)return emu.read(symbols[name],emu.memType.snesWorkRam)end
local function word(name)return byte(name)+emu.read(symbols[name]+1,emu.memType.snesWorkRam)*256 end
local function vram()
 local b={};for i=0,32767 do b[i+1]=string.char(emu.read(i,emu.memType.snesVideoRam))end;return table.concat(b)
end
local function save_ppm(name)
 local pixels,size=emu.getScreenBuffer(),emu.getScreenSize();local scale=size.height//239
 local ppm=assert(io.open(name,'wb'));ppm:write('P6\n256 224\n255\n')
 for y=0,223 do for x=0,255 do local p=pixels[(y+7)*scale*size.width+x*scale+1];ppm:write(string.char((p>>16)&255,(p>>8)&255,p&255))end end;ppm:close()
end
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or finished then return end;frame=frame+1
 if not entered then
  if frame>3000 then finish(false,'JUMP timeout GB phase '..emu.read(0xc100,emu.memType.gameboyMemory)) end
  return
 end
 if frame==entered+10 then
  for i=1,#expected do
   local actual=emu.read(0x10000+i-1,emu.memType.snesWorkRam)
   if actual~=expected:byte(i)then finish(false,string.format('upload mismatch %04X: %02X != %02X',i-1,actual,expected:byte(i)));return end
  end
 end
 if frame%1000==0 then
  result:write(string.format('frame %d stage %d page %d good %d bad %d rows %d missed %d drawn %d queue %d\n',frame,emu.read(0xc100,emu.memType.gameboyMemory),emu.read(0xc111,emu.memType.gameboyMemory),word('_good_pages'),word('_bad_pages'),word('_capture_rows'),word('_capture_missed'),word('_drawn_rows'),byte('_qcount')));result:flush()
 end
 local sent=emu.read(0xc113,emu.memType.gameboyMemory)
 if sent~=last_sent then sent_at=frame;last_sent=sent end
 local good=word('_good_pages')
 if good~=last_good then
  if sent_at then max_ack=math.max(max_ack,frame-sent_at) end
  last_good=good
 end
 local dirty=false
 for i=0,27 do if emu.read(symbols['_dirty']+i,emu.memType.snesWorkRam)~=0 or emu.read(symbols['_overlay_dirty']+i,emu.memType.snesWorkRam)~=0 then dirty=true end end
 if not dirty and byte('_scroll_pending')==0 then stable=stable+1 else stable=0 end
 if ui_test and stable>=3 then
  if good==103 and not baseline then baseline=vram();baseline_drawn=word('_drawn_rows') end
  if good==106 and not closed_saved then save_ppm('kernel-closed.ppm');closed_saved=true end
 end
 if emu.read(0xc100,emu.memType.gameboyMemory)==6 and stable>=3 then
  if ui_test then
   if not baseline or not closed_saved then finish(false,'UI checkpoints were not reached');return end
   if vram()~=baseline or word('_drawn_rows')~=baseline_drawn then finish(false,'overlay update redrew or changed BG1');return end
   result:write('PASS: menu open/highlight/close, OSK, bars, busy, progress and theme leave BG1 bytes and draw count unchanged\n')
  end
  save_ppm('kernel.ppm')
  if max_ack==0 or max_ack>120 then finish(false,'page ACK exceeded 120 frames: '..max_ack);return end
  finish(true,string.format('real kernel replay: %d pages, %d rows, %d missed; longest ACK %d SNES frames',word('_good_pages'),word('_drawn_rows'),word('_capture_missed'),max_ack))
 elseif frame>60000 then
  local state=emu.getState();local f=assert(io.open('kernel-state.txt','w'));for k,v in pairs(state)do f:write(tostring(k)..'='..tostring(v)..'\n')end;f:close()
  finish(false,'replay timeout')
 end
end,emu.eventType.endFrame)
