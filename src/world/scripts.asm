YourHouseSign:
  ld bc, user_name
  jr ShowHouseSignText

RivalHouseSign:
  ld bc, rival_name

ShowHouseSignText:
  ld hl, HouseText
  ld de, str_buffer
  call str_Replace
  ld hl, str_buffer
  call RevealTextAndWait
  HIDE_WIN
  WAITPAD_UP
  ret

PickRedTeam:
  ld a, TEAM_FLAG_RED
  ld b, BANK(BilletTownRedsTeam)
  ld de, BilletTownRedsTeam.name
  ld hl, BilletTownRedsTeam.lineup
  jr PickTeam
PickGreenTeam:
  ld a, TEAM_FLAG_GREEN
  ld b, BANK(BilletTownGreensTeam)
  ld de, BilletTownGreensTeam.name
  ld hl, BilletTownGreensTeam.lineup
  jr PickTeam
PickBlueTeam:
  ld a, TEAM_FLAG_BLUE
  ld b, BANK(BilletTownBluesTeam)
  ld de, BilletTownBluesTeam.name
  ld hl, BilletTownBluesTeam.lineup
PickTeam:
  ld [team_flags], a
  push de;team name
  push bc;team bank
  call CreateUserLineupFromBank
  ; call ShowLineup;TODO: make stats the only available option
  
  ;ask if you want to manage the selected team
  pop bc;team bank
  ld c, b
  ld b, BANK(@)
  pop hl;team name
  ld de, name_buffer
  call str_FarCopy
  STR_FAR_COPY DocHickoryYouWantThisTeamText, str_buffer
  ld bc, name_buffer;team name
  ld hl, str_buffer;src
  ld de, tile_buffer;dest
  call str_Replace

  call CopyBkgToWin
  SHOW_WIN
  ld a, WX_OFS
  ldh [rWX], a
  xor a
  ldh [rWY], a
  ld hl, tile_buffer
  ld a, DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP
  ld de, 12
  call RevealText
  WAITPAD_UP
  ld b, 14
  ld c, 7
  ld a, DRAW_FLAGS_WIN
  call AskYesNo
  cp a, 1
  jr z, .done
.teamNotPicked
  xor a
  ld [team_flags], a
.done
  HIDE_WIN
  WAITPAD_UP
  ret