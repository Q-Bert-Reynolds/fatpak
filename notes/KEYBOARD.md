# Keyboard and mouse drivers

SETTINGS > KEYBOARD is available in both the editor and browser. Select
NONE, PS/2 KEYBOARD or iGKB USB; TEST opens the packet diagnostic screen. The single iGKB option represents the adapter;
mouse packet decoding awaits hardware capture. A saved mouse-only selection (3)
loads this same driver. The selection takes effect immediately and is stored with the settings (SET5, with SET2–SET4 migration).
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

The retained experimental mouse path uses tile 26 of `img/ui_font.png` for its mouse pointer, separate from
both the insertion cursor and the on-screen keyboard. It appears on the first
complete mouse report and hides after two seconds without input. Its tile is
copied into the unused VRAM bank-0 tile 122, outside the text renderer's blocks.

In that path, one left click in the browser selects a row; a second left click on that row
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

The keyboard page (15) has a $580-byte slot at $A000, with stable init and
process jumps. Only one driver payload occupies that slot. Common host setup,
copying and settings code stays outside it. Wide assembler modules can still
borrow page 15 and restore the selected payload afterwards.

`make assemble` builds `/GBCSYS/DRIVERS/{PS2,IGKB}.DRV` along with the OS,
KEYTEST.MOD, EDITOR.DAT and language files. Install them together. Each driver
has a 512-byte FPKD header followed by the slot payload. The header carries its
format version, driver kind, shared-state/init addresses, payload CRC-16/CCITT,
length and the OS ROM's global checksum. KEYTEST.MOD validates the complete
staged image before stopping or replacing the current driver. The final copy
is 384 bytes, so it cannot overwrite the host code after the slot.

Module ABI 11 adds ModDriver: commands 0–2 copy staging-window chunks; $40/$41
query the shared-state/init addresses; $80–$83 initialize without saving;
$C0–$C3 commit and save the selected device. Calls switch pages through resident
code. PS/2's bit-level interrupt remains resident; USB devices use the GB's
internal serial clock and are polled by the loaded driver.

`tests/run_igkb.sh` exercises menus, typing, raw capture, pause/resume, driver
swaps, cold-boot persistence and corrupt/foreign driver rejection on DMG and
CGB. It also retains the earlier mouse UI tests using explicit legacy type 3;
those tests do not validate the hardware's mouse wire format. Use
`tests/run_igkb.sh mouse` for the mouse UI and raw capture checks only.
Gearboy's `make -C tests igkb` checks queue behavior and keyboard encoding.
