; Manufacturer v1.0 sends HID+93, or HID+61 with Shift. Letter bytes
; already are ASCII. Some shifted non-letter keys collide with letters in
; that firmware; do not guess at those ambiguous bytes.
IGKBHandleCode::
  cp 123
  jp c, KBHandleCharacter
  sub 123
  cp IGKBKeyMapEnd-IGKBKeyMap
  ret nc
  ld c, a
  ld b, 0
  ld hl, IGKBKeyMap
  add hl, bc
  ld a, [hl]
  and a
  ret z
  jp KBHandleEditorKey
IGKBKeyMap:
  DB "1234567890"
  DB KEY_ENTER, KEY_ESCAPE, KEY_BACKSPACE, KEY_TAB, ' ', '-', '=', '[', ']', 92, '#', ';', 39, '`', ',', '.', '/', 0
  DB KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7, KEY_F8, KEY_F9, KEY_F10, KEY_F11, KEY_F12
  DB 0, 0, 0, KEY_INSERT, KEY_HOME, KEY_PAGE_UP, KEY_DELETE, KEY_END, KEY_PAGE_DOWN
  DB KEY_RIGHT, KEY_LEFT, KEY_DOWN, KEY_UP, 0, '/', '*', '-', '+', KEY_ENTER
  DB "1234567890."
IGKBKeyMapEnd:
