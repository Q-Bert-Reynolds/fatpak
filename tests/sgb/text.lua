-- 512x448 character text's replay (tests/sgb/text_replay.py): at each checkpoint the GB transport pauses ($C117), and
-- once the kernel has had time to draw it, the picture is saved as text-<good pages>.ppm; at the end, text-end.ppm.
local result=assert(io.open('result.txt','w'))
local symbols=dofile('kernel-symbols.lua')
local frame,entered,finished,paused,ended=0,nil,false,0,0
local function finish(ok,message)
 if finished then return end;finished=true
 result:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');result:close();emu.stop(ok and 0 or 1)
end
emu.addMemoryCallback(function()if not entered then entered=frame end end,emu.callbackType.exec,0x7f0000,0x7f0000,emu.cpuType.snes)
local late={}
if os.getenv('TEXT_DEBUG') then
 emu.addMemoryCallback(function(addr,value)
  local st=emu.getState();local line=st['snes.ppu.scanline']
  if line<225 and #late<40 then
   late[#late+1]=string.format('f%d line %d vram %04x mode %d',frame,line,st['snes.ppu.vramAddress'] or -1,emu.read(symbols['_text_mode'],emu.memType.snesWorkRam))
  end
 end,emu.callbackType.write,0x420B,0x420B,emu.cpuType.snes,emu.memType.snesMemory)
end
local function byte(name)return emu.read(symbols[name],emu.memType.snesWorkRam)end
local function word(name)return byte(name)+emu.read(symbols[name]+1,emu.memType.snesWorkRam)*256 end
local function save_ppm(name)
 -- 512 wide (mode 5 + interlace): every pixel and line, 448 of them from line 14; else 256x224 as map.lua
 local pixels,size=emu.getScreenBuffer(),emu.getScreenSize();local ppm=assert(io.open(name,'wb'))
 if size.width>=512 then
  ppm:write('P6\n512 448\n255\n')
  for y=0,447 do for x=0,511 do local p=pixels[(y+14)*size.width+x+1];ppm:write(string.char((p>>16)&255,(p>>8)&255,p&255))end end
 else
  local scale=size.height//239;ppm:write('P6\n256 224\n255\n')
  for y=0,223 do for x=0,255 do local p=pixels[(y+7)*scale*size.width+x*scale+1];ppm:write(string.char((p>>16)&255,(p>>8)&255,p&255))end end
 end
 ppm:close()
end
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or finished then return end;frame=frame+1
 if not entered then if frame>3000 then finish(false,'JUMP timeout') end;return end
 if emu.read(0xC117,emu.memType.gameboyMemory)==1 then
  paused=paused+1
  if paused==240 then
   save_ppm('text-'..word('_good_pages')..'.ppm')
   result:write(string.format('checkpoint: %d pages, text mode %d\n',word('_good_pages'),byte('_text_mode')));result:flush()
   emu.write(0xC117,0,emu.memType.gameboyMemory);paused=0
  end
  return
 end
 if emu.read(0xc100,emu.memType.gameboyMemory)==6 then
  ended=ended+1
  if ended==240 then
   save_ppm('text-end.ppm')
   if os.getenv('TEXT_DEBUG') then
    local t={}
    for _,n in ipairs({'_dirty','_overlay_dirty','_raster_valid'}) do
     local v={};for i=0,31 do v[#v+1]=emu.read(symbols[n]+i,emu.memType.snesWorkRam)end;t[#t+1]=n..' '..table.concat(v,',')
    end
    local rows=word('_rows');local v={};for i=0,10 do v[#v+1]=emu.read(rows+21*133+i,emu.memType.snesWorkRam)end;t[#t+1]='row21 '..table.concat(v,',')
    for _,a in ipairs({0x3800,0x3840,0x9C00,0x9C40,0xF000+14*64,0xF000+13*64,0xE800+14*64}) do local v={};for i=0,31 do v[#v+1]=string.format('%02x',emu.read(a+i,emu.memType.snesVideoRam))end;t[#t+1]=string.format('vram %04x ',a)..table.concat(v,' ') end
    result:write(table.concat(t,'\n')..'\nlate DMA:\n'..table.concat(late,'\n')..'\n')
   end
   finish(word('_bad_pages')<8,string.format('replayed %d pages, %d bad, text mode %d at the end',word('_good_pages'),word('_bad_pages'),byte('_text_mode')))
  end
 elseif frame>90000 then finish(false,'replay timeout: '..word('_good_pages')..' pages')
 end
end,emu.eventType.endFrame)
