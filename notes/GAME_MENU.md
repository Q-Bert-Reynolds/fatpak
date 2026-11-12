# In-game cart-button menu

[Architecture](ARCHITECTURE.md) · [EverDrive compatibility](EVERDRIVE.md) · [TODO](../TODO.md)

The cart button opens Resume game, Save state, Load state and Return to OS.
Up/Down/Select move, A/Start choose, B resumes. A successful save or load
resumes; errors (no state, unsupported RAM size, invalid image, SD error) stay in
the menu with a footer message.

The menu is full screen (game picture, sprites and window hidden), drawn with
CPU copies in the editor's VWF: filename header, border, highlight and a controls
footer with the clock. `ingame_menu.py` builds the static pixels. The filename
header is pre-rendered at launch into PSRAM `$3e3f`, offset `$20`.

## Capture and restore

Entry at `$0670` follows stock GBCOS v1.06: push AF/BC/DE/HL on the game's stack,
unlock, write `$04` to `$BD06`, save SP, switch to the resident stack, then read
the mapper registers at `$BD14-$BD17`. Launch installs this entry vector.

[`snapshot.asm`](../src/game/snapshot.asm) writes the stock 82 KiB layout:

| PSRAM block | Contents |
| --- | --- |
| `$3e40` | `SAVE`, SP, four mapper bytes, optional `GB,1,model` at offsets 10-13 |
| `$3e41-$3e50` | VRAM bank 0 |
| `$3e51-$3e60` | WRAM `$c000-$dfff` (bank 1 selected) |
| `$3e61` | OAM, IO, HRAM, IE (`$fe00-$ffff`) |
| `$3e62-$3ea1` | Cartridge RAM, 8 or 32 KiB |
| `$3ea2` | CGB BG/OBJ palettes |
| `$3ea3-$3eb2` | VRAM bank 1 |
| `$3eb3-$3ee2` | CGB WRAM banks 2-7 |
| `$3ee3` | Reserved |

The `GB,1,model` extension lets FatPak reject its own states from a different
hardware mode; stock ignores it, and stock images without it are accepted.

The context and nine-byte resident stack live at `$0009-$001f` (capture uses at
most eight bytes; the first is a guard). Link assertions protect the gap and keep
resume code below the bytes mapper writes clobber. After capture the menu clears
WRAM/HRAM and uses the normal OS stack and far calls for SD access.

Restore uses the resident stack, restores memory, palettes, readable IO, bank
selectors and CPU speed, then delivers the pending VBlank through `$0040`.
Write-only audio registers follow stock policy. It's a cartridge snapshot, not a
cycle-exact save state; RTC time isn't rolled back.

## Files

States are `/GBCSYS/SNAP/<basename>.sav` (83,968 bytes), mirrored in the stock
battery-backed slot at save-RAM sectors `$0040-$00e3`. Launch loads the file into
the slot; boot backs up a valid slot under the registry's game name; menu Save
also writes the file immediately, via `.tmp` with the previous file kept as `.bak`.

Load stages and validates the whole file at PSRAM `$3c00-$3ca3` before replacing
the suspended image (hence the 7.5 MiB ROM limit). The stock format holds at most
32 KiB of cartridge RAM; larger configurations are rejected. Per-game path and
RAM-size metadata live at `$3e2f`.

## Warm return

Return to OS stops interrupts, timer, serial, sound and HDMA, repairs the six
resident bytes changed by mapper writes, selects OS mapping and jumps to
`WarmMain`. That runs normal startup (cart-switch reset, VBlank vector, save
backup, browser) but skips `CartConfigureFeatures`, preserving the live FPGA mask
and mapper RTC controls, and never requests a boot-ROM reset. A DMG game leaves
the OS in DMG mode even on CGB/GBA.

After warm return the renderer keeps `render_cpu_copy` on (CPU copies, CGB
layout and palettes kept). Readiness checks test HDMA5 bit 7 only: a cancelled
transfer reads `$80-$FE`, so waiting for `$FF` would hang.

## Clock

`src/ui/footer.c` caches the calendar time, polled about once a second from frame
waits. Normal footers right-align it in the VWF; the cart menu polls from
`MenuPad` and rewrites only the six rightmost footer tiles. No valid RTC shows
`--:--`.

## Testing

`bash tests/run_ingame_return.sh` (sibling Gearboy core, temporary SD folders)
covers Resume, Save state, repeated warm returns, browser startup, input and
save backup on DMG and CGB. It checks that Return reaches `WarmMain` without
factory configuration or a reboot request, that cancelled HDMA counts don't block
rendering, active DMA still blocks VRAM, and warm rendering never restarts HDMA.
`bash tests/run_footer_clock.sh` covers 12-hour formatting, the clockless
fallback, spacing, idle refresh and rendered pixels.

Gearboy shares save RAM across OS/game mappings, applies restored mapper bytes on
resume, and backs the calendar with host time plus an offset set over I2C.
