"""ASM.MOD against RGBDS: builds modules/asm.c for the PC (tests/asm_host.c), assembles each
tests/asm/*.asm with both and compares the ROMs byte for byte; then checks error reporting.
usage: python3 tests/test_asm.py"""
import subprocess, sys, tempfile
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

ROOT = Path(__file__).resolve().parent.parent
HOST = ROOT / 'build/asm_host'
NAMES = {1: 'SYNTAX', 2: 'SYMBOL', 3: 'DUPLICATE', 4: 'RANGE', 5: 'JR', 6: 'OPERAND', 7: 'SECTION', 8: 'FULL',
         9: 'FORWARD', 10: 'UNSUPPORTED', 11: 'NAME', 12: 'DIVIDE', 13: 'MNEMONIC', 14: 'PHASE', 15: 'STRING',
         16: 'SCOPE', 17: 'SYMBOLS', 18: 'EMPTY', 19: 'BANK'}
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
    status, line, pos, blocks, symbols = map(int, out)
    return status, line, pos, (work / 'ours.gb').read_bytes() if not status else b''

def theirs(source, work):
    src = work / 'in.asm'
    src.write_text(source)
    run(['rgbasm', '-o', str(work / 'in.o'), str(src)])
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
    ('SECTION "a", ROM0[0]\n INCLUDE "x.inc"\n', 'UNSUPPORTED', 2),
    ('SECTION "a", ROM0[0]\n ld a, 1 / 0\n', 'DIVIDE', 2),
    ('SECTION "a", ROM0[0]\n mov a, b\n', 'MNEMONIC', 2),
    ('SECTION "a", ROM0[0]\n db "open\n', 'STRING', 2),
    ('SECTION "a", ROM0[0]\n.local:\n', 'SCOPE', 2),
    ('DEF X EQU 1\n', 'EMPTY', None),
    ('SECTION "a", ROMX, BANK[0]\n nop\n', 'BANK', 1),
    ('SECTION "a", ROM0[0]\n ld a,, b\n', 'SYNTAX', 2),
    ('SECTION "a", WRAM0\n db 1\n', 'SECTION', 2),
    ('SECTION "a", ROM0[0]\n nop\n ld a, ' + 'x' * 33 + '\n', 'NAME', 3),
]

def main():
    # the module's ints are 16 bits on SDCC: build it that way here too
    run(['gcc', '-O1', '-DHOST_TEST', '-Dint=short', '-c', '-o', str(HOST) + '.o', str(ROOT / 'modules/asm.c')])
    run(['gcc', '-O1', '-DHOST_TEST', '-Dint=short', '-c', '-o', str(HOST) + '2.o', str(ROOT / 'modules/asm_emit.c')])
    run(['gcc', '-O1', '-DHOST_TEST', '-o', str(HOST), str(ROOT / 'tests/asm_host.c'), str(HOST) + '.o', str(HOST) + '2.o'])
    failed = 0
    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        for path in sorted((ROOT / 'tests/asm').glob('*.asm')):
            source = path.read_text()
            status, line, pos, image = ours(source, work)
            if status:
                print(f'{path.name}: FAIL line {line}: {NAMES.get(status, status)}'); failed += 1; continue
            expected = theirs(source, work)
            if image != expected:
                diffs = [i for i in range(max(len(image), len(expected))) if i >= len(image) or i >= len(expected) or image[i] != expected[i]]
                print(f'{path.name}: FAIL {len(diffs)} differences (sizes {len(image)} {len(expected)})')
                for i in diffs[:6]: print(f'  ${i:04X}: ours {image[i:i+4].hex()} theirs {expected[i:i+4].hex()}')
                failed += 1
            else:
                print(f'{path.name}: {len(image)} bytes match')
        for source, name, line in ERRORS:
            status, got, pos, _ = ours(source, work)
            if status != CODES[name] or (line and got != line):
                print(f'error case {name!r}: got {NAMES.get(status, status)} at line {got}, wanted line {line}'); failed += 1
            elif line and source.splitlines()[line - 1] != source[pos:].split('\n', 1)[0]:
                print(f'error case {name!r}: pos {pos} is not the start of line {line}'); failed += 1
    print('asm: ' + ('%d FAILED' % failed if failed else 'all cases match RGBDS'))
    sys.exit(1 if failed else 0)

if __name__ == '__main__':
    main()
