INCLUDE "src/beisbol.inc"

Section "Overworld Map", ROMX, BANK[WORLD_BANK+1]
INCLUDE "img/maps/overworld.asm"
INCLUDE "img/maps/forest.asm"
INCLUDE "maps/Mountains.gbmap"
INCLUDE "maps/Overworld.gbmap"
INCLUDE "maps/VeteranPark.gbmap"

Section "Indoor Maps", ROMX, BANK[WORLD_BANK+2]
INCLUDE "img/maps/houses.asm"
INCLUDE "img/maps/businesses.asm"
INCLUDE "maps/Houses.gbmap"
INCLUDE "maps/Businesses.gbmap"

SECTION "World Code", ROMX, BANK[WORLD_BANK]
INCLUDE "src/world/computer.asm"
INCLUDE "src/world/scripts.asm"
INCLUDE "img/maps/world_sprites.asm"
INCLUDE "maps/map_animations.gbanim"
INCLUDE "maps/map_avatars.gbavatar"

MOVE_PLAYER: MACRO;\1 = animation address, \2 = map move routine, \3 = map draw routine
  ld hl, \1
  call AnimatePlayerAvatar
  call CheckPlayerCollision
  call SetupAvatarAnimation
.loop
    push af;steps left
    push bc;c = collision
    cp a, MAP_STEP_SIZE/2
    jr nz, .checkCollision
    ld hl, \1
    call AnimatePlayerAvatar
  .checkCollision
    call CheckPlayerCollision
    jr nz, .collisionResponse
    call \2
  .collisionResponse
    pop bc;c = collision
    push bc
    ld a, c
    cp a, MAP_COLLISION_LEDGE
    jr z, .jump
    cp a, MAP_COLLISION_DOOR
    jr nz, .waitVBL
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
  .waitVBL
    call CopyMapSpritesToOAMBuffer
    call gbdk_WaitVBL
    pop bc;c = collision
    pop af;steps left
    dec a
    jr nz, .loop
  call FixMapScroll
  call CopyMapSpritesToOAMBuffer
IF !ISCONST(\3)
  call GetCurrentMap
  ld b, a
  ld hl, \3
  call Trampoline
ENDC
  ret
ENDM

MoveUp: MOVE_PLAYER GBStampAnimationCalvinWalkUp, MoveMapUp, 0
MoveDown: MOVE_PLAYER GBStampAnimationCalvinWalkDown, MoveMapDown, DrawMapBottomEdge
MoveLeft: MOVE_PLAYER GBStampAnimationCalvinWalkLeft, MoveMapLeft, 0
MoveRight: MOVE_PLAYER GBStampAnimationCalvinWalkRight, MoveMapRight, DrawMapRightEdge

Look:;a = button_state
  push af
  xor a
  ld [anim_frame], a
.checkUp
  pop af
  push af
  and a, PADF_UP
  jr z, .checkDown
  ld hl, GBStampAnimationCalvinWalkUp
  call AnimatePlayerAvatar
  jr .exit
.checkDown
  pop af
  push af
  and a, PADF_DOWN
  jr z, .checkRight
  ld hl, GBStampAnimationCalvinWalkDown
  call AnimatePlayerAvatar
  jr .exit
.checkRight
  pop af
  push af
  and a, PADF_RIGHT
  jr z, .checkLeft
  ld hl, GBStampAnimationCalvinWalkRight
  call AnimatePlayerAvatar
  jr .exit
.checkLeft
  pop af
  push af
  and a, PADF_LEFT
  jr z, .exit
  ld b, 1;flip
  ld hl, GBStampAnimationCalvinWalkLeft
  call AnimatePlayerAvatar
.exit
  pop af
  ret 

Move:;a = button_state
.checkUp
  push af
  and a, PADF_UP
  jr z, .checkDown
  call MoveUp
  jr .exit
.checkDown
  pop af
  push af
  and a, PADF_DOWN
  jr z, .checkRight
  call MoveDown
  jr .exit
.checkRight
  pop af
  push af
  and a, PADF_RIGHT
  jr z, .checkLeft
  call MoveRight
  jr .exit
.checkLeft
  pop af
  push af
  and a, PADF_LEFT
  jr z, .exit
  call MoveLeft
.exit
  pop af
  ret 
  
AnimatePlayerAvatar:;hl = animation
  ld a, [anim_frame]
  ld b, 0
  call AnimateAvatar
  ld [anim_frame], a

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

SetupAvatarAnimation:;returns step count in a, collision type in c
  ld a, [map_collision_type]
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
  TRAMPOLINE FadeOut
  ld hl, PaletteCalvin
  ld a, 7
  call GBCSetPalette
  ld a, [map_collision_data]
  call EnterMapDoor
  call FixMapScroll
  call ShowPlayerAvatar
  TRAMPOLINE FadeIn
  ret

StartMenuText:
  DB "ROLéDEX\nLINEUP\nITEM\n%s\nSAVE\nOPTIONS\nEXIT", 0

ShowPauseMenu::
  call CopyBkgToWin

.showPauseMenu
  ld a, 7
  ld [rWX], a
  xor a
  ld [rWY], a
  SHOW_WIN
  ld hl, StartMenuText
  ld de, str_buffer
  ld bc, user_name
  call str_Replace

  ld hl, name_buffer
  xor a
  ld [hl], a;no title

  ld b, 10;x
  ld c, 0 ;y
  ld d, 10;w
  ld e, 16;h
  ld a, DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP
  call ShowListMenu ;returns choice in a
  push af
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
  call ShowRoledex
  jr .returnToPauseMenu
.lineup
  cp 2
  jr nz, .item
  ld b, 0
  call ShowLineup
  jr .returnToPauseMenu
.item
  cp 3
  jr nz, .user
  ld a, INVENTORY_MODE_USE
  ld [inventory_mode], a
  call ShowInventory
  jr .returnToPauseMenu
.user
  cp 4
  jr nz, .save
  call ShowUserInfo
  jr .returnToPauseMenu
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
  HIDE_ALL_SPRITES
  ld a, [rSCX]
  ld h, a
  ld a, [rSCY]
  ld l, a
  push hl
  xor a
  ld [rSCX], a
  ld [rSCY], a
  call ShowOptions
  pop hl
  ld a, h
  ld [rSCX], a
  ld a, l
  ld [rSCY], a
.returnToPauseMenu
  call CopyBufferToWin
  call LoadAvatarSprites
  call SetMapTiles
  call SetMapPalettes
  call ShowPlayerAvatar
  call DrawMapToScreen
  POP_VAR list_selection
  jp .showPauseMenu
.exit
  HIDE_WIN
  call DrawMapToScreen
  WAITPAD_UP
  POP_VAR list_selection
  ret

CheckPlayerCollision:;returns z if no collision
  ld a, [last_map_button_state]
  and a, PADF_UP
  jr nz, .up
  ld a, [last_map_button_state]
  and a, PADF_DOWN
  jr nz, .down
  ld a, [last_map_button_state]
  and a, PADF_LEFT
  jr nz, .left
  ld a, [last_map_button_state]
  and a, PADF_RIGHT
  jr nz, .right
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
  ld [map_obj_type], a
  ld a, c
  ld [map_sprite_collision_index], a
  pop af
  and a, MAP_COLLISION_MASK
  ld [map_collision_type], a
  ld a, b
  ld [map_collision_data], a
  ld a, [map_collision_type]
  cp a, MAP_COLLISION_GRASS
  ret z
  cp a, MAP_COLLISION_NONE
  ret z
  cp a, MAP_COLLISION_DOOR
  ret z
  cp a, MAP_COLLISION_SOLID
  jr z, .stay
  cp a, MAP_COLLISION_TEXT
  jr z, .stay
  cp a, MAP_COLLISION_SCRIPT
  jr z, .stay
.checkWaterMove
  cp a, MAP_COLLISION_WATER
  jr z, .stay;TODO: add swimming
.checkLedgeMove;all other collision types already handled
  ld a, [map_collision_data];directions allowed
  cpl;flip bits
  ld b, a;directions stopped
  ld a, [last_map_button_state]
  and a, b
  ret z
  ld a, MAP_COLLISION_SOLID
  ld [map_collision_type], a
  ret
.stay
  ld a, 1
  or a
  ret

CheckActions:
  call CheckPlayerCollision
  ld a, [map_obj_type]
  cp a, MAP_OBJ_AVATAR
  jr nz, .checkCollisionType
.foundAvatar
  ld a, [map_sprite_collision_index]
  ld de, MAP_SPRITE_SIZE
  call math_Multiply;hl = map sprite index * map sprite size
  ld de, map_sprite_buffer+3
  add hl, de;hl = map sprite x address
  ld a, [rSCX]
  ld b, a
  ld a, [hli];x
  sub a, b
  cp a, 64
  jr c, .lookRight
  cp a, 80
  jr nc, .lookLeft
  ld a, [rSCY]
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
  and a, ~MAP_AVATAR_DIRECTION
  or a, c
  ld [hl], a
  call CopyMapSpritesToOAMBuffer
.checkCollisionType
  ld a, [map_collision_type]
  cp a, MAP_COLLISION_TEXT
  jr z, .displayText
  cp a, MAP_COLLISION_SCRIPT
  ret nz
.runScript
  ld a, [map_collision_data]
  jp RunMapScript
.displayText
  ld a, [map_collision_data]
  call GetMapText
  call RevealTextAndWait
  HIDE_WIN
  WAITPAD_UP
  ret

ShowPlayerAvatar:
  ld b, 72
  ld c, 76
  ld h, 2
  ld l, 2
  ld a, 0
  call MoveSprites ;bc = xy in screen space, hl = wh in tiles, a = first sprite index
  ld a, [last_map_button_state]
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

CheckRandomAppearance:
  call CheckPlayerCollision.center
  ld a, [map_collision_type]
  and a, MAP_COLLISION_GRASS
  ret z
  call gbdk_Random
  ld a, d
  and a, e
  and a, %10000000
  ret

Overworld::
  DISPLAY_OFF
  SET_DEFAULT_PALETTE

  call LoadFontTiles
  call LoadAvatarSprites
  call ShowPlayerAvatar

  call SetMapTiles
  call SetMapPalettes

  ;TODO: load song based on location
  PLAY_SONG hurrah_for_our_national_game_data, 1
  
  ld a, 1
  ld [map_scroll_speed], a
  xor a
  ld [list_selection], a

  call FixMapScroll
  call DrawMapToScreen

  SHOW_BKG
  HIDE_WIN
  DISPLAY_ON
.moveLoop
    call gbdk_WaitVBL
    call UpdateInput
    ld a, [button_state]
    and a, PADF_UP | PADF_DOWN | PADF_LEFT | PADF_RIGHT
    jr z, .checkStart
    ld [last_map_button_state], a
.checkStart
    ld a, [button_state]
    and a, PADF_START
    jr z, .checkA
    call ShowPauseMenu
.checkA
    ld a, [button_state]
    and a, PADF_A
    jr z, .look
    call CheckActions
.look
    ld a, [last_button_state]
    and a, PADF_LEFT|PADF_RIGHT|PADF_UP|PADF_DOWN
    jr nz, .move
    ld a, [button_state]
    call Look
    jr .moveLoop
.move
    ld a, [button_state]
    call Move
    call CheckRandomAppearance
    jp .moveLoop
    jr z, .moveLoop
    ret