-- Mesen's SNES mouse serial device drives the uploaded 65816 program;
-- assertions read the GB program's own P1 results, not injected mailbox bytes.
local out=assert(io.open('result.txt','w'))
local frame,ready=0,nil
local finished=false
local function read(a) return emu.read(a,emu.memType.gameboyMemory) end
local function fail(message)
 if finished then return end
 finished=true
 out:write('FAIL: '..message..'\n');out:close();emu.stop(1)
end
local function check(ok,message) if not ok then fail(message) end end
emu.addMemoryCallback(function(a,v)
 if v==0xb1 and not ready then
  ready=frame
 end
end,emu.callbackType.write,0x6003,0x6003,emu.cpuType.snes)
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or not ready then return end
 local t=frame-ready
 local input={xOffset=0,yOffset=0,left=false,right=false}
 if t>=10 and t<20 then input.xOffset=1;input.yOffset=-1;input.left=true end
 if t>=30 and t<40 then input.xOffset=-1;input.yOffset=1;input.right=true end
 if t>=50 and t<60 then input.xOffset=127;input.yOffset=127 end
 if t>=70 and t<80 then input.xOffset=-127;input.yOffset=-127 end
 if t>=95 and t<98 then input.left=true end
 if t>=100 and t<103 then input.right=true end
 -- This workspace's Mesen Lua SetInput pops its port from argument 3.
 -- Supplying both positions also works with upstream's documented signature.
 emu.setInput(input,1,1)
 emu.setInput({b=true},0,0)
end,emu.eventType.inputPolled)
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or finished then return end
 frame=frame+1
 if not ready then if frame>800 then fail('bridge did not install') end;return end
 local t=frame-ready
 local flags,x,y=read(0xc100),read(0xc101),read(0xc102)
 if t==7 then check(flags==0,'pointer report before input') end
 if t==25 then
  check(flags%8==1,'left release/buttons/signature')
  check(x==90 and y==62,'positive X / negative Y: '..x..','..y)
  check(read(0xc105)==2,'controller 1 B button survives mailbox polling: '..read(0xc105))
 end
 if t==15 then check(flags%8==3,'left press: '..flags..' x='..x..' y='..y..' GBpc='..emu.getState()['cart.gameboy.cpu.pc']) end
 if t==35 then check(flags%8==5,'right press') end
 if t==45 then check(x==80 and y==72,'negative X / positive Y: '..x..','..y) end
 if t==65 then check(x==159 and y==143,'positive saturation') end
 if t==85 then check(x==0 and y==0,'negative saturation') end
 if t==90 then
  emu.write(0xc103,0,emu.memType.gameboyMemory)
  emu.write(0xc107,1,emu.memType.gameboyMemory)
 end
 if t==110 then emu.write(0xc107,0,emu.memType.gameboyMemory) end
 if t==125 then check(read(0xc103)==6 and flags%8==1,'queued clicks survive a busy GB and finish released') end
 if t==130 then emu.write(0xc106,1,emu.memType.gameboyMemory) end
 if t==160 then
  check(read(0xc106)==2,'GB finished uninstall')
  -- Installer saved the BIOS vector in its own RAM. It must be restored.
  check(emu.read(0xbb,emu.memType.snesWorkRam)==0x0a and emu.read(0xbc,emu.memType.snesWorkRam)==0xb5,'BIOS vector restored')
  finished=true
  out:write('PASS: SNES mouse upload, signed motion, both buttons, coordinate limits, GB P1 mailbox, queued clicks during a busy GB, controller 1 and uninstall\n')
  out:close();emu.stop(0)
 end
end,emu.eventType.endFrame)
