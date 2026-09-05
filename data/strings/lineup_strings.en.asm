;
; lineup_strings.en.asm
;

;moves
UnableText::                              DB "NOT ABLE", 0
AbleText::                                DB "ABLE", 0
NotCompatibleWithText::                   DB "is not\ncompatible with\n%s.", 0
TheyCantLearnText::                       DB "They can't learn\n%s.", 0
TryingToLearnText::                       DB "is\ntrying to learn\n%s!", 0
ButCantLearnMoreText::                    DB "But, %s\ncan't learn more\nthan 4 moves.", 0
ForgetAMoveText::                         DB "Forget an older\nmove to make room\nfor %s?", 0
AbandonLearningText::                     DB "Abandon learning\n%s?", 0
DidNotLearnText::                         DB "\ndid not learn\n%s!", 0
WhichMoveShouldBeForgottenText::          DB "Which move should\nbe forgotten?", 0
OneTwoAndPoofText::                       DB "1, 2 and... Poof!", 0
PlayerForgotMoveText::                    DB "forgot\n%s!", 0
AndElipsisText::                          DB "And...", 0
PlayerLearnedMoveText::                   DB "learned\n%s!", 0

;items
ItWontHaveAnyEffectText::                 DB "It won't have any\neffect.", 0
StatusClearedText::                       DB "Status cleared.", 0
PlayerUsedItemText::                      DB "used\n%s.", 0
PlayerRecoveredByNumberText::             DB "\nrecovered by %s!", 0

;evolution
WhatPlayerIsEvolvingText::                DB "What? %s\nis changing!", 0
PlayerEvolvedIntoText::                   DB "is\nnow %s!", 0

;menus
FromWorldMenuText::                       DB "STATS\nBAT ORDER\nPOSITION\nCANCEL", 0
FromGameMenuText::                        DB "STATS\nPOSITION\nCANCEL", 0

;stats
BatStatName::                             DB "BAT", 0
FieldStatName::                           DB "FIELD", 0
SpeedStatName::                           DB "SPEED", 0
ThrowStatName::                           DB "THROW", 0
StatScreenStatusText::                    DB "STATUS/", 0
StatScreenTypeText::                      DB "TYPE", 0
StatScreenPayText::                       DB "PAY/", 0
