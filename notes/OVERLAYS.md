# Fixed-code overlays (Phase 4)

The general loader installs one host-bound `OVL1` image into a subinterval of
`_RenderOverlayStart.._RenderOverlayEnd`. Those linker symbols describe only the
fixed renderer section, never the rest of resident bank 1 or a whole $1D00 page.
No caller, interrupt or return address may use the interval during replacement.
Stop the renderer/DMA, turn the LCD off and mask IE before install or restore.
The dispatcher and every loader/checksum/copy callee remain outside the interval.

`overlay_request.source` and `.offset` identify the envelope in staged PSRAM.
`OverlayInstall()` validates its bounds, host checksum, ABI, kind, entry and CRC
before writing code. It backs up and reads back the original interval, copies
and verifies the payload, and restores the backup if installation fails.
`OverlayRestore()` checks the backup before use and verifies the restored bytes.
Both preserve the window block and configuration. The returned status is 0 OK,
1 invalid, 2 busy, or 3 fatal restore failure. A fatal result leaves `overlay_live`
set: the caller must stop rather than enter potentially damaged renderer code.
Nested installation is refused. Restoring an inactive overlay succeeds.

The 16-byte envelope is:

| Offset | Size | Value |
| --- | --- | --- |
| 0 | 4 | `OVL1` |
| 4 | 1 | ABI 1 |
| 5 | 1 | Kind 1, fixed renderer |
| 6 | 2 | Raw OS global-checksum bytes at $014E–$014F |
| 8 | 2 | Destination address |
| 10 | 2 | Payload byte length, nonzero |
| 12 | 2 | Entry within the payload |
| 14 | 2 | CRC-16/CCITT-FALSE over payload |
| 16 | length | Executable payload |

Words are little endian. A container page pads the envelope and payload to
$1D00 bytes. `scripts/overlays.py` creates/checks these pages; the outer SGB.DAT
CRC also covers padding and its directory/header. Phase 5 supplies the complete
file loader and bootstrap; Phase 4 alone does not activate fullscreen rendering.

Persistent allocation: `$3B00–$3B8F` stages SGB.DAT (72 KiB), `$3B90–$3B9F`
holds the verified original renderer (up to 8 KiB). Phase 8 reserves `$3BA0`
for up to 19 fixed-stride menu lines (one sector); accesses restore the PSRAM
window and stage one line in `wide_scratch`. This stays below snapshot
staging at `$3C00` and avoids the `$3E00` hardware failure region. Large-file
added text now ends at `$3B00`: its cap is `$6E0000` instead of `$720000`
(256 KiB reserved). Assembler caches/images remain below the new boundary.
Loader state uses 21 bytes of the existing WRAMX gap, leaving 14 bytes free.

`make test-overlays` runs the actual GB loader on DMG and CGB in Gearboy with
its FatPak-specific SGB host disabled. It tests a cross-sector header, unaligned
multi-sector payload and partial tail, execution of installed code, replacement
of the entire audited renderer interval, exact restoration, bad CRC/host/bounds,
live-interrupt/nested refusal, corrupt-backup failure and repaired retry.
Runtime geometry and module compatibility suites pass on both machines.

ABI 12 fills the final reserved module slot with `ModOverlay(command)`: 0 returns
the request pointer, 1 installs, 2 restores, 3 reads the entry, 4 reads live state,
and 5 calls the validated entry and returns its byte result. Loader helpers stay
out of page 13 so the standard bootstrap module can call them. Entry code must
obey the host-bound import/layout contract. The terminal linker audits its
external control transfers; module/interrupt page audits remain enabled.
