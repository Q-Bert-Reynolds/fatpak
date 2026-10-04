;
; lineup_strings.pt.asm
;

;moves
UnableText::                              DB "INCAPAZ", 0
AbleText::                                DB "CAPAZ", 0
NotCompatibleWithText::                   DB "não é\ncompatível com\n%s.", 0
TheyCantLearnText::                       DB "Não pode aprender\n%s.", 0
TryingToLearnText::                       DB "está\ntentando aprender\n%s!", 0
ButCantLearnMoreText::                    DB "Mas %s\nnão pode aprender\nmais de 4 movimentos.", 0
ForgetAMoveText::                         DB "Esquecer um\nmovimento antigo\npara dar lugar a %s?", 0
AbandonLearningText::                     DB "Desistir de aprender\n%s?", 0
DidNotLearnText::                         DB "\nnão aprendeu\n%s!", 0
WhichMoveShouldBeForgottenText::          DB "Qual movimento deve\nser esquecido?", 0
OneTwoAndPoofText::                       DB "1, 2 e... Puf!", 0
PlayerForgotMoveText::                    DB "esqueceu\n%s!", 0
AndElipsisText::                          DB "E...", 0
PlayerLearnedMoveText::                   DB "aprendeu\n%s!", 0

;items
ItWontHaveAnyEffectText::                 DB "Não terá nenhum\nefeito.", 0
StatusClearedText::                       DB "Status\nrestaurado.", 0
PlayerUsedItemText::                      DB "usou\n%s.", 0
PlayerRecoveredByNumberText::             DB "\nrecuperou %s!", 0

;evolution
WhatPlayerIsEvolvingText::                DB "O quê? %s\nestá mudando!", 0
PlayerEvolvedIntoText::                   DB "agora é\n%s!", 0

;menus
FromWorldMenuText::                       DB "DADOS\nORDEM\nPOSIÇÃO\nCANCELAR", 0
FromGameMenuText::                        DB "STATUS\nPOSIÇÃO\nCANCELAR", 0

;stats
BatStatName::                             DB "REBATE", 0
FieldStatName::                           DB "CAMPO", 0
SpeedStatName::                           DB "VELO", 0
ThrowStatName::                           DB "ARREMESSO", 0
StatScreenStatusText::                    DB "STATUS/", 0
StatScreenTypeText::                      DB "TIPO", 0
StatScreenPayText::                       DB "PAGA/", 0
