# Loadable modules and overlays

Status: implementation plan. The loader and module ABI do not exist yet.

Call the features **modules**, and the memory replacement mechanism an
**overlay loader**. An overlay is code loaded over another program region and
removed/restored when it returns; a module is the separately built component.
This terminology has 8-bit precedent: Digital Research's December 1980
[LINK-80 Operator's Guide, Appendix E](https://www.bitsavers.org/pdf/digitalResearch/cpm/LINK-80_Operators_Guide_Dec80.pdf)
describes CP/M `.OVL` files with a load address and length, sharing memory with
other program components. FatPak can use `.MOD` filenames without changing the
technical meaning of the loader.

## First scope

Extract keyboard diagnostics first. It is a bounded, synchronous screen and
already returns to its caller. Follow with file info and clock settings after
measuring their imports. Keep startup, the browser, interrupts, game capture/
resume, the renderer, SD/FatFs and the loader available while a module runs.
Do not start with the assembler or PNG decoder: first establish a small working
loader and a stable API. This plan does not add a plugin discovery UI.

V1 supports one active module, one code page, one entry and a normal return.
No nesting, resident modules, runtime relocation, exported callbacks or saved
pointers into a module after it exits. Modules run synchronously on the OS stack.

## Memory and execution

The executable window is `$A000-$BCFF`, exactly 7,424 bytes. `$BD00-$BFFF`
contains registers and the PSRAM window and must never be overwritten. Module
code, constants and zero-initialized private data must all fit in that page;
there is no spare general-purpose WRAM allocation.

Start by borrowing **page 13**, subject to an import audit. Current code on that
page includes syntax keywords/SGB setup and filesystem operations such as
stat, rename, unlink and mkdir. Those services cannot be called while the page
contains module code. V1 diagnostics use plain UI drawing and input; initial
file services may expose open/read/write/seek/close only after confirming their
entire call chains avoid page 13. Move any required conflicting implementation
to another page before adding that import. Far calls to a displaced page do
not become safe merely because they pass through a resident thunk.

Keep the transfer loop, entry/return trampoline and API jump table resident.
The copy loop must execute in ROM0 or always-mapped bank 1: switching to page
13 while executing an ordinary paged C loader would replace its own code.
The caller's return address must likewise remain usable until restoration.

Proposed PSRAM reservations, not allocated by a loader yet:

| Blocks | Purpose |
| --- | --- |
| `$3d00-$3d54` | Current `EDITOR.DAT` assets, protected from ROM loading |
| `$3d55-$3d64` | Filename undo history |
| `$3d80-$3d8e` | Incoming module staging, 15 sectors |
| `$3d90-$3d9e` | Backup of the displaced OS page, 15 sectors |

An OS page occupies 14 full sectors plus 256 bytes. Copy/checksum exactly 7,424
bytes, never the final sector's register/window range. Assert reservations in
the build against asset growth, large-file additions, snapshot staging at
`$3c00-$3ca3`, game metadata at `$3e2f` and the snapshot/menu workspace above it.
No module scratch is placed inside the editor text, undo or clipboard regions.

## File format and ABI

Build each module with its own RGBDS link script and a ROM fragment with a
`LOAD` section in SRAM page 13, as current OS pages do. Its execution addresses
are absolute at `$A000`, limited to `$BD00`. Extract just the fragment payload
from the linked image using its section bounds; do not ship a padded OS ROM. Use SDCC's existing register/stack calling convention. A host tool
packages the linked payload into `/GBCSYS/MODULES/<name>.MOD` with a 32-byte
header. Freeze exact byte offsets when writing the packer and loader together.

The header needs magic `FPKM`, format version, host ABI version, module ID,
load address/page requirement, entry offset, payload length, BSS offset/length,
CRC-16 of the payload, and zero reserved bytes. Reject wrong versions, truncated
or trailing payloads, bad checksums, entry points outside executable payload,
and overlapping/out-of-range BSS before replacing any code. Zero unused space
so a short module cannot execute residual OS instructions accidentally.

Expose a small, explicitly versioned resident jump table, rather than linking
against arbitrary addresses from `GBCOS.sym`. Keep its position stable with a
linker reservation and assertions; select the actual address after the resident
space audit. Generate an SDK include/header from the same ABI definition.

Initial imports: API/version query, draw plain row, draw/update frame, wait/get
input, show/close box, read clock, a bounded keyboard-diagnostics snapshot/
listen service, and return status. Add audited file handles
for the next module. Avoid exposing FatFs structs, renderer globals or raw
mapper registers as ABI. A small host-owned call context passes the invocation
and result; the module's other state lives in its own page. Document stack use
and test it against the existing FatFs/editor stack guard before shipping.

## Pointers across page changes

A second ABI audit is essential: a pointer into module code/data at `$A000`
cannot be passed straight to a host routine that switches pages. It would read
that host page at the same address instead. A far-call thunk fixes execution
mapping, not the lifetime of the argument's memory.

Resident API wrappers must marshal strings and I/O through a bounded bounce
buffer before switching pages, then copy results back after reselecting the
module. Reuse an audited existing host scratch buffer (the 512-byte filesystem
buffer is a candidate) rather than allocating another WRAM block. Give the API
bounded lengths and opaque file handles; keep its scratch use synchronous and
nonreentrant. Audit UI drawing and file operations separately for scratch-buffer
aliasing and preserve the large document's open file handle. The call context
itself must be in host WRAM/stack, not in the borrowed page. Test module-local
strings, read/write destinations and error messages across every host page call.

## Load, call and restore

1. Show a resident loading box; reject a second module invocation.
2. Open and fully validate the module into staging using a private file handle.
   Keep an existing large document's handle, text and undo untouched.
3. Save caller page, interrupt masks and UI context. Copy/checksum the borrowed
   page into its backup from resident code. Disable nonresident interrupt work
   during page replacement; retain only audited resident LCD handling so the
   loading screen remains valid. Do not start HDMA while the mapping changes.
4. Install the staged code/constants, clear its BSS, then enter through the
   resident trampoline. Enable only services/interrupts safe with page 13 absent.
5. On normal return or a host-reported cancellation/error, remove modal pointers
   into module memory, restore and verify the OS page, restore mapping and UI
   state, then redraw the caller. The host restores editor layout/syntax after the page
   is restored; module cleanup must not call an editor refresh that needs the
   displaced keyword code. Do not return into the replaced page first.
6. Missing/bad modules leave OS code untouched and report the existing SD/module
   error UI. A native module can still crash; there is no memory protection.
   If the saved page cannot be verified, do not execute it: recovery must use
   the full device restart path. Power loss naturally returns to normal OS boot.

## Implementation milestones

1. **Inventory and ABI:** list page-13 residents and transitive imports; establish
   the jump-table reservation, call context, stack budget and SDK. Add build
   checks rejecting imports into the displaced page and oversized images.
2. **Packer and transfer primitive:** build a diagnostic module that draws a
   line and returns. Validate headers/checksums and test page backup/restore
   independently of any existing feature extraction.
3. **Keyboard diagnostic extraction:** move the current keyboard test behind
   the browser's existing Settings command. Preserve PS/2 detection and B exit.
   Package/install required modules with `GBCOS.BIN` and `EDITOR.DAT`.
4. **Next modules:** move file info, then clock settings, one at a time. Keep
   filesystem helpers required by their ABI outside the borrowed page. Update
   the map after each move and use the freed space for the next extraction.
5. **Utilities:** only then add snapshot viewers, PNG decoding and on-device
   development features. Revisit multiple pages/relocation if an actual module
   exceeds 7,424 bytes.

Acceptance checks: DMG/CGB; byte-identical page restoration; repeated and failed
loads; wrong version/checksum/length/BSS/entry; cancellation; all UI exits;
keyboard input; caller stack guards; open small/large documents and undo;
unchanged save/snapshot data; then GBA SP hardware testing and a Crystal launch
following module return. Measure page space recovered and SD load latency.
