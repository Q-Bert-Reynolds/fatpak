//
// announcer_strings.de.h
//

//positions ordered by position id
const char PositionTexts[] =              "Werfer\0"
                                          "Fänger\0"
                                          "First Baseman\0"
                                          "Zweitbasemann\0"
                                          "Drittbasemann\0"
                                          "Shortstop\0"
                                          "Left Fielder\0"
                                          "Centerfielder\0"
                                          "Rightfielder";

//ordinal numbers for innings
const char InningTexts[] =                "1.\0"
                                          "2.\0"
                                          "3.\0"
                                          "4.\0"
                                          "5.\0"
                                          "6.\0"
                                          "7.\0"
                                          "8.\0"
                                          "9.\0"
                                          "10.\0"
                                          "11.\0"
                                          "12.";

//base names
const char BaseTexts[] =                  "Erste Base\0"
                                          "zweite\0"
                                          "Dritte Base\0"
                                          "Homeplate";

//beginning of frame
const char TakesTheMoundText[] =          "%s betritt\200den Werferh<u:>gel.";
const char WalksToThePlateText[] =        "%s tritt\200an den Schlag.";

//move selected
const char BatterStepsIntoTheBoxText[] =  "%s tritt\200in die Box.";
const char PitcherSetsText[] =            "%s macht sich\200bereit.";

//beginning of play
const char AndThePitchText[] =            "Und der Wurf.";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\200Ein %s.";

//after pitch
const char EarlySwingText[] =             "Fr<u:>her Schwung.";
const char LateSwingText[] =              "Später Schwung.";
const char SwingAndMissText[] =           "Schwung und\200Fehlschlag.";
const char HitBarrelText[] =              "Den Ball richtig\200gut getroffen.";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "Weiter Flyball";
const char HitFlyBallText[] =             "Flyball";
const char HitShallowFlyBallText[] =      "Kurzer Flyball";
const char HitPopFlyText[] =              "Pop-Fly";

//outfield location by angle
const char OutfieldLocationTexts[] =      "Entlang der\200<LF>-Linie.\0"
                                          "ins\200linke Feld.\0"
                                          "nach\200linksmitte.\0"
                                          "ins\200Center Field.\0"
                                          "nach\200rechts-mitte.\0"
                                          "ins\200rechte Feld.\0"
                                          "die <RF>-Linie\200entlang.";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "Line Drive";
const char HitSoftLinerText[] =           "Weicher Line\200Drive";
const char HitGroundBallText[] =          "Groundball";
const char HitChopperText[] =             "Ein Hopper";
const char HitPopUpText[] =               "Hoch geschlagen";
const char HitBuntText[] =                "Gebuntet";

//infield location by angle
const char InfieldLocationTexts[] =       "entlang der\200<3B>-Linie\0"
                                          "\200zur Dritten.\0"
                                          "\200im <SS>-<3B>-Loch.\0"
                                          "\200zum Shortstop.\0"
                                          "\200durch die Mitte.\0"
                                          "\200zum zweiten Base.\0"
                                          "\200im <1B>-<2B>-Loch.\0"
                                          "\200zu First.\0"
                                          "entlang der\200<1B>-Linie";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "zum\200%s.";

//fielded, replace %s with player name
const char CaughtByText[] =               "%s macht\200den Fang.";
const char LeapingCatchByText[] =         "%s springt\200 und schnappt ihn.";
const char DivingCatchByText[] =          "%s mit\200dem Hechtsprung.";
const char FieldedByText[] =              "Aufgenommen von\200%s.";

//errors
const char OffTheGloveOfText[] =          "Vom Handschuh von\200%s.";
const char BobbledByText[] =              "Fallen gelassen von\200%s.";
const char BadThrowByText[] =             "Ein schlechter Wurf\200von %s.";

//throw, replace %s with player name, append base thrown to
const char ThrowsToText[] =               "Wirft zu %s.";

//tag, replace %s with player name
const char PlacesTheTagText[] =           "%s\200setzt das Tag.";

//dead ball
const char DeadBallText[] =               "Toter Ball!";

//strike
const char StrikeText[] =                 "Strike %s!";
const char StrikeOutLookingText[] =       "%s sieht dem\200dritten Strike zu!";
const char StrikeOutSwingingText[] =      "%s geht\200schwingend aus!";

//no swing
const char BallText[] =                   "Ball %s.";
const char WalkText[] =                   "%s mit einem Walk\200auf Base.";
const char PassedBallText[] =             "Passed Ball!";
const char WildPitchText[] =              "Wild Pitch!";
const char HitByPitchText[] =             "Das hat ihn getroffen,\200also ist %s auf <1B>.";
const char BenchesClearText[] =           "Und die Bänke\200leeren sich.";

//runners on
const char RunnersOnBaseTexts[] =         "Niemand auf Base.\0"
                                          "Läufer auf der\200ersten Base.\0"
                                          "Läufer auf der\200zweiten Base.\0"
                                          "Läufer auf der ersten\200und zweiten Base.\0"
                                          "Läufer auf der\200dritten Base.\0"
                                          "Läufer auf 1.\200und 3. Base.\0"
                                          "Läufer auf der zweiten\200und dritten Base.\0"
                                          "Alle Bases\200besetzt.";

//tagging up
const char TaggingFromTexts[] =           "%s r<u:>ckt von First\200nach.\0"
                                          "%s r<u:>ckt von\200zweiter Base auf.\0"
                                          "Taggt von der dritten\200ist %s.";

//safe/out
const char SafeText[] =                   "Sicher!";
const char OutText[] =                    "Aus!";
const char DoublePlayText[] =             "Doppelplay!";
const char TriplePlayText[] =             "Dreifachspiel!";

//foul
const char HitFoulTipText[] =             "Foul Tip.";
const char HitFoulBackText[] =            "Foul nach hinten.";
const char HitFoulBallText[] =            "Foulball!";
const char InFoulTerritoryText[] =        "im\200Foul-Territorium.";

//hit
const char HitBaseHitText[] =             "Base Hit!";
const char HitDoubleText[] =              "Double!";
const char HitTripleText[] =              "Triple!";
const char HitHomeRunText[] =             "HOMERUN!";
const char HitGrandSlamText[] =           "GRAND SLAM!";
const char CriticalHitText[] =            "Kritischer\200Treffer!";

//score
const char PlayerScoresText[] =           "erzielt einen\200Run.";
const char TwoPlayersScoreText[] =        "und\200%s punkten.";
const char BasesClearedScoreText[] =      "Und das räumt\200die Bases ab.";

//end of frame
const char BottomOfTheText[] =            "Unteres\200%s.";
const char TopOfTheText[] =               "Anfang\200des %s.";

//end of game
const char AndThatsTheBallGameText[] =    "Und das ist das\200Spiel.";
