# Phase 7 hardware integration — pending

The production build now produces `bin/SGB.DAT` from the real cc65/65816 kernel,
fonts and the renderer overlay bound to `GBCOS.BIN`. `make assemble` stages it
with the existing OS/data/modules; its normal mounted-card copy includes it.
For a build without copying to the card, pass `SD_MOUNT=/tmp/fatpak-no-sd`.
Copy `SGB.DAT`, `GBCOS.BIN`, `EDITOR.DAT` and `MODULES/SGBBOOT.MOD` from the same
build into `GBCSYS`. The container checks the OS checksum before takeover.
Removing `SGB.DAT` disables fullscreen startup on SGB and retains the BIOS mode.
DMG/CGB startup is unaffected.

No SGB1 or SGB2 hardware results have been collected for this kernel. Mesen
proves BIOS upload, real ICD2 transport and PPU output separately from the OS
frontend test; it cannot prove the complete EverDrive/SGB combination. The
Phase 0b hardware ACK stall remains relevant. Do not mark Phase 7 complete from
an emulator result or from producing the container.

Record console/SGB revision, cart/OS build and keyboard/controller setup with
all results. Use a gamepad in port 1; leave the mouse in port 2 for later input
checks. A keyboard can help inspect text while the full pad mapping is developed.

- [ ] SGB1: cold boot reaches fullscreen browser, readable title/status and file list.
- [ ] SGB2: repeat the same cold-boot check.
- [ ] On each, open a small `.c` file, verify comments/strings/keywords, scroll,
      place the cursor, edit using the pad/OSK, save and reopen the changed file.
- [ ] On each, repeat with `.md`: headings, emphasis, fenced code and selection.
- [ ] Run L+R+Select diagnostics through several minutes of scrolling. Record
      accepted/rejected pages, overwritten rows and whether display/input stalls.
- [ ] Open/close menus over text; change selection; dismiss dialogs; open help,
      OSK and module menus. Base text must reappear intact. (Phase 8.)
- [ ] Verify missing/corrupt/mismatched `SGB.DAT` retains BIOS mode, using copies
      of the files and restoring a matching production set afterwards.
- [ ] Remove/reinsert the physical keyboard and try longer filesystem operations;
      no unsaved document may be discarded because of a transport timeout.

A runtime transport fault currently stops page publication and preserves the GB
state; automatic visual recovery after SNES takeover is not established. Save
before stress tests. Fullscreen game launch, cart-button return and reset/BIOS
handoff are Phase 10 work; the non-destructive Phase 0c probe is insufficient to
prove that cycle after replacing SNES VRAM/CGRAM.

Use copies of small source files for edit/save checks. Capture a photo and the
precise last action if a check fails, especially any cold-boot stall, black screen
or change in the diagnostic counters.
