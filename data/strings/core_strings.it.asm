;
; core_strings.it.asm
;

;types ordered by type id
TypeStrings::                             DB " ", 0
                                          DB "Basico", 0
                                          DB "Caldo", 0
                                          DB "Fluido", 0
                                          DB "Elettrico", 0
                                          DB "Radicato", 0
                                          DB "Freddo", 0
                                          DB "Duro", 0
                                          DB "Sporco", 0
                                          DB "Sabbioso", 0
                                          DB "Acrobata", 0
                                          DB "Mentale", 0
                                          DB "Fastidioso", 0
                                          DB "Solido", 0
                                          DB "Morto", 0
                                          DB "Mito", 0

;status strings from a mask
StatusStrings::                           DB "OK", 0
                                          DB "BRN", 0
                                          DB "CGL", 0
                                          DB "PAR", 0
                                          DB "PSN", 0
                                          DB "SLP", 0

;menu strings
CancelString::                            DB "ANNULLA", 0
YesNoText::                               DB "SÌ\nNO", 0
SaveGameText::                            DB "Vuoi SALVARE\nla partita?", 0
NowSavingText::                           DB "Salvataggio in corso...", 0
SavedTheGameText::                        DB "%s ha salvato\nla partita.", 0
