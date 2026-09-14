SECTION "Coach Images 0", ROMX, BANK[COACH_IMG_BANK+0]

INCLUDE "./img/coaches/gm_aragon.asm"
INCLUDE "./img/coaches/rangers.asm"
INCLUDE "./img/coaches/ralph_soto.asm"
INCLUDE "./img/coaches/doc_hickory.asm"
INCLUDE "./img/coaches/oldtimers.asm"
INCLUDE "./img/coaches/mechs.asm"
INCLUDE "./img/coaches/jocks.asm"
INCLUDE "./img/coaches/scouts.asm"
INCLUDE "./img/coaches/senor_cano.asm"
INCLUDE "./img/coaches/calvin.asm"
INCLUDE "./img/coaches/bella_donna.asm"
INCLUDE "./img/coaches/gm_gandil.asm"
INCLUDE "./img/coaches/skip_rivers.asm"
INCLUDE "./img/coaches/cheer.asm"
INCLUDE "./img/coaches/lads.asm"
INCLUDE "./img/coaches/queens.asm"
INCLUDE "./img/coaches/miners.asm"
INCLUDE "./img/coaches/maniacs.asm"
INCLUDE "./img/coaches/great_zambino.asm"
INCLUDE "./img/coaches/techs.asm"
INCLUDE "./img/coaches/cats.asm"
INCLUDE "./img/coaches/nolan0.asm"
INCLUDE "./img/coaches/sharks.asm"
INCLUDE "./img/coaches/psychos.asm"
INCLUDE "./img/coaches/whips.asm"
INCLUDE "./img/coaches/smoke.asm"
INCLUDE "./img/coaches/luck.asm"
SECTION "Coach Images 1", ROMX, BANK[COACH_IMG_BANK+1]

INCLUDE "./img/coaches/bulls.asm"
INCLUDE "./img/coaches/lasses.asm"
INCLUDE "./img/coaches/sailors.asm"
INCLUDE "./img/coaches/ghosts.asm"
INCLUDE "./img/coaches/clowns.asm"
INCLUDE "./img/coaches/swimmers.asm"
INCLUDE "./img/coaches/fighters.asm"
INCLUDE "./img/coaches/rockets.asm"
INCLUDE "./img/coaches/birds.asm"
INCLUDE "./img/coaches/nolan2.asm"
INCLUDE "./img/coaches/gm_wu.asm"
INCLUDE "./img/coaches/coach_brick.asm"
INCLUDE "./img/coaches/fuzz.asm"
INCLUDE "./img/coaches/kids.asm"
INCLUDE "./img/coaches/captain_shreve.asm"
INCLUDE "./img/coaches/gm_elsa.asm"
INCLUDE "./img/coaches/gm_venkman.asm"
INCLUDE "./img/coaches/nolan1.asm"
INCLUDE "./img/coaches/beasts.asm"

SECTION "Coach Data", ROMX, BANK[COACHES_BANK]

DEF COACH_GM_ARAGON       EQU 0
DEF COACH_RANGERS         EQU 1
DEF COACH_RALPH_SOTO      EQU 2
DEF COACH_DOC_HICKORY     EQU 3
DEF COACH_OLDTIMERS       EQU 4
DEF COACH_MECHS           EQU 5
DEF COACH_JOCKS           EQU 6
DEF COACH_SCOUTS          EQU 7
DEF COACH_SENOR_CANO      EQU 8
DEF COACH_CALVIN          EQU 9
DEF COACH_BELLA_DONNA     EQU 10
DEF COACH_GM_GANDIL       EQU 11
DEF COACH_SKIP_RIVERS     EQU 12
DEF COACH_CHEER           EQU 13
DEF COACH_LADS            EQU 14
DEF COACH_QUEENS          EQU 15
DEF COACH_MINERS          EQU 16
DEF COACH_MANIACS         EQU 17
DEF COACH_GREAT_ZAMBINO   EQU 18
DEF COACH_TECHS           EQU 19
DEF COACH_CATS            EQU 20
DEF COACH_NOLAN0          EQU 21
DEF COACH_SHARKS          EQU 22
DEF COACH_PSYCHOS         EQU 23
DEF COACH_WHIPS           EQU 24
DEF COACH_SMOKE           EQU 25
DEF COACH_LUCK            EQU 26
DEF COACH_BULLS           EQU 27
DEF COACH_LASSES          EQU 28
DEF COACH_SAILORS         EQU 29
DEF COACH_GHOSTS          EQU 30
DEF COACH_CLOWNS          EQU 31
DEF COACH_SWIMMERS        EQU 32
DEF COACH_FIGHTERS        EQU 33
DEF COACH_ROCKETS         EQU 34
DEF COACH_BIRDS           EQU 35
DEF COACH_NOLAN2          EQU 36
DEF COACH_GM_WU           EQU 37
DEF COACH_COACH_BRICK     EQU 38
DEF COACH_FUZZ            EQU 39
DEF COACH_KIDS            EQU 40
DEF COACH_CAPTAIN_SHREVE  EQU 41
DEF COACH_GM_ELSA         EQU 42
DEF COACH_GM_VENKMAN      EQU 43
DEF COACH_NOLAN1          EQU 44
DEF COACH_BEASTS          EQU 45
DEF COACHES_COUNT         EQU 46

CoachTiles:
  DW _GmAragonTiles
  DW _RangersTiles
  DW _RalphSotoTiles
  DW _DocHickoryTiles
  DW _OldtimersTiles
  DW _MechsTiles
  DW _JocksTiles
  DW _ScoutsTiles
  DW _SenorCanoTiles
  DW _CalvinTiles
  DW _BellaDonnaTiles
  DW _GmGandilTiles
  DW _SkipRiversTiles
  DW _CheerTiles
  DW _LadsTiles
  DW _QueensTiles
  DW _MinersTiles
  DW _ManiacsTiles
  DW _GreatZambinoTiles
  DW _TechsTiles
  DW _CatsTiles
  DW _Nolan0Tiles
  DW _SharksTiles
  DW _PsychosTiles
  DW _WhipsTiles
  DW _SmokeTiles
  DW _LuckTiles
  DW _BullsTiles
  DW _LassesTiles
  DW _SailorsTiles
  DW _GhostsTiles
  DW _ClownsTiles
  DW _SwimmersTiles
  DW _FightersTiles
  DW _RocketsTiles
  DW _BirdsTiles
  DW _Nolan2Tiles
  DW _GmWuTiles
  DW _CoachBrickTiles
  DW _FuzzTiles
  DW _KidsTiles
  DW _CaptainShreveTiles
  DW _GmElsaTiles
  DW _GmVenkmanTiles
  DW _Nolan1Tiles
  DW _BeastsTiles

CoachTileMaps:
  DW _GmAragonTileMap
  DW _RangersTileMap
  DW _RalphSotoTileMap
  DW _DocHickoryTileMap
  DW _OldtimersTileMap
  DW _MechsTileMap
  DW _JocksTileMap
  DW _ScoutsTileMap
  DW _SenorCanoTileMap
  DW _CalvinTileMap
  DW _BellaDonnaTileMap
  DW _GmGandilTileMap
  DW _SkipRiversTileMap
  DW _CheerTileMap
  DW _LadsTileMap
  DW _QueensTileMap
  DW _MinersTileMap
  DW _ManiacsTileMap
  DW _GreatZambinoTileMap
  DW _TechsTileMap
  DW _CatsTileMap
  DW _Nolan0TileMap
  DW _SharksTileMap
  DW _PsychosTileMap
  DW _WhipsTileMap
  DW _SmokeTileMap
  DW _LuckTileMap
  DW _BullsTileMap
  DW _LassesTileMap
  DW _SailorsTileMap
  DW _GhostsTileMap
  DW _ClownsTileMap
  DW _SwimmersTileMap
  DW _FightersTileMap
  DW _RocketsTileMap
  DW _BirdsTileMap
  DW _Nolan2TileMap
  DW _GmWuTileMap
  DW _CoachBrickTileMap
  DW _FuzzTileMap
  DW _KidsTileMap
  DW _CaptainShreveTileMap
  DW _GmElsaTileMap
  DW _GmVenkmanTileMap
  DW _Nolan1TileMap
  DW _BeastsTileMap

CoachTileCounts:
  DB _GM_ARAGON_TILE_COUNT
  DB _RANGERS_TILE_COUNT
  DB _RALPH_SOTO_TILE_COUNT
  DB _DOC_HICKORY_TILE_COUNT
  DB _OLDTIMERS_TILE_COUNT
  DB _MECHS_TILE_COUNT
  DB _JOCKS_TILE_COUNT
  DB _SCOUTS_TILE_COUNT
  DB _SENOR_CANO_TILE_COUNT
  DB _CALVIN_TILE_COUNT
  DB _BELLA_DONNA_TILE_COUNT
  DB _GM_GANDIL_TILE_COUNT
  DB _SKIP_RIVERS_TILE_COUNT
  DB _CHEER_TILE_COUNT
  DB _LADS_TILE_COUNT
  DB _QUEENS_TILE_COUNT
  DB _MINERS_TILE_COUNT
  DB _MANIACS_TILE_COUNT
  DB _GREAT_ZAMBINO_TILE_COUNT
  DB _TECHS_TILE_COUNT
  DB _CATS_TILE_COUNT
  DB _NOLAN0_TILE_COUNT
  DB _SHARKS_TILE_COUNT
  DB _PSYCHOS_TILE_COUNT
  DB _WHIPS_TILE_COUNT
  DB _SMOKE_TILE_COUNT
  DB _LUCK_TILE_COUNT
  DB _BULLS_TILE_COUNT
  DB _LASSES_TILE_COUNT
  DB _SAILORS_TILE_COUNT
  DB _GHOSTS_TILE_COUNT
  DB _CLOWNS_TILE_COUNT
  DB _SWIMMERS_TILE_COUNT
  DB _FIGHTERS_TILE_COUNT
  DB _ROCKETS_TILE_COUNT
  DB _BIRDS_TILE_COUNT
  DB _NOLAN2_TILE_COUNT
  DB _GM_WU_TILE_COUNT
  DB _COACH_BRICK_TILE_COUNT
  DB _FUZZ_TILE_COUNT
  DB _KIDS_TILE_COUNT
  DB _CAPTAIN_SHREVE_TILE_COUNT
  DB _GM_ELSA_TILE_COUNT
  DB _GM_VENKMAN_TILE_COUNT
  DB _NOLAN1_TILE_COUNT
  DB _BEASTS_TILE_COUNT

CoachColors:
  DW _GmAragonColors
  DW _RangersColors
  DW _RalphSotoColors
  DW _DocHickoryColors
  DW _OldtimersColors
  DW _MechsColors
  DW _JocksColors
  DW _ScoutsColors
  DW _SenorCanoColors
  DW _CalvinColors
  DW _BellaDonnaColors
  DW _GmGandilColors
  DW _SkipRiversColors
  DW _CheerColors
  DW _LadsColors
  DW _QueensColors
  DW _MinersColors
  DW _ManiacsColors
  DW _GreatZambinoColors
  DW _TechsColors
  DW _CatsColors
  DW _Nolan0Colors
  DW _SharksColors
  DW _PsychosColors
  DW _WhipsColors
  DW _SmokeColors
  DW _LuckColors
  DW _BullsColors
  DW _LassesColors
  DW _SailorsColors
  DW _GhostsColors
  DW _ClownsColors
  DW _SwimmersColors
  DW _FightersColors
  DW _RocketsColors
  DW _BirdsColors
  DW _Nolan2Colors
  DW _GmWuColors
  DW _CoachBrickColors
  DW _FuzzColors
  DW _KidsColors
  DW _CaptainShreveColors
  DW _GmElsaColors
  DW _GmVenkmanColors
  DW _Nolan1Colors
  DW _BeastsColors

CoachPaletteMaps:
  DW _GmAragonPaletteMap
  DW _RangersPaletteMap
  DW _RalphSotoPaletteMap
  DW _DocHickoryPaletteMap
  DW _OldtimersPaletteMap
  DW _MechsPaletteMap
  DW _JocksPaletteMap
  DW _ScoutsPaletteMap
  DW _SenorCanoPaletteMap
  DW _CalvinPaletteMap
  DW _BellaDonnaPaletteMap
  DW _GmGandilPaletteMap
  DW _SkipRiversPaletteMap
  DW _CheerPaletteMap
  DW _LadsPaletteMap
  DW _QueensPaletteMap
  DW _MinersPaletteMap
  DW _ManiacsPaletteMap
  DW _GreatZambinoPaletteMap
  DW _TechsPaletteMap
  DW _CatsPaletteMap
  DW _Nolan0PaletteMap
  DW _SharksPaletteMap
  DW _PsychosPaletteMap
  DW _WhipsPaletteMap
  DW _SmokePaletteMap
  DW _LuckPaletteMap
  DW _BullsPaletteMap
  DW _LassesPaletteMap
  DW _SailorsPaletteMap
  DW _GhostsPaletteMap
  DW _ClownsPaletteMap
  DW _SwimmersPaletteMap
  DW _FightersPaletteMap
  DW _RocketsPaletteMap
  DW _BirdsPaletteMap
  DW _Nolan2PaletteMap
  DW _GmWuPaletteMap
  DW _CoachBrickPaletteMap
  DW _FuzzPaletteMap
  DW _KidsPaletteMap
  DW _CaptainShrevePaletteMap
  DW _GmElsaPaletteMap
  DW _GmVenkmanPaletteMap
  DW _Nolan1PaletteMap
  DW _BeastsPaletteMap

CoachPaletteCounts:
  DB _GM_ARAGON_PALETTE_COUNT
  DB _RANGERS_PALETTE_COUNT
  DB _RALPH_SOTO_PALETTE_COUNT
  DB _DOC_HICKORY_PALETTE_COUNT
  DB _OLDTIMERS_PALETTE_COUNT
  DB _MECHS_PALETTE_COUNT
  DB _JOCKS_PALETTE_COUNT
  DB _SCOUTS_PALETTE_COUNT
  DB _SENOR_CANO_PALETTE_COUNT
  DB _CALVIN_PALETTE_COUNT
  DB _BELLA_DONNA_PALETTE_COUNT
  DB _GM_GANDIL_PALETTE_COUNT
  DB _SKIP_RIVERS_PALETTE_COUNT
  DB _CHEER_PALETTE_COUNT
  DB _LADS_PALETTE_COUNT
  DB _QUEENS_PALETTE_COUNT
  DB _MINERS_PALETTE_COUNT
  DB _MANIACS_PALETTE_COUNT
  DB _GREAT_ZAMBINO_PALETTE_COUNT
  DB _TECHS_PALETTE_COUNT
  DB _CATS_PALETTE_COUNT
  DB _NOLAN0_PALETTE_COUNT
  DB _SHARKS_PALETTE_COUNT
  DB _PSYCHOS_PALETTE_COUNT
  DB _WHIPS_PALETTE_COUNT
  DB _SMOKE_PALETTE_COUNT
  DB _LUCK_PALETTE_COUNT
  DB _BULLS_PALETTE_COUNT
  DB _LASSES_PALETTE_COUNT
  DB _SAILORS_PALETTE_COUNT
  DB _GHOSTS_PALETTE_COUNT
  DB _CLOWNS_PALETTE_COUNT
  DB _SWIMMERS_PALETTE_COUNT
  DB _FIGHTERS_PALETTE_COUNT
  DB _ROCKETS_PALETTE_COUNT
  DB _BIRDS_PALETTE_COUNT
  DB _NOLAN2_PALETTE_COUNT
  DB _GM_WU_PALETTE_COUNT
  DB _COACH_BRICK_PALETTE_COUNT
  DB _FUZZ_PALETTE_COUNT
  DB _KIDS_PALETTE_COUNT
  DB _CAPTAIN_SHREVE_PALETTE_COUNT
  DB _GM_ELSA_PALETTE_COUNT
  DB _GM_VENKMAN_PALETTE_COUNT
  DB _NOLAN1_PALETTE_COUNT
  DB _BEASTS_PALETTE_COUNT

CoachBanks:
  DB BANK(_GmAragonTiles)
  DB BANK(_RangersTiles)
  DB BANK(_RalphSotoTiles)
  DB BANK(_DocHickoryTiles)
  DB BANK(_OldtimersTiles)
  DB BANK(_MechsTiles)
  DB BANK(_JocksTiles)
  DB BANK(_ScoutsTiles)
  DB BANK(_SenorCanoTiles)
  DB BANK(_CalvinTiles)
  DB BANK(_BellaDonnaTiles)
  DB BANK(_GmGandilTiles)
  DB BANK(_SkipRiversTiles)
  DB BANK(_CheerTiles)
  DB BANK(_LadsTiles)
  DB BANK(_QueensTiles)
  DB BANK(_MinersTiles)
  DB BANK(_ManiacsTiles)
  DB BANK(_GreatZambinoTiles)
  DB BANK(_TechsTiles)
  DB BANK(_CatsTiles)
  DB BANK(_Nolan0Tiles)
  DB BANK(_SharksTiles)
  DB BANK(_PsychosTiles)
  DB BANK(_WhipsTiles)
  DB BANK(_SmokeTiles)
  DB BANK(_LuckTiles)
  DB BANK(_BullsTiles)
  DB BANK(_LassesTiles)
  DB BANK(_SailorsTiles)
  DB BANK(_GhostsTiles)
  DB BANK(_ClownsTiles)
  DB BANK(_SwimmersTiles)
  DB BANK(_FightersTiles)
  DB BANK(_RocketsTiles)
  DB BANK(_BirdsTiles)
  DB BANK(_Nolan2Tiles)
  DB BANK(_GmWuTiles)
  DB BANK(_CoachBrickTiles)
  DB BANK(_FuzzTiles)
  DB BANK(_KidsTiles)
  DB BANK(_CaptainShreveTiles)
  DB BANK(_GmElsaTiles)
  DB BANK(_GmVenkmanTiles)
  DB BANK(_Nolan1Tiles)
  DB BANK(_BeastsTiles)

