local out=assert(io.open('result.txt','w'))
local frame,entered,returned=0,nil,nil
local finished=false
local frozenPixel=nil
local function gb(a) return emu.read(a,emu.memType.gameboyMemory) end
local function finish(ok,message)
 if finished then return end
 finished=true
 out:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');out:close()
 local image=assert(io.open('handoff.png','wb'));image:write(emu.takeScreenshot());image:close()
 emu.stop(ok and 0 or 1)
end
emu.addMemoryCallback(function() if not entered then entered=frame end end,
 emu.callbackType.exec,0x7f0000,0x7f0000,emu.cpuType.snes)
emu.addMemoryCallback(function() if entered and not returned then returned=frame end end,
 emu.callbackType.exec,0x1800,0x1800,emu.cpuType.snes)
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or not returned then return end
 emu.setInput({b=true},0,0)
end,emu.eventType.inputPolled)
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or finished then return end
 frame=frame+1
 if entered and frame-entered==1 then frozenPixel=emu.getScreenBuffer()[100*emu.getScreenSize().width+101] end
 if not returned then
  if frame>1100 then finish(false,'BIOS return timeout; GB phase='..gb(0xc100)) end
  return
 end
 if frame-returned<30 then return end
 if gb(0xc100)~=5 or gb(0xc102)==0xa5 or gb(0xc102)==0 or gb(0xc102)==255 then
  finish(false,'GB did not survive handoff and resume pad polling: '..gb(0xc102));return
 end
 -- The queued MASK_EN cancel must be consumed by the resumed real BIOS.
 local pixels=emu.getScreenBuffer()
 local varied=false
 for i=2,#pixels do if pixels[i]~=pixels[1] then varied=true;break end end
 if not varied or pixels[100*emu.getScreenSize().width+101]==frozenPixel then finish(false,'BIOS did not unfreeze the new GB picture');return end
 finish(true,'JUMP returned through bank-0 RTS without GB reset; BIOS video, command processing and pad polling resumed')
end,emu.eventType.endFrame)
