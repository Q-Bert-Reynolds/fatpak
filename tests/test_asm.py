"""ASM.MOD against RGBDS: builds modules/asm.c for the PC (tests/asm_host.c), assembles each
tests/asm/*.asm with both and compares the ROMs byte for byte; then checks error reporting.
usage: python3 tests/test_asm.py"""
import subprocess, sys, tempfile
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent / 'scripts'))

ROOT = Path(__file__).resolve().parent.parent
HOST = ROOT / 'build/asm_host'
NAMES = {1: 'SYNTAX', 2: 'SYMBOL', 3: 'DUPLICATE', 4: 'RANGE', 5: 'JR', 6: 'OPERAND', 7: 'SECTION', 8: 'FULL',
         9: 'FORWARD', 10: 'UNSUPPORTED', 11: 'NAME', 12: 'DIVIDE', 13: 'MNEMONIC', 14: 'PHASE', 15: 'STRING',
         16: 'SCOPE', 17: 'SYMBOLS', 18: 'EMPTY', 19: 'BANK', 20: 'ASSERT', 21: 'FILE', 22: 'NESTING', 23: 'OVERLAP'}
CODES = {v: k for k, v in NAMES.items()}

def run(args, **kw):
    done = subprocess.run(args, capture_output=True, text=True, **kw)
    if done.returncode:
        sys.exit(f'{args[0]} failed:\n{done.stderr}')
    return done

def ours(source, work):
    src = work / 'in.asm'
    src.write_text(source)
    out = run([str(HOST), str(src), str(work / 'ours.gb')]).stdout.split()
    status, line, pos, blocks, symbols, file = map(int, out)
    return status, line, pos, (work / 'ours.gb').read_bytes() if not status else b''

def assemble(path, work):
    """our status, line and file for a source file in place (includes resolve beside it)"""
    out = run([str(HOST), str(path), str(work / 'ours.gb')]).stdout.split()
    return int(out[0]), int(out[1]), int(out[5])

def theirs(source, work, cwd=None):
    src = work / 'in.asm'
    src.write_text(source)
    run(['rgbasm', '-o', str(work / 'in.o'), str(src)], cwd=cwd)
    run(['rgblink', '-o', str(work / 'theirs.gb'), str(work / 'in.o')])
    run(['rgbfix', '-v', '-p', '0', str(work / 'theirs.gb')])
    return (work / 'theirs.gb').read_bytes()

ERRORS = [ # source, expected error, line
    ('SECTION "a", ROM0[0]\n ld a, b\n jp Nowhere\n', 'SYMBOL', 3),
    ('SECTION "a", ROM0[0]\nX:\nX:\n', 'DUPLICATE', 3),
    ('SECTION "a", ROM0[0]\n ld a, 256\n', 'RANGE', 2),
    ('SECTION "a", ROM0[0]\nBack:\n ds 200\n jr Back\n', 'JR', 4),
    ('SECTION "a", ROM0[0]\n ld [hl], [hl]\n', 'OPERAND', 2),
    (' ld a, b\n', 'SECTION', 1),
    ('SECTION "a", ROM0[$3FFF]\n nop\n nop\n', 'FULL', 3),
    ('SECTION "a", ROM0[0]\n ds Later\nDEF Later EQU 2\n', 'FORWARD', 2),
    ('SECTION "a", ROM0[0]\n LOAD "x", WRAM0\n', 'UNSUPPORTED', 2),
    ('SECTION "a", ROM0[0]\nCHARMAP "x", 1, 2\n db \'x\'\n', 'STRING', 3),
    ('SECTION "a", ROM0[0]\n SETCHARMAP nothere\n', 'SYMBOL', 2),
    ('SECTION "a", ROM0[0]\n nop\nREPT 2\n nop\n ld a, 300\nENDR\n', 'RANGE', 5),
    ('SECTION "a", ROM0[0]\nFOR I, 2\n FOR J, 2\n  db I * 250 + J * 10\n ENDR\nENDR\n', 'RANGE', 4),
    ('SECTION "a", ROM0[0]\n INCLUDE "nothere.inc"\n', 'FILE', 2),
    ('SECTION "a", ROM0[0]\n nop\n ASSERT 1 == 2\n', 'ASSERT', 3),
    ('SECTION "a", ROM0[0]\n nop\n FAIL "no"\n', 'ASSERT', 3),
    ('SECTION "a", ROM0[0]\n IF 1\n nop\n', 'SYNTAX', 4),
    ('SECTION "a", ROM0[0]\n REPT 2\n nop\n', 'SYNTAX', 4),
    ('MACRO m\n ld a, \\1\nENDM\nSECTION "a", ROM0[0]\n m 300\n', 'RANGE', 5),
    # placement: of two equal sections the later one is placed first, so the earlier fails
    ('SECTION "a", ROM0[0]\n ds 4, 1\nSECTION "b", ROM0[2]\n ds 4, 1\n', 'OVERLAP', 1),
    ('SECTION "a", ROM0\n ds $3000, 1\nSECTION "b", ROM0\n ds $3000, 1\n', 'FULL', 1),
    ('IF DEF(Later)\nFAIL "pass 2 must not see it yet"\nENDC\nDEF Later EQU 1\nSECTION "a", ROM0[0]\n nop\n', None, 0),
    ('SECTION "a", ROM0[0]\n ld a, 1 / 0\n', 'DIVIDE', 2),
    ('SECTION "a", ROM0[0]\n mov a, b\n', 'MNEMONIC', 2),
    ('SECTION "a", ROM0[0]\n db "open\n', 'STRING', 2),
    ('SECTION "a", ROM0[0]\n.local:\n', 'SCOPE', 2),
    ('DEF X EQU 1\n', 'EMPTY', None),
    ('SECTION "a", ROMX, BANK[0]\n nop\n', 'BANK', 1),
    ('SECTION "a", ROM0[0]\n ld a,, b\n', 'SYNTAX', 2),
    ('SECTION "a", WRAM0\n db 1\n', 'SECTION', 2),
    ('SECTION "a", ROM0[0]\n nop\n ld a, ' + 'x' * 64 + '\n', 'NAME', 3),
]

def sections(work, cases=150):
    """Random section layouts: every section gets a label, and a fixed table at $3F00 holds
    each one's address and bank, so the ROMs differ wherever placement does."""
    import random
    rng = random.Random(1)
    regions = {'ROM0': (0x0000, 0x2000, 0, 0), 'ROMX': (0x4000, 0x4000, 1, 7), 'WRAM0': (0xC000, 0x1000, 0, 0),
               'WRAMX': (0xD000, 0x1000, 1, 7), 'HRAM': (0xFF80, 0x7F, 0, 0), 'VRAM': (0x8000, 0x2000, 0, 1)}
    bad = 0
    for case in range(cases):
        lines, names = [], []
        for i in range(rng.randint(2, 12)):
            t = rng.choice(['ROM0', 'ROM0', 'ROMX', 'ROMX', 'WRAM0', 'WRAMX', 'HRAM', 'VRAM'])
            base, size, b0, b1 = regions[t]
            n = rng.choice([0, 1, 2, 3, 5, 8, 16, 40, 100, 0x200, 0x900]) if t != 'HRAM' else rng.randint(0, 8)
            attrs = t
            if rng.random() < 0.25: attrs += f'[${base + rng.randrange(0, size // 2):04X}]'
            if t in ('ROMX', 'WRAMX', 'VRAM') and rng.random() < 0.4: attrs += f', BANK[{rng.randint(b0, b1)}]'
            if '[' not in attrs.split(',')[0] and rng.random() < 0.3: attrs += f', ALIGN[{rng.randint(1, 6)}]'
            lines += [f'SECTION "s{i}", {attrs}', f'L{i}:'] + ([f'  ds {n}' + (', 1' if t.startswith('ROM') else '')] if n else [])
            names.append(f'L{i}')
        lines += ['SECTION "table", ROM0[$3F00]'] + [f'  dw {l}\n  db BANK({l})' for l in names]
        source = '\n'.join(lines) + '\n'
        status, line, pos, image = ours(source, work)
        src = work / 'in.asm'
        done = subprocess.run(['rgbasm', '-o', str(work / 'in.o'), str(src)], capture_output=True)
        linked = not done.returncode and not subprocess.run(['rgblink', '-o', str(work / 'theirs.gb'), str(work / 'in.o')], capture_output=True).returncode
        if linked: run(['rgbfix', '-v', '-p', '0', str(work / 'theirs.gb')])
        if done.returncode: continue # rgbasm refused it (e.g. an overlong HRAM section): not a placement case
        if bool(status) == linked or (linked and image != (work / 'theirs.gb').read_bytes()):
            bad += 1
            if bad <= 2: print(f'sections case {case}: ours {NAMES.get(status, status)} line {line}, rgblink {"ok" if linked else "fails"}\n{source}')
    print(f'sections: {cases} random layouts, ' + (f'{bad} differ' if bad else 'all placed like rgblink'))
    return 1 if bad else 0

def main():
    # the module's ints are 16 bits on SDCC: build it that way here too
    run(['gcc', '-O1', '-DHOST_TEST', '-Dint=short', '-c', '-o', str(HOST) + '.o', str(ROOT / 'modules/asm.c')])
    run(['gcc', '-O1', '-DHOST_TEST', '-Dint=short', '-c', '-o', str(HOST) + '2.o', str(ROOT / 'modules/asm_emit.c')])
    run(['gcc', '-O1', '-DHOST_TEST', '-Dint=short', '-c', '-o', str(HOST) + '3.o', str(ROOT / 'modules/asm_line.c')])
    run(['gcc', '-O1', '-DHOST_TEST', '-Dint=short', '-c', '-o', str(HOST) + '4.o', str(ROOT / 'modules/asm_str.c')])
    run(['gcc', '-O1', '-DHOST_TEST', '-Dint=short', '-c', '-o', str(HOST) + '5.o', str(ROOT / 'modules/asm_loop.c')])
    run(['gcc', '-O1', '-DHOST_TEST', '-o', str(HOST), str(ROOT / 'tests/asm_host.c'), str(HOST) + '.o', str(HOST) + '2.o', str(HOST) + '3.o', str(HOST) + '4.o', str(HOST) + '5.o'])
    failed = 0
    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        for path in sorted((ROOT / 'tests/asm').glob('*.asm')):
            source = path.read_text()
            (work / 'lib').mkdir(exist_ok=True) # includes resolve beside the source for both
            for inc in (ROOT / 'tests/asm/lib').glob('*'): (work / 'lib' / inc.name).write_bytes(inc.read_bytes())
            status, line, pos, image = ours(source, work)
            if status:
                print(f'{path.name}: FAIL line {line}: {NAMES.get(status, status)}'); failed += 1; continue
            expected = theirs(source, work, cwd=work)
            if image != expected:
                diffs = [i for i in range(max(len(image), len(expected))) if i >= len(image) or i >= len(expected) or image[i] != expected[i]]
                print(f'{path.name}: FAIL {len(diffs)} differences (sizes {len(image)} {len(expected)})')
                for i in diffs[:6]: print(f'  ${i:04X}: ours {image[i:i+4].hex()} theirs {expected[i:i+4].hex()}')
                failed += 1
            else:
                print(f'{path.name}: {len(image)} bytes match')
        # the OS's own library files match RGBDS, unmodified
        lib = work / 'src'
        lib.mkdir(exist_ok=True)
        for name in ('math.asm', 'gbdk.asm', 'memory1.asm', 'hardware.inc'):
            text = (ROOT / 'src' / name).read_text()
            (lib / name).write_text(text)
        for name in ('math.asm', 'memory1.asm', 'gbdk.asm'):
            status, line, file = assemble(lib / name, work)
            if status:
                print(f'src/{name}: FAIL file {file} line {line}: {NAMES.get(status, status)}'); failed += 1
                continue
            mine = (work / 'ours.gb').read_bytes()
            run(['rgbasm', '-o', str(work / 'lib.o'), str(lib / name)], cwd=work)
            run(['rgblink', '-o', str(work / 'lib.gb'), str(work / 'lib.o')])
            run(['rgbfix', '-v', '-p', '0', str(work / 'lib.gb')])
            if mine != (work / 'lib.gb').read_bytes():
                print(f'src/{name}: FAIL differs from RGBDS'); failed += 1
            else:
                print(f'src/{name}: {len(mine)} bytes match')
        failed += sections(work)
        for source, name, line in ERRORS:
            status, got, pos, _ = ours(source, work)
            if name is None:
                if status: print(f'case {source!r}: got {NAMES.get(status, status)} at line {got}'); failed += 1
                continue
            if status != CODES[name] or (line and got != line):
                print(f'error case {name!r}: got {NAMES.get(status, status)} at line {got}, wanted line {line}'); failed += 1
            elif line and line <= len(source.splitlines()) and source.splitlines()[line - 1] != source[pos:].split('\n', 1)[0]:
                print(f'error case {name!r}: pos {pos} is not the start of line {line}'); failed += 1
    print('asm: ' + ('%d FAILED' % failed if failed else 'all cases match RGBDS'))
    sys.exit(1 if failed else 0)

if __name__ == '__main__':
    main()
