-- Real BIOS DATA_TRN/JUMP: no injected code, registers, replies or pixels.
local result = assert(io.open('result.txt', 'w'))
local fixture = assert(io.open('hello.bin', 'rb'))
local expected = fixture:read('*a'); fixture:close()
local frame, entered, finished = 0, nil, false
local function finish(ok, message)
 if finished then return end
 finished = true
 result:write((ok and 'PASS: ' or 'FAIL: ') .. message .. '\n')
 result:close()
 emu.stop(ok and 0 or 1)
end
emu.addMemoryCallback(function()
 if not entered then entered = frame end
end, emu.callbackType.exec, 0x7f0000, 0x7f0000, emu.cpuType.snes)
emu.addEventCallback(function(cpu)
 if cpu ~= emu.cpuType.snes or finished then return end
 frame = frame + 1
 if not entered then
  if frame > 900 then
   finish(false, 'JUMP did not reach $7F0000; GB phase=' ..
       emu.read(0xc100, emu.memType.gameboyMemory))
  end
  return
 end
 if frame - entered < 10 then return end
 for i = 1, #expected do
  local actual = emu.read(0x10000 + i - 1, emu.memType.snesWorkRam)
  if actual ~= expected:byte(i) then
   finish(false, string.format('DATA_TRN mismatch at $7F%04X: %02X != %02X',
       i - 1, actual, expected:byte(i))); return
  end
 end
 if emu.read(0xc100, emu.memType.gameboyMemory) ~= 5 or
     emu.read(0xc101, emu.memType.gameboyMemory) ~= 0xa5 then
  finish(false, 'GB did not receive the SNES $A5 reply'); return
 end
 if emu.read(0, emu.memType.snesCgRam) ~= 0xe0 or
     emu.read(1, emu.memType.snesCgRam) ~= 3 then
  finish(false, 'SNES backdrop is not BGR555 $03E0'); return
 end
 local pixels, size = emu.getScreenBuffer(), emu.getScreenSize()
 -- Mesen centers the 224 visible lines at line 7 of a 239-line buffer;
 -- high-resolution output doubles both axes. Its VBlank padding is black.
 local scale = size.height // 239
 if #pixels ~= size.width * size.height or (scale ~= 1 and scale ~= 2) or
     size.height ~= 239 * scale or size.width ~= 256 * scale then
  finish(false, 'unexpected SNES output dimensions'); return
 end
 for y = 7 * scale, 231 * scale - 1 do
  for x = 0, size.width - 1 do
   local pixel = pixels[y * size.width + x + 1]
   local r, g, b = (pixel >> 16) & 255, (pixel >> 8) & 255, pixel & 255
   if r ~= 0 or g < 240 or b ~= 0 then
    finish(false, string.format('output pixel (%d,%d) is not green: %08X', x, y, pixel)); return
   end
  end
 end
 local image = assert(io.open('hello.png', 'wb'))
 image:write(emu.takeScreenshot()); image:close()
 finish(true, '4096-byte DATA_TRN, $7F0000 JUMP, GB mailbox reply, fullscreen green')
end, emu.eventType.endFrame)
