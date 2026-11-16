SetKeyboardMode::;a = mode
  ld b, a
  ld a, [kb_mode]
  cp a, b
  ret z
.clearFlags
  xor a
  ld [kb_flags], a
  ld [kb_button_state], a
  ld [kb_held_key], a
.setMode
  ld a, b
  ld [kb_mode], a
  ret

;queues the held arrow key again at the d-pad's rate (the keyboard's own repeats are dropped, see PS2HoldArrowKey)
KBRepeatHeldKey:
  ld a, [kb_held_key]
  and a
  ret z
  ld hl, kb_repeat_timer
  dec [hl]
  ret nz
  ld [hl], PAD_REPEAT_RATE
  push af
  call KBHandleArrowKey
  pop af
  ld [kb_held_key], a;queueing a key clears it
  ret

INCLUDE "src/keyboard/kb_handlers.asm"
