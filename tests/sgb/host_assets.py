#!/usr/bin/env python3
"""Export/check the exact FatPak protocol and font bytes used by Gearboy."""
from pathlib import Path
import argparse
import os
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'scripts'))
import data_file
import fonts as font_source


def font_include():
    names = ['mono', 'vwf', 'fixed', 'h1', 'h2', 'h3', 'h4', 'fixed_bold',
             'fixed_italic', 'fixed_bold_italic', 'vwf_bold', 'vwf_italic',
             'vwf_bold_italic']
    result = '// Generated from FatPak img/fonts/*.asm. See tests/sgb/host_assets.py.\n'
    result += 'static const unsigned char kFatPakGlyphs[13][2048] = {\n'
    for name in names:
        glyphs = data_file.db_bytes(f'img/fonts/font_{name}.asm')[:2048]
        assert len(glyphs) == 2048
        result += '{' + ','.join(map(str, glyphs)) + '},\n'
    result += '};\nstatic const unsigned char kFatPakWidths[7][256] = {\n'
    for index in range(7):
        if index == 1:
            widths = data_file.db_bytes('img/fonts/font_vwf.asm')[2048:2304]
        else:
            width = 8 if index == 0 else 4 if index == 2 else 11-index
            widths = bytes([width] * 256)
        assert len(widths) == 256
        result += '{' + ','.join(map(str, widths)) + '},\n'
    result += '};\nstatic const unsigned char kFatPakIcons[11][64] = {\n'
    for pixels in font_source.button_pixels().values():
        result += '{' + ','.join(str(v) for row in pixels for v in row) + '},\n'
    return (result + '};\n').encode()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gearboy', type=Path, default=ROOT.parent / 'Gearboy')
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    args.gearboy = args.gearboy.resolve()
    os.chdir(ROOT)
    outputs = {
        args.gearboy / 'src/FatPakSGBProtocol.h': (ROOT / 'tests/sgb/protocol.hpp').read_bytes(),
        args.gearboy / 'src/FatPakSGBFonts.inl': font_include(),
    }
    for path, data in outputs.items():
        if args.check:
            if not path.exists() or path.read_bytes() != data:
                raise SystemExit(f'stale Gearboy host asset: {path}')
        elif not path.exists() or path.read_bytes() != data:
            path.write_bytes(data)


if __name__ == '__main__':
    main()
