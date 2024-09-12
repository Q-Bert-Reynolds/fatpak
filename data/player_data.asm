DEF NUM_BUBBI EQU 1
DEF NUM_IVY EQU 2
DEF NUM_VENUS EQU 3
DEF NUM_GINGER EQU 4
DEF NUM_FRECKLES EQU 5
DEF NUM_BIG_RED EQU 6
DEF NUM_SQUIRT EQU 7
DEF NUM_PUDGE EQU 8
DEF NUM_YOGI EQU 9
DEF NUM_SWEET_PEA EQU 10
DEF NUM_META EQU 11
DEF NUM_BUTTERFLY EQU 12
DEF NUM_WEEDS EQU 13
DEF NUM_KOO_KOO EQU 14
DEF NUM_BEEDIE EQU 15
DEF NUM_PIDGE EQU 16
DEF NUM_GIO EQU 17
DEF NUM_OT EQU 18
DEF NUM_RAT_TAIL EQU 19
DEF NUM_CAIT EQU 20
DEF NUM_STOOP EQU 21
DEF NUM_CROW EQU 22
DEF NUM_SNAKE EQU 23
DEF NUM_COBRA EQU 24
DEF NUM_CHU EQU 25
DEF NUM_RAI EQU 26
DEF NUM_SHREW EQU 27
DEF NUM_SANDY EQU 28
DEF NUM_CHICA EQU 29
DEF NUM_MUCHACHA EQU 30
DEF NUM_REINA EQU 31
DEF NUM_CHICO EQU 32
DEF NUM_MUCHACHO EQU 33
DEF NUM_RAY EQU 34
DEF NUM_FAIRY EQU 35
DEF NUM_FABLE EQU 36
DEF NUM_VULFPEK EQU 37
DEF NUM_FOXY EQU 38
DEF NUM_PUFF EQU 39
DEF NUM_TUFF EQU 40
DEF NUM_BATS EQU 41
DEF NUM_GOLD_BATS EQU 42
DEF NUM_ODDIE EQU 43
DEF NUM_GLOOMY EQU 44
DEF NUM_VILE EQU 45
DEF NUM_PARIS EQU 46
DEF NUM_PARIAH EQU 47
DEF NUM_NATTY EQU 48
DEF NUM_MOTHER EQU 49
DEF NUM_DIGGS EQU 50
DEF NUM_DOUG EQU 51
DEF NUM_MEOW EQU 52
DEF NUM_PURR EQU 53
DEF NUM_DUCK EQU 54
DEF NUM_GOLD_DUCK EQU 55
DEF NUM_MAN EQU 56
DEF NUM_PRIMO EQU 57
DEF NUM_LITHIUM EQU 58
DEF NUM_ARCANE EQU 59
DEF NUM_POLLY EQU 60
DEF NUM_SWIRL EQU 61
DEF NUM_WRATH EQU 62
DEF NUM_BRUH EQU 63
DEF NUM_DAB EQU 64
DEF NUM_KAZAA EQU 65
DEF NUM_CHIP EQU 66
DEF NUM_CHOKE EQU 67
DEF NUM_CHAMP EQU 68
DEF NUM_SPROUT EQU 69
DEF NUM_WEEPY EQU 70
DEF NUM_VIC EQU 71
DEF NUM_FONZ EQU 72
DEF NUM_CRUEL EQU 73
DEF NUM_DUDE EQU 74
DEF NUM_GRAVEL EQU 75
DEF NUM_GOLEM EQU 76
DEF NUM_PINTO EQU 77
DEF NUM_MUSTANG EQU 78
DEF NUM_SLOWPOKE EQU 79
DEF NUM_LAGGARD EQU 80
DEF NUM_MAGNET EQU 81
DEF NUM_TON EQU 82
DEF NUM_DUBIOUS EQU 83
DEF NUM_DUCE EQU 84
DEF NUM_TREY EQU 85
DEF NUM_SEAL EQU 86
DEF NUM_SEALION EQU 87
DEF NUM_GREASER EQU 88
DEF NUM_YUCK EQU 89
DEF NUM_CUP EQU 90
DEF NUM_DISH EQU 91
DEF NUM_GAS EQU 92
DEF NUM_MORTY EQU 93
DEF NUM_MACOBB EQU 94
DEF NUM_ONYX EQU 95
DEF NUM_ZEE EQU 96
DEF NUM_MEDIUM EQU 97
DEF NUM_DICK EQU 98
DEF NUM_REX EQU 99
DEF NUM_SPEEDBALL EQU 100
DEF NUM_TUCKER EQU 101
DEF NUM_ED EQU 102
DEF NUM_EDD EQU 103
DEF NUM_BONES EQU 104
DEF NUM_MARROW EQU 105
DEF NUM_BRUCE EQU 106
DEF NUM_JACKIE EQU 107
DEF NUM_TONGUE EQU 108
DEF NUM_ASH EQU 109
DEF NUM_SMOKEY EQU 110
DEF NUM_RHINO EQU 111
DEF NUM_DON EQU 112
DEF NUM_CHANCE EQU 113
DEF NUM_FRIZZ EQU 114
DEF NUM_GENGIS EQU 115
DEF NUM_BRAIN EQU 116
DEF NUM_EINSTEIN EQU 117
DEF NUM_GOLDIE EQU 118
DEF NUM_SEEKER EQU 119
DEF NUM_STARCHILD EQU 120
DEF NUM_STARMAN EQU 121
DEF NUM_MIME EQU 122
DEF NUM_SCISSORS EQU 123
DEF NUM_JINX EQU 124
DEF NUM_BUZZ EQU 125
DEF NUM_MAGMA EQU 126
DEF NUM_PINCH EQU 127
DEF NUM_BULL EQU 128
DEF NUM_FISH EQU 129
DEF NUM_GAR EQU 130
DEF NUM_BUS EQU 131
DEF NUM_YEAH_YEAH EQU 132
DEF NUM_EVIE EQU 133
DEF NUM_VAPOR EQU 134
DEF NUM_JOLT EQU 135
DEF NUM_FALRE EQU 136
DEF NUM_POLYGON EQU 137
DEF NUM_SPIRAL EQU 138
DEF NUM_SPIRE EQU 139
DEF NUM_HORSHOE EQU 140
DEF NUM_TOPPER EQU 141
DEF NUM_ARROWHEAD EQU 142
DEF NUM_BEAR EQU 143
DEF NUM_ART EQU 144
DEF NUM_ZAPH EQU 145
DEF NUM_ELTON EQU 146
DEF NUM_DRATS EQU 147
DEF NUM_AIRE EQU 148
DEF NUM_DRAGON EQU 149
DEF NUM_MIKE EQU 150
DEF NUM_MICK EQU 151
SECTION "Player Data", ROMX, BANK[PLAYER_DATA_BANK]
;weight format: DDDDLLLL LLLLLLLL where D is decimal and L is lbs
;height format: FFFFIIII where F is feet and I is inches

_001BubbiRoledex:
DB 1
DB GRASS
DB POISON
DB $40 ;height
DW $002A ;weight
DB 45 ;HP
DB 49 ;Bat
DB 49 ;Field
DB 45 ;Speed
DB 65 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 0 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteBubbi ;Color Palette
;animations
DB BANK(_001BubbiLeftyBatterUserTiles)
DW _001BubbiLeftyBatterUserTiles
DB _001BUBBI_LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_001BubbiRightyBatterUserTiles)
DW _001BubbiRightyBatterUserTiles
DB _001BUBBI_RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_001BubbiLeftyBatterOpponentTiles)
DW _001BubbiLeftyBatterOpponentTiles
DB _001BUBBI_LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_001BubbiLeftyPitcherOpponentTiles)
DW _001BubbiLeftyPitcherOpponentTiles
DB _001BUBBI_LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_001BubbiRightyPitcherOpponentTiles)
DW _001BubbiRightyPitcherOpponentTiles
DB _001BUBBI_RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $2E, $00, $E0, $1E, $00, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB KUDZUBALL_MOVE, 7
DB HARDWOOD_MOVE, 13
DB NASTY_CURVE_MOVE, 20
DB PLANT_N_TURN_MOVE, 27
DB SLEEPER_MOVE, 41
DB GRASSBURNER_MOVE, 48
DB 0
;evolution
DB EV_TYPE_AGE, 2, 16
DB 0

_002IvyRoledex:
DB 2
DB GRASS
DB POISON
DB $50 ;height
DW $006E ;weight
DB 60 ;HP
DB 62 ;Bat
DB 63 ;Field
DB 60 ;Speed
DB 80 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 4 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteBubbi ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_002IvyLeftyBatterOpponentTiles)
DW _002IvyLeftyBatterOpponentTiles
DB _002IVY_LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_002IvyRightyPitcherOpponentTiles)
DW _002IvyRightyPitcherOpponentTiles
DB _002IVY_RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $2E, $00, $E0, $1E, $00, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB KUDZUBALL_MOVE, 7
DB HARDWOOD_MOVE, 13
DB NASTY_CURVE_MOVE, 22
DB PLANT_N_TURN_MOVE, 30
DB SLEEPER_MOVE, 46
DB GRASSBURNER_MOVE, 54
DB 0
;evolution
DB EV_TYPE_AGE, 3, 32
DB 0

_003VenusRoledex:
DB 3
DB GRASS
DB POISON
DB $60 ;height
DW $00A0 ;weight
DB 80 ;HP
DB 82 ;Bat
DB 83 ;Field
DB 80 ;Speed
DB 100 ;Throw
DB 2 ;Lineup Body
DB 0 ;Lineup Head
DB 4 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteBubbi ;Color Palette
;animations
DB BANK(_003VenusLeftyBatterUserTiles)
DW _003VenusLeftyBatterUserTiles
DB _003VENUS_LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_003VenusRightyBatterUserTiles)
DW _003VenusRightyBatterUserTiles
DB _003VENUS_RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_003VenusRightyPitcherOpponentTiles)
DW _003VenusRightyPitcherOpponentTiles
DB _003VENUS_RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $2E, $10, $E0, $1E, $00, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB KUDZUBALL_MOVE, 7
DB HARDWOOD_MOVE, 13
DB NASTY_CURVE_MOVE, 22
DB PLANT_N_TURN_MOVE, 30
DB SLEEPER_MOVE, 55
DB GRASSBURNER_MOVE, 65
DB 0
;evolution
DB EV_TYPE_NONE

_004GingerRoledex:
DB 4
DB FIRE
DB NONE
DB $50 ;height
DW $0050 ;weight
DB 39 ;HP
DB 52 ;Bat
DB 43 ;Field
DB 65 ;Speed
DB 50 ;Throw
DB 1 ;Lineup Body
DB 2 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteGinger ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_004GingerLeftyPitcherOpponentTiles)
DW _004GingerLeftyPitcherOpponentTiles
DB _004GINGER_LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $95, $6E, $07, $90, $9E, $38, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SWING_MOVE, 1
DB SCORCH_MOVE, 7
DB SCOWL_MOVE, 15
DB RAGE_MOVE, 22
DB SLASH_MOVE, 30
DB FIREBALL_MOVE, 38
DB HIGH_HEAT_MOVE, 46
DB 0
;evolution
DB EV_TYPE_AGE, 5, 16
DB 0

_005FrecklesRoledex:
DB 5
DB FIRE
DB NONE
DB $60 ;height
DW $0082 ;weight
DB 58 ;HP
DB 64 ;Bat
DB 58 ;Field
DB 80 ;Speed
DB 65 ;Throw
DB 2 ;Lineup Body
DB 2 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteGinger ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_005FrecklesLeftyPitcherOpponentTiles)
DW _005FrecklesLeftyPitcherOpponentTiles
DB _005FRECKLES_LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $95, $6E, $07, $90, $9E, $38, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SWING_MOVE, 1
DB SCORCH_MOVE, 7
DB SCOWL_MOVE, 15
DB RAGE_MOVE, 24
DB SLASH_MOVE, 33
DB FIREBALL_MOVE, 42
DB HIGH_HEAT_MOVE, 50
DB 0
;evolution
DB EV_TYPE_AGE, 6, 36
DB 0

_006BigRedRoledex:
DB 6
DB FIRE
DB FLYING
DB $70 ;height
DW $00D2 ;weight
DB 78 ;HP
DB 84 ;Bat
DB 78 ;Field
DB 100 ;Speed
DB 85 ;Throw
DB 7 ;Lineup Body
DB 2 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteGinger ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_006BigRedLeftyPitcherUserTiles)
DW _006BigRedLeftyPitcherUserTiles
DB _006BIGRED_LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_006BigRedLeftyPitcherOpponentTiles)
DW _006BigRedLeftyPitcherOpponentTiles
DB _006BIGRED_LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $95, $6E, $17, $90, $9E, $38, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SWING_MOVE, 1
DB SCORCH_MOVE, 7
DB SCOWL_MOVE, 15
DB RAGE_MOVE, 24
DB SLASH_MOVE, 36
DB FIREBALL_MOVE, 46
DB HIGH_HEAT_MOVE, 55
DB 0
;evolution
DB EV_TYPE_NONE

_007SquirtRoledex:
DB 7
DB WATER
DB NONE
DB $40 ;height
DW $0028 ;weight
DB 44 ;HP
DB 48 ;Bat
DB 65 ;Field
DB 43 ;Speed
DB 50 ;Throw
DB 0 ;Lineup Body
DB 1 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSquirt ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_007SquirtRightyPitcherOpponentTiles)
DW _007SquirtRightyPitcherOpponentTiles
DB _007SQUIRT_RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $6F, $E7, $80, $9E, $08, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB BUBBLEBALL_MOVE, 8
DB SPITBALL_MOVE, 15
DB CURVEBALL_MOVE, 22
DB WITHDRAW_MOVE, 28
DB BASH_MOVE, 35
DB HYDRO_CANNON_MOVE, 42
DB 0
;evolution
DB EV_TYPE_AGE, 8, 16
DB 0

_008PudgeRoledex:
DB 8
DB WATER
DB NONE
DB $50 ;height
DW $00A5 ;weight
DB 59 ;HP
DB 63 ;Bat
DB 80 ;Field
DB 58 ;Speed
DB 65 ;Throw
DB 3 ;Lineup Body
DB 1 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSquirt ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $6F, $E7, $80, $9E, $08, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB BUBBLEBALL_MOVE, 8
DB SPITBALL_MOVE, 15
DB CURVEBALL_MOVE, 24
DB WITHDRAW_MOVE, 31
DB BASH_MOVE, 39
DB HYDRO_CANNON_MOVE, 47
DB 0
;evolution
DB EV_TYPE_AGE, 9, 36
DB 0

_009YogiRoledex:
DB 9
DB WATER
DB NONE
DB $60 ;height
DW $0104 ;weight
DB 79 ;HP
DB 83 ;Bat
DB 100 ;Field
DB 78 ;Speed
DB 85 ;Throw
DB 7 ;Lineup Body
DB 3 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSquirt ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_009YogiRightyBatterUserTiles)
DW _009YogiRightyBatterUserTiles
DB _009YOGI_RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $6F, $F7, $83, $9E, $08, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB BUBBLEBALL_MOVE, 8
DB SPITBALL_MOVE, 15
DB CURVEBALL_MOVE, 24
DB WITHDRAW_MOVE, 31
DB BASH_MOVE, 42
DB HYDRO_CANNON_MOVE, 52
DB 0
;evolution
DB EV_TYPE_NONE

_010SweetPeaRoledex:
DB 10
DB BUG
DB NONE
DB $30 ;height
DW $001C ;weight
DB 45 ;HP
DB 30 ;Bat
DB 35 ;Field
DB 45 ;Speed
DB 20 ;Throw
DB 0 ;Lineup Body
DB 1 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $00, $00, $00, $00, $00, $00 ;HM/TM bit field
;learnset
DB SILKY_SWING_MOVE, 1
DB TOSS_MOVE, 1
DB 0
;evolution
DB EV_TYPE_AGE, 11, 7
DB 0

_011MetaRoledex:
DB 11
DB BUG
DB NONE
DB $45 ;height
DW $0046 ;weight
DB 50 ;HP
DB 20 ;Bat
DB 55 ;Field
DB 30 ;Speed
DB 25 ;Throw
DB 1 ;Lineup Body
DB 1 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $00, $00, $00, $00, $00, $00 ;HM/TM bit field
;learnset
DB HARDEN_MOVE, 1
DB TOSS_MOVE, 1
DB 0
;evolution
DB EV_TYPE_AGE, 12, 10
DB 0

_012ButterflyRoledex:
DB 12
DB BUG
DB FLYING
DB $50 ;height
DW $0091 ;weight
DB 60 ;HP
DB 45 ;Bat
DB 50 ;Field
DB 70 ;Speed
DB 80 ;Throw
DB 1 ;Lineup Body
DB 5 ;Lineup Head
DB 5 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $02, $A6, $10, $E0, $7E, $10, $A2 ;HM/TM bit field
;learnset
DB TOSS_MOVE, 1
DB KINESIS_MOVE, 12
DB PUFF_MOVE, 15
DB KUDZUBALL_MOVE, 16
DB SLEEPER_MOVE, 17
DB SINKER_MOVE, 21
DB KNUCKLECURVE_MOVE, 26
DB PSYCH_OUT_MOVE, 32
DB 0
;evolution
DB EV_TYPE_NONE

_013WeedsRoledex:
DB 13
DB BUG
DB POISON
DB $36 ;height
DW $0023 ;weight
DB 40 ;HP
DB 35 ;Bat
DB 30 ;Field
DB 50 ;Speed
DB 20 ;Throw
DB 0 ;Lineup Body
DB 1 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $00, $00, $00, $00, $00, $00 ;HM/TM bit field
;learnset
DB NASTY_CURVE_MOVE, 1
DB SILKY_SWING_MOVE, 1
DB 0
;evolution
DB EV_TYPE_AGE, 14, 7
DB 0

_014KooKooRoledex:
DB 14
DB BUG
DB POISON
DB $49 ;height
DW $0051 ;weight
DB 45 ;HP
DB 25 ;Bat
DB 50 ;Field
DB 35 ;Speed
DB 25 ;Throw
DB 1 ;Lineup Body
DB 4 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $00, $00, $00, $00, $00, $00 ;HM/TM bit field
;learnset
DB HARDEN_MOVE, 1
DB TOSS_MOVE, 1
DB 0
;evolution
DB EV_TYPE_AGE, 15, 10
DB 0

_015BeedieRoledex:
DB 15
DB BUG
DB POISON
DB $55 ;height
DW $00AA ;weight
DB 65 ;HP
DB 80 ;Bat
DB 40 ;Field
DB 75 ;Speed
DB 45 ;Throw
DB 2 ;Lineup Body
DB 4 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $26, $10, $C0, $1E, $18, $82 ;HM/TM bit field
;learnset
DB BARRAGE_MOVE, 12
DB FOCUS_MOVE, 16
DB THREAD_MOVE, 20
DB RAGE_MOVE, 25
DB PINPOINT_MOVE, 30
DB MEDITATE_MOVE, 35
DB 0
;evolution
DB EV_TYPE_NONE

_016PidgeRoledex:
DB 16
DB NORMAL
DB FLYING
DB $53 ;height
DW $008C ;weight
DB 40 ;HP
DB 45 ;Bat
DB 40 ;Field
DB 56 ;Speed
DB 35 ;Throw
DB 3 ;Lineup Body
DB 4 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $42, $A6, $00, $80, $1E, $F1, $82 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB KICKUP_SAND_MOVE, 1
DB QUICK_SWING_MOVE, 12
DB KNUCKLECURVE_MOVE, 19
DB SKY_SMASH_MOVE, 28
DB MEDITATE_MOVE, 36
DB MOCK_MOVE, 44
DB 0
;evolution
DB EV_TYPE_AGE, 17, 18
DB 0

_017GioRoledex:
DB 17
DB NORMAL
DB FLYING
DB $60 ;height
DW $00D3 ;weight
DB 63 ;HP
DB 60 ;Bat
DB 55 ;Field
DB 71 ;Speed
DB 50 ;Throw
DB 4 ;Lineup Body
DB 1 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $42, $A6, $00, $80, $1E, $F1, $82 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB KICKUP_SAND_MOVE, 1
DB QUICK_SWING_MOVE, 12
DB KNUCKLECURVE_MOVE, 21
DB SKY_SMASH_MOVE, 31
DB MEDITATE_MOVE, 40
DB MOCK_MOVE, 49
DB 0
;evolution
DB EV_TYPE_AGE, 18, 36
DB 0

_018OTRoledex:
DB 18
DB NORMAL
DB FLYING
DB $65 ;height
DW $0111 ;weight
DB 83 ;HP
DB 80 ;Bat
DB 75 ;Field
DB 91 ;Speed
DB 70 ;Throw
DB 7 ;Lineup Body
DB 3 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $42, $A6, $10, $80, $1E, $F1, $82 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB KICKUP_SAND_MOVE, 1
DB QUICK_SWING_MOVE, 12
DB KNUCKLECURVE_MOVE, 21
DB SKY_SMASH_MOVE, 31
DB MEDITATE_MOVE, 44
DB MOCK_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_019RatTailRoledex:
DB 19
DB NORMAL
DB NONE
DB $40 ;height
DW $003D ;weight
DB 30 ;HP
DB 56 ;Bat
DB 35 ;Field
DB 72 ;Speed
DB 25 ;Throw
DB 0 ;Lineup Body
DB 6 ;Lineup Head
DB 3 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2F, $A0, $8C, $9A, $18, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB QUICK_SWING_MOVE, 7
DB SLIDER_MOVE, 14
DB FOCUS_MOVE, 23
DB SMASH_MOVE, 34
DB 0
;evolution
DB EV_TYPE_AGE, 20, 20
DB 0

_020CaitRoledex:
DB 20
DB NORMAL
DB NONE
DB $59 ;height
DW $00DC ;weight
DB 55 ;HP
DB 81 ;Bat
DB 60 ;Field
DB 97 ;Speed
DB 50 ;Throw
DB 4 ;Lineup Body
DB 6 ;Lineup Head
DB 1 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2F, $F0, $8C, $9A, $18, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB QUICK_SWING_MOVE, 7
DB SLIDER_MOVE, 14
DB FOCUS_MOVE, 27
DB SMASH_MOVE, 41
DB 0
;evolution
DB EV_TYPE_NONE

_021StoopRoledex:
DB 21
DB NORMAL
DB FLYING
DB $50 ;height
DW $006E ;weight
DB 40 ;HP
DB 60 ;Bat
DB 30 ;Field
DB 70 ;Speed
DB 31 ;Throw
DB 1 ;Lineup Body
DB 6 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $42, $A6, $00, $80, $1A, $11, $82 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB SWING_MOVE, 1
DB GLARE_MOVE, 9
DB BARRAGE_MOVE, 15
DB MOCK_MOVE, 22
DB RISER_MOVE, 29
DB MEDITATE_MOVE, 36
DB 0
;evolution
DB EV_TYPE_AGE, 22, 20
DB 0

_022CrowRoledex:
DB 22
DB NORMAL
DB FLYING
DB $50 ;height
DW $00AA ;weight
DB 65 ;HP
DB 90 ;Bat
DB 65 ;Field
DB 100 ;Speed
DB 61 ;Throw
DB 2 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $42, $A6, $10, $80, $1A, $11, $82 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB SWING_MOVE, 1
DB GLARE_MOVE, 9
DB BARRAGE_MOVE, 15
DB MOCK_MOVE, 22
DB RISER_MOVE, 29
DB MEDITATE_MOVE, 36
DB 0
;evolution
DB EV_TYPE_NONE

_023SnakeRoledex:
DB 23
DB POISON
DB NONE
DB $50 ;height
DW $005A ;weight
DB 35 ;HP
DB 60 ;Bat
DB 44 ;Field
DB 55 ;Speed
DB 40 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $10, $2E, $00, $C3, $9A, $08, $8A ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB PUFF_MOVE, 10
DB SLIDER_MOVE, 17
DB SLURVE_MOVE, 31
DB NASTY_CURVE_MOVE, 38
DB 0
;evolution
DB EV_TYPE_AGE, 24, 22
DB 0

_024CobraRoledex:
DB 24
DB POISON
DB NONE
DB $50 ;height
DW $00EA ;weight
DB 60 ;HP
DB 85 ;Bat
DB 69 ;Field
DB 80 ;Speed
DB 65 ;Throw
DB 7 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $10, $2E, $10, $C3, $9A, $08, $8A ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB PUFF_MOVE, 10
DB SLIDER_MOVE, 17
DB SLURVE_MOVE, 36
DB NASTY_CURVE_MOVE, 47
DB 0
;evolution
DB EV_TYPE_NONE

_025ChuRoledex:
DB 25
DB ELECTRIC
DB NONE
DB $50 ;height
DW $002E ;weight
DB 35 ;HP
DB 55 ;Bat
DB 30 ;Field
DB 90 ;Speed
DB 50 ;Throw
DB 0 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteElectric ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $0C, $6E, $0D, $8C, $1E, $18, $C2 ;HM/TM bit field
;learnset
DB SHOCKER_MOVE, 1
DB SWING_MOVE, 1
DB THUNDERBALL_MOVE, 9
DB QUICK_SWING_MOVE, 16
DB SWAT_MOVE, 26
DB MEDITATE_MOVE, 33
DB THUNDERSTICK_MOVE, 43
DB 0
;evolution
DB EV_TYPE_ITEM, 26, SPARK_GLOVE_ITEM
DB 0

_026RaiRoledex:
DB 26
DB ELECTRIC
DB NONE
DB $50 ;height
DW $00B8 ;weight
DB 60 ;HP
DB 90 ;Bat
DB 55 ;Field
DB 100 ;Speed
DB 90 ;Throw
DB 4 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteElectric ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_026RaiLeftyPitcherOpponentTiles)
DW _026RaiLeftyPitcherOpponentTiles
DB _026RAI_LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $0C, $6E, $1D, $8C, $1E, $18, $C2 ;HM/TM bit field
;learnset
DB SHOCKER_MOVE, 1
DB SWING_MOVE, 1
DB THUNDERBALL_MOVE, 1
DB 0
;evolution
DB EV_TYPE_NONE

_027ShrewRoledex:
DB 27
DB GROUND
DB NONE
DB $50 ;height
DW $0032 ;weight
DB 50 ;HP
DB 75 ;Bat
DB 85 ;Field
DB 40 ;Speed
DB 30 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $91, $2E, $05, $83, $9A, $18, $8A ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SWING_MOVE, 1
DB KICKUP_SAND_MOVE, 10
DB NASTY_CURVE_MOVE, 24
DB SWAT_MOVE, 31
DB BARRAGE_MOVE, 38
DB 0
;evolution
DB EV_TYPE_AGE, 28, 22
DB 0

_028SandyRoledex:
DB 28
DB GROUND
DB NONE
DB $50 ;height
DW $0078 ;weight
DB 75 ;HP
DB 100 ;Bat
DB 110 ;Field
DB 65 ;Speed
DB 55 ;Throw
DB 4 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $91, $2E, $15, $83, $9E, $18, $8A ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SWING_MOVE, 1
DB KICKUP_SAND_MOVE, 10
DB NASTY_CURVE_MOVE, 27
DB SWAT_MOVE, 36
DB BARRAGE_MOVE, 47
DB 0
;evolution
DB EV_TYPE_NONE

_029ChicaRoledex:
DB 29
DB POISON
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 55 ;HP
DB 47 ;Bat
DB 52 ;Field
DB 41 ;Speed
DB 40 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2E, $20, $8C, $1E, $08, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SCOWL_MOVE, 1
DB SWING_MOVE, 1
DB CHANGEUP_MOVE, 8
DB NASTY_CURVE_MOVE, 14
DB PUSH_BUNT_MOVE, 21
DB SLIDER_MOVE, 29
DB TWO_SEAM_MOVE, 36
DB COMEBACKER_MOVE, 43
DB 0
;evolution
DB EV_TYPE_AGE, 30, 16
DB 0

_030MuchachaRoledex:
DB 30
DB POISON
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 70 ;HP
DB 62 ;Bat
DB 67 ;Field
DB 56 ;Speed
DB 55 ;Throw
DB 4 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $3F, $E0, $8C, $1E, $08, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SCOWL_MOVE, 1
DB SWING_MOVE, 1
DB CHANGEUP_MOVE, 8
DB NASTY_CURVE_MOVE, 14
DB PUSH_BUNT_MOVE, 23
DB SLIDER_MOVE, 32
DB TWO_SEAM_MOVE, 41
DB COMEBACKER_MOVE, 50
DB 0
;evolution
DB EV_TYPE_ITEM, 31, MOON_GLOVE_ITEM
DB 0

_031ReinaRoledex:
DB 31
DB POISON
DB GROUND
DB $50 ;height
DW $0064 ;weight
DB 90 ;HP
DB 82 ;Bat
DB 87 ;Field
DB 76 ;Speed
DB 75 ;Throw
DB 7 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $7F, $FF, $8F, $1E, $28, $8A ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SCOWL_MOVE, 1
DB SWING_MOVE, 1
DB CHANGEUP_MOVE, 8
DB NASTY_CURVE_MOVE, 14
DB BOMB_MOVE, 23
DB 0
;evolution
DB EV_TYPE_NONE

_032ChicoRoledex:
DB 32
DB POISON
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 46 ;HP
DB 57 ;Bat
DB 40 ;Field
DB 50 ;Speed
DB 40 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $3E, $20, $8C, $1E, $08, $82 ;HM/TM bit field
;learnset
DB GLARE_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB CHANGEUP_MOVE, 8
DB NASTY_CURVE_MOVE, 14
DB FOCUS_MOVE, 21
DB FOUR_SEAM_MOVE, 29
DB CUTTER_MOVE, 36
DB COMEBACKER_MOVE, 43
DB 0
;evolution
DB EV_TYPE_AGE, 33, 16
DB 0

_033MuchachoRoledex:
DB 33
DB POISON
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 61 ;HP
DB 72 ;Bat
DB 57 ;Field
DB 65 ;Speed
DB 55 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $3F, $E0, $8C, $1E, $08, $82 ;HM/TM bit field
;learnset
DB GLARE_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB CHANGEUP_MOVE, 8
DB NASTY_CURVE_MOVE, 14
DB FOCUS_MOVE, 23
DB FOUR_SEAM_MOVE, 32
DB CUTTER_MOVE, 41
DB COMEBACKER_MOVE, 50
DB 0
;evolution
DB EV_TYPE_ITEM, 34, MOON_GLOVE_ITEM
DB 0

_034RayRoledex:
DB 34
DB POISON
DB GROUND
DB $50 ;height
DW $0064 ;weight
DB 81 ;HP
DB 92 ;Bat
DB 77 ;Field
DB 85 ;Speed
DB 75 ;Throw
DB 7 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $7F, $FF, $8F, $1E, $28, $8A ;HM/TM bit field
;learnset
DB GLARE_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB CHANGEUP_MOVE, 8
DB NASTY_CURVE_MOVE, 14
DB BASH_MOVE, 23
DB 0
;evolution
DB EV_TYPE_NONE

_035FairyRoledex:
DB 35
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 70 ;HP
DB 45 ;Bat
DB 48 ;Field
DB 35 ;Speed
DB 60 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $1C, $6F, $E7, $AC, $7F, $28, $E6 ;HM/TM bit field
;learnset
DB BUNT_MOVE, 1
DB TOSS_MOVE, 1
DB CHANT_MOVE, 13
DB TWO_SEAM_MOVE, 18
DB SUBMARINE_MOVE, 24
DB KNUCKLEBALL_MOVE, 31
DB FORKBALL_MOVE, 39
DB KINESIS_MOVE, 48
DB 0
;evolution
DB EV_TYPE_ITEM, 36, MOON_GLOVE_ITEM
DB 0

_036FableRoledex:
DB 36
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 95 ;HP
DB 70 ;Bat
DB 73 ;Field
DB 60 ;Speed
DB 85 ;Throw
DB 4 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $1C, $6F, $F7, $AC, $7F, $28, $E6 ;HM/TM bit field
;learnset
DB BUNT_MOVE, 1
DB CHANT_MOVE, 1
DB KNUCKLEBALL_MOVE, 1
DB SUBMARINE_MOVE, 1
DB TWO_SEAM_MOVE, 1
DB 0
;evolution
DB EV_TYPE_NONE

_037VulfpekRoledex:
DB 37
DB FIRE
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 38 ;HP
DB 41 ;Bat
DB 40 ;Field
DB 65 ;Speed
DB 65 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2E, $00, $80, $9E, $38, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SCORCH_MOVE, 1
DB QUICK_SWING_MOVE, 16
DB SCOWL_MOVE, 21
DB BAFFLINGBUNT_MOVE, 28
DB FIREBALL_MOVE, 35
DB HEATER_MOVE, 42
DB 0
;evolution
DB EV_TYPE_ITEM, 38, FIRE_GLOVE_ITEM
DB 0

_038FoxyRoledex:
DB 38
DB FIRE
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 73 ;HP
DB 76 ;Bat
DB 75 ;Field
DB 100 ;Speed
DB 100 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2E, $10, $80, $9E, $38, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB QUICK_SWING_MOVE, 1
DB SCORCH_MOVE, 1
DB SCOWL_MOVE, 1
DB 0
;evolution
DB EV_TYPE_NONE

_039PuffRoledex:
DB 39
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 115 ;HP
DB 45 ;Bat
DB 20 ;Field
DB 20 ;Speed
DB 25 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $1C, $6F, $E7, $AC, $7E, $28, $E6 ;HM/TM bit field
;learnset
DB CHANT_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB SPLITTER_MOVE, 9
DB EEPHUS_PITCH_MOVE, 14
DB FORKBALL_MOVE, 19
DB TWO_SEAM_MOVE, 24
DB REST_MOVE, 29
DB BOMB_MOVE, 34
DB KNUCKLECURVE_MOVE, 39
DB 0
;evolution
DB EV_TYPE_ITEM, 40, MOON_GLOVE_ITEM
DB 0

_040TuffRoledex:
DB 40
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 140 ;HP
DB 70 ;Bat
DB 45 ;Field
DB 45 ;Speed
DB 50 ;Throw
DB 3 ;Lineup Body
DB 4 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $1C, $6F, $F7, $AC, $7E, $28, $E6 ;HM/TM bit field
;learnset
DB CHANT_MOVE, 1
DB EEPHUS_PITCH_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB 0
;evolution
DB EV_TYPE_NONE

_041BatsRoledex:
DB 41
DB POISON
DB FLYING
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 45 ;Bat
DB 35 ;Field
DB 55 ;Speed
DB 40 ;Throw
DB 1 ;Lineup Body
DB 5 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $02, $A6, $00, $C0, $1A, $10, $82 ;HM/TM bit field
;learnset
DB SILKY_SWING_MOVE, 1
DB TOSS_MOVE, 1
DB SLIDER_MOVE, 10
DB BAFFLINGBUNT_MOVE, 21
DB BENDER_MOVE, 28
DB SHIVER_MOVE, 36
DB 0
;evolution
DB EV_TYPE_AGE, 42, 22
DB 0

_042GoldBatsRoledex:
DB 42
DB POISON
DB FLYING
DB $50 ;height
DW $0064 ;weight
DB 75 ;HP
DB 80 ;Bat
DB 70 ;Field
DB 90 ;Speed
DB 75 ;Throw
DB 3 ;Lineup Body
DB 5 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $02, $A6, $10, $C0, $1A, $10, $82 ;HM/TM bit field
;learnset
DB GLARE_MOVE, 1
DB SILKY_SWING_MOVE, 1
DB SLIDER_MOVE, 1
DB TOSS_MOVE, 1
DB BAFFLINGBUNT_MOVE, 21
DB BENDER_MOVE, 32
DB SHIVER_MOVE, 43
DB 0
;evolution
DB EV_TYPE_NONE

_043OddieRoledex:
DB 43
DB GRASS
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 45 ;HP
DB 50 ;Bat
DB 55 ;Field
DB 30 ;Speed
DB 75 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $26, $00, $E0, $1E, $00, $82 ;HM/TM bit field
;learnset
DB KUDZUBALL_MOVE, 1
DB SWING_MOVE, 1
DB NASTY_CURVE_MOVE, 15
DB GRASSBURNER_MOVE, 17
DB SLEEPER_MOVE, 19
DB GAS_MOVE, 24
DB PLANT_N_TURN_MOVE, 33
DB HARDWOOD_MOVE, 46
DB 0
;evolution
DB EV_TYPE_AGE, 44, 21
DB 0

_044GloomyRoledex:
DB 44
DB GRASS
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 65 ;Bat
DB 70 ;Field
DB 40 ;Speed
DB 85 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $26, $00, $E0, $1E, $00, $82 ;HM/TM bit field
;learnset
DB KUDZUBALL_MOVE, 1
DB SWING_MOVE, 1
DB NASTY_CURVE_MOVE, 15
DB GRASSBURNER_MOVE, 17
DB SLEEPER_MOVE, 19
DB GAS_MOVE, 28
DB PLANT_N_TURN_MOVE, 38
DB HARDWOOD_MOVE, 52
DB 0
;evolution
DB EV_TYPE_ITEM, 45, LEAF_GLOVE_ITEM
DB 0

_045VileRoledex:
DB 45
DB GRASS
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 75 ;HP
DB 80 ;Bat
DB 85 ;Field
DB 50 ;Speed
DB 100 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $2E, $10, $E0, $1E, $00, $82 ;HM/TM bit field
;learnset
DB KUDZUBALL_MOVE, 1
DB SWING_MOVE, 1
DB NASTY_CURVE_MOVE, 15
DB GRASSBURNER_MOVE, 17
DB SLEEPER_MOVE, 19
DB 0
;evolution
DB EV_TYPE_NONE

_046ParisRoledex:
DB 46
DB BUG
DB GRASS
DB $50 ;height
DW $0064 ;weight
DB 35 ;HP
DB 70 ;Bat
DB 55 ;Field
DB 25 ;Speed
DB 55 ;Throw
DB 1 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $2E, $00, $E0, $9E, $08, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SWING_MOVE, 1
DB GRASSBURNER_MOVE, 13
DB SILKY_SWING_MOVE, 20
DB PLANT_N_TURN_MOVE, 27
DB SLASH_MOVE, 34
DB PALMBALL_MOVE, 41
DB 0
;evolution
DB EV_TYPE_AGE, 47, 24
DB 0

_047PariahRoledex:
DB 47
DB BUG
DB GRASS
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 95 ;Bat
DB 80 ;Field
DB 30 ;Speed
DB 80 ;Throw
DB 8 ;Lineup Body
DB 4 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $2E, $10, $E0, $9E, $08, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB GRASSBURNER_MOVE, 13
DB SILKY_SWING_MOVE, 20
DB PLANT_N_TURN_MOVE, 30
DB SLASH_MOVE, 39
DB PALMBALL_MOVE, 48
DB 0
;evolution
DB EV_TYPE_NONE

_048NattyRoledex:
DB 48
DB BUG
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 55 ;Bat
DB 50 ;Field
DB 45 ;Speed
DB 40 ;Throw
DB 0 ;Lineup Body
DB 5 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $26, $00, $E0, $5E, $00, $A2 ;HM/TM bit field
;learnset
DB BUNT_MOVE, 1
DB TOSS_MOVE, 1
DB PUFF_MOVE, 24
DB SILKY_SWING_MOVE, 27
DB GRASSBURNER_MOVE, 30
DB SLEEPER_MOVE, 43
DB 0
;evolution
DB EV_TYPE_AGE, 49, 31
DB 0

_049MotherRoledex:
DB 49
DB BUG
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 70 ;HP
DB 65 ;Bat
DB 60 ;Field
DB 90 ;Speed
DB 90 ;Throw
DB 2 ;Lineup Body
DB 5 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $02, $66, $10, $E0, $7E, $10, $A2 ;HM/TM bit field
;learnset
DB BUNT_MOVE, 1
DB TOSS_MOVE, 1
DB PUFF_MOVE, 24
DB SILKY_SWING_MOVE, 27
DB GRASSBURNER_MOVE, 30
DB SLEEPER_MOVE, 43
DB 0
;evolution
DB EV_TYPE_NONE

_050DiggsRoledex:
DB 50
DB GROUND
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 10 ;HP
DB 55 ;Bat
DB 25 ;Field
DB 95 ;Speed
DB 45 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2E, $00, $83, $9A, $00, $8A ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SWING_MOVE, 1
DB GLARE_MOVE, 15
DB DIG_IN_MOVE, 19
DB KICKUP_SAND_MOVE, 24
DB SLASH_MOVE, 31
DB BLINK_MOVE, 35
DB SPELUNKER_MOVE, 40
DB BRAIN_MELTER_MOVE, 43
DB 0
;evolution
DB EV_TYPE_AGE, 51, 26
DB 0

_051DougRoledex:
DB 51
DB GROUND
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 35 ;HP
DB 80 ;Bat
DB 50 ;Field
DB 120 ;Speed
DB 70 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2E, $10, $83, $9A, $00, $8A ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SWING_MOVE, 1
DB GLARE_MOVE, 15
DB DIG_IN_MOVE, 19
DB KICKUP_SAND_MOVE, 24
DB SLASH_MOVE, 35
DB BLINK_MOVE, 38
DB SPELUNKER_MOVE, 47
DB BRAIN_MELTER_MOVE, 50
DB 0
;evolution
DB EV_TYPE_NONE

_052MeowRoledex:
DB 52
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 45 ;Bat
DB 35 ;Field
DB 90 ;Speed
DB 40 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2F, $88, $8C, $1A, $18, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SCOWL_MOVE, 1
DB SLIDER_MOVE, 12
DB MONEYBALL_MOVE, 17
DB SLURVE_MOVE, 24
DB FORKBALL_MOVE, 33
DB SLASH_MOVE, 44
DB 0
;evolution
DB EV_TYPE_AGE, 53, 28
DB 0

_053PurrRoledex:
DB 53
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 70 ;Bat
DB 60 ;Field
DB 115 ;Speed
DB 65 ;Throw
DB 1 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2F, $98, $8C, $1A, $18, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SCOWL_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB SLIDER_MOVE, 12
DB MONEYBALL_MOVE, 17
DB SLURVE_MOVE, 24
DB FORKBALL_MOVE, 37
DB SLASH_MOVE, 51
DB 0
;evolution
DB EV_TYPE_NONE

_054DuckRoledex:
DB 54
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 50 ;HP
DB 52 ;Bat
DB 48 ;Field
DB 55 ;Speed
DB 50 ;Throw
DB 3 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $6F, $EF, $80, $9A, $18, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB PUSH_BUNT_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB PREDICT_MOVE, 36
DB BARRAGE_MOVE, 43
DB HYDRO_CANNON_MOVE, 52
DB 0
;evolution
DB EV_TYPE_AGE, 55, 33
DB 0

_055GoldDuckRoledex:
DB 55
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 80 ;HP
DB 82 ;Bat
DB 78 ;Field
DB 85 ;Speed
DB 80 ;Throw
DB 2 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $6F, $FF, $80, $9A, $18, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB PUSH_BUNT_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB PREDICT_MOVE, 39
DB BARRAGE_MOVE, 48
DB HYDRO_CANNON_MOVE, 59
DB 0
;evolution
DB EV_TYPE_NONE

_056ManRoledex:
DB 56
DB FIGHTING
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 80 ;Bat
DB 35 ;Field
DB 70 ;Speed
DB 35 ;Throw
DB 2 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $0F, $8C, $9B, $18, $8A ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB GLARE_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB BRUSHBACK_MOVE, 15
DB SPLITTER_MOVE, 21
DB FOCUS_MOVE, 27
DB LEAN_IN_MOVE, 33
DB VULCAN_MOVE, 39
DB 0
;evolution
DB EV_TYPE_AGE, 57, 28
DB 0

_057PrimoRoledex:
DB 57
DB FIGHTING
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 105 ;Bat
DB 60 ;Field
DB 95 ;Speed
DB 60 ;Throw
DB 3 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $1F, $8C, $9B, $18, $8A ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB GLARE_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB BRUSHBACK_MOVE, 15
DB SPLITTER_MOVE, 21
DB FOCUS_MOVE, 27
DB LEAN_IN_MOVE, 37
DB VULCAN_MOVE, 46
DB 0
;evolution
DB EV_TYPE_NONE

_058LithiumRoledex:
DB 58
DB FIRE
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 55 ;HP
DB 70 ;Bat
DB 45 ;Field
DB 60 ;Speed
DB 50 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2E, $00, $90, $9E, $38, $82 ;HM/TM bit field
;learnset
DB SLIDER_MOVE, 1
DB SWING_MOVE, 1
DB SCORCH_MOVE, 18
DB CIRCLECHANGE_MOVE, 30
DB KINESIS_MOVE, 39
DB HEATER_MOVE, 50
DB 0
;evolution
DB EV_TYPE_ITEM, 59, FIRE_GLOVE_ITEM
DB 0

_059ArcaneRoledex:
DB 59
DB FIRE
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 90 ;HP
DB 110 ;Bat
DB 80 ;Field
DB 95 ;Speed
DB 80 ;Throw
DB 2 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2E, $10, $90, $BE, $38, $82 ;HM/TM bit field
;learnset
DB CIRCLECHANGE_MOVE, 1
DB SCORCH_MOVE, 1
DB SLIDER_MOVE, 1
DB SWING_MOVE, 1
DB 0
;evolution
DB EV_TYPE_NONE

_060PollyRoledex:
DB 60
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 50 ;Bat
DB 40 ;Field
DB 90 ;Speed
DB 40 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $2F, $E0, $80, $5A, $08, $A2 ;HM/TM bit field
;learnset
DB BUBBLEBALL_MOVE, 1
DB SWING_MOVE, 1
DB HYPNOSIS_MOVE, 16
DB SPITBALL_MOVE, 19
DB TWO_SEAM_MOVE, 25
DB BOMB_MOVE, 31
DB KINESIS_MOVE, 38
DB HYDRO_CANNON_MOVE, 45
DB 0
;evolution
DB EV_TYPE_AGE, 61, 25
DB 0

_061SwirlRoledex:
DB 61
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 65 ;Bat
DB 65 ;Field
DB 90 ;Speed
DB 50 ;Throw
DB 3 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $6F, $E7, $83, $5B, $08, $A2 ;HM/TM bit field
;learnset
DB BUBBLEBALL_MOVE, 1
DB SWING_MOVE, 1
DB HYPNOSIS_MOVE, 16
DB SPITBALL_MOVE, 19
DB TWO_SEAM_MOVE, 26
DB BOMB_MOVE, 33
DB KINESIS_MOVE, 41
DB HYDRO_CANNON_MOVE, 49
DB 0
;evolution
DB EV_TYPE_ITEM, 62, WATER_GLOVE_ITEM
DB 0

_062WrathRoledex:
DB 62
DB WATER
DB FIGHTING
DB $50 ;height
DW $0064 ;weight
DB 90 ;HP
DB 85 ;Bat
DB 95 ;Field
DB 70 ;Speed
DB 70 ;Throw
DB 7 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $6F, $F7, $83, $5B, $08, $A2 ;HM/TM bit field
;learnset
DB BOMB_MOVE, 1
DB BUBBLEBALL_MOVE, 1
DB HYPNOSIS_MOVE, 1
DB SPITBALL_MOVE, 1
DB SWING_MOVE, 1
DB TWO_SEAM_MOVE, 1
DB 0
;evolution
DB EV_TYPE_NONE

_063BruhRoledex:
DB 63
DB PSYCHIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 25 ;HP
DB 20 ;Bat
DB 15 ;Field
DB 90 ;Speed
DB 105 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $0C, $6E, $07, $80, $7F, $08, $E6 ;HM/TM bit field
;learnset
DB BLINK_MOVE, 1
DB SWING_MOVE, 1
DB 0
;evolution
DB EV_TYPE_AGE, 64, 16
DB 0

_064DabRoledex:
DB 64
DB PSYCHIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 35 ;Bat
DB 30 ;Field
DB 105 ;Speed
DB 120 ;Throw
DB 1 ;Lineup Body
DB 4 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $0C, $6E, $07, $80, $FF, $08, $E6 ;HM/TM bit field
;learnset
DB BLINK_MOVE, 1
DB PREDICT_MOVE, 1
DB SWING_MOVE, 1
DB KINESIS_MOVE, 16
DB SCREWBALL_MOVE, 20
DB BRAIN_MELTER_MOVE, 27
DB GYROBALL_MOVE, 31
DB PSYCH_OUT_MOVE, 38
DB MEDITATE_MOVE, 42
DB 0
;evolution
DB EV_TYPE_TRADE, 65, 0
DB 0

_065KazaaRoledex:
DB 65
DB PSYCHIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 55 ;HP
DB 50 ;Bat
DB 45 ;Field
DB 120 ;Speed
DB 135 ;Throw
DB 2 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $0C, $6E, $17, $80, $FF, $08, $E6 ;HM/TM bit field
;learnset
DB BLINK_MOVE, 1
DB PREDICT_MOVE, 1
DB SWING_MOVE, 1
DB KINESIS_MOVE, 16
DB SCREWBALL_MOVE, 20
DB BRAIN_MELTER_MOVE, 27
DB GYROBALL_MOVE, 31
DB PSYCH_OUT_MOVE, 38
DB MEDITATE_MOVE, 42
DB 0
;evolution
DB EV_TYPE_NONE

_066ChipRoledex:
DB 66
DB FIGHTING
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 70 ;HP
DB 80 ;Bat
DB 50 ;Field
DB 35 ;Speed
DB 35 ;Throw
DB 2 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $07, $83, $9B, $28, $8A ;HM/TM bit field
;learnset
DB LEAN_IN_MOVE, 1
DB TOSS_MOVE, 1
DB COMEBACKER_MOVE, 20
DB GLARE_MOVE, 25
DB BRUSHBACK_MOVE, 39
DB BEANBALL_MOVE, 46
DB 0
;evolution
DB EV_TYPE_AGE, 67, 28
DB 0

_067ChokeRoledex:
DB 67
DB FIGHTING
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 80 ;HP
DB 100 ;Bat
DB 70 ;Field
DB 45 ;Speed
DB 50 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $07, $83, $9B, $28, $8A ;HM/TM bit field
;learnset
DB GLARE_MOVE, 1
DB LEAN_IN_MOVE, 1
DB TOSS_MOVE, 1
DB COMEBACKER_MOVE, 20
DB BRUSHBACK_MOVE, 44
DB BEANBALL_MOVE, 52
DB 0
;evolution
DB EV_TYPE_TRADE, 68, 0
DB 0

_068ChampRoledex:
DB 68
DB FIGHTING
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 90 ;HP
DB 130 ;Bat
DB 80 ;Field
DB 55 ;Speed
DB 65 ;Throw
DB 4 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $17, $83, $9B, $28, $8A ;HM/TM bit field
;learnset
DB GLARE_MOVE, 1
DB TOSS_MOVE, 1
DB BEANBALL_MOVE, 52
DB BRUSHBACK_MOVE, 52
DB COMEBACKER_MOVE, 52
DB LEAN_IN_MOVE, 52
DB 0
;evolution
DB EV_TYPE_NONE

_069SproutRoledex:
DB 69
DB GRASS
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 50 ;HP
DB 75 ;Bat
DB 35 ;Field
DB 40 ;Speed
DB 70 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $26, $00, $E0, $1E, $00, $82 ;HM/TM bit field
;learnset
DB KUDZUBALL_MOVE, 1
DB SWING_MOVE, 1
DB BUNT_MOVE, 13
DB PUFF_MOVE, 15
DB SLEEPER_MOVE, 18
DB GRASSBURNER_MOVE, 21
DB NASTY_CURVE_MOVE, 26
DB PLANT_N_TURN_MOVE, 33
DB BOMB_MOVE, 42
DB 0
;evolution
DB EV_TYPE_AGE, 70, 21
DB 0

_070WeepyRoledex:
DB 70
DB GRASS
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 90 ;Bat
DB 50 ;Field
DB 55 ;Speed
DB 85 ;Throw
DB 1 ;Lineup Body
DB 5 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $26, $00, $E0, $1E, $00, $82 ;HM/TM bit field
;learnset
DB KUDZUBALL_MOVE, 1
DB SWING_MOVE, 1
DB BUNT_MOVE, 13
DB PUFF_MOVE, 15
DB SLEEPER_MOVE, 18
DB GRASSBURNER_MOVE, 23
DB NASTY_CURVE_MOVE, 29
DB PLANT_N_TURN_MOVE, 38
DB BOMB_MOVE, 49
DB 0
;evolution
DB EV_TYPE_ITEM, 71, LEAF_GLOVE_ITEM
DB 0

_071VicRoledex:
DB 71
DB GRASS
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 80 ;HP
DB 105 ;Bat
DB 65 ;Field
DB 70 ;Speed
DB 100 ;Throw
DB 2 ;Lineup Body
DB 4 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $2E, $10, $E0, $1E, $00, $82 ;HM/TM bit field
;learnset
DB KUDZUBALL_MOVE, 1
DB SWING_MOVE, 1
DB BUNT_MOVE, 13
DB PUFF_MOVE, 15
DB SLEEPER_MOVE, 18
DB 0
;evolution
DB EV_TYPE_NONE

_072FonzRoledex:
DB 72
DB WATER
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 40 ;Bat
DB 35 ;Field
DB 70 ;Speed
DB 100 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $A1, $27, $E0, $C0, $1E, $08, $82 ;HM/TM bit field
;learnset
DB NASTY_CURVE_MOVE, 1
DB SWING_MOVE, 1
DB FASTBALL_MOVE, 7
DB BUNT_MOVE, 13
DB GAS_MOVE, 18
DB SPITBALL_MOVE, 22
DB CIRCLECHANGE_MOVE, 27
DB PREDICT_MOVE, 33
DB SINKER_MOVE, 40
DB HYDRO_CANNON_MOVE, 48
DB 0
;evolution
DB EV_TYPE_AGE, 73, 30
DB 0

_073CruelRoledex:
DB 73
DB WATER
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 80 ;HP
DB 70 ;Bat
DB 65 ;Field
DB 100 ;Speed
DB 120 ;Throw
DB 2 ;Lineup Body
DB 4 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $A1, $27, $F0, $C0, $1E, $08, $82 ;HM/TM bit field
;learnset
DB NASTY_CURVE_MOVE, 1
DB SWING_MOVE, 1
DB FASTBALL_MOVE, 7
DB BUNT_MOVE, 13
DB GAS_MOVE, 18
DB SPITBALL_MOVE, 22
DB CIRCLECHANGE_MOVE, 27
DB PREDICT_MOVE, 35
DB SINKER_MOVE, 43
DB HYDRO_CANNON_MOVE, 50
DB 0
;evolution
DB EV_TYPE_NONE

_074DudeRoledex:
DB 74
DB ROCK
DB GROUND
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 80 ;Bat
DB 100 ;Field
DB 20 ;Speed
DB 30 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $2E, $07, $83, $9B, $A0, $9A ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB PUSH_BUNT_MOVE, 11
DB ROCK_MOVE, 16
DB SEPPUKUBALL_MOVE, 21
DB HARDEN_MOVE, 26
DB SPELUNKER_MOVE, 31
DB EXPLODE_MOVE, 36
DB 0
;evolution
DB EV_TYPE_AGE, 75, 25
DB 0

_075GravelRoledex:
DB 75
DB ROCK
DB GROUND
DB $50 ;height
DW $0064 ;weight
DB 55 ;HP
DB 95 ;Bat
DB 115 ;Field
DB 35 ;Speed
DB 45 ;Throw
DB 4 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $2E, $07, $83, $9B, $A0, $9A ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB PUSH_BUNT_MOVE, 11
DB ROCK_MOVE, 16
DB SEPPUKUBALL_MOVE, 21
DB HARDEN_MOVE, 29
DB SPELUNKER_MOVE, 36
DB EXPLODE_MOVE, 43
DB 0
;evolution
DB EV_TYPE_TRADE, 76, 0
DB 0

_076GolemRoledex:
DB 76
DB ROCK
DB GROUND
DB $50 ;height
DW $0064 ;weight
DB 80 ;HP
DB 110 ;Bat
DB 130 ;Field
DB 45 ;Speed
DB 55 ;Throw
DB 5 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $17, $83, $9B, $A0, $9A ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB PUSH_BUNT_MOVE, 11
DB ROCK_MOVE, 16
DB SEPPUKUBALL_MOVE, 21
DB HARDEN_MOVE, 29
DB SPELUNKER_MOVE, 36
DB EXPLODE_MOVE, 43
DB 0
;evolution
DB EV_TYPE_NONE

_077PintoRoledex:
DB 77
DB FIRE
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 50 ;HP
DB 85 ;Bat
DB 55 ;Field
DB 90 ;Speed
DB 65 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $3E, $00, $80, $1E, $38, $82 ;HM/TM bit field
;learnset
DB SCORCH_MOVE, 1
DB TOSS_MOVE, 1
DB DRAG_BUNT_MOVE, 30
DB STOMP_MOVE, 32
DB SCOWL_MOVE, 35
DB HEATER_MOVE, 39
DB SINKER_MOVE, 43
DB MEDITATE_MOVE, 48
DB 0
;evolution
DB EV_TYPE_AGE, 78, 40
DB 0

_078MustangRoledex:
DB 78
DB FIRE
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 100 ;Bat
DB 70 ;Field
DB 105 ;Speed
DB 80 ;Throw
DB 2 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $3E, $10, $80, $1E, $38, $82 ;HM/TM bit field
;learnset
DB SCORCH_MOVE, 1
DB TOSS_MOVE, 1
DB DRAG_BUNT_MOVE, 30
DB STOMP_MOVE, 32
DB SCOWL_MOVE, 35
DB HEATER_MOVE, 39
DB SINKER_MOVE, 47
DB MEDITATE_MOVE, 55
DB 0
;evolution
DB EV_TYPE_NONE

_079SlowpokeRoledex:
DB 79
DB WATER
DB PSYCHIC
DB $50 ;height
DW $0064 ;weight
DB 90 ;HP
DB 65 ;Bat
DB 65 ;Field
DB 15 ;Speed
DB 40 ;Throw
DB 3 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $38, $2F, $E8, $83, $FE, $38, $E6 ;HM/TM bit field
;learnset
DB BRAIN_MELTER_MOVE, 1
DB SWING_MOVE, 1
DB KNUCKLECURVE_MOVE, 18
DB PUSH_BUNT_MOVE, 22
DB SCOWL_MOVE, 27
DB SPITBALL_MOVE, 33
DB KINESIS_MOVE, 40
DB BLINK_MOVE, 48
DB 0
;evolution
DB EV_TYPE_AGE, 80, 37
DB 0

_080LaggardRoledex:
DB 80
DB WATER
DB PSYCHIC
DB $50 ;height
DW $0064 ;weight
DB 95 ;HP
DB 75 ;Bat
DB 110 ;Field
DB 30 ;Speed
DB 80 ;Throw
DB 5 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $3C, $6F, $FF, $83, $FE, $38, $E6 ;HM/TM bit field
;learnset
DB BRAIN_MELTER_MOVE, 1
DB SWING_MOVE, 1
DB KNUCKLECURVE_MOVE, 18
DB PUSH_BUNT_MOVE, 22
DB SCOWL_MOVE, 27
DB SPITBALL_MOVE, 33
DB WITHDRAW_MOVE, 37
DB KINESIS_MOVE, 44
DB BLINK_MOVE, 55
DB 0
;evolution
DB EV_TYPE_NONE

_081MagnetRoledex:
DB 81
DB ELECTRIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 25 ;HP
DB 35 ;Bat
DB 70 ;Field
DB 45 ;Speed
DB 95 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $08, $26, $00, $8C, $3E, $10, $C2 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB FASTBALL_MOVE, 21
DB SHOCKER_MOVE, 25
DB FOUR_SEAM_MOVE, 29
DB LIGHTNINBOLT_MOVE, 35
DB SWAT_MOVE, 41
DB SCREWBALL_MOVE, 47
DB 0
;evolution
DB EV_TYPE_AGE, 82, 30
DB 0

_082TonRoledex:
DB 82
DB ELECTRIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 50 ;HP
DB 60 ;Bat
DB 95 ;Field
DB 70 ;Speed
DB 120 ;Throw
DB 5 ;Lineup Body
DB 5 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $08, $26, $10, $8C, $3E, $10, $C2 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB FASTBALL_MOVE, 21
DB SHOCKER_MOVE, 25
DB FOUR_SEAM_MOVE, 29
DB LIGHTNINBOLT_MOVE, 38
DB SWAT_MOVE, 46
DB SCREWBALL_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_083DubiousRoledex:
DB 83
DB NORMAL
DB FLYING
DB $50 ;height
DW $0064 ;weight
DB 52 ;HP
DB 65 ;Bat
DB 55 ;Field
DB 60 ;Speed
DB 58 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $C3, $AE, $00, $80, $1E, $18, $82 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB SWING_MOVE, 1
DB SCOWL_MOVE, 20
DB CHANGEUP_MOVE, 24
DB RISER_MOVE, 30
DB RAGE_MOVE, 36
DB THREE_SEAM_MOVE, 40
DB KINESIS_MOVE, 44
DB 0
;evolution
DB EV_TYPE_NONE

_084DuceRoledex:
DB 84
DB NORMAL
DB FLYING
DB $50 ;height
DW $0064 ;weight
DB 35 ;HP
DB 85 ;Bat
DB 45 ;Field
DB 75 ;Speed
DB 35 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $40, $AE, $00, $80, $1E, $09, $86 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB SWING_MOVE, 1
DB SCOWL_MOVE, 20
DB CHANGEUP_MOVE, 24
DB RISER_MOVE, 30
DB RAGE_MOVE, 39
DB THREE_SEAM_MOVE, 45
DB KINESIS_MOVE, 51
DB 0
;evolution
DB EV_TYPE_AGE, 85, 31
DB 0

_085TreyRoledex:
DB 85
DB NORMAL
DB FLYING
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 110 ;Bat
DB 70 ;Field
DB 100 ;Speed
DB 60 ;Throw
DB 2 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $40, $AE, $10, $80, $1E, $09, $86 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB 0
;evolution
DB EV_TYPE_NONE

_086SealRoledex:
DB 86
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 45 ;Bat
DB 55 ;Field
DB 45 ;Speed
DB 70 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $30, $3F, $E8, $80, $1A, $08, $82 ;HM/TM bit field
;learnset
DB BUNT_MOVE, 1
DB TOSS_MOVE, 1
DB SCOWL_MOVE, 30
DB COLDSHOULDER_MOVE, 35
DB REST_MOVE, 40
DB FORKBALL_MOVE, 45
DB FROZEN_ROPE_MOVE, 50
DB 0
;evolution
DB EV_TYPE_AGE, 87, 34
DB 0

_087SealionRoledex:
DB 87
DB WATER
DB ICE
DB $50 ;height
DW $0064 ;weight
DB 90 ;HP
DB 70 ;Bat
DB 80 ;Field
DB 70 ;Speed
DB 95 ;Throw
DB 4 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $30, $3F, $F8, $80, $1A, $08, $82 ;HM/TM bit field
;learnset
DB TOSS_MOVE, 1
DB SCOWL_MOVE, 30
DB COLDSHOULDER_MOVE, 35
DB REST_MOVE, 44
DB FORKBALL_MOVE, 50
DB FROZEN_ROPE_MOVE, 56
DB 0
;evolution
DB EV_TYPE_NONE

_088GreaserRoledex:
DB 88
DB POISON
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 80 ;HP
DB 80 ;Bat
DB 50 ;Field
DB 25 ;Speed
DB 40 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $28, $00, $CC, $1A, $A0, $92 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB GAS_MOVE, 30
DB EEPHUS_PITCH_MOVE, 33
DB PUFF_MOVE, 37
DB HARDEN_MOVE, 42
DB SPLITTER_MOVE, 48
DB NASTY_CURVE_MOVE, 55
DB 0
;evolution
DB EV_TYPE_AGE, 89, 38
DB 0

_089YuckRoledex:
DB 89
DB POISON
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 105 ;HP
DB 105 ;Bat
DB 75 ;Field
DB 50 ;Speed
DB 65 ;Throw
DB 5 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $28, $10, $CC, $1A, $A0, $92 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB GAS_MOVE, 30
DB EEPHUS_PITCH_MOVE, 33
DB PUFF_MOVE, 37
DB HARDEN_MOVE, 45
DB SPLITTER_MOVE, 53
DB NASTY_CURVE_MOVE, 60
DB 0
;evolution
DB EV_TYPE_NONE

_090CupRoledex:
DB 90
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 30 ;HP
DB 65 ;Bat
DB 100 ;Field
DB 40 ;Speed
DB 45 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $27, $E0, $80, $3E, $90, $96 ;HM/TM bit field
;learnset
DB TOSS_MOVE, 1
DB WITHDRAW_MOVE, 1
DB FASTBALL_MOVE, 18
DB SHELL_MOVE, 23
DB COLDSHOULDER_MOVE, 30
DB GLARE_MOVE, 39
DB FROZEN_ROPE_MOVE, 50
DB 0
;evolution
DB EV_TYPE_ITEM, 91, WATER_GLOVE_ITEM
DB 0

_091DishRoledex:
DB 91
DB WATER
DB ICE
DB $50 ;height
DW $0064 ;weight
DB 50 ;HP
DB 95 ;Bat
DB 180 ;Field
DB 70 ;Speed
DB 85 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $27, $F0, $80, $3E, $90, $96 ;HM/TM bit field
;learnset
DB COLDSHOULDER_MOVE, 1
DB FASTBALL_MOVE, 1
DB SHELL_MOVE, 1
DB WITHDRAW_MOVE, 1
DB KNUCKLECURVE_MOVE, 50
DB 0
;evolution
DB EV_TYPE_NONE

_092GasRoledex:
DB 92
DB GHOST
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 30 ;HP
DB 35 ;Bat
DB 30 ;Field
DB 80 ;Speed
DB 100 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $20, $00, $CC, $5A, $82, $B2 ;HM/TM bit field
;learnset
DB BAFFLINGBUNT_MOVE, 1
DB LICK_MOVE, 1
DB POSSESS_MOVE, 1
DB HYPNOSIS_MOVE, 27
DB BRAIN_MELTER_MOVE, 35
DB 0
;evolution
DB EV_TYPE_AGE, 93, 25
DB 0

_093MortyRoledex:
DB 93
DB GHOST
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 45 ;HP
DB 50 ;Bat
DB 45 ;Field
DB 95 ;Speed
DB 115 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $20, $00, $CC, $5A, $82, $B2 ;HM/TM bit field
;learnset
DB BAFFLINGBUNT_MOVE, 1
DB LICK_MOVE, 1
DB POSSESS_MOVE, 1
DB HYPNOSIS_MOVE, 29
DB BRAIN_MELTER_MOVE, 38
DB 0
;evolution
DB EV_TYPE_TRADE, 94, 0
DB 0

_094MacobbRoledex:
DB 94
DB GHOST
DB POISON
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 65 ;Bat
DB 60 ;Field
DB 110 ;Speed
DB 130 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $17, $CC, $5B, $8A, $B2 ;HM/TM bit field
;learnset
DB BAFFLINGBUNT_MOVE, 1
DB LICK_MOVE, 1
DB POSSESS_MOVE, 1
DB HYPNOSIS_MOVE, 29
DB BRAIN_MELTER_MOVE, 38
DB 0
;evolution
DB EV_TYPE_NONE

_095OnyxRoledex:
DB 95
DB ROCK
DB GROUND
DB $50 ;height
DW $0064 ;weight
DB 35 ;HP
DB 45 ;Bat
DB 160 ;Field
DB 70 ;Speed
DB 30 ;Throw
DB 7 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $10, $2E, $00, $83, $9A, $88, $9A ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB BUNT_MOVE, 15
DB ROCK_SLIDER_MOVE, 19
DB RAGE_MOVE, 25
DB BOMB_MOVE, 33
DB HARDEN_MOVE, 43
DB 0
;evolution
DB EV_TYPE_NONE

_096ZeeRoledex:
DB 96
DB PSYCHIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 48 ;Bat
DB 45 ;Field
DB 42 ;Speed
DB 90 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $0C, $6E, $07, $80, $7F, $0A, $E6 ;HM/TM bit field
;learnset
DB HYPNOSIS_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB SINKER_MOVE, 12
DB KINESIS_MOVE, 17
DB SHUUTO_MOVE, 24
DB GAS_MOVE, 29
DB BLINK_MOVE, 32
DB MEDITATE_MOVE, 37
DB 0
;evolution
DB EV_TYPE_AGE, 97, 26
DB 0

_097MediumRoledex:
DB 97
DB PSYCHIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 85 ;HP
DB 73 ;Bat
DB 70 ;Field
DB 67 ;Speed
DB 115 ;Throw
DB 4 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $0C, $6E, $17, $80, $7F, $0A, $E6 ;HM/TM bit field
;learnset
DB HYPNOSIS_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB SINKER_MOVE, 12
DB KINESIS_MOVE, 17
DB SHUUTO_MOVE, 24
DB GAS_MOVE, 33
DB BLINK_MOVE, 37
DB MEDITATE_MOVE, 43
DB 0
;evolution
DB EV_TYPE_NONE

_098DickRoledex:
DB 98
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 30 ;HP
DB 105 ;Bat
DB 25 ;Field
DB 50 ;Speed
DB 90 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $B1, $2F, $E0, $80, $1A, $00, $82 ;HM/TM bit field
;learnset
DB BUBBLEBALL_MOVE, 1
DB SWING_MOVE, 1
DB VULCAN_MOVE, 20
DB CUTTER_MOVE, 25
DB STOMP_MOVE, 30
DB CRABHAMMER_MOVE, 35
DB HARDEN_MOVE, 40
DB 0
;evolution
DB EV_TYPE_AGE, 99, 28
DB 0

_099RexRoledex:
DB 99
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 55 ;HP
DB 130 ;Bat
DB 50 ;Field
DB 75 ;Speed
DB 115 ;Throw
DB 5 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $B1, $2F, $F0, $80, $1A, $00, $82 ;HM/TM bit field
;learnset
DB BUBBLEBALL_MOVE, 1
DB SWING_MOVE, 1
DB VULCAN_MOVE, 20
DB CUTTER_MOVE, 25
DB STOMP_MOVE, 34
DB CRABHAMMER_MOVE, 42
DB HARDEN_MOVE, 49
DB 0
;evolution
DB EV_TYPE_NONE

_100SpeedballRoledex:
DB 100
DB ELECTRIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 30 ;Bat
DB 50 ;Field
DB 100 ;Speed
DB 55 ;Throw
DB 4 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $08, $24, $00, $0C, $3E, $90, $D2 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB FASTBALL_MOVE, 17
DB SEPPUKUBALL_MOVE, 22
DB KINESIS_MOVE, 29
DB SWAT_MOVE, 36
DB EXPLODE_MOVE, 43
DB 0
;evolution
DB EV_TYPE_AGE, 101, 30
DB 0

_101TuckerRoledex:
DB 101
DB ELECTRIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 50 ;Bat
DB 70 ;Field
DB 140 ;Speed
DB 80 ;Throw
DB 5 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $08, $24, $10, $0C, $3E, $98, $D2 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB FASTBALL_MOVE, 17
DB SEPPUKUBALL_MOVE, 22
DB KINESIS_MOVE, 29
DB SWAT_MOVE, 40
DB EXPLODE_MOVE, 50
DB 0
;evolution
DB EV_TYPE_NONE

_102EdRoledex:
DB 102
DB GRASS
DB PSYCHIC
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 40 ;Bat
DB 80 ;Field
DB 40 ;Speed
DB 60 ;Throw
DB 4 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $26, $00, $80, $7E, $C0, $B2 ;HM/TM bit field
;learnset
DB BARRAGE_MOVE, 1
DB HYPNOSIS_MOVE, 1
DB PREDICT_MOVE, 25
DB KUDZUBALL_MOVE, 28
DB GRASSBURNER_MOVE, 32
DB PUFF_MOVE, 37
DB HARDWOOD_MOVE, 42
DB SLEEPER_MOVE, 48
DB 0
;evolution
DB EV_TYPE_ITEM, 103, LEAF_GLOVE_ITEM
DB 0

_103EddRoledex:
DB 103
DB GRASS
DB PSYCHIC
DB $50 ;height
DW $0064 ;weight
DB 95 ;HP
DB 95 ;Bat
DB 85 ;Field
DB 55 ;Speed
DB 125 ;Throw
DB 7 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $10, $26, $10, $E0, $7E, $C0, $B2 ;HM/TM bit field
;learnset
DB BARRAGE_MOVE, 1
DB HYPNOSIS_MOVE, 1
DB STOMP_MOVE, 28
DB 0
;evolution
DB EV_TYPE_NONE

_104BonesRoledex:
DB 104
DB GROUND
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 50 ;HP
DB 50 ;Bat
DB 95 ;Field
DB 35 ;Speed
DB 40 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6F, $E7, $83, $9A, $28, $82 ;HM/TM bit field
;learnset
DB CHOP_DOWN_MOVE, 1
DB SCOWL_MOVE, 1
DB TOSS_MOVE, 1
DB GLARE_MOVE, 25
DB FOCUS_MOVE, 31
DB SLASH_MOVE, 38
DB BOUNCER_MOVE, 43
DB RAGE_MOVE, 46
DB 0
;evolution
DB EV_TYPE_AGE, 105, 28
DB 0

_105MarrowRoledex:
DB 105
DB GROUND
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 80 ;Bat
DB 110 ;Field
DB 45 ;Speed
DB 50 ;Throw
DB 2 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6F, $F7, $83, $9A, $28, $82 ;HM/TM bit field
;learnset
DB CHOP_DOWN_MOVE, 1
DB SCOWL_MOVE, 1
DB TOSS_MOVE, 1
DB GLARE_MOVE, 25
DB FOCUS_MOVE, 33
DB SLASH_MOVE, 41
DB BOUNCER_MOVE, 48
DB RAGE_MOVE, 55
DB 0
;evolution
DB EV_TYPE_NONE

_106BruceRoledex:
DB 106
DB FIGHTING
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 50 ;HP
DB 120 ;Bat
DB 53 ;Field
DB 87 ;Speed
DB 35 ;Throw
DB 2 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $07, $80, $1B, $18, $82 ;HM/TM bit field
;learnset
DB MEDITATE_MOVE, 1
DB TAUNT_MOVE, 1
DB TOSS_MOVE, 1
DB LEAN_IN_MOVE, 33
DB BRUSHBACK_MOVE, 38
DB FOCUS_MOVE, 43
DB BEANBALL_MOVE, 48
DB SMASH_MOVE, 53
DB 0
;evolution
DB EV_TYPE_NONE

_107JackieRoledex:
DB 107
DB FIGHTING
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 50 ;HP
DB 105 ;Bat
DB 79 ;Field
DB 76 ;Speed
DB 35 ;Throw
DB 8 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $07, $80, $1B, $18, $82 ;HM/TM bit field
;learnset
DB FOUR_SEAM_MOVE, 1
DB MEDITATE_MOVE, 1
DB FIREBALL_MOVE, 33
DB FROZEN_ROPE_MOVE, 38
DB THUNDERBALL_MOVE, 43
DB CURVEBALL_MOVE, 48
DB COMEBACKER_MOVE, 53
DB 0
;evolution
DB EV_TYPE_NONE

_108TongueRoledex:
DB 108
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 90 ;HP
DB 55 ;Bat
DB 75 ;Field
DB 30 ;Speed
DB 60 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $B5, $6F, $F7, $8F, $1A, $28, $80 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB SWING_MOVE, 1
DB STOMP_MOVE, 7
DB CHANGEUP_MOVE, 15
DB CURVEBALL_MOVE, 23
DB BOMB_MOVE, 31
DB SLIDER_MOVE, 39
DB 0
;evolution
DB EV_TYPE_NONE

_109AshRoledex:
DB 109
DB POISON
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 65 ;Bat
DB 95 ;Field
DB 35 ;Speed
DB 60 ;Throw
DB 3 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $20, $00, $8C, $1A, $A0, $92 ;HM/TM bit field
;learnset
DB PUFF_MOVE, 1
DB TOSS_MOVE, 1
DB NASTY_CURVE_MOVE, 32
DB PUSH_BUNT_MOVE, 37
DB SEPPUKUBALL_MOVE, 40
DB SHIVER_MOVE, 45
DB EXPLODE_MOVE, 48
DB 0
;evolution
DB EV_TYPE_AGE, 110, 35
DB 0

_110SmokeyRoledex:
DB 110
DB POISON
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 90 ;Bat
DB 120 ;Field
DB 60 ;Speed
DB 85 ;Throw
DB 4 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $20, $10, $8C, $1A, $A0, $92 ;HM/TM bit field
;learnset
DB PUFF_MOVE, 1
DB TOSS_MOVE, 1
DB NASTY_CURVE_MOVE, 32
DB PUSH_BUNT_MOVE, 39
DB SEPPUKUBALL_MOVE, 43
DB SHIVER_MOVE, 49
DB EXPLODE_MOVE, 53
DB 0
;evolution
DB EV_TYPE_NONE

_111RhinoRoledex:
DB 111
DB GROUND
DB ROCK
DB $50 ;height
DW $0064 ;weight
DB 80 ;HP
DB 85 ;Bat
DB 95 ;Field
DB 25 ;Speed
DB 30 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $10, $3E, $00, $8F, $9A, $28, $8A ;HM/TM bit field
;learnset
DB KNUCKLECURVE_MOVE, 1
DB SWING_MOVE, 1
DB STOMP_MOVE, 30
DB TWO_SEAM_MOVE, 35
DB FOSH_MOVE, 40
DB SLURVE_MOVE, 45
DB GLARE_MOVE, 50
DB SPLITTER_MOVE, 55
DB 0
;evolution
DB EV_TYPE_AGE, 112, 42
DB 0

_112DonRoledex:
DB 112
DB GROUND
DB ROCK
DB $50 ;height
DW $0064 ;weight
DB 105 ;HP
DB 130 ;Bat
DB 120 ;Field
DB 40 ;Speed
DB 45 ;Throw
DB 4 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $7F, $FF, $8F, $9A, $28, $8A ;HM/TM bit field
;learnset
DB KNUCKLECURVE_MOVE, 1
DB SWING_MOVE, 1
DB STOMP_MOVE, 30
DB TWO_SEAM_MOVE, 35
DB FOSH_MOVE, 40
DB SLURVE_MOVE, 48
DB GLARE_MOVE, 55
DB SPLITTER_MOVE, 64
DB 0
;evolution
DB EV_TYPE_NONE

_113ChanceRoledex:
DB 113
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 250 ;HP
DB 5 ;Bat
DB 5 ;Field
DB 50 ;Speed
DB 105 ;Throw
DB 5 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $1C, $6F, $F7, $AC, $7F, $6C, $E6 ;HM/TM bit field
;learnset
DB BOMB_MOVE, 1
DB TWO_SEAM_MOVE, 1
DB CHANT_MOVE, 24
DB SCOWL_MOVE, 30
DB SINKER_MOVE, 38
DB CURVEBALL_MOVE, 44
DB MEDITATE_MOVE, 48
DB SLURVE_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_114FrizzRoledex:
DB 114
DB GRASS
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 55 ;Bat
DB 115 ;Field
DB 60 ;Speed
DB 100 ;Throw
DB 1 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $2E, $10, $E0, $1A, $08, $82 ;HM/TM bit field
;learnset
DB BUNT_MOVE, 1
DB GYROBALL_MOVE, 1
DB KUDZUBALL_MOVE, 29
DB GAS_MOVE, 32
DB GRASSBURNER_MOVE, 36
DB SLEEPER_MOVE, 39
DB BOMB_MOVE, 45
DB SCREWBALL_MOVE, 49
DB 0
;evolution
DB EV_TYPE_NONE

_115GengisRoledex:
DB 115
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 105 ;HP
DB 95 ;Bat
DB 80 ;Field
DB 90 ;Speed
DB 40 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $6F, $F7, $8F, $1A, $28, $8A ;HM/TM bit field
;learnset
DB PUSH_BUNT_MOVE, 1
DB RAGE_MOVE, 1
DB SLIDER_MOVE, 26
DB TWO_SEAM_MOVE, 31
DB BOMB_MOVE, 36
DB GLARE_MOVE, 41
DB SCREWBALL_MOVE, 46
DB 0
;evolution
DB EV_TYPE_NONE

_116BrainRoledex:
DB 116
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 30 ;HP
DB 40 ;Bat
DB 70 ;Field
DB 60 ;Speed
DB 70 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $27, $E0, $80, $1A, $18, $82 ;HM/TM bit field
;learnset
DB BUBBLEBALL_MOVE, 1
DB SWING_MOVE, 1
DB SHUUTO_MOVE, 19
DB GLARE_MOVE, 24
DB SPITBALL_MOVE, 30
DB MEDITATE_MOVE, 37
DB HYDRO_CANNON_MOVE, 45
DB 0
;evolution
DB EV_TYPE_AGE, 117, 32
DB 0

_117EinsteinRoledex:
DB 117
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 55 ;HP
DB 65 ;Bat
DB 95 ;Field
DB 85 ;Speed
DB 95 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $27, $F0, $80, $1A, $18, $82 ;HM/TM bit field
;learnset
DB BUBBLEBALL_MOVE, 1
DB SWING_MOVE, 1
DB SHUUTO_MOVE, 19
DB GLARE_MOVE, 24
DB SPITBALL_MOVE, 30
DB MEDITATE_MOVE, 41
DB HYDRO_CANNON_MOVE, 52
DB 0
;evolution
DB EV_TYPE_NONE

_118GoldieRoledex:
DB 118
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 45 ;HP
DB 67 ;Bat
DB 60 ;Field
DB 63 ;Speed
DB 50 ;Throw
DB 8 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $37, $E0, $80, $1A, $18, $82 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB SWING_MOVE, 1
DB TWO_SEAM_MOVE, 1
DB FASTBALL_MOVE, 19
DB KNUCKLECURVE_MOVE, 24
DB SLURVE_MOVE, 30
DB SHELL_MOVE, 37
DB BOMB_MOVE, 45
DB MEDITATE_MOVE, 54
DB 0
;evolution
DB EV_TYPE_AGE, 119, 33
DB 0

_119SeekerRoledex:
DB 119
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 80 ;HP
DB 92 ;Bat
DB 65 ;Field
DB 68 ;Speed
DB 80 ;Throw
DB 8 ;Lineup Body
DB 5 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $37, $F0, $80, $1A, $18, $82 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB SWING_MOVE, 1
DB TWO_SEAM_MOVE, 1
DB FASTBALL_MOVE, 19
DB KNUCKLECURVE_MOVE, 24
DB SLURVE_MOVE, 30
DB SHELL_MOVE, 39
DB BOMB_MOVE, 48
DB MEDITATE_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_120StarchildRoledex:
DB 120
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 30 ;HP
DB 45 ;Bat
DB 55 ;Field
DB 85 ;Speed
DB 70 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $28, $27, $E0, $8C, $7E, $18, $E6 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB SPITBALL_MOVE, 17
DB HARDEN_MOVE, 22
DB CUTTER_MOVE, 27
DB SWAT_MOVE, 32
DB SINKER_MOVE, 37
DB KINESIS_MOVE, 42
DB HYDRO_CANNON_MOVE, 47
DB 0
;evolution
DB EV_TYPE_ITEM, 121, WATER_GLOVE_ITEM
DB 0

_121StarmanRoledex:
DB 121
DB WATER
DB PSYCHIC
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 75 ;Bat
DB 85 ;Field
DB 115 ;Speed
DB 100 ;Throw
DB 3 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $28, $27, $F0, $8C, $7E, $18, $E6 ;HM/TM bit field
;learnset
DB HARDEN_MOVE, 1
DB SPITBALL_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB 0
;evolution
DB EV_TYPE_NONE

_122MimeRoledex:
DB 122
DB PSYCHIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 40 ;HP
DB 45 ;Bat
DB 65 ;Field
DB 90 ;Speed
DB 100 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $0C, $6E, $17, $AC, $7F, $08, $E2 ;HM/TM bit field
;learnset
DB BRAIN_MELTER_MOVE, 1
DB SWING_MOVE, 1
DB PSYCH_OUT_MOVE, 15
DB KINESIS_MOVE, 23
DB TWO_SEAM_MOVE, 31
DB MEDITATE_MOVE, 39
DB SUBMARINE_MOVE, 47
DB 0
;evolution
DB EV_TYPE_NONE

_123ScissorsRoledex:
DB 123
DB BUG
DB FLYING
DB $50 ;height
DW $0064 ;weight
DB 70 ;HP
DB 110 ;Bat
DB 80 ;Field
DB 105 ;Speed
DB 55 ;Throw
DB 7 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $26, $10, $80, $1A, $18, $82 ;HM/TM bit field
;learnset
DB SWAT_MOVE, 1
DB TOSS_MOVE, 1
DB GLARE_MOVE, 17
DB FOCUS_MOVE, 20
DB TWO_SEAM_MOVE, 24
DB SLASH_MOVE, 29
DB SCOWL_MOVE, 35
DB MEDITATE_MOVE, 42
DB 0
;evolution
DB EV_TYPE_NONE

_124JinxRoledex:
DB 124
DB ICE
DB PSYCHIC
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 50 ;Bat
DB 35 ;Field
DB 95 ;Speed
DB 95 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $04, $6F, $F7, $80, $7F, $08, $A2 ;HM/TM bit field
;learnset
DB CHANGEUP_MOVE, 1
DB SWING_MOVE, 1
DB LICK_MOVE, 18
DB TWO_SEAM_MOVE, 23
DB COLDSHOULDER_MOVE, 31
DB BOMB_MOVE, 39
DB SMASH_MOVE, 47
DB FROZEN_ROPE_MOVE, 58
DB 0
;evolution
DB EV_TYPE_NONE

_125BuzzRoledex:
DB 125
DB ELECTRIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 83 ;Bat
DB 57 ;Field
DB 105 ;Speed
DB 85 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $1C, $6E, $17, $8C, $7F, $18, $E2 ;HM/TM bit field
;learnset
DB GLARE_MOVE, 1
DB SWAT_MOVE, 1
DB TOSS_MOVE, 1
DB SHOCKER_MOVE, 34
DB SLASH_MOVE, 37
DB ELEC_SLIDER_MOVE, 42
DB KINESIS_MOVE, 49
DB THUNDERSTICK_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_126MagmaRoledex:
DB 126
DB FIRE
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 95 ;Bat
DB 57 ;Field
DB 93 ;Speed
DB 85 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $14, $6E, $17, $80, $7B, $28, $A2 ;HM/TM bit field
;learnset
DB GLARE_MOVE, 1
DB SCORCH_MOVE, 1
DB TOSS_MOVE, 1
DB BAFFLINGBUNT_MOVE, 39
DB EEPHUS_PITCH_MOVE, 48
DB FIREBALL_MOVE, 48
DB PUFF_MOVE, 52
DB HEATER_MOVE, 55
DB 0
;evolution
DB EV_TYPE_NONE

_127PinchRoledex:
DB 127
DB BUG
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 125 ;Bat
DB 100 ;Field
DB 85 ;Speed
DB 55 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $81, $2E, $15, $80, $1A, $00, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB VULCAN_MOVE, 1
DB TAUNT_MOVE, 25
DB CUTTER_MOVE, 30
DB FOCUS_MOVE, 36
DB HARDEN_MOVE, 43
DB SLASH_MOVE, 49
DB SHUUTO_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_128BullRoledex:
DB 128
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 75 ;HP
DB 100 ;Bat
DB 95 ;Field
DB 110 ;Speed
DB 70 ;Throw
DB 3 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $10, $3E, $70, $8F, $1A, $28, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB STOMP_MOVE, 21
DB TWO_SEAM_MOVE, 28
DB GLARE_MOVE, 35
DB RAGE_MOVE, 44
DB SINKER_MOVE, 51
DB 0
;evolution
DB EV_TYPE_NONE

_129FishRoledex:
DB 129
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 20 ;HP
DB 10 ;Bat
DB 55 ;Field
DB 80 ;Speed
DB 20 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $00, $00, $00, $00, $00, $00 ;HM/TM bit field
;learnset
DB WIFF_MOVE, 1
DB TOSS_MOVE, 15
DB 0
;evolution
DB EV_TYPE_AGE, 130, 20
DB 0

_130GarRoledex:
DB 130
DB WATER
DB FLYING
DB $50 ;height
DW $0064 ;weight
DB 95 ;HP
DB 125 ;Bat
DB 79 ;Field
DB 81 ;Speed
DB 100 ;Throw
DB 7 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $30, $2F, $F0, $9C, $1E, $28, $82 ;HM/TM bit field
;learnset
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB SLIDER_MOVE, 20
DB DRAGON_BUNT_MOVE, 25
DB GLARE_MOVE, 32
DB HYDRO_CANNON_MOVE, 41
DB SMASH_MOVE, 52
DB 0
;evolution
DB EV_TYPE_NONE

_131BusRoledex:
DB 131
DB WATER
DB ICE
DB $50 ;height
DW $0064 ;weight
DB 130 ;HP
DB 85 ;Bat
DB 80 ;Field
DB 60 ;Speed
DB 95 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $30, $3F, $F0, $BC, $5E, $08, $A2 ;HM/TM bit field
;learnset
DB SHELL_MOVE, 1
DB TOSS_MOVE, 1
DB CHANT_MOVE, 16
DB SHIVER_MOVE, 20
DB SINKER_MOVE, 25
DB DEAD_PULL_MOVE, 31
DB FROZEN_ROPE_MOVE, 38
DB HYDRO_CANNON_MOVE, 46
DB 0
;evolution
DB EV_TYPE_NONE

_132YeahYeahRoledex:
DB 132
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 48 ;HP
DB 48 ;Bat
DB 48 ;Field
DB 48 ;Speed
DB 48 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $00, $00, $00, $00, $00, $00 ;HM/TM bit field
;learnset
DB STUDY_MOVE, 1
DB TOSS_MOVE, 1
DB 0
;evolution
DB EV_TYPE_NONE

_133EvieRoledex:
DB 133
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 55 ;HP
DB 55 ;Bat
DB 50 ;Field
DB 55 ;Speed
DB 65 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2E, $40, $80, $1E, $18, $82 ;HM/TM bit field
;learnset
DB KICKUP_SAND_MOVE, 1
DB TOSS_MOVE, 1
DB QUICK_SWING_MOVE, 27
DB SCOWL_MOVE, 31
DB SLIDER_MOVE, 37
DB SEPPUKUBALL_MOVE, 45
DB 0
;evolution
DB EV_TYPE_ITEM, 134, WATER_GLOVE_ITEM
DB EV_TYPE_ITEM, 135, SPARK_GLOVE_ITEM
DB EV_TYPE_ITEM, 136, FIRE_GLOVE_ITEM
DB 0

_134VaporRoledex:
DB 134
DB WATER
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 130 ;HP
DB 65 ;Bat
DB 60 ;Field
DB 65 ;Speed
DB 110 ;Throw
DB 2 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $2F, $B0, $80, $1E, $18, $82 ;HM/TM bit field
;learnset
DB KICKUP_SAND_MOVE, 1
DB TOSS_MOVE, 1
DB QUICK_SWING_MOVE, 27
DB SPITBALL_MOVE, 31
DB SCOWL_MOVE, 37
DB SLIDER_MOVE, 40
DB PUFF_MOVE, 42
DB COLDSHOULDER_MOVE, 44
DB SHIVER_MOVE, 48
DB HYDRO_CANNON_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_135JoltRoledex:
DB 135
DB ELECTRIC
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 65 ;Bat
DB 60 ;Field
DB 130 ;Speed
DB 110 ;Throw
DB 2 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $08, $2E, $10, $8C, $1E, $18, $C2 ;HM/TM bit field
;learnset
DB KICKUP_SAND_MOVE, 1
DB TOSS_MOVE, 1
DB QUICK_SWING_MOVE, 27
DB THUNDERSTICK_MOVE, 31
DB SCOWL_MOVE, 37
DB ELEC_SLIDER_MOVE, 40
DB SLIDER_MOVE, 40
DB BRUSHBACK_MOVE, 42
DB BRAIN_MELTER_MOVE, 44
DB PINPOINT_MOVE, 48
DB THUNDERBALL_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_136FalreRoledex:
DB 136
DB FIRE
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 130 ;Bat
DB 60 ;Field
DB 65 ;Speed
DB 110 ;Throw
DB 3 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $00, $2E, $50, $80, $1E, $38, $82 ;HM/TM bit field
;learnset
DB KICKUP_SAND_MOVE, 1
DB TOSS_MOVE, 1
DB QUICK_SWING_MOVE, 27
DB FIREBALL_MOVE, 31
DB SCOWL_MOVE, 37
DB SLIDER_MOVE, 40
DB GLARE_MOVE, 42
DB HEATER_MOVE, 44
DB RAGE_MOVE, 48
DB HIGH_HEAT_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_137PolygonRoledex:
DB 137
DB NORMAL
DB NONE
DB $50 ;height
DW $0064 ;weight
DB 65 ;HP
DB 60 ;Bat
DB 70 ;Field
DB 40 ;Speed
DB 75 ;Throw
DB 1 ;Lineup Body
DB 5 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $08, $26, $70, $8C, $7E, $18, $E6 ;HM/TM bit field
;learnset
DB GYROBALL_MOVE, 1
DB SWING_MOVE, 1
DB TOSS_MOVE, 1
DB PREDICT_MOVE, 23
DB VULCAN_MOVE, 28
DB KINESIS_MOVE, 35
DB THREE_SEAM_MOVE, 42
DB 0
;evolution
DB EV_TYPE_NONE

_138SpiralRoledex:
DB 138
DB ROCK
DB WATER
DB $50 ;height
DW $0064 ;weight
DB 35 ;HP
DB 40 ;Bat
DB 100 ;Field
DB 35 ;Speed
DB 90 ;Throw
DB 0 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $2F, $E0, $80, $1E, $00, $82 ;HM/TM bit field
;learnset
DB SPITBALL_MOVE, 1
DB WITHDRAW_MOVE, 1
DB SHUUTO_MOVE, 34
DB GLARE_MOVE, 39
DB FOSH_MOVE, 44
DB HYDRO_CANNON_MOVE, 49
DB 0
;evolution
DB EV_TYPE_AGE, 139, 40
DB 0

_139SpireRoledex:
DB 139
DB ROCK
DB WATER
DB $50 ;height
DW $0064 ;weight
DB 70 ;HP
DB 60 ;Bat
DB 125 ;Field
DB 55 ;Speed
DB 115 ;Throw
DB 3 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $3F, $F5, $80, $1E, $08, $82 ;HM/TM bit field
;learnset
DB SPITBALL_MOVE, 1
DB WITHDRAW_MOVE, 1
DB SHUUTO_MOVE, 34
DB GLARE_MOVE, 39
DB FOSH_MOVE, 46
DB HYDRO_CANNON_MOVE, 53
DB 0
;evolution
DB EV_TYPE_NONE

_140HorshoeRoledex:
DB 140
DB ROCK
DB WATER
DB $50 ;height
DW $0064 ;weight
DB 30 ;HP
DB 80 ;Bat
DB 90 ;Field
DB 55 ;Speed
DB 45 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $2F, $E0, $80, $1E, $00, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB HARDEN_MOVE, 1
DB KUDZUBALL_MOVE, 34
DB SLASH_MOVE, 39
DB SCOWL_MOVE, 44
DB HYDRO_CANNON_MOVE, 49
DB 0
;evolution
DB EV_TYPE_AGE, 141, 40
DB 0

_141TopperRoledex:
DB 141
DB ROCK
DB WATER
DB $50 ;height
DW $0064 ;weight
DB 60 ;HP
DB 115 ;Bat
DB 105 ;Field
DB 80 ;Speed
DB 70 ;Throw
DB 2 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $23, $6F, $B5, $80, $1E, $08, $82 ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB HARDEN_MOVE, 1
DB KUDZUBALL_MOVE, 34
DB SLASH_MOVE, 39
DB SCOWL_MOVE, 46
DB HYDRO_CANNON_MOVE, 53
DB 0
;evolution
DB EV_TYPE_NONE

_142ArrowheadRoledex:
DB 142
DB ROCK
DB FLYING
DB $60 ;height
DW $0064 ;weight
DB 80 ;HP
DB 105 ;Bat
DB 65 ;Field
DB 130 ;Speed
DB 60 ;Throw
DB 7 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $42, $A6, $50, $90, $1E, $31, $82 ;HM/TM bit field
;learnset
DB BRAIN_MELTER_MOVE, 1
DB SKY_SMASH_MOVE, 1
DB FOUR_SEAM_MOVE, 33
DB SLIDER_MOVE, 38
DB SEPPUKUBALL_MOVE, 45
DB SMASH_MOVE, 54
DB 0
;evolution
DB EV_TYPE_NONE

_143BearRoledex:
DB 143
DB NORMAL
DB NONE
DB $63 ;height
DW $01A5 ;weight
DB 160 ;HP
DB 110 ;Bat
DB 65 ;Field
DB 30 ;Speed
DB 65 ;Throw
DB 5 ;Lineup Body
DB 6 ;Lineup Head
DB 7 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_143BearRightyBatterUserTiles)
DW _143BearRightyBatterUserTiles
DB _143BEAR_RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_143BearRightyBatterOpponentTiles)
DW _143BearRightyBatterOpponentTiles
DB _143BEAR_RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $34, $6F, $FF, $AF, $5F, $A8, $AA ;HM/TM bit field
;learnset
DB FASTBALL_MOVE, 1
DB KINESIS_MOVE, 1
DB REST_MOVE, 1
DB STOMP_MOVE, 35
DB HARDEN_MOVE, 41
DB TWO_SEAM_MOVE, 48
DB SMASH_MOVE, 56
DB 0
;evolution
DB EV_TYPE_NONE

_144ArtRoledex:
DB 144
DB ICE
DB FLYING
DB $63 ;height
DW $00DD ;weight
DB 90 ;HP
DB 85 ;Bat
DB 100 ;Field
DB 85 ;Speed
DB 125 ;Throw
DB 7 ;Lineup Body
DB 5 ;Lineup Head
DB 7 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $42, $A7, $B0, $80, $1E, $11, $82 ;HM/TM bit field
;learnset
DB FROZEN_ROPE_MOVE, 1
DB RISER_MOVE, 1
DB COLDSHOULDER_MOVE, 51
DB MEDITATE_MOVE, 55
DB SHIVER_MOVE, 60
DB 0
;evolution
DB EV_TYPE_NONE

_145ZaphRoledex:
DB 145
DB ELECTRIC
DB FLYING
DB $64 ;height
DW $00EB ;weight
DB 90 ;HP
DB 90 ;Bat
DB 85 ;Field
DB 100 ;Speed
DB 125 ;Throw
DB 7 ;Lineup Body
DB 4 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_145ZaphRightyBatterUserTiles)
DW _145ZaphRightyBatterUserTiles
DB _145ZAPH_RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $52, $A6, $10, $8C, $1E, $11, $C2 ;HM/TM bit field
;learnset
DB BENDER_MOVE, 1
DB THUNDERSTICK_MOVE, 1
DB THUNDERBALL_MOVE, 51
DB MEDITATE_MOVE, 55
DB BRAIN_MELTER_MOVE, 60
DB 0
;evolution
DB EV_TYPE_NONE

_146EltonRoledex:
DB 146
DB FIRE
DB FLYING
DB $6A ;height
DW $00D2 ;weight
DB 90 ;HP
DB 100 ;Bat
DB 90 ;Field
DB 90 ;Speed
DB 125 ;Throw
DB 7 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $42, $A6, $50, $80, $1E, $31, $82 ;HM/TM bit field
;learnset
DB HIGH_HEAT_MOVE, 1
DB MOCK_MOVE, 1
DB GLARE_MOVE, 51
DB MEDITATE_MOVE, 55
DB SKY_SMASH_MOVE, 60
DB 0
;evolution
DB EV_TYPE_NONE

_147DratsRoledex:
DB 147
DB DRAGON
DB NONE
DB $54 ;height
DW $005A ;weight
DB 41 ;HP
DB 64 ;Bat
DB 45 ;Field
DB 50 ;Speed
DB 50 ;Throw
DB 0 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $2F, $E0, $9C, $1E, $38, $C2 ;HM/TM bit field
;learnset
DB CIRCLECHANGE_MOVE, 1
DB SWING_MOVE, 1
DB SHOCKER_MOVE, 10
DB MEDITATE_MOVE, 20
DB STOMP_MOVE, 30
DB DRAGON_BUNT_MOVE, 40
DB SMASH_MOVE, 50
DB 0
;evolution
DB EV_TYPE_AGE, 148, 30
DB 0

_148AireRoledex:
DB 148
DB DRAGON
DB NONE
DB $61 ;height
DW $00AA ;weight
DB 61 ;HP
DB 84 ;Bat
DB 65 ;Field
DB 70 ;Speed
DB 70 ;Throw
DB 1 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $20, $3F, $E0, $9C, $1E, $38, $C2 ;HM/TM bit field
;learnset
DB CIRCLECHANGE_MOVE, 1
DB SWING_MOVE, 1
DB SHOCKER_MOVE, 10
DB MEDITATE_MOVE, 20
DB STOMP_MOVE, 35
DB DRAGON_BUNT_MOVE, 45
DB SMASH_MOVE, 55
DB 0
;evolution
DB EV_TYPE_AGE, 149, 55
DB 0

_149DragonRoledex:
DB 149
DB DRAGON
DB FLYING
DB $71 ;height
DW $0118 ;weight
DB 91 ;HP
DB 134 ;Bat
DB 95 ;Field
DB 80 ;Speed
DB 100 ;Throw
DB 7 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 1 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $32, $3F, $F0, $9C, $1E, $38, $C2 ;HM/TM bit field
;learnset
DB CIRCLECHANGE_MOVE, 1
DB SWING_MOVE, 1
DB SHOCKER_MOVE, 10
DB MEDITATE_MOVE, 20
DB STOMP_MOVE, 35
DB DRAGON_BUNT_MOVE, 45
DB SMASH_MOVE, 60
DB 0
;evolution
DB EV_TYPE_NONE

_150MikeRoledex:
DB 150
DB PSYCHIC
DB NONE
DB $69 ;height
DW $00E6 ;weight
DB 106 ;HP
DB 110 ;Bat
DB 90 ;Field
DB 130 ;Speed
DB 154 ;Throw
DB 7 ;Lineup Body
DB 0 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $1C, $6F, $B7, $AC, $7F, $A8, $E6 ;HM/TM bit field
;learnset
DB BRAIN_MELTER_MOVE, 1
DB CUTTER_MOVE, 1
DB PREDICT_MOVE, 1
DB SWAT_MOVE, 1
DB DRAG_BUNT_MOVE, 63
DB CURVEBALL_MOVE, 70
DB SHIVER_MOVE, 75
DB KINESIS_MOVE, 81
DB 0
;evolution
DB EV_TYPE_NONE

_151MickRoledex:
DB 151
DB PSYCHIC
DB NONE
DB $58 ;height
DW $0096 ;weight
DB 100 ;HP
DB 100 ;Bat
DB 100 ;Field
DB 100 ;Speed
DB 100 ;Throw
DB 0 ;Lineup Body
DB 3 ;Lineup Head
DB 2 ;Lineup Hat
DB 0 ;Lineup Palette
DW PaletteSepia ;Color Palette
;animations
DB BANK(_LeftyBatterUserTiles)
DW _LeftyBatterUserTiles
DB _LEFTY_BATTER_USER_TILE_COUNT
DB BANK(_RightyBatterUserTiles)
DW _RightyBatterUserTiles
DB _RIGHTY_BATTER_USER_TILE_COUNT
DB BANK(_LeftyPitcherUserTiles)
DW _LeftyPitcherUserTiles
DB _LEFTY_PITCHER_USER_TILE_COUNT
DB BANK(_RightyPitcherUserTiles)
DW _RightyPitcherUserTiles
DB _RIGHTY_PITCHER_USER_TILE_COUNT
DB BANK(_LeftyBatterOpponentTiles)
DW _LeftyBatterOpponentTiles
DB _LEFTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_RightyBatterOpponentTiles)
DW _RightyBatterOpponentTiles
DB _RIGHTY_BATTER_OPPONENT_TILE_COUNT
DB BANK(_LeftyPitcherOpponentTiles)
DW _LeftyPitcherOpponentTiles
DB _LEFTY_PITCHER_OPPONENT_TILE_COUNT
DB BANK(_RightyPitcherOpponentTiles)
DW _RightyPitcherOpponentTiles
DB _RIGHTY_PITCHER_OPPONENT_TILE_COUNT
DB $FF, $FF, $FF, $FF, $FF, $FF, $FE ;HM/TM bit field
;learnset
DB BOMB_MOVE, 1
DB FOUR_SEAM_MOVE, 1
DB CURVEBALL_MOVE, 20
DB KNUCKLEBALL_MOVE, 30
DB BRAIN_MELTER_MOVE, 40
DB 0
;evolution
DB EV_TYPE_NONE

Roledex:
DW _001BubbiRoledex
DW _002IvyRoledex
DW _003VenusRoledex
DW _004GingerRoledex
DW _005FrecklesRoledex
DW _006BigRedRoledex
DW _007SquirtRoledex
DW _008PudgeRoledex
DW _009YogiRoledex
DW _010SweetPeaRoledex
DW _011MetaRoledex
DW _012ButterflyRoledex
DW _013WeedsRoledex
DW _014KooKooRoledex
DW _015BeedieRoledex
DW _016PidgeRoledex
DW _017GioRoledex
DW _018OTRoledex
DW _019RatTailRoledex
DW _020CaitRoledex
DW _021StoopRoledex
DW _022CrowRoledex
DW _023SnakeRoledex
DW _024CobraRoledex
DW _025ChuRoledex
DW _026RaiRoledex
DW _027ShrewRoledex
DW _028SandyRoledex
DW _029ChicaRoledex
DW _030MuchachaRoledex
DW _031ReinaRoledex
DW _032ChicoRoledex
DW _033MuchachoRoledex
DW _034RayRoledex
DW _035FairyRoledex
DW _036FableRoledex
DW _037VulfpekRoledex
DW _038FoxyRoledex
DW _039PuffRoledex
DW _040TuffRoledex
DW _041BatsRoledex
DW _042GoldBatsRoledex
DW _043OddieRoledex
DW _044GloomyRoledex
DW _045VileRoledex
DW _046ParisRoledex
DW _047PariahRoledex
DW _048NattyRoledex
DW _049MotherRoledex
DW _050DiggsRoledex
DW _051DougRoledex
DW _052MeowRoledex
DW _053PurrRoledex
DW _054DuckRoledex
DW _055GoldDuckRoledex
DW _056ManRoledex
DW _057PrimoRoledex
DW _058LithiumRoledex
DW _059ArcaneRoledex
DW _060PollyRoledex
DW _061SwirlRoledex
DW _062WrathRoledex
DW _063BruhRoledex
DW _064DabRoledex
DW _065KazaaRoledex
DW _066ChipRoledex
DW _067ChokeRoledex
DW _068ChampRoledex
DW _069SproutRoledex
DW _070WeepyRoledex
DW _071VicRoledex
DW _072FonzRoledex
DW _073CruelRoledex
DW _074DudeRoledex
DW _075GravelRoledex
DW _076GolemRoledex
DW _077PintoRoledex
DW _078MustangRoledex
DW _079SlowpokeRoledex
DW _080LaggardRoledex
DW _081MagnetRoledex
DW _082TonRoledex
DW _083DubiousRoledex
DW _084DuceRoledex
DW _085TreyRoledex
DW _086SealRoledex
DW _087SealionRoledex
DW _088GreaserRoledex
DW _089YuckRoledex
DW _090CupRoledex
DW _091DishRoledex
DW _092GasRoledex
DW _093MortyRoledex
DW _094MacobbRoledex
DW _095OnyxRoledex
DW _096ZeeRoledex
DW _097MediumRoledex
DW _098DickRoledex
DW _099RexRoledex
DW _100SpeedballRoledex
DW _101TuckerRoledex
DW _102EdRoledex
DW _103EddRoledex
DW _104BonesRoledex
DW _105MarrowRoledex
DW _106BruceRoledex
DW _107JackieRoledex
DW _108TongueRoledex
DW _109AshRoledex
DW _110SmokeyRoledex
DW _111RhinoRoledex
DW _112DonRoledex
DW _113ChanceRoledex
DW _114FrizzRoledex
DW _115GengisRoledex
DW _116BrainRoledex
DW _117EinsteinRoledex
DW _118GoldieRoledex
DW _119SeekerRoledex
DW _120StarchildRoledex
DW _121StarmanRoledex
DW _122MimeRoledex
DW _123ScissorsRoledex
DW _124JinxRoledex
DW _125BuzzRoledex
DW _126MagmaRoledex
DW _127PinchRoledex
DW _128BullRoledex
DW _129FishRoledex
DW _130GarRoledex
DW _131BusRoledex
DW _132YeahYeahRoledex
DW _133EvieRoledex
DW _134VaporRoledex
DW _135JoltRoledex
DW _136FalreRoledex
DW _137PolygonRoledex
DW _138SpiralRoledex
DW _139SpireRoledex
DW _140HorshoeRoledex
DW _141TopperRoledex
DW _142ArrowheadRoledex
DW _143BearRoledex
DW _144ArtRoledex
DW _145ZaphRoledex
DW _146EltonRoledex
DW _147DratsRoledex
DW _148AireRoledex
DW _149DragonRoledex
DW _150MikeRoledex
DW _151MickRoledex
