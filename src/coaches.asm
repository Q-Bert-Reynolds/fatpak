INCLUDE "src/beisbol.inc"
INCLUDE "data/coach_img.asm"

SECTION "Coaches RAM", WRAM0
Opponent::
.name: DS 8
.coach: DS 16
.innings: DB
.money: DS 3
.restriction: DB
.flag_index: DB
.flag_bits: DB
.item: DB
.image: DB
OpponentEnd:

SECTION "Banked Coach Code/Data", ROMX

INCLUDE "data/coach_data.asm"

;TODO: coaching styles and strategies go here

PreLoadCoachTiles:: ;a = coach id, de = vram address, returns bank in a, tiles in hl, vram address in de, byte count in bc
  push de;vram address
.calcByteCount
  push af;id
  ld b, 0
  ld c, a
  ld hl, CoachTileCounts
  add hl, bc
  ld a, [hl]
  ld de, 16
  call math_Multiply
  ld b, h
  ld c, l
  pop af;id
  push bc;byte count
.getTiles
  push af;id
  ld h, 0
  ld l, a
  add hl, hl
  ld de, CoachTiles
  add hl, de
  ld a, [hli]
  ld d, a
  ld a, [hl]
  ld h, a
  ld l, d
  pop af;id
  push hl;tiles
.getBank
  ld b, 0
  ld c, a
  ld hl, CoachBanks
  add hl, bc
  ld a, [hl];bank
  pop hl;tiles
  pop bc;byte count
  pop de;vram address
  ret

PreloadCoachPalettes:: ;a = coach id, h = first pal index, returns a = bank, b = first pal index, c = num palettes, hl = source
  push af;coach id
  push hl;h = first pal index
  add a, a
  ld b, 0
  ld c, a
  ld hl, CoachColors
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld h, a 
  ld l, c;hl = colors
  pop de;d = first pal index
  pop af;coach id

  push hl;colors
  push af;coach id
  ld b, 0
  ld c, a
  ld hl, CoachPaletteCounts
  add hl, bc
  ld a, [hl];palette count
  ld b, d;b = first palette index
  ld c, a;c = palette count

  pop af;coach id
  ld d, 0
  ld e, a
  ld hl, CoachBanks
  add hl, de
  ld a, [hl];bank

  pop hl;colors
  ret

PreSetCoachTiles:: ;a = coach, h=offset, returns tiles in bc, bank in a, offset in h
  push hl;offset
  push af;id

  ld h, 0
  ld l, a
  add hl, hl
  ld bc, CoachTileMaps
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a ;bc = tiles

  pop af;id
  push bc;tiles

  ld d, 0
  ld e, a
  ld hl, CoachBanks
  add hl, de
  ld a, [hl];bank

  pop bc;tiles
  pop hl;h = offset
  ret

PreSetCoachPalettes:: ;a = coach, h=offset, sets VBK, returns pal map in bc, bank in a, offset in h
  push hl;offset
  push af;id
  ld h, 0
  ld l, a
  add hl, hl
  ld bc, CoachPaletteMaps
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a ;bc = pal map

  ld a, 1
  ldh [rVBK], a

  pop af;id
  push bc;pal map
  ld d, 0
  ld e, a
  ld hl, CoachBanks
  add hl, de
  ld a, [hl];bank
  pop bc;pal map

  pop hl;h = offset
  ret

SECTION "Coach Code", ROM0

LoadCoachTiles:: ;a = coach id, de = vram address
  TRAMPOLINE PreLoadCoachTiles
  ld [rROMB0], a
  call mem_CopyVRAM

  ldh a, [loaded_bank]
  ld [rROMB0], a
  ret

LoadCoachPalettes:: ;a = coach id, h = offset
  ld b, a;coach
  ld a, [sys_info]
  and a, SYS_INFO_GBC | SYS_INFO_SGB
  ret z;exit early if color not supported

  ld a, BANK(PreloadCoachPalettes)
  ld [rROMB0], a

  ld a, b;coach
  call PreloadCoachPalettes
  ld [rROMB0], a
  call GBCSetTwoColorBGPalettes

  ldh a, [loaded_bank]
  ld [rROMB0], a
  ret

SetCoachTiles:: ;a = coach, de=xy, h=offset
  ld b, a;coach
  ld a, BANK(PreSetCoachTiles)
  ld [rROMB0], a

  ld a, b;coach
  push de;xy
  call PreSetCoachTiles
  pop de;xy
  ld [rROMB0], a
  ld a, h;offset
  ld hl, $0707
  call SetBkgTilesWithOffset

  ldh a, [loaded_bank]
  ld [rROMB0], a
  ret

SetCoachPalettes:: ;a = coach, de=xy, h=offset
  ld b, a;coach
  ld a, [sys_info]
  and a, SYS_INFO_GBC | SYS_INFO_SGB
  ret z;exit early if color not supported

  ld a, BANK(PreSetCoachPalettes)
  ld [rROMB0], a

  ld a, b;coach
  push de;xy
  call PreSetCoachPalettes
  ld [rROMB0], a
  ld a, h;offset
  pop de;xy
  ld hl, $0707
  call SetBkgTilesWithOffset

  xor a
  ldh [rVBK], a

  ldh a, [loaded_bank]
  ld [rROMB0], a
  ret
