local result=assert(io.open('result.txt','w'))
local frame, done=0,nil
local finished=false
local function gb(a) return emu.read(a,emu.memType.gameboyMemory) end
local function sw(a) return emu.read(a,emu.memType.snesWorkRam) end
local function word(read,a) return read(a)+256*read(a+1) end
local dropAck=os.getenv('SGB_BENCH_DROP_ACK')=='1'
local dropped=false
local p1Writes,busyWrites=0,0
local function activeReply()
 local stage=gb(0xc130)
 return gb(0xc100)>=5 and stage>=1 and stage<=4
end
emu.addMemoryCallback(function(a,v)
 if v==0xa5 and activeReply() then p1Writes=p1Writes+1 end
end,emu.callbackType.write,0x6004,0x6004,emu.cpuType.snes)
emu.addMemoryCallback(function(a,v)
 if v>=0x80 and activeReply() then busyWrites=busyWrites+1 end
end,emu.callbackType.write,0x6005,0x6005,emu.cpuType.snes)
if dropAck then
 emu.addMemoryCallback(function(a,v)
  if v==1 and not dropped and activeReply() then dropped=true;return 0 end
 end,emu.callbackType.write,0x6007,0x6007,emu.cpuType.snes)
end
local function finish(ok,message)
 if finished then return end
 finished=true
 result:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');result:close()
 local image=assert(io.open('bench.png','wb'));image:write(emu.takeScreenshot());image:close()
 emu.stop(ok and 0 or 1)
end
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or finished then return end
 frame=frame+1
 if gb(0xc100)==6 and not done then done=frame end
 if gb(0xc100)==0xe1 then finish(false,'mailbox timeout stage='..gb(0xc130)..' tx='..gb(0xc132)..' rx='..gb(0xc134)..' flags='..gb(0xc135));return end
 if not done then
  if frame>1800 then finish(false,'bench timeout phase='..gb(0xc100)..' stage='..gb(0xc130)..' tx='..gb(0xc132)..' rx='..gb(0xc134)..' flags='..gb(0xc135)..' good='..word(sw,0x1002)..' bad='..word(sw,0x1004)) end
  return
 end
 if frame-done<150 then return end
 local good,bad,miss=word(sw,0x1002),word(sw,0x1004),word(sw,0x1006)
 local total=word(gb,0xc114)+65536*word(gb,0xc116)
 local active,peak=word(gb,0xc11a),word(gb,0xc118)
 local rtt=word(gb,0xc11e)
 -- The diagnostic shown on hardware must also reach DONE, not just the GB.
 if emu.read(2*0x1077,emu.memType.snesVideoRam)~=20 then
  finish(false,'SNES diagnostic did not display stage 4');return
 end
 -- Verify the final mailbox diagnostics, including the raw rejected-read view.
 local function shown(address,expected)
  for i=1,#expected do
   if emu.read(2*(address+i-1),emu.memType.snesVideoRam)~=string.byte(expected,i)-32 then return false end
  end
  return true
 end
 if not shown(0x11f4,'4242') or not shown(0x1214,'0001') or
    not shown(0x1234,'4242') or not shown(0x1254,'0001') or
    not shown(0x1274,'4201') then
  finish(false,'SNES mailbox diagnostics incorrect');return
 end
 local metrics=string.format('{"good":%d,"bad":%d,"missed_rows":%d,"gb_frames":%d,"bytes":%d,"active_frames":%d,"peak_bytes_per_frame":%d,"rtt_max_frames":%d}',good,bad,miss,word(gb,0xc110),total,active,peak,rtt)
 local out=assert(io.open('metrics.json','w'));out:write(metrics..'\n');out:close()
 if word(gb,0xc136)~=34 or word(gb,0xc138)~=1 or gb(0xc132)~=66 or gb(0xc134)~=66 or gb(0xc135)~=1 then finish(false,'ACK/NACK flow control '..metrics);return end
 if good<34 or bad<1 or miss~=0 or word(sw,0x1026)~=0 then finish(false,'capture/checksum counters '..metrics);return end
 if total~=67*1921 or active==0 or peak<500 or peak>1921 or rtt>20 then finish(false,'writer or round-trip accounting '..metrics);return end
 if dropAck and not dropped then finish(false,'first ACK suppression did not run');return end
 if word(sw,0x102d)==0 then finish(false,'ACK writer did not execute');return end
 if busyWrites<34 or p1Writes<busyWrites then finish(false,'ACK publication omitted slot 1');return end
 finish(true,'LCD pages, deliberate checksum rejection/retry, stress, final ACK; '..metrics)
end,emu.eventType.endFrame)
