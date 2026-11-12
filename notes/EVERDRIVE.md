# EverDrive compatibility

[Architecture](ARCHITECTURE.md) · [In-game menu](GAME_MENU.md) · [TODO](../TODO.md)

FatPak uses stock GBCOS v1.06 file names and formats, keyed by the ROM's
basename (same-named games in different folders share files, as in stock).

| File | Contents |
| --- | --- |
| `/GBCSYS/SAVE/<name>.srm` | Battery RAM at its real size (MBC2 512 B; 2-128 KiB) |
| `/GBCSYS/SAVE/<name>.rtc` | MBC3 RTC: 512 B, five game registers, five reference registers, zero padding |
| `/GBCSYS/SNAP/<name>.sav` | Save state, see [GAME_MENU.md](GAME_MENU.md) |
| `/GBCSYS/CHEATS/<name>.txt` | Game Genie codes |
| `/GBCSYS/REGISTRY.BIN` | Stock current-game record and options |
| `/GBCSYS/EDITOR.GAM` | FatPak ownership record (GAM3; GAM1/GAM2 still read) |

## PSRAM window

`$BD03:$BD02` select the 512-byte block shown at `$BE00`. Write the high byte
first, then the low byte, as the stock OS does (`CopyDEtoBD02`): its
`IncrementBD02` writes only `$BD02`, so the low-byte write is what switches the
window, and a `$BD03` write appears to wait for it. With the low byte first
(FatPak until 2026-11-12) every switch that changed the high byte read or wrote
the old high byte's block first. That corrupted module backups, staging and the
assembler's PSRAM at random: MODULE LOAD FAILED, RESTORE FAILED, wrong assembler
errors, freezes and garbled header/footer on DMG and GBA SP, made more or less
likely by any code-layout change. Gearboy applied each byte at once, so it never
failed. `GEARBOY_EVERDRIVE_LATCH_BD03=1` (Gearboy, set by every `tests/run_*.sh`)
holds a `$BD03` write until the next `$BD02` write; with it the old order froze
the module tests at once. Writing only `$BD02` to step within a high byte is fine.

## Registry and ownership

Launch updates stock `REGISTRY.BIN` (game metadata, directory entry, valid flag,
additive checksum, options preserved) so both OSes agree on who owns cartridge
RAM. FatPak invalidates the stock SRAM marker before preparing a game and
publishes it only after the registry and GAM3 record are written. Backup checks
that marker before saving SRAM, RTC and the state slot, imports a valid stock
registry when the FatPak cookie is missing or superseded, and skips unknown
ownership rather than guessing. Legacy GAM1/GAM2 records back up SRAM but can't
claim the state slot those builds never initialized.

## Clock and RTC

SETTINGS > CLOCK sets the calendar (Up/Down field, Left/Right adjust, A save,
B cancel). FatFs timestamps use it; without a valid clock files get 2026-01-01.
Calendar reads poll completion and ignore slave ACK during reception, like stock
`I2C_ReadBytes`.

MBC3 carts (`$0f/$10`) load `.rtc`, advance the game clock by elapsed calendar
time (ninth day bit, halt and carry included); boot backs it up from the
interleaved save-RAM shadow of `$BD10-$BD13`. A
missing file starts at zero with the current reference. Without a calendar,
registers are kept but don't advance. The reference wraps every 512 days, as in
stock.

Programming follows stock's pre-launch `$629f`: halt both counters at index 4,
write the five paired fields, write 1 to `$BD10` at index 6, leave `$BD13` at 0.
Gearboy doesn't model that control register, so tests compare bus writes against
the stock sequence.

Cold boot reads the model byte at EEPROM `$A0:$3f18` and writes stock's feature
mask to `$BD0F` (X3 `$01`, X5 `$00`, X7 `$06`; bit 1 = RTC, bit 2 = snapshots),
then clears the X7 mapper RTC control at index 6 like `CheckAndInitializeRTC`.
Unknown models or read errors keep the bootloader's mask. Gearboy records the
mask and supplies an X7 model, but doesn't emulate the bits' effects.

## Game launch

Like stock `Cart_LaunchGame`: write launch config `$08` (keeping option bit 5),
initialize mapper latches, select normal speed (CGB only: `gbdk_CPUSlow` checks
`sys_info`, because a DMG reads `KEY1` as `$FF` and its `STOP` would freeze the
launch at "Preparing game..."), leave IE off, enable audio,
write `$BD07`, then spin in resident cartridge code. The reset/boot path supplies
the game's registers; there's no timeout or jump to `$0100`.

### ROM transfer lessons

Crystal froze on hardware with an earlier streaming loader: correct boot
registers, but 14 of 128 banks corrupted in PSRAM. Busy-polled reads and a
plain-screen streaming loader both worked. What the working path does, and must
keep doing:

- `sd_ReadBlocks` finishes pending HDMA first and allows only the resident LCD
  interrupt (no VBlank/OAM DMA, input or sprites), restoring IE/IF on every exit.
- The inner loop is stock's eight-write loop, run from ROM0.
- CPU speed is left as the caller set it: CGB stays in double speed through the
  transfer and preparation. *Not yet confirmed on hardware with Crystal.*
- Command/token failures report a disk error; there's no silent slow retry.
- A 32-byte header comparison runs after the transfer (header only, not the
  whole ROM).

The loading screen keeps the browser and its box in VRAM. `render_cpu_copy`
switches CGB to the DMG CPU-copy loop without touching `render_gbc`, so the CGB
layout, banks and attributes survive. The box is sized for four-digit KB counts
and updated in place after each chunk, then reads "Preparing game..." while
saves, state and registry are prepared. On failure, `GameLoadingEnd` restores
sprites, interrupts and normal uploads; no rebuild is needed.

Pitfalls found on the way:

- Masking IE for a whole 128 KiB transfer kills the raster handler's
  window/tile switches, garbling the screen.
- Switching CPU speed between chunks with the LCD on caused artifacts.
- Enabling interrupts between a STAT wait and the copy lets a handler return
  into mode 3, dropping VRAM writes. Each STAT poll plus two-byte copy is now
  atomic. Gearboy allows VRAM access in every mode, so tests check the PPU mode
  at each store.

`tests/run_loading.sh` covers command delays, bad tokens, changed headers,
pending HDMA, both CGB speeds and DMG, CPU-copied pixels versus the normal
renderer, failure cleanup and copy-routine chunk boundaries; browser tests load
all of Crystal and reach its title.

Gearboy trace, 1 MiB CGB game with 32 KiB RAM and an existing state: select to
`GameLaunch` went from 9.51 s to 4.80 s (preparation 5.12 s → 2.37 s) with the
current loader. Hardware SD latency differs.

## Cheats

Stock Game Genie ROM patches, applied at launch when the registry's Cheats
option is on (default). Up to sixteen `XXX-XXX-XXX` lines in hex (any case,
LF or CRLF); `XXX-XXX-XXX` is an empty slot and `ABC-DEF-XXX` has no compare
byte. Compare codes scan every physical bank including 0; others patch the first
bank only. The in-bank offset ignores address bit 14. GameShark RAM codes aren't
supported. Changes apply on next launch.
