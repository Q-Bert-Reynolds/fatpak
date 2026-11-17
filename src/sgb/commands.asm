; SGB BIOS command IDs (Pan Docs, SGB command summary).
DEF SGB_CODE_PAL01    EQU $00 ;Set SGB Palette 0,1 Data
DEF SGB_CODE_PAL23    EQU $01 ;Set SGB Palette 2,3 Data
DEF SGB_CODE_PAL03    EQU $02 ;Set SGB Palette 0,3 Data
DEF SGB_CODE_PAL12    EQU $03 ;Set SGB Palette 1,2 Data
DEF SGB_CODE_ATTR_BLK EQU $04 ;Block Area Designation Mode
DEF SGB_CODE_ATTR_LIN EQU $05 ;Line Area Designation Mode
DEF SGB_CODE_ATTR_DIV EQU $06 ;Divide Area Designation Mode
DEF SGB_CODE_ATTR_CHR EQU $07 ;1CHR Area Designation Mode
DEF SGB_CODE_SOUND    EQU $08 ;Sound On/Off
DEF SGB_CODE_SOU_TRN  EQU $09 ;Transfer Sound PRG/DATA
DEF SGB_CODE_PAL_SET  EQU $0A ;Set SGB Palette Indirect
DEF SGB_CODE_PAL_TRN  EQU $0B ;Set System Color Palette Data
DEF SGB_CODE_ATRC_EN  EQU $0C ;Enable/disable Attraction Mode
DEF SGB_CODE_TEST_EN  EQU $0D ;Speed Function (unavailable)
DEF SGB_CODE_ICON_EN  EQU $0E ;SGB Function
DEF SGB_CODE_DATA_SND EQU $0F ;Packet Transfer to SNES WRAM
DEF SGB_CODE_DATA_TRN EQU $10 ;VRAM Transfer to SNES WRAM
DEF SGB_CODE_MLT_REQ  EQU $11 ;Controller 2 Request
DEF SGB_CODE_JUMP     EQU $12 ;Set SNES Program Counter
DEF SGB_CODE_CHR_TRN  EQU $13 ;Transfer Character Font Data
DEF SGB_CODE_PCT_TRN  EQU $14 ;Set Screen Data Color Data
DEF SGB_CODE_ATTR_TRN EQU $15 ;Set Attribute from ATF
DEF SGB_CODE_ATTR_SET EQU $16 ;Set Data to ATF
DEF SGB_CODE_MASK_EN  EQU $17 ;Game Boy Window Mask
DEF SGB_CODE_OBJ_TRN  EQU $18 ;SNES OBJ Mode (unavailable)
DEF SGB_CODE_PAL_PRI  EQU $19 ;System palette priority

