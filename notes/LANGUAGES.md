# Languages

The UI's text is data, not code: every string lives in `data/strings/strings.csv`
with a column per language, and the OS reads the loaded language from PSRAM.
SETTINGS > LANGUAGE (editor and browser) picks one; it's a setting, so it survives
a restart and travels in the swap file. Languages: English (`en`, the fallback)
and Spanish (`es`).

## Adding or changing a string

`data/strings/strings.csv` has `key, kind, comment` and then a column per
language, `en` first. A row's key becomes `S_<KEY>` in `src/strings.h`, numbered
in CSV order: a menu is a run of consecutive rows, passed to `Choose` as its first
id and a count, so keep those runs together (the comment says which). An empty
cell falls back to English.

- `{}` marks where the code puts something (a number, a name). Every language has
  the same number, in the same order. `S_PART(S_X, n)` is the text after the nth
  `{}`, up to the next, so `"Line {}, Col {}"` is built as part 0, a number, part 1,
  a number, part 2.
- `<A> <B> <SELECT> <START> <LR> <UD> <DPAD> ...` are the button icons
  (`src/ui/icons.h`).
- The text is Latin-1. The VWF font has the accented letters (the capitals Á É Í
  Ó Ú Ñ Ü are first drafts: the base letter and a 1-pixel accent on the empty top
  row).

`scripts/strings.py` refuses a string that doesn't fit where its kind is shown:

| Kind | Where | Limit |
| --- | --- | --- |
| `item` | a menu line, a box line in a module | 18 characters |
| `box` | a box line (titles, busy text, build results and errors) | 19 characters |
| `bar` | the status bar, beside the clock | 111 pixels (VWF widths) |
| `row` | a text row in a module | 39 characters |

Every string is at most `LANG_MAX` (47) characters, `Str`'s buffer. Help screens
are `data/help/<name>.txt` (English) and `data/help/<name>.<lang>.txt`: 32 lines,
under 32 bytes and 152 pixels each.

A new language is a new CSV column (its two-letter code as the header), its help
files, and a row in the `LANG_*` run whose text is the language's own name in
every column. `make assemble` writes `bin/LANG/<CODE>.DAT` and copies them to
`/GBCSYS/LANG/` on the card.

## How it works

`scripts/strings.py` writes `src/strings.h` (ids, `STR_HASH` of the key list,
`LANG_CODES`) and one image per language: a header block (`FPKL`,
`LANG_VERSION`, the hash, the string count), the two help screens (4 blocks, in
`DATA_HELP`'s layout), then an offset per string and the strings, 0-terminated,
each `{}` a `$1F`. English is also appended to `EDITOR.DAT`, after its
`DATA_BLOCKS`.

At boot, after `EDITOR.DAT`, `LoadLanguage` (`src/app/language.c`) copies the
setting's image to PSRAM at `LANG_BLOCK` (`$3CA4`, 28 blocks, between the
snapshot staging and `MODULE_STAGE5`) with `fs_LoadLanguage`, which refuses a file
whose hash doesn't match the OS's strings. If `/GBCSYS/LANG/<code>.DAT` doesn't
load, English comes from `EDITOR.DAT` and the status bar says so. Without
`EDITOR.DAT` there are no strings: the OS says `NO EDITOR.DAT` (one of the two
strings left in ROM, with the boot's `Loading...`).

- `PutStr(dest, id)` (`src/strings.asm`, ROM0) copies the string, or an `S_PART`
  piece, and a 0 to `dest`, returning the 0's address, so it chains like
  `PutText`. It saves and restores the PSRAM window and its PSRAM/save RAM bit.
- `Str(id)` copies it to `str_text` (WRAMX, past the wide modules' BSS) and
  returns that: for calls that take text (`ShowMessage`, `ShowBusy`,
  `DrawRow`). It's valid until the next `Str`.
- Modules use `ModString(dest, id)` (ABI 9), the same as `PutStr` into their own
  memory; `modules/lib/text.c` has a `Str` of its own.
- HELP.MOD reads the help through `ModData` at `DATA_HELP` as before; the host
  serves those blocks from the loaded language.

A lookup is two window switches and a short copy, a few hundred cycles; strings
are read when a menu, box or message appears, never per frame. The literals it
replaced cost about what the calls do, so it's no smaller: the OS pages and ROM0
lost about 380 bytes, mostly to `PutStr` and the language code.

## Not translated yet

- The in-game menu (`scripts/ingame_menu.py` draws its labels into tiles at build
  time): per-language tiles in the language image, copied before a game starts.
- The keyboard test's PS/2 error names are short words; the error names of
  ASM.MOD's results are translated, the assembler's own text (none) isn't needed.
- Dates and the clock keep their format.
