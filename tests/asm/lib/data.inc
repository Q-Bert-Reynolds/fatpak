; included twice by features.asm: the guard keeps it to one definition
IF !DEF(DATA_INC)
DEF DATA_INC EQU 1
DEF DATA_MAGIC EQU $BEEF
ENDC
