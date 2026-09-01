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
const char HitDeepFlyBallText[] =         "Bola de mosca profunda";
const char HitFlyBallText[] =             "Pelota voladora";
const char HitShallowFlyBallText[] =      "Mosca poco profunda";
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
const char CaughtByText[] =               "%s hace la captura.";
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
const char HitGrandSlamText[] =           "<!>Jonr<o`>n con las\200bases llenas!";
const char CriticalHitText[] =            "<!>Impacto cr<i`>tico!";

//score
const char PlayerScoresText[] =           " puntuaciones.";
const char TwoPlayersScoreText[] =        " y puntaje\200%s.";
const char BasesClearedScoreText[] =      "Y eso borra las bases.";

//end of frame
const char BottomOfTheText[] =            "Inferior de\200t %s.";
const char TopOfTheText[] =               "Superior\200 del %s.";

//end of game
const char AndThatsTheBallGameText[] =    "Y ese es el juego.";

#elif defined(LANG_FR)//French

//positions ordered by position id
const char PositionTexts[] =              "lanceur\0"
                                          "receveur\0"
                                          "premier but\0"
                                          "deuxième but\0"
                                          "joueur de troisième base\0"
                                          "arrêt-court\0"
                                          "voltigeur de gauche\0"
                                          "voltigeur de centre\0"
                                          "voltigeur de droite";

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
const char HitDeepFlyBallText[] =         "Balle haute profonde";
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
const char BenchesClearText[] =           "Et les bancs se vident.";

//runners on
const char RunnersOnBaseTexts[] =         "Personne sur les buts.\0"
                                          "Coureur en première base.\0"
                                          "Coureur au deuxième.\0"
                                          "Coureurs au premier\200et au deuxième.\0"
                                          "Coureur au troisième.\0"
                                          "Coureurs au premier\200et au troisième.\0"
                                          "Coureurs aux deuxième\200et troisième.\0"
                                          "Bases pleines.";

//tagging up
const char TaggingFromTexts[] =           "%s repart du premier.\0"
                                          "%s va\200repartir du deuxième.\0"
                                          "S'<e`>lance du troisième\200est %s.";

//safe/out
const char SafeText[] =                   "Sauf !";
const char OutText[] =                    "Retir<e`> !";
const char DoublePlayText[] =             "Double jeu !";
const char TriplePlayText[] =             "Triple jeu !";

//foul
const char HitFoulTipText[] =             "Foul tip.";
const char HitFoulBackText[] =            "Foul ball vers l'arrière.";
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

#elif defined(LANG_IT)//Italian

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
const char EarlySwingText[] =             "Swing anticipato.";
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
const char BenchesClearText[] =           "E le panchine si svuotano.";

//runners on
const char RunnersOnBaseTexts[] =         "Nessuno in base.\0"
                                          "Corridore in prima.\0"
                                          "Corridore in seconda.\0"
                                          "Corridori in prima\200e seconda.\0"
                                          "Corritore in terza.\0"
                                          "Corridori in prima\200e terza.\0"
                                          "Corridori in seconda\200e terza.\0"
                                          "Basi piene";

//tagging up
const char TaggingFromTexts[] =           "%s parte dalla prima.\0"
                                          "%s ripartirà\200dalla seconda.\0"
                                          "Pesta da terza\200è %s.";

//safe/out
const char SafeText[] =                   "Salvo!";
const char OutText[] =                    "Fuori!";
const char DoublePlayText[] =             "Doppio gioco!";
const char TriplePlayText[] =             "Triplo gioco!";

//foul
const char HitFoulTipText[] =             "Foul tip";
const char HitFoulBackText[] =            "Fallo all'indietro.";
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

#elif defined(LANG_PT)//Portuguese

//positions ordered by position id
const char PositionTexts[] =              "arremessador\0"
                                          "receptor\0"
                                          "primeira-base\0"
                                          "segunda-base\0"
                                          "terceiro-base\0"
                                          "interbase\0"
                                          "jardinheiro esquerdo\0"
                                          "jardineiro central\0"
                                          "jardineiro direito";

//ordinal numbers for innings
const char InningTexts[] =                "1º\0"
                                          "2º\0"
                                          "3º\0"
                                          "4º\0"
                                          "5º\0"
                                          "6º\0"
                                          "7º\0"
                                          "8º\0"
                                          "9º\0"
                                          "10º\0"
                                          "11º\0"
                                          "12º";

//base names
const char BaseTexts[] =                  "primeira\0"
                                          "segunda\0"
                                          "terceira\0"
                                          "home plate";

//beginning of frame
const char TakesTheMoundText[] =          "%s assume o\200montinho.";
const char WalksToThePlateText[] =        "%s caminha\200at<e`> o home plate.";

//move selected
const char BatterStepsIntoTheBoxText[] =  "%s entra\200na caixa.";
const char PitcherSetsText[] =            "%s se prepara.";

//beginning of play
const char AndThePitchText[] =            "E o arremesso.";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\200Um %s.";

//after pitch
const char EarlySwingText[] =             "Swing adiantado.";
const char LateSwingText[] =              "Swing atrasado.";
const char SwingAndMissText[] =           "Swing e errou.";
const char HitBarrelText[] =              "Pegou em cheio\200na bola.";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "Bola alta e profunda";
const char HitFlyBallText[] =             "Bola alta";
const char HitShallowFlyBallText[] =      "Fly curto";
const char HitPopFlyText[] =              "Pop fly";

//outfield location by angle
const char OutfieldLocationTexts[] =      "pela\200linha de <LF>.\0"
                                          "para o\200campo esquerdo.\0"
                                          "para\200o centro-esquerdo.\0"
                                          "para o\200jardim central.\0"
                                          "para o\200centro-direito.\0"
                                          "para o\200campo direito.\0"
                                          "pela\200linha do <RF>.";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "Linhada";
const char HitSoftLinerText[] =           "Linha suave";
const char HitGroundBallText[] =          "Bola rasteira";
const char HitChopperText[] =             "Um chopper";
const char HitPopUpText[] =               "Subiu";
const char HitBuntText[] =                "Buntou";

//infield location by angle
const char InfieldLocationTexts[] =       "pela\200linha da <3B>\0"
                                          "\200para a terceira.\0"
                                          "\200no buraco <SS>-<3B>.\0"
                                          "\200para o interbase.\0"
                                          "\200pelo meio.\0"
                                          "\200para a segunda.\0"
                                          "\200no buraco de <1B>-<2B>.\0"
                                          "\200para a primeira.\0"
                                          "pela\200linha de <1B>";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "ao\200%s.";

//fielded, replace %s with player name
const char CaughtByText[] =               "%s faz\200a captura.";
const char LeapingCatchByText[] =         "%s salta\200e agarra.";
const char DivingCatchByText[] =          "%s com\200a defesa de peixinho.";
const char FieldedByText[] =              "Defendido por\200%s.";

//errors
const char OffTheGloveOfText[] =          "Fora da luva de\200%s.";
const char BobbledByText[] =              "Bobeado por\200%s.";
const char BadThrowByText[] =             "Um mau arremesso\200de %s.";

//throw, replace %s with player name, append base thrown to
const char ThrowsToText[] =               "Arremessa para %s.";

//tag, replace %s with player name
const char PlacesTheTagText[] =           "%s\200aplica o tag.";

//dead ball
const char DeadBallText[] =               "Bola morta!";

//strike
const char StrikeText[] =                 "Strike %s!";
const char StrikeOutLookingText[] =       "%s <e`> pego\200olhando!";
const char StrikeOutSwingingText[] =      "%s foi ponchado\200balançando!";

//no swing
const char BallText[] =                   "Bola %s.";
const char WalkText[] =                   "%s na base\200com um walk.";
const char PassedBallText[] =             "Bola passada!";
const char WildPitchText[] =              "Lançamento\200descontrolado!";
const char HitByPitchText[] =             "Acertou nele, então\200%s est<a`> na <1B>.";
const char BenchesClearText[] =           "E os bancos se esvaziam.";

//runners on
const char RunnersOnBaseTexts[] =         "Ningu<e`>m nas bases.\0"
                                          "Corredor na primeira.\0"
                                          "Corredor na segunda.\0"
                                          "Corredores na primeira\200e segunda.\0"
                                          "Corredor na terceira.\0"
                                          "Corredores na primeira\200e terceira.\0"
                                          "Corredores na segunda\200e terceira.\0"
                                          "Bases lotadas.";

//tagging up
const char TaggingFromTexts[] =           "%s pisa e corre da primeira.\0"
                                          "%s vai\200correr da segunda.\0"
                                          "Avançando da terceira\200<e`> %s.";

//safe/out
const char SafeText[] =                   "Salvo!";
const char OutText[] =                    "Fora!";
const char DoublePlayText[] =             "Jogada Dupla!";
const char TriplePlayText[] =             "Jogada tripla!";

//foul
const char HitFoulTipText[] =             "Foul tip.";
const char HitFoulBackText[] =            "Foul para tr<a`>s.";
const char HitFoulBallText[] =            "Bola de foul!";
const char InFoulTerritoryText[] =        "em\200territ<o`>rio foul.";

//hit
const char HitBaseHitText[] =             "Tacada simples!";
const char HitDoubleText[] =              "Dupla!";
const char HitTripleText[] =              "Triplo!";
const char HitHomeRunText[] =             "HOME RUN!";
const char HitGrandSlamText[] =           "GRAND SLAM!";
const char CriticalHitText[] =            "Acerto cr<i`>tico!";

//score
const char PlayerScoresText[] =           "marca.";
const char TwoPlayersScoreText[] =        "e\200%s marcam.";
const char BasesClearedScoreText[] =      "E isso limpa\200as bases.";

//end of frame
const char BottomOfTheText[] =            "Parte inferior\200do %s.";
const char TopOfTheText[] =               "Topo da\200%s.";

//end of game
const char AndThatsTheBallGameText[] =    "E fim de\200jogo.";

#elif defined(LANG_DE)//German

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
const char PitcherSetsText[] =            "%s macht sich bereit.";

//beginning of play
const char AndThePitchText[] =            "Und der Wurf.";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\200Ein %s.";

//after pitch
const char EarlySwingText[] =             "Fr<u:>her Schwung.";
const char LateSwingText[] =              "Später Schwung.";
const char SwingAndMissText[] =           "Schwung und Fehlschlag.";
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
const char HitSoftLinerText[] =           "Weicher Line Drive";
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
const char BenchesClearText[] =           "Und die Bänke leeren sich.";

//runners on
const char RunnersOnBaseTexts[] =         "Niemand auf Base.\0"
                                          "Läufer auf der ersten Base.\0"
                                          "Läufer auf der zweiten Base.\0"
                                          "Läufer auf der ersten\200und zweiten Base.\0"
                                          "Läufer auf der dritten Base.\0"
                                          "Läufer auf 1.\200und 3. Base.\0"
                                          "Läufer auf der zweiten\200und dritten Base.\0"
                                          "Alle Bases besetzt.";

//tagging up
const char TaggingFromTexts[] =           "%s r<u:>ckt von First nach.\0"
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
const char CriticalHitText[] =            "Kritischer Treffer!";

//score
const char PlayerScoresText[] =           "erzielt einen Run.";
const char TwoPlayersScoreText[] =        "und\200%s punkten.";
const char BasesClearedScoreText[] =      "Und das räumt\200die Bases ab.";

//end of frame
const char BottomOfTheText[] =            "Unteres\200%s.";
const char TopOfTheText[] =               "Anfang\200des %s.";

//end of game
const char AndThatsTheBallGameText[] =    "Und das ist das\200Spiel.";

#elif defined(LANG_JA)//Japanese

//positions ordered by position id
const char PositionTexts[] =              "投手\0"
                                          "捕手\0"
                                          "一塁手\0"
                                          "二塁手\0"
                                          "三塁手\0"
                                          "遊撃手\0"
                                          "左翼手\0"
                                          "中堅手\0"
                                          "右翼手";

//ordinal numbers for innings
const char InningTexts[] =                "1回\0"
                                          "2回\0"
                                          "3回\0"
                                          "4回\0"
                                          "5回\0"
                                          "6回\0"
                                          "7回\0"
                                          "8回\0"
                                          "9回\0"
                                          "10回\0"
                                          "11回\0"
                                          "12回";

//base names
const char BaseTexts[] =                  "一塁\0"
                                          "二塁\0"
                                          "三塁\0"
                                          "本塁";

//beginning of frame
const char TakesTheMoundText[] =          "%sが\200マウンドに上がります。";
const char WalksToThePlateText[] =        "%sが打席に\200向かいます。";

//move selected
const char BatterStepsIntoTheBoxText[] =  "%sが\200打席に入ります。";
const char PitcherSetsText[] =            "%sがセットに入ります。";

//beginning of play
const char AndThePitchText[] =            "投げました。";

//append to "And the pitch." text, replace %s with pitch name
const char ThrewAPitchText[] =            "\200%s。";

//after pitch
const char EarlySwingText[] =             "早いスイング";
const char LateSwingText[] =              "振り遅れ";
const char SwingAndMissText[] =           "空振り";
const char HitBarrelText[] =              "芯で捉えた！";

//hit to outfield - append outfield location
const char HitDeepFlyBallText[] =         "大きなフライ";
const char HitFlyBallText[] =             "フライボール";
const char HitShallowFlyBallText[] =      "浅いフライ";
const char HitPopFlyText[] =              "ポップフライ";

//outfield location by angle
const char OutfieldLocationTexts[] =      "<LF>線\200沿い。\0"
                                          "レフトへ\0"
                                          "左中間へ\0"
                                          "センターへ\0"
                                          "右中間へ\0"
                                          "ライトへ\0"
                                          "<RF>線沿い";

//hit to infield - append infield location or "to the" position text
const char HitLineDriveText[] =           "ライナー";
const char HitSoftLinerText[] =           "弱いライナー";
const char HitGroundBallText[] =          "ゴロ";
const char HitChopperText[] =             "ボテボテのゴロ";
const char HitPopUpText[] =               "打ち上げた";
const char HitBuntText[] =                "バント";

//infield location by angle
const char InfieldLocationTexts[] =       "<3B>線\200沿い\0"
                                          "\200サードへ\0"
                                          "\200<SS>-<3B>の間。\0"
                                          "\200ショートへ。\0"
                                          "\200センターへ\0"
                                          "\200セカンドへ\0"
                                          "\200<1B>-<2B>間へ\0"
                                          "\200一塁へ。\0"
                                          "<1B>線沿い";

//append to bunts and popups, replace %s with position
const char ToThePositionText[] =          "%sへ";

//fielded, replace %s with player name
const char CaughtByText[] =               "%sが\200キャッチ。";
const char LeapingCatchByText[] =         "%sがジャンプして\200キャッチ！";
const char DivingCatchByText[] =          "%sの\200ダイビングキャッチ。";
const char FieldedByText[] =              "%sが捕球";

//errors
const char OffTheGloveOfText[] =          "%sのグラブを\200弾いた";
const char BobbledByText[] =              "%sがファンブル。";
const char BadThrowByText[] =             "%sからの\200悪送球";

//throw, replace %s with player name, append base thrown to
const char ThrowsToText[] =               "%sへ送球。";

//tag, replace %s with player name
const char PlacesTheTagText[] =           "%sが\200タッチします。";

//dead ball
const char DeadBallText[] =               "ボールデッド！";

//strike
const char StrikeText[] =                 "ストライク%s！";
const char StrikeOutLookingText[] =       "%s\200見逃し三振！";
const char StrikeOutSwingingText[] =      "%s\200空振り三振！";

//no swing
const char BallText[] =                   "ボール%s。";
const char WalkText[] =                   "%sが四球で\200出塁。";
const char PassedBallText[] =             "パスボール！";
const char WildPitchText[] =              "ワイルドピッチ！";
const char HitByPitchText[] =             "デッドボール！\200%sは<1B>へ。";
const char BenchesClearText[] =           "両軍のベンチから選手が飛び出します。";

//runners on
const char RunnersOnBaseTexts[] =         "ランナーなし\0"
                                          "ランナー一塁\0"
                                          "ランナー2塁\0"
                                          "ランナー一、二塁\0"
                                          "ランナー3塁\0"
                                          "ランナー一・\200三塁\0"
                                          "ランナー2・3塁\0"
                                          "満塁。";

//tagging up
const char TaggingFromTexts[] =           "%sが一塁からタッチアップ。\0"
                                          "%sは2塁から\200タッチアップ。\0"
                                          "サードからのタッチアップは\200%s。";

//safe/out
const char SafeText[] =                   "セーフ！";
const char OutText[] =                    "アウト！";
const char DoublePlayText[] =             "ダブルプレー！";
const char TriplePlayText[] =             "トリプルプレー!";

//foul
const char HitFoulTipText[] =             "ファウルチップ";
const char HitFoulBackText[] =            "ファウルバック";
const char HitFoulBallText[] =            "ファウルボール！";
const char InFoulTerritoryText[] =        "ファウルエリア\200で";

//hit
const char HitBaseHitText[] =             "ヒット！";
const char HitDoubleText[] =              "ツーベース！";
const char HitTripleText[] =              "スリーベース！";
const char HitHomeRunText[] =             "ホームラン！";
const char HitGrandSlamText[] =           "満塁ホームラン！";
const char CriticalHitText[] =            "クリティカルヒット！";

//score
const char PlayerScoresText[] =           "が生還。";
const char TwoPlayersScoreText[] =        "と\200%sが得点。";
const char BasesClearedScoreText[] =      "これで走者一掃！";

//end of frame
const char BottomOfTheText[] =            "%sの裏";
const char TopOfTheText[] =               "%sの表";

//end of game
const char AndThatsTheBallGameText[] =    "これで\200ゲームセットです。";
#endif
