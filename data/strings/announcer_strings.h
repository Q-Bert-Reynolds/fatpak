#if defined(LANG_EN)//English

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
const char BenchesClearText[] =           "And the benches clear.";

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
const char TaggingFromTexts[] =           "%s tags from first.\0"
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

#elif defined(LANG_ES)//Spanish

//positions ordered by position id
const char PositionTexts[] =              "lanzador\0"
                                          "receptor\0"
                                          "initialista\0"
                                          "intermedista\0"
                                          "antesalista\0"
                                          "campocorto\0"
                                          "jardinero izquierdo\0"
                                          "jardinero central\0"
                                          "jardinero derecho";

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
const char SwingAndMissText[] =           "Swing y una se<n~>orita.";
const char HitBarrelText[] =              "Realmente tengo el\200barrel en ese.";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "Bola de mosca profunda";
const char HitFlyBallText[] =             "Pelota voladora";
const char HitShallowFlyBallText[] =      "Mosca poco profunda";
const char HitPopFlyText[] =              "Mosca";

//outfield location by angle
const char OutfieldLocationTexts[] =      "Abajo\200the <LF> <LF> l<i`>nea.\0"
                                          "a\200jard<i`>n izquierdo.\0"
                                          "a\200centro izquierda.\0"
                                          "a\200jardin centro.\0"
                                          "a\200centro derecho\0"
                                          "a\200jard<i`>n derecho.\0"
                                          "Abajo\200the <RF> l<i`>nea.";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "L<i`>nea de l<i`>nea";
const char HitGroundBallText[] =          "Bola de tierra";
const char HitChopperText[] =             "Un helic<o`>ptero";
const char HitPopUpText[] =               "Aparecido";
const char HitBuntText[] =                "Buntado";

//infield location by angle
const char InfieldLocationTexts[] =       "abajo\200el<3B> l<i`>nea\0"
                                          "nto tercero.\0"
                                          "Nin el hoyo <SS> -<3B>.\0"
                                          "nto corto.\0"
                                          "nup the Middle.\0"
                                          "nto segundo.\0"
                                          "Nin el hoyo  <1B>-<2B>.\0"
                                          "nto primero.\0"
                                          "abajo\200el <1B> l<i`>nea";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "al\200%s.";

//fielded, replace %s with player name
const char CaughtByText[] =               "%s hace la captura.";
const char LeapingCatchByText[] =         "%s salta\200 y lo engancha.";
const char DivingCatchByText[] =          "%s con\200the Diving Grab.";
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
const char BenchesClearText[] =           "Y los bancos despejados.";

//runners on
const char RunnersOnBaseTexts[] =         "Nadie en la base.\0"
                                          "Runner en primero.\0"
                                          "Corredor en segundo.\0"
                                          "Corredores en el primer segundo.\0"
                                          "Corredor en tercero.\0"
                                          "Corredores en el primer\200y tercero.\0"
                                          "Corredores en el segundo\200y tercero.\0"
                                          "Bases cargadas.";

//tagging up
const char TaggingFromTexts[] =           "%s etiquetas desde primero.\0"
                                          "%s ser<a`> de segundo.\0"
                                          "Etiquetado de tercero\200is %s.";

//safe/out
const char SafeText[] =                   "<!>Seguro!";
const char OutText[] =                    "<!>Afuera!";
const char DoublePlayText[] =             "<!>Doble jugada!";
const char TriplePlayText[] =             "<!>Juego triple!";

//foul
const char HitFoulTipText[] =             "Consejo sucio.";
const char HitFoulBackText[] =            "Flolled de regreso.";
const char HitFoulBallText[] =            "<!>Bola de falta!";
const char InFoulTerritoryText[] =        "en el territorio de\200foul.";

//hit
const char HitBaseHitText[] =             "<!>Indiscutible!";
const char HitDoubleText[] =              "<!>Doble!";
const char HitTripleText[] =              "<!>Triple!";
const char HitHomeRunText[] =             "<!>Jonr<o`>n!";
const char HitGrandSlamText[] =           "GRAND SLAM!";
const char CriticalHitText[] =            "<!>Impacto cr<i`>tico!";

//score
const char PlayerScoresText[] =           " puntuaciones.";
const char TwoPlayersScoreText[] =        " y puntaje\200%s.";
const char BasesClearedScoreText[] =      "Y eso borra las bases.";

//end of frame
const char BottomOfTheText[] =            "Inferior de\200t %s.";
const char TopOfTheText[] =               "Superior de\200the %s.";

//end of game
const char AndThatsTheBallGameText[] =    "Y ese es el juego\200ball.";
#endif
