# EverDrive compatibility

[README](../README.md) · [Architecture](ARCHITECTURE.md) · [TODO](TODO.md)

Girlboss uses the stock GBCOS v1.06 file names and formats. Files are keyed by
the ROM's basename, so identically named games in different folders share saves,
just as they do in stock OS.

## Clock

SETTINGS > CLOCK edits year, month, day, hour, minute, and second. Up/down selects
a field, left/right adjusts it, A saves, and B cancels. Invalid dates and missing
clock hardware are reported. FatFs uses the real calendar for timestamps; carts
without a valid clock retain the 2026-01-01 fallback date.

MBC3 RTC cartridges (`$0f/$10`) load and back up
`/GBCSYS/SAVE/<basename>.rtc`. The stock 512-byte image contains five game RTC
registers followed by five wall-clock reference registers, with zero padding.
Elapsed calendar time advances the game clock before launch, including the
ninth day bit, halt flag and day-overflow flag. A missing file starts the game
clock at zero with the current reference time. With no calendar device, stored
registers are retained without offline advancement. Like stock, the reference
counter wraps every 512 days.

RTC programming follows stock GBCOS's pre-launch `$629f` routine: halt both
counters through index 4, write the five paired fields, write 1 to `$BD10` at
index 6, then leave `$BD13` at 0. The former restore-file sequence ended with
index 6 set to 0 instead. Gearboy does not model that control register's effect,
so integration tests observe the actual firmware bus writes against the stock
sequence rather than treating an emulator launch as hardware proof.

Startup also reads the factory model byte at EEPROM `$A0:$3f18` and writes the
stock cartridge-feature mask to `$BD0F`: X3 = `$01`, X5 = `$00`, X7 = `$06`.
Stock derives bit 1 from RTC capability and bit 2 from snapshot capability.
On X7, the mapper RTC control at index 6 is cleared before normal calendar use,
matching stock `CheckAndInitializeRTC`. Unknown models or failed EEPROM reads
preserve the bootloader's feature configuration. Girlboss previously omitted
this setup, and Gearboy silently ignored `$BD0F` writes. Gearboy now records the
mask and supplies an X7 factory model for startup regression tests; the full
hardware effects of all feature bits are not emulated.

The clock-menu garbage was caused by 40-byte row spacing where menu boxes use
20-byte rows, plus page-local field-name pointers passed to a text routine on
another page. Fields now use packed box rows and resident strings. Calendar
reads poll completion without checking the slave ACK bit during reception,
matching stock `I2C_ReadBytes`. Clock setting is hardware-confirmed. The same
Crystal ROM boots with stock GBCOS on the GBA SP but remained white with Girlboss,
including after factory-feature initialization and without save/RTC files.
Red, Blue, Gold and Silver launch, so RTC alone does not explain the failure.
Emulator checks cover the complete browser launch, all loaded ROM bytes, the
title screen, and RTC/SRAM file round trips.

## Game launch and device identification

Stock `Cart_LaunchGame` writes launch config `$08` (preserving option bit 5),
initializes the mapper latches, writes the mapper to `$BD07`, then waits forever
in resident cartridge code. It does not set the game's initial CPU registers;
the reset/boot path is responsible for them. Before this handoff, stock selects
normal CPU speed, leaves IE disabled and explicitly enables audio at `$FF26`.

Girlboss now follows that sequence. The former HRAM wait timed out after about
half a second and jumped to `$0100` with a hard-coded `A=$11`, without establishing
the rest of the boot state. The new resident wait has no timeout or direct game
entry. Hardware retesting found no change: the new state has the same bad CGB
flag and saved CPU position. The FPGA's internal reset implementation has not
been inspected.

The first frozen states had Crystal's `hCGB` at `$ffe6` equal to 0 in actual CGB
mode. Importing a state into Gearboy and changing only that byte to 1 reaches
the title. This explains the white picture, but did not establish why the flag
became zero. The first entry probe recorded A `$64` and `hCGB=0` before HRAM
clearing; it overwrote its record on every entry, so a restart could hide the
original boot state.

The hardware `Crystal Entry History.gbc` state resolves that ambiguity:

- First registers: AF `$1100`, BC `$0100`, DE `$ff56`, HL `$000d`, SP `$fffe`.
  These are correct GBA boot values, including A `$11`.
- The entry counter was `$37` (55), with latest A `$64`. Crystal repeatedly
  re-entered startup; the bad device flag is a later symptom.
- The loaded 2 MiB ROM summed to `$7cd7`; the identical SD file sums to `$6a52`.
  Per-bank sums differ in 14 banks: `$00,$10,$11,$1f,$2d,$2e,$2f,$31,$33,$35,$55,$58,$61,$64`.
  The other 114 bank sums agree. This is not simply a wrong ROM-bank mask.

The cartridge receives valid initial CPU registers. The current investigation
is corrupted ROM data in memory, rather than RTC or CGB-only device detection.
Factory-feature initialization and the resident launch wait did not fix it.
The precise hardware cause of the changed bytes is still unconfirmed.

### ROM transfer investigation

Hardware retesting of the uninterrupted, eight-write streaming loop still left
Crystal frozen and introduced garbage while loading. Masking IE across an entire
128 KiB transfer also prevents the renderer's LCD interrupts from selecting the
right window/tile addressing as the screen is drawn. That attempt did not fix
the ROM corruption and has been removed.

The busy-polled multiblock reader **launched Crystal on hardware**, although
loading was painfully slow. This narrows the failure to the streaming path and
its execution conditions, rather than RTC, initial CPU identification or the
common FAT/ROM-placement code. It does not identify the exact electrical or
FPGA timing cause.

The fast build with a plain static loading screen **also launched Crystal on
hardware**, with much faster loading. Its transfer finished pending HDMA, used
normal CPU speed and ran stock's eight-write inner loop from resident ROM0.
This is the working basis for subsequent loading UI changes; the individual
contribution of each change has not been measured on hardware.

### Loading box over the browser

The loading screen now retains the normal browser, header/footer and the
existing "Loading..." box instead of clearing VRAM. During launch,
`render_cpu_copy` selects the DMG renderer's HBlank CPU-copy loop on CGB while
retaining CGB tile addresses, VRAM banks, palettes and attributes. It does not
change `render_gbc`, which would invalidate the existing screen layout.

`GameLoadingBegin` finishes any older HDMA row and pending scroll, then switches
to normal CPU speed once with LCD off. It restarts the existing raster layout
and leaves only the resident LCD/STAT interrupt enabled. That handler maintains
the window and tile-addressing changes needed to display the browser; it never
starts DMA or accesses the SD interface. VBlank/OAM DMA, cursor/spinner sprites
and input updates remain disabled throughout loading. No progress redraw runs
between transfer chunks yet; a loading bar is future work.

`sd_ReadBlocks` retains normal-speed streaming and the eight-write ROM0 loop.
It allows only the caller's LCD interrupt, excluding every other handler, and
finishes any pending HBlank DMA before starting. Cleanup disables streaming and
restores the caller's CPU speed, IE and IF on every exit without issuing EI.
In the real launch path the CPU is already at normal speed for the entire load,
so no speed switches occur between chunks. Ordinary file/save reads continue
to use the busy-polled single-sector path. Command/token failures report a disk
error rather than silently retrying the whole ROM slowly.

The error path restores CPU speed, sprite/display settings, interrupts and the
normal renderer transfer mode before showing the existing error message. Since
the browser's tiles/maps were preserved, no renderer rebuild is needed.
The retained 32-byte source header is still compared against loaded PSRAM before
finishing; this checks the header, not the entire ROM.

Native checks compare CPU-drawn browser/box VRAM and rendered pixels against
the normal renderer on DMG and CGB, monitor HDMA/OAM starts while the screen is
held, and exercise failed-load recovery. Transfer tests cover command delays,
missing/invalid tokens, a changed header, initial HDMA, both CGB speeds and DMG;
they verify normal-speed ROM0 writes and exclude DMA-capable interrupts. Full
browser tests compare every loaded Crystal ROM byte and reach its title screen.

**The browser-overlay/CPU-copy version still needs a hardware retest.** The
plain-screen fast build is preserved locally at
`/tmp/girlboss-before-browser-loading` before installing this change.
Gearboy does not reproduce cartridge electrical timing, so emulator tests alone
cannot prove the revised interrupt allowance is safe on hardware.

### Temporary hardware probes

`Crystal Entry Check.gbc` and `Crystal Entry History.gbc` are separate local test
ROM copies on the SD root. They do not add OS build variants or a game-specific
production patch. The history probe retains the first registers, startup count
and loaded-ROM checksums in WRAM bank 7:

| WRAM bank 7 address | Contents |
| --- | --- |
| `$d000-$d0ff` | Cumulative 16-bit sums after banks 0-127, little endian |
| `$dfe0/$dfe2/$dfe4/$dfe6/$dfe8` | First HL/DE/BC/AF/SP, little endian |
| `$dff0-$dff1` | `EP` signature |
| `$dff2` | Entry count |
| `$dff4` | Latest entry A |
| `$dff5-$dff6` | Whole loaded-ROM sum, little endian; expected `$6a52` |

The history probe occupies originally zero bytes `$0063-$00fc`, redirects
`$0100` there, repairs the global checksum, and preserves game code/data from
`$0150` onward. It restores all incoming CPU registers and the WRAM bank before
Crystal's original startup. The logs survive initialization, which only clears
WRAM bank 1. Its checksum takes about half a minute at normal speed. Logs are
cumulative across software restarts and repeated launches while WRAM survives;
an existing `EP` log also means the checksum is not recomputed. A fresh log is
needed before using the same history ROM to assess another loading attempt.
Original ROM/save filenames are separate. Remove the temporary probe files
once the loading fix is confirmed.

Gearboy honors `$BD04` when extracting the launched ROM, including masked
address-line mirroring. Previously it used the header's size, hiding bad mask
settings. Ordinary launch still resets the emulated console immediately, so a
separate bus-probe regression suppresses reset to check the resident wait, IE,
audio enable and unmodified HRAM beyond the former timeout.

## Battery saves and registry

Battery SRAM uses `/GBCSYS/SAVE/<basename>.srm`. MBC2 saves are 512 bytes;
2, 8, 32, 64 and 128 KiB saves retain their actual sizes.

Launch updates the stock `REGISTRY.BIN` game metadata, expanded directory entry,
valid flag, and additive checksum while preserving options. This makes the
stock backup agree with Girlboss about which game owns cartridge RAM. Girlboss
also imports a checked stock registry when its private ownership cookie is
absent or superseded. It validates the stock SRAM marker before backing up
SRAM, RTC and the state slot. Invalid ownership is skipped instead of assigning
unknown RAM to the previous Girlboss game.

`EDITOR.GAM` uses version GAM3 internally; older GAM1/GAM2 records are still read.
Legacy records back up SRAM without claiming a snapshot slot those builds never
initialized. The stock registry and save files remain the interchange formats. Girlboss
invalidates the SRAM marker before preparing a new game and publishes the valid
marker only after its registry and ownership record have been written.

## Save states

See [IN_GAME_MENU.md](IN_GAME_MENU.md) for controls, layout and limitations.
States use stock `/GBCSYS/SNAP/<basename>.sav` files and the battery-backed slot.
The format supports at most 32 KiB of cartridge RAM.

## Cheats

Stock cheats are Game Genie ROM patches applied before launch. Girlboss reads
`/GBCSYS/CHEATS/<basename>.txt` when the stock registry's Cheats option is enabled
(default: enabled). The text editor can edit these files directly. Use up to
sixteen lines of `XXX-XXX-XXX`, replacing the Xs with hexadecimal code digits.
`XXX-XXX-XXX` is an unused slot; `ABC-DEF-XXX` is a six-digit code without a
compare byte. Both LF and stock CRLF endings work; lowercase hex is accepted.
Matching stock behavior, compare codes scan all physical ROM banks (including
bank zero); codes without a compare byte patch the first physical bank only.
The offset within each bank ignores address bit 14. Changing cheats takes effect on the next launch.

This implements stock ROM patching. Continuous GameShark RAM writes aren't part
of this cheat format. Save states have been tested successfully on hardware;
cheat testing is deferred.
