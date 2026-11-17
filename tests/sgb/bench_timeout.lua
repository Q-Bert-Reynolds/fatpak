-- Suppress a published ACK or NACK while leaving capture/validation running.
-- Exercise the GB's real P1 reader and verify a visible, bounded failure.
local fault=assert(os.getenv('SGB_BENCH_TIMEOUT'))
assert(fault=='ack' or fault=='nack')
local flag=fault=='ack' and 1 or 2
local stage=fault=='ack' and 0xe1 or 0xe2
local frame,done,suppressed=0,nil,0
local finished=false
local function gb(a) return emu.read(a,emu.memType.gameboyMemory) end
local function finish(ok,message)
 if finished then return end
 finished=true
 local out=assert(io.open('result.txt','w'))
 out:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');out:close()
 local image=assert(io.open('bench.png','wb'))
 image:write(emu.takeScreenshot());image:close()
 emu.stop(ok and 0 or 1)
end
emu.addMemoryCallback(function(a,v)
 if v==flag then suppressed=suppressed+1;return 0 end
end,emu.callbackType.write,0x6007,0x6007,emu.cpuType.snes)
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or finished then return end
 frame=frame+1
 if gb(0xc100)==0xe1 and not done then done=frame end
 if not done then
  if frame>1200 then finish(false,fault..' timeout did not stop the sender') end
  return
 end
 if frame-done<560 then return end
 if suppressed==0 or gb(0xc130)~=stage or gb(0xc143)~=0 then
  finish(false,fault..' timeout state or raw flags incorrect');return
 end
 -- Both the stage and raw flags must reach the SNES diagnostic, too.
 local function tile(word) return emu.read(2*word,emu.memType.snesVideoRam) end
 if tile(0x1076)~=37 or tile(0x1077)~=16+stage%16 or tile(0x1257)~=16 then
  finish(false,fault..' timeout diagnostic did not reach the TV');return
 end
 if emu.read(0x102b,emu.memType.snesWorkRam)~=0 then
  finish(false,'unexpected ACK data bank in reference BIOS');return
 end
 local writes=emu.read(0x102d,emu.memType.snesWorkRam)+256*emu.read(0x102e,emu.memType.snesWorkRam)
 if writes==0 then finish(false,'ACK writer did not execute');return end
 if gb(0xc164)~=6 then finish(false,'diagnostic matrix did not finish');return end
 local expected={
  {0xa5,0xc3,0x69,0x96},
  {0xa5,1,1,flag==1 and 0 or 1},
  {0xa5,gb(0xc132),gb(0xc133),0},
  {0xa5,gb(0xc132),gb(0xc133),0},
  {0xa5,0x3c,0x69,0x5a}
 }
 for row=1,5 do
  for byte=1,4 do
   local value=expected[row][byte]
   if gb(0xc150+(row-1)*4+byte-1)~=value then
    finish(false,'matrix readback mismatch at row '..row..' byte '..byte);return
   end
   local address=0x12d4+(row-1)*32+(byte-1)*2
   local digits={math.floor(value/16),value%16}
   for nibble=1,2 do
    local digit=digits[nibble]
    local glyph=digit<10 and 16+digit or 23+digit
    if tile(address+nibble-1)~=glyph then
     finish(false,'matrix snapshot did not reach the TV');return
    end
   end
  end
 end
 if tile(0x1377)~=22 then finish(false,'matrix completion did not reach the TV');return end
 finish(true,fault..' suppressed: visible stage '..string.format('%02X',stage)..', raw flags 00, sender stopped within 120 GB frames')
end,emu.eventType.endFrame)
