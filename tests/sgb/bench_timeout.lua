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
 if frame-done<60 then return end
 if suppressed==0 or gb(0xc130)~=stage or gb(0xc143)~=0 then
  finish(false,fault..' timeout state or raw flags incorrect');return
 end
 -- Both the stage and raw flags must reach the SNES diagnostic, too.
 local function tile(word) return emu.read(2*word,emu.memType.snesVideoRam) end
 if tile(0x1076)~=37 or tile(0x1077)~=16+stage%16 or tile(0x1257)~=16 then
  finish(false,fault..' timeout diagnostic did not reach the TV');return
 end
 local scan={15,0xa5,14,gb(0xc132),13,gb(0xc133),12,0}
 for i=1,#scan do
  if gb(0xc147+i)~=scan[i] then
   finish(false,'slow slot scan ID/byte mismatch at '..i);return
  end
 end
 for slot=0,3 do
  local id,value=scan[2*slot+1],scan[2*slot+2]
  local word=0x12d4+slot*32
  local digits={math.floor(id/16),id%16,math.floor(value/16),value%16}
  for i=1,4 do
   local digit=digits[i]
   local expected=digit<10 and 16+digit or 23+digit
   if tile(word+i-1)~=expected then
    finish(false,'slow slot scan did not reach the TV');return
   end
  end
 end
 finish(true,fault..' suppressed: visible stage '..string.format('%02X',stage)..', raw flags 00, sender stopped within 120 GB frames')
end,emu.eventType.endFrame)
