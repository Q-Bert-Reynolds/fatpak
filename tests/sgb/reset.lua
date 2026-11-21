-- reset.s: a JUMP program that leaves by soft-resetting the BIOS. When the reset code runs, everything a
-- fullscreen kernel owns is overwritten (WRAM outside the BIOS's stack page, VRAM, CGRAM, OAM). Passes when
-- the BIOS boots the GB again and processes its second DATA_TRN + JUMP (the SPC driver upload, the GB
-- reset/handshake and the BIOS's command loop all survived), with its border back on screen.
local out=assert(io.open('result.txt','w'))
local frame,entries,reset,finished=0,{},nil,false
local W=emu.memType.snesWorkRam
local icd={}
for _,bank in ipairs({0,0x800000}) do
 emu.addMemoryCallback(function(a,v) if #icd<20 then icd[#icd+1]=string.format('f%d=%02X',frame,v) end end,emu.callbackType.write,bank+0x6003,bank+0x6003,emu.cpuType.snes,emu.memType.snesMemory)
end
local function gb(a) return emu.read(a,emu.memType.gameboyMemory) end
local function finish(ok,message)
 if finished then return end
 finished=true
 out:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');out:close()
 emu.stop(ok and 0 or 1)
end
local function shot(name)
 local image=assert(io.open(name,'wb'));image:write(emu.takeScreenshot());image:close()
end
emu.addMemoryCallback(function()
 entries[#entries+1]=frame
 if #entries==2 then
  finish(true,string.format('soft reset at frame %d; the GB booted again and the BIOS ran JUMP again at frame %d (first at %d)',reset,frame,entries[1]))
 end
end,emu.callbackType.exec,0x7f0000,0x7f0000,emu.cpuType.snes)
emu.addMemoryCallback(function()
 if #entries~=1 or reset then return end
 reset=frame
 local fill=os.getenv('RESET_FILL')
 if fill~='none' then
  for i=0,0x1FFFF do
   if i<0x0F00 or i>=0x1000 then emu.write(i,fill=='zero' and 0 or (i*37+0x5A)&255,W) end
  end
 end
 for i=0,0xFFFF do emu.write(i,0xA5,emu.memType.snesVideoRam) end
 for i=0,511 do emu.write(i,0xA5,emu.memType.snesCgRam) end
 for i=0,543 do emu.write(i,0xA5,emu.memType.snesSpriteRam) end
end,emu.callbackType.exec,0x8104,0x8104,emu.cpuType.snes)
emu.addEventCallback(function(c)
 if c~=emu.cpuType.snes or finished then return end
 frame=frame+1
 if reset and frame==reset+300 then shot('reset.png') end
 if frame>(reset or 1100)+1500 then
  local st=emu.getState()
  finish(false,string.format('no second JUMP after the soft reset; GB phase=%d SNES PC=%02X:%04X SPC PC=%04X GB PC=%04X APU ports %02X %02X boot ROM %s ICD2 6003 writes %s',gb(0xc100),st['cpu.k'],st['cpu.pc'],st['spc.pc'] or -1,st['cart.gameboy.cpu.pc'] or -1,emu.read(0x2140,emu.memType.snesMemory),emu.read(0x2141,emu.memType.snesMemory),tostring(st['cart.gameboy.memoryManager.disableBootRom']),table.concat(icd,' ')))
 end
 if not reset and frame>1500 then finish(false,'the program never reset the BIOS') end
end,emu.eventType.endFrame)
