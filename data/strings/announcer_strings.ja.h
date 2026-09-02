//
// announcer_strings.ja.h
//

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
