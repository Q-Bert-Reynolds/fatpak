INCLUDE "img/play/runners/runners.asm"
INCLUDE "img/play/count/count.asm"
INCLUDE "img/play/arrow/arrow.asm"

DEF OUT_COUNT_BASES_LEN EQU 6
OutCountBases:
  DB "<out_ou><out_t><count_balls><count_strikes><runners_3B_2B><runners_1B>"

; DrawPlayerUI:: ;a = team (0 = user, 1 = opponent)
;   push af;team
;   ld c, a;team
;   and a
;   jr z, .userPlayer
; .opposingPlayer
;   xor a
;   ld [_x], a
;   ld a, 3
;   ld [_y], a;if (team) x = 0, y = 3;
;   jr .checkHomeAway
; .userPlayer
;   ld a, 8
;   ld [_x], a
;   ld a, 10
;   ld [_y], a ;else x = 8, y = 10;
; .checkHomeAway
;   ld b, 1
;   ld a, [home_team]
;   cp c
;   jr z, .teamIsHome
;   xor a
;   ld b, a
; .teamIsHome
;   xor a
;   ld [_b], a
;   ld a, [frame]
;   and a, 1
;   cp b
;   jr z, .teamIsPitching
;   ld a, 1
;   ld [_b], a;team is batting
; .teamIsPitching ;b = (team == home_team) != (frame % 2);

;   ld a, ' '
;   ld hl, tile_buffer
;   ld [hli], a;tiles[0] = " ";
;   inc hl

;   xor a
;   ld [_i], a
; .nameBarLoop;for (i = 0; i < 10; i++) 
;     ld a, '─'
;     ld [hli], a ;tiles[i+2] = "─";
;     ld a, [_i]
;     inc a
;     ld [_i], a
;     cp 10
;     jr nz, .nameBarLoop

;   pop af;team
;   push af
;   and a
;   jr nz, .setOpponentName
;   call GetCurrentUserPlayer
;   call GetUserPlayerName
;   jr .drawName
; .setOpponentName
;   call GetCurrentOpponentPlayer
;   call GetPlayerNumber
;   call GetPlayerName
; .drawName
;   ld hl, name_buffer
;   call str_Length;de = len
;   ld a, 12
;   sub a, e;(12-len)
;   srl a;(12-len)/2
;   inc a;1+(12-len)/2
;   ld b, d
;   ld c, e; bc = len
;   ld hl, tile_buffer
;   ld d, 0
;   ld e, a;de = 1+(12-len)/2
;   add hl, de
;   ld d, h
;   ld e, l;de = tile_buffer+1+(12-len)/2
;   ld hl, name_buffer
;   call mem_Copy

;   pop af;team
;   push af
;   and a
;   jr nz, .setOpponentAge
;   call GetCurrentUserPlayer
;   jr .drawAge
; .setOpponentAge
;   call GetCurrentOpponentPlayer
; .drawAge
;   ld d, h
;   ld e, l
;   ld hl, tile_buffer+12
;   call SetAgeTiles
; .doneWithAge
;   ld a, [_b]
;   and a
;   jr z, .isPitcher ;if (b) {
;   ld hl, tile_buffer+1
;   call CurrentOrderInLineup
;   add a, '1'
;   ld [hl], a ;tiles[1] = "1" + p->batting_order;
;   ld hl, tile_buffer+15
;   ld a, '<BA>'
;   ld [hl], a ;tiles[15] = "<BA>";
;   jr .doneWithPlayerStats
; .isPitcher ;else {
;   ld hl, tile_buffer+1
;   ld a, '<P>'
;   ld [hl], a ;tiles[1] = p->position;
;   ld hl, tile_buffer+15
;   ld a, '<ERA>'
;   ld [hl], a ;tiles[15] = "<ERA>";

; .doneWithPlayerStats
;   ld a, ' '
;   ld hl, tile_buffer+20 ;tiles[20] = " ";
  
;   ld a, [_x]
;   ld d, a
;   ld a, [_y]
;   ld e, a
;   ld h, 12
;   ld l, 2
;   ld bc, tile_buffer
;   call gbdk_SetBkgTiles;set_bkg_tiles(x,y,12,2,tiles);

;   ld a, [_b]
;   and a
;   jr z, .setERA;if (b) 
; .setBatAvg
;   pop af;team
;   push af
;   ld de, 324
;   call BattingAvgToString
;   ld hl, str_buffer+4
;   ld a, ' '
;   ld [hl], a
;   ld a, [_x]
;   add a, 4
;   ld d, a
;   ld a, [_y]
;   inc a
;   ld e, a
;   ld h, 5
;   ld l, 1
;   ld bc, str_buffer
;   call gbdk_SetBkgTiles ;set_bkg_tiles(x+4,y+1,4,1,batting_avg(p));
;   jr .setHealthPct

; .setERA
;   pop af;team
;   push af
;   ld hl, 902
;   call EarnedRunAvgToString
;   ld hl, str_buffer+4
;   ld a, ' '
;   ld [hl], a

;   ld a, [_x]
;   add a, 4
;   ld d, a
;   ld a, [_y]
;   inc a
;   ld e, a
;   ld h, 5
;   ld l, 1
;   ld bc, str_buffer
;   call gbdk_SetBkgTiles ;else set_bkg_tiles(x+4,y+1,4,1,earned_run_avg(p));

; .setHealthPct 
;   pop af;team
;   ld a, 85
;   call HealthPctToString
;   ld a, [_x]
;   add a, 9
;   ld d, a
;   ld a, [_y]
;   inc a
;   ld e, a
;   ld h, 3
;   ld l, 1
;   ld bc, str_buffer
;   call gbdk_SetBkgTiles;set_bkg_tiles(x+9,y+1,3,1,health_pct(p));
;   ret

DrawPlayerUI:: ;a = team (0 = user, 1 = opponent)
  and a
  jr z, DrawUserPlayerUI
  jp DrawOpposingPlayerUI

DrawUserPlayerUI::
  ld a, ' '
  ld hl, tile_buffer
  ld bc, 30
  call mem_Set
  
.arrow
  ld a, '<arrow_tail>'
  ld hl, tile_buffer+9
  ld [hl], a
  ld a, '<arrow_line_vert>'
  ld hl, tile_buffer+19
  ld [hl], a
  ld a, '<arrow_elbow_right>'
  ld hl, tile_buffer+29
  ld [hl], a
  ld a, '<arrow_tip_left>'
  ld hl, tile_buffer+20
  ld [hli], a
  ld a, '<arrow_line_horiz>'
  ld bc, 8
  call mem_Set
  ld hl, $0A03
  ld de, $0909
  ld bc, tile_buffer
  call gbdk_SetBkgTiles

.name
  call GetCurrentUserPlayer
  call GetUserPlayerName
  DRAW_STRING DRAW_FLAGS_BKG, 9, 9, name_buffer
  ret

DrawOpposingPlayerUI::
  LOAD_TILES _ArrowCornerBottomLeftTile, _VRAM+$1000, '<arrow_elbow_left>', 1
  LOAD_TILES _ArrowTipRightTile, _VRAM+$1000, '<arrow_tip_right>', 1

  ld a, ' '
  ld hl, tile_buffer
  ld bc, 30
  call mem_Set
  
.arrow
  ld a, '<arrow_tail>'
  ld hl, tile_buffer+10
  ld [hl], a
  ld a, '<arrow_tip_right>'
  ld hl, tile_buffer+29
  ld [hl], a
  ld a, '<arrow_elbow_left>'
  ld hl, tile_buffer+20
  ld [hli], a
  ld a, '<arrow_line_horiz>'
  ld bc, 8
  call mem_Set
  ld hl, $0A03
  ld de, $0101
  ld bc, tile_buffer
  call gbdk_SetBkgTiles

.name
  call GetCurrentOpponentPlayer
  call GetPlayerName
  DRAW_STRING DRAW_FLAGS_BKG, 2, 2, name_buffer
  ret

DrawBases::
  ld bc, 16
  ld de, _VRAM+$1000 + '<runners_1B>'*16
.checkFirstBase
  ld a, [runners_on_base]
  and a, LOW(FIRST_BASE_MASK)
  jr z, .notOnFirstBase
.runnerOnFirstBase
  ld hl, _RunnerOnFirstTile
  jr .drawFirstBase
.notOnFirstBase
  ld hl, _FirstEmptyTile
.drawFirstBase
  call mem_CopyVRAM
  
  ld bc, 16
  ld de, _VRAM+$1000 + '<runners_3B_2B>'*16
.checkSecondThirdBase
  ld a, [runners_on_base]
  and a, LOW(SECOND_BASE_MASK)
  ld b, a
  ld a, [runners_on_base+1]
  and a, HIGH(THIRD_BASE_MASK)
  or a, b
  jr z, .notOnSecondOrThirdBase
  cp a, LOW(SECOND_BASE_MASK)
  jr z, .runnerOnSecond
  cp a, HIGH(THIRD_BASE_MASK)
  jr z, .runnerOnThird
.runnersOnSecondAndThird
  ld hl, _RunnersOnSecondAndThirdTile
  jr .drawSecondAndThirdBase
.runnerOnSecond
  ld hl, _RunnerOnSecondTile
  jr .drawSecondAndThirdBase
.runnerOnThird
  ld hl, _RunnerOnThirdTile
  jr .drawSecondAndThirdBase
.notOnSecondOrThirdBase
  ld hl, _SecondAndThirdEmptyTile
.drawSecondAndThirdBase
  call mem_CopyVRAM
  ret

DrawCountOutsInning::
  LOAD_TILES _OutsOuTile, _VRAM+$1000, '<out_ou>', 1
  LOAD_TILES _OutsTTile, _VRAM+$1000, '<out_t>', 1
  
.balls
  ld bc, 16
  ld de, _VRAM+$1000 + '<count_balls>'*16
  call GetBalls
  ld hl, _NoBallsTile
  and a
  jr z, .setBallsTile
  ld hl, _OneBallTile
  dec a
  jr z, .setBallsTile
  ld hl, _TwoBallsTile
  dec a
  jr z, .setBallsTile
  ld hl, _ThreeBallsTile
.setBallsTile
  call mem_CopyVRAM

.strikes
  ld bc, 16
  ld de, _VRAM+$1000 + '<count_strikes>'*16
  call GetStrikes
  ld hl, _NoStrikesTile
  and a
  jr z, .setStrikesTile
  ld hl, _OneStrikeTile
  dec a
  jr z, .setStrikesTile
  ld hl, _TwoStrikesTile
.setStrikesTile
  call mem_CopyVRAM

.tilemap
  ld de, tile_buffer
  call GetOuts
  add a, '0'
  ld [de], a
  inc de
  ld hl, OutCountBases
  ld bc, OUT_COUNT_BASES_LEN
  call mem_Copy
  ld hl, tile_buffer+OUT_COUNT_BASES_LEN+1

.frame
  ld [hl], '▼'
  ld a, [frame]
  bit 0, a
  jr nz, .inning
  ld [hl], '▲'

.inning
  inc hl
  ld d, h
  ld e, l
  srl a;frame/2
  inc a
  ld l, a
  xor a
  ld h, a
  call str_Number

.draw
  ld hl, tile_buffer
  call str_Length
  ld h, e;w
  ld l, 1;h
  ld d, 1;x
  ld e, 3;y
  ld bc, tile_buffer
  call gbdk_SetBkgTiles
  ret


DrawTeamNames::
  ld hl, user_name
  ld de, name_buffer
  ld bc, 8
  call mem_Copy;memcpy(name_buff, user_name, 8);
  
  ld hl, name_buffer
  call str_Length;l = strlen(name_buff);
  ld h, e ;w
  ld l, 1
  ld de, $0101
  ld a, [home_team]
  and a
  jr z, .setPlayerAway
  ld de, $0102  
.setPlayerAway
  ld bc, name_buffer
  call gbdk_SetBkgTiles;set_bkg_tiles(0,y,7,1,name_buff);

  ld a, [game_state]
  and a, GAME_STATE_UNSIGNED_PLAYER
  jr z, .setOpposingTeamName

.setUnsignedPlayerName
  call GetCurrentOpponentPlayer
  call GetPlayerNumber
  call GetPlayerName
  jr .drawOpposingName

.setOpposingTeamName
  ld hl, Opponent.name
  ld de, name_buffer
  call str_Copy

.drawOpposingName
  ld hl, name_buffer
  call str_Length;l = strlen(name_buff);
  ld h, e ;w
  ld l, 1
  ld de, $0101
  ld a, [home_team]
  and a
  jr nz, .setOpponentAway
  ld de, $0102
.setOpponentAway
  ld bc, name_buffer
  call gbdk_SetBkgTiles
  ret

DrawScore::
  xor a
  ld h, a
  ld a, [away_score]
  ld l, a
  ld de, name_buffer
  call str_Number

  ld hl, name_buffer
  call str_Length
  ld h, e ;w
  ld l, 1 ;h
  ld d, 10 ;x
  ld e, 1 ;y
  ld bc, name_buffer
  call gbdk_SetBkgTiles
  
  xor a
  ld h, a
  ld a, [home_score]
  ld l, a
  ld de, name_buffer
  call str_Number

  ld hl, name_buffer
  call str_Length

  ld h, e ;w
  ld l, 1 ;h
  ld d, 10 ;x
  ld e, 2 ;y
  ld bc, name_buffer
  call gbdk_SetBkgTiles
  ret

DrawPlayBallUI::
  ;TODO: track which tiles are loaded
  LOAD_TILES _ArrowTailTile, _VRAM+$1000, '<arrow_tail>', 1
  LOAD_TILES _ArrowLineVerticalTile, _VRAM+$1000, '<arrow_line_vert>', 1
  LOAD_TILES _ArrowLineHorizontalTile, _VRAM+$1000, '<arrow_line_horiz>', 1
  LOAD_TILES _ArrowCornerBottomLeftTile, _VRAM+$1000, '<arrow_elbow_left>', 1
  LOAD_TILES _ArrowCornerBottomRightTile, _VRAM+$1000, '<arrow_elbow_right>', 1
  LOAD_TILES _ArrowTipLeftTile, _VRAM+$1000, '<arrow_tip_left>', 1
  LOAD_TILES _ArrowTipRightTile, _VRAM+$1000, '<arrow_tip_right>', 1
  
  call DrawTeamNames
  call DrawScore
  call DrawBases

  DRAW_UI_BOX DRAW_FLAGS_BKG, 0, 12,  9, 6
  DRAW_UI_BOX DRAW_FLAGS_BKG, 8, 12, 12, 6

  call DrawCountOutsInning

  DRAW_STRING DRAW_FLAGS_BKG, 10, 14, PlayMenuPlayString
  DRAW_STRING DRAW_FLAGS_BKG, 15, 14, PlayMenuTeamString
  DRAW_STRING DRAW_FLAGS_BKG, 10, 16, PlayMenuItemString
  DRAW_STRING DRAW_FLAGS_BKG, 15, 16, PlayMenuRunString

  DISPLAY_ON
  ret 

MovePlayMenuArrow:
  xor a
  ld [_i], a
.columnLoop ;for (i = 0; i < 2; i++) {
    xor a
    ld [_j], a
  .rowLoop ;for (j = 0; j < 2; j++) {
      ld hl, tile_buffer
      ld a, ' '
      ld [hl], a
      ld a, [_x]
      ld b, a
      ld a, [_i]
      cp b
      jr nz, .notArrow
      ld a, [_y]
      ld b, a
      ld a, [_j]
      cp b
      jr nz, .notArrow
      ld a, '▶'
      ld [hl], a
    .notArrow ;tiles[0] = (x==i && y==j) ? "▶" : " ";
      ld a, [_i]
      add a, a;i*2
      add a, a;i*4
      ld b, a
      ld a, [_i]
      add a, a;i*2
      add a, b;i*6
      add a, 8;i*6+8
      ld d, a ;x
      ld a, [_j]
      add a, a;j*2
      add a, 14;j*2+14
      ld e, a;y
      ld a, 1
      ld h, a
      ld l, a
      ld bc, tile_buffer
      call gbdk_SetBkgTiles;set_bkg_tiles(i*6+8,j*2+14,1,1,tiles);

      ld a, [_j]
      inc a
      ld [_j], a
      cp 2
      jr nz, .rowLoop
    ld a, [_i]
    inc a
    ld [_i], a
    cp 2
    jr nz, .columnLoop
  ret

SelectPlayMenuItem::
  ld a, [play_menu_selection]
  and 1
  ld [_x], a ;x = play_menu_selection % 2;

  ld a, [play_menu_selection]
  and 2
  srl a 
  ld [_y], a ;y = (play_menu_selection & 2) >> 1;

  call MovePlayMenuArrow
  WAITPAD_UP
.moveMenuArrowLoop ;while (1) {
    call UpdateInput ;k = joypad();
.testUpPressed ;if (k & J_UP && y == 1) { y = 0; move_play_menu_arrow(); }
    ld a, [button_state]
    and a, PADF_UP
    jr z, .testDownPressed
    ld a, [_y]
    cp 1
    jr nz, .testDownPressed
    xor a
    ld [_y], a
    jr .moveArrow
.testDownPressed ;else if (k & J_DOWN && y == 0) { y = 1; move_play_menu_arrow(); }
    ld a, [button_state]
    and a, PADF_DOWN
    jr z, .testLeftPressed
    ld a, [_y]
    and a
    jr nz, .testLeftPressed
    ld a, 1
    ld [_y], a
    jr .moveArrow    
.testLeftPressed ;else if (k & J_LEFT && x == 1) { x = 0; move_play_menu_arrow(); }
    ld a, [button_state]
    and a, PADF_LEFT
    jr z, .testRightPressed
    ld a, [_x]
    cp 1
    jr nz, .testRightPressed
    xor a
    ld [_x], a
    jr .moveArrow
.testRightPressed ;else if (k & J_RIGHT && x == 0) { x = 1; move_play_menu_arrow(); }
    ld a, [button_state]
    and a, PADF_RIGHT
    jr z, .testAPressed
    ld a, [_x]
    xor a
    jr nz, .testAPressed
    ld a, 1
    ld [_x], a
.moveArrow
    call MovePlayMenuArrow
    
.testAPressed ;if (k & J_A) break;
    ld a, [button_state]
    and a, PADF_A
    jr nz, .exitMoveMenuArrowLoop
    call gbdk_WaitVBL
    jr .moveMenuArrowLoop
.exitMoveMenuArrowLoop
  ld a, [_y]
  add a, a ;y*2
  ld b, a
  ld a, [_x];y*2+x
  add a, b 
  ld [play_menu_selection], a
  ret

MoveMoveMenuArrow:
  xor a
  ld [_i], a
  ld hl, tile_buffer
.setTilesLoop ;for (i = 0; i < 4; i++) {
    ld a, [_i]
    ld b, a
    ld a, [move_choice]
    cp b
    jr z, .setArrow
    ld a, ' '
    jr .setTile
.setArrow
    ld a, '▶'
.setTile
    ld [hli], a;tiles[i] = (i == y) ? "▶" : 0;
    ld a, [_i]
    inc a
    ld [_i], a
    cp 4
    jr nz, .setTilesLoop

  ld d, 6
  ld e, 13
  ld h, 1
  ld l, 4
  ld bc, tile_buffer
  call gbdk_SetBkgTiles;set_bkg_tiles(6,13,1,4,tiles);
  ret

ShowMoveInfo::;[_d] = move mask
  ld b, 0
  ld c, 8
  ld d, 11
  ld e, 5
  ld a, DRAW_FLAGS_BKG
  call DrawUIBox

  ld d, 1
  ld e, 9
  ld h, 5
  ld l, 1
  ld bc, TypeSlashText
  call gbdk_SetBkgTiles;set_bkg_tiles(1,9,5,1,"TYPE/");

  call GetCurrentUserPlayer
  push hl;current user player
  ld a, [_d]
  ld d, a
  ld a, [move_choice]
  call GetPlayerMove
  ld a, [move_data.type]
  call GetTypeString

  ld hl, name_buffer
  call str_Length
  ld h, e
  ld l, 1
  ld d, 2
  ld e, 10
  ld bc, name_buffer
  call gbdk_SetBkgTiles;set_bkg_tiles(2,10,strlen(name_buff),1,name_buff);
  
  pop de;current user player
  ld hl, tile_buffer
  ld a, [_d];move mask
  ld b, a
  ld a, [move_choice]
  call SetMovePPTiles;a = move, b = move mask, de = player, hl = tile address
  
  ld h, 5
  ld l, 1
  ld d, 5
  ld e, 11
  ld bc, tile_buffer
  call gbdk_SetBkgTiles
  ret

SelectMoveMenuItem:: ;returns selection in a
  COPY_BKG_TO_BUFFER 0, 8, 20, 10

.drawUI
  ld b, 5
  ld c, 12
  ld d, 15
  ld e, 6
  ld a, DRAW_FLAGS_BKG
  call DrawUIBox

.drawMoveNames
  xor a
  ld [_i], a
  call GetCurrentUserPlayer
  push hl
  call IsUserFielding
  jr nz, .userIsFielding
.userIsBatting
  ld d, BATTING_MOVES
  jr .getMoveCount
.userIsFielding
  ld d, PITCHING_MOVES
.getMoveCount
  call GetPlayerMoveCount
  ld [_c], a;move count
  pop hl;player
.loopMoves
    push hl;player
    push de;move mask
    ld a, [_i]

    call GetPlayerMoveName

    ld hl, name_buffer
    call str_Length

    ld h, e
    ld l, 1
    ld d, 7
    ld a, [_i]
    add a, 13
    ld e, a
    
    ld bc, name_buffer
    call gbdk_SetBkgTiles

    pop de;move mask
    pop hl;player
    ld a, [_i]
    inc a
    ld [_i], a
    cp MAX_MOVES
    jr nz, .loopMoves

  ld a, d;move mask
  ld [_d], a
  call MoveMoveMenuArrow
  call ShowMoveInfo

  WAITPAD_UP;update_waitpadup();
.loop ;while (1) {
    call gbdk_WaitVBL
    call UpdateInput;  k = joypad();
.checkButtonUp;  if (k & J_UP && move_choice > 0) {
    ld a, [button_state]
    and PADF_UP
    jr z, .checkButtonDown
    ld a, [move_choice]
    and a
    jr z, .checkButtonDown
    dec a ;--move_choice;
    ld [move_choice], a
    call MoveMoveMenuArrow
    call ShowMoveInfo
    WAITPAD_UP
    jp .loop

.checkButtonDown;  else if (k & J_DOWN && move_choice < c-1) {
    ld a, [button_state]
    and PADF_DOWN
    jr z, .checkButtonStartA
    ld a, [_c];move count
    dec a
    ld c, a
    ld a, [move_choice]
    cp c
    jr nc, .checkButtonStartA
    inc a
    ld [move_choice], a
    call MoveMoveMenuArrow
    call ShowMoveInfo
    WAITPAD_UP
    jp .loop

.checkButtonStartA;  if (k & (J_START | J_A)) {
    ld a, [button_state]
    and PADF_START | PADF_A
    jp z, .checkButtonB
    ld a, [move_choice]
    push af
    jr .restoreTiles

.checkButtonB;  else if (k & J_B) break;
    ld a, [button_state]
    and PADF_B
    jp z, .loop
    ld a, -1
    push af

.restoreTiles
  COPY_BUFFER_TO_BKG 0, 8, 20, 10
  pop af
  inc a
  ret
