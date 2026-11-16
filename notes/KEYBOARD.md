# Keyboard and mouse drivers

SETTINGS > KEYBOARD / MOUSE is available in both the editor and browser. Select
NONE, PS/2 KEYBOARD, iGKB KEYBOARD or iGKB MOUSE. The selection takes effect
immediately and is stored with the settings (SET5, with SET2–SET4 migration).
Small documents also save the setting to EDITOR.SWP before the menu returns.
A large document keeps it in PSRAM, like the existing theme setting.

PS/2 is the default, built into the OS. Switching back to it after another
driver loads PS2.DRV. KEYBOARD TEST keeps the selected driver and shows its
received bytes; it does not force PS/2 mode.

In Gearboy, select the matching device in Input: PS/2 Keyboard, iGKB USB
Keyboard, or iGKB USB Mouse. These devices are mutually exclusive and yield
the serial port to a connected link cable. Caps Lock routes host keyboard
keys into the selected keyboard, as for the existing PS/2 support. Mouse
movement and left/right buttons are sent only over the displayed viewport;
leaving it releases held buttons. Movement is scaled to emulated pixels,
including SGB output, and pending hover motion is coalesced.

FatPak shows an I-beam mouse pointer, separate from the insertion cursor and
the on-screen keyboard. Left click places the text cursor; dragging selects
text. Mouse hover navigates menu and browser rows, left click confirms, and
right click opens or closes the application menu. Mouse reports are processed
in bursts of three bytes so a complete report can be handled in one frame.

## Wire formats

The keyboard follows the manufacturer's v1.0 CH559 firmware: HID usage + 93,
or + 61 with Shift. Letters therefore arrive as ASCII; digits, punctuation,
function and navigation keys are mapped separately. That firmware loses modifier
information and produces ambiguous bytes for some shifted non-letter keys;
the emulator preserves that encoding rather than inventing a different wire
format. PS/2 remains the option for complete modifier shortcuts.

Reference: [insideGadgets keyboard firmware and demo](https://insidegadgets.com/files/insideGadgets_USB_Keyboard_v1.0.zip),
`CH559sdccUSBHost-master/uart.c`, `sendHidPollMSG`.

Mouse mode follows [bbbbbr's modified mouse firmware/example](https://github.com/bbbbbr/gameboy-usb-mouse).
A report is three nonzero bytes:

| Byte | Meaning |
| --- | --- |
| 0 | $40, buttons in bits 0–2, positive X/Y in bits 4/5 |
| 1 | $80 plus absolute X movement (0–127) |
| 2 | $80 plus absolute Y movement (0–127) |

Zero is idle; $FF is valid movement magnitude 127. A new header restarts an
incomplete packet. The original keyboard firmware does not support mice;
physical mouse use needs the modified firmware.

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

`tests/run_igkb.sh` exercises real menus and serial transfers on DMG and CGB:
typing, drag selection, button releases, large movement bytes, driver swaps,
cold-boot persistence and rejection of corrupt or foreign-build drivers.
Gearboy's `make -C tests igkb` checks the wire encoding and queue behavior.
