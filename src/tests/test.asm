MACRO RUN_TESTS
IF SOUND_TEST_ENABLED
  TRAMPOLINE SFXTest
ENDC

IF KEYBOARD_TEST_ENABLED
  TRAMPOLINE KeyboardDemo
ENDC

IF MAP_TEST_ENABLED
  TRAMPOLINE TestMap
ENDC

IF SD_TEST_ENABLED
  TRAMPOLINE SDTest
ENDC

ENDM

IF SOUND_TEST_ENABLED
INCLUDE "src/tests/sfx_test.asm"
ENDC

IF KEYBOARD_TEST_ENABLED
SECTION FRAGMENT "Keyboard Code Bank X", ROMX;the handlers jump to the demo and it reads their keymaps
INCLUDE "src/keyboard/kb_demo.asm"
INCLUDE "src/keyboard/kb_debug_ui.asm"
ENDC

IF MAP_TEST_ENABLED
INCLUDE "src/tests/map_test.asm"
ENDC

IF SD_TEST_ENABLED
INCLUDE "src/tests/sd_test.asm"
ENDC
