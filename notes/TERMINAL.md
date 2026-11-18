# Terminal and local version control

[Architecture](ARCHITECTURE.md) · [Modules](MODULES.md) ·
[Assembler](ASSEMBLER.md) · [Compiler](COMPILER.md) ·
[Game development](GAME_ENGINE.md)

Proposal: a UNIX-style command environment inside FatPak for managing files,
invoking development tools and keeping local version history. It should work
on DMG and CGB, with buttons/on-screen keyboard or a physical keyboard. It is
an alternative interface to the same project and file services used by the
browser/editor, not a requirement to build a UNIX kernel.

The useful first target is a foreground shell, streaming file commands, command
adapters for modules and a deliberately bounded Git-compatible implementation.
Processes, virtual memory, users/permissions, background jobs and networking are
not prerequisites. All names and new interfaces below are proposed; this file
does not change the current ABI or project syntax.

## What already exists

- FatPak has a renderer, keyboard/input paths, text editing and an SD filesystem.
  `src/fatfs/file_api.h` exposes host-side list, rename, delete, copy, load/save,
  inspection and viewer functions. Copy already supports folders without
  overwriting existing destinations; delete handles files/empty directories.
- `modules/abi.json` exposes display/input, source/file reads, PSRAM loading,
  progress and other selected services. It has no general command arguments,
  standard streams, directory iterator or general writable file-handle API.
- `RunModule` is synchronous and rejects nesting. Modules have fixed entry
  points/IDs; they are not arbitrary executable files with a C `main(argc,argv)`.
- The host already invokes `ASM.MOD`, then `LINK.MOD`, and writes build outputs.
  This is a useful model for command orchestration.
- `modules/asm_proj.c` parses `project.gbp`: `main`, `output`, `rgbasm` options
  and `rgbfix` options. These lines are declarative build settings, not shell
  invocations. They do not currently execute the desktop programs or provide
  pipes, general commands, variables or exit-status semantics.

The work is therefore mostly a command runtime, console and safe shared I/O
interfaces, followed by individual tools. Existing modules need explicit
adapters; adding a prompt does not give them command-line behavior automatically.

## Terminal, shell and command dispatcher

Keep these responsibilities separate:

| Component | Responsibility | Placement |
| --- | --- | --- |
| Console | Prompt, line editing, scrollback, pager, input and displayed output | Host-owned state and rendering path |
| Shell parser | Tokenize/parse a line or script into bounded command records | Small host helper or optional parser module |
| Dispatcher | Resolve commands, prepare arguments/I/O, run modules, collect results | Host code that remains usable between module calls |
| Built-ins | Shell state and simple host operations | Host adapters; page where ordinary host code is safe |
| Command modules | Substantial tool implementations | Existing/new `.MOD` files through the normal loader |

An entire shell in `SHELL.MOD` cannot call `ASM.MOD` or `GIT.MOD`: nesting is
forbidden. If parsing uses a module, it returns a command plan before execution.
If console UI code lives on a borrowed page, it resumes only after the command
returns. No module leaves live pointers into its borrowed code/BSS behind.

The permanently reachable dispatcher should be small. Do not place all commands
in already crowded ROM0. Ordinary host work can run from restored pages between
module invocations. Audit any service reachable while a command module is
mapped, including its interrupt handlers and FatFs callees.

Console state consists of a current directory, pending input, history, bounded
variables, last exit status and PSRAM-backed scrollback. Give scrollback an
explicit allocation/lifetime so builds and asset tools cannot overwrite it.
Use a row cache rather than retaining every line in WRAM. Support horizontal
viewing/wrapping and a pager for narrow screens. A compact font can improve
density, but every command must remain usable on the normal display.

Line editing needs cursor movement, history, path completion and cancel. Button
shortcuts should cover these without requiring Control keys. Start with plain
text, newline, carriage return and tabs. An ANSI/VT escape interpreter or serial
terminal endpoint can follow; neither is needed for local command execution.
Render untrusted file/filename control bytes visibly instead of interpreting
them as console commands.

## Initial shell language

Implement a documented subset rather than suggesting POSIX shell compatibility:

- Commands with words, single/double quotes, escapes, `--` and bounded arguments.
  Preserve an empty quoted argument; reject unterminated quotes and overlong input.
- Absolute and relative paths, `.`/`..`, `pwd` and `cd`; canonicalize without
  permitting traversal above the mounted root. The shell's cwd is separate from
  the editor's document folder.
- Newline/`;` sequencing and `&&`/`||` short-circuit execution. Later add bounded
  variables such as `$?` and `$NAME`, with precisely specified expansion rules.
- Input/output redirection, followed by sequential spooled pipes. Keep these
  behind their own delivery milestone rather than accepting syntax too early.
- A `source file` command for the same grammar, bounded script nesting and a
  stop-on-error batch mode. Interactive sessions retain the prompt after errors.

Use shell `#` comments and keep `;` as a command separator. Preserve
`project.gbp`'s existing `;` comments and quote rules in its own parser. Do not
silently reinterpret old project files as scripts. Globs (`*`, `?`) can be
added with bounded expansion, literal quoted words and documented no-match
behavior; keep shell globs distinct from Git pathspec/ignore syntax.

Defer command substitution, subshells, functions, job control, general loops,
signals and field-splitting rules. A script is a list of supported commands,
not an arbitrary executable shell file. Validate a command's syntax before
opening/truncating a redirection target.

## Filesystem commands and services

| Commands | Initial behavior |
| --- | --- |
| `pwd`, `cd`, `ls [-a] [-l]` | Navigation and paged metadata listing |
| `stat`, `cat`, `more`, `head` | Inspect metadata/text without loading the document |
| `hexdump` | Stream binary inspection; use the existing hex UI for interactive viewing |
| `mkdir`, `rmdir`, `touch` | Create folders, remove empty folders, create/update file times |
| `cp`, `mv`, `rm` | Shared host operations with explicit overwrite/removal policies |
| `find`, `grep`, `cmp` | Bounded directory walk, literal text search and streaming byte comparison initially |
| `edit`, `open`, `run` | Enter existing editor/viewer/application/game flows |
| `help`, `modules`, `clear`, `history` | Discover commands and inspect/reset console state |

Reuse host file operations where their semantics match; add missing operations
through shared services. Do not duplicate FatFs inside every command module.
The browser's list is sorted/filtered for UI and skips hidden/dot names; Git
and `ls -a` need an iterator that sees `.git`, `.gitignore` and other real files.
Directory walking must not clobber an open editor document or another command's
file handle. `FF_FS_LOCK` is currently disabled, so enforce handle/ownership
rules in the host rather than assuming FatFs rejects conflicting operations.

Define one strict path resolver for commands: relative paths start at cwd,
absolute paths at SD root, with checked component and total lengths. The current
64-character LFN configuration and bounded UTF-8 buffers constrain what can be
addressed. Do not silently substitute an 8.3 alias or truncate a path. UTF-8
display fallback must not alter the bytes used to open a file. Module file
helpers that search parent folders or fall back to a basename are useful for
assembly includes, but unsuitable as shell `open` semantics.

File I/O needs bounded host-owned handles, offsets/lengths wider than 16 bits,
chunked read/write, seek, stat, directory iteration, flush/close and explicit
errors. Check short writes and close/flush failures. Keep sector buffers private
to the service; copy text/arguments before entering paged FatFs code. Begin with
a few audited handles, not a full POSIX descriptor subsystem.

New commands must coordinate with the editor: do not replace, delete or check
out over unsaved document contents silently. Reuse the existing move tracking,
but extend the document-busy rules to all mutations. Git stages disk bytes;
`git add` should identify an unsaved matching document and require saving it
first. Versioning never implies auto-saving every open file.

Default copies/moves refuse accidental replacement unless requested. `rm` can
use a recoverable project trash policy, with permanent/recursive removal as
explicit options. State those differences from UNIX in help. Redirection `>`
means replacement, `>>` append; initially implement `>` via a temporary output
and successful close before replacement. Protect `cat file > file` and equivalent
aliases. For cross-volume moves later, copy/verify before removal.

FAT is not a transactional filesystem. Use same-directory temporary files,
backups and recovery records for replacement; flush ordering and recovery must
be tested on the actual card. A rename alone is not a claim of power-fail atomicity.

## Command interfaces to modules

Introduce a versioned command context in host WRAM. Its logical fields are:

```text
version, size, invocation ID, command/subcommand ID
argc + argument offsets into a bounded host/PSRAM argument arena
cwd descriptor, stdin/stdout/stderr handles
progress/cancel state, continuation token
command exit status, structured diagnostic/output descriptors
```

Define byte layout and bounds when implementing, rather than freezing a C
struct here. Arguments are data, never a string re-parsed by the module.
Large arrays/output use PSRAM offsets or host handles; small strings can use
audited copying wrappers. Module-owned pointers cannot outlive the invocation.
The context and argument arena must survive BSS resets and page swaps.

Keep the loader's return code, `module_status` and command exit status distinct:
missing/wrong-ABI modules are loader failures; a syntax error in C is a tool
failure; `grep` finding no match is an ordinary nonzero command result. Define
adapter mappings and a separate internal state for pending/yielded work.
Shell status can follow familiar 0/success, 1/ordinary failure, 2/usage error
conventions, with named codes for unavailable commands and cancellation.

Register command names against approved module IDs, entry modes, minimum ABI,
usage/help and capabilities (streaming, interactive, mutating, resumable).
One module may handle multiple subcommands. Preserve the loader's ID/header/CRC
checks; do not execute any file with a `.MOD` extension found in cwd. A command
manifest is data, not code to evaluate. Existing module entry contexts remain
valid; use adapters or an explicit new entry mode instead of guessing which
context a module received.

Examples of adapters:

| Command | Dispatch |
| --- | --- |
| `build [project.gbp]` | Existing project pipeline, with explicit project/source selection |
| `asm file.asm -o game.gb` | Host prepares assembler context, runs ASM then LINK and persists outputs |
| `cc file.c -S -o file.asm` | Planned compiler with explicit arguments and diagnostics |
| `image inspect art.png` / `image export ...` | Planned image converter command modes |
| `edit-asset map world` | Planned application session handoff, then restoration of terminal state |
| `git status` | Version-control dispatcher and its sequential phases |

The spellings are proposed FatPak commands; they do not promise full desktop
`rgbasm`/`rgblink` options or compatible `.o` files. Build, menu actions and shell
commands should call the same normalized request/validation layer so options
and behavior cannot drift.

There are two viable ways to provide new I/O while modules run:

1. Small modules call audited resident wrappers whose full callees remain mapped.
   Output may use the ordinary renderer if its buffers/pages remain available.
2. Wide modules perform bounded computation, then **return** a host-service
   request or output chunk. The host restores pages, performs file/UI work and
   re-enters the module with a continuation. Store resumable state in a PSRAM
   arena and context; the loader zeros module BSS on each entry. Never preserve
   a C call stack across this yield.

Use the second pattern for services that cannot safely run under borrowed pages.
Batch requests/chunks to amortize module reloads. Progress/cancel polling must
respect the same rendering constraints; wide-module output can be spooled and
displayed between phases, with the audited progress path during a long phase.
No command is allowed to bypass loader checks or invoke a second module itself.

## Pipes and scripts without processes

Start with redirection and explicit temporary files. Later support
`find src | grep announcer` by executing the producer completely into a bounded
PSRAM/SD spool, closing it, then running the consumer with that spool as input.
This fits sequential modules and provides useful composition without concurrency.

Document the differences: no live producer/consumer backpressure, no `yes | head`,
and possibly delayed output. Spool limits/full-card errors must stop execution
and clean up temporary state. Preserve per-stage errors; expose the last stage's
status by default and optionally a defined pipefail mode. Keep diagnostics on
stderr separate from stdout so redirected build output remains useful.

An interactive viewer/editor/application is a top-level command, not a pipe
filter. The host suspends the console, uses the existing UI/launch flow and
restores cwd, input and scrollback on return. Ctrl-C/button cancel is a
cooperative request at safe checkpoints, not an asynchronous UNIX signal or a
forced module unload during an SD write.

## Relationship to project.gbp

Keep `project.gbp` as the reproducible build manifest. `build project.gbp` should
interpret its settings through the existing parser and normalized build request.
Later asset jobs can join the same orchestration described in `GAME_ENGINE.md`.
The terminal can show the equivalent phases and diagnostics without making the
manifest an executable script.

A separate script might contain:

```sh
cd /Projects/beisbol
git status
build project.gbp && run beisbol.gb
```

Paths/command spelling here are illustrative. `rgbasm -D _DEMO` inside the
manifest sets options for its listed units; it is not equivalent to typing that
line without an input file at a prompt. Preserve existing comment/quoting and
project-relative paths. Factor shared option parsing deliberately, coordinating
with the active assembler work. Do not have the shell rewrite project files
merely to run a command.

## Git: recommended scope

Prefer a small implementation of real Git storage over an unrelated snapshot
format named `git`. Local commits and branches do not need network access.
Use a SHA-1, loose-object repository profile first, with standard blob/tree/commit
objects and refs. Git stores snapshots as related objects; branches name commits
and `HEAD` identifies the current checkout. See the official
[object model](https://git-scm.com/book/en/v2/Git-Internals-Git-Objects) and
[repository layout](https://git-scm.com/docs/gitrepository-layout).

This is a new, modest implementation, not a port of the full Git executable or
an assumption that a desktop Git library fits the module budget. Call it a
Git subset and publish exact supported repository features. A separate custom
snapshot store could arrive sooner, but should use a different command/name
and explicit import/export rather than implying Git interoperability.

| Command | First useful implementation |
| --- | --- |
| `git init`, `git config user.name/user.email` | Create the supported repository profile and identity |
| `git status`, `git ls-files` | Compare HEAD, index and disk; tracked/deleted/untracked paths |
| `git add`, `git rm` | Stage whole files/deletions; `add -A` handles both recursively |
| `git diff`, `git diff --cached` | Worktree/index and index/HEAD text comparisons; binary change summaries |
| `git commit -m "..."` | Commit the index snapshot with parent, author/committer and message |
| `git log`, `git show` | Bounded/paged history, commit metadata and file contents |
| `git branch`, `git switch`, `git switch -c` | List/create branches and change a clean checkout |
| `git restore -- path` | Replace worktree file from index; explicit discard of unstaged changes |
| `git restore --staged -- path` | Unstage from HEAD without changing worktree |
| `git restore --source REV -- path` | Recover a file from a supported revision |
| `git revert HEAD` | Initially undo the latest single-parent commit by creating an inverse commit |

The index/staging area is essential: committing must use bytes staged by `add`,
even if the file is edited again before `commit`. A branch is a reference, not
a full copied project directory. Switch preflights affected files and refuses
dirty tracked state or untracked files that would be overwritten. No automatic
stash or destructive force mode is needed initially.

Distinguish undo operations in help. `restore` discards selected working changes;
`restore --staged` changes staging; `revert` records an undo in history. Restrict
initial `revert` to a clean index/worktree and the current single-parent tip,
where the parent tree supplies the inverse snapshot. Older-commit revert needs
three-way conflict handling and belongs with the merge milestone. Initial-commit
and merge-commit revert can be explicitly unsupported. History-rewriting reset,
rebase, merge and cherry-pick are later commands.

Support revision names first as branch names, full object IDs and a bounded
first-parent form such as `HEAD~2`. Resolve abbreviations only with ambiguity
checks if added. Do not pretend to implement Git's entire revision expression
language. Preserve binary assets exactly; pixel/audio/map editors can later
provide asset-aware diffs, but binary files already work as whole-file snapshots.

## Git storage and streaming implementation

Implement incrementally with a host test harness and official format fixtures:

- Hash object headers and bodies while streaming. Write standard zlib-compressed
  loose objects; an initial writer can use DEFLATE stored blocks to avoid a
  sophisticated compressor, trading card space for code size. Reading objects
  made by desktop Git still requires a general compatible inflater with bounded
  history storage. Reuse a proven image codec core where appropriate, not its
  PNG-specific framing. The object header/ID/compression relationship is described
  in [Git Objects](https://git-scm.com/book/en/v2/Git-Internals-Git-Objects).
- Generate trees with correct modes, byte ordering and tree-specific name sorting;
  serialize commits with exact parent/tree/identity/time/message fields. Keep
  author timezone offsets and handle an unset clock explicitly. Use known
  bytes/expected IDs to validate serialization before introducing CLI commands.
- Use the standard version-2 index, with checksums and sorted entries, rather
  than a private staging database that desktop Git cannot read. Stream merges
  of index records for `add`; retain the staged object ID and mode. Stat fields
  can be conservative; hash content when uncertain about change detection.
  Reject unknown required extensions and unmerged entries initially. Follow the
  [index specification](https://git-scm.com/docs/gitformat-index).
- Store loose refs, symbolic HEAD and recovery logs. Before updating a ref,
  verify its old value, acquire the relevant lock and publish objects first.
  Append reflogs where supported; never treat unreferenced objects from an
  interrupted command as committed history.

Do not load an entire large image, map, index or repository into WRAM. Use
chunked file I/O, PSRAM-backed scratch, external sorting/streamed walks where
needed, and explicit bounds for directory depth and history traversal. Build
diffs with bounded line tables; large/binary files may use a summary initially.
Check every referenced object's type, decoded size and content ID.

The loose-only profile must detect objects stored only in packs, packed refs,
SHA-256 repositories, linked worktrees, alternates, shallow/partial histories,
submodules and unsupported index/features before mutating anything. Some can
be supported independently later. A repository repacked by desktop Git may
therefore need conversion before this first client can use it. Packs involve
compressed and delta-based representations; they also underpin normal Git
transport and bundles. Neither `clone` nor bundle import is a small addition
to loose-object support. See the
[pack specification](https://git-scm.com/docs/gitformat-pack).

The baseline must initialize and use repositories on the Game Boy independently.
A documented desktop preparation/import tool is optional interoperability,
not a required step for every commit. Later read support for pack indexes,
REF/OFS deltas and bounded delta reconstruction would allow existing desktop
repositories more directly. Keep pack writing/GC separate; loose full snapshots
will consume card space quickly for changing binary art/music. Report usage and
never prune history automatically in the first version.

## FAT compatibility and repository recovery

Git stores path names and modes that FAT cannot always represent. Preflight
every checkout for case collisions, reserved/invalid names, trailing-dot/space
aliases, path/component limits and file/directory conflicts. Treat symlinks,
gitlinks and executable modes explicitly: reject unsupported checkout types or
preserve executable metadata in the index without inventing FAT permission bits.
Never silently rename tracked paths or normalize file contents.

Object filenames fit the current component budget, but nested branch refs,
temporary `.lock` suffixes and total repository paths need separate checks.
Git tree sorting remains byte-sensitive even though FAT lookup is not. Preserve
canonical tracked spelling and plan case-only renames through a temporary name.
Generic directory APIs must expose dot directories without recursing into
`.git` during worktree scans.

Use a plain-byte profile initially: no line-ending conversions, clean/smudge
filters, LFS, hooks, signing or arbitrary config execution. Detect attributes or
configuration that changes interpretation and report unsupported features.
Implement a documented `.gitignore` subset with tests before using it for
recursive add/status; reject unsupported patterns rather than silently selecting
unexpected files. Default templates should ignore generated builds, spools,
asset-session workspaces and recovery/trash files while retaining editable
sources. Existing repositories can intentionally track generated files.

A commit writes immutable objects before index/ref publication. A branch switch
or restore changes multiple worktree files, so it needs a separate recovery plan:
enumerate changes, check free space, retain original files, journal completion,
and update HEAD/index only at the appropriate commit point. On interruption,
finish or roll back deterministically before accepting another mutation. Retain
backups until the new checkout verifies. FAT sync/rename do not make an entire
checkout atomic; locking must cover both metadata and recovery transactions.

Run one repository mutation at a time. Refuse to steal unexplained lock files;
offer explicit recovery after validating the session/journal. Reflogs and local
backups aid recovery but are not a backup against SD-card failure. An offline
repository-copy/export workflow is sufficient initially; network fetch/push
requires hardware transport plus Git protocol, authentication and likely TLS,
which are separate work.

## Packaging the Git commands

Start with a logical `GIT.MOD` front end, measuring code size early. Split by
phase if necessary: object/hash/codec, index/tree work, history/diff and checkout
planning may require separate modules. One host dispatcher sequences them under
the single `git` command. Persist command state in a versioned PSRAM record;
no Git module calls another module or keeps pointers across invocations.

Filesystem mutations are host-service requests between phases until resident
streaming wrappers have been audited for the pages each module borrows. Reuse
the command runtime's output/cancel/I/O protocol rather than creating a second
Git-specific filesystem ABI. Long hashes, inflates and scans need progress and
cooperative cancellation before any irreversible publication step.

## Delivery and validation

1. **Console and read-only shell.** Prompt, history, cwd, completion, paging,
   `ls/stat/cat/hexdump` and module discovery. Verify document/scrollback ownership.
2. **File operations and tool commands.** Shared strict paths, raw directory
   iteration, streaming handles, safe writes, `cp/mv/mkdir/rm`, build/assembler
   adapters and clear exit statuses. Keep existing menu/module callers working.
3. **Batch composition.** Redirection, short-circuit sequences, scripts, then
   bounded spooled pipes. Test cancellation, full cards, incomplete output,
   quoted paths, glob limits and input/output aliases.
4. **Git storage.** Implement object hashing/encoding, trees/commits, refs and
   standard staging/index in a host harness. Cross-check with desktop `git
   hash-object`, `cat-file`, `ls-tree`, `status` and `fsck` on disposable fixtures.
5. **Local history on hardware.** Initialize, stage, commit, inspect/diff, branch,
   switch, restore and restricted revert. Test staged-versus-edited bytes,
   additions/deletions, binary assets, first commit and multiple branches.
6. **Reference workflow.** On Game Boy, branch beisbolgb, edit code and assets,
   inspect/stage/commit, build/run, restore an edit and revert a committed tip.
   Switch back without touching untracked work or development saves. Verify the
   resulting repository with desktop Git as an interoperability test.

Inject failures around each file/object/index/ref/checkout publication step.
Test hidden files, case/path conflicts, unsupported packed repositories, bad
checksums, disk exhaustion and reboot recovery. Run loader/ABI/editor regression
tests and exercise both one-page and wide command modules. Record DMG/CGB
timings, module sizes, WRAM/stack high-water marks, spool/scratch use and card
space amplification before expanding to pack support or merging.

The first complete terminal is useful once a user can organize project files,
run the same tools as BUILD/RUN, and maintain honest local Git history without
leaving the Game Boy. Full UNIX compatibility and online hosting can remain
separate ambitions.
