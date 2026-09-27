;
; core_strings.en.asm
;

;types ordered by type id
TypeStrings::                             DB "", 0
                                          DB "Basic", 0
                                          DB "Hot", 0
                                          DB "Fluid", 0
                                          DB "Electric", 0
                                          DB "Rooted", 0
                                          DB "Chill", 0
                                          DB "Tough", 0
                                          DB "Filthy", 0
                                          DB "Gritty", 0
                                          DB "Acrobat", 0
                                          DB "Mental", 0
                                          DB "Pesky", 0
                                          DB "Solid", 0
                                          DB "Dead", 0
                                          DB "Myth", 0

;status strings from a mask
StatusStrings::                           DB "OK", 0
                                          DB "BRN", 0
                                          DB "FRZ", 0
                                          DB "PAR", 0
                                          DB "PSN", 0
                                          DB "SLP", 0

;menu strings
CancelString::                            DB "CANCEL", 0
YesNoText::                               DB "YES\nNO", 0
SaveGameText::                            DB "Would you like to\nSAVE the game?", 0
NowSavingText::                           DB "Now saving...", 0
SavedTheGameText::                        DB "%s saved\nthe game.", 0

;replace strings
PlayerReplaceText::                       DB "PLAYER", 0

;title menu
ContinueMenuText::                        DB "CONTINUE\n", 0
NewGameMenuText::                         DB "NEW GAME", 0
OptionsMenuText::                         DB "\nOPTIONS", 0
ExhibitionMenuText::                      DB "\nEXHIBITION", 0
