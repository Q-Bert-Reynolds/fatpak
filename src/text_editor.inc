IF !DEF(TEXT_EDITOR_INC)
DEF TEXT_EDITOR_INC EQU 1

INCLUDE "src/hardware.inc"
INCLUDE "src/memory1.asm"
INCLUDE "src/strings.asm"
INCLUDE "src/gbdk.asm"
INCLUDE "src/math.asm"

INCLUDE "src/charmap.asm"
INCLUDE "src/constants.asm"
INCLUDE "src/macros.asm"
INCLUDE "src/pages.asm"
INCLUDE "src/far_call.asm"
INCLUDE "src/keyboard/keyboard.asm"
INCLUDE "src/input.asm"
INCLUDE "src/interrupts.asm"

INCLUDE "src/color.asm"
INCLUDE "src/sgb.asm"

INCLUDE "src/core.asm"


INCLUDE "src/fade.asm"
INCLUDE "src/editor/editor.asm"
INCLUDE "src/fatfs/fatfs.asm"

INCLUDE "src/wram.asm"
INCLUDE "src/sram.asm"

;TODO: makefile should create/update a file that includes all assemblies generated from C sources 

ENDC ; TEXT_EDITOR_INC
