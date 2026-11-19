#!/usr/bin/env python3
"""Check the real GB publisher's transactions, independently of host rendering."""
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'scripts'))
import sgb_protocol as wire
from kernel_build import recording

pages=recording(sys.argv[1])
row_bytes=legacy_bytes=0
for raw in pages:
    _,commands=wire.decode_page(raw)
    for op,body in commands:
        if op!=wire.SGBFS_CMD_ROW:continue
        count=body[5];runs=body[7+count:]
        assert runs==wire.rle_encode(wire.rle_decode(runs,count)), 'ROW has redundant adjacent attribute runs'
        row_bytes+=len(body);legacy_bytes+=7+3*count
assert row_bytes<legacy_bytes, 'frontend did not exercise ROW compression'
print(f'PASS: frontend ROW payloads use {row_bytes}/{legacy_bytes} bytes with merged runs')

# Each completed draw ends in CURSOR, even when its commands span pages.
# The fixture walks through unchanged document text in both directions, so
# only the exposed row should be published. Edits may legitimately send more.
scroll_rows=[]
scroll_delta=None
changed=0
for raw in pages:
    for op,body in wire.decode_page(raw)[1]:
        if op==wire.SGBFS_CMD_SCROLL:
            assert scroll_delta is None, 'nested scroll before draw completion'
            scroll_delta=int.from_bytes(body[:1], 'little', signed=True)
            changed=0
        elif op==wire.SGBFS_CMD_ROW and scroll_delta is not None:
            changed+=1
        elif op==wire.SGBFS_CMD_CURSOR and scroll_delta is not None:
            assert changed==1, f'scroll republished {changed} rows instead of retaining the viewport'
            scroll_rows.append((scroll_delta,changed))
            scroll_delta=None
assert scroll_delta is None, 'incomplete scroll draw'
assert len(scroll_rows)>=10 and {delta for delta,_ in scroll_rows}=={-1,1}, 'missing repeated bidirectional scrolling'
print(f'PASS: {len(scroll_rows)} real frontend scrolls publish only the exposed row instead of all 26')

menu=False
for raw in pages:
    sequence,commands=wire.decode_page(raw)
    if any(op==7 and b'SETTINGS' in body[3:] for op,body in commands):menu=True
    if menu and any(op==6 and body==bytes(5) for op,body in commands):
        assert all(op not in (1,2,3) for op,_ in commands), 'closing a menu republished or scrolled base text'
        print(f'PASS: real GB menu-close transaction {sequence} contains no ROW/ROW_SAME/SCROLL')
        break
else:raise AssertionError('no complete menu open/close in the recording')
