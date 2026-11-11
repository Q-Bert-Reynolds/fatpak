; shared by tests/asm/features.asm: guards, constants, macros
IF !DEF(UTIL_INC)
DEF UTIL_INC EQU 1

DEF SCREEN_W EQU 160
DEF SCREEN_H EQU 144

RSRESET
DEF OBJ_Y RB 1
DEF OBJ_X RB 1
DEF OBJ_TILE RB 1
DEF OBJ_FLAGS RB 1
DEF OBJ_SIZE RB 0
RSSET 8
DEF PAIR RW 2
DEF QUAD RL 1
DEF RS_END RB 0

MACRO LD_IMM ; \1 = register, \2 = value
  ld \1, \2
ENDM

MACRO WAIT_VBLANK
.wait\@
  ldh a, [$FF44]
  cp 144
  jr c, .wait\@
ENDM

MACRO COUNTDOWN ; \1 = register, \2 = macro to run each step
.loop\@
  \2
  dec \1
  jr nz, .loop\@
ENDM

MACRO STEP
  inc c
ENDM

MACRO ADD_ALL ; sums every argument into a
REPT _NARG
  add a, \1
  SHIFT
ENDR
ENDM

ENDC
