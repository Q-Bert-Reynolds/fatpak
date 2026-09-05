;
; lineup_strings.de.asm
;

;moves
UnableText::                              DB "NICHT ERLERNBAR", 0
AbleText::                                DB "ERLERNBAR", 0
NotCompatibleWithText::                   DB "ist nicht\nkompatibel mit\n%s.", 0
TheyCantLearnText::                       DB "Kann %s\nnicht erlernen.", 0
TryingToLearnText::                       DB "versucht,\n%s zu erlernen!", 0
ButCantLearnMoreText::                    DB "Aber %s\nkann nicht mehr\nals 4 Attacken erlernen.", 0
ForgetAMoveText::                         DB "Soll eine ältere\nAttacke vergessen werden,\num Platz für %s zu machen?", 0
AbandonLearningText::                     DB "Erlernen von\n%s abbrechen?", 0
DidNotLearnText::                         DB "\nhat %s\nnicht gelernt!", 0
WhichMoveShouldBeForgottenText::          DB "Welche Attacke soll\nvergessen werden?", 0
OneTwoAndPoofText::                       DB "1, 2 und... Schwups!", 0
PlayerForgotMoveText::                    DB "hat\n%s vergessen!", 0
AndElipsisText::                          DB "Und...", 0
PlayerLearnedMoveText::                   DB "hat\n%s erlernt!", 0

;items
ItWontHaveAnyEffectText::                 DB "Es hat keine\nWirkung.", 0
StatusClearedText::                       DB "Status geheilt.", 0
PlayerUsedItemText::                      DB "setzte\n%s ein.", 0
PlayerRecoveredByNumberText::             DB "\num %s erholt!", 0

;evolution
WhatPlayerIsEvolvingText::                DB "Hä? %s\nentwickelt sich!", 0
PlayerEvolvedIntoText::                   DB "ist\njetzt %s!", 0

;menus
FromWorldMenuText::                       DB "STATUS\nREIHENFOLGE\nPOSITION\nZURÜCK", 0
FromGameMenuText::                        DB "STATUS\nPOSITION\nZURÜCK", 0

;stats
BatStatName::                             DB "SCHLAG", 0
FieldStatName::                           DB "FELD", 0
SpeedStatName::                           DB "TEMPO", 0
ThrowStatName::                           DB "WURF", 0
StatScreenStatusText::                    DB "STATUS/", 0
StatScreenTypeText::                      DB "TYP", 0
StatScreenPayText::                       DB "GEHALT/", 0
