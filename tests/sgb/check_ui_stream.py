#!/usr/bin/env python3
"""Check the real GB publisher's transactions, independently of host rendering."""
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'scripts'))
import sgb_protocol as wire
from kernel_build import recording

pages=recording(sys.argv[1])
menu=False
for raw in pages:
    sequence,commands=wire.decode_page(raw)
    if any(op==7 and b'SETTINGS' in body[3:] for op,body in commands):menu=True
    if menu and any(op==6 and body==bytes(5) for op,body in commands):
        assert all(op not in (1,2,3) for op,_ in commands), 'closing a menu republished or scrolled base text'
        print(f'PASS: real GB menu-close transaction {sequence} contains no ROW/ROW_SAME/SCROLL')
        break
else:raise AssertionError('no complete menu open/close in the recording')
