; a project's main: its defines come from project.gbp, its includes from the project's folder
INCLUDE "lib/part.asm"
INCLUDE "Base.asm"
SECTION "main", ROM0[$150]
  ld a, LANG
IF DEF(_DEMO)
  db STRLEN("{_DEMO}"), Part, Root
ENDC
SECTION "far", ROMX
  db "far"
