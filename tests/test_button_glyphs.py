"""The mono artwork is also available to proportional-font UI hints."""
import unittest
from pathlib import Path
from PIL import Image
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from data_file import db_bytes
from fonts import glyph_rows


class ButtonGlyphTest(unittest.TestCase):
    def test_ui_fonts_share_buttons_and_composed_directions(self):
        with Image.open(ROOT / 'img/ui_font.png') as image:
            expected = {code: glyph_rows(image, code) for code in range(1, 9)}
        for code, parts in {129: (5, 6), 130: (7, 8), 131: (5, 6, 7, 8)}.items():
            expected[code] = [0] * 8
            for part in parts:
                expected[code] = [a | b for a, b in zip(expected[code], expected[part])]
        for font, label in [('mono', 'Mono'), ('vwf', 'VWF')]:
            path = ROOT / f'img/fonts/font_{font}.asm'
            glyphs = db_bytes(path, f'Font{label}Glyphs', f'Font{label}Widths')
            widths = db_bytes(path, f'Font{label}Widths')
            for code, pixels in expected.items():
                with self.subTest(font=font, code=code):
                    self.assertEqual(list(glyphs[code * 8:code * 8 + 8]), pixels)
                    self.assertEqual(widths[code], 9 if font == 'vwf' else 8)


if __name__ == '__main__':
    unittest.main()
