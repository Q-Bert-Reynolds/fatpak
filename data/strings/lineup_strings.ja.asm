;
; lineup_strings.ja.asm
;

;moves
UnableText::                              DB "おぼえられない", 0
AbleText::                                DB "おぼえられる", 0
NotCompatibleWithText::                   DB "%sとは\nつかえない！", 0
TheyCantLearnText::                       DB "%sは\nおぼえられない！", 0
TryingToLearnText::                       DB "は\n%sを おぼえようとしている！", 0
ButCantLearnMoreText::                    DB "しかしs%は\nワザを　４つまでしか\nおぼえられない！", 0
ForgetAMoveText::                         DB "%sを おぼえさせるために\nほかの わざを わすれさせますか？", 0
AbandonLearningText::                     DB "%sを\nおぼえるのを あきらめますか？", 0
DidNotLearnText::                         DB "\n%sを\nおぼえなかった！", 0
WhichMoveShouldBeForgottenText::          DB "どの わざを\nわすれさせますか？", 0
OneTwoAndPoofText::                       DB "1 2の ……ポカン！", 0
PlayerForgotMoveText::                    DB "%sを\nわすれた！", 0
AndElipsisText::                          DB "そして…", 0
PlayerLearnedMoveText::                   DB "おぼえた！", 0

;items
ItWontHaveAnyEffectText::                 DB "こうかが ない！", 0
StatusClearedText::                       DB "じょうたいが もとに もどった。", 0
PlayerUsedItemText::                      DB "%sを\nつかった！", 0
PlayerRecoveredByNumberText::             DB "\n%s かいふくした！", 0

;evolution
WhatPlayerIsEvolvingText::                DB "おや？ %sの\nようすが…！", 0
PlayerEvolvedIntoText::                   DB "%s に\nしんかした！", 0

;menus
FromWorldMenuText::                       DB "つよさ\nじゅんばん\nばしょ\nやめる", 0
FromGameMenuText::                        DB "つよさをみる\nいれかえ\nやめる", 0

;stats
BatStatName::                             DB "打力", 0
FieldStatName::                           DB "守備", 0
SpeedStatName::                           DB "スピード", 0
ThrowStatName::                           DB "かた", 0
StatScreenStatusText::                    DB "じょうたい/", 0
StatScreenTypeText::                      DB "タイプ", 0
StatScreenPayText::                       DB "ねんほう/", 0
