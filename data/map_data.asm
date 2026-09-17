;constants
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
