# In-game cart-button menu

Build with `make assemble`. B resumes; up/down/select moves the highlight; A or
Start chooses Resume game or Return to OS. There is one menu implementation.
When `/media/qbertreynolds/GAMEBOY` is mounted, a successful OS build also
copies `GBCOS.BIN` to its `GBCSYS` folder and flushes the write to the card.

The cart-button entry follows stock GBCOS v1.06: push the interrupted registers,
unlock immediately, write `$04` to `$BD06`, save SP, and select an OS page and
resident stack before reading the game mapper registers at `$BD14-$BD17`.
The normal OS VBlank vector is installed at startup; launch replaces it with
the in-game entry vector.

The full-screen background menu disables sprites and the window. Its labels
use the editor's variable-width font: `ingame_menu.py` composes their pixels
from `img/fonts/font_vwf.asm` during the normal build. Static labels avoid
using the editor renderer's scratch variables while game RAM is live. Change
the labels and positions in that script. The box follows the editor's OpenBox
geometry: a dark one-pixel border, four-pixel padding, half-row top/bottom,
and no title. DMG selection is inverted; CGB uses the shared editor theme.
Both bars match that selection treatment. The footer shows button hints; the
OS currently has no clock reader.

Before launch, the basename is converted from UTF-8 to the editor's Latin-1
charset and drawn with the existing VWF renderer. Its 160-byte ink bitmap is
kept at `$BE20` in PSRAM block `$3e3f`, outside game WRAM/HRAM. Entry encodes
it for the current hardware mode. Long filenames are clipped at the right edge.
This also works for games without battery RAM; it does not depend on a save
record or the cartridge header's internal title.

Only BG tiles `$8000-$87ff`, BG map `$9800-$9bff`, CGB attributes for that map,
and BG palette 0 are borrowed. Their original contents are saved in PSRAM
blocks `$3e30-$3e37` and `$3e3f`. Other tiles, maps, palettes and OAM remain
untouched. Resume restores the borrowed data, LCDC, scrolling, BGP, VBK and
BCPS before restoring the game SP and mapper, pulsing `$BD09`, and jumping to
`$0040` to deliver the pending VBlank. The game picture is hidden during the
menu; its sprites do not compete with menu text.

The small context and nine-byte stack occupy `$0009-$001f`, between the reboot
stub and RST `$20`. The deepest call chain uses six bytes, leaving three spare.
Link assertions protect this gap and keep resume code below mapper-write
addresses. Apart from pushing interrupted registers on the game stack, the
menu leaves game WRAM/HRAM alone. The menu explicitly selects page 4 and uses a resident trampoline to load its
static graphics from page 9; it does not use the editor's page-switching
scratch variables. The prelaunch filename renderer uses the normal OS stack
and editor scratch space while the game is not running.

Return to OS is a warm restart. It stops interrupts, timer, serial, sound and
active CGB HBlank DMA, turns off the LCD, restores the six resident bytes
written as mapper registers, and jumps directly to `Main`. Launch saves those
bytes before configuring the game mapper. Main resets cartridge switch state,
installs the normal VBlank vector, initializes the editor, backs up the game's
save, and opens the file browser. No `$BD06=$10` reset or Nintendo logo is
requested. A DMG game leaves the OS in DMG mode even on a CGB/GBA; changing
that hardware mode requires the boot ROM and a full reset.

Gearboy distinguishes `$BD09` bit 2 (select OS) from `$BD06` bit 4 (reset OS),
keeps the CPU running for a warm return, and copies shared cartridge save RAM
into the OS mapping when the cart button is pressed.

Hardware previously confirmed the sprite menu, Resume, and the reset-based
return. The revised editor-style menu and warm return still need hardware testing:
copy `bin/GBCOS.BIN` to `/GBCSYS/GBCOS.BIN`, resume a game, then return to the
file browser and launch another game. `EDITOR.DAT` is unchanged by this menu.

Emulator validation covers DMG and CGB MBC5 games, three repeated menu/resume
cycles, byte-for-byte restoration of both VRAM banks, palettes, OAM and display
registers, stack headroom, continued VBlank interrupts and ROM-bank restoration.
The warm-return check observes the direct jump to Main without a reset request,
checks repaired resident bytes and unchanged hardware mode, and confirms the
file browser renders. Shared game save RAM and launching another game after
warm return (including its menu and Resume) are also checked. Selection
pixels, one-pixel borders, filename-bar encoding and the real file-browser
launch path are checked with the revised layout.
