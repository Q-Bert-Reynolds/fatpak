;
; play_ball_strings.fr.asm
;

;intro
UnsignedPlayerAppearedText::              DB "%s non signé\nest apparu!", 0
TeamChallengeText::                       DB " veut jouer\n%s manches.", 0
PlayBallText::                            DB "Au jeu !", 0

;menu
PlayMenuPlayString::                      DB "JOU", 0
PlayMenuTeamString::                      DB "EQPE", 0
PlayMenuItemString::                      DB "OBJ.", 0
PlayMenuRunString::                       DB "FUIR", 0

;run selected
QuittingIsNotAnOptionText::               DB "Abandonner n'est\npas une option !", 0

;play selected
TypeSlashText::                           DB "TYPE/", 0
BlankMoveText::                           DB "--------", 0
