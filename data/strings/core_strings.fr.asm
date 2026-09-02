;
; core_strings.fr.asm
;

;types ordered by type id
TypeStrings::                             DB " ", 0
                                          DB "Basique", 0
                                          DB "Chaud", 0
                                          DB "Fluide", 0
                                          DB "Électrique", 0
                                          DB "Enraciné", 0
                                          DB "Froid", 0
                                          DB "Dur", 0
                                          DB "Sale", 0
                                          DB "Sableux", 0
                                          DB "Acrobate", 0
                                          DB "Mental", 0
                                          DB "Agaçant", 0
                                          DB "Solide", 0
                                          DB "Mort", 0
                                          DB "Mythe", 0

;status strings from a mask
StatusStrings::                           DB "OK", 0
                                          DB "BRU", 0
                                          DB "GEL", 0
                                          DB "PAR", 0
                                          DB "POI", 0
                                          DB "SOM", 0

;menu strings
CancelString::                            DB "ANNULER", 0
YesNoText::                               DB "OUI\nNON", 0
SaveGameText::                            DB "Voulez-vous\nSAUVEGARDER?", 0
NowSavingText::                           DB "Sauvegarde en cours...", 0
SavedTheGameText::                        DB "%s a sauvegardé\nla partie.", 0
