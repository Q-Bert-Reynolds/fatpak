-- The map view's replay (tests/sgb/map_replay.py): at each checkpoint the GB transport pauses ($C117), and
-- once the kernel has had time to draw it, the picture is saved as map-<good pages>.ppm; at the end, map-end.ppm.
local result=assert(io.open('result.txt','w'))
local symbols=dofile('kernel-symbols.lua')
local frame,entered,finished,paused,ended=0,nil,false,0,0
local function finish(ok,message)
 if finished then return end;finished=true
 result:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');result:close();emu.stop(ok and 0 or 1)
end
emu.addMemoryCallback(function()if not entered then entered=frame end end,emu.callbackType.exec,0x7f0000,0x7f0000,emu.cpuType.snes)
local function byte(name)return emu.read(symbols[name],emu.memType.snesWorkRam)end
local function word(name)return byte(name)+emu.read(symbols[name]+1,emu.memType.snesWorkRam)*256 end
local function save_ppm(name)
 local pixels,size=emu.getScreenBuffer(),emu.getScreenSize();local scale=size.height//239
 local ppm=assert(io.open(name,'wb'));ppm:write('P6\n256 224\n255\n')
 for y=0,223 do for x=0,255 do local p=pixels[(y+7)*scale*size.width+x*scale+1];ppm:write(string.char((p>>16)&255,(p>>8)&255,p&255))end end;ppm:close()
end
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or finished then return end;frame=frame+1
 if not entered then if frame>3000 then finish(false,'JUMP timeout') end;return end
 if emu.read(0xC117,emu.memType.gameboyMemory)==1 then
  paused=paused+1
  if paused==240 then
   save_ppm('map-'..word('_good_pages')..'.ppm')
   result:write(string.format('checkpoint: %d pages, map mode %d\n',word('_good_pages'),byte('_map_mode')));result:flush()
   emu.write(0xC117,0,emu.memType.gameboyMemory);paused=0
  end
  return
 end
 if emu.read(0xc100,emu.memType.gameboyMemory)==6 then
  ended=ended+1
  if ended==240 then
   save_ppm('map-end.ppm')
   finish(byte('_map_mode')==0,string.format('replayed %d pages, %d bad, map mode %d at the end',word('_good_pages'),word('_bad_pages'),byte('_map_mode')))
  end
 elseif frame>90000 then finish(false,'replay timeout: '..word('_good_pages')..' pages')
 end
end,emu.eventType.endFrame)
