MACRO RUN_TESTS
IF SOUND_TEST_ENABLED
  TRAMPOLINE SFXTest
ENDC

IF KEYBOARD_TEST_ENABLED
  TRAMPOLINE KeyboardDemo
ENDC

IF SD_TEST_ENABLED
  TRAMPOLINE SDDiag;read only, SDTest also writes sector 1
ENDC

ENDM

IF SOUND_TEST_ENABLED
INCLUDE "src/tests/sfx_test.asm"
ENDC

IF KEYBOARD_TEST_ENABLED
  KEYBOARD_SECTION;the handlers jump to the demo and it reads their keymaps
INCLUDE "src/keyboard/kb_demo.asm"
INCLUDE "src/keyboard/kb_debug_ui.asm"
ENDC

IF SD_TEST_ENABLED
INCLUDE "src/tests/sd_test.asm"
ENDC
