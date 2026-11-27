-- tests/sgb/attr.asm's screen: every cell (x + y) & 3 once the 9 packets are in; then the rows a frame apart, reported
local result = assert(io.open('result.txt', 'w'))
local frame, seen1, seen2, finished = 0, nil, nil, false
local function finish(ok, message)
 if finished then return end
 finished = true
 result:write((ok and 'PASS: ' or 'FAIL: ') .. message .. '\n')
 result:close()
 emu.stop(ok and 0 or 1)
end
local names = {[0]='red', 'green', 'blue', 'white'}
local function cell(cx, cy)
 local pixels, size = emu.getScreenBuffer(), emu.getScreenSize()
 local scale = size.height // 239
 local x, y = (48 + cx * 8 + 4) * scale, (7 + 40 + cy * 8 + 4) * scale
 local p = pixels[y * size.width + x + 1]
 local r, g, b = (p >> 16) & 255, (p >> 8) & 255, p & 255
 if r > 200 and g > 200 and b > 200 then return 3 end
 if r > 200 and g < 60 and b < 60 then return 0 end
 if g > 200 and r < 60 and b < 60 then return 1 end
 if b > 200 and r < 60 and g < 60 then return 2 end
 return string.format('%02X%02X%02X', r, g, b)
end
emu.addEventCallback(function(cpu)
 if cpu ~= emu.cpuType.snes or finished then return end
 frame = frame + 1
 local phase = emu.read(0xc100, emu.memType.gameboyMemory)
 if (phase == 0xa1 or phase == 0xa2) and not seen1 then seen1 = frame end
 if phase == 0xa2 and not seen2 then seen2 = frame end
 if frame > 4000 then finish(false, 'timeout, phase ' .. phase) end
 if seen1 and not seen2 and frame == seen1 + 20 then
  local bad = 0
  for cy = 0, 17 do for cx = 0, 19 do
   local want, got = (cx + cy) % 4, cell(cx, cy)
   if got ~= want then
    bad = bad + 1
    if bad < 6 then result:write(string.format('cell %d,%d: %s want %s', cx, cy, tostring(got), names[want]) .. '\n') end
   end
  end end
  if bad > 0 then finish(false, '9 single-packet ATTR_CHRs: ' .. bad .. ' cells wrong') end
 end
 if seen2 and frame == seen2 + 20 then
  local bad = 0
  for cx = 0, 19 do
   if cell(cx, 0) ~= 3 then bad = bad + 1 end
   if cell(cx, 1) ~= 0 then bad = bad + 1 end
  end
  finish(true, 'the whole screen at the OS\'s pace; two commands a frame apart (not relied on): ' .. bad .. ' cells wrong')
 end
end, emu.eventType.endFrame)
