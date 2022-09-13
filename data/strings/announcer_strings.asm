IF DEF(_LANG_EN);English

;positions ordered by position id
PositionTexts::                 
  .pitcher:                      DB "pitcher",0
  .catcher:                      DB "catcher",0
  .first:                        DB "first baseman",0
  .second:                       DB "second baseman",0
  .third:                        DB "third baseman",0
  .shortstop:                    DB "shortstop",0
  .left:                         DB "left fielder",0
  .center:                       DB "center fielder",0
  .right:                        DB "right fielder",0

;ordinal numbers for innings
InningTexts::                   
  .first:                        DB "1st",0
  .second:                       DB "2nd",0
  .third:                        DB "3rd",0
  .fourth:                       DB "4th",0
  .fifth:                        DB "5th",0
  .sixth:                        DB "6th",0
  .seventh:                      DB "7th",0
  .eighth:                       DB "8th",0
  .ninth:                        DB "9th",0
  .tenth:                        DB "10th",0
  .eleventh:                     DB "11th",0
  .twelfth:                      DB "12th",0

;base names
BaseTexts::                     
  .first:                        DB "first",0
  .second:                       DB "second",0
  .third:                        DB "third",0
  .home:                         DB "home plate",0

;beginning of frame
TakesTheMoundText::              DB "%s takes\nthe mound.",0
WalksToThePlateText::            DB "%s walks\nup to the plate.",0

;move selected
BatterStepsIntoTheBoxText::      DB "%s steps\ninto the box.",0
PitcherSetsText::                DB "%s sets.",0

;beginning of play
AndThePitchText::                DB "And the pitch.",0

;append to "And the pitch." text, replace %s with pitch name
ThrewAPitchText::                DB "\nA %s.",0

;after pitch
EarlySwingText::                 DB "Early swing.",0
LateSwingText::                  DB "Late swing.",0
SwingAndMissText::               DB "Swing and a miss.",0
HitBarrelText::                  DB "Really got the\nbarrel on that one.",0

;hit to outfield - append outfield location
HitDeepFlyBallText::             DB "Deep fly ball ",0
HitFlyBallText::                 DB "Fly ball ",0
HitShallowFlyBallText::          DB "Shallow fly ",0
HitPopFlyText::                  DB "Pop fly ",0

;outfield location by angle
OutfieldLocationTexts::         
  .leftLine:                     DB "down\nthe <LF> line.",0
  .leftField:                    DB "to\nleft field.",0
  .leftCenter:                   DB "to\nleft center.",0
  .centerField:                  DB "to\ncenter field.",0
  .rightCenter:                  DB "to\nright center.",0
  .rightField:                   DB "to\nright field.",0
  .rightLine:                    DB "down\nthe <RF> line.",0

;hit to infield - append infield location or "to the" position text
HitLineDriveText::               DB "Line drive ",0
HitGroundBallText::              DB "Ground ball ",0
HitChopperText::                 DB "A chopper ",0
HitPopUpText::                   DB "Popped up ",0
HitBuntText::                    DB "Bunted ",0

;infield location by angle
InfieldLocationTexts::          
  .thirdBaseLine:                DB "down\nthe <3B> line",0
  .third:                        DB "\nto third.",0
  .shortThirdHole:               DB "\nin the <SS>-<3B> hole.",0
  .short:                        DB "\nto short.",0
  .upTheMiddle:                  DB "\nup the middle.",0
  .second:                       DB "\nto second.",0
  .firstSecondHole:              DB "\nin the <1B>-<2B> hole.",0
  .first:                        DB "\nto first.",0
  .firstBaseLine:                DB "down\nthe <1B> line",0

;append to bunts and popups, replace %s with position
ToThePositionText::              DB "to the\n%s.",0

;fielded, replace %s with player name
CaughtByText::                   DB "%s makes\nthe catch.",0
LeapingCatchByText::             DB "%s leaps\n and snags it.",0
DivingCatchByText::              DB "%s with\nthe diving grab.",0
FieldedByText::                  DB "Fielded by\n%s.",0

;errors
OffTheGloveOfText::              DB "Off the glove of\n%s.",0
BobbledByText::                  DB "Bobbled by\n%s.",0
BadThrowByText::                 DB "A bad throw\nfrom %s.",0

;throw, replace %s with player name, append base thrown to
ThrowsToText::                   DB "Throws to %s.",0

;tag, replace %s with player name
PlacesTheTagText::               DB "%s\nplaces the tag.",0

;dead ball
DeadBallText::                   DB "Dead ball!",0

;strike
StrikeText::                     DB "Strike %s!",0
StrikeOutLookingText::           DB "%s strikes\nout looking!",0
StrikeOutSwingingText::          DB "%s strikes\nout swinging!",0

;no swing
BallText::                       DB "Ball %s.",0
WalkText::                       DB "%s on base\nwith a walk.",0
PassedBallText::                 DB "Wild pitch!",0
WildPitchText::                  DB "Passed ball!",0
HitByPitchText::                 DB "That hit 'em, so\n%s is on <1B>.",0
BenchesClearText::               DB "And the benches clear.",0

;runners on
RunnersOnBaseTexts::            
  .nobody:                       DB "Nobody on base.",0
  .first:                        DB "Runner on first.",0
  .second:                       DB "Runner on second.",0
  .firstAndSecond:               DB "Runners on first\nand second.",0
  .third:                        DB "Runner on third.",0
  .firstAndThird:                DB "Runners on first\nand third.",0
  .secondAndThird:               DB "Runners on second\nand third.",0
  .basesLoaded:                  DB "Bases loaded.",0

;tagging up
TaggingFromTexts::              
  .first:                        DB "%s tags from first.",0
  .second:                       DB "%s will\ntag from second.",0
  .third:                        DB "Tagging from third\nis %s.",0

;safe/out
SafeText::                       DB "Safe!",0
OutText::                        DB "Out!",0
DoublePlayText::                 DB "Double Play!",0
TriplePlayText::                 DB "Triple Play!",0

;foul
HitFoulTipText::                 DB "Foul tip.",0
HitFoulBackText::                DB "Foulled back.",0
HitFoulBallText::                DB "Foul Ball!",0
InFoulTerritoryText::            DB "in\nfoul territory.",0

;hit
HitBaseHitText::                 DB "Base hit!",0
HitDoubleText::                  DB "Double!",0
HitTripleText::                  DB "Triple!",0
HitHomeRunText::                 DB "HOME RUN!",0
HitGrandSlamText::               DB "GRAND SLAM!",0
CriticalHitText::                DB "Critical hit!",0

;score
PlayerScoresText::               DB " scores.",0
TwoPlayersScoreText::            DB " and\n%s score.",0
BasesClearedScoreText::          DB "And that clears\nthe bases.",0

;end of frame
BottomOfTheText::                DB "Bottom of\nthe %s.",0
TopOfTheText::                   DB "Top of\nthe %s.",0

;end of game
AndThatsTheBallGameText::        DB "And that's the\nball game.",0
ELIF DEF(_LANG_ES);Spanish

;positions ordered by position id
PositionTexts::                 
  .pitcher:                      DB "lanzador",0
  .catcher:                      DB "receptor",0
  .first:                        DB "primera base",0
  .second:                       DB "segunda base",0
  .third:                        DB "tercera base",0
  .shortstop:                    DB "campocorto",0
  .left:                         DB "jardinero izquierdo",0
  .center:                       DB "jardinero central",0
  .right:                        DB "jardinero derecho",0

;ordinal numbers for innings
InningTexts::                   
  .first:                        DB "1st",0
  .second:                       DB "2nd",0
  .third:                        DB "3rd",0
  .fourth:                       DB "4th",0
  .fifth:                        DB "5th",0
  .sixth:                        DB "6th",0
  .seventh:                      DB "7th",0
  .eighth:                       DB "8th",0
  .ninth:                        DB "9th",0
  .tenth:                        DB "10th",0
  .eleventh:                     DB "11th",0
  .twelfth:                      DB "12th",0

;base names
BaseTexts::                     
  .first:                        DB "primero",0
  .second:                       DB "segundo",0
  .third:                        DB "tercera",0
  .home:                         DB "plato casero",0

;beginning of frame
TakesTheMoundText::              DB "%s en el\nmontículo",0
WalksToThePlateText::            DB "%s se acerca\nal plato.",0

;move selected
BatterStepsIntoTheBoxText::      DB "%s pasos\ninto la caja.",0
PitcherSetsText::                DB "%s conjuntos.",0

;beginning of play
AndThePitchText::                DB "Y el tono.",0

;append to "And the pitch." text, replace %s with pitch name
ThrewAPitchText::                DB "\nUn %s.",0

;after pitch
EarlySwingText::                 DB "Swing temprano.",0
LateSwingText::                  DB "Swing tardío.",0
SwingAndMissText::               DB "Swing y una señorita.",0
HitBarrelText::                  DB "Realmente tengo el\nbarrel en ese.",0

;hit to outfield - append outfield location
HitDeepFlyBallText::             DB "Bola de mosca profunda",0
HitFlyBallText::                 DB "Pelota voladora",0
HitShallowFlyBallText::          DB "Mosca poco profunda",0
HitPopFlyText::                  DB "Mosca",0

;outfield location by angle
OutfieldLocationTexts::         
  .leftLine:                     DB "Abajo\nthe <LF> <LF> línea.",0
  .leftField:                    DB "a\njardín izquierdo.",0
  .leftCenter:                   DB "a\ncentro izquierda.",0
  .centerField:                  DB "a\njardin centro.",0
  .rightCenter:                  DB "a\ncentro derecho",0
  .rightField:                   DB "a\njardín derecho.",0
  .rightLine:                    DB "Abajo\nthe <RF> línea.",0

;hit to infield - append infield location or "to the" position text
HitLineDriveText::               DB "Línea de línea",0
HitGroundBallText::              DB "Bola de tierra",0
HitChopperText::                 DB "Un helicóptero",0
HitPopUpText::                   DB "Aparecido",0
HitBuntText::                    DB "Buntado",0

;infield location by angle
InfieldLocationTexts::          
  .thirdBaseLine:                DB "abajo\nthe <3B> línea",0
  .third:                        DB "nto tercero.",0
  .shortThirdHole:               DB "Nin el hoyo <SS> -<3B>.",0
  .short:                        DB "nto corto.",0
  .upTheMiddle:                  DB "nup the Middle.",0
  .second:                       DB "nto segundo.",0
  .firstSecondHole:              DB "Nin el hoyo  <1B>-<2B>.",0
  .first:                        DB "nto primero.",0
  .firstBaseLine:                DB "abajo\nthe <1B> línea",0

;append to bunts and popups, replace %s with position
ToThePositionText::              DB "al\n%s.",0

;fielded, replace %s with player name
CaughtByText::                   DB "%s hace la captura.",0
LeapingCatchByText::             DB "%s salta\n y lo engancha.",0
DivingCatchByText::              DB "%s con\nthe Diving Grab.",0
FieldedByText::                  DB "Filentado por\n%s.",0

;errors
OffTheGloveOfText::              DB "Fuera del guante de\n%s.",0
BobbledByText::                  DB "Bobado por\n%s.",0
BadThrowByText::                 DB "Un mal lanzamiento\nfrom %s.",0

;throw, replace %s with player name, append base thrown to
ThrowsToText::                   DB "Lanza a %s.",0

;tag, replace %s with player name
PlacesTheTagText::               DB "%s\nplaces la etiqueta.",0

;dead ball
DeadBallText::                   DB "¡Pelota muerta!",0

;strike
StrikeText::                     DB "¡Huelgas!",0
StrikeOutLookingText::           DB "%s huelga\nout mirando!",0
StrikeOutSwingingText::          DB "%s huelga\nout balanceándose!",0

;no swing
BallText::                       DB "Pelotas.",0
WalkText::                       DB "%s en la base\n con una caminata.",0
PassedBallText::                 DB "¡Partido salvaje!",0
WildPitchText::                  DB "¡Pasó la pelota!",0
HitByPitchText::                 DB "Eso lo golpeó, por lo que\n%s está en <1B>.",0
BenchesClearText::               DB "Y los bancos despejados.",0

;runners on
RunnersOnBaseTexts::            
  .nobody:                       DB "Nadie en la base.",0
  .first:                        DB "Runner en primero.",0
  .second:                       DB "Corredor en segundo.",0
  .firstAndSecond:               DB "Corredores en el primer segundo.",0
  .third:                        DB "Corredor en tercero.",0
  .firstAndThird:                DB "Corredores en el primer\nand tercero.",0
  .secondAndThird:               DB "Corredores en el segundo\nand tercero.",0
  .basesLoaded:                  DB "Bases cargadas.",0

;tagging up
TaggingFromTexts::              
  .first:                        DB "%s etiquetas desde primero.",0
  .second:                       DB "%s será de segundo.",0
  .third:                        DB "Etiquetado de tercero\nis %s.",0

;safe/out
SafeText::                       DB "¡Seguro!",0
OutText::                        DB "¡Afuera!",0
DoublePlayText::                 DB "¡Doble jugada!",0
TriplePlayText::                 DB "¡Juego triple!",0

;foul
HitFoulTipText::                 DB "Consejo sucio.",0
HitFoulBackText::                DB "Flolled de regreso.",0
HitFoulBallText::                DB "¡Bola de falta!",0
InFoulTerritoryText::            DB "en el territorio de\nfoul.",0

;hit
HitBaseHitText::                 DB "¡Base Hit!",0
HitDoubleText::                  DB "¡Doble!",0
HitTripleText::                  DB "¡Triple!",0
HitHomeRunText::                 DB "¡CARRERA!",0
HitGrandSlamText::               DB "GRAND SLAM!",0
CriticalHitText::                DB "¡Impacto crítico!",0

;score
PlayerScoresText::               DB " puntuaciones.",0
TwoPlayersScoreText::            DB " y puntaje\n%s.",0
BasesClearedScoreText::          DB "Y eso borra las bases.",0

;end of frame
BottomOfTheText::                DB "Inferior de\nthe %s.",0
TopOfTheText::                   DB "Superior de\nthe %s.",0

;end of game
AndThatsTheBallGameText::        DB "Y ese es el juego\nball.",0
ENDC
