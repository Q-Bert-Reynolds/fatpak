SECTION "Item Data", ROMX, BANK[ITEM_BANK]

DEF BASEBALL_ITEM EQU 1
DEF GAME_BALL_ITEM EQU 2
DEF SERIES_BALL_ITEM EQU 3
DEF PARK_BALL_ITEM EQU 4
DEF PERFECT_BALL_ITEM EQU 5
DEF X_BAT_ITEM EQU 6
DEF X_FIELD_ITEM EQU 7
DEF X_SPEED_ITEM EQU 8
DEF X_THROW_ITEM EQU 9
DEF GUARD_SPEC_ITEM EQU 10
DEF DIRE_HIT_ITEM EQU 11
DEF X_ACCURACY_ITEM EQU 12
DEF CUTOUT_ITEM EQU 13
DEF HM01_ITEM EQU 14
DEF HM02_ITEM EQU 15
DEF HM03_ITEM EQU 16
DEF HM04_ITEM EQU 17
DEF HM05_ITEM EQU 18
DEF TM01_ITEM EQU 19
DEF TM02_ITEM EQU 20
DEF TM03_ITEM EQU 21
DEF TM04_ITEM EQU 22
DEF TM05_ITEM EQU 23
DEF TM06_ITEM EQU 24
DEF TM07_ITEM EQU 25
DEF TM08_ITEM EQU 26
DEF TM09_ITEM EQU 27
DEF TM10_ITEM EQU 28
DEF TM11_ITEM EQU 29
DEF TM12_ITEM EQU 30
DEF TM13_ITEM EQU 31
DEF TM14_ITEM EQU 32
DEF TM15_ITEM EQU 33
DEF TM16_ITEM EQU 34
DEF TM17_ITEM EQU 35
DEF TM18_ITEM EQU 36
DEF TM19_ITEM EQU 37
DEF TM20_ITEM EQU 38
DEF TM21_ITEM EQU 39
DEF TM22_ITEM EQU 40
DEF TM23_ITEM EQU 41
DEF TM24_ITEM EQU 42
DEF TM25_ITEM EQU 43
DEF TM26_ITEM EQU 44
DEF TM27_ITEM EQU 45
DEF TM28_ITEM EQU 46
DEF TM29_ITEM EQU 47
DEF TM30_ITEM EQU 48
DEF TM31_ITEM EQU 49
DEF TM32_ITEM EQU 50
DEF TM33_ITEM EQU 51
DEF TM34_ITEM EQU 52
DEF TM35_ITEM EQU 53
DEF TM36_ITEM EQU 54
DEF TM37_ITEM EQU 55
DEF TM38_ITEM EQU 56
DEF TM39_ITEM EQU 57
DEF TM40_ITEM EQU 58
DEF TM41_ITEM EQU 59
DEF TM42_ITEM EQU 60
DEF TM43_ITEM EQU 61
DEF TM44_ITEM EQU 62
DEF TM45_ITEM EQU 63
DEF TM46_ITEM EQU 64
DEF TM47_ITEM EQU 65
DEF TM48_ITEM EQU 66
DEF TM49_ITEM EQU 67
DEF TM50_ITEM EQU 68
DEF STEROIDS_ITEM EQU 69
DEF HGH_ITEM EQU 70
DEF PROTEIN_ITEM EQU 71
DEF IRON_ITEM EQU 72
DEF UPPERS_ITEM EQU 73
DEF ACID_ITEM EQU 74
DEF PP_UP_ITEM EQU 75
DEF NUGGET_ITEM EQU 76
DEF HELIX_JERSEY_ITEM EQU 77
DEF DOME_HELMET_ITEM EQU 78
DEF OLD_HAT_ITEM EQU 79
DEF TOWN_MAP_ITEM EQU 80
DEF GOLD_TEETH_ITEM EQU 81
DEF SS_TICKET_ITEM EQU 82
DEF SAPHE_SCOPE_ITEM EQU 83
DEF WHISTLE_ITEM EQU 84
DEF OLD_ROD_ITEM EQU 85
DEF GOOD_ROD_ITEM EQU 86
DEF SUPER_ROD_ITEM EQU 87
DEF ITEMFINDER_ITEM EQU 88
DEF EXP_ALL_ITEM EQU 89
DEF TOKEN_CASE_ITEM EQU 90
DEF TOKEN_ITEM EQU 91
DEF BIKE_VOUCHER_ITEM EQU 92
DEF CARD_KEY_ITEM EQU 93
DEF LIFT_KEY_ITEM EQU 94
DEF SECRET_KEY_ITEM EQU 95
DEF DOCS_PACKAGE_ITEM EQU 96
DEF ROLEDEX_ITEM EQU 97
DEF BICYCLE_ITEM EQU 98
DEF FIRE_BALL_ITEM EQU 99
DEF THUNDER_BAT_ITEM EQU 100
DEF WATER_GLOVE_ITEM EQU 101
DEF GRASS_GRIP_ITEM EQU 102
DEF MOON_SHOES_ITEM EQU 103
DEF ETHER_ITEM EQU 104
DEF ELIXER_ITEM EQU 105
DEF MAX_ETHER_ITEM EQU 106
DEF MAX_ELIXER_ITEM EQU 107
DEF ANTIDOTE_ITEM EQU 108
DEF ALOE_VERA_ITEM EQU 109
DEF ANTI_FREEZE_ITEM EQU 110
DEF SMELLING_SALTS_ITEM EQU 111
DEF BUZZ_KILL_ITEM EQU 112
DEF FULL_HEAL_ITEM EQU 113
DEF POTION_ITEM EQU 114
DEF SUPER_POTION_ITEM EQU 115
DEF HYPER_POTION_ITEM EQU 116
DEF MAX_POTION_ITEM EQU 117
DEF FULL_RESTORE_ITEM EQU 118
DEF REVIVE_ITEM EQU 119
DEF MAX_REVIVE_ITEM EQU 120
DEF WATER_ITEM EQU 121
DEF BEER_ITEM EQU 122
DEF SPORT_ADE_ITEM EQU 123
DEF ESCAPE_ROPE_ITEM EQU 124
DEF REPEL_ITEM EQU 125
DEF SUPER_REPEL_ITEM EQU 126
DEF MAX_REPEL_ITEM EQU 127

BaseballItem:;Used to recruit Players. The cost is reasonable.
DB BASEBALL_ITEM
DB ITEM_TYPE_BASEBALL
D32 3 ;cost

GameBallItem:;Regulation Game balls perform better than cheap balls.
DB GAME_BALL_ITEM
DB ITEM_TYPE_BASEBALL
D32 15 ;cost

SeriesBallItem:;Post-season Series balls perform better than a Game Ball.
DB SERIES_BALL_ITEM
DB ITEM_TYPE_BASEBALL
D32 50 ;cost

ParkBallItem:;This special ball is for recruiting Players in Strike Zone.
DB PARK_BALL_ITEM
DB ITEM_TYPE_BASEBALL
D32 0 ;can't be sold

PerfectBallItem:;This ball can recruit Players 100% of the time.
DB PERFECT_BALL_ITEM
DB ITEM_TYPE_BASEBALL
D32 0 ;can't be sold

XBatItem:;Boosts Bat temporarily
DB X_BAT_ITEM
DB ITEM_TYPE_GAME
D32 500 ;cost
DB STAT_BAT
DW 2;change

XFieldItem:;Boosts Field temporarily
DB X_FIELD_ITEM
DB ITEM_TYPE_GAME
D32 550 ;cost
DB STAT_FIELD
DW 2;change

XSpeedItem:;Boosts Speed temporarily
DB X_SPEED_ITEM
DB ITEM_TYPE_GAME
D32 350 ;cost
DB STAT_SPEED
DW 2;change

XThrowItem:;Boosts Throw temporarily
DB X_THROW_ITEM
DB ITEM_TYPE_GAME
D32 350 ;cost
DB STAT_THROW
DW 2;change

GuardSpecItem:;Disables Throw modifiers
DB GUARD_SPEC_ITEM
DB ITEM_TYPE_GAME
D32 100 ;cost
DB STAT_SPECIAL

DireHitItem:;Boosts move effectiveness
DB DIRE_HIT_ITEM
DB ITEM_TYPE_GAME
D32 650 ;cost
DB STAT_CRIT

XAccuracyItem:;Boosts Accuracy temporarily
DB X_ACCURACY_ITEM
DB ITEM_TYPE_GAME
D32 950 ;cost
DB STAT_ACCURACY

CutoutItem:;A cardboard cutout to distract your opponent.
DB CUTOUT_ITEM
DB ITEM_TYPE_GAME
D32 1000 ;cost

HM01Item:;A good, hard swing.
DB HM01_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB CUT_MOVE

HM02Item:;No wall is too high to pull one back.
DB HM02_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB FLY_MOVE

HM03Item:;50% chance of avoiding the tag on a close play.
DB HM03_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SWIM_MOVE

HM04Item:;A big swing that can muscle anything deep.
DB HM04_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB MUSCLE_MOVE

HM05Item:;At just the right angle, you can blind the pitcher flashing a bunt. Lowers the pitcher's Accuracy by 1 stage.
DB HM05_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB FLASH_MOVE

TM01Item:;A faster than normal curveball thrown with the index knuckle on the ball.
DB TM01_ITEM
DB ITEM_TYPE_MOVE
D32 3000 ;cost
DB KNUCKLECURVE_MOVE

TM02Item:;A super slow pitch that drops through the strikezone. It often catches batters off guard.
DB TM02_ITEM
DB ITEM_TYPE_MOVE
D32 2000 ;cost
DB EEPHUS_PITCH_MOVE

TM03Item:;A curveball with more inward than downward motion.
DB TM03_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SLURVE_MOVE

TM04Item:;A curveball that breaks away from the pitcher instead of inward.
DB TM04_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SCREWBALL_MOVE

TM05Item:;A cross between a split-finger pitch and a straight change.
DB TM05_ITEM
DB ITEM_TYPE_MOVE
D32 3000 ;cost
DB FOSH_MOVE

TM06Item:;A filthy breaking changeup. Has a 30% chance to poison the batter.
DB TM06_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB FILTH_MOVE

TM07Item:;Same motion as a fastball, but much slower.
DB TM07_ITEM
DB ITEM_TYPE_MOVE
D32 2000 ;cost
DB PALMBALL_MOVE

TM08Item:;A fastball with a dropping spin. Has an increased risk of wild pitches.
DB TM08_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SINKER_MOVE

TM09Item:;A changeup thrown like a splitter. Breaks with a more gental downward motion.
DB TM09_ITEM
DB ITEM_TYPE_MOVE
D32 3000 ;cost
DB FORKBALL_MOVE

TM10Item:;A two-seam fastball. It tails away from the pitcher.
DB TM10_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB TWO_SEAM_MOVE

TM11Item:;A slippery pitch that floats like a bubble
DB TM11_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB BUBBLEBALL_MOVE

TM12Item:;A little spit on the fingers causes the ball to tumble forward. Can be wild.
DB TM12_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SPITBALL_MOVE

TM13Item:;A hard hit line drive that has a 10% chance of freezing the fielder.
DB TM13_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB FROZEN_ROPE_MOVE

TM14Item:;Takes a pitch. The batter's preocupation with how cold they've gotten protects them from negative stat modifier.
DB TM14_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SHIVER_MOVE

TM15Item:;A hard hit ball with a good lanuch angle. Batter takes the next pitch to recover.
DB TM15_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SMASH_MOVE

TM16Item:;Crowds pay big money to see this curve.
DB TM16_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB MONEYBALL_MOVE

TM17Item:;A four-seam fastball thrown inside. 50% chance of hitting batter. Can cause a batter to flinch.
DB TM17_ITEM
DB ITEM_TYPE_MOVE
D32 3000 ;cost
DB BRUSHBACK_MOVE

TM18Item:;Hard linedrive, right at the pitcher.
DB TM18_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB COMEBACKER_MOVE

TM19Item:;A four-seam fastball aimed right at the batter. 100% chance of hitting batter.
DB TM19_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB BEANBALL_MOVE

TM20Item:;Nothing but fastballs, each one thrown harder than the last.
DB TM20_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB RAGE_MOVE

TM21Item:;A fastball that's all over the place.
DB TM21_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB KUDZUBALL_MOVE

TM22Item:;Has a high critical hit ratio.
DB TM22_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB PLANT_N_TURN_MOVE

TM23Item:;A drag bunt that wears down the fielder 40 HP.
DB TM23_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB DRAGON_BUNT_MOVE

TM24Item:;A four-seam fastball that comes like a bolt of lightning.
DB TM24_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB LIGHTNING_MOVE

TM25Item:;Has a ~10% chance to paralyze the fielder the ball is hit to.
DB TM25_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB THUNDERSTICK_MOVE

TM26Item:;A forkball that takes a hard turn out of the strikezone at the last second.
DB TM26_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SPELUNKER_MOVE

TM27Item:;If it connects, it's gone.
DB TM27_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB CRACK_MOVE

TM28Item:;On the first pitch, the batter digs in. On the second pitch, the batter attacks anything close.
DB TM28_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB DIG_IN_MOVE

TM29Item:;Takes a pitch. Lowers the pitcher's Accuracy by 1 stage.
DB TM29_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB KINESIS_MOVE

TM30Item:;A fastball that seems to jump from the mound to the plate in the blink of an eye.
DB TM30_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB BLINK_MOVE

TM31Item:;Takes the pitch. Learns the pitch.
DB TM31_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB STUDY_MOVE

TM32Item:;A fastball thrown with the index and middle fingers split on either side of the ball. Looks like a four-seam until it drops off the table.
DB TM32_ITEM
DB ITEM_TYPE_MOVE
D32 1000 ;cost
DB SPLITTER_MOVE

TM33Item:;Takes a pitch. Increases the batter's critical hit ratio.
DB TM33_ITEM
DB ITEM_TYPE_MOVE
D32 1000 ;cost
DB PREDICT_MOVE

TM34Item:;Takes a pitch, steps out of the box, the crowd starts to chant. Pitcher sleeps on the runners.
DB TM34_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB CHANT_MOVE

TM35Item:;A tough-to-hit, tough-to-control offspeed pitch with little to no rotation on the ball.
DB TM35_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB KNUCKLEBALL_MOVE

TM36Item:;A hard thrown shuuto that destroy's the pitcher's shoulder.
DB TM36_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SEPPUKUBALL_MOVE

TM37Item:;A hard swing with a high launch angle.
DB TM37_ITEM
DB ITEM_TYPE_MOVE
D32 2000 ;cost
DB BOMB_MOVE

TM38Item:;Some serious heat up in the zone.
DB TM38_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB HIGH_HEAT_MOVE

TM39Item:;An ugly swing that always manages to make contact.
DB TM39_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SWAT_MOVE

TM40Item:;Takes a pitch, lowers their head, and swings hard on the next turn.
DB TM40_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB BASH_MOVE

TM41Item:;An eephus that restores half the pitcher's health.
DB TM41_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SOFT_TOSS_MOVE

TM42Item:;A fastball with a ~30% chance to lower the batter's Batting by 1 stage.
DB TM42_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB BRAIN_MELTER_MOVE

TM43Item:;Batter digs in, takes the first pitch, and smashes anything close on the second pitch.
DB TM43_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SKY_SMASH_MOVE

TM44Item:;Takes the next two pitches. Restores health fully.
DB TM44_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB REST_MOVE

TM45Item:;A deceiving offsepeed pitch.
DB TM45_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB THUNDERBALL_MOVE

TM46Item:;Takes a pitch. Lowers the pitcher's Throwing by 1 stage.
DB TM46_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB PSYCH_OUT_MOVE

TM47Item:;A fastball that takes everything a pitcher has left.
DB TM47_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB EXPLODE_MOVE

TM48Item:;A slider with with a heavy drop to it.
DB TM48_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB ROCK_SLIDER_MOVE

TM49Item:;A two-seam fastball with a little extra tail.
DB TM49_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB THREE_SEAM_MOVE

TM50Item:;A knuckle scraper. Starts at the knees and finishes high.
DB TM50_ITEM
DB ITEM_TYPE_MOVE
D32 0 ;can't be sold
DB SUBMARINE_MOVE

SteroidsItem:;Boosts experience level
DB STEROIDS_ITEM
DB ITEM_TYPE_STATS
D32 0 ;can't be sold
DB STAT_LEVEL
DW 1;change

HGHItem:;Boosts HP meter by one point
DB HGH_ITEM
DB ITEM_TYPE_STATS
D32 9800 ;cost
DB STAT_MAXHP
DW 1;change

ProteinItem:;Boosts Bat rating
DB PROTEIN_ITEM
DB ITEM_TYPE_STATS
D32 9800 ;cost
DB STAT_BAT
DW 1;change

IronItem:;Boosts Field rating
DB IRON_ITEM
DB ITEM_TYPE_STATS
D32 9800 ;cost
DB STAT_FIELD
DW 1;change

UppersItem:;Boosts Speed rating
DB UPPERS_ITEM
DB ITEM_TYPE_STATS
D32 9800 ;cost
DB STAT_SPEED
DW 1;change

AcidItem:;Boosts Throw rating
DB ACID_ITEM
DB ITEM_TYPE_STATS
D32 9800 ;cost
DB STAT_THROW
DW 1;change

PPUpItem:;Boosts PP meter by one point
DB PP_UP_ITEM
DB ITEM_TYPE_STATS
D32 9800 ;cost
DB STAT_MAXPP
DW 1;change

NuggetItem:;This item is not very effective unless you’re after gold.
DB NUGGET_ITEM
DB ITEM_TYPE_SELL
D32 50000 ;cost

HelixJerseyItem:;Used to clone a new Player
DB HELIX_JERSEY_ITEM
DB ITEM_TYPE_DNA
D32 0 ;can't be sold

DomeHelmetItem:;Used to clone a new Player
DB DOME_HELMET_ITEM
DB ITEM_TYPE_DNA
D32 0 ;can't be sold

OldHatItem:;Used to clone a new Player
DB OLD_HAT_ITEM
DB ITEM_TYPE_DNA
D32 0 ;can't be sold

TownMapItem:;This map will help you navigate the world of Baseball.
DB TOWN_MAP_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

GoldTeethItem:;Helps Warden speak
DB GOLD_TEETH_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

SSTicketItem:;A boarding ticket for the S.S. Manny.
DB SS_TICKET_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

SapheScopeItem:;This allows you to identify a ghostly Player.
DB SAPHE_SCOPE_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

WhistleItem:;It wakes up sleeping Players. It’s handy during games.
DB WHISTLE_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

OldRodItem:;Use this rod to fish with water Players.
DB OLD_ROD_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

GoodRodItem:;This rod can recruit Players that the OLD ROD can’t.
DB GOOD_ROD_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

SuperRodItem:;The best rod. It recruits Players that the other rods can’t.
DB SUPER_ROD_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

ItemfinderItem:;This handy machine helps you find items.
DB ITEMFINDER_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

ExpAllItem:;Share experience with Players who didn’t play.
DB EXP_ALL_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

TokenCaseItem:;Save a maximum of 9,999 tokens in this.
DB TOKEN_CASE_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

TokenItem:;Used to place bets
DB TOKEN_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

BikeVoucherItem:;Used to redeem a bike
DB BIKE_VOUCHER_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

CardKeyItem:;Opens Saphe Co. doors
DB CARD_KEY_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

LiftKeyItem:;Activates elevator
DB LIFT_KEY_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

SecretKeyItem:;Opens Pepper Island Stadium
DB SECRET_KEY_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

DocsPackageItem:;Belongs to Doc Hickory
DB DOCS_PACKAGE_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

RoledexItem:;Used to store scouting reports
DB ROLEDEX_ITEM
DB ITEM_TYPE_SPECIAL
D32 0 ;can't be sold

BicycleItem:;This is too expensive for a child to buy.
DB BICYCLE_ITEM
DB ITEM_TYPE_SPECIAL
D32 1000000000 ;cost

FireBallItem:;This glove has a connection to Fire Players.
DB FIRE_BALL_ITEM
DB ITEM_TYPE_STATS
D32 10000 ;cost
DB STAT_EVOLVE

ThunderBatItem:;This bat has a connection to Electric Players.
DB THUNDER_BAT_ITEM
DB ITEM_TYPE_STATS
D32 10000 ;cost
DB STAT_EVOLVE

WaterGloveItem:;This glove has a connection to Water Players.
DB WATER_GLOVE_ITEM
DB ITEM_TYPE_STATS
D32 10000 ;cost
DB STAT_EVOLVE

GrassGripItem:;This grip has a connection to Grass Players.
DB GRASS_GRIP_ITEM
DB ITEM_TYPE_STATS
D32 10000 ;cost
DB STAT_EVOLVE

MoonShoesItem:;These shoes have a connection to ? Players.
DB MOON_SHOES_ITEM
DB ITEM_TYPE_STATS
D32 0 ;can't be sold
DB STAT_EVOLVE

EtherItem:;Gives 10PP to one ability
DB ETHER_ITEM
DB ITEM_TYPE_STATS
D32 0 ;can't be sold
DB STAT_PP
DW 10;change

ElixerItem:;Gives 10PP to all abilities
DB ELIXER_ITEM
DB ITEM_TYPE_STATS
D32 0 ;can't be sold
DB STAT_PPALL
DW 10;change

MaxEtherItem:;Restores all PP to one ability
DB MAX_ETHER_ITEM
DB ITEM_TYPE_STATS
D32 0 ;can't be sold
DB STAT_PP
DW 100;change

MaxElixerItem:;Restores all PP
DB MAX_ELIXER_ITEM
DB ITEM_TYPE_STATS
D32 0 ;can't be sold
DB STAT_PPALL
DW 100;change

AntidoteItem:;This removes poison from a Player
DB ANTIDOTE_ITEM
DB ITEM_TYPE_STATS
D32 100 ;cost
DB STAT_STATUS_PSN

AloeVeraItem:;This heals a Player that is burned.
DB ALOE_VERA_ITEM
DB ITEM_TYPE_STATS
D32 250 ;cost
DB STAT_STATUS_BRN

AntiFreezeItem:;Thaws a frozen Player.
DB ANTI_FREEZE_ITEM
DB ITEM_TYPE_STATS
D32 250 ;cost
DB STAT_STATUS_FRZ

SmellingSaltsItem:;This wakes up a sleeping Player.
DB SMELLING_SALTS_ITEM
DB ITEM_TYPE_STATS
D32 250 ;cost
DB STAT_STATUS_SLP

BuzzKillItem:;This heals a paralyzed Player.
DB BUZZ_KILL_ITEM
DB ITEM_TYPE_STATS
D32 250 ;cost
DB STAT_STATUS_PAR

FullHealItem:;This will heal all of the conditions stated above.
DB FULL_HEAL_ITEM
DB ITEM_TYPE_STATS
D32 600 ;cost
DB STAT_STATUS_ALL

PotionItem:;This will restore some HP.
DB POTION_ITEM
DB ITEM_TYPE_STATS
D32 300 ;cost
DB STAT_HP
DW 20;change

SuperPotionItem:;This will restore more HP than a POTION.
DB SUPER_POTION_ITEM
DB ITEM_TYPE_STATS
D32 700 ;cost
DB STAT_HP
DW 50;change

HyperPotionItem:;This will restore more HP than a SUPER POTION.
DB HYPER_POTION_ITEM
DB ITEM_TYPE_STATS
D32 1500 ;cost
DB STAT_HP
DW 100;change

MaxPotionItem:;This restores HP to its maximum.
DB MAX_POTION_ITEM
DB ITEM_TYPE_STATS
D32 2500 ;cost
DB STAT_HP
DW 500;change

FullRestoreItem:;This will heal all conditions and fully restore HP.
DB FULL_RESTORE_ITEM
DB ITEM_TYPE_STATS
D32 3000 ;cost
DB STAT_ALL

ReviveItem:;This will revive an exhausted Player and restore ½ HP.
DB REVIVE_ITEM
DB ITEM_TYPE_STATS
D32 1500 ;cost
DB STAT_REVIVE
DW 50;change

MaxReviveItem:;This will revive an exhausted Player and fully restore HP.
DB MAX_REVIVE_ITEM
DB ITEM_TYPE_STATS
D32 0 ;can't be sold
DB STAT_REVIVE
DW 500;change

WaterItem:;During a game, it will restore HP a little.
DB WATER_ITEM
DB ITEM_TYPE_STATS
D32 1 ;cost
DB STAT_HP
DW 10;change

BeerItem:;During a game, it will restore HP a lot.
DB BEER_ITEM
DB ITEM_TYPE_STATS
D32 5 ;cost
DB STAT_HP
DW 50;change

SportAdeItem:;During a game, it will restore HP a lot more.
DB SPORT_ADE_ITEM
DB ITEM_TYPE_STATS
D32 8 ;cost
DB STAT_HP
DW 100;change

EscapeRopeItem:;This rope can pull you out of a cave instantly.
DB ESCAPE_ROPE_ITEM
DB ITEM_TYPE_WORLD
D32 550 ;cost

RepelItem:;Spray on and weak Players will avoid you for a while.
DB REPEL_ITEM
DB ITEM_TYPE_WORLD
D32 350 ;cost

SuperRepelItem:;This spray lasts longer than REPEL.
DB SUPER_REPEL_ITEM
DB ITEM_TYPE_WORLD
D32 500 ;cost

MaxRepelItem:;This spray lasts longer than SUPER REPEL.
DB MAX_REPEL_ITEM
DB ITEM_TYPE_WORLD
D32 700 ;cost

ItemList:
DW BaseballItem
DW GameBallItem
DW SeriesBallItem
DW ParkBallItem
DW PerfectBallItem
DW XBatItem
DW XFieldItem
DW XSpeedItem
DW XThrowItem
DW GuardSpecItem
DW DireHitItem
DW XAccuracyItem
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
DW UppersItem
DW AcidItem
DW PPUpItem
DW NuggetItem
DW HelixJerseyItem
DW DomeHelmetItem
DW OldHatItem
DW TownMapItem
DW GoldTeethItem
DW SSTicketItem
DW SapheScopeItem
DW WhistleItem
DW OldRodItem
DW GoodRodItem
DW SuperRodItem
DW ItemfinderItem
DW ExpAllItem
DW TokenCaseItem
DW TokenItem
DW BikeVoucherItem
DW CardKeyItem
DW LiftKeyItem
DW SecretKeyItem
DW DocsPackageItem
DW RoledexItem
DW BicycleItem
DW FireBallItem
DW ThunderBatItem
DW WaterGloveItem
DW GrassGripItem
DW MoonShoesItem
DW EtherItem
DW ElixerItem
DW MaxEtherItem
DW MaxElixerItem
DW AntidoteItem
DW AloeVeraItem
DW AntiFreezeItem
DW SmellingSaltsItem
DW BuzzKillItem
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
DW EscapeRopeItem
DW RepelItem
DW SuperRepelItem
DW MaxRepelItem

