# C compiler

[Architecture](ARCHITECTURE.md) · [Assembler](ASSEMBLER.md) ·
[Modules](MODULES.md) · [TODO](../TODO.md)

An on-device C compiler for Game Boy programs (status below). It produces readable,
RGBDS-compatible SM83 assembly that `ASM.MOD` can assemble. The compiler runs
on DMG as well as CGB; its output runs on Game Boy hardware without FatPak
services. SGB programs still execute Game Boy code; a SNES compiler is outside
this project.

This is a small, freestanding compiler with one target, a documented C subset,
and a small runtime. It is not a portable compiler framework, a replacement for
all of SDCC, or initially a way to rebuild FatPak itself. Correct code without
peephole definitions is a requirement, including when optimization is disabled.

## Status (2026-11-21)

FILE > BUILD and RUN work on a `.c` file on the Game Boy (Gearboy, DMG and CGB; not tried on
hardware yet): three modules compile it, `ASM.MOD` and `LINK.MOD` build the ROM beside it. The
same code runs on a PC for the tests: `make test-cc` (`tests/test_cc.py`), and
`tests/run_cc_build.sh` in Gearboy. Error messages on the device are numbers:
[CC_ERRORS.md](CC_ERRORS.md).

### Using it

Open a `.c` file and BUILD (or RUN). The compiled unit is one file: it can `#include` headers
(`"name"` from the file's folder and those above it, `<name>` from `/GBCSYS/CC/include`), but
there is no linking of several `.c` files yet, and `project.gbp` isn't read for C. The runtime
(`/GBCSYS/CC/crt0.asm`, `ccrt.asm`, `crtend.asm`) is `INCLUDE`d around the unit: `main`
runs with interrupts off; its `int` result is at `$C000` and `$C002` becomes `$A5` when it
returns. An error shows the file, `Line <n>`, `C ERROR <n>` and the name it's about, and
moves the cursor to the line (in the document). `make assemble` copies the runtime and headers
to the card with the modules.

Gearboy, `tests/cc/arith.c` (80 lines): about 90 s from BUILD to the ROM on CGB, 3 minutes on
DMG (2026-11-21). A cycle profile (`CC_PROFILE=<file> tests/run_cc_build.sh <fixture>`, then
name the PCs from `bin/GBCOS.sym` and `build/modules/<M>/module.sym`) of `pointers.c` found
ASM.MOD about half of it, the passes 45%, and the field accessors only ~5%: far calls,
loading modules and byte loops were the rest. 2026-11-22's changes (ModFar's fast path, the
Fletcher module check, `cc_copy` for PSRAM copies, ASM's lexer in assembly) took it from
2,700 frames to ~2,080 (-23%). What's left: ASM's lexing (`Advance`, `Keyword`), installing
and verifying module pages (`mem_Copy`, `ModuleCompare`, ~12%), and the generated code's
size (every local on the stack: ASM reads ~1,400 lines for 40 of C).

### Pieces

| Part | Where |
| --- | --- |
| Pass A, preprocessing: CCA.MOD, 4 pages | `modules/cc/cc_pre_*.c`, `cc_pre.h`; `cc_dev_pre.c` (ModSource, ModLoad) |
| Pass B, parsing: CCB.MOD, 5 pages | `modules/cc/cc_parse_*.c`, `cc_parse.h`; `cc_dev_parse.c` |
| Pass C, code generation: CCC.MOD, 3 pages | `modules/cc/cc_gen_*.c`, `cc_gen.h`, `cc_ops.h`; `cc_dev_gen.c` |
| The error box: CCERR.MOD | `modules/cc/cc_err.c` |
| In every pass, A and B, B and C | `cc_core.c`, `cc_arith.c`, `cc_types.c` |
| Page-local accessors (`CC_NEED_*`, `scripts/cc_pages.py`) | `cc_acc.h` |
| Layouts, PSRAM map, host interface; tables; context and state | `cc.h`, `cc_int.h`, `cc_ctx.h` |
| Codes and their English | `cc_msg.h`, `cc_msgs.c` (`scripts/cc_errors.py` writes CC_ERRORS.md) |
| Start-up, helpers, end of data records | `modules/cc/rt/crt0.asm`, `ccrt.asm`, `crtend.asm` |
| `hardware.h`, `stdint.h`, `stddef.h`, `stdbool.h`, `limits.h` | `modules/cc/include/` |
| Host (`BuildStart`, assembly) | `src/editor/build.c` |
| PC harness: `cc_host [-I dir] [-D n[=v]] [-u unit] [-M deps] in.c -o out.asm` | `tests/cc_host.c` |
| Gearboy runner: prints `main`'s result | `tests/cc_run.cpp` |

Supported: everything in "Start with" below, plus structs/unions (members, nesting, copies,
initializers), `switch`, `goto`, enums, function pointers, static locals, `long` through runtime
helpers, function-like macros and `#if` arithmetic. `#` and `##` in macros, designated
initializers, compound literals, struct arguments/returns, variadic functions, bitfields,
floating point, `long long`, `#pragma` and inline assembly are rejected with an error. `f()`
declares a function without parameters, as `f(void)` does.

### The passes

Each pass is a wide module, and they hand over only through PSRAM (`cc.h`'s map, in
`ASM.MOD`'s areas, free until it runs):

- **A** (`cc_pre_*`) lexes and preprocesses into a token stream (8 bytes a token, `TK_LINE`
  markers for lines and files). Names (64-byte records, hash chains), macros, macro bodies and
  expansions, string literals (a heap) are in PSRAM.
- **B** (`cc_parse_*`) parses the stream. Symbols (never removed: a name's visible symbol heads a
  `shadow` chain), types, fields and expression trees (16-byte records, kept for C) go to PSRAM,
  and each statement becomes ops in the statement stream (`IR_*`, `cc_int.h`), static data too
  (`IR_D*`). Its `gen_*` are stream writers that mirror the stack depth.
- **C** (`cc_gen_*`) replays the stream through the code generator, writes the text sinks, and
  joins them at `CC_OUT_BLOCK` (64 KiB at most: `ASM.MOD`'s document limit), with the runtime's
  `INCLUDE`s on the device (`CC_WRAP`).

Every table is read and written by value through small functions (`SY_KIND(i)`, `ND_A(n)`...):
no pointer into the PSRAM window survives the next select. On the PC the window is one
512-byte buffer written back and reloaded at every select, so a stale pointer fails the tests
there too; PSRAM starts out as `$A5`s.

The host (`BuildStart`) runs CCA.MOD; each module names the next in the context (`cc_chain`):
CCB, CCC, or CCERR.MOD after an error, which writes the box's text and the cursor's place. An
error ends a pass through `ModAbort` (ABI 14, `ModuleAbort`'s second label), which also resets
the far-call depth; on the PC, `longjmp`. CCC.MOD fills in the `AsmContext` (sharing the
context's storage) for `ASM.MOD`'s `ASM_TEXT`.

### Fitting the modules

What the module rules required:

- Pages: each page is one or more whole sources, mapped alone at `$A000`. A recursive cycle
  stays on one page (expressions on `cc_b_expr`, the code generator's on `cc_c_gen`), since each
  call between pages takes one of the OS's 16 far-call frames (Gearboy: 9 at the deepest). A pointer to a page's constants can't cross pages: the generator emits
  instruction codes (`cc_ops.h`, 113 templates on `cc_c_emit`), `out_str` copies a literal to the
  stack first, and the hot accessors are copied into each page (renamed by `CC_PAGE`).
- No SDCC helpers (`cc_mul32`, `cc_divmod32`...), no `memcpy` from struct assignments
  (`tok_copy`), no initialized data, no struct returns, no libc.
- Stacks: each pass runs on its own stack in its BSS (1,792, 2,560 and 2,560 bytes; `cc_dev_*.c`
  switch to it in `ModuleMain`): the OS's 1 KiB also holds BuildFile's frames, and FatFs
  under `ModLoad`. `ModLoad` (which may hold the BSS elsewhere while it draws progress) runs on
  the OS's stack. Gearboy: the OS stack 804 bytes deep at most (FatFs reading an `#include`),
  the passes' own up to 679, 524 and 435 bytes (`preproc.c`, `calls.c`). BSS in all: 2,922, 2,768
  and 2,709 bytes (of 3,072). Scratch arrays (cases, labels, initializer items, declarator
  operations, struct members) are in PSRAM.
- SDCC 4.2.0 miscompiled two places silently (the PC build was right): `store_to` lost a register
  across a spill, and `local_declaration`'s address-taken struct shared its stack slot with a
  later local. Both are rewritten around it. `run_cc_build.sh` compares the assembly the modules
  write with the PC's byte for byte, which is how they were found: trust that, not the PC.
- Size: CCB's five pages are 6,720 + 6,915 + 6,300 + 6,824 + 6,634 bytes of 7,424; CCC's
  `cc_c_gen` is 7,283. Growth needs care.
- The OS has almost no room: `BuildStart` is assembly, `NameChar` moved to page 4 and
  `BuildModule` to page 6 to make space (every page is at 98-99%).

The PC harness builds each pass as its own object, only its entries global, so the passes
share nothing but the emulated PSRAM.

### Tests

`test_cc.py` compiles each `tests/cc/*.c` (the address sanitizer watches the compiler), links
it with the runtime through RGBDS, and runs it in Gearboy as CGB and DMG; `main` returns 0 or
the line of its first failed `CHECK`. The same units built through `ASM.MOD` and `LINK.MOD`
(`build/asm_host`) must give the same ROM byte for byte. `abi.c` links with
`tests/cc/sdcc/abi_peer.c`, compiled by SDCC 4.2.0 (`--sdcccall 1`), and calls both ways.
`hardware.c` polls `LY`, writes VRAM with the LCD off and reads it back. 27 bad programs check
the error messages and lines. `run_cc_build.sh` does FILE > BUILD on the fixtures on a fresh
card in Gearboy (CGB and DMG), runs each ROM built there, checks an error's box and cursor, and
records the far-call depth and stack.

How the code differs from the plan below:

- No per-function IR: statements are generated as they're parsed (in pass B, as stream ops).
  Each full expression is a typed tree, constants folded and every promotion and conversion
  explicit. Locals are allocated on the stack at their declaration and freed at the end of
  their block. `cg_depth` tracks every push, so each `break`, `continue`, `goto`, `case` and
  `return` moves SP by a known amount; a `goto` or `case` into a block at another depth goes
  through a stub that adjusts SP.
- Code generation: a value is in HL, extended to 16 bits by its type, or in DEHL for 32 bits.
  Binary operators take the left operand in DE and the right in HL; stores go through BC.
  Constant operands, short shifts and comparisons are inline. Multiplication, division,
  variable shifts, 32-bit operations, struct copies and indirect calls (`__cc_jphl`) call
  `ccrt.asm`. All branches are `jp`. Locals all live on the stack: correct, but slow and big.
- Output goes to six sinks, each one section per unit: code, rodata (`const` objects), strings
  (literals, as numeric `DB`s), data, init records (`SECTION FRAGMENT "cc_init"`: `DW dest, end`
  and the bytes) and bss. Link `crt0.asm` first and `crtend.asm` last: crtend ends the records.
- Names: `_name` for external symbols, `__unit_name` for statics, `__unit__s<n>` for static
  locals, `__unit__<n>` for literals and record ends, `.L<n>` for local labels.

## Build contract

The intended pipeline is:

```text
C + headers -> CC.MOD -> generated .asm -> ASM.MOD -> link/fix -> .gb
handwritten .asm --------------------------^
```

`CC.MOD` is a proposed name, not an existing module. The host coordinates the
stages after each module returns. Modules cannot invoke one another: the loader
allows one synchronous module at a time. Assembly and ROM placement remain the
assembler/linker's responsibility. The working assembler is gaining a separate
`LINK.MOD`; use its eventual interface rather than duplicating object writing,
relocation, header fixing or ROM placement in the compiler.

One C translation unit produces one assembly translation unit. Compile each C
file independently, and mix the generated units with handwritten RGBDS units.
An assembly-only project must continue to use its existing build path. Compiler
integration and project syntax are later changes, coordinated with the assembler
work; this document does not reserve new `project.gbp` keywords or object fields.

The first implementation should run as a host command-line program with explicit
input and output paths. This is a development harness for the same compiler core
that will run on the Game Boy, not a separate desktop-only implementation.

## Language and data model

Use familiar C syntax and C99 integer semantics for the supported features.
Do not call the result a complete C99 implementation. Publish a feature table
and reject unsupported constructs explicitly, before emitting a usable output.

| Property | Proposed contract |
| --- | --- |
| Bytes and byte order | 8-bit bytes, little-endian |
| `char` | 8 bits; plain `char` unsigned; explicit `signed char` supported |
| `short`, `int` | 16 bits, signed unless qualified |
| `long` | 32 bits; added after the 16-bit core |
| `_Bool` | Stored in one byte, normalized to 0 or 1 |
| Object/function pointers | 16-bit near addresses; null is zero |
| `size_t`, `ptrdiff_t` | Unsigned and signed 16-bit integers respectively |
| Alignment | Byte alignment, including aggregate members; no implicit padding |
| Signed representation | Two's complement; signed right shift is arithmetic |
| Execution environment | Freestanding; no implicit hosted library or OS |

Apply integer promotions and usual arithmetic conversions before selecting
instructions. In particular, two `unsigned char` operands generally promote to
signed 16-bit `int`; they do not automatically perform byte arithmetic. Unsigned
arithmetic wraps at its type's width. Signed division truncates toward zero and
the remainder follows the dividend's sign. RGBDS expressions have different
division/remainder rules, so evaluate C constant expressions in the compiler.
Signed overflow, invalid shifts and invalid pointer arithmetic retain C's
undefined behavior; diagnose these when evident in a constant expression.

Start with:

- Object/function declarations, prototypes, definitions, lexical scopes,
  `typedef`, `const`, `volatile`, `extern` and `static`.
- Integer literals, character/string literals and escapes, casts, `sizeof`,
  addresses, indirection, indexing, arrays and pointer arithmetic.
- Arithmetic, bitwise, comparison and logical operators; assignment and compound
  assignment; prefix/postfix increment; conditional and comma expressions.
- Blocks, `if`/`else`, `while`, `do`, `for`, `break`, `continue` and `return`.
- Direct function calls, automatic locals, globals and constant initializers.
  Automatic locals have stack storage so recursion and reentrant functions work.

Then add structs/unions with member access and aggregate initialization,
`switch`, function pointers, static local initialization and 32-bit arithmetic.
Aggregate copies need explicit lowering; aggregate arguments/returns can remain
unsupported until their ABI is implemented. Static locals use constant
initialization, not dynamic initialization guards.

Initially exclude floating point, `long long`, variable-length arrays, bitfields,
variadic functions, atomics, threads, dynamic loading and a full standard library.
Reject unknown compiler attributes and pragmas rather than silently dropping
them. Old-style function definitions and implicit function declarations are not
needed. General inline assembly can wait: separately assembled routines provide
the initial hardware escape hatch.

## Preprocessor

Keep preprocessing separate from C parsing, with file/line information on every
token. A useful first set is quoted/system includes with explicit search roots,
object-like defines, `#undef`, include guards and nested `#if`/`#ifdef`/
`#ifndef`/`#elif`/`#else`/`#endif`, plus `#error`, `__FILE__` and `__LINE__`.
Conditional expressions must use defined integer rules and short-circuiting.
Add function-like macros before describing the compiler as ready for ordinary
game headers. Stringification and token pasting can follow, with explicit errors
until supported. Variadic macros are deferred.

Expansion needs disabled-macro tracking, a bounded expansion stack and useful
diagnostics for include cycles, excessive nesting and oversized tokens. Do not
implement expansion as recursive string replacement. Record all included files
as build dependencies, including headers reached only through other headers.

## Calling convention

Use SM83 SDCC `__sdcccall(1)` for supported signatures. This matches FatPak's
existing direction and makes assembly helpers and mixed-compiler tests useful.
Small-C is a guide to implementation size, not a requirement to use its ABI.

Before code generation, write and execute an ABI fixture matrix against the
installed SDCC. Pin its version and flags; the checkout in `~/Projects/sdcc`
may differ from the installed compiler. Resolve the exact register assignment,
stack byte layout, cleanup, clobbers and return rules from those fixtures and
the SM83 sources/manual. Do not infer the ABI from a few generated functions or
from the Z80 convention.

What SDCC 4.2.0 #13081 (`-msm83 --sdcccall 1`) does, as `tests/cc/abi.c` checks
both ways:

| Argument | 8 bits | 16 bits (and pointers) | 32 bits |
| --- | --- | --- | --- |
| first | `a` | `de` | `debc` (`bc` low) |
| second, after one in `a` | `e` | `de` | stack |
| second, after one in `de` | `a` | `bc` | stack |
| second, after one in `debc`; third and later | stack | stack | stack |

Stack arguments are pushed last first, packed by size (a byte takes one byte:
`push hl` / `inc sp` with the value in `h`), and the callee removes them
(`pop hl` / `add sp, n` / `jp hl`). Results are in `a`, `bc` or `debc`. Every
register is clobbered by a call. CC passes `a` arguments by pushing them with the
value in the high byte and popping them with `pop af`, so HL can hold the target
of an indirect call.

The existing architecture notes describe arguments in `a`, `de`, `e` and `bc`,
with remaining arguments on the stack and callee cleanup for fixed prototypes;
returns use `a` (8 bits), `bc` (16 bits) and `debc` (32 bits). Treat this as an
overview, not the full ABI table. Test every supported first/second argument
width combination, additional arguments, pointer arguments, nested calls and
values live across calls. Add indirect calls and aggregate cases with their
language milestones. Model all registers as call-clobbered unless the verified
contract guarantees otherwise.

Track stack depth explicitly through locals, spills, saved registers, arguments
and return addresses. Every control-flow merge must agree on stack depth. Large
frames and offsets need legal instruction sequences beyond SM83's signed-byte
SP-relative range. Report per-function frame usage; recursion prevents a general
static bound on total stack usage.

The first release can require assembly wrappers for interrupt handlers and
banked calls. A near function pointer does not identify a ROM bank. An eventual
banked calling extension needs its own pointer representation, trampoline,
register/stack contract and interrupt policy; it must not reinterpret ordinary
16-bit pointers silently.

## Compiler structure

Implement a small core in C using fixed-width values, explicit storage accessors
and bounded working buffers. Separate source I/O, diagnostics and output sinks
from compilation so the host harness and device use the same logic.

1. **Lex/preprocess.** Stream source into tokens with source locations; intern
   names. Keep source text and cold tables in PSRAM or temporary storage.
2. **Parse/type-check.** Recursive descent for declarations/statements and a
   precedence parser for expressions. Resolve types, lvalues and conversions
   before generating machine operations. Bound parser recursion explicitly.
3. **Lower one function.** Build basic blocks and a compact typed intermediate
   representation (IR). Operations include loads/stores, conversions, arithmetic,
   comparisons, branches, calls and returns. Keep address computation distinct
   from reading the addressed object. A whole-program AST or SSA framework is
   unnecessary initially.
4. **Select SM83 instructions.** Lower every IR operation to legal instructions
   or a declared runtime helper. Record register, flag and memory effects.
5. **Allocate registers/spill.** Begin conservatively with stack slots and simple
   temporary lifetimes. Add local register reuse after the baseline works.
6. **Lay out/emit.** Emit RGBDS sections, symbols, instructions and data with
   deterministic names and a generated-line-to-C-location map.

Declaration collection may require a preliminary pass or replaying tokens, but
normal C visibility rules still apply: a later declaration does not make an
earlier undeclared use legal. Keep translation-unit declarations between
functions and release function-local IR promptly. Store references as stable
IDs/offsets, never pointers into a banked PSRAM window.

## Correctness without peephole definitions

Instruction selection must already produce valid, correct RGBDS assembly.
The emitter writes `jp hl`, `[hl]`, `ldh` and SP-relative forms directly in the
accepted syntax. It must never depend on rewriting SDCC/ASxxxx syntax afterward.

Memory operations need explicit register and flag dependencies. For example,
when evaluating `*p = f()`, preserve the destination address across the call or
recompute it afterward from preserved inputs; a stale `hl` is never an assumed
destination. Compound assignment evaluates its lvalue address once. Increment
and multi-byte operations must preserve carry/borrow until consumed.

Generate real branches for `&&`, `||` and `?:` so skipped operands have no side
effects. Respect sequence points and preserve every required `volatile` access,
including its width and order. A 16-bit volatile access still consists of two
byte accesses and is not atomic. Do not cache hardware registers or introduce
extra reads of them. Keep volatile read-modify-write sequences explicit.

Start with `jp` for branches. Later, shorten a branch only when its final distance
is known to fit after allocation and layout, using an iterative layout if
necessary. Never rely on an assembler retry to repair an optimistic `jr`.

Optional optimization passes can fold constants, remove unreachable blocks,
reuse known values and select `ldh` for proven high-memory addresses. Their
legality comes from typed IR and instruction effects. There is no required
external rule file, text cleanup pass or optimization switch that repairs
incorrect baseline code. Both optimized and unoptimized builds are test targets.

## Assembly, storage and runtime

Emit a deliberately small subset of the assembler's supported RGBDS syntax:
`SECTION`, global/local labels, instructions, `DB`, `DW`, `DS` and constant
definitions as needed. Avoid `LOAD`, `UNION`, assembler macros or elaborate
string interpolation. Never require a new assembler feature merely to format
compiler output. Compile a fixture through both `ASM.MOD` and desktop RGBDS.

Use `_name` for C external symbols and deterministic unit-specific prefixes for
internal symbols, literals and compiler labels. Keep generated names within the
assembler's documented limits; use IDs for uniqueness rather than truncating
source identifiers. Ordinary C name scopes are independent of assembler local
label scope. Separate code, ROM constants, zero-initialized RAM and initialized
RAM plus its ROM initializer image into explicitly named sections.

Emit strings as numeric bytes so a surrounding RGBDS charmap cannot change C
string contents. Evaluate integer initializers with C semantics; use assembler
expressions only for relocation-dependent addresses and supported address
addends. C `const` is a type qualifier, not an automatic choice of physical ROM
storage: define placement rules explicitly, including objects whose addresses
escape or whose storage must remain writable through other permitted accesses.

Start with ROM0 code and constants, WRAM0 data, and a nonbanked 32 KiB ROM.
Document RAM/stack reservations in the startup assembly and diagnose overflow at
link time. Expand to explicit ROMX placement later. The compiler does not
automatically switch banks when dereferencing near pointers. CGB-only features
and mapper-specific support belong in explicit libraries/configuration.

Provide a small RGBDS runtime alongside the compiler:

- Startup, entry/header and vector reservations, stack setup, BSS zeroing,
  initialized-data copying, a call to `main`, and a defined path if it returns.
- Integer multiply/divide/remainder, shifts or aggregate copying when lowering
  requires helpers. Give helpers a documented ABI and test boundary cases.
- Minimal headers for types and hardware addresses; optional memory routines and
  interrupt/banking wrappers. No implicit `printf`, allocator or SDCC library.

List helper dependencies per unit so the build selects each needed definition
once. Runtime assembly must assemble with `ASM.MOD` too. Startup owns interrupts
and initial hardware state; compiling C must not quietly enable interrupts.

## Fitting the device

Budget against the module loader, not desktop memory availability. Current wide
modules can borrow up to five 7,424-byte code pages and have 3,072 bytes of WRAMX
BSS, while also using the OS stack. Those are ceilings shared with wrappers,
buffers and compiler state, not all usable for parser tables. Measure a minimal
compiler module early, before growing the language.

Keep hot lexer/parser state and a few block caches in WRAM; put interned names,
types, symbols, tokens and function IR in PSRAM. If compilation must split into
separate modules, use a versioned intermediate representation handed through
PSRAM and host-controlled sequential calls. Cross-page calls within a wide
module remain possible, but its code and constant pointers cannot cross pages.

Use explicit bounds and checked allocation for every arena, source, generated
file, nesting stack and ID space. Distinguish a 16-bit CPU address from a larger
PSRAM/file offset. Cache block reads and write output in chunks; per-character
far calls or repeated SD scans will dominate DMG compile times.

The assembler already uses much of the editor's large-file add-buffer region.
Plan storage lifetimes across the entire build: compiler work arenas may be
reused after compilation, but generated assembly and its source map must survive
until assembly finishes. Do not assign permanent PSRAM blocks here while the
assembler layout is changing. The editor text, undo/settings, module backups
and protected assets must survive every stage.

Begin on device with text-buffer-sized source and explicit limits for includes
and generated output. Generated assembly can exceed its C input, so the current
65,024-byte open-document limit cannot be its only input path. Use file-backed
generated units or a host-provided PSRAM stream with an explicit length; choose
that handoff with the assembler implementation. Initially the host can persist
generated assembly after the compiler returns, using its file-writing path;
arbitrary SD writes inside a wide module are not an existing free service.
SD temporary passes can follow if PSRAM capacity proves insufficient.

## Diagnostics and builds

Carry source path, line and column through preprocessing and lowering. Retain
macro/include context where practical. Translate assembler diagnostics in a
generated file back to the C location through a sidecar map; emitted comments
alone cannot provide that interface. Link errors should name the C symbol and
unit when known. Compiler-generated invalid assembly is a compiler defect.

Return diagnostics and output descriptors to the host in a versioned context;
the host restores the editor and moves the cursor using the original source.
Call `ModProgress` regularly with phase/unit progress. Preserve the previous
successful ROM when any stage fails and do not launch partial output.

Later incremental builds must include source/header contents or reliable change
metadata, compiler/runtime version, flags, defines and include search paths in
their cache identity. A generated unit is current only when all of these match.
Keep generated assembly inspectable and avoid overwriting handwritten `.asm`
files; choose the cache/output naming scheme during project integration.

## SDCC as a reference

The source checkout at `~/Projects/sdcc` provides useful starting points:

| Path within that checkout | What to study |
| --- | --- |
| `src/z80/main.c` | SM83 target setup and RGBDS selection |
| `src/z80/gen.c` | Calls/returns, arithmetic, casts and memory access lowering |
| `src/z80/ralloc.c`, `ralloc2.cc` | Register constraints and spilling examples |
| `src/z80/mappings.i` | Assembler dialect mappings |
| `src/z80/peeph-sm83.def` | Instruction selection opportunities and pitfalls |
| `device/lib/sm83/` | Startup and arithmetic/memory helper examples |
| `doc/sdccman.lyx` | SM83 data model and calling convention documentation |

Use tiny C fixtures to compare SDCC and the new compiler operation by operation.
Matching simple SDCC assembly can be an early milestone; matching its output
globally is not an acceptance criterion. Keep fixture inputs, tool versions,
flags, generated assembly and observed results together. Existing FatPak builds
use `--no-peep --peep-file peephole.def`, and the architecture notes record SDCC
miscompilations: investigate disagreements instead of treating SDCC as infallible.

The first prototype should implement its own small frontend, typed IR and SM83
emitter. Porting SDCC's complete frontend, allocator and multi-target machinery
would work against the device budget. Study its algorithms and regressions;
review the relevant source file's license before incorporating code.

## Implementation milestones

1. **Freeze the contracts.** Record the supported type/ABI tables with executable
   SDCC probes, define a minimal runtime and assembly subset, and measure module
   code/BSS/stack feasibility. Assemble a hand-written example of the proposed
   output through desktop RGBDS and `ASM.MOD` before writing the frontend.
2. **Host vertical slice.** Compile a function with byte/word constants, locals,
   arithmetic and a return; link it with startup and run it. Add a hardware-visible
   example such as a tile or palette change using a volatile register. Generated
   assembly must work without peephole files from this first step.
3. **Useful 16-bit C.** Implement declarations, preprocessing, expressions,
   control flow, pointers/arrays, direct calls and initialization. Add ABI tests
   in both directions with SDCC and assembly, including stack arguments.
4. **On-device compilation.** Package the same core, add PSRAM storage and host
   handoff, preserve editor state, translate diagnostics and run BUILD/RUN on DMG
   and CGB. Measure compile time, output size, stack and arena high-water marks.
5. **Practical game subset.** Add structs/unions, `switch`, function pointers,
   32-bit operations and the needed runtime helpers. Build a multi-file game
   mixed with handwritten assembly and report the remaining language exclusions.
6. **Placement and efficiency.** Add explicit banked code/data support only with
   tested access/call rules. Profile real games, then improve instruction selection,
   register reuse, branch layout and incremental compilation.

Self-hosting, replacing SDCC in FatPak's own build, and compiling arbitrary GBDK
projects are separate future decisions, not completion requirements.

## Acceptance tests

- Parse/type/preprocessor tests cover scope, invalid declarations, macro recursion,
  literal escapes, promotions and useful unsupported-feature errors.
- Execute compiled programs in Gearboy and compare memory/register-visible
  results with expected values. Cover signed/unsigned boundaries, carries across
  bytes, casts, comparisons, negative division, pointer scaling and nested calls.
- Exercise `*p = f()`, signed-byte loads, post-increment stores, live values across
  spills and the multi-byte allocation arithmetic described in the assembler
  notes. Test frames beyond signed-byte SP offsets and recursion.
- Use defined-behavior C fixtures for differential tests against SDCC; do not use
  a host's wider `int` arithmetic as an unqualified Game Boy oracle. Trace required
  volatile accesses, short-circuit behavior and side-effect counts explicitly.
- Assemble identical generated units with `ASM.MOD` and RGBDS, with equivalent
  placement/fix settings, and compare ROM bytes. Separately compare program
  behavior against SDCC; different instruction sequences are allowed.
- Run the core suite with optimizations disabled and enabled. Check missing
  helpers, duplicate symbols, RAM/ROM exhaustion, malformed input and arena limits.
- Test device failures and successful rebuilds with the editor state intact,
  included-file diagnostics, generated output larger than its input and protected
  PSRAM regions guarded. Finish with a small game built and run on DMG and CGB
  hardware, recording timings separately from emulator measurements.
