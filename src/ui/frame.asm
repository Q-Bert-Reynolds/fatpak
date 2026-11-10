;Shared frame wait and input update (src/ui/screen.h).
SECTION FRAGMENT "Editor ROM0", ROM0

_WaitFrame::
  call gbdk_WaitVBL
  call UpdateInput
  jp _FooterTick

