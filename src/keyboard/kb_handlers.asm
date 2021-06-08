;KBHandleCharacter
;KBHandleArrowKey
;KBHandleTab
;KBHandleEnter
;KBHandleBackspace
;KBHandleDelete
;KBHandleFunctionKey
;KBHandleEscape

KBHandleCharacter::;a = character in ASCII
  ld b, a
  ld a, [kb_mode]
  cp a, KB_MODE_TYPING
  ret nz

  ld a, b;ASCII

  ret

KBHandleArrowKey::;a = DPad key
  ld b, a
  ld a, [button_state]
  or a, b
  ld [button_state], a
  ret

KBHandleTab::
  ld b, a
  ld a, [kb_mode]
  cp a, KB_MODE_TYPING
  ret nz

  ld a, [button_state]
  or a, PADF_SELECT
  ld [button_state], a
  ret

KBHandleEnter::
  ld a, [kb_mode]
  cp a, KB_MODE_BUTTONS
  ret nz
  ld a, [button_state]
  or a, PADF_START
  ld [button_state], a
  ret

KBHandleBackspace::
  ld b, a
  ld a, [kb_mode]
  cp a, KB_MODE_TYPING
  ret nz

  ret

KBHandleDelete::
  ld b, a
  ld a, [kb_mode]
  cp a, KB_MODE_TYPING
  ret nz

  ret

KBHandleFunctionKey::;a = function key
  ;TODO: jump between scenes
  ret

KBHandleEscape::
  ld b, a
  ld a, [kb_mode]
  cp a, KB_MODE_BUTTONS
  ret nz
  ld a, [button_state]
  or a, PADF_B
  ld [button_state], a
  ret