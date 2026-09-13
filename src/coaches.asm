INCLUDE "src/beisbol.inc"
INCLUDE "data/coach_img.asm"

SECTION "Banked Coach Code", ROMX, BANK[COACHES_BANK]

PreLoadCoachTiles:: ;a = coach id, de = vram address, returns bank in a, tiles in hl, vram address in de
  push de;vram address
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
  push af;id
  add a, a
  ld d, 0
  ld e, a
  ld hl, CoachTiles
  add hl, de
  ld a, [hli]
  ld d, a
  ld a, [hl]
  ld h, a
  ld l, d
  
  pop af;id
  push hl;tiles
  ld b, 0
  ld c, a
  ld hl, CoachBanks
  add hl, bc
  ld a, [hl]

  pop hl;tiles
  pop de;vram address
  ret

PreloadCoachPalettes:: ;a = coach id, h = first pal index, returns b = first pal index, c = num palettes, hl = source
  ld b, a;coach
  ld a, [sys_info]
  and a, SYS_INFO_GBC | SYS_INFO_SGB
  ret z;exit early if not color
 
  ld a, b;coach
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

PreSetCoachTiles:: ;a = coach, de=xy, h=offset
  push hl;offset

  add a, a
  ld b, 0
  ld c, a
  ld hl, CoachTileMaps
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a ;bc = tiles

  pop hl;offset
  ld a, h; a = offset

  ;TODO... return tiles, offset, and bank; move SetBkg to SetCoachTiles
  ld hl, $0707
  call SetBkgTilesWithOffset
  ret

PreSetCoachPalettes:: ;a = coach, de=xy, h=offset
  ld b, a;coach
  ld a, [sys_info]
  and a, SYS_INFO_GBC | SYS_INFO_SGB
  ret z;exit early if not GBC
  ld a, b;coach

  push hl;offset
  add a, a
  ld b, 0
  ld c, a
  ld hl, CoachPaletteMaps
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a ;bc = map

  ld a, 1
  ld [rVBK], a
  pop hl;offset
  ld a, h; a = offset

  ;TODO... return map, offset, and bank; move SetBkg to SetCoachPalettes
  ld hl, $0707
  call SetBkgTilesWithOffset
  xor a
  ld [rVBK], a
  ret

SECTION "Coach Code", ROM0

LoadCoachTiles:: ;a = coach id, de = vram address
  push af
  ld a, [loaded_bank]
  ld b, a;bank
  ld a, COACHES_BANK
  SET_BANK

  pop af
  push bc;bank
  call PreLoadCoachTiles
  ld [rROMB0], a
  call mem_CopyVRAM

  pop af;bank
  SET_BANK
  ret

LoadCoachPalettes:: ;a = coach id, h = offset
  push af
  ld a, [loaded_bank]
  ld b, a;bank
  ld a, COACHES_BANK
  SET_BANK

  pop af
  push bc;bank
  call PreloadCoachPalettes
  ld [rROMB0], a
  call SetTwoColorBGPalettes

  pop af;bank
  SET_BANK
  ret

SetCoachTiles:: ;a = coach, de=xy, h=offset
  push af
  ld a, [loaded_bank]
  ld b, a;bank
  ld a, COACHES_BANK
  SET_BANK

  pop af
  push bc;bank
  call PreSetCoachTiles

  pop af;bank
  SET_BANK
  ret

SetCoachPalettes:: ;a = coach, de=xy, h=offset
  push af
  ld a, [loaded_bank]
  ld b, a;bank
  ld a, COACHES_BANK
  SET_BANK

  pop af
  push bc;bank
  call PreSetCoachPalettes

  pop af;bank
  SET_BANK
  ret
