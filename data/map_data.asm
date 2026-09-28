
SECTION "Map Images", ROMX
INCLUDE "img/maps/houses.asm"
INCLUDE "img/maps/overworld.asm"
INCLUDE "img/maps/world_sprites.asm"
INCLUDE "img/maps/businesses.asm"
INCLUDE "img/maps/forest.asm"

SECTION "Map Loader Data", ROM0
DEF MAP_BUSINESSES      EQU 0
DEF MAP_VETERANPARK     EQU 1
DEF MAP_MOUNTAINS       EQU 2
DEF MAP_OVERWORLD       EQU 3
DEF MAP_HOUSES          EQU 4

MapBanks:
  DB BANK(MapBusinesses)
  DB BANK(MapVeteranPark)
  DB BANK(MapMountains)
  DB BANK(MapOverworld)
  DB BANK(MapHouses)

MapAddresses:
  DW MapBusinesses
  DW MapVeteranPark
  DW MapMountains
  DW MapOverworld
  DW MapHouses

SECTION "Businesses Map Bank", ROMX
INCLUDE "maps/Businesses.gbmap"

SECTION "VeteranPark Map Bank", ROMX
INCLUDE "maps/VeteranPark.gbmap"

SECTION "Mountains Map Bank", ROMX
INCLUDE "maps/Mountains.gbmap"

SECTION "Overworld Map Bank", ROMX
INCLUDE "maps/Overworld.gbmap"

SECTION "Houses Map Bank", ROMX
INCLUDE "maps/Houses.gbmap"
