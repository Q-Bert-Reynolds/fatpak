//
// announcer_strings.it.h
//

//positions ordered by position id
const char PositionTexts[] =              "lanciatore\0"
                                          "ricevitore\0"
                                          "prima base\0"
                                          "secondobase\0"
                                          "terza base\0"
                                          "interbase\0"
                                          "esterno sinistro\0"
                                          "esterno centro\0"
                                          "esterno destro";

//ordinal numbers for innings
const char InningTexts[] =                "1°\0"
                                          "2°\0"
                                          "3°\0"
                                          "4°\0"
                                          "5°\0"
                                          "6°\0"
                                          "7°\0"
                                          "8°\0"
                                          "9°\0"
                                          "10°\0"
                                          "11°\0"
                                          "12°";

//base names
const char BaseTexts[] =                  "prima\0"
                                          "seconda\0"
                                          "terza\0"
                                          "casa base";

//beginning of frame
const char TakesTheMoundText[] =          "%s sale sul\200monte.";
const char WalksToThePlateText[] =        "%s si avvicina\200al piatto.";

//move selected
const char BatterStepsIntoTheBoxText[] =  "%s entra\200nel box.";
const char PitcherSetsText[] =            "%s è pronto.";

//beginning of play
const char AndThePitchText[] =            "E il lancio.";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\200Un %s.";

//after pitch
const char EarlySwingText[] =             "Swing\200anticipato.";
const char LateSwingText[] =              "Swing in ritardo.";
const char SwingAndMissText[] =           "Swing a vuoto";
const char HitBarrelText[] =              "Ha davvero preso\200il centro della mazza.";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "Volata profonda";
const char HitFlyBallText[] =             "Volata";
const char HitShallowFlyBallText[] =      "Volata corta";
const char HitPopFlyText[] =              "Volata alta";

//outfield location by angle
const char OutfieldLocationTexts[] =      "lungo\200la linea di <LF>.\0"
                                          "all'esterno\200sinistro\0"
                                          "a\200centro sinistra.\0"
                                          "al\200campo centrale.\0"
                                          "al\200centro destra.\0"
                                          "al\200campo destro.\0"
                                          "lungo\200la linea di <RF>.";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "Linea";
const char HitSoftLinerText[] =           "Linea morbida";
const char HitGroundBallText[] =          "Palla a terra";
const char HitChopperText[] =             "Un chopper";
const char HitPopUpText[] =               "Spuntato";
const char HitBuntText[] =                "Smorzato";

//infield location by angle
const char InfieldLocationTexts[] =       "lungo\200la linea di <3B>\0"
                                          "\200a terza.\0"
                                          "\200nel buco <SS>-<3B>.\0"
                                          "\200all'interbase.\0"
                                          "\200al centro.\0"
                                          "\200in seconda.\0"
                                          "\200nel buco <1B>-<2B>.\0"
                                          "\200in prima.\0"
                                          "lungo\200la linea di <1B>";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "al\200%s.";

//fielded, replace %s with player name
const char CaughtByText[] =               "%s effettua\200la presa.";
const char LeapingCatchByText[] =         "%s salta\200 e la afferra.";
const char DivingCatchByText[] =          "%s con\200la presa in tuffo.";
const char FieldedByText[] =              "Raccolta da\200%s.";

//errors
const char OffTheGloveOfText[] =          "Fuori dal guanto di\200%s.";
const char BobbledByText[] =              "Mancata da\200%s.";
const char BadThrowByText[] =             "Un brutto tiro\200da %s.";

//throw, replace %s with player name, append base thrown to
const char ThrowsToText[] =               "Lancia a %s.";

//tag, replace %s with player name
const char PlacesTheTagText[] =           "%s\200effettua la toccata.";

//dead ball
const char DeadBallText[] =               "Palla morta!";

//strike
const char StrikeText[] =                 "Strike %s!";
const char StrikeOutLookingText[] =       "%s viene eliminato\200al piatto guardando!";
const char StrikeOutSwingingText[] =      "%s eliminato\200sventolando!";

//no swing
const char BallText[] =                   "Ball %s.";
const char WalkText[] =                   "%s in base\200con una base su ball.";
const char PassedBallText[] =             "Palla passata!";
const char WildPitchText[] =              "Lancio pazzo!";
const char HitByPitchText[] =             "L'ha colpito, quindi\200%s è in <1B>.";
const char BenchesClearText[] =           "E le panchine si\200svuotano.";

//runners on
const char RunnersOnBaseTexts[] =         "Nessuno in base.\0"
                                          "Corridore in\200prima.\0"
                                          "Corridore in\200seconda.\0"
                                          "Corridori in prima\200e seconda.\0"
                                          "Corritore in\200terza.\0"
                                          "Corridori in prima\200e terza.\0"
                                          "Corridori in seconda\200e terza.\0"
                                          "Basi piene";

//tagging up
const char TaggingFromTexts[] =           "%s parte dalla\200prima.\0"
                                          "%s ripartirà\200dalla seconda.\0"
                                          "Pesta da terza\200è %s.";

//safe/out
const char SafeText[] =                   "Salvo!";
const char OutText[] =                    "Fuori!";
const char DoublePlayText[] =             "Doppio gioco!";
const char TriplePlayText[] =             "Triplo gioco!";

//foul
const char HitFoulTipText[] =             "Foul tip";
const char HitFoulBackText[] =            "Fallo\200all'indietro.";
const char HitFoulBallText[] =            "Palla foul!";
const char InFoulTerritoryText[] =        "in\200territorio foul.";

//hit
const char HitBaseHitText[] =             "Valida!";
const char HitDoubleText[] =              "Doppio!";
const char HitTripleText[] =              "Triplo!";
const char HitHomeRunText[] =             "FUORICAMPO!";
const char HitGrandSlamText[] =           "GRAND SLAM!";
const char CriticalHitText[] =            "Colpo critico!";

//score
const char PlayerScoresText[] =           "segna.";
const char TwoPlayersScoreText[] =        "e\200%s segnano.";
const char BasesClearedScoreText[] =      "E questo svuota\200le basi.";

//end of frame
const char BottomOfTheText[] =            "Parte bassa\200del %s.";
const char TopOfTheText[] =               "Parte alta\200del %s.";

//end of game
const char AndThatsTheBallGameText[] =    "E la partita\200finisce qui.";
