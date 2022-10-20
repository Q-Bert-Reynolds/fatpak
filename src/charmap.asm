NEWCHARMAP baseball

;SDCC converts unicode to ascii for you and breaks the charmap
;As a workaround translate.py replaces unicode chars with <strings>: 
charmap "<dots>", 10
charmap "<ball>", 11
charmap "<arrow left>", 12
charmap "<arrow right>", 13
charmap "<arrow right off>", 14
charmap "<top left>", 17
charmap "<top right>", 18
charmap "<bottom left>", 19
charmap "<bottom right>", 20
charmap "<_>", 21
charmap "<|>", 22
charmap "<base empty>", 23
charmap "<base occupied>", 24
charmap "<K>", 27
charmap "<down arrow>", 28
charmap "<up arrow>", 29
charmap "<return>", 30
charmap "<+>", 31
charmap "<i`>", 91
charmap "<u:>", 93
charmap "<u`>", 94
charmap "<o`>", 95
charmap "<a`>", 96
charmap "<!>", 123
charmap "<?>", 125
charmap "<n~>", 126
charmap "<e`>", 127

charmap "<P>", 1 ; pitcher
charmap "<C>", 2 ; catcher
charmap "<1B>", 3 ; first
charmap "<2B>", 4 ; second
charmap "<3B>", 5 ; third
charmap "<SS>", 6 ; short
charmap "<LF>", 7 ; left
charmap "<CF>", 8 ; center
charmap "<RF>", 9 ; right
charmap "◌", 10 ; dotted circle
charmap "○", 11 ; baseball
charmap "◀", 12
charmap "▶", 13
charmap "▷", 14
charmap "<to>", 15
charmap "<yr>", 16
charmap "┌", 17
charmap "┐", 18
charmap "└", 19
charmap "┘", 20
charmap "─", 21
charmap "│", 22
charmap "◇", 23
charmap "◆", 24
charmap "<ERA>", 25
charmap "<BA>", 26
charmap "ꓘ", 27
charmap "▼", 28 ;bottom of the inning
charmap "▲", 29 ;top of the inning
charmap "↵", 30 ;end/return
charmap "┼", 31
charmap "í", 91
charmap "ü", 93
charmap "ú", 94
charmap "ó", 95
charmap "á", 96
charmap "¡", 123
charmap "¿", 125
charmap "ñ", 126
charmap "é", 127
charmap "\n", 128