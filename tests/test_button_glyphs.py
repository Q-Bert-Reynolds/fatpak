"""The mono artwork is also available to proportional-font UI hints."""
import unittest
from pathlib import Path
from PIL import Image
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from data_file import db_bytes


class ButtonGlyphTest(unittest.TestCase):
    def test_ui_fonts_share_buttons_and_composed_directions(self):
        with Image.open(ROOT / 'img/ui_font.png') as image:
            expected = {code: [[3 - image.getpixel((code * 8 + x, y)) % 4
                                for x in range(8)] for y in range(8)] for code in range(1, 9)}
        self.assertEqual({p for glyph in expected.values() for row in glyph for p in row}, {0, 1, 2, 3})
        for code, parts in {129: (5, 6), 130: (7, 8), 131: (5, 6, 7, 8)}.items():
            expected[code] = [[0] * 8 for _ in range(8)]
            for part in parts:
                expected[code] = [[a | b for a, b in zip(row, source)]
                                  for row, source in zip(expected[code], expected[part])]
        for font, label in [('mono', 'Mono'), ('vwf', 'VWF')]:
            path = ROOT / f'img/fonts/font_{font}.asm'
            glyphs = db_bytes(path, f'Font{label}Glyphs', f'Font{label}Widths')
            widths = db_bytes(path, f'Font{label}Widths')
            for index, (code, pixels) in enumerate(expected.items()):
                with self.subTest(font=font, code=code):
                    occupied = [sum(128 >> x for x, p in enumerate(row) if p) for row in pixels]
                    self.assertEqual(list(glyphs[code * 8:code * 8 + 8]), occupied)
                    self.assertEqual(widths[code], 9 if font == 'vwf' else 8)
                    if font == 'vwf':
                        for y in range(8):
                            dim = glyphs[(132 + index) * 8 + y]
                            accent = glyphs[(143 + index) * 8 + y]
                            for x in range(8):
                                bit = 128 >> x
                                value = (int(bool(occupied[y] & bit) and not (dim & bit)) |
                                         int(bool(occupied[y] & bit) and not (accent & bit)) << 1)
                                self.assertEqual(value, pixels[y][x])



if __name__ == '__main__':
    unittest.main()
