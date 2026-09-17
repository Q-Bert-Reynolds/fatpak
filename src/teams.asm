SECTION "Teams", ROMX, BANK[TEAMS_BANK]

INCLUDE "data/team_data.asm"

;TODO: routines for playing teams, awarding money/items, setting flags, getting text, etc.

PlayTeam::;team data loaded in [Opponent]
  ;check if requirements are met
  ;if not, play appropriate text
  ;otherwise, play intro text and start the game 

  ;clear the unsigned player game state flag to play a team
  ld a, [game_state]
  and a, ~GAME_STATE_UNSIGNED_PLAYER 
  or a, GAME_STATE_PLAY_BALL
  ld [game_state], a
  TRAMPOLINE StartGame

  ;check the win state
  ;play appropriate text
  ;set flags
  ;award items

  ret