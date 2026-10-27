MACRO RUN_TESTS
IF SOUND_TEST_ENABLED
  TRAMPOLINE SFXTest
ENDC

IF KEYBOARD_TEST_ENABLED
  call KeyboardDemo
ENDC

IF MAP_TEST_ENABLED
  TRAMPOLINE TestMap
ENDC

IF SIM_TEST_ENABLED
  TEST_SIM 255, -15, 15
ENDC
ENDM

MACRO TEST_SIM ;\1 = speed, \2 = deg left/right, \3 = deg up/down
  ld a, \1
  ld d, \2
  ld e, \3
  TRAMPOLINE RunSimulation;a = exit velocity d= spray angle e = launch angle
ENDM

MACRO TEST_ANNOUNCER ;\1 = angle left or right
  ld hl, str_buffer
  xor a
  ld [hl], a
  ld b, \1
  call AppendOutfieldLocationTextByAngle
  ld hl, str_buffer
  call RevealTextAndWait
ENDM

IF SOUND_TEST_ENABLED
INCLUDE "src/tests/sfx_test.asm"
ENDC

IF KEYBOARD_TEST_ENABLED
SECTION "Keyboard Test", ROM0
INCLUDE "src/keyboard/kb_demo.asm"
INCLUDE "src/keyboard/kb_debug_ui.asm"
ENDC

IF MAP_TEST_ENABLED
INCLUDE "src/tests/map_test.asm"
ENDC