# In-game cart-button menu

Build with `make assemble`. There is one in-game menu implementation: RESUME
and EXIT TO OS. B resumes; up/down/select moves; A or Start selects the item.

The entry and resume sequence now follows stock GBCOS v1.06 more closely:

- Unlock before patching the OS VBlank vector at boot. Install the in-game
  vector before launch configuration and MBC writes.
- Push the interrupted registers and unlock immediately, removing the former
  one-second delay. Write `$04` to `$BD06`, save SP, and switch to a resident stack.
- Keep the small state variables and stack in resident OS memory. Only the
  borrowed palettes, sprite tiles and OAM use PSRAM block `$3e3f`.
- Select page 9 explicitly. A previous read of 9 did not establish that the page
  register was immutable.
- Finish PSRAM reads before clearing `$BD06`, restoring the game SP and mapper,
  pulsing `$BD09`, restoring CPU registers, and jumping to `$0040` to deliver
  the pending VBlank to the game's handler.

The context occupies the unused `$0009-$001f` gap between the reboot stub and
RST `$20`. Its nine-byte stack has a maximum call depth of four bytes. Link
assertions prevent overlap and keep resume code away from mapper write addresses.
The menu leaves game WRAM/HRAM alone apart from pushing interrupted registers
onto the original game stack.

Gearboy now fetches the OS's actual `$0040` vector rather than injecting a jump
to `$0670`, and exposes captured mapper bytes at `$BD14-$BD17`. These changes
make emulator testing less likely to hide replacement-OS mistakes.

Validation: the OS assembles and passes its page layout check. A core harness
launches synthetic MBC5 games in DMG and CGB modes, then checks three repeated
menu entry/resume cycles, resident stack headroom, VBlank progress after resume,
and restoration of ROM bank 3.

This remains a hardware test candidate. The reported DMG/GBA SP freezes,
blank/disabled display, garbage and occasional return to the browser have not
been reproduced or confirmed fixed on physical hardware. Copy `bin/GBCOS.BIN`
to `/GBCSYS/GBCOS.BIN` on the test card, retaining the previous OS, and test
entry, repeated resume, and EXIT TO OS. Building does not update the card.
