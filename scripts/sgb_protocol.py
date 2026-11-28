"""Fullscreen protocol v1 generator and strict reference codec (Phase 1).

This is the executable specification, not an installed GB/SNES backend. Constants
are read from protocol.asm; consumers and tests never carry another opcode list.
"""
from pathlib import Path
import argparse
import binascii
import re
import struct

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'src/sgb/protocol.asm'


def constants():
    out = {}
    for raw in SOURCE.read_text().splitlines():
        line = raw.split(';', 1)[0].strip()
        if not line:
            continue
        match = re.fullmatch(r'DEF (SGBFS_\w+) EQU (\$[0-9A-Fa-f]+|[0-9]+)', line)
        if not match:
            raise ValueError(f'unsupported protocol definition: {raw}')
        name, value = match.groups()
        if name in out:
            raise ValueError(f'duplicate definition: {name}')
        out[name] = int(value[1:], 16) if value.startswith('$') else int(value)
    return out


C = constants()
globals().update(C)
COMMANDS = {value: name.removeprefix('SGBFS_CMD_') for name, value in C.items()
            if name.startswith('SGBFS_CMD_')}
EVENTS = {value: name.removeprefix('SGBFS_EVENT_') for name, value in C.items()
          if name.startswith('SGBFS_EVENT_') and name != 'SGBFS_EVENT_SEQ_MAX'}


def generate(check=False):
    banner = '// Generated from src/sgb/protocol.asm by scripts/sgb_protocol.py.\n'
    files = {
        ROOT / 'src/sgb/protocol.h': banner + '#ifndef SGBFS_PROTOCOL_H\n#define SGBFS_PROTOCOL_H\n' +
            ''.join(f'#define {k} {v}u\n' for k, v in C.items()) + '#endif\n',
        ROOT / 'snes/protocol.inc': '; Generated from src/sgb/protocol.asm.\n' +
            ''.join(f'{k} = ${v:X}\n' for k, v in C.items()),
        ROOT / 'tests/sgb/protocol.hpp': banner + '#pragma once\n#include <cstdint>\nnamespace sgbfs {\n' +
            ''.join(f'constexpr std::uint32_t {k} = {v};\n' for k, v in C.items()) + '}\n',
    }
    for path, content in files.items():
        if check:
            if not path.exists() or path.read_text() != content:
                raise ValueError(f'stale generated protocol file: {path.relative_to(ROOT)}')
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            if not path.exists() or path.read_text() != content:
                path.write_text(content)


def require(ok, message):
    if not ok:
        raise ValueError(message)


def crc(data):
    return binascii.crc_hqx(data, SGBFS_CRC_INIT)


def newer(sequence, previous, maximum=SGBFS_PAGE_SEQ_MAX):
    require(1 <= sequence <= maximum and 1 <= previous <= maximum, 'invalid sequence')
    distance = (sequence - previous) % maximum
    return 0 < distance <= maximum // 2


def next_sequence(sequence, maximum=SGBFS_PAGE_SEQ_MAX):
    require(0 <= sequence <= maximum, 'invalid sequence')
    return sequence % maximum + 1


def rle_encode(attrs):
    result = bytearray()
    for attr in attrs:
        require(0 <= attr <= 255 and attr & 15 and attr >> 4 <= 14, 'invalid style/width')
        if result and result[-1] == attr and result[-2] < 255:
            result[-2] += 1
        else:
            result.extend((1, attr))
    return bytes(result)


def rle_decode(data, length):
    require(len(data) % 2 == 0 and 0 <= length <= SGBFS_STRIDE, 'invalid RLE length')
    result = bytearray()
    for count, attr in zip(data[::2], data[1::2]):
        require(count and attr & 15 and attr >> 4 <= 14, 'invalid RLE run')
        require(len(result) + count <= length, 'RLE overflow')
        result.extend([attr] * count)
    require(len(result) == length, 'RLE underflow')
    return bytes(result)


def row(number, font, flags, selection_start, selection_end, chars, attrs, text=0):
    chars, attrs = bytes(chars), bytes(attrs)
    require(len(chars) == len(attrs), 'character/style count mismatch')
    runs = rle_encode(attrs)
    body = bytes((number, font, flags, selection_start, selection_end, len(chars), len(runs)//2)) + chars + runs
    return command(SGBFS_CMD_ROW, body, text)


def validate_command(opcode, body, text=0):
    """text: the mode the kernel is in (TEXT): 1's rows, columns and selection in columns"""
    require(opcode in COMMANDS, 'unknown opcode')
    name, n = COMMANDS[opcode], len(body)
    R = SGBFS_TEXT_ROWS if text else SGBFS_ROWS
    if name == 'ROW':
        require(n >= 7, 'short ROW')
        y, font, flags, start, end, count, runs = body[:7]
        require(y < R and font <= 6 and flags <= SGBFS_ROW_STYLED, 'ROW geometry/font/flags')
        right = SGBFS_TEXT_COLS if text else SGBFS_TEXT_WIDTH
        require(start <= right and (end <= right or end == 255), 'ROW selection')
        require(end == 255 or start <= end, 'reversed ROW selection')
        require(count <= SGBFS_STRIDE and n == 7 + count + 2*runs, 'ROW size')
        attrs = rle_decode(body[7+count:], count)
        require(text or sum(a & 15 for a in attrs) <= SGBFS_TEXT_WIDTH, 'ROW pixel width')
    elif name == 'ROW_SAME':
        require(n == 2 and max(body) < R, 'ROW_SAME')
    elif name == 'SCROLL':
        require(n == 2 and body[1] <= 1, 'SCROLL')
        delta = struct.unpack('b', body[:1])[0]
        require(0 < abs(delta) < R, 'SCROLL delta')
    elif name == 'LAYOUT':
        require(n == 4, 'LAYOUT length')
        top, rows, bars, osk = body
        require(bars <= 3 and osk in (0, 5) and top < R and 1 <= rows <= R,
                'LAYOUT fields')
        require(top + rows + bool(bars & 2) <= R, 'LAYOUT bounds')
    elif name == 'CURSOR':
        require(n == 3 and body[0] < R and body[2] <= SGBFS_CURSOR_WHITE, 'CURSOR')
    elif name == 'BOX':
        require(n == 5, 'BOX length')
        x, width, top, rows = struct.unpack('<BHBB', body)
        require((not width and not any(body)) or
                (width >= 8 and x + width <= SGBFS_WIDTH and 1 <= rows <= SGBFS_ROWS and top + rows <= R), 'BOX geometry')
    elif name in ('BOX_LINE', 'BAR'):
        require(n >= 3 and body[1] <= 6 and body[2] <= SGBFS_STRIDE and n == 3 + body[2], 'text line length/font')
        require(body[0] < (SGBFS_ROWS if name == 'BOX_LINE' else 2), 'text line index')
    elif name == 'BOX_HI':
        require(n == 1 and (body[0] < SGBFS_ROWS or body[0] == 255), 'BOX_HI')
    elif name == 'OSK':
        require(n == 2 and body[0] < 4 and (body[1] < 50 or body[1] == 255), 'OSK')
    elif name == 'PALETTE':
        require(n >= 4 and 1 <= body[1] <= 16 and body[0] + body[1] <= 16 and n == 2 + 2*body[1], 'PALETTE size')
        require(all(not v & 0x8000 for v in struct.unpack('<'+'H'*body[1], body[2:])), 'PALETTE color')
    elif name == 'BUSY':
        require(n == 1 and body[0] <= 1, 'BUSY')
    elif name == 'PROGRESS':
        require(n == 8, 'PROGRESS length')
        loaded, total = struct.unpack('<II', body)
        require(loaded <= total, 'PROGRESS range')
    elif name == 'SCROLLBAR':
        require(n == 3 and (not body[1] or (body[0] + body[1] <= SGBFS_HEIGHT and
                body[0] <= body[2] <= body[0] + body[1] - 5)), 'SCROLLBAR')
    elif name == 'LAUNCH':
        require(body == bytes((SGBFS_LAUNCH_RESET_REQUIRED,)), 'LAUNCH mode')
    elif name == 'MAP':
        require(n == 1 and body[0] & ~SGBFS_MAP_HIRES <= 2 and body[0] != SGBFS_MAP_HIRES, 'MAP mode')
    elif name == 'MAP_TILES':
        require(n >= 2 and 1 <= body[1] <= SGBFS_MAP_TILES_MAX and body[0] + body[1] <= 256 and
                n == 2 + 16*body[1], 'MAP_TILES size')
    elif name == 'MAP_COLORS':
        require(n >= 2 and 1 <= body[1] <= SGBFS_MAP_PALETTES and body[0] + body[1] <= SGBFS_MAP_PALETTES and
                n == 2 + 8*body[1], 'MAP_COLORS size')
        require(all(not v & 0x8000 for v in struct.unpack('<'+'H'*4*body[1], body[2:])), 'MAP_COLORS color')
    elif name == 'MAP_CELLS':
        require(n >= 4 and body[0] < SGBFS_MAP_WIDTH and body[1] < SGBFS_MAP_HEIGHT and body[2] <= 1 and
                1 <= body[3] <= SGBFS_MAP_CELLS_MAX and n == 4 + 2*body[3], 'MAP_CELLS size')
        require(all(p < SGBFS_MAP_PALETTES for p in body[5::2]), 'MAP_CELLS palette')
    elif name == 'MAP_SCROLL':
        require(n == 4 and struct.unpack_from('<H', body)[0] < 1024 and struct.unpack_from('<H', body, 2)[0] < 512, 'MAP_SCROLL')
    elif name == 'CODE':
        require(4 <= n <= 3 + SGBFS_CODE_MAX and body[0] <= 1 and
                struct.unpack_from('<H', body, 1)[0] + n - 3 <= SGBFS_CODE_SIZE, 'CODE size')
    elif name == 'TEXT':
        require(n == 1 and body[0] <= 1, 'TEXT mode')
    elif name == 'EXIT':
        require(n == 0, 'EXIT takes no body')
    elif name in ('HELLO', 'RESET'):
        require(body == bytes((SGBFS_VERSION, SGBFS_PROFILE)), 'version/profile mismatch')


def command(opcode, body=b'', text=0):
    body = bytes(body)
    validate_command(opcode, body, text)
    return struct.pack('<BH', opcode, len(body)) + body


def commands(data, text=0):
    result, offset = [], 0
    while offset < len(data):
        require(offset + 3 <= len(data), 'truncated command header')
        opcode, size = struct.unpack_from('<BH', data, offset)
        offset += 3
        require(offset + size <= len(data), 'truncated command payload')
        body = bytes(data[offset:offset+size])
        validate_command(opcode, body, text)
        if opcode == SGBFS_CMD_TEXT:
            text = body[0]
        result.append((opcode, body))
        offset += size
    require(all(op != SGBFS_CMD_EXIT for op, _ in result) or len(result) == 1, 'EXIT must be alone in its page')
    return result


def page(sequence, encoded_commands, text=0):
    require(1 <= sequence <= SGBFS_PAGE_SEQ_MAX, 'invalid page sequence')
    payload = bytes(encoded_commands)
    require(len(payload) <= SGBFS_PAGE_PAYLOAD, 'page overflow')
    commands(payload, text)  # validate the complete transaction before publication
    data = struct.pack('<BH', sequence, len(payload)) + payload
    return (data + struct.pack('<H', crc(data))).ljust(SGBFS_PAGE_SIZE, b'\0')


def decode_page(data, text=0):
    require(len(data) == SGBFS_PAGE_SIZE, 'page size')
    sequence, length = struct.unpack_from('<BH', data)
    require(sequence and length <= SGBFS_PAGE_PAYLOAD, 'uncommitted/oversized page')
    end = SGBFS_PAGE_HEADER + length
    require(crc(data[:end]) == struct.unpack_from('<H', data, end)[0], 'page CRC')
    return sequence, commands(data[SGBFS_PAGE_HEADER:end], text)


def mailbox(sequence, event, a, b):
    require(1 <= sequence <= SGBFS_EVENT_SEQ_MAX and event in EVENTS, 'mailbox sequence/type')
    require(0 <= a <= 255 and 0 <= b <= 255, 'mailbox payload')
    name = EVENTS[event]
    if name == 'KEY':
        require(a and b <= 7, 'key/modifiers')
    elif name.startswith('MOUSE_'):
        require(a & SGBFS_MOUSE_ROW_MASK < SGBFS_TEXT_ROWS, 'mouse row') # (56: TEXT 1's; 28 at 256x224)
        if name == 'MOUSE_MOVE':
            require(a >> SGBFS_MOUSE_BUTTON_SHIFT == 0, 'hover buttons')
        elif name in ('MOUSE_DOWN', 'MOUSE_DRAG'):
            require(a >> SGBFS_MOUSE_BUTTON_SHIFT != 0, 'pressed mouse buttons')
    elif name == 'PAD':
        require(not b & ~a, 'pressed pad buttons must be held')
    elif name == 'HELLO':
        require(a == SGBFS_VERSION and b <= 15, 'HELLO version/features')
    elif name == 'ACK':
        require(a <= 1 and b, 'ACK page/sequence')
    elif name == 'LAUNCH_READY':
        require(a == SGBFS_LAUNCH_RESET_REQUIRED and b == 0, 'LAUNCH_READY')
    return bytes((sequence, event, a, b))


def decode_mailbox(before, data, after):
    require(len(data) == SGBFS_MAILBOX_SIZE and before == data[0] == after and not before & SGBFS_COMMIT_BUSY,
            'busy/torn mailbox')
    return tuple(mailbox(*data))


def status(heartbeat, acknowledged_event, busy=False, page_a=0, page_b=0):
    require(0 <= heartbeat <= 65535 and 0 <= acknowledged_event <= 127, 'status counters')
    require(0 <= page_a <= 255 and 0 <= page_b <= 255 and busy in (False, True), 'status fields')
    data = struct.pack('<BBHBBBB', SGBFS_STATUS_MAGIC, SGBFS_VERSION, heartbeat,
                       acknowledged_event, int(busy), page_a, page_b) + bytes(6)
    return data + struct.pack('<H', crc(data))


def decode_status(data):
    require(len(data) == SGBFS_STATUS_SIZE and data[0] == SGBFS_STATUS_MAGIC and
            data[1] == SGBFS_VERSION and not any(data[8:14]), 'status magic/version/reserved')
    require(crc(data[:14]) == struct.unpack_from('<H', data, 14)[0], 'status CRC')
    heartbeat, event, flags, a, b = struct.unpack_from('<HBBBB', data, 2)
    require(event <= 127 and flags <= 1, 'status flags/sequence')
    return heartbeat, event, bool(flags), a, b


def data_file(program, fonts=b'', overlays=b'', load=0x7f0000, entry=0x7f0000, host_checksum=b'', extension=b''):
    """Header bytes 6-7: the extension's length, last in the file (sent in CODE commands, not uploaded); its first
    word is that length too, for the GB (the SGB log reuses the header in PSRAM)"""
    program, fonts, overlays, extension = bytes(program), bytes(fonts), bytes(overlays), bytes(extension)
    require(len(extension) <= SGBFS_CODE_SIZE and (overlays or not extension), 'SGB.DAT extension')
    require(not extension or extension[:2] == struct.pack('<H', len(extension)), 'extension length word')
    require(program and not load & 4095 and 0x7f0000 <= load <= entry < load + len(program) <= 0x800000, 'SNES load/entry')
    require(load + len(program) + len(fonts) <= 0x800000, 'SNES image exceeds bank $7F')
    require(len(overlays) in (0, SGBFS_OVERLAY_PAGE_SIZE), 'overlay page alignment')
    require((bool(overlays) and len(host_checksum) == 2) or (not overlays and not host_checksum), 'overlay host binding')
    binding = bytes(host_checksum) + bytes((SGBFS_OVERLAY_ABI, SGBFS_OVERLAY_FIXED_RENDER)) if overlays else bytes(4)
    body = program + fonts + overlays + extension
    header = b'SGB1' + bytes((SGBFS_VERSION, SGBFS_DATA_HEADER)) + struct.pack('<H', len(extension))
    header += load.to_bytes(3, 'little') + entry.to_bytes(3, 'little')
    header += struct.pack('<IIIH', len(program), len(fonts), len(overlays), 0) + binding
    image = header + body
    return image[:26] + struct.pack('<H', crc(image)) + image[28:]


def decode_data_file(data, host_checksum=None):
    require(len(data) >= SGBFS_DATA_HEADER and data[:6] == b'SGB1'+bytes((SGBFS_VERSION, SGBFS_DATA_HEADER)), 'SGB.DAT header')
    e, = struct.unpack_from('<H', data, 6)
    load, entry = int.from_bytes(data[8:11], 'little'), int.from_bytes(data[11:14], 'little')
    p, f, o, checksum = struct.unpack_from('<IIIH', data, 14)
    require(SGBFS_DATA_HEADER + p + f + o + e == len(data) and crc(data[:26] + bytes(2) + data[28:]) == checksum, 'SGB.DAT size/CRC')
    if o:
        require(host_checksum is not None and data[28:30] == bytes(host_checksum) and
                data[30:32] == bytes((SGBFS_OVERLAY_ABI, SGBFS_OVERLAY_FIXED_RENDER)), 'overlay host/ABI/kind mismatch')
    else:
        require(not any(data[28:32]), 'unexpected overlay binding')
    parts = data[32:32+p], data[32+p:32+p+f], data[32+p+f:32+p+f+o]
    extension = data[32+p+f+o:]
    require(data_file(*parts, load, entry, host_checksum=bytes(host_checksum) if o else b'',
                      extension=extension) == data, 'SGB.DAT metadata')
    return load, entry, parts + (extension,)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    generate(parser.parse_args().check)
