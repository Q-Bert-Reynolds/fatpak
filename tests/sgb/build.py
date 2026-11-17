#!/usr/bin/env python3
"""Build the Phase 0a probe independently of FatPak's OS/data/modules."""
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]
WORK = ROOT / 'build/sgb'


def run(*args):
    subprocess.run(args, cwd=ROOT, check=True)


def build():
    WORK.mkdir(parents=True, exist_ok=True)
    run('ca65', '-o', str(WORK / 'hello.o'), 'tests/sgb/hello.s')
    run('ld65', '-C', 'tests/sgb/hello.cfg', '-Ln', str(WORK / 'hello.lbl'),
        '-o', str(WORK / 'hello.bin'), str(WORK / 'hello.o'))
    labels = {name.lstrip('.'): int(addr, 16) for _, addr, name in
              (line.split() for line in (WORK / 'hello.lbl').read_text().splitlines())}
    payload = (WORK / 'hello.bin').read_bytes()
    assert labels['Entry'] == 0x7F0000 and len(payload) <= 4096
    # A position-dependent tail tests all 4 KiB, including the last partial row.
    payload += bytes(((i * 73) ^ (i >> 3)) & 255 for i in range(len(payload), 4096))
    (WORK / 'hello.bin').write_bytes(payload)
    (WORK / 'hello.inc').write_text(
        'DEF HELLO_ENTRY EQU $%06X\nDEF HELLO_NMI EQU $%06X\n' %
        (labels['Entry'], labels['Nmi']))
    run('rgbasm', '-o', str(WORK / 'hello-gb.o'), 'tests/sgb/hello.asm')
    run('rgblink', '-n', str(WORK / 'hello.sym'), '-o', str(WORK / 'hello.gb'),
        str(WORK / 'hello-gb.o'))
    run('rgbfix', '-v', '-s', '-l', '0x33', '-t', 'SGBHELLO', '-m', '0',
        '-p', '255', str(WORK / 'hello.gb'))
    print('Phase 0a: build/sgb/hello.gb (DATA_TRN 4096 bytes to $7F0000 + JUMP)')


if __name__ == '__main__':
    build()
