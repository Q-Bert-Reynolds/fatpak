;
; lineup_strings.fr.asm
;

;moves
UnableText::                              DB "INAPTE", 0
AbleText::                                DB "APTE", 0
NotCompatibleWithText::                   DB "n'est pas\ncompatible avec\n%s.", 0
TheyCantLearnText::                       DB "Impossible d'apprendre\n%s.", 0
TryingToLearnText::                       DB "essaie\nd'apprendre\n%s !", 0
ButCantLearnMoreText::                    DB "Mais %s\nne peut pas apprendre\nplus de 4 capacités.", 0
ForgetAMoveText::                         DB "Oublier une ancienne\ncapacité pour faire\nde la place à %s ?", 0
AbandonLearningText::                     DB "Abandonner l'apprentissage\nde %s ?", 0
DidNotLearnText::                         DB "\nn'a pas appris\n%s !", 0
WhichMoveShouldBeForgottenText::          DB "Quelle capacité\ndoit être oubliée ?", 0
OneTwoAndPoofText::                       DB "1, 2 et... Pouf !", 0
PlayerForgotMoveText::                    DB "a oublié\n%s !", 0
AndElipsisText::                          DB "Et...", 0
PlayerLearnedMoveText::                   DB "a appris\n%s!", 0

;items
ItWontHaveAnyEffectText::                 DB "Cela n'aura aucun\neffet.", 0
StatusClearedText::                       DB "Statut rétabli.", 0
PlayerUsedItemText::                      DB "a utilisé\n%s.", 0
PlayerRecoveredByNumberText::             DB "\na récupéré %s !", 0

;evolution
WhatPlayerIsEvolvingText::                DB "Quoi ? %s\névolue !", 0
PlayerEvolvedIntoText::                   DB "est\ndevenu %s !", 0

;menus
FromWorldMenuText::                       DB "STATS\nORDRE COMBAT\nPOSITION\nANNULER", 0
FromGameMenuText::                        DB "STATS\nPOSITION\nANNULER", 0

;stats
BatStatName::                             DB "FRAPPE", 0
FieldStatName::                           DB "TERRAIN", 0
SpeedStatName::                           DB "VITESSE", 0
ThrowStatName::                           DB "LANCER", 0
StatScreenStatusText::                    DB "STATUT/", 0
StatScreenTypeText::                      DB "TYPE", 0
StatScreenPayText::                       DB "PAYE/", 0
