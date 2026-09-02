//
// announcer_strings.pt.h
//

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
