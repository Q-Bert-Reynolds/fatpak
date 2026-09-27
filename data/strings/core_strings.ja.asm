;
; core_strings.ja.asm
;

;types ordered by type id
TypeStrings::                             DB "", 0
                                          DB "ベーシック", 0
                                          DB "熱い", 0
                                          DB "流体", 0
                                          DB "電気", 0
                                          DB "根付いた", 0
                                          DB "冷気", 0
                                          DB "タフ", 0
                                          DB "不潔", 0
                                          DB "砂っぽい", 0
                                          DB "アクロバット", 0
                                          DB "メンタル", 0
                                          DB "厄介", 0
                                          DB "固い", 0
                                          DB "死んだ", 0
                                          DB "神話", 0

;status strings from a mask
StatusStrings::                           DB "OK", 0
                                          DB "やけど", 0
                                          DB "こおり", 0
                                          DB "マヒ", 0
                                          DB "どく", 0
                                          DB "ねむり", 0

;menu strings
CancelString::                            DB "キャンセル", 0
YesNoText::                               DB "はい\nいいえ", 0
SaveGameText::                            DB "ゲームを\nセーブしますか？", 0
NowSavingText::                           DB "セーブ中...", 0
SavedTheGameText::                        DB "%sは\nゲームをセーブした。", 0

;replace strings
PlayerReplaceText::                       DB "プレイヤー", 0

;title menu
ContinueMenuText::                        DB "つづきから\n", 0
NewGameMenuText::                         DB "はじめから", 0
OptionsMenuText::                         DB "\nオプション", 0
ExhibitionMenuText::                      DB "\nエキシビション", 0
