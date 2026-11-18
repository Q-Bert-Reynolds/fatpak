-- Capture the actual SNES PPU after each recorded frontend checkpoint.
local shots=dofile('shots.lua')
local symbols=dofile('kernel-symbols.lua')
local frame,at,stable=0,0,0
local function save(name)
 local pixels,size=emu.getScreenBuffer(),emu.getScreenSize()
 local scale=size.height//239
 assert(scale>=1,'unexpected SNES screen size')
 local f=assert(io.open(name..'.ppm','wb'));f:write('P6\n256 224\n255\n')
 for y=0,223 do for x=0,255 do
  local p=pixels[(y+7)*scale*size.width+x*scale+1]
  f:write(string.char((p>>16)&255,(p>>8)&255,p&255))
 end end
 f:close()
end
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes then return end
 frame=frame+1
 local page=emu.read(0xc111,emu.memType.gameboyMemory)
 local dirty=emu.read(symbols._scroll_pending,emu.memType.snesWorkRam)~=0
 for i=0,27 do
  if emu.read(symbols._dirty+i,emu.memType.snesWorkRam)~=0 or
     emu.read(symbols._overlay_dirty+i,emu.memType.snesWorkRam)~=0 then dirty=true end
 end
 if page~=at or dirty then at=page;stable=0 else stable=stable+1 end
 if shots[page] and emu.read(0xc117,emu.memType.gameboyMemory)==1 and stable>=3 then
  for _,name in ipairs(shots[page]) do save(name) end
  shots[page]=nil
  emu.write(0xc117,0,emu.memType.gameboyMemory)
  if next(shots)==nil then emu.stop(0) end
 end
 if frame>10000 then error('SGB screenshot replay timed out at page '..page) end
end,emu.eventType.endFrame)
