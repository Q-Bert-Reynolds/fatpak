;Shared frame wait and input update (src/ui/screen.h).
SECTION FRAGMENT "Editor ROM0", ROM0

_WaitFrame::
  call gbdk_WaitVBL
  call UpdateInput
  call SGBAttrFlush;(after the mouse driver's ACK, which it waits for)
  call ScrollBarFrame;(after the mouse driver's report)
  jp _FooterTick

