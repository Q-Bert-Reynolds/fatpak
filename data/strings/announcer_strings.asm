
PositionTexts::
.pitcher:
IF DEF(_LANG_ES)
  DB "lanzador",0
ELSE
  DB "pitcher",0
ENDC
.catcher:
IF DEF(_LANG_ES)
  DB "receptor",0
ELSE
  DB "catcher",0
ENDC
.first:
IF DEF(_LANG_ES)
  DB "primera base",0
ELSE
  DB "first baseman",0
ENDC
.second:
IF DEF(_LANG_ES)
  DB "segunda base",0
ELSE
  DB "second baseman",0
ENDC
.third:
IF DEF(_LANG_ES)
  DB "tercera base",0
ELSE
  DB "third baseman",0
ENDC
.shortstop:
IF DEF(_LANG_ES)
  DB "campocorto",0
ELSE
  DB "shortstop",0
ENDC
.left:
IF DEF(_LANG_ES)
  DB "jardinero izquierdo",0
ELSE
  DB "left fielder",0
ENDC
.center:
IF DEF(_LANG_ES)
  DB "jardinero central",0
ELSE
  DB "center fielder",0
ENDC
.right:
IF DEF(_LANG_ES)
  DB "jardinero derecho",0
ELSE
  DB "right fielder",0
ENDC
InningTexts::
.first: DB "1st",0
.second: DB "2nd",0
.third: DB "3rd",0
.fourth: DB "4th",0
.fifth: DB "5th",0
.sixth: DB "6th",0
.seventh: DB "7th",0
.eighth: DB "8th",0
.ninth: DB "9th",0
.tenth: DB "10th",0
.eleventh: DB "11th",0
.twelfth: DB "12th",0
BaseTexts::
.first:
IF DEF(_LANG_ES)
  DB "primero",0
ELSE
  DB "first",0
ENDC
.second:
IF DEF(_LANG_ES)
  DB "segundo",0
ELSE
  DB "second",0
ENDC
.third:
IF DEF(_LANG_ES)
  DB "tercera",0
ELSE
  DB "third",0
ENDC
.home:
IF DEF(_LANG_ES)
  DB "plato casero",0
ELSE
  DB "home plate",0
ENDC
TakesTheMoundText::
IF DEF(_LANG_ES)
  DB "%s en el\nmontículo",0
ELSE
  DB "%s takes\nthe mound.",0
ENDC
WalksToThePlateText::
IF DEF(_LANG_ES)
  DB "%S camina\nup al plato.",0
ELSE
  DB "%s walks\nup to the plate.",0
ENDC
BatterStepsIntoTheBoxText::
IF DEF(_LANG_ES)
  DB "%s pasos\ninto la caja.",0
ELSE
  DB "%s steps\ninto the box.",0
ENDC
PitcherSetsText::
IF DEF(_LANG_ES)
  DB "%s conjuntos.",0
ELSE
  DB "%s sets.",0
ENDC
AndThePitchText::
IF DEF(_LANG_ES)
  DB "Y el tono.",0
ELSE
  DB "And the pitch.",0
ENDC
ThrewAPitchText::
IF DEF(_LANG_ES)
  DB "na %s.",0
ELSE
  DB "\nA %s.",0
ENDC
EarlySwingText::
IF DEF(_LANG_ES)
  DB "Swing temprano.",0
ELSE
  DB "Early swing.",0
ENDC
LateSwingText::
IF DEF(_LANG_ES)
  DB "Swing tardío.",0
ELSE
  DB "Late swing.",0
ENDC
SwingAndMissText::
IF DEF(_LANG_ES)
  DB "Swing y una señorita.",0
ELSE
  DB "Swing and a miss.",0
ENDC
HitBarrelText::
IF DEF(_LANG_ES)
  DB "Realmente tengo el\nbarrel en ese.",0
ELSE
  DB "Really got the\nbarrel on that one.",0
ENDC
HitDeepFlyBallText::
IF DEF(_LANG_ES)
  DB "Bola de mosca profunda",0
ELSE
  DB "Deep fly ball ",0
ENDC
HitFlyBallText::
IF DEF(_LANG_ES)
  DB "Pelota voladora",0
ELSE
  DB "Fly ball ",0
ENDC
HitShallowFlyBallText::
IF DEF(_LANG_ES)
  DB "Mosca poco profunda",0
ELSE
  DB "Shallow fly ",0
ENDC
HitPopFlyText::
IF DEF(_LANG_ES)
  DB "Mosca",0
ELSE
  DB "Pop fly ",0
ENDC
OutfieldLocationTexts::
.leftLine:
IF DEF(_LANG_ES)
  DB "Abajo\nthe ļ ļ línea.",0
ELSE
  DB "down\nthe ļ line.",0
ENDC
.leftField:
IF DEF(_LANG_ES)
  DB "a\nleft campo.",0
ELSE
  DB "to\nleft field.",0
ENDC
.leftCenter:
IF DEF(_LANG_ES)
  DB "a\nleft Center.",0
ELSE
  DB "to\nleft center.",0
ENDC
.centerField:
IF DEF(_LANG_ES)
  DB "a\ncenter campo.",0
ELSE
  DB "to\ncenter field.",0
ENDC
.rightCenter:
IF DEF(_LANG_ES)
  DB "a\nright Center.",0
ELSE
  DB "to\nright center.",0
ENDC
.rightField:
IF DEF(_LANG_ES)
  DB "al campo\nright.",0
ELSE
  DB "to\nright field.",0
ENDC
.rightLine:
IF DEF(_LANG_ES)
  DB "Abajo\nthe ŗ ŗ línea.",0
ELSE
  DB "down\nthe ŗ line.",0
ENDC
HitLineDriveText::
IF DEF(_LANG_ES)
  DB "Línea de línea",0
ELSE
  DB "Line drive ",0
ENDC
HitGroundBallText::
IF DEF(_LANG_ES)
  DB "Bola de tierra",0
ELSE
  DB "Ground ball ",0
ENDC
HitChopperText::
IF DEF(_LANG_ES)
  DB "Un helicóptero",0
ELSE
  DB "A chopper ",0
ENDC
HitPopUpText::
IF DEF(_LANG_ES)
  DB "Aparecido",0
ELSE
  DB "Popped up ",0
ENDC
HitBuntText::
IF DEF(_LANG_ES)
  DB "Buntado",0
ELSE
  DB "Bunted ",0
ENDC
InfieldLocationTexts::
.thirdBaseLine:
IF DEF(_LANG_ES)
  DB "abajo\nthe ³ línea",0
ELSE
  DB "down\nthe ³ line",0
ENDC
.third:
IF DEF(_LANG_ES)
  DB "nto tercero.",0
ELSE
  DB "\nto third.",0
ENDC
.shortThirdHole:
IF DEF(_LANG_ES)
  DB "Nin el hoyo ş -³.",0
ELSE
  DB "\nin the ş-³ hole.",0
ENDC
.short:
IF DEF(_LANG_ES)
  DB "nto corto.",0
ELSE
  DB "\nto short.",0
ENDC
.upTheMiddle:
IF DEF(_LANG_ES)
  DB "nup the Middle.",0
ELSE
  DB "\nup the middle.",0
ENDC
.second:
IF DEF(_LANG_ES)
  DB "nto segundo.",0
ELSE
  DB "\nto second.",0
ENDC
.firstSecondHole:
IF DEF(_LANG_ES)
  DB "Nin el hoyo ¹ -ie.",0
ELSE
  DB "\nin the ¹-² hole.",0
ENDC
.first:
IF DEF(_LANG_ES)
  DB "nto primero.",0
ELSE
  DB "\nto first.",0
ENDC
.firstBaseLine:
IF DEF(_LANG_ES)
  DB "abajo\nthe ¹ línea",0
ELSE
  DB "down\nthe ¹ line",0
ENDC
ToThePositionText::
IF DEF(_LANG_ES)
  DB "al\n%s.",0
ELSE
  DB "to the\n%s.",0
ENDC
CaughtByText::
IF DEF(_LANG_ES)
  DB "%s hace la captura.",0
ELSE
  DB "%s makes\nthe catch.",0
ENDC
LeapingCatchByText::
IF DEF(_LANG_ES)
  DB "%s salta\n y lo engancha.",0
ELSE
  DB "%s leaps\n and snags it.",0
ENDC
DivingCatchByText::
IF DEF(_LANG_ES)
  DB "%s con\nthe Diving Grab.",0
ELSE
  DB "%s with\nthe diving grab.",0
ENDC
FieldedByText::
IF DEF(_LANG_ES)
  DB "Filentado por\n%s.",0
ELSE
  DB "Fielded by\n%s.",0
ENDC
OffTheGloveOfText::
IF DEF(_LANG_ES)
  DB "Fuera del guante de\n%s.",0
ELSE
  DB "Off the glove of\n%s.",0
ENDC
BobbledByText::
IF DEF(_LANG_ES)
  DB "Bobado por\n%s.",0
ELSE
  DB "Bobbled by\n%s.",0
ENDC
BadThrowByText::
IF DEF(_LANG_ES)
  DB "Un mal lanzamiento\nfrom %s.",0
ELSE
  DB "A bad throw\nfrom %s.",0
ENDC
ThrowsToText::
IF DEF(_LANG_ES)
  DB "Lanza a %s.",0
ELSE
  DB "Throws to %s.",0
ENDC
PlacesTheTagText::
IF DEF(_LANG_ES)
  DB "%s\nplaces la etiqueta.",0
ELSE
  DB "%s\nplaces the tag.",0
ENDC
DeadBallText::
IF DEF(_LANG_ES)
  DB "¡Pelota muerta!",0
ELSE
  DB "Dead ball!",0
ENDC
StrikeText::
IF DEF(_LANG_ES)
  DB "¡Huelgas!",0
ELSE
  DB "Strike %s!",0
ENDC
StrikeOutLookingText::
IF DEF(_LANG_ES)
  DB "%s huelga\nout mirando!",0
ELSE
  DB "%s strikes\nout looking!",0
ENDC
StrikeOutSwingingText::
IF DEF(_LANG_ES)
  DB "%s huelga\nout balanceándose!",0
ELSE
  DB "%s strikes\nout swinging!",0
ENDC
BallText::
IF DEF(_LANG_ES)
  DB "Pelotas.",0
ELSE
  DB "Ball %s.",0
ENDC
WalkText::
IF DEF(_LANG_ES)
  DB "%s en la base\n con una caminata.",0
ELSE
  DB "%s on base\nwith a walk.",0
ENDC
PassedBallText::
IF DEF(_LANG_ES)
  DB "¡Partido salvaje!",0
ELSE
  DB "Wild pitch!",0
ENDC
WildPitchText::
IF DEF(_LANG_ES)
  DB "¡Pasó la pelota!",0
ELSE
  DB "Passed ball!",0
ENDC
HitByPitchText::
IF DEF(_LANG_ES)
  DB "Eso lo golpeó, por lo que\n%s está en ¹.",0
ELSE
  DB "That hit 'em, so\n%s is on ¹.",0
ENDC
BenchesClearText::
IF DEF(_LANG_ES)
  DB "Y los bancos despejados.",0
ELSE
  DB "And the benches clear.",0
ENDC
RunnersOnBaseTexts::
.nobody:
IF DEF(_LANG_ES)
  DB "Nadie en la base.",0
ELSE
  DB "Nobody on base.",0
ENDC
.first:
IF DEF(_LANG_ES)
  DB "Runner en primero.",0
ELSE
  DB "Runner on first.",0
ENDC
.second:
IF DEF(_LANG_ES)
  DB "Corredor en segundo.",0
ELSE
  DB "Runner on second.",0
ENDC
.firstAndSecond:
IF DEF(_LANG_ES)
  DB "Corredores en el primer segundo.",0
ELSE
  DB "Runners on first\nand second.",0
ENDC
.third:
IF DEF(_LANG_ES)
  DB "Corredor en tercero.",0
ELSE
  DB "Runner on third.",0
ENDC
.firstAndThird:
IF DEF(_LANG_ES)
  DB "Corredores en el primer\nand tercero.",0
ELSE
  DB "Runners on first\nand third.",0
ENDC
.secondAndThird:
IF DEF(_LANG_ES)
  DB "Corredores en el segundo\nand tercero.",0
ELSE
  DB "Runners on second\nand third.",0
ENDC
.basesLoaded:
IF DEF(_LANG_ES)
  DB "Bases cargadas.",0
ELSE
  DB "Bases loaded.",0
ENDC
TaggingFromTexts::
.first:
IF DEF(_LANG_ES)
  DB "%s etiquetas desde primero.",0
ELSE
  DB "%s tags from first.",0
ENDC
.second:
IF DEF(_LANG_ES)
  DB "%s será de segundo.",0
ELSE
  DB "%s will\ntag from second.",0
ENDC
.third:
IF DEF(_LANG_ES)
  DB "Etiquetado de tercero\nis %s.",0
ELSE
  DB "Tagging from third\nis %s.",0
ENDC
SafeText::
IF DEF(_LANG_ES)
  DB "¡Seguro!",0
ELSE
  DB "Safe!",0
ENDC
OutText::
IF DEF(_LANG_ES)
  DB "¡Afuera!",0
ELSE
  DB "Out!",0
ENDC
DoublePlayText::
IF DEF(_LANG_ES)
  DB "¡Doble jugada!",0
ELSE
  DB "Double Play!",0
ENDC
TriplePlayText::
IF DEF(_LANG_ES)
  DB "¡Juego triple!",0
ELSE
  DB "Triple Play!",0
ENDC
HitFoulTipText::
IF DEF(_LANG_ES)
  DB "Consejo sucio.",0
ELSE
  DB "Foul tip.",0
ENDC
HitFoulBackText::
IF DEF(_LANG_ES)
  DB "Flolled de regreso.",0
ELSE
  DB "Foulled back.",0
ENDC
HitFoulBallText::
IF DEF(_LANG_ES)
  DB "¡Bola de falta!",0
ELSE
  DB "Foul Ball!",0
ENDC
InFoulTerritoryText::
IF DEF(_LANG_ES)
  DB "en el territorio de\nfoul.",0
ELSE
  DB "in\nfoul territory.",0
ENDC
HitBaseHitText::
IF DEF(_LANG_ES)
  DB "¡Base Hit!",0
ELSE
  DB "Base hit!",0
ENDC
HitDoubleText::
IF DEF(_LANG_ES)
  DB "¡Doble!",0
ELSE
  DB "Double!",0
ENDC
HitTripleText::
IF DEF(_LANG_ES)
  DB "¡Triple!",0
ELSE
  DB "Triple!",0
ENDC
HitHomeRunText::
IF DEF(_LANG_ES)
  DB "¡CARRERA!",0
ELSE
  DB "HOME RUN!",0
ENDC
HitGrandSlamText:: DB "GRAND SLAM!",0
CriticalHitText::
IF DEF(_LANG_ES)
  DB "¡Impacto crítico!",0
ELSE
  DB "Critical hit!",0
ENDC
PlayerScoresText::
IF DEF(_LANG_ES)
  DB " puntuaciones.",0
ELSE
  DB " scores.",0
ENDC
TwoPlayersScoreText::
IF DEF(_LANG_ES)
  DB " y puntaje\n%s.",0
ELSE
  DB " and\n%s score.",0
ENDC
BasesClearedScoreText::
IF DEF(_LANG_ES)
  DB "Y eso borra las bases.",0
ELSE
  DB "And that clears\nthe bases.",0
ENDC
BottomOfTheText::
IF DEF(_LANG_ES)
  DB "Inferior de\nthe %s.",0
ELSE
  DB "Bottom of\nthe %s.",0
ENDC
TopOfTheText::
IF DEF(_LANG_ES)
  DB "Superior de\nthe %s.",0
ELSE
  DB "Top of\nthe %s.",0
ENDC
AndThatsTheBallGameText::
IF DEF(_LANG_ES)
  DB "Y ese es el juego\nball.",0
ELSE
  DB "And that's the\nball game.",0
ENDC