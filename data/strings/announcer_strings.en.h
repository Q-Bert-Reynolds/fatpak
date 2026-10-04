//
// announcer_strings.en.h
//

//positions ordered by position id
const char PositionTexts[] =              "pitcher\0"
                                          "catcher\0"
                                          "first baseman\0"
                                          "second baseman\0"
                                          "third baseman\0"
                                          "shortstop\0"
                                          "left fielder\0"
                                          "center fielder\0"
                                          "right fielder";

//ordinal numbers for innings
const char InningTexts[] =                "1st\0"
                                          "2nd\0"
                                          "3rd\0"
                                          "4th\0"
                                          "5th\0"
                                          "6th\0"
                                          "7th\0"
                                          "8th\0"
                                          "9th\0"
                                          "10th\0"
                                          "11th\0"
                                          "12th";

//base names
const char BaseTexts[] =                  "first\0"
                                          "second\0"
                                          "third\0"
                                          "home plate";

//beginning of frame
const char TakesTheMoundText[] =          "%s takes\200the mound.";
const char WalksToThePlateText[] =        "%s walks\200up to the plate.";

//move selected
const char BatterStepsIntoTheBoxText[] =  "%s steps\200into the box.";
const char PitcherSetsText[] =            "%s sets.";

//beginning of play
const char AndThePitchText[] =            "And the pitch.";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\200A %s.";

//after pitch
const char EarlySwingText[] =             "Early swing.";
const char LateSwingText[] =              "Late swing.";
const char SwingAndMissText[] =           "Swing and a miss.";
const char HitBarrelText[] =              "Really got the\200barrel on that one.";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "Deep fly ball ";
const char HitFlyBallText[] =             "Fly ball ";
const char HitShallowFlyBallText[] =      "Shallow fly ";
const char HitPopFlyText[] =              "Pop fly ";

//outfield location by angle
const char OutfieldLocationTexts[] =      "down\200the <LF> line.\0"
                                          "to\200left field.\0"
                                          "to\200left center.\0"
                                          "to\200center field.\0"
                                          "to\200right center.\0"
                                          "to\200right field.\0"
                                          "down\200the <RF> line.";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "Line drive ";
const char HitSoftLinerText[] =           "Soft liner";
const char HitGroundBallText[] =          "Ground ball ";
const char HitChopperText[] =             "A chopper ";
const char HitPopUpText[] =               "Popped up ";
const char HitBuntText[] =                "Bunted ";

//infield location by angle
const char InfieldLocationTexts[] =       "down\200the <3B> line\0"
                                          "\200to third.\0"
                                          "\200in the <SS>-<3B> hole.\0"
                                          "\200to short.\0"
                                          "\200up the middle.\0"
                                          "\200to second.\0"
                                          "\200in the <1B>-<2B> hole.\0"
                                          "\200to first.\0"
                                          "down\200the <1B> line";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "to the\200%s.";

//fielded, replace %s with player name
const char CaughtByText[] =               "%s makes\200the catch.";
const char LeapingCatchByText[] =         "%s leaps\200 and snags it.";
const char DivingCatchByText[] =          "%s with\200the diving grab.";
const char FieldedByText[] =              "Fielded by\200%s.";

//errors
const char OffTheGloveOfText[] =          "Off the glove of\200%s.";
const char BobbledByText[] =              "Bobbled by\200%s.";
const char BadThrowByText[] =             "A bad throw\200from %s.";

//throw, replace %s with player name, append base thrown to
const char ThrowsToText[] =               "Throws to %s.";

//tag, replace %s with player name
const char PlacesTheTagText[] =           "%s\200places the tag.";

//dead ball
const char DeadBallText[] =               "Dead ball!";

//strike
const char StrikeText[] =                 "Strike %s!";
const char StrikeOutLookingText[] =       "%s strikes\200out looking!";
const char StrikeOutSwingingText[] =      "%s strikes\200out swinging!";

//no swing
const char BallText[] =                   "Ball %s.";
const char WalkText[] =                   "%s on base\200with a walk.";
const char PassedBallText[] =             "Passed ball!";
const char WildPitchText[] =              "Wild pitch!";
const char HitByPitchText[] =             "That hit 'em, so\200%s is on <1B>.";
const char BenchesClearText[] =           "And the benches\200clear.";

//runners on
const char RunnersOnBaseTexts[] =         "Nobody on base.\0"
                                          "Runner on first.\0"
                                          "Runner on second.\0"
                                          "Runners on first\200and second.\0"
                                          "Runner on third.\0"
                                          "Runners on first\200and third.\0"
                                          "Runners on second\200and third.\0"
                                          "Bases loaded.";

//tagging up
const char TaggingFromTexts[] =           "%s tags from\200first.\0"
                                          "%s will\200tag from second.\0"
                                          "Tagging from third\200is %s.";

//safe/out
const char SafeText[] =                   "Safe!";
const char OutText[] =                    "Out!";
const char DoublePlayText[] =             "Double Play!";
const char TriplePlayText[] =             "Triple Play!";

//foul
const char HitFoulTipText[] =             "Foul tip.";
const char HitFoulBackText[] =            "Foulled back.";
const char HitFoulBallText[] =            "Foul Ball!";
const char InFoulTerritoryText[] =        "in\200foul territory.";

//hit
const char HitBaseHitText[] =             "Base hit!";
const char HitDoubleText[] =              "Double!";
const char HitTripleText[] =              "Triple!";
const char HitHomeRunText[] =             "HOME RUN!";
const char HitGrandSlamText[] =           "GRAND SLAM!";
const char CriticalHitText[] =            "Critical hit!";

//score
const char PlayerScoresText[] =           " scores.";
const char TwoPlayersScoreText[] =        " and\200%s score.";
const char BasesClearedScoreText[] =      "And that clears\200the bases.";

//end of frame
const char BottomOfTheText[] =            "Bottom of\200the %s.";
const char TopOfTheText[] =               "Top of\200the %s.";

//end of game
const char AndThatsTheBallGameText[] =    "And that's the\200ball game.";
