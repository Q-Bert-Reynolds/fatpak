INCLUDE "src/keyboard/kb_jump_table.asm"
INCLUDE "src/keyboard/ps2_ascii_keymaps.asm"
INCLUDE "src/keyboard/ps2_handlers.asm"
PS2Process::
  ld a, [kb_mode]
  and a
  ret z;exit early if KB_MODE_NONE
  ld a, [kb_type]
  cp a, KB_TYPE_PS2
  ret nz;no keyboard
  call ProcessPS2KeyCodes
  jp KBRepeatHeldKey

ProcessPS2KeyCodes:
  ld a, [kb_buffer_write]
  ld b, a;b = write index
  ld a, [kb_buffer_read]
  ld d, 0
  ld e, a;de = read index
  cp a, b
  ret z;if read == write, done

.loop
    ld hl, kb_error_buffer
    add hl, de;[hl] = current error
    ld a, [hl];error code
    and a;check for errors
    jr nz, .incrementReadIndex;if errors found, don't process keycode

  .processKeyCode
    ld hl, kb_scan_code_buffer
    add hl, de;[hl] = current scan code
    ld a, [hli];scan code
    push de;store read index
    push bc;store write index
    call PS2HandleKeycode
    pop bc;restore write index
    pop de;restore read index

  .incrementReadIndex
    ld a, e
    inc a
    and a, KB_SCAN_CODE_COUNT-1
    ld e, a;de = read index
    ld [kb_buffer_read], a

  .checkDone
    cp a, b;if read == write, done
    jp nz, .loop
  ret