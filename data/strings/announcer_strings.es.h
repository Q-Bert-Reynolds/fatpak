//
// announcer_strings.es.h
//

//positions ordered by position id
const char PositionTexts[] =              "lanzador\0"
                                          "receptor\0"
                                          "initialista\0"
                                          "intermedista\0"
                                          "antesalista\0"
                                          "campocorto\0"
                                          "jardinero\200izquierdo\0"
                                          "jardinero\200central\0"
                                          "jardinero\200derecho";

//ordinal numbers for innings
const char InningTexts[] =                "1er\0"
                                          "2do\0"
                                          "3er\0"
                                          "4to\0"
                                          "5to\0"
                                          "6to\0"
                                          "7mo\0"
                                          "8vo\0"
                                          "9no\0"
                                          "10ma\0"
                                          "11ro\0"
                                          "12do";

//base names
const char BaseTexts[] =                  "primero\0"
                                          "segundo\0"
                                          "tercera\0"
                                          "el home";

//beginning of frame
const char TakesTheMoundText[] =          "%s en el\200mont<i`>culo";
const char WalksToThePlateText[] =        "%s se acerca\200al plato.";

//move selected
const char BatterStepsIntoTheBoxText[] =  "%s pasos\200into la caja.";
const char PitcherSetsText[] =            "%s conjuntos.";

//beginning of play
const char AndThePitchText[] =            "Y el tono.";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\200Un %s.";

//after pitch
const char EarlySwingText[] =             "Swing temprano.";
const char LateSwingText[] =              "Swing tard<i`>o.";
const char SwingAndMissText[] =           "Abanica.";
const char HitBarrelText[] =              "Realmente tengo\200el barrel en ese.";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "Bola de mosca\200profunda";
const char HitFlyBallText[] =             "Pelota voladora";
const char HitShallowFlyBallText[] =      "Mosca poco\200profunda";
const char HitPopFlyText[] =              "Mosca";

//outfield location by angle
const char OutfieldLocationTexts[] =      "Abajo\200l<i`>nea <LF>.\0"
                                          "a\200jard<i`>n izquierdo.\0"
                                          "a\200centro izquierda.\0"
                                          "a\200jardin centro.\0"
                                          "a\200centro derecho\0"
                                          "a\200jard<i`>n derecho.\0"
                                          "Abajo\200 <RF> l<i`>nea.";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "L<i`>nea de l<i`>nea";
const char HitSoftLinerText[] =           "L<i`>nea suave";
const char HitGroundBallText[] =          "Bola de tierra";
const char HitChopperText[] =             "Un helic<o`>ptero";
const char HitPopUpText[] =               "Aparecido";
const char HitBuntText[] =                "Buntado";

//infield location by angle
const char InfieldLocationTexts[] =       "abajo\200del <3B> l<i`>nea\0"
                                          "\200a tercero.\0"
                                          "\200en el hoyo de <SS>-<3B>.\0"
                                          "\200al campocorto.\0"
                                          "\200en el medio\0"
                                          "\200al segundo.\0"
                                          "\200en el hoyo de <1B>-<2B>.\0"
                                          "\200 al primero.\0"
                                          "abajo\200 <1B> l<i`>nea";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "al\200%s.";

//fielded, replace %s with player name
const char CaughtByText[] =               "%s hace la\200captura.";
const char LeapingCatchByText[] =         "%s salta\200 y lo engancha.";
const char DivingCatchByText[] =          "%s con\200la barrida";
const char FieldedByText[] =              "Filentado por\200%s.";

//errors
const char OffTheGloveOfText[] =          "Fuera del guante de\200%s.";
const char BobbledByText[] =              "Bobado por\200%s.";
const char BadThrowByText[] =             "Un mal lanzamiento\200from %s.";

//throw, replace %s with player name, append base thrown to
const char ThrowsToText[] =               "Lanza a %s.";

//tag, replace %s with player name
const char PlacesTheTagText[] =           "%s\200places la etiqueta.";

//dead ball
const char DeadBallText[] =               "<!>Pelota muerta!";

//strike
const char StrikeText[] =                 "<!>Huelgas!";
const char StrikeOutLookingText[] =       "%s huelga\200out mirando!";
const char StrikeOutSwingingText[] =      "%s huelga\200out balance<a`>ndose!";

//no swing
const char BallText[] =                   "Bola %s.";
const char WalkText[] =                   "%s en la base\200 con una caminata.";
const char PassedBallText[] =             "<!>Pasb<o`>l!";
const char WildPitchText[] =              "<!>Lanzamiento\200salvaje!";
const char HitByPitchText[] =             "Eso lo golpe<o`>, por lo que\200%s est<a`> en <1B>.";
const char BenchesClearText[] =           "Y los bancos\200despejados.";

//runners on
const char RunnersOnBaseTexts[] =         "Nadie en la base.\0"
                                          "Runner en\200primero.\0"
                                          "Corredor en\200segundo.\0"
                                          "Corredores en el\200primer segundo.\0"
                                          "Corredor en\200tercero.\0"
                                          "Corredores en el primer\200y tercero.\0"
                                          "Corredores en el segundo\200y tercero.\0"
                                          "Bases cargadas.";

//tagging up
const char TaggingFromTexts[] =           "%s etiquetas\200desde primero.\0"
                                          "%s ser<a`> de\200segundo.\0"
                                          "Etiquetado de tercero\200is %s.";

//safe/out
const char SafeText[] =                   "<!>Seguro!";
const char OutText[] =                    "<!>Afuera!";
const char DoublePlayText[] =             "<!>Doble jugada!";
const char TriplePlayText[] =             "<!>Juego triple!";

//foul
const char HitFoulTipText[] =             "Consejo sucio.";
const char HitFoulBackText[] =            "Flolled de\200regreso.";
const char HitFoulBallText[] =            "<!>Bola de falta!";
const char InFoulTerritoryText[] =        "en el territorio de\200foul.";

//hit
const char HitBaseHitText[] =             "<!>Indiscutible!";
const char HitDoubleText[] =              "<!>Doble!";
const char HitTripleText[] =              "<!>Triple!";
const char HitHomeRunText[] =             "<!>Jonr<o`>n!";
const char HitGrandSlamText[] =           "<!>Jonr<o`>n con las\200bases llenas!";
const char CriticalHitText[] =            "<!>Impacto\200cr<i`>tico!";

//score
const char PlayerScoresText[] =           " puntuaciones.";
const char TwoPlayersScoreText[] =        " y puntaje\200%s.";
const char BasesClearedScoreText[] =      "Y eso borra las\200bases.";

//end of frame
const char BottomOfTheText[] =            "Inferior de\200t %s.";
const char TopOfTheText[] =               "Superior\200 del %s.";

//end of game
const char AndThatsTheBallGameText[] =    "Y ese es el juego.";
