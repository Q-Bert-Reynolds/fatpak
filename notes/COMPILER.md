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

Milestones 1-2 are done and most of 3 and 5 run on the PC: `make test-cc`
(`tests/test_cc.py`). There is no `CC.MOD` yet.

| Part | Where |
| --- | --- |
| Lexer and preprocessor | `modules/cc/cc_lex.c` |
| Declarations, types, statements, expression trees | `modules/cc/cc_parse.c` |
| SM83 code generation | `modules/cc/cc_gen.c` |
| Shared types; host interface | `modules/cc/cc_int.h`, `modules/cc/cc.h` |
| Start-up, helpers, end of data records | `modules/cc/rt/crt0.asm`, `ccrt.asm`, `crtend.asm` |
| `hardware.h`, `stdint.h`, `stddef.h`, `stdbool.h`, `limits.h` | `modules/cc/include/` |
| PC harness: `cc_host [-I dir] [-D n[=v]] [-u unit] [-M deps] in.c -o out.asm` | `tests/cc_host.c` |
| Gearboy runner: prints `main`'s result | `tests/cc_run.cpp` |

Supported: everything in "Start with" below, plus structs/unions (members,
nesting, copies, initializers), `switch`, `goto`, enums, function pointers,
static locals, `long` through runtime helpers, function-like macros and
`#if` arithmetic. `#` and `##` in macros, designated initializers, compound
literals, struct arguments/returns, variadic functions, bitfields, floating
point, `long long`, `#pragma` and inline assembly are rejected with an error.
`f()` declares a function without parameters, as `f(void)` does.

`test_cc.py` compiles each `tests/cc/*.c` (the address sanitizer watches the
compiler), links it with the runtime through RGBDS, and runs it in Gearboy as CGB and
DMG; `main` returns 0 or the line of its first failed `CHECK`. The same units
built through `ASM.MOD` and `LINK.MOD` (`build/asm_host`, a `project.gbp`) must
give the same ROM byte for byte. `abi.c` links with `tests/cc/sdcc/abi_peer.c`,
compiled by SDCC 4.2.0 (`--sdcccall 1`), and calls both ways. `hardware.c` polls
`LY`, writes VRAM with the LCD off and reads it back. 27 bad programs check the
error messages and lines.

How it differs from the plan below:

- No per-function IR. Statements are generated as they are parsed. Each full
  expression is a typed tree (`nodes`, reset after each statement), with
  constants folded and every promotion and conversion explicit. Locals are
  allocated on the stack at their declaration and freed at the end of their block.
  `cg_depth` tracks every push, so each `break`, `continue`, `goto`, `case` and
  `return` moves SP by a known amount. A `goto` or `case` into a block at
  another depth goes through a stub that adjusts SP.
- Code generation: a value is in HL, extended to 16 bits by its type, or in DEHL
  for 32 bits. Binary operators take the left operand in DE and the right in HL;
  stores go through BC. Constant operands, short shifts and comparisons are
  inline. Multiplication, division, variable shifts, 32-bit operations, struct
  copies and indirect calls (`__cc_jphl`) call `ccrt.asm`. All branches are `jp`.
- Output goes to six sinks, each one section per unit: code, rodata (`const`
  objects), strings (literals, as numeric `DB`s), data, init records
  (`SECTION FRAGMENT "cc_init"`: `DW dest, end` and the bytes) and bss. A unit
  uses at most six of `ASM.MOD`'s 512 sections. Link `crt0.asm` first and
  `crtend.asm` last: crtend ends the records.
- Names: `_name` for external symbols, `__unit_name` for statics,
  `__unit__s<n>` for static locals, `__unit__<n>` for literals and record
  ends, `.L<n>` for local labels. Each unit lists the helpers it uses in a final
  comment.

Fitting the device (measured 2026-11-21, SDCC `--opt-code-size`): the core is
about 66 KB of code (lexer 17, parser 34, generator 16) against the five
7,424-byte pages of a wide module. Its tables are about 135 KB at the PC's
limits (`cc.h`), against 3 KB of BSS. `CC.MOD` needs those tables in PSRAM
behind accessors, at least two modules handing over through PSRAM (for example
preprocessing, then parsing and generation), and a code-size pass. The core
already avoids struct returns (SDCC can't compile them) and libc apart from
`setjmp` and `stdarg`.

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
