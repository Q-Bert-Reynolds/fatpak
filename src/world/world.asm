INCLUDE "src/text_editor.inc"

DEF WORLD_SAMPLE_RATE       EQU 12
DEF WORLD_FRAME_STEP        EQU 60 / WORLD_SAMPLE_RATE

SECTION "Billet Town", ROMX
INCLUDE "data/strings/billet_town_strings.asm"

SECTION "World Meta Sprites", ROMX
INCLUDE "maps/WorldMetaSprites.gbms"

SECTION "World Code", ROMX
INCLUDE "data/strings/world_strings.asm"
INCLUDE "src/world/scripts.asm"
INCLUDE "img/maps/world_sprites.asm"
INCLUDE "maps/map_avatars.gbavatar"
