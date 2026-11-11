IF !DEF(FATPAK_INC)
DEF FATPAK_INC EQU 1

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
INCLUDE "src/rtc/rtc.asm"

INCLUDE "src/ui/color.asm"
INCLUDE "src/ui/sgb.asm"

INCLUDE "src/core.asm"


INCLUDE "src/ui/fade.asm"
INCLUDE "src/ui/theme.asm"
INCLUDE "src/ui/frame.asm"
INCLUDE "src/ui/footer.asm"
INCLUDE "src/editor/text_buffer.asm"
INCLUDE "src/editor/keywords.asm"
INCLUDE "src/editor/osk.asm"
INCLUDE "src/ui/render.asm"
INCLUDE "src/editor/editor.asm"
INCLUDE "src/editor/undo.asm"
INCLUDE "src/fatfs/sd.asm"
INCLUDE "src/game/ingame.asm"
INCLUDE "src/game/loading.asm"
INCLUDE "src/game/snapshot.asm"
INCLUDE "src/game/launch.asm"
INCLUDE "src/fatfs/fatfs.asm"

INCLUDE "src/modules/runtime.asm"

INCLUDE "src/wram.asm"
INCLUDE "src/sram.asm"

INCLUDE "build/c_modules.inc";generated from the C_SOURCES list in Makefile

ENDC ; FATPAK_INC
