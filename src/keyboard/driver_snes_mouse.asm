IF !DEF(SYS_INFO_SGBFS)
DEF SYS_INFO_SGBFS EQU %00000100 ; (src/gbdk.asm's: fullscreen terminal active)
ENDC
DEF SNES_MOUSE_DRIVER EQU 1 ; (driver_mouse.asm without the iGKB packet parser)
; The SGB's driver: a PS/2 keyboard (PS2KeyboardInterrupt takes its bytes under KB_TYPE_SNES_MOUSE too) and the
; SNES mouse in port 2. The mouse: four SGB input bytes, BIOS pad 1, commit/buttons, absolute X, absolute Y.
; Read commit twice around the coordinates, and always leave pad 1 selected.
INCLUDE "src/keyboard/ps2_keys.asm"
SNESMouseProcess:
  ld a, [kb_type]
  cp KB_TYPE_SNES_MOUSE
  ret nz
  ld a, [kb_mode]
  and a
  jr z, .mouse ; (KB_MODE_NONE: no keys)
  call ProcessPS2KeyCodes
  call KBRepeatHeldKey
.mouse
  ld a, [igkb_ready]
  and a
  jr nz, .frame
  inc a
  ld [igkb_ready], a
  xor a
  ld [igkb_timeout], a
  ld [igkb_double], a
  ld [igkb_nav], a
  ld [igkb_action], a
  ld [igkb_packet], a
.frame
  call IGKBMouseFrame
  ldh a, [sys_info]
  and SYS_INFO_SGBFS
  jr z, .bridge
  ; fullscreen: the kernel's events (fs_mouse, src/sgb/display.asm); P1 is the mailbox's, no bridge to ACK
  ld hl, fs_mouse
  ld a, [hli]
  ld b, a
  ld e, a
  ld a, [hli]
  ld c, a
  ld d, [hl]
  ld a, b
  ld hl, igkb_packet
  cp [hl]
  ret z
  ld [hl], a
  and a
  ret z ; (none yet)
  jr .report
.bridge
  call SNESMouseRead
  ld a, b
  cp e
  ret nz
  bit 7, a
  ret nz
  ld hl, igkb_packet
  cp [hl]
  ret z
  ld [hl], a
  call .ack
.report
  bit 0, b
  jr z, .absent
  ld a, b
  srl a
  and 3
  ld [igkb_flags], a
  ldh a, [sys_info]
  and SYS_INFO_SGBFS
  jr nz, .place ; (fullscreen: the SNES's 256x224, already within it)
  ld a, c
  cp 160
  ret nc
  ld a, d
  cp 144
  ret nc
.place
  ld a, c
  ld [_mouse_x], a
  ld a, d
  ld [_mouse_y], a
  jp IGKBMouseReport
.absent
  xor a
  ld [_mouse_buttons], a
  ld [oam_buffer+8], a
  ret

.ack
  push bc
  push de
  call SGBInputBegin
  push af
  ld hl, SNESMouseAck
  call SGBPacketAck;(not within 2 frames of an SGB attribute packet)
  call SNESMouseSelectOne
  pop af
  pop de
  pop bc
  jp SGBInputEnd
SNESMouseAck:
  DB $79, $f0, $1f, 0, 1, 1
  DS 10
INCLUDE "src/sgb/mouse_input.asm"

INCLUDE "src/keyboard/driver_mouse.asm"
INCLUDE "src/keyboard/driver_ps2.asm"
