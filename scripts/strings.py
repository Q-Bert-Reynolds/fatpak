"""The UI's strings in every language (notes/LANGUAGES.md), from data/strings/strings.csv:
key, kind, comment, then a column per language (en first, the fallback). Writes src/strings.h
(S_<key> ids, in CSV order, so a menu's items are consecutive ids) and bin/LANG/<CODE>.DAT, the
image a language loads into PSRAM at LANG_BLOCK:

  block 0             "FPKL", LANG_VERSION, the key list's hash (2 bytes), the string count (2 bytes)
  LANG_HELP (4)       the editor's and browser's help, 32 lines of 32 bytes each (data/help/*.txt;
                      data/help/<name>.<lang>.txt for another language)
  LANG_TABLE...       an offset per string from the table's start (2 bytes each), then the strings:
                      Latin-1, 0 ends one, PART_SEPARATOR stands for each {} (PutStr's pieces)

<A> <B> <SELECT> <START> <LR> <UD> ... are the icons in src/ui/icons.h. Each kind has a limit
the text must fit (the widest of the pieces for a bar is measured in VWF pixels).

usage: python3 scripts/strings.py
"""
import binascii
import csv
import re
import sys
from pathlib import Path
import utils
from data_file import db_bytes

ROOT = Path(__file__).resolve().parent.parent
CSV = ROOT / 'data/strings/strings.csv'
PART_SEPARATOR = 0x1F
BLOCK = 512
HELP_PIXELS = 152  # a text row from column 1
BAR_PIXELS = 111  # status bar text from column 1, clear of the footer clock (FooterCompose: 160 - 48)
LIMITS = {'item': 18, 'box': 19, 'row': 39, 'bar': 47}


def icons():
    out = {}
    for name, code in re.findall(r'#define ICON_(\w+)\s+"\\(\d+)"', (ROOT / 'src/ui/icons.h').read_text()):
        out[f'<{name}>'] = chr(int(code, 8))
    return out


def buttons():
    text = (ROOT / 'src/charmap.asm').read_text(encoding='utf8')
    return {token: chr(int(code)) for token, code in re.findall(r'charmap "(<BTN_[A-Z]+>)", (\d+)', text)}


def load():
    with open(CSV, encoding='utf8', newline='') as file:
        rows = list(csv.reader(file))
    header = rows[0]
    assert header[:3] == ['key', 'kind', 'comment'] and header[3] == 'en', 'columns: key, kind, comment, en, ...'
    languages = header[3:]
    strings = []
    for row in rows[1:]:
        if not row or not row[0]:
            continue
        key, kind, _comment, *texts = row
        assert re.fullmatch(r'[A-Z][A-Z0-9_]*', key), f'bad key {key}'
        assert kind in LIMITS, f'{key}: kind {kind}'
        texts += [''] * (len(languages) - len(texts))
        strings.append((key, kind, [t if t or i == 0 else texts[0] for i, t in enumerate(texts)]))
    keys = [s[0] for s in strings]
    assert len(set(keys)) == len(keys), 'a key is used twice'
    return languages, strings


def encode(text, tags):
    for tag, char in tags.items():
        text = text.replace(tag, char)
    data = text.encode('latin1').replace(b'{}', bytes([PART_SEPARATOR]))
    assert b'<' not in data or b'>' not in data, f'unknown tag in {text!r}'
    return data


def widths():
    return db_bytes(str(ROOT / 'img/fonts/font_vwf.asm'), 'FontVWFWidths')


def check(key, kind, language, data, english, vwf):
    pieces = data.split(bytes([PART_SEPARATOR]))
    assert len(pieces) == len(english.split(bytes([PART_SEPARATOR]))), f'{key} ({language}): {{}} count differs from English'
    assert len(data) <= LIMITS['bar'], f'{key} ({language}) is over {LIMITS["bar"]} characters'
    if kind == 'bar':
        pixels = sum(vwf[c] for c in data if c != PART_SEPARATOR)
        assert pixels <= BAR_PIXELS, f'{key} ({language}): {pixels} pixels, the status bar has {BAR_PIXELS}'
    else:
        text = data.replace(bytes([PART_SEPARATOR]), b'')
        assert len(text) <= LIMITS[kind], f'{key} ({language}): {len(text)} characters, {kind} allows {LIMITS[kind]}'


def key_hash(strings):
    return binascii.crc_hqx(','.join(key for key, _, _ in strings).encode(), 0xFFFF)


def help_screens(language):
    data = bytearray(4 * BLOCK)
    tokens, vwf = buttons(), widths()
    for context, name in enumerate(('editor', 'browser')):
        path = ROOT / f'data/help/{name}.{language}.txt'
        if language == 'en' or not path.exists():
            path = ROOT / f'data/help/{name}.txt'
        lines = path.read_text(encoding='utf8').splitlines()
        assert len(lines) == 32, f'{path.name} must have 32 lines'
        for i, line in enumerate(lines):
            for token, char in tokens.items():
                line = line.replace(token, char)
            encoded = line.encode('latin1')
            assert len(encoded) < 32, f'{path.name}: help line too long: {line}'
            pixels = sum(vwf[c] for c in encoded)
            assert pixels <= HELP_PIXELS, f'{path.name}: {pixels} pixels, a help row has {HELP_PIXELS}: {line}'
            offset = context * 2 * BLOCK + i * 32
            data[offset:offset + len(encoded)] = encoded
    return data


def image(language):
    """the language's PSRAM image (bytes, whole blocks)"""
    c = utils.constants()
    languages, strings = load()
    index = languages.index(language)
    tags, vwf = icons(), widths()
    texts = []
    for key, kind, values in strings:
        data = encode(values[index], tags)
        check(key, kind, language, data, encode(values[0], tags), vwf)
        texts.append(data)
    table = bytearray()
    offset = 2 * len(texts)
    for data in texts:
        table += offset.to_bytes(2, 'little')
        offset += len(data) + 1
    for data in texts:
        table += data + b'\0'
    out = bytearray(BLOCK)
    out[0:4] = b'FPKL'
    out[4] = c['LANG_VERSION']
    out[5:7] = key_hash(strings).to_bytes(2, 'little')
    out[7:9] = len(strings).to_bytes(2, 'little')
    assert c['LANG_HELP'] == 1 and c['LANG_TABLE'] == 5
    out += help_screens(language)
    out += table
    out += bytes(-len(out) % BLOCK)
    assert len(out) // BLOCK <= c['LANG_BLOCKS'], f'{language}: {len(out) // BLOCK} blocks, LANG_BLOCKS is {c["LANG_BLOCKS"]}'
    return bytes(out)


def header(languages, strings):
    lines = ['/* Generated from data/strings/strings.csv by scripts/strings.py. */',
             '#ifndef FATPAK_STRINGS_H', '#define FATPAK_STRINGS_H',
             '// PutStr(dest, id) and Str(id) (src/strings.asm), ModString in modules; S_PART(id, n) is the',
             '// text after its nth {}, up to the next',
             '#define S_PART(id, n) ((id) | ((n) << 12))',
             f'#define STR_COUNT {len(strings)}',
             f'#define STR_HASH 0x{key_hash(strings):04X}u',
             f'#define LANGUAGES {len(languages)}',
             f'#define LANG_CODES "{"".join(code.upper() for code in languages)}" // 2 characters each: /GBCSYS/LANG/<code>.DAT']
    for i, (key, _, values) in enumerate(strings):
        lines.append(f'#define S_{key} {i} // {values[0]}'.rstrip())
    lines.append('#endif')
    return '\n'.join(lines) + '\n'


def main():
    languages, strings = load()
    assert len(strings) < 4096
    path = ROOT / 'src/strings.h'
    text = header(languages, strings)
    if not path.exists() or path.read_text() != text:  # rewritten only when it changes: every C file includes it
        path.write_text(text)
    out = ROOT / 'bin/LANG'
    out.mkdir(parents=True, exist_ok=True)
    for language in languages:
        data = image(language)
        (out / f'{language.upper()}.DAT').write_bytes(data)
        print(f'strings.py: bin/LANG/{language.upper()}.DAT {len(data)} bytes, {len(strings)} strings')


if __name__ == '__main__':
    main()
