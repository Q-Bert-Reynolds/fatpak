
SECTION "Map Images", ROMX
INCLUDE "img/maps/flower_tile_anim.asm"
INCLUDE "img/maps/houses.asm"
INCLUDE "img/maps/overworld.asm"
INCLUDE "img/maps/world_sprites.asm"
INCLUDE "img/maps/businesses.asm"
INCLUDE "img/maps/forest.asm"

SECTION "Map Loader Data", ROM0
DEF MAP_MAPTEST         EQU 0

MapBanks:
  DB BANK(MapMapTest)

MapAddresses:
  DW MapMapTest

SECTION "MapTest Map Bank", ROMX
INCLUDE "maps/MapTest.gbmap"
