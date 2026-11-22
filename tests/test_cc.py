"""CC (modules/cc) on a PC: builds tests/cc_host.c, compiles each tests/cc/*.c, links it with
the runtime through RGBDS and runs it in Gearboy (tests/cc_run.cpp), where main returns 0 or
the line of its first failed CHECK; then checks the compiler's error messages.
usage: python3 tests/test_cc.py [fixture...]"""
import os, subprocess, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CC = ROOT / 'modules/cc'
HOST = ROOT / 'build/cc_host'
RUNNER = ROOT / 'build/cc_run'
ASM_HOST = ROOT / 'build/asm_host' # ASM.MOD and LINK.MOD on a PC, built by tests/test_asm.py
GEARBOY = Path(os.environ.get('GEARBOY_ROOT', ROOT.parent / 'Gearboy'))

def run(args, **kw):
    done = subprocess.run([str(a) for a in args], capture_output=True, text=True, **kw)
    if done.returncode:
        sys.exit(f'{args[0]} failed:\n{done.stdout}{done.stderr}')
    return done

PASSES = { # each pass is a module on the Game Boy: its own object here, only its entries global,
    # so the passes share nothing but the emulated PSRAM (and the host functions)
    'a': (['cc_pre_main.c', 'cc_pre_lex.c', 'cc_pre_dir.c', 'cc_pre_if.c', 'cc_core.c', 'cc_arith.c'], ['cc_pass_a_init', 'cc_define', 'cc_pass_a']),
    'b': (['cc_parse_stmt.c', 'cc_parse_expr.c', 'cc_parse_tree.c', 'cc_parse_decl.c', 'cc_parse_init.c', 'cc_core.c', 'cc_arith.c', 'cc_types.c'], ['cc_pass_b']),
    'c': (['cc_gen_main.c', 'cc_gen_code.c', 'cc_gen_emit.c', 'cc_core.c', 'cc_types.c'], ['cc_pass_c']),
}
CFLAGS = ['-std=c99', '-DCC_HOST', '-O1', '-g', '-Wall', '-Wextra', '-Werror', '-Wno-unused-parameter', '-fsanitize=address,undefined']

def build():
    objects = []
    for name, (sources, entries) in PASSES.items():
        parts = []
        for src in sources:
            parts.append(ROOT / f'build/cc_{name}_{Path(src).stem}.o')
            run(['gcc', *CFLAGS, '-c', '-o', parts[-1], CC / src])
        objects.append(ROOT / f'build/cc_pass_{name}.o')
        run(['ld', '-r', '-o', objects[-1], *parts])
        run(['objcopy', *[f'--keep-global-symbol={e}' for e in entries], objects[-1]])
    run(['gcc', *CFLAGS, '-o', HOST, ROOT / 'tests/cc_host.c', CC / 'cc_msgs.c', *objects])
    deps = [ROOT / 'tests/cc_run.cpp']
    if not RUNNER.exists() or any(d.stat().st_mtime > RUNNER.stat().st_mtime for d in deps):
        objects = [*GEARBOY.glob('src/*.o'), *GEARBOY.glob('src/audio/*.o'),
                   GEARBOY / 'platforms/shared/dependencies/miniz/miniz.o',
                   GEARBOY / 'platforms/shared/desktop/trace_logger_formatter.o']
        run([os.environ.get('CXX', 'c++'), '-O2', '-std=c++11', '-fno-rtti', f'-I{GEARBOY}/src',
             ROOT / 'tests/cc_run.cpp', *objects, '-latomic', '-o', RUNNER])

def compile_c(source, work, name='unit', extra=()):
    out = work / f'{name}.asm'
    done = subprocess.run([str(HOST), '-I', str(CC / 'include'), *extra, str(source), '-o', str(out)],
                          capture_output=True, text=True)
    return done, out

def link(units, work, name):
    objects = []
    for unit in [CC / 'rt/crt0.asm', CC / 'rt/ccrt.asm', *units, CC / 'rt/crtend.asm']:
        obj = work / (Path(unit).stem + '.o')
        run(['rgbasm', '-o', obj, unit])
        objects.append(obj)
    rom, sym = work / f'{name}.gb', work / f'{name}.sym'
    run(['rgblink', '-o', rom, '-n', sym, *objects])
    run(['rgbfix', '-v', '-p', '0', rom])
    return rom, sym

def sdcc(source, work):
    """a peer unit compiled by SDCC, as RGBDS assembly"""
    out = work / (source.stem + '.asm')
    run(['sdcc', '-msm83', '--sdcccall', '1', '--asm=rgbds', '--dataseg', 'WRAM0', '--no-peep', '-S', '-o', out, source.name], cwd=source.parent)
    out.write_text(out.read_text().replace('\tjp\t(hl)', '\tjp\thl')) # SDCC 4.2's spelling, which RGBDS 1.0 rejects
    return out

def fixture(path, work, model):
    done, asm = compile_c(path, work, path.stem)
    if done.returncode:
        return f'compile failed:\n{done.stderr}'
    units = [asm]
    for line in path.read_text().splitlines():
        if line.startswith('// peer: '):
            units.append(sdcc(path.parent / line[9:].strip(), work))
    rom, sym = link(units, work, path.stem)
    if len(units) == 1 and model == 'cgb':
        problem = asm_mod(asm, rom, work)
        if problem:
            return problem
    result = subprocess.run([str(RUNNER), str(rom), str(sym), '600', model], capture_output=True, text=True)
    words = result.stdout.split()
    if result.returncode or words[:2] != ['exit', '0']:
        return f'{model}: {result.stdout.strip()}{" (the CHECK on that line)" if words[:1] == ["exit"] else ""} {result.stderr}'
    return None

ERRORS = [ # source, part of the message, line
    ('int main(void) { return x; }', 'undeclared: x', 1),
    ('int main(void) {\n int a;\n int a;\n return 0; }', 'already declared: a', 3),
    ('int main(void) { float f; return 0; }', 'floating point', 1),
    ('int main(void) { return 1.5; }', 'floating point', 1),
    ('int f(int a, ...);', 'variadic', 1),
    ('int main(void) { int* p = 5; return 0; }', 'integer converted to a pointer', 1),
    ('int main(void) { return 1 / 0; }', 'division by zero', 1),
    ('int main(void) { int x = 1 << 16; return x; }', 'shift count', 1),
    ('struct s { int a : 3; };', 'bitfields', 1),
    ('#pragma once\nint x;', 'pragma', 1),
    ('#define F(a) #a\n', 'not supported', 1),
    ('#define F(a, b) a\nint x = F(1);', 'wrong number of macro arguments', 2),
    ('#if 1\nint x;\n', '#if without #endif', 3),
    ('#error stop here\n', 'stop here', 1),
    ('#include "nothere.h"\n', "can't open", 1),
    ('int main(void) { goto nowhere; }', 'undefined label: nowhere', 1),
    ('int main(void) { break; }', 'break outside', 1),
    ('int main(void) { const int c = 1; c = 2; return c; }', 'const', 1),
    ('void f(void) { return 1; }', 'return with a value', 1),
    ('int f(int a); int main(void) { return f(1, 2); }', 'too many arguments', 1),
    ('int main(void) { long long x; return 0; }', 'long long', 1),
    ('int main(void) { int a[] = {1, 2}; return a[0]; }', None, 0),
    ('int main(void) {\n  switch (1) { case 1: case 1: break; }\n return 0; }', 'duplicate case', 2),
    ("int main(void) { return 'ab'; }", 'one character', 1),
    ('int main(void) { struct q *p; return p->x; }', 'incomplete', 1),
    ('int g(void) { return 0; } int g(void) { return 1; }', 'defined twice', 1),
    ('int main(void) { int x; x(); return 0; }', 'non-function', 1),
]

def errors(work):
    failed = 0
    for source, message, line in ERRORS:
        src = work / 'err.c'
        src.write_text(source)
        done, _ = compile_c(src, work, 'err')
        text = done.stderr
        if message is None:
            ok = done.returncode == 0
        else:
            ok = done.returncode == 1 and message in text and f'err.c:{line}: error' in text
        if not ok:
            print(f'FAIL error test {source!r}: wanted {message!r} at line {line}, got: {text.strip() or "success"}')
            failed += 1
    return failed

def asm_mod(asm, rom, work):
    """the same units through ASM.MOD + LINK.MOD (a project.gbp): the ROM must match RGBDS's"""
    folder = work / 'asm_mod'
    folder.mkdir(exist_ok=True)
    names = ['crt0.asm', 'ccrt.asm', asm.name, 'crtend.asm']
    for name, src in zip(names, [CC / 'rt/crt0.asm', CC / 'rt/ccrt.asm', asm, CC / 'rt/crtend.asm']):
        (folder / name).write_text(Path(src).read_text())
    (folder / 'project.gbp').write_text('main ' + ' '.join(names) + '\n')
    out = subprocess.run([str(ASM_HOST), str(folder / asm.name), str(work / 'asm_mod.gb')], capture_output=True, text=True).stdout.split()
    if not out or out[0] != '0':
        return f'ASM.MOD error {out[:2]} (status, line) in {out[6:] or asm.name}'
    if (work / 'asm_mod.gb').read_bytes() != rom.read_bytes():
        return 'ASM.MOD built a different ROM from RGBDS'
    return None

def main():
    run([sys.executable, ROOT / 'scripts/cc_pages.py', '--check']) # each page's CC_NEED_ block
    run([sys.executable, ROOT / 'scripts/cc_errors.py', '--check']) # notes/CC_ERRORS.md
    build()
    if not ASM_HOST.exists():
        run([sys.executable, ROOT / 'tests/test_asm.py'])
    names = sys.argv[1:]
    fixtures = [p for p in sorted((ROOT / 'tests/cc').glob('*.c')) if not names or p.stem in names]
    failed = 0
    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        for path in fixtures:
            for model in ('cgb', 'dmg'):
                problem = fixture(path, work, model)
                if problem:
                    print(f'FAIL {path.name}: {problem}')
                    failed += 1
                    break
            else:
                print(f'ok {path.name}')
        if not names:
            failed += errors(work)
    if failed:
        sys.exit(f'{failed} failed')
    print('all passed')

if __name__ == '__main__':
    main()
