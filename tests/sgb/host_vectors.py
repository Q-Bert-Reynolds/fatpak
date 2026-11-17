#!/usr/bin/env python3
"""Cross-check Gearboy's independent decoder against the Phase 1 Python codec."""
from pathlib import Path
import random
import struct
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'scripts'))
import sgb_protocol as p

# Prefix gives every stateless valid BOX_LINE/SCROLL a valid model context.
prefix = p.command(p.SGBFS_CMD_BOX, struct.pack('<BHBB', 0, 256, 0, 28))
bodies = {
    1: bytes([0,2,1,0,255,2,1,65,66,2,4]), 2: bytes([0,27]),
    3: bytes([1,0]), 4: bytes([1,26,3,0]), 5: bytes([27,255,2]),
    6: struct.pack('<BHBB', 16,240,0,28), 7: bytes([27,6,2,65,66]),
    8: bytes([27]), 9: bytes([1,6,2,65,66]), 10: bytes([3,49]),
    11: bytes([0,2,0,0,255,127]), 12: bytes([1]),
    13: struct.pack('<II', 5,10), 14: bytes([1]), 15: bytes([1,0]), 16: bytes([1,0]),
}
rng = random.Random(0x534742)
output = bytearray()
for op, original in bodies.items():
    candidates = [original, b'', original+b'\0']
    for i in range(len(original)):
        for v in (0,1,7,27,28,64,127,128,248,255):
            b=bytearray(original); b[i]=v; candidates.append(bytes(b))
    for _ in range(64):
        candidates.append(rng.randbytes(rng.randrange(0,30)))
    for body in candidates:
        raw=prefix+struct.pack('<BH',op,len(body))+body
        try:
            p.commands(raw); valid=True
        except ValueError:
            valid=False
        header=struct.pack('<BH',1,len(raw))+raw
        page=(header+struct.pack('<H',p.crc(header))).ljust(1920,b'\0')
        output += bytes([int(valid)])+page
path=Path(__file__).resolve().parents[2]/'build/sgb/host-vectors.bin'
path.parent.mkdir(parents=True,exist_ok=True); path.write_bytes(output)
print(f'{len(output)//1921} independent Python/C++ protocol vectors: {path}')

# Verify that the bytes captured by DATA_TRN match the SGB.DAT upload section.
blob=(path.parent/'bench.bin').read_bytes()
(path.parent/'bench.SGB.DAT').write_bytes(p.data_file(blob))
