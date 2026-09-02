;
; core_strings.de.asm
;

;types ordered by type id
TypeStrings::                             DB " ", 0
                                          DB "Basis", 0
                                          DB "Heiß", 0
                                          DB "Flüssig", 0
                                          DB "Elektrisch", 0
                                          DB "Verwurzelt", 0
                                          DB "Kühl", 0
                                          DB "Hart", 0
                                          DB "Schmutzig", 0
                                          DB "Körnig", 0
                                          DB "Akrobat", 0
                                          DB "Mental", 0
                                          DB "Lästig", 0
                                          DB "Fest", 0
                                          DB "Tot", 0
                                          DB "Mythos", 0

;status strings from a mask
StatusStrings::                           DB "OK", 0
                                          DB "BRN", 0
                                          DB "GEF", 0
                                          DB "PAR", 0
                                          DB "PSN", 0
                                          DB "SCH", 0

;menu strings
CancelString::                            DB "ABBRECHEN", 0
YesNoText::                               DB "JA\nNEIN", 0
SaveGameText::                            DB "Möchtest du das\nSpiel SPEICHERN?", 0
NowSavingText::                           DB "Wird gespeichert...", 0
SavedTheGameText::                        DB "%s hat das Spiel\ngespeichert.", 0
