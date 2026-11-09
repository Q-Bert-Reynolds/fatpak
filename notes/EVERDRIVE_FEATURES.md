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

The clock-menu garbage was caused by 40-byte row spacing where menu boxes use
20-byte rows, plus page-local field-name pointers passed to a text routine on
another page. Fields now use packed box rows and resident strings. Calendar
reads poll completion without checking the slave ACK bit during reception,
matching stock `I2C_ReadBytes`. These corrections still need a hardware retest
of clock setting and Crystal's previously white screen after the boot logo.

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
