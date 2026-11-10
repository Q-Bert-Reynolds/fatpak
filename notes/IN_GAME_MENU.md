# In-game cart-button menu

[README](../README.md) · [Architecture](ARCHITECTURE.md) · [EverDrive compatibility](EVERDRIVE_FEATURES.md)

`make assemble` produces `bin/GBCOS.BIN`. When
`/media/qbertreynolds/GAMEBOY` is mounted, the normal build copies the image to
`GBCSYS/GBCOS.BIN` and flushes the write. There is one build/menu implementation.

The cart button opens Resume game, Save state, Load state, and Return to OS.
Up/down/select moves the highlight, A/Start chooses, and B resumes. Saving or
loading a state resumes automatically on success. An unavailable state, unsupported
RAM size, invalid image, or SD error leaves the menu open with an error footer;
B still resumes the suspended game. File operations can take several seconds.

The menu uses the editor's VWF, one-pixel border, highlighted selection, filename
header, and controls footer. `ingame_menu.py` composes its static pixels. The
filename is rendered before launch into PSRAM block `$3e3f`, offset `$20`.
The full-screen menu hides the game picture, sprites, and window.

## Capture and restore

Entry follows stock GBCOS v1.06: push AF/BC/DE/HL on the game's stack, unlock
immediately, write `$04` to `$BD06`, save SP, and switch to a resident stack before
reading the mapper registers at `$BD14-$BD17`. The normal VBlank vector is
installed at startup; launch replaces it with the in-game entry vector.

[`src/game/snapshot.asm`](../src/game/snapshot.asm) captures the stock 82 KiB layout:

| PSRAM block | Contents |
| --- | --- |
| `$3e40` | `SAVE`, SP, four mapper bytes |
| `$3e41-$3e50` | VRAM bank 0 |
| `$3e51-$3e60` | WRAM `$c000-$dfff`, bank 1 selected |
| `$3e61` | OAM, IO, HRAM, IE (`$fe00-$ffff`) |
| `$3e62-$3ea1` | Cartridge RAM, 8 or 32 KiB |
| `$3ea2` | CGB BG/object palette RAM |
| `$3ea3-$3eb2` | VRAM bank 1 |
| `$3eb3-$3ee2` | CGB WRAM banks 2-7 |
| `$3ee3` | Reserved |

The optional bytes `GB,1,model` at header offsets 10-13 let FatPak reject
its own states made in a different hardware mode. Stock ignores these bytes;
FatPak also accepts stock images without this extension.

After capture, the menu clears WRAM/HRAM, initializes the OS service context,
and uses the normal OS stack for SD access. Restore uses the resident stack,
restores memory/palettes, readable IO registers, original bank selectors and
CPU speed, then hands back the pending VBlank through `$0040`. Write-only audio
frequency registers follow the stock restore policy. This is a cartridge
snapshot, not a cycle-exact emulator save state; RTC time isn't rolled back.

The context and nine-byte stack occupy `$0009-$001f`. Capture uses at most eight
stack bytes; the first is a guard. Link assertions protect the gap and keep the
resident resume code below the addresses changed by mapper writes.

## Files and battery-backed state slot

States use `/GBCSYS/SNAP/<game basename>.sav`, exactly 83,968 bytes. The matching
battery-backed slot occupies save-RAM sectors `$0040-$00e3`, as in stock OS.
Launch loads the game's state file into that slot; boot backs up a valid slot
under the registry's game name. Saving from the menu also writes the file
immediately. Snapshot writes use `.tmp` and retain the previous file as `.bak`.

Loading reads and validates the entire file in PSRAM `$3c00-$3ca3` before replacing
the suspended image. This staging space limits ROM loading to 7.5 MiB. The stock
state format holds at most 32 KiB of cartridge RAM; FatPak rejects states for
larger RAM configurations. Normal battery saves can still use 128 KiB.

Per-game snapshot path and RAM-size metadata live in PSRAM `$3e2f`. These blocks,
the filename bitmap, and the snapshot workspace are outside the loaded ROM.

## Warm return

Return to OS stops interrupts, timer, serial, sound and HBlank DMA, repairs the
six resident bytes changed by mapper writes, selects OS mapping, and jumps to
`WarmMain`. This uses the normal startup path to reset cart-switch state,
reinstate the VBlank vector, back up saves, and open the browser, but skips
`CartConfigureFeatures`: the live FPGA feature mask and mapper RTC controls were
already configured at cold boot. It doesn't request a boot-ROM reset.
A DMG game leaves the OS in DMG mode even on CGB/GBA hardware.

The in-game menu draws with CPU copies. After warm return, the editor also
keeps `render_cpu_copy` enabled, using the launcher's CPU-copy fallback while
retaining CGB palettes and layout. Renderer readiness checks use HDMA5 bit 7:
a cancelled transfer is idle even when its remaining count makes the register
read `$80-$FE` instead of `$FF`. Waiting for exactly `$FF` could otherwise hang
startup after cancelling a game's HBlank DMA.

Gearboy shares cartridge save RAM across its OS/game mappings and applies the
restored mapper bytes when resuming. Its calendar RTC uses host local time and
supports setting an offset through the same I2C interface as the cartridge.

## Validation

`bash tests/run_ingame_return.sh` uses an already-built sibling Gearboy desktop
core to exercise Resume, Save state, repeated warm returns, browser startup,
input and battery-save backup for DMG and CGB games. It checks that Return to
OS reaches `WarmMain` directly, skips factory feature configuration, and never
requests the cartridge reboot. All SD files live in temporary folders.
The test injects cancelled HDMA counts, checks that active DMA still blocks
VRAM access, and verifies that warm OS rendering never starts HDMA again.

[`Gearboy/tests/fatpak_features_tests.cpp`](../../Gearboy/tests/fatpak_features_tests.cpp) runs the assembled routines against
an isolated temporary SD folder. It covers DMG/CGB capture, stock state layout,
save/load with changed game memory, all CGB WRAM banks, shared SRAM, mapper
restore, malformed/missing states, Game Genie compare bytes, stock registry
ownership, clock setup, FAT timestamps and clockless operation. Legacy GAM2 migration and 128 KiB SRAM backup are covered too. Previous
menu regression checks also exercised repeated Resume and warm return to the browser.
From the FatPak root, run `make -C ../Gearboy/tests fatpak`; these checks
use temporary SD folders. Save states have also been tested successfully on
hardware. RTC corrections still need hardware verification; see
[TODO](TODO.md#priority).
