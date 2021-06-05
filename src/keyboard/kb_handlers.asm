;KBHandleCharacter
;KBHandleArrowKey
;KBHandleTab
;KBHandleEnter
;KBHandleBackspace
;KBHandleDelete
;KBHandleFunctionKey
;KBHandleEscape

KBHandleCharacter::;a = character in ASCII
  jp DrawCharacter

  ld hl, str_buffer
  ld [hli], a
  xor a
  ld [hld], a
  ld bc, 1
  ld de, 0
  ld a, DRAW_FLAGS_BKG
  call DrawText
  ret

KBHandleArrowKey::;a = DPad key
  ld b, a
  ld a, [button_state]
  or a, b
  ld [button_state], a
  ret

KBHandleTab::
  ld c, 4
.loop
    push bc
    ld a, " "
    call DrawCharacter
    pop bc
    dec c
    jr nz, .loop
  ret

KBHandleEnter::
  xor a
  ld [_x], a
  ld a, [_y]
  inc a
  cp a, 18
  jr c, .setY
.wrapY
  xor a
.setY
  ld [_y], a
  ret

KBHandleBackspace::
  ld a, -1
  jp RemoveCharacter
  ret

KBHandleDelete::
  ld a, 1
  jp RemoveCharacter
  ret

KBHandleFunctionKey::;a = function key
  ret

KBHandleEscape::
  ret