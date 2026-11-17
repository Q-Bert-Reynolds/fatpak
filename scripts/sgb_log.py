#!/usr/bin/env python3
"""Read the bounded hardware flight recorder at /GBCSYS/SGB.LOG."""
import argparse
import csv
import struct
import sys
from pathlib import Path

KINDS = {1: 'start', 2: 'publish', 3: 'ack', 4: 'timeout', 5: 'key', 6: 'sd_write', 7: 'sd_error', 8: 'wait_state'}
KINDS.update(enumerate(('good', 'bad', 'miss', 'rows', 'draw_frames', 'ui_frames',
                        'page_frames', 'mail_frames', 'snes_frame'), 32))


def decode(data):
    if len(data) < 16 or data[:8] != b'SGBLOG1\0' or data[10] != 12:
        raise ValueError('unsupported or truncated SGB log header')
    if any(data[13:16]):
        raise ValueError('nonzero reserved header bytes')
    records = []
    previous = epoch = 0
    for at in range(16, len(data) - 11, 12):
        kind, page, frame, pending, fault, seq, event, a, b, row, deferred = struct.unpack_from('<BBH8B', data, at)
        if kind not in KINDS:
            raise ValueError(f'unknown record {kind} at byte {at}')
        if frame < previous:
            epoch += 65536
        previous = frame
        item = dict(gb_frame=epoch+frame, kind=KINDS[kind], page=page,
                    pending=pending, fault=fault, event_seq=seq, event=event,
                    a=a, b=b, row=row, deferred=deferred, value='')
        if kind >= 32:
            item['value'] = a | b << 8
        elif kind == 6:
            item['value'] = (frame - (row | deferred << 8)) & 65535
        elif kind == 7:
            item['value'] = row
        elif kind == 8:
            item['value'] = f'LCDC={a:02X} LY={b:02X} IE={row:02X} IF={deferred:02X}'
        records.append(item)
    return data[8:10].hex().upper(), records


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('log', type=Path)
    args = parser.parse_args()
    data = args.log.read_bytes()
    binding, records = decode(data)
    print(f'OS checksum: {binding}; SGB.DAT CRC: {int.from_bytes(data[11:13], "little"):04X}; {len(records)} records', file=sys.stderr)
    if (len(data)-16) % 12:
        print('Ignoring a partial final record', file=sys.stderr)
    if records:
        writer = csv.DictWriter(sys.stdout, fieldnames=records[0].keys())
        writer.writeheader()
        writer.writerows(records)


if __name__ == '__main__':
    main()
