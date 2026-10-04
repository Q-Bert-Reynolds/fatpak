//
// announcer_strings.fr.h
//

//positions ordered by position id
const char PositionTexts[] =              "lanceur\0"
                                          "receveur\0"
                                          "premier but\0"
                                          "deuxième but\0"
                                          "joueur de\200troisième base\0"
                                          "arrêt-court\0"
                                          "voltigeur de\200gauche\0"
                                          "voltigeur de\200centre\0"
                                          "voltigeur de\200droite";

//ordinal numbers for innings
const char InningTexts[] =                "1er\0"
                                          "2e\0"
                                          "3e\0"
                                          "4e\0"
                                          "5e\0"
                                          "6e\0"
                                          "7e\0"
                                          "8e\0"
                                          "9e\0"
                                          "10e\0"
                                          "11e\0"
                                          "12e";

//base names
const char BaseTexts[] =                  "premier\0"
                                          "deuxième\0"
                                          "troisième\0"
                                          "marbre";

//beginning of frame
const char TakesTheMoundText[] =          "%s monte sur\200le monticule.";
const char WalksToThePlateText[] =        "%s s'avance\200au marbre.";

//move selected
const char BatterStepsIntoTheBoxText[] =  "%s s'avance\200dans le rectangle.";
const char PitcherSetsText[] =            "%s se pr<e`>pare.";

//beginning of play
const char AndThePitchText[] =            "Et le lancer.";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\200Un %s.";

//after pitch
const char EarlySwingText[] =             "Swing en avance.";
const char LateSwingText[] =              "Élan tardif.";
const char SwingAndMissText[] =           "Élan et rat<e`>.";
const char HitBarrelText[] =              "Vraiment mis le\200centre de la batte.";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "Balle haute\200profonde";
const char HitFlyBallText[] =             "Balle volante";
const char HitShallowFlyBallText[] =      "Ballon court";
const char HitPopFlyText[] =              "Chandelle";

//outfield location by angle
const char OutfieldLocationTexts[] =      "le long de\200la ligne <LF>.\0"
                                          "au\200champ gauche.\0"
                                          "au\200centre gauche.\0"
                                          "au\200champ centre.\0"
                                          "au\200centre droit.\0"
                                          "au\200champ droit.\0"
                                          "le long de\200la ligne <RF>.";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "Flèche";
const char HitSoftLinerText[] =           "Ligne douce";
const char HitGroundBallText[] =          "Roulant";
const char HitChopperText[] =             "Un chopper";
const char HitPopUpText[] =               "Chandelle";
const char HitBuntText[] =                "Amorti";

//infield location by angle
const char InfieldLocationTexts[] =       "le long de\200la ligne de <3B>\0"
                                          "\200au troisième.\0"
                                          "\200dans le trou <SS>-<3B>.\0"
                                          "\200à l'arrêt-court.\0"
                                          "\200au milieu.\0"
                                          "\200au deuxième.\0"
                                          "\200dans le trou <1B>-<2B>.\0"
                                          "\200au premier.\0"
                                          "le long de\200la ligne du <1B>";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "au\200%s.";

//fielded, replace %s with player name
const char CaughtByText[] =               "%s fait\200l'attrap<e`>.";
const char LeapingCatchByText[] =         "%s saute\200 et l'attrape.";
const char DivingCatchByText[] =          "%s avec\200l'attrap<e`> en plongeant.";
const char FieldedByText[] =              "Capt<e`> par\200%s.";

//errors
const char OffTheGloveOfText[] =          "Sur le gant de\200%s.";
const char BobbledByText[] =              "Échapp<e`> par\200%s.";
const char BadThrowByText[] =             "Un mauvais lancer\200de %s.";

//throw, replace %s with player name, append base thrown to
const char ThrowsToText[] =               "Lance à %s.";

//tag, replace %s with player name
const char PlacesTheTagText[] =           "%s\200effectue le toucher.";

//dead ball
const char DeadBallText[] =               "Balle morte !";

//strike
const char StrikeText[] =                 "Prise %s !";
const char StrikeOutLookingText[] =       "%s est retir<e`>\200sans balancer !";
const char StrikeOutSwingingText[] =      "%s retir<e`>\200au bâton !";

//no swing
const char BallText[] =                   "Balle %s.";
const char WalkText[] =                   "%s sur base\200avec un but sur balles.";
const char PassedBallText[] =             "Balle pass<e`>e !";
const char WildPitchText[] =              "Mauvais lancer !";
const char HitByPitchText[] =             "Ça l'a touch<e`>, donc\200%s est sur la <1B>.";
const char BenchesClearText[] =           "Et les bancs se\200vident.";

//runners on
const char RunnersOnBaseTexts[] =         "Personne sur les\200buts.\0"
                                          "Coureur en\200première base.\0"
                                          "Coureur au\200deuxième.\0"
                                          "Coureurs au premier\200et au deuxième.\0"
                                          "Coureur au\200troisième.\0"
                                          "Coureurs au premier\200et au troisième.\0"
                                          "Coureurs aux deuxième\200et troisième.\0"
                                          "Bases pleines.";

//tagging up
const char TaggingFromTexts[] =           "%s repart du\200premier.\0"
                                          "%s va\200repartir du deuxième.\0"
                                          "S'<e`>lance du troisième\200est %s.";

//safe/out
const char SafeText[] =                   "Sauf !";
const char OutText[] =                    "Retir<e`> !";
const char DoublePlayText[] =             "Double jeu !";
const char TriplePlayText[] =             "Triple jeu !";

//foul
const char HitFoulTipText[] =             "Foul tip.";
const char HitFoulBackText[] =            "Foul ball vers\200l'arrière.";
const char HitFoulBallText[] =            "Balle fausse !";
const char InFoulTerritoryText[] =        "en\200territoire des fausses balles.";

//hit
const char HitBaseHitText[] =             "Coup sûr !";
const char HitDoubleText[] =              "Double !";
const char HitTripleText[] =              "Triple !";
const char HitHomeRunText[] =             "COUP DE CIRCUIT !";
const char HitGrandSlamText[] =           "GRAND CHELEM !";
const char CriticalHitText[] =            "Coup critique !";

//score
const char PlayerScoresText[] =           "marque.";
const char TwoPlayersScoreText[] =        "et\200%s marquent.";
const char BasesClearedScoreText[] =      "Et ça vide\200les buts.";

//end of frame
const char BottomOfTheText[] =            "Bas de\200la %s.";
const char TopOfTheText[] =               "D<e`>but de\200la %s.";

//end of game
const char AndThatsTheBallGameText[] =    "Et c'est la fin\200du match.";
