;Shared frame wait and input update (src/ui/screen.h).
SECTION FRAGMENT "Editor ROM0", ROM0

_WaitFrame::;the busy spinner shows if the next one is a while coming
  xor a
  ldh [busy_frames], a
  ld de, 0
  ld c, BUSY_SPRITE
  call gbdk_MoveSprite
  call gbdk_WaitVBL
  ld a, 1
  ldh [busy_frames], a
  call UpdateInput
  jp _FooterTick

