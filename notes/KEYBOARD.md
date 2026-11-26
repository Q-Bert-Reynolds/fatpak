# Keyboard and mouse drivers

SETTINGS > KEYBOARD is available in both the editor and browser. Select
NONE, PS/2 KEYBOARD or iGKB USB; SGB also offers SNES MOUSE. TEST opens the packet diagnostic screen. The single iGKB option represents the adapter;
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

The keyboard page (15) has a $570-byte slot at $A000, with stable init and
process jumps. Only one driver payload occupies that slot. Common host setup,
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

Connect a gamepad to SNES port 1 and the mouse to port 2. On SGB, select
SETTINGS > KEYBOARD > SNES MOUSE (in fullscreen too: there the SNES kernel reads the mouse and the
driver takes its events, notes/SGB.md "SNES mouse in fullscreen"). This occupies the input-driver slot, so it
replaces the selected serial keyboard driver; the gamepad continues working.
The selection persists across boots. TEST shows four-byte reports: zero,
commit/buttons, X, Y. Coordinates cover the GB viewport (160 by 144 pixels).
The pointer remains hidden until motion or a button transition, then uses the
same browser/editor/menu handlers and two-second timeout as the experimental
mouse path. Browser clicks select the target row directly; double-click and
right-click actions wait for that selection to be drawn.

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
single-controller mode. Failed game loads leave the bridge running.

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
