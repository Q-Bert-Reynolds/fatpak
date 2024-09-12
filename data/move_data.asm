SECTION "Move Data", ROMX, BANK[PLAYER_DATA_BANK]

DEF PINPOINT_MOVE EQU 1
DEF THREAD_MOVE EQU 2
DEF SILKY_SWING_MOVE EQU 3
DEF DRAGON_BUNT_MOVE EQU 4
DEF DRAGONBALL_MOVE EQU 5
DEF ELEC_SLIDER_MOVE EQU 6
DEF LIGHTNINBOLT_MOVE EQU 7
DEF SHOCKER_MOVE EQU 8
DEF THUNDERBALL_MOVE EQU 9
DEF THUNDERSTICK_MOVE EQU 10
DEF BEANBALL_MOVE EQU 11
DEF BRUSHBACK_MOVE EQU 12
DEF COMEBACKER_MOVE EQU 13
DEF LEAN_IN_MOVE EQU 14
DEF TAUNT_MOVE EQU 15
DEF FIREBALL_MOVE EQU 16
DEF HEATER_MOVE EQU 17
DEF HIGH_HEAT_MOVE EQU 18
DEF SCORCH_MOVE EQU 19
DEF BENDER_MOVE EQU 20
DEF FLY_MOVE EQU 21
DEF RISER_MOVE EQU 22
DEF MOCK_MOVE EQU 23
DEF SKY_SMASH_MOVE EQU 24
DEF BAFFLINGBUNT_MOVE EQU 25
DEF DEAD_PULL_MOVE EQU 26
DEF LICK_MOVE EQU 27
DEF POSSESS_MOVE EQU 28
DEF KUDZUBALL_MOVE EQU 29
DEF GRASSBURNER_MOVE EQU 30
DEF HARDWOOD_MOVE EQU 31
DEF SLEEPER_MOVE EQU 32
DEF PLANT_N_TURN_MOVE EQU 33
DEF BOUNCER_MOVE EQU 34
DEF CHOP_DOWN_MOVE EQU 35
DEF CRACK_MOVE EQU 36
DEF DIG_IN_MOVE EQU 37
DEF KICKUP_SAND_MOVE EQU 38
DEF SPELUNKER_MOVE EQU 39
DEF COLDSHOULDER_MOVE EQU 40
DEF FROZEN_ROPE_MOVE EQU 41
DEF SHIVER_MOVE EQU 42
DEF BUNT_MOVE EQU 43
DEF PUSH_BUNT_MOVE EQU 44
DEF DRAG_BUNT_MOVE EQU 45
DEF BARRAGE_MOVE EQU 46
DEF BASH_MOVE EQU 47
DEF BOMB_MOVE EQU 48
DEF CHANGEUP_MOVE EQU 49
DEF CHANT_MOVE EQU 50
DEF CIRCLECHANGE_MOVE EQU 51
DEF CURVEBALL_MOVE EQU 52
DEF CUT_MOVE EQU 53
DEF CUTTER_MOVE EQU 54
DEF EEPHUS_PITCH_MOVE EQU 55
DEF EXPLODE_MOVE EQU 56
DEF FASTBALL_MOVE EQU 57
DEF FLASH_MOVE EQU 58
DEF FOCUS_MOVE EQU 59
DEF FORKBALL_MOVE EQU 60
DEF FOSH_MOVE EQU 61
DEF FOUR_SEAM_MOVE EQU 62
DEF GLARE_MOVE EQU 63
DEF GYROBALL_MOVE EQU 64
DEF HARDEN_MOVE EQU 65
DEF KNUCKLEBALL_MOVE EQU 66
DEF KNUCKLECURVE_MOVE EQU 67
DEF MONEYBALL_MOVE EQU 68
DEF PALMBALL_MOVE EQU 69
DEF QUICK_SWING_MOVE EQU 70
DEF RAGE_MOVE EQU 71
DEF SCOWL_MOVE EQU 72
DEF SCREWBALL_MOVE EQU 73
DEF SEPPUKUBALL_MOVE EQU 74
DEF SHUUTO_MOVE EQU 75
DEF SINKER_MOVE EQU 76
DEF SLASH_MOVE EQU 77
DEF SLIDER_MOVE EQU 78
DEF SLURVE_MOVE EQU 79
DEF SMASH_MOVE EQU 80
DEF SOFT_TOSS_MOVE EQU 81
DEF SPLITTER_MOVE EQU 82
DEF STOMP_MOVE EQU 83
DEF STRENGTH_MOVE EQU 84
DEF STRUGGLE_MOVE EQU 85
DEF STUDY_MOVE EQU 86
DEF SUBMARINE_MOVE EQU 87
DEF SWAT_MOVE EQU 88
DEF SWING_MOVE EQU 89
DEF THREE_SEAM_MOVE EQU 90
DEF TOSS_MOVE EQU 91
DEF TWO_SEAM_MOVE EQU 92
DEF VULCAN_MOVE EQU 93
DEF WIFF_MOVE EQU 94
DEF FILTH_MOVE EQU 95
DEF NASTY_CURVE_MOVE EQU 96
DEF GAS_MOVE EQU 97
DEF PUFF_MOVE EQU 98
DEF BLINK_MOVE EQU 99
DEF BRAIN_MELTER_MOVE EQU 100
DEF HYPNOSIS_MOVE EQU 101
DEF KINESIS_MOVE EQU 102
DEF MEDITATE_MOVE EQU 103
DEF PREDICT_MOVE EQU 104
DEF PSYCH_OUT_MOVE EQU 105
DEF REST_MOVE EQU 106
DEF ROCK_MOVE EQU 107
DEF ROCK_HAMMER_MOVE EQU 108
DEF ROCK_SLIDER_MOVE EQU 109
DEF BUBBLEBALL_MOVE EQU 110
DEF CRABHAMMER_MOVE EQU 111
DEF HYDRO_CANNON_MOVE EQU 112
DEF SHELL_MOVE EQU 113
DEF SPITBALL_MOVE EQU 114
DEF SURF_MOVE EQU 115
DEF WITHDRAW_MOVE EQU 116

PinpointMove:;An incredibly accurate four-seam.
DB PINPOINT_MOVE
DB 0;Pitch
DB BUG
DB 10 ;Play Points
DB 80 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

ThreadMove:;An incredibly accurate two-seam.
DB THREAD_MOVE
DB 0;Pitch
DB BUG
DB 20 ;Play Points
DB 75 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_FADE ;Path

SilkySwingMove:;Lowers the fielder's Speed by 1 stage.
DB SILKY_SWING_MOVE
DB 1;Swing
DB BUG
DB 30 ;Play Points
DB 50 ;Power
DB 95 ;Accuracy
DB 15 ;Launch Angle
DB 45 ;Spray

DragonBuntMove:;A drag bunt that wears down the fielder 40 HP.
DB DRAGON_BUNT_MOVE
DB 1;Swing
DB DRAGON
DB 10 ;Play Points
DB 40 ;Power
DB 100 ;Accuracy
DB -15 ;Launch Angle
DB 5 ;Spray

DragonballMove:;A shuuto with an off-center pivot.
DB DRAGONBALL_MOVE
DB 0;Pitch
DB DRAGON
DB 10 ;Play Points
DB 70 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_FADE ;Path

ElecSliderMove:;A hard slider with a spark of electricity.
DB ELEC_SLIDER_MOVE
DB 0;Pitch
DB ELECTRIC
DB 10 ;Play Points
DB 80 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_SLIDER ;Path

LightninBoltMove:;A four-seam fastball that comes like a bolt of lightning.
DB LIGHTNINBOLT_MOVE
DB 0;Pitch
DB ELECTRIC
DB 10 ;Play Points
DB 105 ;Power
DB 85 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

ShockerMove:;A highly charged two-seamer with an eratic break.
DB SHOCKER_MOVE
DB 0;Pitch
DB ELECTRIC
DB 15 ;Play Points
DB 90 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_FADE ;Path

ThunderballMove:;A deceiving offsepeed pitch.
DB THUNDERBALL_MOVE
DB 0;Pitch
DB ELECTRIC
DB 30 ;Play Points
DB 65 ;Power
DB 70 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

ThunderStickMove:;Has a ~10% chance to paralyze the fielder the ball is hit to.
DB THUNDERSTICK_MOVE
DB 1;Swing
DB ELECTRIC
DB 10 ;Play Points
DB 120 ;Power
DB 70 ;Accuracy
DB 15 ;Launch Angle

BeanballMove:;A four-seam fastball aimed right at the batter. 100% chance of hitting batter.
DB BEANBALL_MOVE
DB 0;Pitch
DB FIGHTING
DB 20 ;Play Points
DB 100 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

BrushbackMove:;A four-seam fastball thrown inside. 50% chance of hitting batter. Can cause a batter to flinch.
DB BRUSHBACK_MOVE
DB 0;Pitch
DB FIGHTING
DB 15 ;Play Points
DB 90 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

ComebackerMove:;Hard linedrive, right at the pitcher.
DB COMEBACKER_MOVE
DB 1;Swing
DB FIGHTING
DB 5 ;Play Points
DB 120 ;Power
DB 85 ;Accuracy
DB 3 ;Launch Angle

LeanInMove:;Fake a check-swing and lean into anything close.
DB LEAN_IN_MOVE
DB 1;Swing
DB FIGHTING
DB 20 ;Play Points
DB 0 ;Power
DB 50 ;Accuracy

TauntMove:;Step out of the box and make a face. Makes pitchers throw wildly inside.
DB TAUNT_MOVE
DB 1;Swing
DB FIGHTING
DB 50 ;Play Points
DB 0 ;Power
DB 50 ;Accuracy

FireballMove:;Pure fire, right down the pipe.
DB FIREBALL_MOVE
DB 0;Pitch
DB FIRE
DB 30 ;Play Points
DB 100 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

HeaterMove:;A four-seam fastball with some heat on it.
DB HEATER_MOVE
DB 0;Pitch
DB FIRE
DB 15 ;Play Points
DB 90 ;Power
DB 95 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

HighHeatMove:;Some serious heat up in the zone.
DB HIGH_HEAT_MOVE
DB 0;Pitch
DB FIRE
DB 5 ;Play Points
DB 120 ;Power
DB 50 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

ScorchMove:;A hard hit ball with a ~10% chance to burn the fielder.
DB SCORCH_MOVE
DB 1;Swing
DB FIRE
DB 25 ;Play Points
DB 100 ;Power
DB 100 ;Accuracy
DB 20 ;Launch Angle

BenderMove:;A curveball that seems to drop out of the sky.
DB BENDER_MOVE
DB 0;Pitch
DB FLYING
DB 10 ;Play Points
DB 70 ;Power
DB 65 ;Accuracy
DB PITCH_PATH_CURVE ;Path

FlyMove:;An uppercut swing with a high chance of a fly ball.
DB FLY_MOVE
DB 1;Swing
DB FLYING
DB 15 ;Play Points
DB 70 ;Power
DB 95 ;Accuracy
DB 35 ;Launch Angle

RiserMove:;A gravity-defying four-seam with a monster spin-rate.
DB RISER_MOVE
DB 0;Pitch
DB FLYING
DB 10 ;Play Points
DB 120 ;Power
DB 75 ;Accuracy
DB PITCH_PATH_RISE ;Path

MockMove:;Takes a pitch to mock the pitcher. 20% chance of getting thrown at.
DB MOCK_MOVE
DB 1;Swing
DB FLYING
DB 10 ;Play Points
DB 0 ;Power
DB 20 ;Accuracy

SkySmashMove:;Batter digs in, takes the first pitch, and smashes anything close on the second pitch.
DB SKY_SMASH_MOVE
DB 1;Swing
DB FLYING
DB 5 ;Play Points
DB 140 ;Power
DB 90 ;Accuracy
DB 45 ;Launch Angle

BafflingBuntMove:;Squares for a bunt. Unsquares. Squares again. Takes a pitch. Confuses the pitcher.
DB BAFFLINGBUNT_MOVE
DB 1;Swing
DB GHOST
DB 10 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

DeadPullMove:;Hard hit, pulled right down the line.
DB DEAD_PULL_MOVE
DB 1;Swing
DB GHOST
DB 10 ;Play Points
DB 90 ;Power
DB 100 ;Accuracy
DB 5 ;Launch Angle
DB 5 ;Spray
DB 45 ;Pull

LickMove:;Has a ~30% chance to paralyze the fielder. This move fails against Psychic-type pitches.
DB LICK_MOVE
DB 1;Swing
DB GHOST
DB 30 ;Play Points
DB 20 ;Power
DB 100 ;Accuracy
DB 10 ;Launch Angle

PossessMove:;A pitch that can be controlled after it's thrown
DB POSSESS_MOVE
DB 0;Pitch
DB GHOST
DB 5 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_KNUCKLE ;Path

KudzuballMove:;A fastball that's all over the place.
DB KUDZUBALL_MOVE
DB 0;Pitch
DB GRASS
DB 10 ;Play Points
DB 90 ;Power
DB 60 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

GrassburnerMove:;A hard hit ground ball with a chance of burning the fielder.
DB GRASSBURNER_MOVE
DB 1;Swing
DB GRASS
DB 5 ;Play Points
DB 120 ;Power
DB 100 ;Accuracy
DB 0 ;Launch Angle
DB 30 ;Spray
DB -22 ;Pull

HardwoodMove:;A hard swing with a big stick.
DB HARDWOOD_MOVE
DB 1;Swing
DB GRASS
DB 15 ;Play Points
DB 90 ;Power
DB 75 ;Accuracy
DB 30 ;Launch Angle
DB 30 ;Spray
DB 0 ;Pull

SleeperMove:;Takes a pitch. Lulls the pitcher to sleep. 
DB SLEEPER_MOVE
DB 1;Swing
DB GRASS
DB 10 ;Play Points
DB 0 ;Power
DB 25 ;Accuracy
DB PITCH_PATH_NONE ;Path

PlantnTurnMove:;Has a high critical hit ratio.
DB PLANT_N_TURN_MOVE
DB 1;Swing
DB GRASS
DB 25 ;Play Points
DB 55 ;Power
DB 95 ;Accuracy
DB 15 ;Launch Angle
DB 10 ;Spray
DB 22 ;Pull

BouncerMove:;Bounces in the dirt.
DB BOUNCER_MOVE
DB 0;Pitch
DB GROUND
DB 15 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

ChopDownMove:;Almost certainly a grounder. Often bounces right in front of the plate and stays in the air for a long time.
DB CHOP_DOWN_MOVE
DB 1;Swing
DB GROUND
DB 45 ;Play Points
DB 60 ;Power
DB 100 ;Accuracy
DB -10 ;Launch Angle

CrackMove:;If it connects, it's gone.
DB CRACK_MOVE
DB 1;Swing
DB GROUND
DB 5 ;Play Points
DB 250 ;Power
DB 30 ;Accuracy
DB 15 ;Launch Angle
DB 30 ;Spray
DB 22 ;Pull

DigInMove:;On the first pitch, the batter digs in. On the second pitch, the batter attacks anything close.
DB DIG_IN_MOVE
DB 1;Swing
DB GROUND
DB 10 ;Play Points
DB 100 ;Power
DB 100 ;Accuracy
DB 0 ;Launch Angle

KickupSandMove:;Takes a pitch. Lowers the catcher's Accuracy by 1 stage.
DB KICKUP_SAND_MOVE
DB 1;Swing
DB GROUND
DB 15 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

SpelunkerMove:;A forkball that takes a hard turn out of the strikezone at the last second.
DB SPELUNKER_MOVE
DB 0;Pitch
DB GROUND
DB 15 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_DROP ;Path

ColdShoulderMove:;Looks over their shoulder. Throws to first. Has a 30% chance of freezing the runner.
DB COLDSHOULDER_MOVE
DB 0;Pitch
DB ICE
DB 5 ;Play Points
DB 0 ;Power
DB 30 ;Accuracy
DB PITCH_PATH_NONE ;Path

FrozenRopeMove:;A hard hit line drive that has a 10% chance of freezing the fielder.
DB FROZEN_ROPE_MOVE
DB 1;Swing
DB ICE
DB 10 ;Play Points
DB 90 ;Power
DB 90 ;Accuracy
DB 10 ;Launch Angle

ShiverMove:;Takes a pitch. The batter's preocupation with how cold they've gotten protects them from negative stat modifiers caused by other players until the end of the plate appearance.
DB SHIVER_MOVE
DB 1;Swing
DB ICE
DB 30 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

BuntMove:;Great for advancing runners.
DB BUNT_MOVE
DB 1;Swing
DB NORMAL
DB 30 ;Play Points
DB 10 ;Power
DB 100 ;Accuracy

PushBuntMove:;A hard bunt meant to go past a charging infielder.
DB PUSH_BUNT_MOVE
DB 1;Swing
DB NORMAL
DB 20 ;Play Points
DB 40 ;Power
DB 100 ;Accuracy

DragBuntMove:;A bunt with a running start. Speed +1.
DB DRAG_BUNT_MOVE
DB 1;Swing
DB NORMAL
DB 15 ;Play Points
DB 10 ;Power
DB 100 ;Accuracy

BarrageMove:;A harder fastball thrown 2-5 times in a row. This pitch has a 3/8 chance of being thrown twice, a 3/8 chance of being thrown three times, a 1/8 chance of being thrown four times, and a 1/8 chance of being thrown five times.
DB BARRAGE_MOVE
DB 0;Pitch
DB NORMAL
DB 10 ;Play Points
DB 150 ;Power
DB 85 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

BashMove:;Takes a pitch, lowers their head, and swings hard on the next turn.
DB BASH_MOVE
DB 1;Swing
DB NORMAL
DB 25 ;Play Points
DB 90 ;Power
DB 100 ;Accuracy

BombMove:;A hard swing with a high launch angle.
DB BOMB_MOVE
DB 1;Swing
DB NORMAL
DB 15 ;Play Points
DB 120 ;Power
DB 70 ;Accuracy

ChangeupMove:;A straight change. Same motion as a fastball, but much slower.
DB CHANGEUP_MOVE
DB 0;Pitch
DB NORMAL
DB 30 ;Play Points
DB 70 ;Power
DB 95 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

ChantMove:;Takes a pitch, steps out of the box, the crowd starts to chant. Pitcher sleeps on the runners.
DB CHANT_MOVE
DB 1;Swing
DB NORMAL
DB 5 ;Play Points
DB 0 ;Power
DB 55 ;Accuracy
DB 5 ;Launch Angle

CircleChangeMove:;A changeup thrown with the thumb and index finger touching. Breaks similar to a screwball.
DB CIRCLECHANGE_MOVE
DB 0;Pitch
DB NORMAL
DB 30 ;Play Points
DB 70 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_RISE ;Path

CurveballMove:;A 12-6 curveball.
DB CURVEBALL_MOVE
DB 0;Pitch
DB NORMAL
DB 25 ;Play Points
DB 70 ;Power
DB 85 ;Accuracy
DB PITCH_PATH_CURVE ;Path

CutMove:;A good, hard swing.
DB CUT_MOVE
DB 1;Swing
DB NORMAL
DB 30 ;Play Points
DB 75 ;Power
DB 95 ;Accuracy
DB 15 ;Launch Angle

CutterMove:;A fastball that tails in from the pitcher.
DB CUTTER_MOVE
DB 0;Pitch
DB NORMAL
DB 20 ;Play Points
DB 85 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_CUT ;Path

EephusPitchMove:;A super slow pitch that drops through the strikezone. It often catches batters off guard.
DB EEPHUS_PITCH_MOVE
DB 0;Pitch
DB NORMAL
DB 10 ;Play Points
DB 30 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_EEPHUS ;Path

ExplodeMove:;A fastball that takes everything a pitcher has left.
DB EXPLODE_MOVE
DB 0;Pitch
DB NORMAL
DB 5 ;Play Points
DB 200 ;Power
DB 75 ;Accuracy

FastballMove:;A hard thrown ball... with an unsure grip.
DB FASTBALL_MOVE
DB 0;Pitch
DB NORMAL
DB 35 ;Play Points
DB 40 ;Power
DB 75 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

FlashMove:;At just the right angle, you can blind the pitcher flashing a bunt. Lowers the pitcher's Accuracy by 1 stage.
DB FLASH_MOVE
DB 1;Swing
DB NORMAL
DB 20 ;Play Points
DB 0 ;Power
DB 70 ;Accuracy

FocusMove:;Takes a pitch. Increases critical hit ratio.
DB FOCUS_MOVE
DB 1;Swing
DB NORMAL
DB 30 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

ForkballMove:;A changeup thrown like a splitter. Breaks with a more gental downward motion.
DB FORKBALL_MOVE
DB 0;Pitch
DB NORMAL
DB 30 ;Play Points
DB 70 ;Power
DB 85 ;Accuracy
DB PITCH_PATH_DROP ;Path

FoshMove:;A cross between a split-finger pitch and a straight change.
DB FOSH_MOVE
DB 0;Pitch
DB NORMAL
DB 30 ;Play Points
DB 70 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

FourSeamMove:;A four-seam fastball.
DB FOUR_SEAM_MOVE
DB 0;Pitch
DB NORMAL
DB 30 ;Play Points
DB 85 ;Power
DB 95 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

GlareMove:;Takes a pitch. Paralyzes the pitcher. Works on Ghost-type pitchers.
DB GLARE_MOVE
DB 1;Swing
DB NORMAL
DB 30 ;Play Points
DB 0 ;Power
DB 75 ;Accuracy

GyroballMove:;A pitch thrown with a spiral-like spin so that the Magnus force is in the same direction as the ball's movement.
DB GYROBALL_MOVE
DB 0;Pitch
DB NORMAL
DB 20 ;Play Points
DB 70 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_DROP ;Path

HardenMove:;Takes a pitch. Raises the user's Batting by 1 stage.
DB HARDEN_MOVE
DB 1;Swing
DB NORMAL
DB 30 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

KnuckleballMove:;A tough-to-hit, tough-to-control offspeed pitch with little to no rotation on the ball.
DB KNUCKLEBALL_MOVE
DB 0;Pitch
DB NORMAL
DB 20 ;Play Points
DB 65 ;Power
DB 50 ;Accuracy
DB PITCH_PATH_KNUCKLE ;Path

KnuckleCurveMove:;A faster than normal curveball thrown with the index knuckle on the ball.
DB KNUCKLECURVE_MOVE
DB 0;Pitch
DB NORMAL
DB 20 ;Play Points
DB 75 ;Power
DB 75 ;Accuracy
DB PITCH_PATH_CURVE ;Path

MoneyballMove:;Crowds pay big money to see this curve.
DB MONEYBALL_MOVE
DB 0;Pitch
DB NORMAL
DB 15 ;Play Points
DB 70 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_CURVE ;Path

PalmballMove:;Same motion as a fastball, but much slower.
DB PALMBALL_MOVE
DB 0;Pitch
DB NORMAL
DB 30 ;Play Points
DB 70 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

QuickSwingMove:;A quick swing for contact.
DB QUICK_SWING_MOVE
DB 1;Swing
DB NORMAL
DB 30 ;Play Points
DB 40 ;Power
DB 100 ;Accuracy
DB 10 ;Launch Angle

RageMove:;Nothing but fastballs, each one thrown harder than the last.
DB RAGE_MOVE
DB 0;Pitch
DB NORMAL
DB 20 ;Play Points
DB 80 ;Power
DB 75 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

ScowlMove:;Takes a pitch. Lowers the infield's Throwing by 1 stage.
DB SCOWL_MOVE
DB 1;Swing
DB NORMAL
DB 40 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

ScrewballMove:;A curveball that breaks away from the pitcher instead of inward.
DB SCREWBALL_MOVE
DB 0;Pitch
DB NORMAL
DB 20 ;Play Points
DB 75 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_SCREW ;Path

SeppukuballMove:;A hard thrown shuuto that destroy's the pitcher's shoulder.
DB SEPPUKUBALL_MOVE
DB 0;Pitch
DB NORMAL
DB 5 ;Play Points
DB 100 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_FADE ;Path

ShuutoMove:;Similar to the screwball, the shuuto breaks away from the pitcher and can jam a hitter.
DB SHUUTO_MOVE
DB 0;Pitch
DB NORMAL
DB 20 ;Play Points
DB 70 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_FADE ;Path

SinkerMove:;A fastball with a dropping spin. Has an increased risk of wild pitches.
DB SINKER_MOVE
DB 0;Pitch
DB NORMAL
DB 25 ;Play Points
DB 80 ;Power
DB 85 ;Accuracy
DB PITCH_PATH_DROP ;Path

SlashMove:;Has a high critical hit ratio.
DB SLASH_MOVE
DB 1;Swing
DB NORMAL
DB 20 ;Play Points
DB 70 ;Power
DB 100 ;Accuracy
DB -5 ;Launch Angle

SliderMove:;Breaks in hard from the pitcher.
DB SLIDER_MOVE
DB 0;Pitch
DB NORMAL
DB 20 ;Play Points
DB 80 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_SLIDER ;Path

SlurveMove:;A curveball with more inward than downward motion.
DB SLURVE_MOVE
DB 0;Pitch
DB NORMAL
DB 25 ;Play Points
DB 70 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_SLURVE ;Path

SmashMove:;A hard hit ball with a good lanuch angle. Batter takes the next pitch to recover.
DB SMASH_MOVE
DB 1;Swing
DB NORMAL
DB 20 ;Play Points
DB 150 ;Power
DB 75 ;Accuracy
DB 25 ;Launch Angle

SoftTossMove:;An eephus that restores half the pitcher's health.
DB SOFT_TOSS_MOVE
DB 0;Pitch
DB NORMAL
DB 10 ;Play Points
DB 25 ;Power
DB 95 ;Accuracy

SplitterMove:;A fastball thrown with the index and middle fingers split on either side of the ball. Looks like a four-seam until it drops off the table.
DB SPLITTER_MOVE
DB 0;Pitch
DB NORMAL
DB 15 ;Play Points
DB 80 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_DROP ;Path

StompMove:;A hack with a big step. Has a ~30% chance to make the target balk on the next pitch.
DB STOMP_MOVE
DB 1;Swing
DB NORMAL
DB 20 ;Play Points
DB 65 ;Power
DB 100 ;Accuracy
DB 30 ;Launch Angle

StrengthMove:;A big swing that can muscle anything deep.
DB STRENGTH_MOVE
DB 1;Swing
DB NORMAL
DB 15 ;Play Points
DB 100 ;Power
DB 100 ;Accuracy
DB 35 ;Launch Angle

StruggleMove:;Used automatically when all of the user's other moves have run out of PP or are otherwise inaccessible. The user receives 1/4 recoil damage. Struggle is classified as a Normal-type move, so it is resisted by Rock-type Pokemon and cannot hit Ghost-type Pokemon at all.
DB STRUGGLE_MOVE
DB 1;Swing
DB NORMAL
DB 1 ;Play Points
DB 50 ;Power
DB 100 ;Accuracy
DB 0 ;Launch Angle

StudyMove:;Takes the pitch. Learns the pitch.
DB STUDY_MOVE
DB 1;Swing
DB NORMAL
DB 20 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

SubmarineMove:;A knuckle scraper. Starts at the knees and finishes high.
DB SUBMARINE_MOVE
DB 0;Pitch
DB NORMAL
DB 15 ;Play Points
DB 75 ;Power
DB 80 ;Accuracy

SwatMove:;An ugly swing that always manages to make contact.
DB SWAT_MOVE
DB 1;Swing
DB NORMAL
DB 20 ;Play Points
DB 30 ;Power
DB 100 ;Accuracy

SwingMove:;An simple swing for contact.
DB SWING_MOVE
DB 1;Swing
DB NORMAL
DB 35 ;Play Points
DB 35 ;Power
DB 95 ;Accuracy
DB 15 ;Launch Angle

ThreeSeamMove:;A two-seam fastball with a little extra tail.
DB THREE_SEAM_MOVE
DB 0;Pitch
DB NORMAL
DB 15 ;Play Points
DB 90 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_FADE ;Path

TossMove:;An easy pitch.
DB TOSS_MOVE
DB 0;Pitch
DB NORMAL
DB 35 ;Play Points
DB 40 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

TwoSeamMove:;A two-seam fastball. It tails away from the pitcher.
DB TWO_SEAM_MOVE
DB 0;Pitch
DB NORMAL
DB 30 ;Play Points
DB 80 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_FADE ;Path

VulcanMove:;A changeup thrown like a Star Trek greeting.
DB VULCAN_MOVE
DB 0;Pitch
DB NORMAL
DB 30 ;Play Points
DB 70 ;Power
DB 90 ;Accuracy
DB PITCH_PATH_DROP ;Path

WiffMove:;Swing... and a miss.
DB WIFF_MOVE
DB 1;Swing
DB NORMAL
DB 40 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

FilthMove:;A filthy breaking changeup. Has a 30% chance to poison the batter.
DB FILTH_MOVE
DB 0;Pitch
DB POISON
DB 10 ;Play Points
DB 90 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_FADE ;Path

NastyCurveMove:;A hard curveball with a 25% chance to poison the batter.
DB NASTY_CURVE_MOVE
DB 0;Pitch
DB POISON
DB 10 ;Play Points
DB 80 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_CURVE ;Path

GasMove:;Straight gas. 10% chance of poisioning the batter.
DB GAS_MOVE
DB 0;Pitch
DB POISON
DB 10 ;Play Points
DB 120 ;Power
DB 70 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

PuffMove:;A nasty puff of smoke. Good contact swing. Has a ~30% chance to poison the catcher.
DB PUFF_MOVE
DB 1;Swing
DB POISON
DB 20 ;Play Points
DB 20 ;Power
DB 100 ;Accuracy
DB 20 ;Launch Angle

BlinkMove:;A fastball that seems to jump from the mound to the plate in the blink of an eye.
DB BLINK_MOVE
DB 0;Pitch
DB PSYCHIC
DB 10 ;Play Points
DB 100 ;Power
DB 50 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

BrainMelterMove:;A fastball with a ~30% chance to lower the batter's Batting by 1 stage.
DB BRAIN_MELTER_MOVE
DB 0;Pitch
DB PSYCHIC
DB 15 ;Play Points
DB 90 ;Power
DB 100 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

HypnosisMove:;Takes a pitch, and puts the pitcher into a trance. Pitcher sleeps on the runners.
DB HYPNOSIS_MOVE
DB 1;Swing
DB PSYCHIC
DB 20 ;Play Points
DB 0 ;Power
DB 60 ;Accuracy

KinesisMove:;Takes a pitch. Lowers the pitcher's Accuracy by 1 stage.
DB KINESIS_MOVE
DB 1;Swing
DB PSYCHIC
DB 15 ;Play Points
DB 0 ;Power
DB 80 ;Accuracy

MeditateMove:;Takes a pitch. Raises the user's Batting by 1 stage.
DB MEDITATE_MOVE
DB 1;Swing
DB PSYCHIC
DB 10 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

PredictMove:;Takes a pitch. Increases the batter's critical hit ratio.
DB PREDICT_MOVE
DB 1;Swing
DB PSYCHIC
DB 10 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

PsychOutMove:;Takes a pitch. Lowers the pitcher's Throwing by 1 stage.
DB PSYCH_OUT_MOVE
DB 1;Swing
DB PSYCHIC
DB 15 ;Play Points
DB 0 ;Power
DB 80 ;Accuracy

RestMove:;Takes the next two pitches. Restores health fully.
DB REST_MOVE
DB 1;Swing
DB PSYCHIC
DB 10 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

RockMove:;A hard sinking fastball that never leaves the infield.
DB ROCK_MOVE
DB 0;Pitch
DB ROCK
DB 5 ;Play Points
DB 50 ;Power
DB 65 ;Accuracy
DB PITCH_PATH_DROP ;Path

RockHammerMove:;A primative chop.
DB ROCK_HAMMER_MOVE
DB 1;Swing
DB ROCK
DB 10 ;Play Points
DB 100 ;Power
DB 90 ;Accuracy
DB -20 ;Launch Angle

RockSliderMove:;A slider with with a heavy drop to it.
DB ROCK_SLIDER_MOVE
DB 0;Pitch
DB ROCK
DB 10 ;Play Points
DB 70 ;Power
DB 75 ;Accuracy
DB PITCH_PATH_SLIDER ;Path

BubbleballMove:;A slippery pitch that floats like a bubble
DB BUBBLEBALL_MOVE
DB 0;Pitch
DB WATER
DB 15 ;Play Points
DB 90 ;Power
DB 65 ;Accuracy
DB PITCH_PATH_RISE ;Path

CrabhammerMove:;Has a high critical hit ratio.
DB CRABHAMMER_MOVE
DB 1;Swing
DB WATER
DB 10 ;Play Points
DB 90 ;Power
DB 85 ;Accuracy
DB 30 ;Launch Angle

HydroCannonMove:;A hard fastball with some sweat on it.
DB HYDRO_CANNON_MOVE
DB 0;Pitch
DB WATER
DB 5 ;Play Points
DB 120 ;Power
DB 80 ;Accuracy
DB PITCH_PATH_STRAIGHT ;Path

ShellMove:;An absolute missile with splash damage.
DB SHELL_MOVE
DB 1;Swing
DB WATER
DB 5 ;Play Points
DB 120 ;Power
DB 80 ;Accuracy
DB 5 ;Launch Angle

SpitballMove:;A little spit on the fingers causes the ball to tumble forward. Can be wild.
DB SPITBALL_MOVE
DB 0;Pitch
DB WATER
DB 20 ;Play Points
DB 80 ;Power
DB 70 ;Accuracy
DB PITCH_PATH_DROP ;Path

SurfMove:;A kunckleball with a flight pattern similar to a wave.
DB SURF_MOVE
DB 0;Pitch
DB WATER
DB 10 ;Play Points
DB 60 ;Power
DB 65 ;Accuracy
DB PITCH_PATH_KNUCKLE ;Path

WithdrawMove:;Takes a pitch. Raises the user's Batting by 1 stage.
DB WITHDRAW_MOVE
DB 1;Swing
DB WATER
DB 20 ;Play Points
DB 0 ;Power
DB 100 ;Accuracy

MoveList:
DW PinpointMove
DW ThreadMove
DW SilkySwingMove
DW DragonBuntMove
DW DragonballMove
DW ElecSliderMove
DW LightninBoltMove
DW ShockerMove
DW ThunderballMove
DW ThunderStickMove
DW BeanballMove
DW BrushbackMove
DW ComebackerMove
DW LeanInMove
DW TauntMove
DW FireballMove
DW HeaterMove
DW HighHeatMove
DW ScorchMove
DW BenderMove
DW FlyMove
DW RiserMove
DW MockMove
DW SkySmashMove
DW BafflingBuntMove
DW DeadPullMove
DW LickMove
DW PossessMove
DW KudzuballMove
DW GrassburnerMove
DW HardwoodMove
DW SleeperMove
DW PlantnTurnMove
DW BouncerMove
DW ChopDownMove
DW CrackMove
DW DigInMove
DW KickupSandMove
DW SpelunkerMove
DW ColdShoulderMove
DW FrozenRopeMove
DW ShiverMove
DW BuntMove
DW PushBuntMove
DW DragBuntMove
DW BarrageMove
DW BashMove
DW BombMove
DW ChangeupMove
DW ChantMove
DW CircleChangeMove
DW CurveballMove
DW CutMove
DW CutterMove
DW EephusPitchMove
DW ExplodeMove
DW FastballMove
DW FlashMove
DW FocusMove
DW ForkballMove
DW FoshMove
DW FourSeamMove
DW GlareMove
DW GyroballMove
DW HardenMove
DW KnuckleballMove
DW KnuckleCurveMove
DW MoneyballMove
DW PalmballMove
DW QuickSwingMove
DW RageMove
DW ScowlMove
DW ScrewballMove
DW SeppukuballMove
DW ShuutoMove
DW SinkerMove
DW SlashMove
DW SliderMove
DW SlurveMove
DW SmashMove
DW SoftTossMove
DW SplitterMove
DW StompMove
DW StrengthMove
DW StruggleMove
DW StudyMove
DW SubmarineMove
DW SwatMove
DW SwingMove
DW ThreeSeamMove
DW TossMove
DW TwoSeamMove
DW VulcanMove
DW WiffMove
DW FilthMove
DW NastyCurveMove
DW GasMove
DW PuffMove
DW BlinkMove
DW BrainMelterMove
DW HypnosisMove
DW KinesisMove
DW MeditateMove
DW PredictMove
DW PsychOutMove
DW RestMove
DW RockMove
DW RockHammerMove
DW RockSliderMove
DW BubbleballMove
DW CrabhammerMove
DW HydroCannonMove
DW ShellMove
DW SpitballMove
DW SurfMove
DW WithdrawMove

