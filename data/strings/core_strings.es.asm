;
; core_strings.es.asm
;

;types ordered by type id
TypeStrings::                             DB "", 0
                                          DB "Básico", 0
                                          DB "Caliente", 0
                                          DB "Fluido", 0
                                          DB "Eléctrico", 0
                                          DB "Arraigado", 0
                                          DB "Frío", 0
                                          DB "Resistente", 0
                                          DB "Sucio", 0
                                          DB "Arenoso", 0
                                          DB "Acróbata", 0
                                          DB "Mental", 0
                                          DB "Molesto", 0
                                          DB "Sólido", 0
                                          DB "Muerto", 0
                                          DB "Mito", 0

;status strings from a mask
StatusStrings::                           DB "OK", 0
                                          DB "QMD", 0
                                          DB "CON", 0
                                          DB "PAR", 0
                                          DB "VEN", 0
                                          DB "DOR", 0

;menu strings
CancelString::                            DB "CANCELAR", 0
YesNoText::                               DB "SÍ\nNO", 0
SaveGameText::                            DB "¿Quieres GUARDAR\nla partida?", 0
NowSavingText::                           DB "Guardando...", 0
SavedTheGameText::                        DB "%s guardó\nla partida.", 0

;replace strings
PlayerReplaceText::                       DB "PELOTERO", 0

;title menu
ContinueMenuText::                        DB "CONTINUAR\n", 0
NewGameMenuText::                         DB "NUEVA PARTIDA", 0
OptionsMenuText::                         DB "\nOPCIONES", 0
ExhibitionMenuText::                      DB "\nEXHIBICIÓN", 0
