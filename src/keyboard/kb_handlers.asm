;KBHandleCharacter
;KBHandleArrowKey
;KBHandleTab
;KBHandleEnter
;KBHandleBackspace
;KBHandleDelete
;KBHandleFunctionKey
;KBHandleEscape

;simulates on screen keyboard actions
;_c = caps, _x,_y = char pos
UILowerCase: DB "abcdefghijklmnopqrstuvwxyz *():;[]#%-?!*+/.,"
UIUpperCase: DB "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
MACRO EDITOR_KEY ;\1 = key, jumps to KBHandleEditorKey in editor mode
  ld a, [kb_mode]
  cp a, KB_MODE_EDITOR
  ld a, \1
  jp z, KBHandleEditorKey
ENDM

KBHandleEditorKey::;a = key, queues key presses in editor mode
  ld b, a;key
  ld a, [kb_mode]
  cp a, KB_MODE_EDITOR
  ret nz
  ld a, [kb_flags]
  and a, KB_FLAG_RELEASE
  ret nz
  ld a, [kb_event_write]
  ld c, a;write index
  inc a
  and a, KB_EVENT_COUNT-1
  ld hl, kb_event_read
  cp a, [hl]
  ret z;queue full, drop key
  ld [kb_event_write], a
  ld h, 0
  ld l, c
  add hl, hl
  ld de, kb_event_buffer
  add hl, de
  ld [hl], b;key
  inc hl
  ld a, [kb_modifiers]
  ld [hl], a
  ret

KBHandleCharacter::;a = character in ASCII
  ld b, a;ASCII
  ld a, [kb_mode]
  cp a, KB_MODE_EDITOR
  jr nz, .notEditor
  ld a, b
  jp KBHandleEditorKey
.notEditor
  cp a, KB_MODE_BUTTONS
  jr z, .updateButtonState
  
  ld a, [kb_flags]
  and a, KB_FLAG_RELEASE
  ret nz;if release flag set, return early

  ld a, [kb_mode]
  cp a, KB_MODE_TYPING
  jr z, .findCharXY
  
IF KEYBOARD_TEST_ENABLED
  ld a, b
  jp nz, KBDemoDrawCharacter
ENDC

.updateButtonState
  ld a, b;ASCII
  ld b, PADF_A
  cp a, 'z'
  jp z, KBUpdateButtons
  ld b, PADF_B
  cp a, 'x'
  jp z, KBUpdateButtons
  ld b, 0
  jp KBUpdateButtons

.findCharXY;ASCII in b
  PUSH_VAR _c
  ld a, 1
  ld [_c], a;assume lowercase
  ld c, 0
  ld hl, UILowerCase
.lowerLoop
    ld a, [hli]
    cp a, b
    jr z, .charFound
    inc c
    ld a, 43
    cp a, c
    jr nc, .lowerLoop
  xor a
  ld [_c], a;upper case
  ld c, 0
  ld hl, UIUpperCase
.upperLoop
    ld a, [hli]
    cp a, b
    jr z, .charFound
    inc c
    ld a, 25
    cp a, c
    jr nc, .upperLoop
  POP_VAR _c
  ret

.charFound
  pop af;discard old _c
  ld h, c
  ld c, 9
  call math_Divide8;l (remainder a) = h / c
  ld [_x], a
  ld a, l
  ld [_y], a
  TRAMPOLINE DrawTextEntryBox
  ldh a, [button_state]
  or a, PADF_A
  ldh [button_state], a

  ret

KBHandleArrowKey::;a = dpad flags
  ld b, a
  ld a, [kb_mode]
  cp a, KB_MODE_EDITOR
  jr nz, .buttons
  ld a, b
  ld c, KEY_RIGHT
  cp a, PADF_RIGHT
  jr z, .key
  ld c, KEY_LEFT
  cp a, PADF_LEFT
  jr z, .key
  ld c, KEY_UP
  cp a, PADF_UP
  jr z, .key
  ld c, KEY_DOWN
.key
  ld a, c
  jp KBHandleEditorKey
.buttons
  ld a, [kb_flags]
  and a, KB_FLAG_RELEASE
  ld a, b
  jr z, KBUpdateButtons.press
.arrowReleased
  cpl a
  ld b, a
  ldh a, [kb_button_state]
  and a, b
  ldh [kb_button_state], a
  ret

KBHandleTab:: 
  EDITOR_KEY KEY_TAB
  ld b, PADF_SELECT
  jr KBUpdateButtons
KBHandleEnter:: 
  EDITOR_KEY KEY_ENTER
  ld b, PADF_START
  jr KBUpdateButtons
KBHandleEscape:: 
  EDITOR_KEY KEY_ESCAPE
  ld b, PADF_B
  ;fall through
KBUpdateButtons::;b = button flags
  ld a, [kb_flags]
  and a, KB_FLAG_RELEASE
;NOTE: Button released events can be lost when an interrupt is disabled.
;      To avoid stale button flags, key release events clear kb_button_state,
;      and press events set the button state to a single button.
  ld a, b 
  jr z, .press
.release
  xor a
.press
  ldh [kb_button_state], a
  ret

KBHandleBackspace::
  EDITOR_KEY KEY_BACKSPACE
IF KEYBOARD_TEST_ENABLED
  ld a, [kb_mode]
  cp a, KB_MODE_DEMO
  jr nz, .buttons
  ld a, [kb_flags]
  and a, KB_FLAG_RELEASE
  jp z, KBDemoRemoveCharacter
  ret
.buttons
ENDC
  ld b, PADF_B
  jr KBUpdateButtons

KBHandleDelete::
  EDITOR_KEY KEY_DELETE
  ret

KBHandleFunctionKey::;a = function key
  ;TODO: jump between scenes
  ret

