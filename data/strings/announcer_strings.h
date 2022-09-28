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
const char TakesTheMoundText[] =          "%s takes\x80the mound.";
const char WalksToThePlateText[] =        "%s walks\x80up to the plate.";

//move selected
const char BatterStepsIntoTheBoxText[] =  "%s steps\x80into the box.";
const char PitcherSetsText[] =            "%s sets.";

//beginning of play
const char AndThePitchText[] =            "And the pitch.";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\x80A %s.";

//after pitch
const char EarlySwingText[] =             "Early swing.";
const char LateSwingText[] =              "Late swing.";
const char SwingAndMissText[] =           "Swing and a miss.";
const char HitBarrelText[] =              "Really got the\x80barrel on that one.";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "Deep fly ball ";
const char HitFlyBallText[] =             "Fly ball ";
const char HitShallowFlyBallText[] =      "Shallow fly ";
const char HitPopFlyText[] =              "Pop fly ";

//outfield location by angle
const char OutfieldLocationTexts[] =      "down\x80the <LF> line.\0"
                                          "to\x80left field.\0"
                                          "to\x80left center.\0"
                                          "to\x80center field.\0"
                                          "to\x80right center.\0"
                                          "to\x80right field.\0"
                                          "down\x80the <RF> line.";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "Line drive ";
const char HitGroundBallText[] =          "Ground ball ";
const char HitChopperText[] =             "A chopper ";
const char HitPopUpText[] =               "Popped up ";
const char HitBuntText[] =                "Bunted ";

//infield location by angle
const char InfieldLocationTexts[] =       "down\x80the <3B> line\0"
                                          "\x80to third.\0"
                                          "\x80in the <SS>-<3B> hole.\0"
                                          "\x80to short.\0"
                                          "\x80up the middle.\0"
                                          "\x80to second.\0"
                                          "\x80in the <1B>-<2B> hole.\0"
                                          "\x80to first.\0"
                                          "down\x80the <1B> line";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "to the\x80%s.";

//fielded, replace %s with player name
const char CaughtByText[] =               "%s makes\x80the catch.";
const char LeapingCatchByText[] =         "%s leaps\x80 and snags it.";
const char DivingCatchByText[] =          "%s with\x80the diving grab.";
const char FieldedByText[] =              "Fielded by\x80%s.";

//errors
const char OffTheGloveOfText[] =          "Off the glove of\x80%s.";
const char BobbledByText[] =              "Bobbled by\x80%s.";
const char BadThrowByText[] =             "A bad throw\x80from %s.";

//throw, replace %s with player name, append base thrown to
const char ThrowsToText[] =               "Throws to %s.";

//tag, replace %s with player name
const char PlacesTheTagText[] =           "%s\x80places the tag.";

//dead ball
const char DeadBallText[] =               "Dead ball!";

//strike
const char StrikeText[] =                 "Strike %s!";
const char StrikeOutLookingText[] =       "%s strikes\x80out looking!";
const char StrikeOutSwingingText[] =      "%s strikes\x80out swinging!";

//no swing
const char BallText[] =                   "Ball %s.";
const char WalkText[] =                   "%s on base\x80with a walk.";
const char PassedBallText[] =             "Passed ball!";
const char WildPitchText[] =              "Wild pitch!";
const char HitByPitchText[] =             "That hit 'em, so\x80%s is on <1B>.";
const char BenchesClearText[] =           "And the benches clear.";

//runners on
const char RunnersOnBaseTexts[] =         "Nobody on base.\0"
                                          "Runner on first.\0"
                                          "Runner on second.\0"
                                          "Runners on first\x80and second.\0"
                                          "Runner on third.\0"
                                          "Runners on first\x80and third.\0"
                                          "Runners on second\x80and third.\0"
                                          "Bases loaded.";

//tagging up
const char TaggingFromTexts[] =           "%s tags from first.\0"
                                          "%s will\x80tag from second.\0"
                                          "Tagging from third\x80is %s.";

//safe/out
const char SafeText[] =                   "Safe!";
const char OutText[] =                    "Out!";
const char DoublePlayText[] =             "Double Play!";
const char TriplePlayText[] =             "Triple Play!";

//foul
const char HitFoulTipText[] =             "Foul tip.";
const char HitFoulBackText[] =            "Foulled back.";
const char HitFoulBallText[] =            "Foul Ball!";
const char InFoulTerritoryText[] =        "in\x80foul territory.";

//hit
const char HitBaseHitText[] =             "Base hit!";
const char HitDoubleText[] =              "Double!";
const char HitTripleText[] =              "Triple!";
const char HitHomeRunText[] =             "HOME RUN!";
const char HitGrandSlamText[] =           "GRAND SLAM!";
const char CriticalHitText[] =            "Critical hit!";

//score
const char PlayerScoresText[] =           " scores.";
const char TwoPlayersScoreText[] =        " and\x80%s score.";
const char BasesClearedScoreText[] =      "And that clears\x80the bases.";

//end of frame
const char BottomOfTheText[] =            "Bottom of\x80the %s.";
const char TopOfTheText[] =               "Top of\x80the %s.";

//end of game
const char AndThatsTheBallGameText[] =    "And that's the\x80ball game.";

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
const char TakesTheMoundText[] =          "%s en el\x80montículo";
const char WalksToThePlateText[] =        "%s se acerca\x80al plato.";

//move selected
const char BatterStepsIntoTheBoxText[] =  "%s pasos\x80into la caja.";
const char PitcherSetsText[] =            "%s conjuntos.";

//beginning of play
const char AndThePitchText[] =            "Y el tono.";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\x80Un %s.";

//after pitch
const char EarlySwingText[] =             "Swing temprano.";
const char LateSwingText[] =              "Swing tardío.";
const char SwingAndMissText[] =           "Swing y una señorita.";
const char HitBarrelText[] =              "Realmente tengo el\x80barrel en ese.";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "Bola de mosca profunda";
const char HitFlyBallText[] =             "Pelota voladora";
const char HitShallowFlyBallText[] =      "Mosca poco profunda";
const char HitPopFlyText[] =              "Mosca";

//outfield location by angle
const char OutfieldLocationTexts[] =      "Abajo\x80the <LF> <LF> línea.\0"
                                          "a\x80jardín izquierdo.\0"
                                          "a\x80centro izquierda.\0"
                                          "a\x80jardin centro.\0"
                                          "a\x80centro derecho\0"
                                          "a\x80jardín derecho.\0"
                                          "Abajo\x80the <RF> línea.";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "Línea de línea";
const char HitGroundBallText[] =          "Bola de tierra";
const char HitChopperText[] =             "Un helicóptero";
const char HitPopUpText[] =               "Aparecido";
const char HitBuntText[] =                "Buntado";

//infield location by angle
const char InfieldLocationTexts[] =       "abajo\x80el<3B> línea\0"
                                          "nto tercero.\0"
                                          "Nin el hoyo <SS> -<3B>.\0"
                                          "nto corto.\0"
                                          "nup the Middle.\0"
                                          "nto segundo.\0"
                                          "Nin el hoyo  <1B>-<2B>.\0"
                                          "nto primero.\0"
                                          "abajo\x80el <1B> línea";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "al\x80%s.";

//fielded, replace %s with player name
const char CaughtByText[] =               "%s hace la captura.";
const char LeapingCatchByText[] =         "%s salta\x80 y lo engancha.";
const char DivingCatchByText[] =          "%s con\x80the Diving Grab.";
const char FieldedByText[] =              "Filentado por\x80%s.";

//errors
const char OffTheGloveOfText[] =          "Fuera del guante de\x80%s.";
const char BobbledByText[] =              "Bobado por\x80%s.";
const char BadThrowByText[] =             "Un mal lanzamiento\x80from %s.";

//throw, replace %s with player name, append base thrown to
const char ThrowsToText[] =               "Lanza a %s.";

//tag, replace %s with player name
const char PlacesTheTagText[] =           "%s\x80places la etiqueta.";

//dead ball
const char DeadBallText[] =               "¡Pelota muerta!";

//strike
const char StrikeText[] =                 "¡Huelgas!";
const char StrikeOutLookingText[] =       "%s huelga\x80out mirando!";
const char StrikeOutSwingingText[] =      "%s huelga\x80out balanceándose!";

//no swing
const char BallText[] =                   "Bola %s.";
const char WalkText[] =                   "%s en la base\x80 con una caminata.";
const char PassedBallText[] =             "¡Pasból!";
const char WildPitchText[] =              "¡Lanzamiento\x80salvaje!";
const char HitByPitchText[] =             "Eso lo golpeó, por lo que\x80%s está en <1B>.";
const char BenchesClearText[] =           "Y los bancos despejados.";

//runners on
const char RunnersOnBaseTexts[] =         "Nadie en la base.\0"
                                          "Runner en primero.\0"
                                          "Corredor en segundo.\0"
                                          "Corredores en el primer segundo.\0"
                                          "Corredor en tercero.\0"
                                          "Corredores en el primer\x80y tercero.\0"
                                          "Corredores en el segundo\x80y tercero.\0"
                                          "Bases cargadas.";

//tagging up
const char TaggingFromTexts[] =           "%s etiquetas desde primero.\0"
                                          "%s será de segundo.\0"
                                          "Etiquetado de tercero\x80is %s.";

//safe/out
const char SafeText[] =                   "¡Seguro!";
const char OutText[] =                    "¡Afuera!";
const char DoublePlayText[] =             "¡Doble jugada!";
const char TriplePlayText[] =             "¡Juego triple!";

//foul
const char HitFoulTipText[] =             "Consejo sucio.";
const char HitFoulBackText[] =            "Flolled de regreso.";
const char HitFoulBallText[] =            "¡Bola de falta!";
const char InFoulTerritoryText[] =        "en el territorio de\x80foul.";

//hit
const char HitBaseHitText[] =             "¡Indiscutible!";
const char HitDoubleText[] =              "¡Doble!";
const char HitTripleText[] =              "¡Triple!";
const char HitHomeRunText[] =             "¡Jonrón!";
const char HitGrandSlamText[] =           "GRAND SLAM!";
const char CriticalHitText[] =            "¡Impacto crítico!";

//score
const char PlayerScoresText[] =           " puntuaciones.";
const char TwoPlayersScoreText[] =        " y puntaje\x80%s.";
const char BasesClearedScoreText[] =      "Y eso borra las bases.";

//end of frame
const char BottomOfTheText[] =            "Inferior de\x80t %s.";
const char TopOfTheText[] =               "Superior de\x80the %s.";

//end of game
const char AndThatsTheBallGameText[] =    "Y ese es el juego\x80ball.";
#endif
