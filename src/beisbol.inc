IF !DEF(BEISBOL_INC)
DEF BEISBOL_INC EQU 1

INCLUDE "src/hardware.inc"
INCLUDE "src/memory1.asm"
INCLUDE "src/strings.asm"
INCLUDE "src/gbdk.asm"
INCLUDE "src/math.asm"

INCLUDE "src/charmap.asm"
INCLUDE "src/constants.asm"
INCLUDE "src/macros.asm"
INCLUDE "src/keyboard/keyboard.asm"
INCLUDE "src/input.asm"
INCLUDE "src/interrupts.asm"

INCLUDE "src/color.asm"
INCLUDE "src/sgb.asm"
INCLUDE "src/audio/audio.asm"
INCLUDE "src/ui.asm"
INCLUDE "src/items.asm"
INCLUDE "src/user.asm"

INCLUDE "src/roledex/roledex.asm"
INCLUDE "src/core.asm"
INCLUDE "src/players.asm"
INCLUDE "src/coaches.asm"
INCLUDE "src/teams.asm"
INCLUDE "src/map_loader.asm"

INCLUDE "src/seed_data.asm"
INCLUDE "src/tests/test.asm"

INCLUDE "src/fade.asm"
INCLUDE "src/start.asm"
INCLUDE "src/title.asm"
INCLUDE "src/new_game.asm"
INCLUDE "src/world/world.asm"
INCLUDE "src/baseball/play_ball.asm"
INCLUDE "src/lineup/lineup.asm"
INCLUDE "src/roledex/roledex_ui.asm"
INCLUDE "src/baseball/simulation.asm"

INCLUDE "src/wram.asm"
INCLUDE "src/sram.asm"

;TODO: makefile should create/update a file that includes all assemblies generated from C sources 

ENDC ; BEISBOL_INC
