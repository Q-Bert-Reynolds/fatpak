INCLUDE "src/beisbol.inc"

SECTION "Billet Town", ROMX
INCLUDE "data/strings/billet_town_strings.asm"

SECTION "World Meta Sprites", ROMX
INCLUDE "maps/WorldMetaSprites.gbms"

SECTION "World Code", ROMX
INCLUDE "data/strings/world_strings.asm"
INCLUDE "src/world/computer.asm"
INCLUDE "src/world/scripts.asm"
INCLUDE "img/maps/world_sprites.asm"
INCLUDE "maps/map_avatars.gbavatar"

DEF WORLD_SAMPLE_RATE       EQU 12
DEF WORLD_FRAME_STEP        EQU 60 / WORLD_SAMPLE_RATE

MACRO MOVE_PLAYER;\1 = animation address, \2 = map move routine, \3 = map draw routine
  ld hl, \1
  call AnimatePlayerAvatar
  call SetupAvatarAnimation
.loop
    push af;steps left
    push bc;collision found/type
    cp a, MAP_STEP_SIZE/2
    jr nz, .checkCollision
    ld hl, \1
    call AnimatePlayerAvatar
  .checkCollision
    pop bc;collision found/type
    push bc
    ld a, b
    and a
    jr nz, .collisionResponse
    call \2
  .collisionResponse
    pop bc;c = collision
    push bc
    ld a, c
    cp a, MAP_COLLISION_LEDGE
    jr z, .jump
    cp a, MAP_COLLISION_DOOR
    jr nz, .copySprites
  .door
    pop bc
    pop af;steps left
    jp EnterDoor
  .jump
    pop bc
    pop af;steps left
    push af
    push bc;c = collision
    call AnimateJump
  .copySprites
    call CopyMapSpritesToOAMBuffer
    ldh a, [button_state]
    and a, PADF_B
    jr nz, .skipVBL
    call gbdk_WaitVBL
  .skipVBL
    pop bc;c = collision
    pop af;steps left
    dec a
    jr nz, .loop
  ldh a, [map_steps]
  inc a
  ldh [map_steps], a
  ret
ENDM

MoveUp: MOVE_PLAYER GBStampAnimationCalvinWalkUp, MoveMapUp
MoveDown: MOVE_PLAYER GBStampAnimationCalvinWalkDown, MoveMapDown
MoveLeft: MOVE_PLAYER GBStampAnimationCalvinWalkLeft, MoveMapLeft
MoveRight: MOVE_PLAYER GBStampAnimationCalvinWalkRight, MoveMapRight

Look:;a = button_state
  ld [_a], a
  xor a
  ldh [map_anim_frame], a
.checkUp
  ld a, [_a]
  and a, PADF_UP
  jr z, .checkDown
  ld hl, GBStampAnimationCalvinWalkUp
  call AnimatePlayerAvatar
  ret
.checkDown
  ld a, [_a]
  and a, PADF_DOWN
  jr z, .checkRight
  ld hl, GBStampAnimationCalvinWalkDown
  call AnimatePlayerAvatar
  ret
.checkRight
  ld a, [_a]
  and a, PADF_RIGHT
  jr z, .checkLeft
  ld hl, GBStampAnimationCalvinWalkRight
  call AnimatePlayerAvatar
  ret
.checkLeft
  ld a, [_a]
  and a, PADF_LEFT
  ret z
  ld b, 1;flip
  ld hl, GBStampAnimationCalvinWalkLeft
  call AnimatePlayerAvatar
  ret 

Move:;a = button_state
  ld [_a], a
.checkUp
  and a, PADF_UP
  jr z, .checkDown
  call MoveUp
  ret
.checkDown
  ld a, [_a]
  and a, PADF_DOWN
  jr z, .checkRight
  call MoveDown
  ret
.checkRight
  ld a, [_a]
  and a, PADF_RIGHT
  jr z, .checkLeft
  call MoveRight
  ret
.checkLeft
  ld a, [_a]
  and a, PADF_LEFT
  ret z
  call MoveLeft
  ret 
  
AnimatePlayerAvatar:;hl = animation
  ldh a, [map_anim_frame]
  ld b, 0
  call AnimateAvatar
  ldh [map_anim_frame], a

  ;TODO: player palette should be index 0, remove code below 
  ld a, 4
  ld hl, oam_buffer+3
  ld de, 4
.colorProps
    push af
    ld a, [hl]
    or a, 7
    ld [hl], a
    add hl, de

    pop af
    dec a
    jr nz, .colorProps
  ret

SetupAvatarAnimation:;returns step count in a, collision found in b, type in c
  call CheckPlayerCollision
  ld b, a
  ldh a, [map_collision_type]
  ld c, a
  cp a, MAP_COLLISION_LEDGE
  ld a, MAP_STEP_SIZE
  ret nz
  add a, a
  ret 

JumpAnimationTable:
  DB 0,-1,-2,-3,-4,-5,-5,-6,-7,-7,-7,-8,-8,-8,-8,-8
  DB -8,-8,-8,-8,-8,-7,-7,-6,-6,-5,-5,-4,-3,-2,-1,0
AnimateJump:;a = frame
  ld b, a
  ld a, MAP_STEP_SIZE*2
  sub a, b
  ld b, 0
  ld c, a;frame
  ld hl, JumpAnimationTable
  add hl, bc
  ld a, [hl];height offset
  add a, 76
  ld c, a
  ld b, 72
  ld h, 2
  ld l, 2
  ld a, 0
  call MoveSprites
  ret 

EnterDoor::
  call PauseGame
  TRAMPOLINE FadeOut
  ld hl, PaletteCalvin
  ld a, 7
  call GBCSetPalette
  ldh a, [map_collision_data]
  call EnterMapDoor
  call ShowPlayerAvatar
  TRAMPOLINE FadeIn
  call ResumeGame
  ret

ShowPauseMenu::
  call PauseGame
  call CopyBkgToWin
  
.showPauseMenu
  ld a, WX_OFS
  ldh [rWX], a
  xor a
  ldh [rWY], a
  SHOW_WIN
  ld hl, StartMenuText
  ld de, str_buffer
  ld bc, user_name
  call str_Replace

  xor a
  ld hl, name_buffer
  ld [hl], a;no title

  ld a, [pc_flags]
  and a, PC_FLAG_GOT_ROLEDEX
  jr z, .showMenuWithoutRoledex
.showFullMenu
  ld b, 10;x
  ld c, 0 ;y
  ld d, 10;w
  ld e, 16;h
  ld a, DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP
  call ShowListMenu ;returns choice in a
  jr .copyCopyWinToBuffer

.showMenuWithoutRoledex
  ld hl, str_buffer
  ld de, tile_buffer;this is discarded
  call str_CopyLine
  ld de, str_buffer
  call str_Copy
  ld b, 10;x
  ld c, 0 ;y
  ld d, 10;w
  ld e, 14;h
  ld a, DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP
  call ShowListMenu ;returns choice in a
  and a
  jr z, .copyCopyWinToBuffer
  inc a;offset because roledex isn't available

.copyCopyWinToBuffer
  push af;choice
  call CopyWinToBuffer
  pop af
  ld b, a;choice
  PUSH_VAR list_selection
  ld a, b;choice
  and a
  jp z, .exit

.roledex
  cp 1
  jr nz, .lineup
  TRAMPOLINE ShowRoledex
  jr .restoreMap

.lineup
  cp 2
  jr nz, .item
  ld de, 0
  ld a, [team_flags]
  and a, TEAM_FLAG_ANY
  jr z, .returnToPauseMenu;you haven't picked a team yet
  TRAMPOLINE ShowLineup
  jr .restoreMap

.item
  cp 3
  jr nz, .user
  ld a, INVENTORY_MODE_USE
  ld [inventory_mode], a
  TRAMPOLINE ShowInventory
  jr .returnToPauseMenu

.user
  cp 4
  jr nz, .save
  TRAMPOLINE ShowUserInfo
  jr .restoreMap

.save
  cp 5
  jr nz, .option
  call ShowSaveGame
  call ShowPlayerAvatar
  call DrawMapToScreen
  jp .exit

.option
  cp 6
  jr nz, .exit
  HIDE_WIN
  call HideAllSprites
  ldh a, [rSCX]
  ld h, a
  ldh a, [rSCY]
  ld l, a
  push hl
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  TRAMPOLINE UIShowOptions
  pop hl
  ld a, h
  ldh [rSCX], a
  ld a, l
  ldh [rSCY], a

.restoreMap
  DISPLAY_OFF
  call LoadAvatarSprites
  call LoadMap
  DISPLAY_ON
  
.returnToPauseMenu
  call CopyBufferToWin
  call ShowPlayerAvatar
  POP_VAR list_selection
  jp .showPauseMenu

.exit
  call ResumeGame
  call DrawMapToScreen
  call gbdk_WaitVBL
  HIDE_WIN
  call WaitPadUp
  POP_VAR list_selection
  ret

CheckPlayerCollision:;returns z if no collision (also in a)
  ldh a, [map_last_button_state]
  and a, PADF_UP
  jr nz, .up
  ldh a, [map_last_button_state]
  and a, PADF_DOWN
  jr nz, .down
  ldh a, [map_last_button_state]
  and a, PADF_LEFT
  jr nz, .left
  ldh a, [map_last_button_state]
  and a, PADF_RIGHT
  jr nz, .right
.noCollision
  xor a
  ret
.up
  ld b, 76
  ld c, 63;up
  jr .getChunk
.down
  ld b, 76
  ld c, 81;down
  jr .getChunk
.left 
  ld b, 63;left
  ld c, 76
  jr .getChunk
.right  
  ld b, 81;right
  ld c, 76
  jr .getChunk
.center::
  ld b, 76
  ld c, 76
.getChunk
  call GetScreenCollision
  push af
  and a, MAP_OBJ_TYPE_MASK
  ldh [map_obj_type], a
  ld a, c
  ldh [map_sprite_collision_index], a
  pop af
  and a, MAP_COLLISION_MASK
  ldh [map_collision_type], a
  ld a, b
  ldh [map_collision_data], a
  ldh a, [map_collision_type]
  cp a, MAP_COLLISION_GRASS
  jr z, .noCollision
  cp a, MAP_COLLISION_DOOR
  jr z, .noCollision
  cp a, MAP_COLLISION_NONE
  ret z
  cp a, MAP_COLLISION_ITEM
  jr z, .solid
  cp a, MAP_COLLISION_SOLID
  jr z, .solid
  cp a, MAP_COLLISION_TEXT
  jr z, .solid
  cp a, MAP_COLLISION_SCRIPT
  jr z, .solid
  cp a, MAP_COLLISION_TEAM
  jr z, .solid
.checkWaterMove
  cp a, MAP_COLLISION_WATER
  jr z, .solid;TODO: add swimming
.checkLedgeMove;all other collision types already handled
  ldh a, [map_collision_data];directions allowed
  cpl;flip bits
  ld b, a;directions stopped
  ldh a, [map_last_button_state]
  and a, b
  ret z
  ld a, MAP_COLLISION_SOLID
  ldh [map_collision_type], a
  ret
.solid
  ld a, 1
  or a
  ret

CheckActions:
  call CheckPlayerCollision
  ldh a, [map_obj_type]
  cp a, MAP_OBJ_AVATAR
  jr nz, .checkCollisionType
.foundAvatar
  ldh a, [map_sprite_collision_index]
  ld de, SPRITE_OBJ_SIZE
  call math_Multiply;hl = map sprite index * map sprite size
  ld de, sprite_obj_buffer+3
  add hl, de;hl = map sprite x address
  ldh a, [rSCX]
  ld b, a
  ld a, [hli];x
  sub a, b
  cp a, 64
  jr c, .lookRight
  cp a, 80
  jr nc, .lookLeft
  ldh a, [rSCY]
  ld b, a
  ld a, [hl];y
  sub a, b 
  cp a, 64
  jr c, .lookDown
  cp a, 80
  jr nc, .lookUp
  ;shouldn't be here
.lookLeft
  ld c, MAP_AVATAR_LEFT
  jr .look
.lookRight
  ld c, MAP_AVATAR_RIGHT
  jr .look
.lookUp
  ld c, MAP_AVATAR_UP
  jr .look
.lookDown
  ld c, MAP_AVATAR_DOWN
.look
  inc hl
  ld a, [hl];extra data
  and a, MAP_AVATAR_EXTRA_DATA
  or a, c
  ld [hl], a
.checkCollisionType
  ldh a, [map_collision_data]
  ld b, a
  ldh a, [map_collision_type]
  cp a, MAP_COLLISION_ITEM
  jp z, PickUpMapItem
  cp a, MAP_COLLISION_TEAM
  jp z, PlayMapTeam
  cp a, MAP_COLLISION_SCRIPT
  jp z, RunMapScript
  cp a, MAP_COLLISION_TEXT
  ret nz
.displayText
  ld a, b
  call GetMapText
  call RevealTextAndWait
  HIDE_WIN
  call WaitPadUp
  ret

ShowPlayerAvatar:
  ld b, 72
  ld c, 76
  ld h, 2
  ld l, 2
  ld a, 0
  call MoveSprites ;bc = xy in screen space, hl = wh in tiles, a = first sprite index
  ldh a, [map_last_button_state]
  call Look
  SHOW_SPRITES
  ret 

LoadAvatarSprites:;NOTE: this should be done BEFORE setting GBC map palettes
  ; ld hl, _AvatarsTiles
  ; ld de, $8000
  ; ld bc, _AVATARS_TILE_COUNT*16
  ; call mem_CopyVRAM

  ld hl, PaletteCalvin
  ld a, 7
  call GBCSetPalette
  ret

CheckRandomEncounter:;TODO get available players and age range from grass in exported object
  ldh a, [map_steps]
  and a
  ret z;hasn't made a step yet

  call CheckPlayerCollision.center
  ldh a, [map_collision_type]
  and a, MAP_COLLISION_GRASS
  ret z;not on the grass

.checkTryout
  call gbdk_Random
  ld a, d
  and a, e
  and a, %10000000
  ret z;no tryout
  xor a, d
  ret z;no tryout

.setUnsignedPlayerGameStateFlag
  ld a, [game_state]
  or a, GAME_STATE_UNSIGNED_PLAYER
  ld [game_state], a

.randomizeHomeAway
  ld a, [rand_hi]
  and 1;This instruction gets me hype every time I type it.
  ld [home_team], a

.randomizeUnsignedPlayer
  call GetMapEncounter;age in b, player num in c, props in d
  ld e, PITCHER
  ld hl, OpponentLineupPlayer1
.fillLineupWithPlayerLoop
    push bc;age/player num
    push de;props/position
    ld a, c;player num in a
    ld c, e;position in c
    push hl;lineup address
    call CreatePlayer;a = num, b = age, c = pos, d = props, hl = address to write player, all registers restored
    pop hl;lineup address
    ld b, 0
    ld c, OpponentLineupPlayer2 - OpponentLineupPlayer1
    add hl, bc
    pop de;props/position
    pop bc;age/player num
    inc e;next position
    ld a, 10
    cp a, e
    jr nz, .fillLineupWithPlayerLoop
  ld a, 1
  and 1
  ret

InitMap::
  DISPLAY_OFF
  call DisableLCDInterrupt
  SET_DEFAULT_PALETTE

  TRAMPOLINE UILoadFontTiles
  call LoadAvatarSprites
  call ShowPlayerAvatar
  call LoadMap

  ;TODO: load song based on location
  PLAY_SONG hurrah_for_our_national_game_data, 1
  
  ld a, 1
  ldh [map_scroll_speed], a
  xor a
  ld [list_selection], a
  ldh [map_steps], a

  SHOW_BKG
  HIDE_WIN
  DISPLAY_ON
  ret

Overworld::
  ld a, WORLD_FRAME_STEP
  ldh [anim_frame_step], a
  call InitMap
  .moveLoop
    call CopyMapSpritesToOAMBuffer
    call gbdk_WaitVBL
    call UpdateInput
    ldh a, [button_state]
    and a, PADF_UP | PADF_DOWN | PADF_LEFT | PADF_RIGHT
    jr z, .checkStart
    ldh [map_last_button_state], a
  .checkStart
    ldh a, [button_state]
    and a, PADF_START
    jr z, .checkA
    call ShowPauseMenu
  .checkA
    ldh a, [button_state]
    and a, PADF_A
    jr z, .look
    call CheckActions
  .look
    ldh a, [last_button_state]
    and a, PADF_LEFT|PADF_RIGHT|PADF_UP|PADF_DOWN
    jr nz, .move
    ldh a, [button_state]
    call Look
    jr .moveLoop
  .move
    ldh a, [button_state]
    call Move
    call CheckRandomEncounter
    jr z, .moveLoop
    ret