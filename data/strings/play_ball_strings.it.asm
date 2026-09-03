;
; play_ball_strings.it.asm
;

;intro
UnsignedPlayerAppearedText::              DB "%s non firmato\nè apparso!", 0
TeamChallengeText::                       DB " vuole giocare \n%s riprese.", 0
PlayBallText::                            DB "Si gioca!", 0

;menu
PlayMenuPlayString::                      DB "GIOC", 0
PlayMenuTeamString::                      DB "SQDA", 0
PlayMenuItemString::                      DB "ROBA", 0
PlayMenuRunString::                       DB "FUGA", 0

;run selected
QuittingIsNotAnOptionText::               DB "Rinunciare non\nè un'opzione!", 0

;play selected
TypeSlashText::                           DB "TIPA/", 0
BlankMoveText::                           DB "--------", 0
