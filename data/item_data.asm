SECTION "Item Data", ROMX, BANK[ITEM_BANK]

DEF BASEBALL_ITEM EQU 1
DEF GAME_BALL_ITEM EQU 2
DEF SERIES_BALL_ITEM EQU 3
DEF PARK_BALL_ITEM EQU 4
DEF SIGNED_BALL_ITEM EQU 5
DEF X_BAT_ITEM EQU 6
DEF X_FIELD_ITEM EQU 7
DEF X_SPEED_ITEM EQU 8
DEF X_THROW_ITEM EQU 9
DEF GUARD_SPEC_ITEM EQU 10
DEF DIRE_HIT_ITEM EQU 11
DEF X_ACCURACY_ITEM EQU 12
DEF X_CONTACT_ITEM EQU 13
DEF CUTOUT_ITEM EQU 14
DEF HM01_ITEM EQU 15
DEF HM02_ITEM EQU 16
DEF HM03_ITEM EQU 17
DEF HM04_ITEM EQU 18
DEF HM05_ITEM EQU 19
DEF TM01_ITEM EQU 20
DEF TM02_ITEM EQU 21
DEF TM03_ITEM EQU 22
DEF TM04_ITEM EQU 23
DEF TM05_ITEM EQU 24
DEF TM06_ITEM EQU 25
DEF TM07_ITEM EQU 26
DEF TM08_ITEM EQU 27
DEF TM09_ITEM EQU 28
DEF TM10_ITEM EQU 29
DEF TM11_ITEM EQU 30
DEF TM12_ITEM EQU 31
DEF TM13_ITEM EQU 32
DEF TM14_ITEM EQU 33
DEF TM15_ITEM EQU 34
DEF TM16_ITEM EQU 35
DEF TM17_ITEM EQU 36
DEF TM18_ITEM EQU 37
DEF TM19_ITEM EQU 38
DEF TM20_ITEM EQU 39
DEF TM21_ITEM EQU 40
DEF TM22_ITEM EQU 41
DEF TM23_ITEM EQU 42
DEF TM24_ITEM EQU 43
DEF TM25_ITEM EQU 44
DEF TM26_ITEM EQU 45
DEF TM27_ITEM EQU 46
DEF TM28_ITEM EQU 47
DEF TM29_ITEM EQU 48
DEF TM30_ITEM EQU 49
DEF TM31_ITEM EQU 50
DEF TM32_ITEM EQU 51
DEF TM33_ITEM EQU 52
DEF TM34_ITEM EQU 53
DEF TM35_ITEM EQU 54
DEF TM36_ITEM EQU 55
DEF TM37_ITEM EQU 56
DEF TM38_ITEM EQU 57
DEF TM39_ITEM EQU 58
DEF TM40_ITEM EQU 59
DEF TM41_ITEM EQU 60
DEF TM42_ITEM EQU 61
DEF TM43_ITEM EQU 62
DEF TM44_ITEM EQU 63
DEF TM45_ITEM EQU 64
DEF TM46_ITEM EQU 65
DEF TM47_ITEM EQU 66
DEF TM48_ITEM EQU 67
DEF TM49_ITEM EQU 68
DEF TM50_ITEM EQU 69
DEF STEROIDS_ITEM EQU 70
DEF HGH_ITEM EQU 71
DEF PROTEIN_ITEM EQU 72
DEF IRON_ITEM EQU 73
DEF CARBOS_ITEM EQU 74
DEF CALCIUM_ITEM EQU 75
DEF PP_UP_ITEM EQU 76
DEF NUGGET_ITEM EQU 77
DEF HELIX_JERSEY_ITEM EQU 78
DEF DOME_HELMET_ITEM EQU 79
DEF OLD_HAT_ITEM EQU 80
DEF TOWN_MAP_ITEM EQU 81
DEF GOLD_TEETH_ITEM EQU 82
DEF SS_TICKET_ITEM EQU 83
DEF DREAM_SCOPE_ITEM EQU 84
DEF HARMONICA_ITEM EQU 85
DEF OLD_ROD_ITEM EQU 86
DEF GOOD_ROD_ITEM EQU 87
DEF SUPER_ROD_ITEM EQU 88
DEF ITEMFINDER_ITEM EQU 89
DEF EXP_ALL_ITEM EQU 90
DEF TOKEN_CASE_ITEM EQU 91
DEF FIRE_GLOVE_ITEM EQU 92
DEF SPARK_GLOVE_ITEM EQU 93
DEF WATER_GLOVE_ITEM EQU 94
DEF LEAF_GLOVE_ITEM EQU 95
DEF MOON_GLOVE_ITEM EQU 96
DEF ANTIDOTE_ITEM EQU 97
DEF BURN_HEAL_ITEM EQU 98
DEF ICE_HEAL_ITEM EQU 99
DEF AWAKENING_ITEM EQU 100
DEF PARLYZ_HEAL_ITEM EQU 101
DEF FULL_HEAL_ITEM EQU 102
DEF POTION_ITEM EQU 103
DEF SUPER_POTION_ITEM EQU 104
DEF HYPER_POTION_ITEM EQU 105
DEF MAX_POTION_ITEM EQU 106
DEF FULL_RESTORE_ITEM EQU 107
DEF REVIVE_ITEM EQU 108
DEF MAX_REVIVE_ITEM EQU 109
DEF WATER_ITEM EQU 110
DEF BEER_ITEM EQU 111
DEF SPORT_ADE_ITEM EQU 112
DEF BICYCLE_ITEM EQU 113
DEF ESCAPE_ROPE_ITEM EQU 114
DEF REPEL_ITEM EQU 115
DEF SUPER_REPEL_ITEM EQU 116
DEF MAX_REPEL_ITEM EQU 117

BaseballItem:;Used to recruit Players. The cost is reasonable.
DB BASEBALL_ITEM
DB ITEM_TYPE_BASEBALL
DW 3 ;cost

GameBallItem:;Regulation Game balls perform better than cheap balls.
DB GAME_BALL_ITEM
DB ITEM_TYPE_BASEBALL
DW 15 ;cost

SeriesBallItem:;Post-season Series balls perform better than a Game Ball.
DB SERIES_BALL_ITEM
DB ITEM_TYPE_BASEBALL
DW 50 ;cost

ParkBallItem:;This special ball is for recruiting Players in Strike Zone.
DB PARK_BALL_ITEM
DB ITEM_TYPE_BASEBALL
DW 0 ;can't be sold

SignedBallItem:;This ball can recruit Players 100% of the time.
DB SIGNED_BALL_ITEM
DB ITEM_TYPE_BASEBALL
DW 0 ;can't be sold

XBatItem:;Available only in games, batting ability will increase.
DB X_BAT_ITEM
DB ITEM_TYPE_GAME
DW 100 ;cost
DB STAT_BAT
DW 2;change

XFieldItem:;Available only in games, field ability will increase.
DB X_FIELD_ITEM
DB ITEM_TYPE_GAME
DW 100 ;cost
DB STAT_FIELD
DW 2;change

XSpeedItem:;Available only in games, speed will increase.
DB X_SPEED_ITEM
DB ITEM_TYPE_GAME
DW 100 ;cost
DB STAT_SPEED
DW 2;change

XThrowItem:;In a game, throwing ability will increase.
DB X_THROW_ITEM
DB ITEM_TYPE_GAME
DW 100 ;cost
DB STAT_THROW
DW 2;change

GuardSpecItem:;In a game, the opposing Player can’t use special abilities.
DB GUARD_SPEC_ITEM
DB ITEM_TYPE_GAME
DW 100 ;cost
DB STAT_SPECIAL

DireHitItem:;In a game, your swings will be more effective.
DB DIRE_HIT_ITEM
DB ITEM_TYPE_GAME
DW 100 ;cost
DB STAT_CRIT

XAccuracyItem:;In a game, your pitching accuracy will increase.
DB X_ACCURACY_ITEM
DB ITEM_TYPE_GAME
DW 100 ;cost
DB STAT_ACCURACY

XContactItem:;In a game, your hitting contact will increase.
DB X_CONTACT_ITEM
DB ITEM_TYPE_GAME
DW 100 ;cost
DB STAT_CONTACT

CutoutItem:;A cardboard cutout of a Player. Try using it in a game.
DB CUTOUT_ITEM
DB ITEM_TYPE_GAME
DW 0 ;can't be sold

HM01Item:;
DB HM01_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB CUT_MOVE

HM02Item:;
DB HM02_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB FLY_MOVE

HM03Item:;
DB HM03_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SURF_MOVE

HM04Item:;
DB HM04_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB STRENGTH_MOVE

HM05Item:;
DB HM05_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB FLASH_MOVE

TM01Item:;
DB TM01_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB KNUCKLECURVE_MOVE

TM02Item:;
DB TM02_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB EEPHUS_PITCH_MOVE

TM03Item:;
DB TM03_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SLURVE_MOVE

TM04Item:;
DB TM04_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SCREWBALL_MOVE

TM05Item:;
DB TM05_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB FOSH_MOVE

TM06Item:;
DB TM06_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB FILTH_MOVE

TM07Item:;
DB TM07_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB PALMBALL_MOVE

TM08Item:;
DB TM08_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SINKER_MOVE

TM09Item:;
DB TM09_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB FORKBALL_MOVE

TM10Item:;
DB TM10_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB TWO_SEAM_MOVE

TM11Item:;
DB TM11_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB BUBBLEBALL_MOVE

TM12Item:;
DB TM12_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SPITBALL_MOVE

TM13Item:;
DB TM13_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB FROZEN_ROPE_MOVE

TM14Item:;
DB TM14_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SHIVER_MOVE

TM15Item:;
DB TM15_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SMASH_MOVE

TM16Item:;
DB TM16_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB MONEYBALL_MOVE

TM17Item:;
DB TM17_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB BRUSHBACK_MOVE

TM18Item:;
DB TM18_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB COMEBACKER_MOVE

TM19Item:;
DB TM19_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB BEANBALL_MOVE

TM20Item:;
DB TM20_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB RAGE_MOVE

TM21Item:;
DB TM21_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB KUDZUBALL_MOVE

TM22Item:;
DB TM22_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB PLANT_N_TURN_MOVE

TM23Item:;
DB TM23_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB DRAGON_BUNT_MOVE

TM24Item:;
DB TM24_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB LIGHTNINBOLT_MOVE

TM25Item:;
DB TM25_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB THUNDERSTICK_MOVE

TM26Item:;
DB TM26_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SPELUNKER_MOVE

TM27Item:;
DB TM27_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB CRACK_MOVE

TM28Item:;
DB TM28_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB DIG_IN_MOVE

TM29Item:;
DB TM29_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB KINESIS_MOVE

TM30Item:;
DB TM30_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB BLINK_MOVE

TM31Item:;
DB TM31_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB STUDY_MOVE

TM32Item:;
DB TM32_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SPLITTER_MOVE

TM33Item:;
DB TM33_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB PREDICT_MOVE

TM34Item:;
DB TM34_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB CHANT_MOVE

TM35Item:;
DB TM35_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB KNUCKLEBALL_MOVE

TM36Item:;
DB TM36_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SEPPUKUBALL_MOVE

TM37Item:;
DB TM37_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB BOMB_MOVE

TM38Item:;
DB TM38_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB HIGH_HEAT_MOVE

TM39Item:;
DB TM39_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SWAT_MOVE

TM40Item:;
DB TM40_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB BASH_MOVE

TM41Item:;
DB TM41_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SOFT_TOSS_MOVE

TM42Item:;
DB TM42_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB BRAIN_MELTER_MOVE

TM43Item:;
DB TM43_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SKY_SMASH_MOVE

TM44Item:;
DB TM44_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB REST_MOVE

TM45Item:;
DB TM45_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB THUNDERBALL_MOVE

TM46Item:;
DB TM46_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB PSYCH_OUT_MOVE

TM47Item:;
DB TM47_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB EXPLODE_MOVE

TM48Item:;
DB TM48_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB ROCK_SLIDER_MOVE

TM49Item:;
DB TM49_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB THREE_SEAM_MOVE

TM50Item:;
DB TM50_ITEM
DB ITEM_TYPE_MOVE
DW 0 ;can't be sold
DB SUBMARINE_MOVE

SteroidsItem:;Increases Player’s level by 1.
DB STEROIDS_ITEM
DB ITEM_TYPE_STATS
DW 10000 ;cost
DB STAT_AGE
DW 1;change

HGHItem:;HP level will increase.
DB HGH_ITEM
DB ITEM_TYPE_STATS
DW 8000 ;cost
DB STAT_MAXHP
DW 1;change

ProteinItem:;Batting ability points will increase.
DB PROTEIN_ITEM
DB ITEM_TYPE_STATS
DW 2000 ;cost
DB STAT_BAT
DW 1;change

IronItem:;Fielding ability points will increase.
DB IRON_ITEM
DB ITEM_TYPE_STATS
DW 2000 ;cost
DB STAT_FIELD
DW 1;change

CarbosItem:;Speed points will increase.
DB CARBOS_ITEM
DB ITEM_TYPE_STATS
DW 2000 ;cost
DB STAT_SPEED
DW 1;change

CalciumItem:;Throwing ability points will increase.
DB CALCIUM_ITEM
DB ITEM_TYPE_STATS
DW 2000 ;cost
DB STAT_THROW
DW 1;change

PPUpItem:;PP level will increase.
DB PP_UP_ITEM
DB ITEM_TYPE_STATS
DW 5000 ;cost
DB STAT_MAXPP
DW 1;change

NuggetItem:;This item is not very effective unless you’re after gold.
DB NUGGET_ITEM
DB ITEM_TYPE_SELL
DW 50000 ;cost

HelixJerseyItem:;You will need to find the secret of this item.
DB HELIX_JERSEY_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

DomeHelmetItem:;You will need to find the secret of this item.
DB DOME_HELMET_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

OldHatItem:;You will need to find the secret of this item.
DB OLD_HAT_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

TownMapItem:;This map will help you navigate the world of Baseball.
DB TOWN_MAP_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

GoldTeethItem:;These belong to the warden of Strike Zone.
DB GOLD_TEETH_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

SSTicketItem:;A boarding ticket for the S.S. Manny.
DB SS_TICKET_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

DreamScopeItem:;This allows you to identify a ghostly Player.
DB DREAM_SCOPE_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

HarmonicaItem:;It wakes up sleeping Players. It’s handy during games.
DB HARMONICA_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

OldRodItem:;Use this rod to fish with water Players.
DB OLD_ROD_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

GoodRodItem:;This rod can recruit Players that the OLD ROD can’t.
DB GOOD_ROD_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

SuperRodItem:;The best rod. It recruits Players that the other rods can’t.
DB SUPER_ROD_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

ItemfinderItem:;This handy machine helps you find items.
DB ITEMFINDER_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

ExpAllItem:;Share experience with Players who didn’t play.
DB EXP_ALL_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

TokenCaseItem:;Save a maximum of 9,999 tokens in this.
DB TOKEN_CASE_ITEM
DB ITEM_TYPE_SPECIAL
DW 0 ;can't be sold

FireGloveItem:;This glove has a connection to Fire Players.
DB FIRE_GLOVE_ITEM
DB ITEM_TYPE_STATS
DW 10000 ;cost
DB STAT_EVOLVE

SparkGloveItem:;This glove has a connection to Electric Players.
DB SPARK_GLOVE_ITEM
DB ITEM_TYPE_STATS
DW 10000 ;cost
DB STAT_EVOLVE

WaterGloveItem:;This glove has a connection to Water Players.
DB WATER_GLOVE_ITEM
DB ITEM_TYPE_STATS
DW 10000 ;cost
DB STAT_EVOLVE

LeafGloveItem:;This glove has a connection to Grass Players.
DB LEAF_GLOVE_ITEM
DB ITEM_TYPE_STATS
DW 10000 ;cost
DB STAT_EVOLVE

MoonGloveItem:;This glove has a connection to ? Players.
DB MOON_GLOVE_ITEM
DB ITEM_TYPE_STATS
DW 0 ;can't be sold
DB STAT_EVOLVE

AntidoteItem:;This removes poison from a Player
DB ANTIDOTE_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_STATUS_PSN

BurnHealItem:;This heals a Player that is burned.
DB BURN_HEAL_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_STATUS_BRN

IceHealItem:;Thaws a frozen Player.
DB ICE_HEAL_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_STATUS_FRZ

AwakeningItem:;This wakes up a sleeping Player.
DB AWAKENING_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_STATUS_SLP

ParlyzHealItem:;This heals a paralyzed Player.
DB PARLYZ_HEAL_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_STATUS_PAR

FullHealItem:;This will heal all of the conditions stated above.
DB FULL_HEAL_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_STATUS_ALL

PotionItem:;This will restore some HP.
DB POTION_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_HP
DW 20;change

SuperPotionItem:;This will restore more HP than a POTION.
DB SUPER_POTION_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_HP
DW 50;change

HyperPotionItem:;This will restore more HP than a SUPER POTION.
DB HYPER_POTION_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_HP
DW 100;change

MaxPotionItem:;This restores HP to its maximum.
DB MAX_POTION_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_HP
DW 500;change

FullRestoreItem:;This will heal all conditions and fully restore HP.
DB FULL_RESTORE_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_ALL

ReviveItem:;This will revive an exhausted Player and restore ½ HP.
DB REVIVE_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_REVIVE
DW 50;change

MaxReviveItem:;This will revive an exhausted Player and fully restore HP.
DB MAX_REVIVE_ITEM
DB ITEM_TYPE_STATS
DW 100 ;cost
DB STAT_REVIVE
DW 500;change

WaterItem:;During a game, it will restore HP a little.
DB WATER_ITEM
DB ITEM_TYPE_STATS
DW 1 ;cost
DB STAT_HP
DW 10;change

BeerItem:;During a game, it will restore HP a lot.
DB BEER_ITEM
DB ITEM_TYPE_STATS
DW 5 ;cost
DB STAT_HP
DW 50;change

SportAdeItem:;During a game, it will restore HP a lot more.
DB SPORT_ADE_ITEM
DB ITEM_TYPE_STATS
DW 8 ;cost
DB STAT_HP
DW 100;change

BicycleItem:;This is too expensive for a child to buy.
DB BICYCLE_ITEM
DB ITEM_TYPE_WORLD
DW 0 ;can't be sold

EscapeRopeItem:;This rope can pull you out of a cave instantly.
DB ESCAPE_ROPE_ITEM
DB ITEM_TYPE_WORLD
DW 100 ;cost

RepelItem:;Spray on and weak Players will avoid you for a while.
DB REPEL_ITEM
DB ITEM_TYPE_WORLD
DW 100 ;cost

SuperRepelItem:;This spray lasts longer than REPEL.
DB SUPER_REPEL_ITEM
DB ITEM_TYPE_WORLD
DW 1000 ;cost

MaxRepelItem:;This spray lasts longer than SUPER REPEL.
DB MAX_REPEL_ITEM
DB ITEM_TYPE_WORLD
DW 10000 ;cost

ItemList:
DW BaseballItem
DW GameBallItem
DW SeriesBallItem
DW ParkBallItem
DW SignedBallItem
DW XBatItem
DW XFieldItem
DW XSpeedItem
DW XThrowItem
DW GuardSpecItem
DW DireHitItem
DW XAccuracyItem
DW XContactItem
DW CutoutItem
DW HM01Item
DW HM02Item
DW HM03Item
DW HM04Item
DW HM05Item
DW TM01Item
DW TM02Item
DW TM03Item
DW TM04Item
DW TM05Item
DW TM06Item
DW TM07Item
DW TM08Item
DW TM09Item
DW TM10Item
DW TM11Item
DW TM12Item
DW TM13Item
DW TM14Item
DW TM15Item
DW TM16Item
DW TM17Item
DW TM18Item
DW TM19Item
DW TM20Item
DW TM21Item
DW TM22Item
DW TM23Item
DW TM24Item
DW TM25Item
DW TM26Item
DW TM27Item
DW TM28Item
DW TM29Item
DW TM30Item
DW TM31Item
DW TM32Item
DW TM33Item
DW TM34Item
DW TM35Item
DW TM36Item
DW TM37Item
DW TM38Item
DW TM39Item
DW TM40Item
DW TM41Item
DW TM42Item
DW TM43Item
DW TM44Item
DW TM45Item
DW TM46Item
DW TM47Item
DW TM48Item
DW TM49Item
DW TM50Item
DW SteroidsItem
DW HGHItem
DW ProteinItem
DW IronItem
DW CarbosItem
DW CalciumItem
DW PPUpItem
DW NuggetItem
DW HelixJerseyItem
DW DomeHelmetItem
DW OldHatItem
DW TownMapItem
DW GoldTeethItem
DW SSTicketItem
DW DreamScopeItem
DW HarmonicaItem
DW OldRodItem
DW GoodRodItem
DW SuperRodItem
DW ItemfinderItem
DW ExpAllItem
DW TokenCaseItem
DW FireGloveItem
DW SparkGloveItem
DW WaterGloveItem
DW LeafGloveItem
DW MoonGloveItem
DW AntidoteItem
DW BurnHealItem
DW IceHealItem
DW AwakeningItem
DW ParlyzHealItem
DW FullHealItem
DW PotionItem
DW SuperPotionItem
DW HyperPotionItem
DW MaxPotionItem
DW FullRestoreItem
DW ReviveItem
DW MaxReviveItem
DW WaterItem
DW BeerItem
DW SportAdeItem
DW BicycleItem
DW EscapeRopeItem
DW RepelItem
DW SuperRepelItem
DW MaxRepelItem

