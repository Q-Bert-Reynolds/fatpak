# Building a game on a Game Boy

[Architecture](ARCHITECTURE.md) · [Modules](MODULES.md) ·
[Compiler](COMPILER.md) · [Assembler](ASSEMBLER.md) ·
[Image viewer](IMAGE_VIEWER.md) · [EverDrive](EVERDRIVE.md)

Goal: create, edit, build and play a game entirely from a Game Boy running
FatPak, with the SD card as the project disk. The reference is
`~/Projects/beisbol/beisbolgb`. Success means regenerating its assets from
editable sources, compiling its C, assembling/linking its units and running the
result without a PC. Rebuilding checked-in generated assembly is an intermediate
milestone; it does not close the asset-authoring loop.

This is a development suite around the game's existing engine. It does not
require replacing beisbolgb's renderer, map runtime, GBT Player, sound driver or
game logic with a new universal engine. Preserve their formats and behavior
first; extract reusable tools and libraries as experience warrants.

Only this planning document is introduced here. Names below are proposals, not
installed tools or reserved module IDs. Hardware and storage limits must be
measured in prototypes before finalizing formats and application boundaries.

## What the reference actually builds

The inspected checkout has 267 PNGs, 44 GIFs, six music `.mod` files, three
FX Hammer `.sav` banks, sixteen CSV files and five `.gbmap` files. These counts
are an inventory snapshot, not limits. Images include indexed, grayscale,
grayscale-with-alpha, RGB and RGBA sources; handling only indexed PNG would not
cover the reference.

| Editable source | Current producer/exporter | Required game outputs |
| --- | --- | --- |
| `img/**/*.png` | `img2rgbds.py` | `.tiles`, single `.tile`, `.tilemap`, `.propmap`, assembly labels/constants; shared tilesets for image folders |
| `img/**/*.gif` | `img2rgbds.py` | Shared animation tiles, per-frame tilemaps, assembly; special `_2x` expansion |
| Player portraits and batting/pitching animations | `roledex.py`, `asset_utils.py` after image conversion | Six player-image groups, default animation pack, player-animation pack, image constants and references |
| `img/**/*sgb_border.png` | `sgb_border.py` through image conversion | SNES-format border tiles/map/palettes and assembly/binary wrappers |
| `maps/*.gbmap` | Sibling Unity `gbmapeditor` | Map headers, palettes, strings, doors, chunks, object references, items, areas, tile animations and graphics references |
| `.gbstamp`, `.gbavatar`, `.gbms` | Unity stamp/avatar/metasprite exporters | Reusable stamps, directional avatar animation references, initial sprite poses and subsequent frame changes |
| `music/*.mod` | `mod2gbt.py` invoking `mod2gbt.c` | GBT Player pattern/order data as `.asm` plus compact `.bin` |
| `sfx/*.sav` and optional `.txt` names | `fxhammer.py` | Named effects, priority/channel headers, timed CH2/CH4 entries and lookup macros |
| `roledex.csv`, `learned_moves.csv`, `taught_moves.csv` | `roledex.py` | Player stats, names/descriptions, learnsets, compatibility bits, graphics linkage and constants |
| `moves.csv`, `items.csv`, `teams.csv` | `moves.py`, `items.py`, `teams.py` | Data, strings, IDs, coach/team/lineup records and conditions |
| `data/strings/*_strings.*.csv`, `src/charmap.asm` | `translate.py` | Language-selecting assembly/includes and C headers with encoded/wrapped text |
| `src/constants.asm` | `build.py` | C constants header |
| C, handwritten assembly and project settings | SDCC, RGBDS, Makefile / `project.gbp` | Configured ROM and symbols |

`generate_assets.py` currently runs constants, music, SFX, images, moves, items,
roledex, translations and teams. **It does not run `maps.py` or Unity.**
`maps.py` constructs the map directory/include assembly; it does not turn a
Unity scene into a map. Replacing only the Python build scripts would leave
world authoring dependent on a PC.

The `.gbmap`, `.gbstamp`, `.gbavatar` and `.gbms` files inspected here are RGBDS
text, not opaque binary or JSON. `Overworld.gbmap` is about 245 KB of source
describing about 7 KB of runtime data. A graphical editor therefore needs a
streaming importer or a compact editable representation, rather than loading
the assembly text into the existing 65,024-byte text buffer.

## Division between FatPak and standalone applications

FatPak should own projects, SD access, source text, builds, diagnostics and
durable saves. Small viewers/forms can be modules. Full visual editors and
continuous audio playback should run as standalone `.gb`/`.gbc` applications,
with their own display, interrupts, memory layout and banked code.

| Proposed component | Form | Responsibility |
| --- | --- | --- |
| Project hub | Host orchestration, optional `PROJECT.MOD` UI | Asset browser, dependency status, editor launch, build/run, validation report |
| `TILEVIEW.MOD`, `HEXVIEW.MOD` | Existing modules, extended where useful | Quick inspection of generated graphics and binary data |
| `IMAGE.MOD` | Batch module(s) | PNG/GIF import/export and Game Boy graphics compilation; split codecs if needed |
| `WORLD.MOD` | Batch module(s) | Import/export/validate maps, stamps, avatars, metasprites and animation tables |
| `MUSIC.MOD`, `SFX.MOD` | Batch modules | MOD-to-GBT conversion and FX Hammer-to-game SFX conversion |
| `DATA.MOD`, `TEXT.MOD` | Modules, split by size | Game tables, constants, translations, charmap encoding and validation |
| `PACK.MOD` | Batch module | Packed graphics, pointer tables, assembly wrappers and bank-size checks |
| `PIXEL.GBC` | Standalone dual-mode application | Pixels, tiles, palettes, fonts, image compositions and SGB border workspace |
| `ANIM.GBC` | Standalone dual-mode application | Frame/tile animation, metasprites, avatar poses and timing |
| `WORLD.GBC` | Standalone dual-mode application | Chunked maps, stamps, collisions, doors, objects, areas and events |
| `MUSIC.GBC` | Standalone dual-mode application | Four-channel tracker with GBT-compatible preview |
| `SFX.GBC` | Standalone dual-mode application | FX Hammer-compatible effect editing and game-driver preview |
| Table/translation forms | Small modules initially | Record-oriented editing of CSV sources with reference pickers and text preview |
| `CC.MOD`, `ASM.MOD`, `LINK.MOD` | Compiler/assembler plan and ongoing work | Code compilation, assembly, placement and ROM finalization |

These are logical responsibilities, not a requirement for one binary per row.
Share pixel widgets between pixel/animation/world applications and the audio
core between music/SFX applications. Combine applications only when measured
load time, memory and interface complexity justify it. Every standalone editor
must create a new asset as well as open an existing one.

Current modules run synchronously, cannot nest, and have tight page/BSS budgets.
Wide modules borrow editor rendering buffers and cannot host an ordinary live
canvas or tracker screen through the existing UI path. They are suitable for
batch conversion with progress reporting; the host runs stages sequentially
after modules return. New file services require an ABI audit, particularly for
wide-module writes that reach paged FatFs helpers. The initial converters can
return PSRAM output descriptors for host-side writes.

## Shared application launch and save protocol

Implement this before five separate editors. Under the normal game launch path,
an application must not assume it retains the OS's SD/PSRAM register access.
Use MBC5 cartridge SRAM as an explicit exchange workspace, with FatPak staging
input and committing returned output. A future application mode retaining SD
access is a separate architecture project, not a prerequisite assumed here.

1. FatPak saves editor state and backs up the current cartridge-RAM owner's save
   through the existing ownership machinery. It records a pending editor session
   on SD before changing SRAM or launching the tool.
2. The host imports the requested asset and its dependency subset into a bounded,
   versioned exchange package. It stages the application ROM and then prepares
   exchange SRAM in an order that prevents ordinary game-save loading from
   overwriting the package. The generic launch path needs an explicit tool mode.
3. The application reads the package using normal MBC5 RAM banks and edits it.
   Its code, immutable libraries and preview engine live in ROM; editable state
   and recovery information live in SRAM. It has no arbitrary filesystem access.
4. Save marks a complete result in SRAM. Return uses the established cartridge
   menu/unlock path or a tested application-return service. A plain write to an
   OS register followed by a jump to `WarmMain` is not an assumed public API.
5. On warm return or next boot, FatPak recognizes the pending session before
   treating SRAM as an ordinary game save. It validates the result, converts it
   to project sources, commits files and updates dependency state.

Specify magic/version, session ID, application and asset type, document revision,
bounded input/output directories with offsets/lengths, status, checksums and a
commit generation. Paths stay in the host's session record; returned descriptors
identify authorized project assets. Reject stale sessions, unsupported versions,
out-of-bounds lengths and partial commits. Distinguish Save, Cancel, checkpoint
and valid-but-uncommitted recovery states. Double-buffer commit metadata and
validate payloads; do not promise atomicity for an entire multi-bank SRAM write.

At most 128 KiB of cartridge RAM is a reasonable initial exchange target for
these tools, subject to verification on the supported EverDrive hardware. Count
headers, dependencies, undo and output against that budget. A raw 256×256 4bpp
border consumes 32 KiB before palettes/maps; a large tracker file or world may
need more than one session. Never reserve bank 0 blindly as a whole header bank.

Use compact tiles/objects/patterns, bounded undo journals and selected chunks or
patterns. A file larger than the workspace remains editable through explicit
work-unit checkout: select in FatPak, edit, return/save, then load the next unit.
Operations needing an unavailable dependency return a request to the host.
Explain this workflow in the interface; do not silently truncate an asset.
Both Save and Save & Continue can return briefly to FatPak to commit and relaunch.

Tool sessions need their own save namespace and must be insulated from game
cheats, automatic save-state loads and same-basename save collisions. Test power
loss during staging, editing, return and commit, and retain a recoverable prior
revision. Saving editor state is not saving the asset. The PNG viewer proposal
in `IMAGE_VIEWER.md` is useful background, but its launch/return and memory sketch
must be verified rather than copied as an implemented editor protocol.

## Source formats and desktop interoperability

Keep original PNG/GIF, tracker MOD, FX Hammer SAV, CSV and map exports importable.
The game must continue to consume its existing runtime formats. Initially target
equivalent output for the checked-out reference, including established symbols,
IDs, bank requirements and ordering. Make ordering explicit: filesystem directory
enumeration is not a stable ID or tile-number assignment scheme.

For new editing, use versioned compact documents where they make the device
practical: indexed pixel planes plus palettes; animation frame/pose records;
chunk/object map documents. Extensions and schemas are to be decided after a
prototype. Each logical asset has one declared source of truth. If a native
document becomes authoritative, record that in the project; do not leave both
its PNG and native representation competing to regenerate each other.

Separate editable sources, preview intermediates and generated game outputs.
Export desktop-friendly PNG/GIF/CSV/MOD/SAV and RGBDS map text through explicit
commands or declared build steps. Import/export must preserve semantics or
report unsupported features. Unity scene hierarchy, prefab links and editor-only
metadata cannot be reconstructed reliably from runtime exports; native world
documents replace that authoring dependency. Textually preserve unknown assembly
blocks when possible and refuse destructive graphical rewrites otherwise.

## Pixel, palette and font tools

`PIXEL.GBC` needs a zoomed pixel grid, full-image preview, pencil/eraser, fill,
line/rectangle, selection/copy/paste, flip/rotate, tile picker and undo. Support
multi-tile images and shared tilesets, not just individual 8×8 tiles. Fonts and
small UI graphics use the same editor with a glyph grid and game charmap labels.

Maintain palette indices explicitly. The current converter groups indexed PNG
colors into fours, reverses shade bits, reuses tiles, treats map/font/simulation
graphics specially, and shares tiles by folder. Match these rules through
named import/export profiles before offering alternative quantization. Preserve
tile numbers for maps, fonts and effects that refer to fixed indices. A tile
deduplication or reorder operation must update dependent maps/stamps/animations
or be rejected.

Provide DMG shade preview and CGB color/attribute preview, including transparency,
flips and sprite priority where applicable. Game-specific palette storage may
omit implicit colors; use adapters instead of assuming every table stores four
full RGB values. On DMG, edit RGB channel values numerically and show labeled
swatches/shades; color work should not require owning a CGB.

The image importer must cover all PNG modes used by the reference and GIF frame
compositing/disposal. Use PSRAM-backed codec state in host converters where
needed. CGB does not provide a contiguous spare 32 KiB WRAM buffer for DEFLATE:
do not assume a general PNG decoder can fit its history there, especially on
DMG. Port a bounded codec and test the actual files before promising arbitrary
image support. Export can start with simple valid PNG encoding; JPEG/video and
general photo editing are outside the reference requirement.

## Animation and metasprite tools

`ANIM.GBC` needs two related modes:

- Image animation: duplicate/reorder frames, onion skin, timing/loop controls,
  a shared tile budget and preview of default/player-specific batting/pitching
  variants. Cover all eight handedness/user/opponent combinations, portrait
  linkage and `_2x` graphics expansion used by the exporters.
- Sprite/stamp animation: compose parts with signed coordinates, tile/attribute
  fields, directional poses and frame timing. Export `.gbms` initial poses and
  frame-change records, `.gbstamp` animation data, and `.gbavatar` directional
  references matching the runtime.

Do not infer runtime timing from GIF delays alone: inspect the game's animation
consumers and preserve their actual timing convention. Preview tile streaming,
sprite count and per-scanline pressure, with a way to show expected hardware
dropout. Warnings should identify the offending frame and scanline.

Also edit background tile animations: the reference defines linear, scroll,
sine and texture types, with a current runtime limit of four active entries.
Expose tile target, type, speed and data/reference fields with validation;
playing a GIF is not a substitute for editing these tables.

## Maps, stamps, areas and events

`WORLD.GBC` should model beisbolgb's chunked world rather than a single flat
tilemap. Import the five reference maps and their shared assets through
`WORLD.MOD`. Use the sibling
`gbmapeditor/Assets/Scripts/Editor/GBMapEditor.cs` and related `GBMapChunk`,
`GBStamp`, `GBAvatar` and `GBMetaSprite` classes together with the assembly
consumers as the format specification. Audit exporters for information absent
from the exported assembly before defining the native document.

Required editing layers and forms:

- Background tiles, rectangular fills, reusable stamps and palette attributes.
- Chunk placement/links, north/east/south/west connections, area assignment,
  graphics banks and map palette sets.
- Collision/interaction types: solid, water, door, text, ledge, grass, script,
  team and item; show collision overlays independently from artwork.
- Door destination/map/coordinates, items, text IDs, script labels and team
  references, with pickers that catch dangling references.
- Avatar direction/behavior and metasprite instances, including the runtime's
  extra-data fields; tile animations and shared stamp/avatar libraries.

Provide chunk-scale painting, stamp previews, copy/paste, object selection,
undo and a world overview. Keep only the active chunk/neighbors in the exchange
workspace, with host import/export retaining the whole world. Cross-map doors
need a project reference catalog even when the destination map is not loaded.
Large assembly input must be read through file/PSRAM streaming.

Add a quick walk/collision preview using the same map decoder where practical.
The actual built game remains the authority for scripts, transitions and game
state. Event forms can set existing runtime fields; arbitrary logic still uses
FatPak's assembly/C text editor. No new universal scripting VM is needed to
recreate this game. Scene/title sequences likewise use existing code plus
editable image/animation/audio references.

## Music and sound effects

`MUSIC.GBC` is a tracker for the reference's GBT Player pipeline, not a generic
sample workstation. It needs order-list/pattern editing, four channels, notes,
instrument/volume/effect fields, copy/transpose, tempo, loop/jump controls and
audition from a row or song position. Inspect `mod2gbt.c` for accepted effects,
instrument mapping, note ranges and its 50-to-60-Hz speed conversion. PCM sample
payloads in a MOD are not automatically playable Game Boy instruments.

Import/export the six reference MODs without losing unsupported metadata.
Warn precisely about effects the game converter cannot represent; do not
silently strip them. `MUSIC.MOD` generates GBT assembly/binary with symbolic
pattern addresses left for assembly/linking. Preview uses the game's GBT Player
version and tick cadence, with channel scopes/meters as optional aids. Do not
substitute another driver's song format merely because a tracker already exists.

`SFX.GBC` needs named effect banks, per-row duration, CH2 pitch/duty/envelope,
CH4 noise/envelope, channel masks and priority. Preserve FX Hammer SAV contents
outside fields being edited, plus the `.txt` name ordering. Export through the
game's exact SFX macros/driver, including channel-disable/mute transitions.
The current converter deliberately chains zero-tick entries within a row and
puts a positive duration on its last entry; retain this behavior and step count.
Its panning TODO is a compatibility issue to document, not a reason to promise
new stereo behavior absent from the game driver.

Provide music-plus-SFX audition to test channel stealing, priorities and music
restoration. Use the same playback core across the two apps or a shared audition
ROM. Verify audio on hardware, including DMG/CGB differences. A reference to
third-party tools such as FX Hammer does not require bundling their ROMs: native
compatible editing is the baseline; optional external-tool launch requires the
same proven session protocol and compatible save handling.

## Game data, dialogue and localization

Use reusable record/table UI widgets with beisbolgb-specific schemas. A universal
spreadsheet alone would miss `teams.csv`'s mixed record rows and the transposed
learned/taught-move matrices. The forms need:

- Player IDs, names, stats, type/version flags, portrait/sprite references,
  descriptions, learnsets and taught-move compatibility.
- Moves/items with enumerated categories, numerical bounds, descriptions and
  referenced effects; teams/coaches with lineup, positions, handedness, innings,
  money, restrictions, flags and rewards.
- Translation labels/comments and language columns, fallback behavior, escaped
  controls, placeholders and text-box preview using the game's font/charmap.

Keep CSV quoting, embedded newlines and UTF-8 intact. Keep IDs stable on record
reorder/rename and validate references across tables and maps. Define intentional
ID migration rather than silently changing a save game's meaning. Japanese and
accented text need glyph selection/input and actual font coverage, not only a
language-column selector. Buttons must suffice; keyboards/mice improve speed
when available but are not mandatory dependencies.

`DATA.MOD`/`TEXT.MOD` reproduce the current packing, bitfields, string terminators,
language selectors, C headers and constant definitions. Text wrapping must use
the game's current contract and placeholder widths; more sophisticated wrapping
can be a later format/profile revision. Keep C-string byte encoding explicit so
the compiler's literal rules do not conflict with game charmap substitutions.

## SGB borders

Make border mode part of `PIXEL.GBC`, with a separate export profile. The current
`sgb_border.py` expects 256×256 source images, up to 256 unique tiles and four
16-color palettes, with a reserved transparent color/tile. Preserve its layout,
palette allocation and emitted data conventions first. The workspace needs
4bpp indexed pixels, palette-per-tile assignment, deduplication and visible
overflow diagnostics; ordinary 2bpp Game Boy tile editing is insufficient.

Allow pan/zoom and a marked Game Boy viewport on DMG/CGB. Previewing the actual
border on an SGB is a later hardware test via a generated preview ROM or the
built game. Editing a border on a Game Boy does not require compiling SNES code;
the existing game-side SGB transfer logic remains responsible for displaying it.

## Project builds and packing

The project hub needs an asset dependency graph alongside code units. Each job
declares inputs, conversion profile/version, outputs and symbolic dependencies.
Use declarative registered jobs rather than requiring Python, Unity, a desktop
C compiler or arbitrary shell scripts on the Game Boy. Extend project syntax
with the compiler/assembler work after those interfaces settle.

```text
PNG/GIF/native art -> graphics conversion -----+
map/stamp/avatar/metasprite docs -> world ------+-> packs + RGBDS wrappers --+
MOD / tracker docs -> GBT ----------------------+                           |
FX Hammer SAV + names -> game SFX --------------+                           |
CSV + charmap -> tables/strings/headers ------------------------------------+
constants.asm -> C header -> C compiler ------------------------------------+
handwritten assembly ------------------------------------------------------+-> ASM -> LINK -> ROM -> RUN
```

Preserve Makefile unit order, prelude, selected DEMO/HOME/AWAY configuration,
language defines and header/fix options. Current `project.gbp` selects DEMO/EN;
do not treat that as the only long-term build configuration. Keep directly read
graphics with their scene's banking assumptions. Preserve the existing player
packing policy initially (`roledex.py` groups 27 players per image group), and
diagnose actual bank overflow rather than assuming the count always fits.

`PACK.MOD` should reproduce compact literal-data runs and graphics packs while
leaving labels, `BANK(label)`, pointers and other relocation-dependent expressions
in assembly. It must not become a second assembler. Regenerate include indexes,
image constants, map directory and cross-reference tables in dependency order.
Write changed outputs only, keep generated outputs distinguishable from sources,
and validate multi-file output sets before making them current.

Cache identity includes source/dependency content or verified metadata, converter
version, profile, configuration and language. Report stale/missing outputs and
allow a full rebuild. Do not infer correctness from timestamp alone. Preserve
the last successful ROM on a failure. Build progress should identify asset,
stage and error location; logs and bank/RAM reports remain inspectable in FatPak.

Project creation also needs folder/file creation, duplicate/rename with reference
updates, import/export, backups and recovery. Reuse the browser/text editor and
extend their missing workflows instead of building a separate filesystem UI in
every tool. Final RUN must commit pending edits before building and use the
existing game-save/return path. Testing must not overwrite a development save
without an explicit choice of test save slot.

## Delivery order and proof of completion

1. **Inventory and golden outputs.** Freeze a reference revision, configuration
   and desktop tool versions; record every source/output edge, symbols, ordering
   and checksums. Audit Unity exports and runtime decoders together. Import all
   reference assets, not only those presently selected by DEMO.
2. **Prove the application loop.** A tiny editor changes one tile, saves through
   SRAM, returns to FatPak and commits a source asset. Verify Cancel, recovery,
   oversized workspace errors and protection of previous game saves on DMG/CGB
   hardware before growing editor features.
3. **Regenerate assets on device.** Implement converters incrementally: tables/
   text/constants, graphics and player packs, music/SFX, world formats and SGB
   borders. Each converter uses shared host/device core tests. Rebuild the
   reference with generated assets deleted from a disposable project copy.
4. **Close visual authoring.** Ship pixel/palette/font editing, frame/metasprite
   editing and chunked world editing. Start with existing formats, then native
   compact documents where needed. Verify saves survive returning/reopening.
5. **Close audio/data authoring.** Ship tracker and SFX editing with actual game
   playback, then schema forms and translation previews. Create a song/effect/
   player/move/team/text entry from scratch and integrate each into the game.
6. **Build the whole game.** Integrate compiler, assembler/linker, dependency
   jobs, configuration selection and test saves. Edit `announcer.c`, regenerate
   its assembly on device and test it; checked-in `_announcer.asm` cannot stand
   in for this milestone. Build/run the reference entirely on hardware.

For format-compatible exports, compare generated binary payloads and resolved
ROM sections against the frozen desktop pipeline. Assembly text may differ in
whitespace or compactness. If an improved packer changes layout, separately
prove equivalent decoded assets and correct relocated references; never waive a
byte difference without explanation. Round-trip tests must compare editable
fields, including retained unknown data, rather than just successful parsing.

The final demonstration starts from editable sources and removes generated
outputs in a disposable project. On the Game Boy, alter a portrait/palette, a
batting animation, a map collision/door, a music pattern, a sound effect, a team
record, a translated string, an SGB border and C code. Regenerate, build, run,
inspect each change and return to continue editing. Test large maps/pattern sets
through workspace paging and repeated power-cycle recovery. Record DMG/CGB
timings, peak workspace/WRAM use and remaining restrictions.

This completes the reference workflow when no required asset edit or generation
step needs the PC. General image manipulation, other music engines, arbitrary
Unity projects, version-control hosting and a universal visual scripting system
can follow without blocking that goal.
