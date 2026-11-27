# Keyboard and mouse drivers

SETTINGS > KEYBOARD is available in both the editor and browser. Select
NONE, PS/2 KEYBOARD or iGKB USB; on an SGB, PS/2 KEYBOARD is the SGB's driver (PS/2 and the SNES mouse, below). TEST opens the packet diagnostic screen. The single iGKB option represents the adapter;
mouse packet decoding awaits hardware capture. A saved mouse-only selection (3)
loads this same driver. The selection takes effect immediately and is stored with the settings (SET6, with SET2–SET5 migration).
Small documents also save the setting to EDITOR.SWP before the menu returns.
A large document keeps it in PSRAM, like the existing theme setting.

PS/2 is the default, built into the OS. Switching back to it after another
driver loads PS2.DRV. TEST keeps the selected driver and shows its
received bytes; it does not force PS/2 mode.

In Gearboy, select Input > PS/2 Keyboard or iGKB USB Keyboard / Mouse.
These devices are mutually exclusive and yield the serial port to a connected link cable. Caps Lock routes host keyboard
keys into the selected keyboard, as for the existing PS/2 support. Mouse
movement and left/right buttons are sent only over the displayed viewport;
leaving it releases held buttons. Movement is scaled to emulated pixels,
including SGB output, and pending hover motion is coalesced.

The SNES mouse and retained experimental mouse path use tile 26 of `img/ui_font.png` for its mouse pointer, separate from
both the insertion cursor and the on-screen keyboard. It appears on the first
complete mouse report and hides after two seconds without input. Its tile is
copied into the unused VRAM bank-0 tile 122, outside the text renderer's blocks.

One left click in the browser selects a row; a second left click on that row
within 400 ms opens its file or folder. Right click selects the row and opens
the menu. Hovering alone leaves the browser selection unchanged. In the editor,
left click positions the cursor, dragging selects text from that click, and
right click opens the menu. Menu hover highlights an item, left click performs
it, and clicking outside closes the menu. Title lines are excluded from menu
hit testing. Navigation waits for each queued event to be consumed before
confirming an action, including clicks several rows from the current selection.
Mouse reports are processed in bursts of three bytes so a complete report can
be handled in one frame.

## Wire formats

The keyboard follows the manufacturer's v1.0 CH559 firmware: HID usage + 93,
or + 61 with Shift. Letters therefore arrive as ASCII; digits, punctuation,
function and navigation keys are mapped separately. That firmware loses modifier
information and produces ambiguous bytes for some shifted non-letter keys;
the emulator preserves that encoding rather than inventing a different wire
format. PS/2 remains the option for complete modifier shortcuts.

Reference: [insideGadgets keyboard firmware and demo](https://insidegadgets.com/files/insideGadgets_USB_Keyboard_v1.0.zip),
`CH559sdccUSBHost-master/uart.c`, `sendHidPollMSG`.

The experimental mouse protocol follows [bbbbbr's modified mouse firmware/example](https://github.com/bbbbbr/gameboy-usb-mouse).
A report is three nonzero bytes:

| Byte | Meaning |
| --- | --- |
| 0 | $40, buttons in bits 0–2, positive X/Y in bits 4/5 |
| 1 | $80 plus absolute X movement (0–127) |
| 2 | $80 plus absolute Y movement (0–127) |

Zero is idle; $FF is valid movement magnitude 127. A new header restarts an
incomplete packet. Physical mouse use needs the modified firmware; it handles keyboard and mouse
USB device types together.

The actual hardware's combined keyboard/mouse wire format is still being
investigated. The unified option retains the established keyboard decoder;
automatic mouse decoding is deferred until raw hardware captures establish
its framing. The older experimental three-byte mouse decoder remains available
internally as legacy type 3, but is not a separate menu option. Gearboy can queue
both keyboard bytes and the experimental mouse reports into one adapter for
capture tests; that does not establish the physical adapter's mouse protocol.

TEST shows the most recent 44 nonzero iGKB serial bytes, four per row,
with their ring indices. These are raw display groups, not asserted packet
boundaries. `$FF` is retained. A pauses/resumes the display while reception
continues; B or Start returns. PS/2 keeps its bit/error view. The test module
never changes the selected driver.

## Driver slot and packaging

The keyboard page (15) has a $8C0-byte slot at $A000 (`KB_DRIVER_SIZE`, sized for the SGB's driver: PS/2 and
the SNES mouse), with stable init and process jumps, installed in 512-byte blocks. Only one driver payload occupies that slot. Common host setup,
copying and settings code stays outside it. Wide assembler modules can still
borrow page 15 and restore the selected payload afterwards.

`make assemble` builds `/GBCSYS/DRIVERS/{PS2,IGKB,SGBMOUSE}.DRV` along with the OS,
KEYTEST.MOD, EDITOR.DAT and language files. Install them together. Each driver
has a 512-byte FPKD header followed by the slot payload. The header carries its
format version, driver kind, shared-state/init addresses, payload CRC-16/CCITT,
length and the OS ROM's global checksum. KEYTEST.MOD validates the complete
staged image before stopping or replacing the current driver. The final copy
is 336 bytes, so it cannot overwrite the host code after the slot.

Module ABI 11 adds ModDriver: commands 0–2 copy staging-window chunks; $40/$41
query the shared-state/init addresses; $42 sends a staging-window SGB packet; $43 returns the system-info address; $80–$84 initialize without saving;
$C0–$C4 commit and save the selected device. Calls switch pages through resident
code. PS/2's bit-level interrupt remains resident; USB devices use the GB's
internal serial clock and are polled by the loaded driver.

`tests/run_igkb.sh` exercises menus, typing, raw capture, pause/resume, driver
swaps, cold-boot persistence and corrupt/foreign driver rejection on DMG and
CGB. It also retains the earlier mouse UI tests using explicit legacy type 3;
those tests do not validate the hardware's mouse wire format. Use
`tests/run_igkb.sh mouse` for the mouse UI and raw capture checks only.
Gearboy's `make -C tests igkb` checks queue behavior and keyboard encoding.

## SNES mouse (Super Game Boy)

Connect a gamepad to SNES port 1 and the mouse to port 2. On an SGB the PS/2 choice (the default) loads
SGBMOUSE.DRV, the SGB's driver (type 4): the PS/2 keyboard and the SNES mouse together (in fullscreen the SNES
kernel reads the mouse and the driver takes its events, notes/SGB.md "SNES mouse in fullscreen"; at 160x144 the
BIOS bridge below). Boot loads it after the fullscreen takeover, so a fullscreen boot uploads no bridge; without
the file the built-in PS/2 driver stays. Elsewhere a saved type 4 loads PS/2. The gamepad continues working.
TEST shows the keyboard's bytes (the mouse's reports aren't kept). At 160x144 coordinates cover the GB
viewport (160 by 144 pixels).
The pointer remains hidden until motion or a button transition, then uses the
same browser/editor/menu handlers and two-second timeout as the experimental
mouse path. In the editor a click places the cursor, a drag selects, and Shift + a
click (or drag) selects from the cursor (the editor keeps the anchor at the cursor
while nothing is selected). Browser clicks select the target row directly; double-click and
right-click actions wait for that selection to be drawn.

While the pointer shows, the editor, the browser and HEXVIEW show a scroll bar at 160x144 (all models; not
the SGB's fullscreen modes), unless everything is on screen: a 4 pixel track over the text rows' right edge
and a thumb (the font's tile 10, a sprite). The window draws the track: on every line then, at the screen's
left on the bars and at the track (WX 163) on the text rows, so its rows are the screen's
(`src/ui/scrollbar.asm`; the bars' window rows are packed otherwise). A press from the thumb's left edge
(x 154) rightwards on the text rows grabs the thumb, there or by its middle elsewhere on the track; the
driver's reports are then the bar's (`ScrollBarHit`, called first in `IGKBMouseAction`) until the button is
let go, and only the thumb moves meanwhile. Letting go queues `KEY_SCROLL` and the view redraws once from
there: the editor's top row and cursor at that place (a large document's window moves around it, the
bottom is Ctrl+End), the browser's list with the selection on the same screen row, HEXVIEW's rows. Views
claim the bar every frame they wait for keys (`ScrollBar`, `ModScrollBar`), so menus, dialogs and other
screens hide it.

`src/sgb/mouse.s` is assembled with cc65's ca65/ld65. SGBMOUSE.DRV includes
both the GB driver and CRC-covered DATA_SND packets uploading the SNES code to
$001800. The BIOS's $0800 command hook installs a private NMI handler and
restores the hook's RTS. MASK_EN freezes the SGB picture for the bulk upload
and releases it after installation. During uploads, acknowledgements and
mailbox reads, the GB keeps its LCD STAT raster interrupts enabled while
masking VBlank, whose controller polling would otherwise interfere with P1.
The normal BIOS H/V IRQ display path remains active.
The handler waits for automatic controller polling, checks the port-2 mouse
signature and clocks the remaining 16 motion bits. It clamps the coordinates
and publishes them through ICD2 controller bytes 2–4, leaving controller 1 to
the BIOS. The GB checks a commit byte before and after each read, rejects a
busy/inconsistent snapshot, and restores player 1 before returning.

Commit bit 0 means mouse present, bits 1/2 are left/right, bits 3–6 are an
activity counter, and bit 7 marks an update in progress. The SNES side queues motion and button transitions; the counter advances
when it publishes the next report. The GB acknowledges each accepted report
with a short DATA_SND write to $001FF0. Reports therefore survive a busy GB
without repeating clicks or refreshing the pointer timeout on idle polls.
The 63-report FIFO coalesces motion within the same button state; if completely
full, it retains earlier edges and replaces its final report with the newest
state so a release is not lost during a long build. Switching drivers, rebooting, resetting the device
or launching a game disables the extra NMI and restores the BIOS vector and
single-controller mode. Failed game loads leave the bridge running. The stop only goes out
while a bridge runs (`SYS_INFO_BRIDGE`, sys_info bit 3: set after the upload, cleared by the stop):
it jumps into the bridge's code, which isn't there after fullscreen's JUMP or EXIT. Leaving fullscreen
for 160x144 loads the driver and its bridge again; for a game it doesn't. The ACK waits 2 frames after
an SGB attribute packet (`SGBPacketAck`, [SGB.md](SGB.md#colours-at-160x144-2026-11-26)): the BIOS takes a
packet a frame, and a lost ACK would stop the reports.

`tests/run_snes_mouse.sh` runs a plain GB harness against the actual SGB1 BIOS
and SNES mouse emulation in Mesen. It exercises the production uploader and P1
reader with LCD interrupts active, signed motion, buttons, clamping, pad 1,
queued clicks while the GB is busy, and uninstall. It requires
`make assemble`, cc65, RGBDS, .NET and the sibling MesenCE build. Override
MESEN_DLL, SGB_BIOS and SGB_BOOT for other locations; defaults use the files in
Downloads. Firmware is copied only to a temporary test directory. The harness
is also built as `build/snes_mouse.gb`.

Gearboy's UI regression injects the three mailbox bytes into its controller
ports because that emulator has no SNES CPU; it checks the actual loaded GB
driver and FatPak UI separately, including the upload freeze, continued LCD
raster updates, and direct browser selection. It does not execute the SNES bridge. The real
BIOS test currently covers the supplied SGB1 ROM; physical SGB and SGB2 testing
remain necessary.
