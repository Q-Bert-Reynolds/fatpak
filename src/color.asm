;
; color.asm
;
; SGB + GBC
;   SetPalettesIndirect             hl = palettes in PAL_SET (SGB) fromat
;   SetPalettesDirect               a = SGB packet header, bc = paletteA, de = paletteB

; GBC only
;   GBCCopyPalettesTo               hl = destination
;   GBCCopyPalettesFrom             hl = source
;   GBCSetTwoColorBGPalettes        b = first pal index, c = num palettes, hl = source
;   GBCSetPalette                   a = palette id, hl = colors

IF !DEF(COLOR_ASM)
DEF COLOR_ASM EQU 1

MACRO RGB ;\1 = red, \2 = green, \3 = blue
  DW (\3 << 10 | \2 << 5 | \1)
ENDM

MACRO DEF_RGB;\1=name \2-4=rgb
  DEF tmp EQUS "MACRO \1\nRGB \2, \3, \4\nENDM"
  tmp
  PURGE tmp
ENDM

MACRO SET_DEFAULT_PALETTE
  ld hl, rBGP
  ld [hl], DMG_PAL_BDLW
  ld hl, rOBP0
  ld [hl], DMG_PAL_BDLW
  ld hl, rOBP1
  ld [hl], DMG_PAL_DLWW
ENDM

;DMG
DEF DMG_PAL_BDLW EQU %11100100 ;normal
DEF DMG_PAL_WLDB EQU %00100111 ;inverted
DEF DMG_PAL_BDLL EQU %11100101 ;black, dark,  light, light/transparent
DEF DMG_PAL_DLWW EQU %10010000 ;dark,  light, white, white/transparent
DEF DMG_PAL_BDWW EQU %11100000 ;black, dark,  white, white/transparent
DEF DMG_PAL_BLWW EQU %11010000 ;black, light, white, white/transparent
DEF DMG_PAL_BLBW EQU %11011100 ;black, light, black, white/transparent
DEF DMG_PAL_WLBW EQU %00011100 ;white, light, black, white/transparent

;CGB/SGB
DEF WHITE_R EQU 29
DEF WHITE_G EQU 29
DEF WHITE_B EQU 27

;greyscale
DEF_RGB  COLOR_WHITE,        29, 29, 29
DEF_RGB  COLOR_LIGHT_GREY,   23, 23, 23
DEF_RGB  COLOR_DARK_GREY,    15, 15, 15
DEF_RGB  COLOR_DARKER_GREY,   8,  8,  8
DEF_RGB  COLOR_ALMOST_BLACK,  6,  6,  6
DEF_RGB  COLOR_BLACK,         0,  0,  0

;sepia
DEF_RGB  COLOR_OFF_WHITE,    29, 29, 27
DEF_RGB  COLOR_TAN,          25, 21, 18
DEF_RGB  COLOR_DIRT,         23, 16, 12
DEF_RGB  COLOR_BROWN,        15, 12,  7
DEF_RGB  COLOR_DARK_BROWN,    3,  2,  0

;rainbow
DEF_RGB  COLOR_PINK,         30, 25, 26
DEF_RGB  COLOR_RED,          25, 11, 15
DEF_RGB  COLOR_DARK_RED,     13,  3,  8
DEF_RGB  COLOR_SALMON,       25,  8, 10
DEF_RGB  COLOR_PEACH,        28, 24, 17
DEF_RGB  COLOR_WARNING,      29, 28, 10
DEF_RGB  COLOR_YELLOW,       29, 27, 17
DEF_RGB  COLOR_LIGHT_GREEN,  16, 23, 13
DEF_RGB  COLOR_OLIVE,        18, 19, 12
DEF_RGB  COLOR_GREEN,         5, 16,  8
DEF_RGB  COLOR_GRASS,         6, 13, 10
DEF_RGB  COLOR_LIGHT_BLUE,   26, 27, 29
DEF_RGB  COLOR_BLUE,         11, 15, 25
DEF_RGB  COLOR_BLUE_GREY,    14, 16, 18
DEF_RGB  COLOR_DARK_BLUE,     5,  8, 16
DEF_RGB  COLOR_DEEP_PURPLE,   0,  2,  5
DEF_RGB  COLOR_PURPLE_GREY,  10,  9, 12

SECTION "Color Code", ROM0
;----------------------------------------------------------------------
;
; SetPalettesIndirect - sets first 4 palettes by index
;   
;   works for both CGB and SGB
;
;   input: 
;     hl = palettes in PAL_SET (SGB) fromat
;
;----------------------------------------------------------------------
SetPalettesIndirect::;hl = palettes in PAL_SET (SGB) fromat
.checkCGB
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .checkSGB
.setPaletteCGB
  push hl;palettes
  inc hl;first palette index
  ld a, BCPSF_AUTOINC
  ldh [rBCPS], a
  ldh [rOCPS], a

  xor a
.loopPalettes
    push af;pal id
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld b, a
    pop af;pal id
    push af;pal id
    push hl;next palette label
    push af;pal id
    ld h, b
    ld l, c;index
    add hl, hl;hl*2
    add hl, hl;hl*4
    add hl, hl;hl*8
    ld bc, DefaultPalettes
    add hl, bc

    pop af;pal id
    call GBCSetPalette

    pop hl;palette label
    pop af
    inc a
    cp 4
    jr nz, .loopPalettes

  pop hl;palettes
.checkSGB
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  ret z
.setPalettesSGB
  jp _sgb_PacketTransfer;no need to check sys info again

;----------------------------------------------------------------------
;
; SetPalettesDirect - sets middle 2 palettes
;   
;   works for both CGB and SGB
;
;   input: 
;     bc = colorA
;     de = colorB
;
;----------------------------------------------------------------------
SetPalettesDirect::;bc = paletteA, de = paletteB
.checkCGB
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .checkSGB
.setPaletteCGB
  ld h, b
  ld l, c
  ld a, 2
  call GBCSetPalette
  ld h, d
  ld l, e
  ld a, 3
  call GBCSetPalette
.checkSGB
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  ret z
.setPalettesSGB
  ld a, PAL23
  jp sgb_SetPal

GBCSetPalette::;a = palette id, hl = colors
  add a, a
  add a, a
  add a, a
  or a, BCPSF_AUTOINC
  ldh [rBCPS], a
  ldh [rOCPS], a
  ld a, 8;4 colors, 2 bytes each
.loopColors
    push af
    LCD_WAIT_VRAM
    ld a, [hli]
    ldh [rBCPD], a
    ldh [rOCPD], a
    pop af
    dec a
    jr nz, .loopColors
  ret

GBCSetTwoColorBGPalettes::; b = first pal index, c = num palettes, hl = source
  ld a, b
  sla a
  sla a
  sla a
  or a, BCPSF_AUTOINC
  ldh [rBCPS], a
.loop
    ld a, [ColorWhite]
    ldh [rBCPD], a
    ld a, [ColorWhite+1]
    ldh [rBCPD], a
    ld a, [hli];light grey
    ldh [rBCPD], a
    ld a, [hli]
    ldh [rBCPD], a
    ld a, [hli];dark grey
    ldh [rBCPD], a
    ld a, [hli]
    ldh [rBCPD], a
    ld a, [ColorBlack]
    ldh [rBCPD], a
    ld a, [ColorBlack+1]
    ldh [rBCPD], a
    dec c
    jr nz, .loop
  ret

;----------------------------------------------------------------------
;
; SetColorBlocks - sets rectangles of color in screenspace
;   
;   works for both CGB and SGB
;
;   input: 
;     b = draw flags
;     hl = SGB ATTR_BLK
;
;----------------------------------------------------------------------
SetColorBlocks::
.checkCGB
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .checkSGB
.setColorBlocksCGB
  jp GBCSetColorBlocks
.checkSGB
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  ret z
.setColorBlocksSGB
  jp _sgb_PacketTransfer

;assumes no window offset, only handles inside blocks
GBCSetColorBlocks::;b = draw flags, hl = SGB ATTR_BLK address
  inc hl;skip sgb packet header
  ld a, [hli];packet count
.loop
    push af;packet count
    push bc;draw flags
    call GBCSetColorBlock
    pop bc;draw flags
    pop af;packet count
    dec a
    jr nz, .loop
  ret

;TODO: handle outside and border cases
GBCSetColorBlock::;b = draw flags, hl = ATTR_BLK_DATA address, returns address of next ATTR_BLK_DATA if any
  push bc;draw flags
  ld a, [hli];bit 2 = outside block, bit 1 = on border, bit 0 = inisde block... not used here
  ld a, [hli];(outside << 4) + (border << 2) + inside XXoobbii
  and %00000011;toss outside and border palettes
  ld b, a;palette in b
  ld a, [hli];x
  ld d, a;x
  ld a, [hli];y
  ld e, a;y
  ld a, [hli];x+w-1
  sub a, d;w-1
  inc a;w
  ld c, a;w
  ld a, [hli];y+h-1
  sub a, e;h-1
  inc a;h
  push hl;next ATTR_BLK_DATA
  ld h, c;w
  ld l, a;h
  push hl;wh
  push de;xy

  ld d, 0
  ld e, c;w
  call math_Multiply;hl = de * a = w * h, b untouched
  ld a, b;palette
  ld b, h
  ld c, l
  ld hl, tile_buffer
  call mem_Set;fills tile buffer with palette from above

  pop de;xy
  pop hl;wh
  pop bc;next ATTR_BLK_DATA
  pop af;draw flags
  push bc;next ATTR_BLK_DATA
  ld bc, tile_buffer
  call GBCSetPaletteMap
  pop hl;next ATTR_BLK_DATA
  ret

GBCSetPaletteMap::;a = draw flags, hl = wh, de = xy, bc = firstTile
  and a, DRAW_FLAGS_WIN
  jr nz, GBCSetWinPaletteMap
  ;fall through to bkg pal map

GBCSetBkgPaletteMap::;hl = wh, de = xy, bc = firstTile
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  ret z
  ld a, 1
  ldh [rVBK], a
  call gbdk_SetBkgTiles
  xor a
  ldh [rVBK], a
  ret

GBCSetWinPaletteMap::;hl = wh, de = xy, bc = firstTile
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  ret z
  ld a, 1
  ldh [rVBK], a
  call gbdk_SetWinTiles
  xor a
  ldh [rVBK], a
  ret

GBCCopyPalettesTo::;hl = dest
  push hl;dest
  ld bc, 8*2*4
  add hl, bc
  ld d, h
  ld e, l;de = dest+8*2*4
  pop hl;dest
  xor a
  ld c, 8*2*4;8 palettes * 2B / color * 4 colors / palette
.copyBkgPal
    ldh [rBCPS], a;set bkg palette index
    ldh [rOCPS], a;set obj palette index
    inc a
    push af;index
    LCD_WAIT_VRAM
    ldh a, [rBCPD];get bkg color
    ld [hli], a;store in tile_buffer
    ldh a, [rOCPD];get obj color
    ld [de], a;store in tile_buffer
    inc de
    pop af;index
    dec c
    jr nz, .copyBkgPal
  ret

GBCCopyPalettesFrom::;hl = source
  push hl;dest
  ld bc, 8*2*4
  add hl, bc
  ld d, h
  ld e, l;de = dest+8*2*4
  pop hl;dest
  ld a, BCPSF_AUTOINC
  ldh [rBCPS], a
  ldh [rOCPS], a
  ld c, 8*2*4;8 palettes * 2B / color * 4 colors / palette
.loop
    LCD_WAIT_VRAM
    ld a, [hli]
    ldh [rBCPD], a
    ld a, [de]
    ldh [rOCPD], a
    inc de
    dec c
    jr nz, .loop
  ret

SECTION "Palettes", ROM0
;This should be a ROMX section, but sgb_PalTrn and several color copy functions expect them to be in ROM0
DefaultPalettes::
PaletteGrey::
  ColorWhite:: COLOR_OFF_WHITE
  ColorLight:: COLOR_LIGHT_GREY
  ColorDark::  COLOR_DARK_GREY
  ColorBlack:: COLOR_BLACK
DEF PALETTE_GREY EQU (PaletteGrey-DefaultPalettes)/8

PaletteSepia::
  COLOR_OFF_WHITE
  COLOR_TAN
  COLOR_BROWN
  COLOR_DARK_BROWN
DEF PALETTE_SEPIA EQU (PaletteSepia-DefaultPalettes)/8

PaletteUI::
  COLOR_OFF_WHITE
  COLOR_TAN    
  COLOR_RED      
  COLOR_BLACK 
DEF PALETTE_UI EQU (PaletteUI-DefaultPalettes)/8

PaletteBaseball::
  COLOR_WHITE
  COLOR_OFF_WHITE    
  COLOR_RED      
  COLOR_DARK_RED 
DEF PALETTE_BASEBALL EQU (PaletteBaseball-DefaultPalettes)/8

PaletteField::
  COLOR_OFF_WHITE
  COLOR_DIRT    
  COLOR_GRASS     
  COLOR_DARK_BROWN
DEF PALETTE_FIELD EQU (PaletteField-DefaultPalettes)/8

PaletteDark::
  COLOR_OFF_WHITE
  COLOR_DARKER_GREY
  COLOR_ALMOST_BLACK
  COLOR_BLACK 
DEF PALETTE_DARK EQU (PaletteDark-DefaultPalettes)/8

PaletteTownMap::
  COLOR_OFF_WHITE
  COLOR_BLUE_GREY    
  COLOR_GREEN      
  COLOR_BLACK 
DEF PALETTE_TOWN_MAP EQU (PaletteTownMap-DefaultPalettes)/8

PaletteTownMapLocation::
  COLOR_OFF_WHITE
  COLOR_RED    
  COLOR_GREEN      
  COLOR_BLACK 
DEF PALETTE_TOWN_MAP_LOCATION EQU (PaletteTownMapLocation-DefaultPalettes)/8

PaletteWarning::
  COLOR_OFF_WHITE
  COLOR_TAN    
  COLOR_WARNING      
  COLOR_BLACK 
DEF PALETTE_WARNING EQU (PaletteWarning-DefaultPalettes)/8

PaletteGood::
  COLOR_OFF_WHITE
  COLOR_TAN    
  COLOR_GREEN      
  COLOR_BLACK 
DEF PALETTE_GOOD EQU (PaletteGood-DefaultPalettes)/8

PaletteIntro::
  COLOR_OFF_WHITE
  RGB 30, 22, 28
  RGB 13,  4,  9
  RGB  3,  1,  7
DEF PALETTE_INTRO EQU (PaletteIntro-DefaultPalettes)/8

PaletteTitleScreen::
  COLOR_OFF_WHITE
  COLOR_YELLOW    
  COLOR_BLUE      
  COLOR_DARK_BLUE 
DEF PALETTE_TITLE_SCREEN EQU (PaletteTitleScreen-DefaultPalettes)/8

PaletteCalvin::
IF DEF(_HOME)
  COLOR_OFF_WHITE
  COLOR_RED
  COLOR_BROWN
  COLOR_DARK_RED
ELIF DEF(_AWAY)
  COLOR_OFF_WHITE
  COLOR_BLUE
  COLOR_BROWN
  COLOR_DARK_BLUE
ELSE;DEMO
  COLOR_OFF_WHITE
  COLOR_GREEN
  COLOR_BROWN
  COLOR_BLACK
ENDC
DEF PALETTE_CALVIN EQU (PaletteCalvin-DefaultPalettes)/8

PaletteLineupRedA::
  COLOR_OFF_WHITE
  COLOR_TAN
  COLOR_RED
  COLOR_BLACK
DEF PALETTE_LINEUP_RED_A EQU (PaletteLineupRedA-DefaultPalettes)/8

PaletteLineupBlueA::
  COLOR_OFF_WHITE
  COLOR_TAN
  COLOR_BLUE
  COLOR_BLACK
DEF PALETTE_LINEUP_BLUE_A EQU (PaletteLineupBlueA-DefaultPalettes)/8

PaletteLineupGreenA::
  COLOR_OFF_WHITE
  COLOR_TAN
  COLOR_GREEN
  COLOR_BLACK
DEF PALETTE_LINEUP_GREEN_A EQU (PaletteLineupGreenA-DefaultPalettes)/8

PaletteLineupRedB::
  COLOR_OFF_WHITE
  COLOR_BROWN
  COLOR_RED
  COLOR_BLACK
DEF PALETTE_LINEUP_RED_B EQU (PaletteLineupRedB-DefaultPalettes)/8

PaletteLineupBlueB::
  COLOR_OFF_WHITE
  COLOR_BROWN
  COLOR_BLUE
  COLOR_BLACK
DEF PALETTE_LINEUP_BLUE_B EQU (PaletteLineupBlueB-DefaultPalettes)/8

PaletteLineupGreenB::
  COLOR_OFF_WHITE
  COLOR_BROWN
  COLOR_BLACK
  COLOR_BLACK
DEF PALETTE_LINEUP_GREEN_B EQU (PaletteLineupGreenB-DefaultPalettes)/8

PaletteVersion::
IF DEF(_HOME)
  COLOR_OFF_WHITE
  COLOR_RED
  COLOR_BLUE_GREY
  COLOR_DARK_RED
ELIF DEF(_AWAY)
  COLOR_OFF_WHITE
  COLOR_BLUE
  COLOR_BLUE_GREY
  COLOR_DARK_BLUE
ELSE;DEMO
  COLOR_OFF_WHITE
  COLOR_GREEN
  COLOR_DARK_BROWN
  COLOR_BLACK
ENDC
DEF PALETTE_VERSION EQU (PaletteVersion-DefaultPalettes)/8

PaletteNolan::
IF DEF(_AWAY)
  COLOR_OFF_WHITE
  COLOR_RED
  COLOR_BROWN
  COLOR_DARK_RED
ELIF DEF(_HOME)
  COLOR_OFF_WHITE
  COLOR_BLUE
  COLOR_BROWN
  COLOR_DARK_BLUE
ELSE;DEMO
  COLOR_OFF_WHITE
  COLOR_YELLOW
  COLOR_BROWN
  COLOR_DARK_BLUE
ENDC
DEF PALETTE_NOLAN EQU (PaletteNolan-DefaultPalettes)/8

PaletteStartLights::
  COLOR_OFF_WHITE
  COLOR_TAN
  COLOR_BROWN
  COLOR_BLACK
DEF PALETTE_START_LIGHTS EQU (PaletteStartLights-DefaultPalettes)/8

;Players
PaletteGreen::
  COLOR_OFF_WHITE
  COLOR_LIGHT_GREEN     
  COLOR_BROWN
  COLOR_BLACK
DEF PALETTE_BUBBI EQU (PaletteGreen-DefaultPalettes)/8

PaletteRed::
  COLOR_OFF_WHITE
  COLOR_PEACH
  COLOR_SALMON
  COLOR_BLACK 
DEF PALETTE_GINGER EQU (PaletteRed-DefaultPalettes)/8

PaletteCyan::
  COLOR_OFF_WHITE
  COLOR_TAN
  COLOR_BLUE
  COLOR_DARK_BLUE
DEF PALETTE_SQUIRT EQU (PaletteCyan-DefaultPalettes)/8

PalettePurple::
  COLOR_OFF_WHITE
  COLOR_YELLOW
  COLOR_PURPLE_GREY
  COLOR_DEEP_PURPLE
DEF PALETTE_MACOBB EQU (PalettePurple-DefaultPalettes)/8

PalettePink::
  COLOR_OFF_WHITE
  COLOR_PINK
  COLOR_RED
  COLOR_BLACK
DEF PALETTE_PUFF EQU (PalettePink-DefaultPalettes)/8

PaletteSlate::
  COLOR_OFF_WHITE
  COLOR_PINK
  COLOR_PURPLE_GREY
  COLOR_BLACK
DEF PALETTE_MUCHACHO EQU (PaletteSlate-DefaultPalettes)/8

PaletteYellow::
  COLOR_OFF_WHITE
  COLOR_YELLOW
  COLOR_TAN
  COLOR_DEEP_PURPLE

PaletteBlue::
  COLOR_OFF_WHITE
  COLOR_PEACH
  COLOR_BLUE
  COLOR_DEEP_PURPLE

PaletteWarm::
  COLOR_OFF_WHITE
  COLOR_YELLOW
  COLOR_PURPLE_GREY
  COLOR_BLACK

PaletteBaseballLeather::
  COLOR_WHITE
  RGB 29, 29, 27
  RGB 26, 25, 22
  RGB 20, 20, 19

PaletteBaseballLaces::
  COLOR_WHITE
  RGB 31, 31, 31
  RGB 15, 0, 2
  RGB 11, 3, 4

ENDC ;COLOR_ASM
