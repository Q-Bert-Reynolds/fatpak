local result=assert(io.open('result.txt','w'))
local fixture=assert(io.open('kernel.bin','rb'));local expected=fixture:read('*a');fixture:close()
local frame,entered,finished=0,nil,false
local stable=0
local baseline,baseline_drawn,closed_saved=nil,nil,false
local keyboard_closed_saved=false
local sent_at,last_good,max_ack,last_sent=nil,0,0,0
local function finish(ok,message)
 if finished then return end;finished=true
 result:write((ok and 'PASS: ' or 'FAIL: ')..message..'\n');result:close()
 local image=assert(io.open('kernel.png','wb'));image:write(emu.takeScreenshot());image:close()
 emu.stop(ok and 0 or 1)
end
emu.addMemoryCallback(function()if not entered then entered=frame end end,emu.callbackType.exec,0x7f0000,0x7f0000,emu.cpuType.snes)


local symbols=dofile('kernel-symbols.lua')
-- the kernel's C side starts after BiosSave (bios.s) has parked the BIOS's state in ARAM
local main_frame
emu.addMemoryCallback(function()
 if not main_frame then main_frame=frame;result:write('BIOS saved in '..(frame-entered)..' SNES frames\n');result:flush() end
end,emu.callbackType.exec,0x7f0000+symbols['_main'],0x7f0000+symbols['_main'],emu.cpuType.snes)
if os.getenv('SGB_KERNEL_PROFILE')=='1' then
 local function measure(name,done)
  local start,count,total,peak=nil,0,0,0
  emu.addMemoryCallback(function()start=frame end,emu.callbackType.exec,0x7f0000+symbols[name],0x7f0000+symbols[name],emu.cpuType.snes)
  emu.addMemoryCallback(function()
   if start then
    local elapsed=frame-start;count=count+1;total=total+elapsed;peak=math.max(peak,elapsed);start=nil
    result:write(string.format('PROFILE %s count %d total %d peak %d SNES frames\n',name,count,total,peak));result:flush()
   end
  end,emu.callbackType.exec,0x7f0000+symbols[done],0x7f0000+symbols[done],emu.cpuType.snes)
 end
 measure('_draw','_PresentRow');measure('_draw_ui','_PresentOverlay')
 measure('_PresentRow','_SharedPrepared')
end
local shared_verified,shared_started=0,false
if os.getenv('SGB_SHARED_CHECK')=='1' then
 emu.addMemoryCallback(function()shared_started=true end,emu.callbackType.exec,0x7f0000+symbols._SharedChecks,0x7f0000+symbols._SharedChecks,emu.cpuType.snes)
 emu.addMemoryCallback(function()
  local function ram(at)return emu.read(at,emu.memType.snesWorkRam)end
  if ram(symbols._shared_finished)==1 then return end
  local function word(at)return ram(at)+ram(at+1)*256 end
  local counts={}
  for i=0,1023 do
   local tile=word(0xa800+i*2)
   if tile>=1024 then finish(false,'shared map tile out of range');return end
   counts[tile]=(counts[tile] or 0)+1
   local at=0xe000+i*2
   local actual=emu.read(at,emu.memType.snesVideoRam)+emu.read(at+1,emu.memType.snesVideoRam)*256
   if actual~=tile then finish(false,string.format('shared WRAM/VRAM map case %d at %d: %04X != %04X (row %d source %04X)',word(symbols._shared_cases),i,actual,tile,word(0xb504),word(0xb502)));return end
  end
  for tile=0,1023 do
   if word(0xa000+tile*2)~=(counts[tile] or 0) then finish(false,'shared reference mismatch for tile '..tile);return end
  end
  local row=word(0xb504)
  local expected_base=ram(symbols._shared_compare_expected)==1 and symbols._shared_expected or symbols._raster
  for column=0,31 do
   local tile=word(0xa800+row+column*2)
   for offset=0,31 do
    local actual=emu.read(tile*32+offset,emu.memType.snesVideoRam)
    local expected=ram(expected_base+column*32+offset)
    if actual~=expected then
     finish(false,string.format('shared tile pixels case %d col %d byte %d: %02X != %02X',word(symbols._shared_cases),column,offset,actual,expected));return
    end
   end
  end
  shared_verified=shared_verified+1
 end,emu.callbackType.exec,0x7f0000+symbols._SharedCommitted,0x7f0000+symbols._SharedCommitted,emu.cpuType.snes)
end
local drop_commit=os.getenv('SGB_KERNEL_DROP_COMMIT')=='1'
local stall_mailbox=os.getenv('SGB_KERNEL_STALL')=='1'
local dropped_seq,dropped_at,recovered=nil,nil,false
local diagnostic_frames=0
local dismiss_at,disabled_at=nil,nil
local show_requested,shown_at=nil,nil
local stall_first_seq,stall_again=nil,nil
local clock_start=nil
if stall_mailbox then
 emu.addEventCallback(function()
  local held=(show_requested~=nil and shown_at==nil) or (dismiss_at~=nil and disabled_at==nil)
  emu.setInput({l=held,r=held,select=held},0,0)
 end,emu.eventType.inputPolled)
end
if stall_mailbox then
 emu.addMemoryCallback(function(a,v)
  if v>0 and v<128 and emu.read(symbols._mailbox+1,emu.memType.snesWorkRam)==6 then
   if disabled_at and v==stall_first_seq then return end
   if not stall_first_seq then stall_first_seq=v
   elseif disabled_at and v~=stall_first_seq and not stall_again then stall_again=frame end
   if not dropped_at then dropped_at=frame end
   if not show_requested then show_requested=frame end
   return 0
  end
 end,emu.callbackType.write,0x6004,0x6004,emu.cpuType.snes)
end
if drop_commit then
 emu.addMemoryCallback(function(a,v)
  if not dropped_seq and v>0 and v<128 and
     emu.read(symbols._mailbox+1,emu.memType.snesWorkRam)==6 then
   dropped_seq=v;dropped_at=frame;return 0
  end
 end,emu.callbackType.write,0x6004,0x6004,emu.cpuType.snes)
end
local ui_test=symbols._test_pages>102
local function byte(name)return emu.read(symbols[name],emu.memType.snesWorkRam)end
local function word(name)return byte(name)+emu.read(symbols[name]+1,emu.memType.snesWorkRam)*256 end
emu.addMemoryCallback(function(a,v)
 if v>0 and v<128 and emu.read(symbols._mailbox+1,emu.memType.snesWorkRam)>=32 then
  if byte('_screen_received')==0 or word('_drawn_rows')<28 then
   finish(false,'diagnostic telemetry occupied the startup mailbox')
  end
 end
end,emu.callbackType.write,0x6004,0x6004,emu.cpuType.snes)
local function vram()
 local b={};for i=0,32767 do b[i+1]=string.char(emu.read(i,emu.memType.snesVideoRam))end;return table.concat(b)
end
local function save_ppm(name)
 local pixels,size=emu.getScreenBuffer(),emu.getScreenSize();local scale=size.height//239
 local ppm=assert(io.open(name,'wb'));ppm:write('P6\n256 224\n255\n')
 for y=0,223 do for x=0,255 do local p=pixels[(y+7)*scale*size.width+x*scale+1];ppm:write(string.char((p>>16)&255,(p>>8)&255,p&255))end end;ppm:close()
end
emu.addEventCallback(function(cpu)
 if cpu~=emu.cpuType.snes or finished then return end;frame=frame+1
 if not entered then
  if frame>3000 then finish(false,'JUMP timeout GB phase '..emu.read(0xc100,emu.memType.gameboyMemory)) end
  return
 end
 if dropped_seq then
  if emu.read(0xc112,emu.memType.gameboyMemory)==dropped_seq then recovered=true end
  if not recovered and frame-dropped_at>240 then
   finish(false,'held mailbox did not recover after dropped commit');return
  end
 end
 if frame==entered+10 then
  -- bios.s's state and self-modified operands change at JUMP (BiosSave), the rest of the image never does
  local mutable=function(a)
   return (a>=symbols['BiosFlag'] and a<symbols['BiosStateEnd']) or (a>symbols['IplRd'] and a<=symbols['IplRd']+3)
  end
  for i=1,#expected do
   local actual=emu.read(0x10000+i-1,emu.memType.snesWorkRam)
   if actual~=expected:byte(i) and not mutable(i-1) then finish(false,string.format('upload mismatch %04X: %02X != %02X',i-1,actual,expected:byte(i)));return end
  end
 end
 if main_frame and frame==main_frame+40 then clock_start=word('_hw_frames') end
 if main_frame and frame==main_frame+100 and clock_start then
  local elapsed=(word('_hw_frames')-clock_start)&65535
  if elapsed<59 or elapsed>61 then finish(false,'NMI timing clock drift: '..elapsed..' frames in 60');return end
 end
 if stall_mailbox and dropped_at then
  if byte('_debug_enabled')~=0 and not shown_at then shown_at=frame end
  if dismiss_at then
   if byte('_debug_enabled')==0 and not disabled_at then disabled_at=frame end
   if disabled_at and byte('_debug_enabled')~=0 then finish(false,'watchdog re-enabled dismissed diagnostics');return end
   if disabled_at and stall_again and frame-stall_again>=360 then
    finish(true,'L+R+Select hides diagnostics through the next stalled mailbox event');return
   end
   if frame-dismiss_at>1000 then finish(false,'diagnostic dismissal/new held event was not exercised');return end
   return
  end
  if byte('_debug_enabled')~=0 and emu.read(symbols._overlay_dirty+27,emu.memType.snesWorkRam)==0 then
   diagnostic_frames=diagnostic_frames+1
   if diagnostic_frames<3 then return end
   -- Every BG2 mask tile must cover the ordinary status bar; BG3 contains text.
   for i=0,31 do
    local at=0xf000+27*64+i*2
    if emu.read(at,emu.memType.snesVideoRam)~=65 or emu.read(at+1,emu.memType.snesVideoRam)~=60 then
     finish(false,'diagnostics do not cover the status bar');return
    end
   end
   local ink=false
   for i=0,511 do if emu.read(0x8000+27*512+i,emu.memType.snesVideoRam)~=0 then ink=true end end
   if not ink then finish(false,'diagnostic row has no glyphs');return end
   local pixels,size=emu.getScreenBuffer(),emu.getScreenSize();local scale=size.height//239
   local paper=pixels[(216+7)*scale*size.width+1];local visible=false
   for y=216,223 do for x=0,255 do
    if pixels[(y+7)*scale*size.width+x*scale+1]~=paper then visible=true end
   end end
   if not visible then finish(false,'diagnostic glyphs are not visible in PPU output');return end
   save_ppm('kernel-diagnostics.ppm')
   result:write('PASS: L+R+Select displays diagnostics above status bar\n');result:flush()
   dismiss_at=frame;return
  end
  if frame-dropped_at>600 then
   finish(false,string.format('stalled mailbox did not display diagnostics: tick %d enabled %d dirty %d',word('_tick'),byte('_debug_enabled'),emu.read(symbols._overlay_dirty+27,emu.memType.snesWorkRam)));return
  end
 end
 if os.getenv('SGB_PLAIN_ONLY')=='1' and byte('_plain_finished')~=0 then
  result:write(string.format('PLAIN %d checks, %d mismatches; first case %d offset %d actual %02X expected %02X\n',word('_plain_checks'),word('_plain_mismatches'),word('_plain_first_case'),word('_plain_first_offset'),byte('_plain_first_actual'),byte('_plain_first_expected')))
  result:write(string.format('PROPORTIONAL eight legacy rows %d vs direct %d SNES frames\n',word('_plain_legacy_frames'),word('_plain_direct_frames')))
  finish(word('_plain_checks')==256 and word('_plain_mismatches')==0,'plain tile checks');return
 end
 if os.getenv('SGB_SHARED_ONLY')=='1' and shared_started and byte('_shared_finished')==1 then
  result:write(string.format('SHARED %d PPU/map/reference checks, %d row-cache errors\n',shared_verified,word('_shared_cache_errors')))
  result:write(string.format('CODE sixteen legacy rows %d vs shared %d SNES frames; %d exact-key hits; %d reused blanks\n',word('_shared_legacy_frames'),word('_shared_upload_frames'),word('_shared_hint_hits'),byte('_shared_reused_blank')))
  finish(shared_verified==217 and word('_shared_cases')==217 and word('_shared_cache_errors')==0 and word('_shared_hint_hits')>0,'shared tiles: full pool, hash collisions, reuse, all fonts/styles and selection');return
 end
 if os.getenv('SGB_TILE_ONLY')=='1' and byte('_tile_finished')~=0 then
  result:write(string.format('TILES %d checks, %d mismatches; first case %d offset %d actual %02X expected %02X\n',word('_tile_checks'),word('_tile_mismatches'),word('_tile_first_case'),word('_tile_first_offset'),byte('_tile_first_actual'),byte('_tile_first_expected')))
  result:write(string.format('FRESH eight legacy rows %d vs tiles %d SNES frames; hits %d misses %d\n',word('_tile_legacy_frames'),word('_tile_cached_frames'),word('_fixed_hits'),word('_fixed_misses')))
  finish(word('_tile_checks')==144 and word('_tile_mismatches')==0,'fixed tile checks');return
 end
 if os.getenv('SGB_CACHE_ONLY')=='1' and byte('_cache_finished')~=0 then
  local failures={};for i=0,111 do if emu.read(symbols._cache_failures+i,emu.memType.snesWorkRam)~=0 then failures[#failures+1]=i end end
  result:write('Cache failures: '..table.concat(failures,',')..'\n')
  result:write(string.format('First diff: offset %d actual %02X cached %02X\n',word('_cache_first_offset'),byte('_cache_first_actual'),byte('_cache_first_expected')))
  result:write(string.format('SELECTION eight cold rows %d vs cached %d SNES frames\n',word('_cache_cold_frames'),word('_cache_warm_frames')))
  finish(word('_cache_checks')==112 and word('_cache_mismatches')==0,'cache checks '..word('_cache_checks')..' mismatches '..word('_cache_mismatches'));return
 end
 if frame%1000==0 then
  result:write(string.format('frame %d stage %d page %d good %d bad %d rows %d missed %d drawn %d queue %d\n',frame,emu.read(0xc100,emu.memType.gameboyMemory),emu.read(0xc111,emu.memType.gameboyMemory),word('_good_pages'),word('_bad_pages'),word('_capture_rows'),word('_capture_missed'),word('_drawn_rows'),byte('_qcount')));result:flush()
 end
 local sent=emu.read(0xc113,emu.memType.gameboyMemory)
 if sent~=last_sent then sent_at=frame;last_sent=sent end
 local good=word('_good_pages')
 if good~=last_good then
  if sent_at then max_ack=math.max(max_ack,frame-sent_at) end
  last_good=good
 end
 local dirty=false
 for i=0,27 do if emu.read(symbols['_dirty']+i,emu.memType.snesWorkRam)~=0 or emu.read(symbols['_overlay_dirty']+i,emu.memType.snesWorkRam)~=0 then dirty=true end end
 -- (the cursor and palette too: one presented in this VBlank shows only in the next frame's picture)
 if not dirty and byte('_scroll_pending')==0 and byte('_cursor_dirty')==0 and byte('_palette_dirty')==0 then stable=stable+1 else stable=0 end
 if ui_test and stable>=3 then
  if good==103 and not baseline then baseline=vram();baseline_drawn=word('_drawn_rows') end
  if good==106 and not closed_saved then save_ppm('kernel-closed.ppm');closed_saved=true end
  if good==108 and not keyboard_closed_saved then save_ppm('kernel-osk-closed.ppm');keyboard_closed_saved=true end
 end
 if emu.read(0xc100,emu.memType.gameboyMemory)==6 and stable>=3 then
  if symbols._glyph_checks then
   if word('_glyph_checks')~=74 or word('_glyph_mismatches')~=0 then
    local cases={};for i=0,73 do if emu.read(symbols._glyph_failures+i,emu.memType.snesWorkRam)~=0 then cases[#cases+1]=i end end
    result:write('Failing glyph cases: '..table.concat(cases,',')..'\n')
    finish(false,string.format('native glyph comparison: %d cases, %d mismatches',word('_glyph_checks'),word('_glyph_mismatches')));return
   end
   result:write('PASS: 74 native/C glyph comparisons: fonts, styles, clipping, icons, overlaps and clock alignment\n')
  end
  if symbols._cache_checks then
   if word('_cache_checks')~=112 or word('_cache_mismatches')~=0 then
    finish(false,string.format('raster cache comparison: %d cases, %d mismatches',word('_cache_checks'),word('_cache_mismatches')));return
   end
   result:write('PASS: 112 native cache/selection comparisons: all slots, shade classes and pixel alignments\n')
   result:write(string.format('SELECTION eight cold rows %d vs cached %d SNES frames\n',word('_cache_cold_frames'),word('_cache_warm_frames')))
  end
  result:write(string.format('PLAIN rows %d\n',word('_plain_rows')))
  result:write(string.format('TILES hits %d misses %d\n',word('_fixed_hits'),word('_fixed_misses')))
  result:write(string.format('CACHE hits %d misses %d\n',word('_raster_hits'),word('_raster_misses')))
  local function dword(name)return word(name)+emu.read(symbols[name]+2,emu.memType.snesWorkRam)*65536+emu.read(symbols[name]+3,emu.memType.snesWorkRam)*16777216 end
  result:write(string.format('SHARED hits %d misses %d key hits %d tile bytes %d map bytes %d\n',word('_shared_hits'),word('_shared_misses'),word('_shared_hint_hits'),dword('_shared_tile_bytes'),dword('_shared_map_bytes')))
  if drop_commit and (not dropped_seq or not recovered) then
   finish(false,'dropped-commit recovery was not exercised');return
  end
  if drop_commit then result:write('PASS: held mailbox recovered after a dropped ACK commit\n') end
  if ui_test then
   if not baseline or not closed_saved or not keyboard_closed_saved then finish(false,'UI checkpoints were not reached');return end
   if vram()~=baseline or word('_drawn_rows')~=baseline_drawn then finish(false,'overlay update redrew or changed BG1');return end
   result:write('PASS: menu open/highlight/close, OSK, bars, busy, progress and theme leave BG1 bytes and draw count unchanged\n')
  end
  save_ppm('kernel.ppm')
  result:write(string.format('TIMING peak frames: draw %d UI %d page %d mailbox %d; completion %d SNES frames\n',
   word('_perf_draw'),word('_perf_ui'),word('_perf_page'),word('_perf_mail'),frame-entered))
  if max_ack==0 or max_ack>120 then finish(false,'page ACK exceeded 120 frames: '..max_ack);return end
  finish(true,string.format('real kernel replay: %d pages, %d rows, %d missed; longest ACK %d SNES frames',word('_good_pages'),word('_drawn_rows'),word('_capture_missed'),max_ack))
 elseif frame>60000 then
  local state=emu.getState();local f=assert(io.open('kernel-state.txt','w'));for k,v in pairs(state)do f:write(tostring(k)..'='..tostring(v)..'\n')end;f:close()
  finish(false,'replay timeout')
 end
end,emu.eventType.endFrame)
