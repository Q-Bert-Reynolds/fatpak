# Assembler

[Architecture](ARCHITECTURE.md) · [Modules](MODULES.md) · [TODO](../TODO.md)

`ASM.MOD` assembles the open `.asm` document on the device into a bootable ROM.
FILE > BUILD (F7) writes `<name>.gb` beside the source; FILE > RUN (F5) builds
and launches it through the normal game path. It assembles an RGBDS 1.0 subset:
a file that builds here builds with `rgbasm`/`rgblink`/`rgbfix -v -p 0` to the
same bytes (that is what the tests check), not the other way round.

Status: includes, conditionals, repeats, macros and rgblink-style placement work
on hardware (DMG01, GBA SP). `EQUS`, string functions, `{}` interpolation,
`PURGE`, `FOR` and `INCBIN` pass on the PC and in Gearboy (DMG, CGB); not yet
tried on hardware. FatPak's own `math.asm`, `memory1.asm` and `gbdk.asm`
assemble byte-identical to RGBDS, unmodified (`memory1.asm` calls
`hardware.inc`'s `rev_Check_hardware_inc`, which builds a macro from an `EQUS`).

## Using it

- Save the file as `.asm` (the language comes from the extension). BUILD saves
  first if the text is modified or unnamed.
- The header's logo, ROM-size byte and both checksums are written for you
  (`rgbfix -v -p 0`); the rest of `$100-$14F` is yours, as in any RGBDS project.
- An error shows in a box with the file's name, `Line <n>` and the message, and
  moves the cursor to that line. In an included file the cursor goes to the
  document's `INCLUDE` line that led there. An error
  in a macro is reported where the macro was used. The first error stops the
  build.
  `build.log` also records `macro <n>` for the innermost macro body's line
  (its first body line is 1), and `byte <n>` for the decimal character code at
  the first parser failure (10 is a line feed, 0 is end of input). These help
  locate a hardware-only failure hidden behind a macro's call site.
- Success shows BUILT and the ROM size. RUN then launches like a game:
  the editor's text and settings go to the swap file first and come back when
  the game returns or at the next boot.
- Only text-buffer documents (≤ 65,024 bytes) assemble; large files report
  FILE TOO BIG. Included files can be up to 64 KiB each, 16 of them.
- `INCLUDE "path"` is tried relative to the document's folder, then to each
  folder above it, then as a base name in the document's folder. RGBDS resolves
  paths from where it runs, usually a project's root, so `src/main.asm` can
  `INCLUDE "src/keyboard/keyboard.asm"` as it does in a Makefile build, and
  `INCLUDE "src/hardware.inc"` also finds `hardware.inc` beside the source. An
  included file may end without a line feed.
- `INCBIN` finds files the same way; it and `INCLUDE` share the 16 slots, and
  a file used twice is read once.
- **Projects.** A `project.gbp` in the document's folder or any folder above it
  (the nearest wins) makes BUILD and RUN build the project instead, from any
  file in it (a `.md` too), and from `project.gbp` itself:

  ```
  ; one file
  main   src/main.asm
  output game.gb
  rgbasm -D _DEMO -D LANG_EN
  rgbfix -jvcs -k 01 -l 0x33 -m 0x1B -p 255
  ```

  `main` and `output` are paths from the project's folder; `output` defaults to
  the first main's path as `.gb`. Includes are tried from the project's folder
  first, as `rgbasm` resolves them when a Makefile runs it there.
- **Units.** `main` takes several files, and may be repeated: each is a unit, as
  a Makefile that runs `rgbasm` once per file and `rgblink` over the objects
  builds them, in link order. Each unit is assembled on its own, as `rgbasm -P
  file` assembles it, and LINK.MOD then does what `rgblink` and `rgbfix` do. The
  `-P` file is read once per build (it may define anything but code) and every
  unit starts from what it left: its symbols, charmaps and `RS` counter. A
  project split like beisbol's is:

  ```
  main   src/memory1.asm src/strings.asm src/gbdk.asm ...
  main   src/baseball/simulation.asm src/wram.asm src/sram.asm src/main.asm
  output beisbol.gb
  rgbasm -D _DEMO -D LANG_EN -E -P src/beisbol.inc
  rgbfix -jvcs -k 01 -l 0x33 -m 0x1B -p 255
  ```

  A unit's constants, macros and string symbols are its own. Other units'
  labels (all of them, as with `rgbasm -E`; `-E` is accepted, and without it
  labels are still shared) and the constants they `EXPORT` are found by the
  link, so a unit can use them wherever `rgbasm` would leave the value to
  `rgblink`: an operand, `DB`/`DW`/`DL`, `ASSERT`, `BANK()`, but not a size, an
  address or an `IF` (NOT YET DEFINED). `\@` starts again in each unit. Up to
  63 units. A build that worked also writes **`build.obj`** beside
  `project.gbp`: each unit's object and the directory entries of the files it
  read. The next build assembles only units whose files changed (or all of them
  when `project.gbp` or the prelude did) and takes the rest from it. With
  nothing changed and the ROM still there (its size, dated no earlier than
  `build.obj`), the build is **up to date**: nothing is assembled, linked or
  written, and `build.log` says so (beisbol: 2.4 s instead of 24 minutes; one
  small unit edited, 1:53). A
  file saved without a clock (dated 2026-01-01 00:00) always counts as changed.
  Delete `build.obj` (or the ROM, to link again) to assemble everything again. One difference from `rgbasm`: a unit that
  uses a prelude symbol, then `PURGE`s and redefines it, sees the new value at
  the earlier use too (its second pass finds its own definition first).
- The `rgbasm` and `rgbfix` lines take those tools' options: `-D NAME[=VALUE]`
  (an `EQUS`, `"1"` without a value), `-P file`, `-E` and `-W...` (ignored);
  `-v -j -c -C -s` and `-k -l -m -n -p -r -t -i`,
  with the value in the same word or the next, numbers as `$1B`, `0x1B`, `0b11`
  or decimal (`-m` takes numbers, not MBC names). The logo, ROM size and
  checksums are always fixed. Anything else is NOT SUPPORTED at its line, `;`
  starts a comment, a word may be quoted, and the keywords are case-insensitive.
  An error goes in the box with its file and line; the cursor moves to it when
  it's in the open document (`project.gbp` included), and stays otherwise.
  A project build also writes **`build.cache`** beside `project.gbp` (after a
  build that worked) and reads it at the next: where each file's directory entry
  was found (its sector, place and 8.3 name). A file whose entry still has that
  name is read straight from its clusters, without FatFs searching its folder
  (most of the card's time); anything else is searched for as before, so a
  moved, renamed or new file is found, and an edited one reads as it is now (the
  entry has its size and first cluster). `build.log`'s card line says how many
  went through it. Delete `build.cache` to start over; one written for another
  card or volume isn't used.
  `.gbp` files are highlighted like assembly with their four words as
  directives. Without a project, BUILD on anything but assembly says NOT AN ASM
  FILE (after the module looked for one).
- Samples: `tests/asm/` (`hello.asm`, `features.asm`, `strings.asm`,
  `loops.asm`, with `lib/`). The card's `Asm` folder has those plus `math.asm`,
  `gbdk.asm`, `memory1.asm` and `hardware.inc`.

## The subset

| Supported | Notes |
| --- | --- |
| Every SM83 instruction, RGBDS spellings | `ld [hl+]`/`[hli]`, `ldh [c]`/`[$ff00+c]`, `jp hl`/`[hl]`, `add b` without `a,`, `ld hl, sp±e`, `stop` is 2 bytes, `halt` 1 |
| Labels `Name:`/`Name::`, locals `.loop` (colon optional), `Name.loop` references, indented labels | locals belong to the last global label |
| `DEF X EQU`, `DEF X =`, `REDEF X =`, `DEF X RB/RW/RL [n]`, `RSRESET`, `RSSET` | constants must be known on the first pass (no forward references) |
| `SECTION [FRAGMENT] "name", TYPE[addr], BANK[n], ALIGN[n[, offset]]` | ROM0, ROMX (banks 1-63), VRAM, SRAM, WRAM0, WRAMX, OAM, HRAM; up to 512; placed like rgblink (below). Fragments with one name join in source order (attributes count on the first) |
| `PUSHS [section args]`, `POPS` | 8 deep; the label scope comes back too |
| `DS ALIGN[n[, offset]][, fill]` | like rgbasm: pads as far as the section's address or alignment says, then tightens a floating section's alignment |
| `DB`/`DW` (with strings and `\n \t \r \0 \\ \" \'`), `DS n[, fill]`, bare `DB`/`DW` in RAM | |
| `INCLUDE "file"` | nested, and the same file again is read from PSRAM, not the card |
| `IF`/`ELIF`/`ELSE`/`ENDC` | nested to 15 levels; skipped lines aren't parsed |
| `REPT n`/`ENDR`, `FOR name, [start,] stop[, step]`/`ENDR` | nested; `\@` is unique per iteration; the `FOR` variable ends one step past its last value, like RGBDS |
| `MACRO name`/`ENDM`, invocation, `\1`-`\9`, `\@`, `_NARG`, `SHIFT` | arguments split at top-level commas, outside `()`, `[]` and quotes; `\@` is `_u1`, `_u2`... as in RGBDS 1.0 |
| `DEF`/`REDEF name EQUS string`, `"""..."""` (may span lines) | a string symbol used as a word is replaced by its text, as in RGBDS: at a statement's start, in an expression, in macro arguments |
| `{name}`, `{fmt:name}` anywhere but comments, in strings and in the middle of words | numbers default to `$` and uppercase hex; formats `[#][0][width]` and `d u x X b o`; string symbols give their text |
| `STRCAT`, `STRUPR`, `STRLWR`, `STRSLICE` (0-based, negative from the end), `STRSUB` (1-based, deprecated in RGBDS), `STRRPL`; `STRLEN`, `STRCMP`, `STRFIND`, `STRRFIND` in expressions | `\\` in a macro body stays a backslash for the string that reads it |
| `INCBIN "file"[, start[, length]]` | copied a run at a time (up to 256 bytes), not a byte at a time |
| `PURGE name, ...` | names can be defined again (pass 2 too) |
| `CHARMAP "string", value, ...`, `NEWCHARMAP name[, base]`, `SETCHARMAP name`, `PUSHC`, `POPC` | strings in `DB` and character literals go through the current map: the longest entry at each position, unmapped characters as themselves; `'x'` must be one entry of one byte; 8 maps, 60 KiB of entries; `\{` `\}` are literal braces |
| `ASSERT expr[, msg]`, `FAIL` | ASSERT is checked in pass 2, or by the link when it needs a label's address |
| `EXPORT`, `GLOBAL` | an `EQU` or `=` constant defined above is other units' too, for values the link works out; labels already are |
| `WARN`, `PRINT`, `PRINTLN` | accepted and ignored |
| Expressions | `+ - * / % & \| ^ << >> == != < > <= >= && \|\| ! ~`, unary `-`, parentheses, `@`, `HIGH()`, `LOW()`, `BANK(label or @)`, `DEF(name)`, `_NARG`, `__RGBDS_MAJOR__` etc., `$hex %bin &oct 123 'c'`, fixed point `1.5` (16.16), `_` separators |

Values are 32 bits and signed, as in RGBDS: `/` rounds toward minus infinity,
`%` takes the divisor's sign, `>>` is arithmetic, a shift of 32 or more leaves 0
(or -1) and a negative one goes the other way. `DL` writes 4 bytes. `EQU` and `=`
constants keep all 32 bits (the high word in the symbol's `extra`); labels,
addresses, sizes and instruction operands are 16 bits, and an operand keeps the
value's low bits (RGBDS warns where it differs). 8-bit operands accept -128..255.
`ldh` takes `$FF00-$FFFF` or `0-$FF`. Mnemonics and directives are
case-insensitive, names case-sensitive. Fixed-point literals are 16.16, the
fraction rounded from up to 7 digits (RGBDS reads more; they differ only in
rare last bits). `+=` and the other compound assignments, `**` and `>>>` aren't
read yet. Nesting: 10 frames (includes, macros, repeats and arguments
together), 256 bytes of macro arguments in flight.

Not supported, with the NOT SUPPORTED error: `LOAD`, `UNION`, `CHARLEN`,
`CHARSUB` and the other charmap functions, `OPT`, the `ALIGN` directive,
`SECTION UNION`, `STRFMT`, `\<10>` and named macro arguments.
Names are up to 79 characters (section names 78); nesting is 16 frames. String symbols
are at most 256 bytes; the `EQUS` heap holds 64 KiB over both passes. Old `X EQU`/`X SET` without `DEF` and `ld [c], a` without `ldh` are
gone from RGBDS 1.0 and aren't accepted.

**Placement** follows rgblink, checked against it on thousands of random
layouts. Pass 1 records each section's type, bank, alignment (and its offset),
address and size; LINK.MOD joins `FRAGMENT`s of one name (each unit's piece
after the last, its bank, address or alignment counting for the whole, as
rgblink merges them) and places them.
Then, in order: sections with address and bank given (one-bank regions count as
given), then bank only, then address only, then neither; within each, aligned
ones first, then bigger, then the later one in the source. Each goes in the
lowest bank it may use, at the lowest address that fits among those already
placed (each bank keeps a list of its sections by address, so `Link` walks only
the gaps). An empty section goes at its region's start, whatever its offset, and
takes no room. Fixed
sections that overlap are SECTIONS OVERLAP; one that doesn't fit is SECTION FULL,
reported at its `SECTION` line. The ROM is the smallest power of two ≥ 32 KiB
that holds the highest ROM bank used.

## How it works

Two modules, run one after the other (`BuildFile`): ASM.MOD assembles each unit
(the document alone is one) as `rgbasm` would, into objects in PSRAM; LINK.MOD
does `rgblink`'s and `rgbfix`'s work on them and writes `build.log`.

ASM.MOD reads the prelude (`-P`) once, as pass 2 reads, and `Snapshot`
(`asm_prelude.c`) copies what it left. Then each unit gets two passes. Pass 1
parses it, sizes every statement (instruction sizes depend only on syntax),
records its sections (each starting at its region's base, or its address) and
defines labels; pass 2 parses again, evaluates and writes bytes, with the same
addresses (a label that ends up somewhere else is a PHASE ERROR, a bug). `DS`
counts and section addresses must be known in pass 1 (NOT YET DEFINED
otherwise). `DEF()` in pass 2 only sees symbols defined earlier in pass 2 (a mark
bit per symbol), so include guards work. Before each pass, `Restore` puts back
the prelude's state: the blocks of prelude symbols the unit redefined, `PURGE`d
or `EXPORT`ed (`Dirty` marks them), the charmaps if it added to them, and
before pass 1 the hash heads, which drops the last unit's symbols.

- **Relocation** (`asm_rel.c`). Without the link, a label in a section that has
  no address is a pass value there, and a name the unit doesn't define is
  another unit's. The parser keeps each value's state (`xs`): known; a pass value
  in one of the unit's sections (labels, `@`), which stays one under `+` and `-`
  of a known value, and two in the same section subtract to a known distance (so
  `jr .loop` and `End - Start` need nothing); or RPN, once any other operator
  meets one (`Combine`, `Rel`). A value that isn't known becomes a **patch**
  where it's used: an operand or `DB`/`DW`/`DL` item (its field: a byte, word,
  long, `jr` distance, `ldh` address, `rst` opcode or `sp+e8`), or `ASSERT`;
  anywhere else it's NOT YET DEFINED. Beisbol has 12,039 (rgbasm writes 13,418:
  it patches every `jr` to a label).
- **Objects** (`modules/assembler/asm_obj.h`). Pass 2 writes each ROM section's bytes in
  its own blocks from `ASM_DATA_BLOCK` (`UnitData` gives them out after pass 1;
  the block for `pc` is `sec_dbase + pc / 512`), and the unit's records to the
  object stream at `ASM_OBJ_BLOCK`: a unit header, its patches (section, offset,
  type, file and line, RPN), then `Exports`' section names, labels (full
  `Global.local` names: other units use them) and `EXPORT`ed constants; a
  patch's place is its pass address, like a label's. The sections themselves
  stay in the build's section table. Beisbol: 699 data
  blocks (of 2,048), 1,105 object blocks (of 2,048), the prelude's snapshot 105
  (of 255).
- **build.obj** (`modules/assembler/prep.c`, `link_build.c`). PREP.MOD (one page) runs
  first: it loads the last `build.obj`'s head and file lists (its first 64
  blocks; `ModLoad` reads a file's first blocks when the rest doesn't fit) at
  `ASM_OLD_BLOCK`, above where the files are packed, and reads the directory
  entry of `project.gbp` and of each file it lists (`ModSector`, the sector kept between them), comparing name, attributes,
  cluster, time, date and size. With `project.gbp` and the prelude's files the
  same, each unit whose files are all the same is clean (`AsmPrep` at
  `ASM_PREP_BLOCK`, `ASM_OLD` in the context). With all of them clean it looks
  up the ROM (`ModLoad` of its path from the head, reading nothing): there,
  `rom_blocks` long, and its entry's time and date no earlier than
  `build.obj`'s, both by the clock, the build is up to date (`ASM_CURRENT`:
  the head's output path and size in the context, a two-line `build.log`, and
  `BuildFile` runs neither module nor writes the ROM, which it writes after
  `build.obj`). Otherwise it loads the rest for LINK.MOD. ASM.MOD doesn't read a clean
  unit's main file nor assemble it (nor the prelude, if all are clean): `Keep`
  writes `OBJ_KEEP` and takes its sections' numbers. In pass 2 every file a
  unit opens is an `OBJ_FILE` record. LINK.MOD's `Restore` copies the kept
  units' section records into their numbers, their data left where it was loaded
  (`Image` and `Compose` read it there); `Walk` reads their objects in the old `build.obj` (`KeepAt`, to their
  recorded length); errors in them name their file from its list. After a link
  that worked, `Compose` puts the new `build.obj` together over the files
  (`ASM_BUILD_BLOCK`): a head (`BuildHead`: `project.gbp`'s record, the ROM's
  path and size, a `BuildUnit` per unit) with the file lists after it (the
  prelude's, each unit's; 64 blocks in all, beisbol's lists 22 KB: more, and
  there's no `build.obj`), the section records as they were before the link
  (`Snap`), the data, then each unit's object (files as numbers in its list). A file's record is its entry's sector and place, from
  `build.cache`'s index (so only with one), and the entry as `ModSector` reads it
  now. The host writes it with `FileWriteImage`'s `$2000` count. When every unit
  was clean it isn't rewritten. Beisbol's is ~940 KB.
- **LINK.MOD** (`modules/assembler/link.c`, `link_obj.c` with `link_read.c`,
  `link_build.c`; three pages, 13, 12 and 5). It reads
  `ASM_LINK_BLOCK` (`AsmLink`: ASM.MOD's result, counts, times and `rgbfix`
  options) and, unless the assembly failed, walks the object stream twice:
  names into a hash table (in ASM.MOD's names-table blocks, 4,096 chains):
  sections (the first of a name is a section, later `FRAGMENT`s of it join it:
  `Join`), labels (as their section and pass address: a patch moves them once
  `Place` has placed them, rgblink's placement, below) and exported constants;
  then, after `Place`, the patches. Between those, `Image` zeroes
  the ROM image and copies each section's bytes to its place. After `Place`,
  each section's move (its address minus its pass start: within 16 bits, both
  are in one region) and bank are a table in WRAM, so a label or patch needs no
  section record. A patch's RPN runs on a stack of 32-bit values (`Value`, with
  ASM.MOD's `Apply`), and the result is checked for its field and written; any
  error reports the patch's file and line. The stream is read a block's run at a
  time (records a step doesn't need are skipped), and that reading, zeroing,
  copying, the checksum, the name hash and compare, and `Place`'s choice of the
  next section are assembly: in SDCC's C they took beisbol's link to 4:16, then
  1:30 with copying and the checksum in assembly; now 0:57 after one edited
  unit, `build.obj` put together included (a Gearboy profile, a PC sample a
  frame: names 17 s, placing 4, the image 4, patches 21, the checksum 3,
  `Compose` 10, its ~940 KB copied through WRAM: there's one PSRAM window).
  Most patches are one term (a label, a section's address or a `BANK()`), which
  `Value` returns without its stack. SDCC 4.2 also dropped the store of `(in_ofs += n) == 512` when it
  wasn't 512 (the walk then never ended on the device): such tests are written
  apart. Then the header and checksums
  (`Header`), and `build.log` after a build that failed too. The box says
  `Placing sections` and `Finishing`, with the time going on from ASM.MOD's.
- **The stream** is a stack of frames that read text by address (`Pos`, 32
  bits): below 64 KiB the document (read through `ModSource` 128 bytes at a
  time), above it a PSRAM byte (`block << 9 | offset`): included files, the EQUS
  heap. `INCLUDE` and `INCBIN` files are read whole by `ModLoad`, once, in pass 1,
  packed one after another from `ASM_FILE_BLOCK` up to `ASM_FILE_END` (about 5
  MiB, any file size); the file's symbol keeps its first block and size. Macro
  and repeat bodies are a range of addresses, replayed (`\1`-`\9` and `\@` push
  small argument frames from memory). Each frame knows its file (the `INCLUDE`
  symbol, 0 for the document) for errors, which name the file without its folders. Skipping (false `IF` branches, recording a `MACRO`,
  `REPT` or `FOR` body) scans lines for the directive that ends them, counting
  nesting. `{` starts interpolation in `Advance` itself (not while skipping or
  in comments), which pushes the text as a frame; a string symbol's expansion is
  a frame too, after putting back the character read past its name.
Source allocation uses `FileBlocks`'s explicit device arithmetic for
`(size + 511) / 512`. SDCC miscompiled the earlier
`(unsigned int)((size + 511) >> 8) >> 1` when spilling its intermediate: it
copied byte 1 over byte 2, then used the duplicated byte for the result.
Files consumed far too many sectors, eventually overwriting reserved PSRAM and
wrapping the allocator. Beisbol reproduced this in Gearboy at about 35 seconds:
`ps2_keys.asm` advanced the cursor from `$F18D` to `$001B`; the next include,
`ps2_interrupt.asm`, was read as document address `$003600`, producing SYNTAX
ERROR at line 1, byte 0. The host C build did not exhibit the compiler bug.
The device regression includes several 22 KB files to exercise that overflow.

- **String symbols** go on a heap in PSRAM (`ASM_HEAP_BLOCK`, 64 KiB)
  that never shrinks during a unit (each starts again from the prelude's), so a
  macro defined from a string keeps its body; the symbol's value is its offset,
  extra its length. String expressions
  are built in a 256-byte WRAMX buffer, nested ones stacked.
- **Symbols** live in PSRAM from `ASM_SYMBOL_BLOCK` as 8-byte units: next, scope
  (the parent label's unit, 0 for globals), value, kind (top bit: defined this
  pass), bank, extra (a label's section, with `LABEL_FIXED` when that has an
  address; a macro's body length), length, name (up to 79 characters). Two
  tables of 256 hash chains share the code (`sym_table`): names (heads in the
  first block, entries from unit 128 to 49,151), emptied back to the prelude's
  for each unit, and files (heads in the second, entries from 49,152), kept the
  whole build: files are symbols named by their path's last 79 characters.
  Entries never cross a block. Macros keep their body's address (value and
  bank) and length. A label's bank is `BANK_LINK` until the link when its
  section's bank isn't given; an `EXPORT`ed constant's bank is 1. `Find` is
  assembly on the device (every name read goes through it).
- **Sections** are 32-byte records in PSRAM from `ASM_SECTION_BLOCK` (512, 32
  blocks), each found by a symbol named `"` and the section's name (so a
  FRAGMENT or pass 2 finds its own). The open one is a copy in WRAMX (`sec`),
  written back when it closes; `fill` is where the pass is up to, so a FRAGMENT
  or `POPS` goes on there. `DS ALIGN` changes the alignment while a pass runs,
  so each pass starts from the declared one. Labels keep their section's 16-bit
  index for the link; each unit has its own records, and LINK.MOD joins
  `FRAGMENT`s (`root`, `piece`) and records where each went (`base`, `bank`).
- **Image** at `ASM_IMAGE_BLOCK` (up to 1 MiB, 2048 blocks), which LINK.MOD
  fills from the sections' data blocks; `Emit` writes the open section's block
  for the address. `INCBIN` goes through `EmitFile` (assembly, beside `Emit`):
  runs that end at the next 256-byte boundary of the file's block or the
  section's (or at the file's end), copied through `str[]` between the two
  windows; pass 1 only counts them. A byte at a time it was a far call
  each (72 KB took ~30 s of a pass on DMG; beisbol's split has ~630 KB). Image, symbols, heap, charmaps and files are
  inside the large-file add buffer, which is unused while a text-buffer document
  is open.
- **Projects** (`modules/assembler/asm_proj.c`): `Main` loads `project.gbp` through the
  host's search (the first file found sets `file_level`, the folder later
  searches try first and `BuildFile` takes the project's folder from), reads it
  as a frame with the lexer's own helpers, loads each main file (`units[]`) and
  the `-P` prelude as included files, defines the `-D` strings before the
  prelude, and LINK.MOD's `Header` applies the `rgbfix` bytes. `Assemble` (in
  `asm_line.c`) reads the prelude, then each unit's passes (`Unit`: an empty
  frame 0 that includes the file, so it reads as `INCLUDE` does), closing the
  unit's section and starting its `\@`, `RS` counter, label scope and `IF` depth
  over. The context reports the error file's path
  as written (`name`, with `base` at its file name) and, on success, the output.
- **build.cache** (`asm_cache.c`, `asm_cstart.c`, `asm_cread.c`, `asm_cbytes.c`;
  split to fit the pages): `CacheStart` (in `Project`, before main) reads the
  last cache file and makes each record a `SYM_CACHED` symbol named as the
  file's `SYM_INCLUDE` one; `LoadPath` reads a file with such a symbol through
  `CacheRead` (`ModSector` for its directory sector, the name compared, then its
  clusters and FAT, in `ASM_LOG_BLOCK`'s two blocks as scratch) and turns the
  symbol into the include. A file the search found is recorded from FatFs's
  `FIL` (`dir_sect`, `dir_ptr`; `ModStat` gives the `FATFS` and `FIL` addresses).
  The new index is built at `ASM_CACHE_BLOCK` (128 blocks) and the host writes it
  when the build worked. FAT16 and FAT32, clusters under 256 sectors. The 32-bit
  sector and cluster numbers are 4-byte arrays worked in assembly: in SDCC's C
  the cache was 3.7 KB, here it's about 1.8 KB. Making room also moved `FOR`'s
  count, `Progress`'s percent and the 16.16 fraction into `Apply` calls.
- **Pages.** A five-page wide module ([MODULES.md](MODULES.md)):
  `modules/assembler/asm.c` (page 13: the stream, words, expressions, word tables, a
  `ModuleMain` that calls `Main`), `asm_emit.c` with `asm_pushs.c`,
  `asm_main.c`, `asm_projw.c` and `asm_cbytes.c` (page 12: 32-bit arithmetic,
  the symbol table, instruction encoders, the data blocks; `PUSHS`/`POPS`;
  `Main`, `Where`, `Report`, `\@`; the cache's 32-bit sector arithmetic),
  `asm_line.c` with `asm_loop.c`, `asm_progress.c`, `asm_cstart.c` and
  `asm_align.c` (page 5: lines, operands, directives, `IF`/`REPT`/`MACRO`,
  `Assemble`; `FOR`, opening files, `INCLUDE`, `INCBIN`; progress; `DS ALIGN`),
  `asm_str.c` with `asm_cread.c` (page 4: `EQUS`, string functions, `{}`,
  charmaps, string characters) and `asm_sect.c` with `asm_proj.c`,
  `asm_cache.c`, `asm_rel.c` and `asm_prelude.c` (page 15: sections;
  `project.gbp`; relocation and patches; the prelude's snapshot and the exports).
  Calls between pages cost a far call each; pointers never cross: each page's
  constants are read by its own code; `modules/assembler/asm_shared.h` lists what is shared
  (globals are WRAMX BSS, readable from all five). Free bytes: page 13 18,
  12 27, 5 17, 4 37, 15 237 (with `jr` for every jump in range,
  `modules/peephole_jr.def`). Units and patches came out of SDCC's 32-bit C
  moved to assembly (`Find`, `StepVar`, `FileOf`, `EmitFile`), `Link`,
  `Relocate`, `Fill`, `Header` and `Log` moving to LINK.MOD, and code moved to
  the page that calls it (`Char` beside the string code, `DS ALIGN`'s beside
  `Ds`, `CloseSection` beside `Section`).
- **32-bit arithmetic** is hand-written assembly on the device: SDCC's `long`
  code took `Apply` alone to 1.6 KB. `Apply` (every binary operator) and `Div`
  (unsigned, for `FOR` counts and `{}` digits) work on two 4-byte registers in
  `asm_math.c` (in both modules); `Digit` (`num * base + d`, for every digit read) is in `asm.c`.
  The C beside each is the PC harness's, which `test_asm.py` checks against
  RGBDS; `values.asm` runs both in Gearboy.
- **Host** (`src/editor/build.c`, page 13, `FileWriteImage` and `fs_LoadFile`
  in `fatfs.c`): saves, runs ASM.MOD with an `AsmContext` (length in; line,
  position, file, symbols back), then LINK.MOD with it (blocks back; the
  error's place when it's the link's; `RunModule` keeps the clock going for
  it and BUILD keeps `file_level`), shows the result in a box, writes the blocks
  with `f_write` straight from the window, then `LaunchGame` for RUN.
- **Progress:** every 64 lines (and as each file starts) `Progress`
  (`asm_progress.c`) puts the pass, a count and where it is (`ReportWhere`: file
  and line) in the context and calls `ModProgress(0)`. The host draws at most
  every 5 s, so a build under 5 s never pays for it, and its `BuildProgress`
  (bank 1) writes the box: for a document `Pass 1: 45k lines` (pass 1 can't know
  the total; 64-line steps / 16, 2% short) and `Pass 2: 47%` (of pass 1's
  lines), for a project `Assembling: 47%` (of its units' passes), then the
  file's name and `line n`, and the time since BUILD (`m:ss`). While a file is
  found and read the host draws too, between its sectors, with the file's name
  and `loading`; LINK.MOD's `Phase` shows `Placing sections` and `Finishing`. So the time moves every 5 s whatever the build is doing: if it
  stops, so has the build. A draw between sectors is the deepest the OS stack
  gets (module, `ModLoad`, `FileSearch`, `FileTry`, `fs_LoadFile`,
  `ModuleAPIProgress`, `EditorDraw`, `RenderRow`): `FileTry`'s path is in
  `buffer`'s upper half, not on the stack, which with it ran past `stack_top` into
  `module_wide` (the next draw then went over the module's BSS). A full beisbol
  build leaves 117 bytes of the stack unused; `run_build.sh` checks 64 stay. A draw costs about 30 frames on DMG (the buffers
  swapped four times and the box's rows drawn again), ~10% of a long build there
  and ~5% on CGB.
- **A failed copy stops the build.** If a draw's copies don't read back (8 tries
  a block), `ModuleAbort` backs out of the module to `RunModule` (its stack and
  far-call depth from `ModuleEnter`) and BUILD says `COPY FAILED op:block` in the
  status bar, with the editor's text intact (left in place if its backup is the
  copy that failed). Before, that restarted the device, and a beisbol build on a
  GBA SP stayed frozen on its progress box for most of an hour (2026-11-13;
  Gearboy builds it through, so the cause is unconfirmed).
- **build.log** (LINK.MOD's `Log`): written beside `project.gbp`, or the
  document, after every build that ran (not after `COPY FAILED`): the output,
  the time assembling (with the lines read in all passes, approximate to 64, the
  units, and the card's share and files) and linking (with sections and
  patches), the total, PSRAM copies retried (both modules), and `built n KB` or
  `stopped: file line n: ERROR`. Times come from `ModStat`
  (seconds counted by the host from `render_frames`, 60 a second: 0.5% slow); the
  text goes to `ASM_LOG_BLOCK` and the host writes `context.log_bytes` of it with
  `FileWriteImage` (bit 15 of its count).
- **Card check** (2026-11-18): after a build that stopped, BUILD runs PREP.MOD again
  with `ASM_CHECK`. It reads each file in ASM.MOD's files table (up to 128) from the card
  again into the ROM image's blocks, compares it with the copy that was assembled, twice,
  and adds to build.log:

  ```
  card check:
    src/hardware.inc: 3 bytes differ, then 3, first at $000a3c line 70: 2c, card 20
    58 files read again from the card, 1 differ
  ```

  The same count twice means the PSRAM copy is damaged (on its way from the card, or since).
  Different counts mean reads of it come back different. Nothing differing points at the
  assembler, or at PSRAM it doesn't check (symbols, heap, macros). It's there for hardware
  builds that stop at random early in the prelude (GBA SP, DMG, SGB and GBC, 2026-11-18:
  `BAD INSTRUCTION` in hardware.inc's version macro, `VALUE TOO BIG`, `TOO DEEP`, with PSRAM
  copies retried 7 times in 38 s), where Gearboy builds the same card state through. A real
  error costs the re-read: ~24 s for 82 files on CGB.
- **No SDCC helpers:** `*` `/` `%` are shift loops; numbers scale by shifts.
- `tests/asm_host.c` builds the same sources for the PC with 16-bit ints
  (`-Dint=short`), a 16 MiB PSRAM array and includes from the source's folder,
  so `tests/test_asm.py` can diff against RGBDS without an emulator. It runs
  LINK.MOD's `ModuleMain` (as `LinkMain`, its two files one object whose other
  names are local) after ASM.MOD's; `ASM_HOST_STATS=1` prints how full the
  PSRAM regions got.

## Errors

| Code | Message | Meaning |
| --- | --- | --- |
| 1 | SYNTAX ERROR | unexpected character, missing `,` `]` `)` `"`, unclosed `IF`/`REPT`/`MACRO` |
| 2 | UNKNOWN SYMBOL | undefined in pass 2, or (the link) no unit defines or `EXPORT`s it |
| 3 | ALREADY DEFINED | label, `EQU` or macro twice; a label in two units, a section name in two (not `FRAGMENT`s of one type) |
| 4 | VALUE TOO BIG | operand outside its range |
| 5 | JR TOO FAR | |
| 6 | BAD OPERAND | no such form of the instruction |
| 7 | NO SECTION | code or label outside a section, data in RAM |
| 8 | SECTION FULL | past the region's end, outside it, or no room to place it |
| 9 | NOT YET DEFINED | `DS`, `SECTION`, `REPT`, `IF` or a constant needs a later symbol, or one only the link knows |
| 10 | NOT SUPPORTED | a known directive this assembler lacks |
| 11 | NAME TOO LONG | over 32 characters |
| 12 | DIVIDE BY ZERO | |
| 13 | BAD INSTRUCTION | not a mnemonic, directive or macro |
| 14 | PHASE ERROR | assembler bug: a label moved between passes |
| 15 | BAD STRING | unterminated, a bad escape, or a string over 256 bytes |
| 16 | NO GLOBAL LABEL | local label before any global one |
| 17 | TOO MANY SYMBOLS | a unit's symbols past 384 KiB, the prelude's past 120 KiB, or the link's names past 384 KiB |
| 18 | NO CODE | nothing in ROM |
| 19 | BAD BANK | wrong bank for the region, ROMX bank 0 or > 63, `ALIGN` > 13 |
| 20 | ASSERT FAILED | `ASSERT` false or `FAIL` |
| 21 | NO SUCH FILE | `INCLUDE` or `INCBIN` can't read it (or it's empty) |
| 22 | TOO DEEP | nesting, arguments, 16 includes, 8 `PUSHS`, 512 sections or 63 units exceeded |
| 23 | SECTIONS OVERLAP | two sections with addresses overlap |

The link's errors (UNKNOWN SYMBOL, VALUE TOO BIG, JR TOO FAR, ASSERT FAILED,
ALREADY DEFINED, SECTION FULL, SECTIONS OVERLAP) are reported at the line of the
instruction, data or `ASSERT` that needed the value, or at the `SECTION`.
Module load failures show the usual MODULE MISSING / DAMAGED / NEEDS NEWER OS.
Results show in a box in the middle of the editor (`ShowBox`): the file's whole
name (wrapped at 19 characters), `Line <n>` and the message, or the ROM's name and
`Built <n> KB`. The symbol count is only in `AsmContext`.

## Timing

Gearboy, from the keypress to the message (`tests/run_build.sh` prints these):

| Source | DMG | CGB |
| --- | --- | --- |
| `hello.asm` (1 KB, 32 KiB ROM) | 733 frames (12.2 s) | 357 frames (6.0 s) |
| `features.asm` with two includes | 862 frames (14.4 s) | 420 frames (7.0 s) |
| `strings.asm` | 808 frames (13.5 s) | 396 frames (6.6 s) |
| `loops.asm` | 755 frames (12.6 s) | 368 frames (6.1 s) |
| `gbdk.asm` with `memory1.asm` and `hardware.inc` (52 KB of source) | 3,652 frames (61 s) | 1,717 frames (29 s) |

About 55 / 28 frames of each are the card write; loading and swapping the five
pages plus the WRAMX region is about 300 on DMG, and LINK.MOD's two pages about
200 more (2026-11-18: before LINK.MOD, `hello.asm` was 517 / 251 frames and
`gbdk.asm` 3,051 / 1,481). Two routines are hand-written
assembly on the device because every character or statement goes through them:
`Advance`'s fast path (a pointer and count for the run of bytes left in the
current chunk or PSRAM block; anything that moves the window or the frame stack
drops it, and `{`, line feeds and macro backslashes take the C path) and
`Keyword`. With fewer far calls they took `gbdk.asm` from 7,397 frames to 2,766
with three pages; the fourth page and `EQUS` cost ~290 more. With five pages
and 32-bit values it's 3,425 on DMG and 1,625 on CGB: `Mul` stops when the
multiplier runs out and `Div` skips the dividend's zero top bytes, without which
578 `Apply` calls cost 6% of the build.

An instruction profile of that build (Gearboy stepped one instruction at a time,
PCs mapped through `GBCOS.sym` and the module's `module.sym`), 28M instructions:
`Advance` 15%, `Keyword` 7.5%, `AdvanceSlow` 7%; far calls 8% (33,000, nearly all
from `asm_line.c` on page 5 to the lexer on page 13: `Space`, `Keyword`, `Line`,
`ReadIdent`, `IsStart`, `AtEnd`); loading and checking the five pages 13%
(`mem_Copy`, `ModuleCompare`, `ModuleCRC`); `Header`'s checksum 3.5%; `Find`
2.8%.

## Tests

- `python3 tests/test_asm.py`: builds the PC harness and compares with RGBDS
  byte for byte: every `tests/asm/*.asm` (`instructions.asm`, every instruction
  form; `directives.asm`, data, expressions, locals, banks and RAM sections;
  `features.asm`, includes, guards, `IF`/`ELIF`, `REPT` with `\@`, macros with
  `\@`, `_NARG` and `SHIFT`, RS counters, fixed point, indented labels;
  `strings.asm`, every string function, format and `EQUS` use including a macro
  built from a string and `PURGE`; `loops.asm`, `FOR` (nested, negative step,
  none) and `INCBIN`; `hello.asm`), FatPak's `math.asm`, `memory1.asm` and
  `gbdk.asm`; `sections.asm` (`FRAGMENT`, `PUSHS`/`POPS` with scopes, `DS ALIGN`
  in floating, aligned, fixed and RAM sections, `ALIGN` offsets); `loops.asm`
  also `INCBIN`s 1.5 KB at odd offsets into an odd address, and to a bank's end
  (`EmitFile`'s runs); `values.asm`
  (32-bit constants, `DL`, beisbol's `D24`/`D32`, signed `/` `%` and shifts at
  their edges, comparisons, 16.16 literals, `FOR` past 16 bits, `{}` formats of
  32-bit values); projects (`project.gbp` with defines and rgbfix options,
  built from a markdown file two folders down, against `rgbasm`/`rgbfix` with
  the same options; ten errors at their lines), units (three files with a `-P`
  prelude: their own constants, macros and `\@`, an `EXPORT`ed constant, labels
  and `FRAGMENT`s across them (aligned, with `DS ALIGN`), a prelude variable,
  constant and charmap one unit changes and the next doesn't see, and what only
  the link knows: other units' labels in operands, `BANK()`, `HIGH()`/`LOW()`,
  `~`, `-`, differences, `rst`, `ldh` to HRAM, `dl`, `Global.local`, a `jr` to
  another section and `ASSERT`; against `rgbasm -E -P` per file and `rgblink`;
  then eight errors only the link finds, each at its file and line; then
  `build.obj`: built again unchanged (up to date), with the ROM deleted (0 of
  3 units assembled, linked again), with one unit grown (1 of 3, the others' sections moved), with the prelude edited (3 of 3),
  each against RGBDS, and a link error in a kept unit named by its file and
  line; the PC harness makes up directory entries from each file's size and
  time, its inode for a sector), 150 random
  section layouts (with fragments, offsets and `DS ALIGN`) whose labels and banks
  go in a fixed table, and 400 ROMX sections. Then each error code's line and
  position.
- `tests/run_build.sh` (DMG, CGB): runs `test_asm.py`, then in Gearboy opens a
  file in the editor and uses FILE > BUILD (message, matching `.gb`, page 12 and
  the editor view restored, timing), an error (line and cursor, no `.gb`), BUILD
  on a `.txt`, FILE > RUN up to `GameLaunch`, `features.asm`, `strings.asm`,
  `loops.asm`, `charmap.asm`, `sections.asm` and `values.asm` (the assembly
  arithmetic) with the `lib/` folder matching RGBDS, `tests/asm/project` built
  from a markdown file (its ROM as `rgbasm`/`rgbfix` make it with the same
  options), errors in an included open document and in `project.gbp` (box,
  cursor), its highlighting, the three units (only they exercise the assembly
  `Find`'s unit tags), an error inside an included
  file, and `gbdk.asm` with `memory1.asm` and `hardware.inc` unmodified.

## beisbolgb

The goal: build `../beisbol/beisbolgb` on the device. Its Makefile runs one
`rgbasm -D _DEMO -D LANG_EN src/main.asm`, then `rgbfix -jvcs -k 01 -l 0x33 -m 0x1B
-p 255`. A PC probe (`tests/asm_host.c` on a scratch copy, with the defines in a
two-line prelude and limits raised) worked through it as far as it could:

| Need | beisbol | Status |
| --- | --- | --- |
| `CHARMAP`, `NEWCHARMAP` | 176 entries | done |
| `INCLUDE "src/..."` from `src/main.asm` | every include | done (folders above the document) |
| A file ending without a line feed | `math.asm` | done |
| `\{`, `\}` in strings | `charmap.asm` | done |
| `cpl a`, `stop n` | `kb_handlers.asm` | done |
| Names over 32 characters | macro names, map constants (65) | done (79) |
| Nesting over 10 frames | `tile_anim.asm`: `FOR`/`FOR`/macro/`REPT`/macro/`REPT` | done (16) |
| Paths over 48 characters | `INCBIN` of tilemaps (67) | done (127; the symbol is the last 79) |
| Hundreds of files | 444 sources (2.0 MB), 675 `INCBIN` files (187 KB) | done: packed in PSRAM (about 5 MiB), read once |
| Files over 64 KB | `player_data.asm` 200 KB, `Overworld.gbmap` 245 KB, `Mountains.gbmap` 122 KB | done: 32-bit positions |
| More than 64 sections | 379 | done: 512, the table in PSRAM, 16-bit section numbers |
| `DS ALIGN[n]` | `tile_anim.asm` | done |
| `SECTION FRAGMENT` | 13, C output (`_announcer.asm`) | done |
| `PUSHS`/`POPS` | 6 | done |
| 32-bit values | `D24`, `D32` (item costs) | done |
| `-D` defines, `rgbfix` options | `_DEMO`, `LANG_EN`; `-jvcs -k 01 -l 0x33 -m 0x1B -p 255` | done: `project.gbp` |
| Units | split into 50 (`rgbasm -E -P src/beisbol.inc` each, then `rgblink`) | done: `main` with several files |
| Speed | ~1.1 MB of units read twice, 110 KB of prelude once, ~630 KB of `INCBIN` | 24.0 minutes on CGB in Gearboy; 2.4 s again unchanged, 1:53 with a unit edited (`build.obj`) |

With a `project.gbp` (the one under Using it) beside an unmodified copy, the
PC harness builds it from any file in it byte for byte as the Makefile's `rgbasm`
and `rgbfix` do. Before that, with sections and 32-bit values done, the PC
harness assembled an unmodified
copy (only the two defines added at the top of `main.asm`) in both passes: a
512 KiB ROM, 12,634 symbols, byte for byte what `rgbasm -D _DEMO -D LANG_EN` and
`rgbfix -v -p 0` make. In Gearboy (CGB), FILE > BUILD on the same
copy writes a ROM identical to RGBDS's in 149,220 frames: 42 minutes with the
progress box and 32-bit values (140,340 without either), so DMG would be over an
hour. The first such run found the one device-only difference: 70 of
its paths start with `./`, and FatFs has no relative names (`FF_FS_RPATH` 0), so
`OpenFile` drops a leading `./` (the PC harness now refuses `.` and `..` like
FatFs does).

**The split** (beisbolgb `49909c4`, 2026-11-16): 50 units with the
`project.gbp` under Units above (all 50 files on its `main` lines, in the
Makefile's `ASM_SOURCES` order). The PC harness and Gearboy (CGB) both build it
byte for byte as the Makefile's `rgblink` and `rgbfix` do. Gearboy, 2026-11-18,
88,891 frames from the keypress (24.7 min); again, through `build.cache`, 84,567:

```
beisbol.gb from project.gbp
pass 1      12:04   ~14464 lines
  card       1:37   393 files found and read, 0 through build.cache
sections     0:34   295
pass 2      11:28   ~14464 lines
finishing    0:27
total       24:33
```

```
pass 1      10:52   ~14464 lines
  card       0:23   394 files found and read, 392 through build.cache
pass 2      11:28   ~14464 lines
total       23:20
```

With the up-to-date check and the faster link (2026-11-18): the full build is
86,611 frames (24.1 min, linking 1:31), and again with nothing changed 146
frames (2.4 s): PREP.MOD reads `build.obj`'s head and 348 directory entries,
and `build.log` says

```
beisbol.gb from project.gbp
up to date: nothing changed since it was built
```

With one small unit edited (a 51st, saved from the editor), 1:53 from the
save to the message, the ROM rgblink's (the full build 86,290 frames, 24.0
min, linking 1:27):

```
assembling    0:56   ~3776 lines, 1 of 51 units
  card        0:02   33 files found and read, 31 through build.cache
linking       0:57   296 sections, 12039 patches
total         1:53
```

Assembling is ~15 s of PREP.MOD loading all of `build.obj` (the card's read
speed), ~35 s of the prelude (3,776 lines, mostly the lexer) and the
snapshot's copy; the link is above.

Before the check, with `build.obj`, the same build again with nothing changed:
7,504 frames (2.1 min), the ROM rgblink's (with the ROM deleted it's still
that, linking 1:15 now):

```
assembling    0:17   ~0 lines, 0 of 50 units
  card        0:00   3 files found and read, 1 through build.cache
linking       1:40   295 sections, 12039 patches
total         1:57
```

A full build is 24.9 minutes: putting `build.obj` together adds ~50 s to the
link. With each unit assembled alone and LINK.MOD, before `build.obj`, 85,861
frames (23.9 min), the ROM again rgblink's:

```
beisbol.gb from project.gbp
assembling   22:14   ~25088 lines, 50 units
  card        1:37   393 files found and read, 0 through build.cache
linking       1:30   295 sections, 12039 patches
total        23:44
```

The prelude is read once instead of twice; the link (placing, labels, patches,
the image and checksums) is 1:30 against the old 1:01 of placing and finishing.
The rest is parsing: each unit is assembled twice every build. Before the split
(one `main.asm`), Gearboy (CGB), 2026-11-13:

```
beisbol.gb from project.gbp
pass 1      24:54   ~24576 lines
  card      11:05   1043 files found and read
sections     0:33   292
pass 2      15:57   ~24576 lines
finishing    0:27
total       41:51
PSRAM copies retried: 0
built 512 KB
```

## Next steps

1. **Faster edits** (1:53 for one small unit), each a redesign: the prelude's
   state kept in `build.obj` (its files' text sits where the units loaded
   before it, so it would have to move, and ASM.MOD has ~340 bytes free);
   per-unit object files, so `Compose` needn't copy the unchanged ~940 KB (or
   a gathering write in the host); multi-block SD reads (CMD18) for every
   load; local labels kept out of the link's names (4,000 of beisbol's 7,743,
   but 150 patches name one).
2. **Hardware pass** for `EQUS`, `FOR` and `INCBIN` with the `Asm` folder.
3. **Speed** (the profile above): five module loads and swaps are the biggest
   fixed cost for small files; a cached backup compare (MODULES.md) or keeping
   the module installed across builds would help. For big sources: the far
   calls from `asm_line.c` to the lexer (moving `Statement`'s hot path next to
   it, or the lexer helpers it calls most into page 5 too), `Keyword` indexing
   its tables by length, comment lines skipped in assembly.
4. **Language:** compound assignment (`+=` ...), `**`, `>>>`, `LOAD`, `UNION`,
   anonymous labels, `STRFMT`, a symbol listing to a file. Page 15 is the last
   OS page a wide module can borrow (every other one holds FatFs or its callers),
   so further room has to come from smaller code.
5. **Large sources:** assemble a large document from its file on the card.
