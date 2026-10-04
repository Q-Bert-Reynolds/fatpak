;
; core_strings.pt.asm
;

;types ordered by type id
TypeStrings::                             DB "", 0
                                          DB "Básico", 0
                                          DB "Quente", 0
                                          DB "Fluido", 0
                                          DB "Elétrico", 0
                                          DB "Enraizado", 0
                                          DB "Frio", 0
                                          DB "Resistente", 0
                                          DB "Sujo", 0
                                          DB "Arenoso", 0
                                          DB "Acróbata", 0
                                          DB "Mental", 0
                                          DB "Irritante", 0
                                          DB "Sólido", 0
                                          DB "Morto", 0
                                          DB "Mito", 0

;status strings from a mask
StatusStrings::                           DB "OK", 0
                                          DB "QMD", 0
                                          DB "CON", 0
                                          DB "PAR", 0
                                          DB "ENV", 0
                                          DB "DOR", 0

;menu strings
CancelString::                            DB "CANCELAR", 0
YesNoText::                               DB "SIM\nNÃO", 0
SaveGameText::                            DB "Deseja\nSALVAR o jogo?", 0
NowSavingText::                           DB "Salvando\nagora...", 0
SavedTheGameText::                        DB "%s salvou\no jogo.", 0

;replace strings
PlayerReplaceText::                       DB "JOGADOR", 0

;title menu
ContinueMenuText::                        DB "CONTINUAR\n", 0
NewGameMenuText::                         DB "NOVO JOGO", 0
OptionsMenuText::                         DB "\nOPÇÕES", 0
ExhibitionMenuText::                      DB "\nEXIBIÇÃO", 0
