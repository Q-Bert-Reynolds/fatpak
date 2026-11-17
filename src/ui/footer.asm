FIXED "Footer dispatch"
_FooterTick:: BANKED_C _footer_Tick
_FooterPoll:: BANKED_C _footer_Poll
_FooterCompose::
  call FarCallInline
  DB BANK(FooterCompose)
  DW FooterCompose

DEF FOOTER_PAGE EQU 4
PAGE FOOTER_PAGE
; Compose the right-aligned clock without a row-sized temporary. The marker
; and seven clock characters occupy the last eight cells of either stride.
FooterCompose:
  ld a, [_footer_ready]
  and a
  jr nz, .ready
  push de
  call _footer_Poll
  pop de
.ready
  ld a, [_screen_stride]
  sub 8
  ld b, a
  ld c, 1
.scan
  ld a, b
  and a
  jr z, .fill
  ld a, [de]
  cp FOOTER_MARKER
  jr z, .fill
  ld l, a
  ld h, 0
  push bc
  push de
  push hl;char followed by zero, for RenderTextWidth
  ld hl, sp+0
  ld d, h
  ld e, l
  call _RenderTextWidth
  pop hl
  pop de
  pop bc
  ld l, a;width
  ld a, [_screen_width]
  sub 48
  sub c
  cp l
  jr c, .fill
  ld a, c
  add l
  ld c, a
  inc de
  dec b
  jr .scan
.fill
  inc b;include the clock-position marker itself
  ld a, FOOTER_MARKER
.marker
  ld [de], a
  inc de
  dec b
  jr nz, .marker
  push de
  ld b, 7
  ld a, ' '
.blank
  ld [de], a
  inc de
  dec b
  jr nz, .blank
  pop de
  ld hl, _footer_time
.time
  ld a, [hli]
  and a
  ret z
  ld [de], a
  inc de
  jr .time
END_PAGE
