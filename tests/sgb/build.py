#!/usr/bin/env python3
"""Build Phase 0 probes independently of FatPak's OS/data/modules."""
from pathlib import Path
import subprocess
import argparse

ROOT = Path(__file__).resolve().parents[2]
WORK = ROOT / 'build/sgb'


def run(*args):
    subprocess.run(args, cwd=ROOT, check=True)


def build(probe="hello"):
    assert probe in ("hello", "bench", "handoff")
    WORK.mkdir(parents=True, exist_ok=True)
    if probe == 'bench':
        rows = ['', 'PHASE 0B LCD CHANNEL', '', 'STAGE', 'GOOD', 'BAD', 'MISSED',
                'ROWS', 'GB FRAMES', 'BYTES LO', 'BYTES HI', 'ACTIVE', 'PEAK',
                'RTT MAX', 'RAM AUDIT', 'TX / RX', 'RX FLAGS',
                'RAW B / E', 'RAW C / D', 'SNES SEQ / FLAG',
                'ACK WRITES', 'RESET SNES TO EXIT',
                'CONST HIGH', 'CONST LOW', 'HELD PLAIN', 'HELD BUSY',
                'NO P1 WRITE', 'DIAG STEP (6 DONE)']
        (WORK / 'bench.screen').write_bytes(bytes(ord(c)-32 for row in rows
            for c in ('  ' + row).ljust(32)))
    run('ca65', '-o', str(WORK / f'{probe}.o'), f'tests/sgb/{probe}.s')
    run('ld65', '-C', 'tests/sgb/hello.cfg', '-Ln', str(WORK / f'{probe}.lbl'),
        '-o', str(WORK / f'{probe}.bin'), str(WORK / f'{probe}.o'))
    labels = {name.lstrip('.'): int(addr, 16) for _, addr, name in
              (line.split() for line in (WORK / f'{probe}.lbl').read_text().splitlines())}
    payload = (WORK / f'{probe}.bin').read_bytes()
    assert labels['Entry'] == 0x7F0000 and len(payload) <= 4096
    # A position-dependent tail tests all 4 KiB, including the last partial row.
    payload += bytes(((i * 73) ^ (i >> 3)) & 255 for i in range(len(payload), 4096))
    (WORK / f'{probe}.bin').write_bytes(payload)
    (WORK / f'{probe}.inc').write_text(
        'DEF PROBE_ENTRY EQU $%06X\nDEF PROBE_NMI EQU $%06X\n' %
        (labels['Entry'], labels['Nmi']))
    (WORK / f'{probe}-gb.asm').write_text(
        f'INCLUDE "build/sgb/{probe}.inc"\nDEF PROBE_NAME EQUS \"{probe}\"\n' +
        ('DEF SGB_BENCH EQU 1\n' if probe == 'bench' else '') +
        ('DEF SGB_HANDOFF EQU 1\n' if probe == 'handoff' else '') +
        'INCLUDE "tests/sgb/hello.asm"\n')
    run('rgbasm', '-o', str(WORK / f'{probe}-gb.o'), str(WORK / f'{probe}-gb.asm'))
    run('rgblink', '-n', str(WORK / f'{probe}.sym'), '-o', str(WORK / f'{probe}.gb'),
        str(WORK / f'{probe}-gb.o'))
    run('rgbfix', '-v', '-s', '-l', '0x33', '-t', 'SGB' + probe.upper(), '-m', '0',
        '-p', '255', str(WORK / f'{probe}.gb'))
    print(f'{probe}: build/sgb/{probe}.gb (DATA_TRN 4096 bytes to $7F0000 + JUMP)')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('probe', nargs='?', default='hello', choices=['hello', 'bench', 'handoff'])
    build(parser.parse_args().probe)
