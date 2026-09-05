;
; lineup_strings.it.asm
;

;moves
UnableText::                              DB "NON PUÒ", 0
AbleText::                                DB "PUÒ", 0
NotCompatibleWithText::                   DB "non è\ncompatibile con\n%s.", 0
TheyCantLearnText::                       DB "Non può imparare\n%s.", 0
TryingToLearnText::                       DB "sta\ncercando di imparare\n%s!", 0
ButCantLearnMoreText::                    DB "Ma %s\nnon può imparare\npiù di 4 mosse.", 0
ForgetAMoveText::                         DB "Vuoi dimenticare una\nmossa per far posto a\n%s?", 0
AbandonLearningText::                     DB "Rinunciare a imparare\n%s?", 0
DidNotLearnText::                         DB "\nnon ha imparato\n%s!", 0
WhichMoveShouldBeForgottenText::          DB "Quale mossa deve\nessere dimenticata?", 0
OneTwoAndPoofText::                       DB "1, 2 e... Puf!", 0
PlayerForgotMoveText::                    DB "HA DIMENTICATO\n%s!", 0
AndElipsisText::                          DB "E...", 0
PlayerLearnedMoveText::                   DB "ha imparato\n%s!", 0

;items
ItWontHaveAnyEffectText::                 DB "Non avrà alcun\neffetto.", 0
StatusClearedText::                       DB "Stato guarito.", 0
PlayerUsedItemText::                      DB "ha usato\n%s.", 0
PlayerRecoveredByNumberText::             DB "\nha recuperato %s PS!", 0

;evolution
WhatPlayerIsEvolvingText::                DB "Cosa? %s\nsta cambiando!", 0
PlayerEvolvedIntoText::                   DB "è\nora %s!", 0

;menus
FromWorldMenuText::                       DB "INFO\nORDINE\nSPOSTA\nESCI", 0
FromGameMenuText::                        DB "STATS\nPOSIZIONE\nANNULLA", 0

;stats
BatStatName::                             DB "BATT", 0
FieldStatName::                           DB "DIFESA", 0
SpeedStatName::                           DB "VELO", 0
ThrowStatName::                           DB "LANCIO", 0
StatScreenStatusText::                    DB "STATO/", 0
StatScreenTypeText::                      DB "TIPO", 0
StatScreenPayText::                       DB "PAGA/", 0
