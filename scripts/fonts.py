"""Converts 128x128 font PNGs (16x16 glyphs of 8x8, indexed by character code) for the editor's
row renderer: 8 bytes of 1bpp glyph rows per character and a width table.
Dark pixels (palette index 0 or 1) are drawn, everything else is background.
Button icons retain all four indexed shades as occupancy and shading masks.

img/ui_font.png            -> img/fonts/font_mono.asm, every glyph 8 pixels wide
img/fonts/fixed_font.png   -> img/fonts/font_fixed.asm, every glyph 4 pixels wide (left 4 pixels of the cell)
img/fonts/vwf_font.png     -> img/fonts/font_vwf.asm, glyphs moved to the left edge,
                              width = last pixel + 2 (1 pixel gap), empty glyphs (space) are 4

Styled fonts (bold, italic, markdown headings) are PNGs too, drawn as they are (not moved left).
Their widths go to img/fonts/styled_widths.asm: fixed fonts use constant IDs (widths 8..4),
a proportional font uses a 256-byte table with each
glyph's last pixel + 2 (4 if it's empty). Italic fonts use their upright font's widths.
`python3 scripts/fonts.py derive` draws any that are missing from the base fonts (--force redraws them all):
  headings 1-4: the fixed font stretched (columns 2,3,2,1 / 2,2,2,1 / 2,1,2,1 / 1,2,1,1 pixels wide),
                1 pixel taller (row 3 twice, row 0 dropped unless it's used)
  fixed bold: stretched 2,1,2,1, VWF bold: ORed 1 pixel right
  italic: the top 4 rows 1 pixel right (after bold)
"""
import os
import sys
from PIL import Image

FONTS = [ # png, asm, label, width (0 = proportional)
  ("img/ui_font.png", "img/fonts/font_mono.asm", "FontMono", 8),
  ("img/fonts/fixed_font.png", "img/fonts/font_fixed.asm", "FontFixed", 4),
  ("img/fonts/vwf_font.png", "img/fonts/font_vwf.asm", "FontVWF", 0),
]
EMPTY_WIDTH = 4

STYLED = [ # png, asm, label
  ("img/fonts/heading1_font.png", "img/fonts/font_h1.asm", "FontH1"),
  ("img/fonts/heading2_font.png", "img/fonts/font_h2.asm", "FontH2"),
  ("img/fonts/heading3_font.png", "img/fonts/font_h3.asm", "FontH3"),
  ("img/fonts/heading4_font.png", "img/fonts/font_h4.asm", "FontH4"),
  ("img/fonts/fixed_bold_font.png", "img/fonts/font_fixed_bold.asm", "FontFixedBold"),
  ("img/fonts/fixed_italic_font.png", "img/fonts/font_fixed_italic.asm", "FontFixedItalic"),
  ("img/fonts/fixed_bold_italic_font.png", "img/fonts/font_fixed_bold_italic.asm", "FontFixedBoldItalic"),
  ("img/fonts/vwf_bold_font.png", "img/fonts/font_vwf_bold.asm", "FontVWFBold"),
  ("img/fonts/vwf_italic_font.png", "img/fonts/font_vwf_italic.asm", "FontVWFItalic"),
  ("img/fonts/vwf_bold_italic_font.png", "img/fonts/font_vwf_bold_italic.asm", "FontVWFBoldItalic"),
]
STYLED_WIDTHS_ASM = "img/fonts/styled_widths.asm"
STYLED_WIDTHS = [ # label, png, fixed width (else proportional), in the order the engine's pages are
  ("HeadingWidths", "img/fonts/heading1_font.png", True),
  ("Heading2Widths", "img/fonts/heading2_font.png", True),
  ("Heading3Widths", "img/fonts/heading3_font.png", True),
  ("Heading4Widths", "img/fonts/heading4_font.png", True),
  ("FixedBoldWidths", "img/fonts/fixed_bold_font.png", True),
  ("VWFBoldWidths", "img/fonts/vwf_bold_font.png", False),
]
STRETCH = [ # pixels each of a fixed glyph's 4 columns becomes
  (2, 3, 2, 1), (2, 2, 2, 1), (2, 1, 2, 1), (1, 2, 1, 1),
]


def glyph_rows(img, code):
  cx, cy = (code % 16) * 8, (code // 16) * 8
  rows = []
  for y in range(8):
    bits = 0
    for x in range(8):
      if img.getpixel((cx + x, cy + y)) < 2:
        bits |= 0x80 >> x
    rows.append(bits)
  return rows


def button_pixels():
  """2bpp palette indices, in the same dark-to-light order as img2rgbds.py."""
  with Image.open("img/ui_font.png") as image:
    icons = {code: [[3 - image.getpixel(((code % 16) * 8 + x, (code // 16) * 8 + y)) % 4
                     for x in range(8)] for y in range(8)] for code in range(1, 9)}
  for code, parts in {129: (5, 6), 130: (7, 8), 131: (5, 6, 7, 8)}.items():
    icons[code] = [[0] * 8 for _ in range(8)]
    for part in parts:
      icons[code] = [[a | b for a, b in zip(row, source)]
                     for row, source in zip(icons[code], icons[part])]
  return icons


def icon_mask(pixels, include):
  return [sum(128 >> x for x, color in enumerate(row) if include(color)) for row in pixels]


def font_glyphs(png, fixed_width):
  """returns the glyphs (8 rows each) and widths of a base font, as the engine draws them"""
  img = Image.open(png)
  glyphs = []
  widths = []
  for code in range(256):
    rows = glyph_rows(img, code)
    used = 0
    for row in rows:
      used |= row
    if fixed_width:
      width = fixed_width
    elif not used:
      width = EMPTY_WIDTH
    else:
      left = 0
      while not used & (0x80 >> left):
        left += 1
      rows = [(row << left) & 0xFF for row in rows]
      used = (used << left) & 0xFF
      right = 7
      while not used & (0x80 >> right):
        right -= 1
      width = min(right + 2, 8)
    glyphs.append(rows)
    widths.append(width)
  # Icons preserve all four source shades. Ordinary characters remain 1bpp.
  if png in ("img/ui_font.png", "img/fonts/vwf_font.png"):
    icons = button_pixels()
    for index, (code, pixels) in enumerate(icons.items()):
      glyphs[code] = icon_mask(pixels, lambda color: color != 0)
      widths[code] = 8 if fixed_width else 9
      if not fixed_width:
        # Unused C1 control slots hold the two shading masks. Together with
        # the occupancy glyph these retain each original 2bpp color index.
        glyphs[132 + index] = icon_mask(pixels, lambda color: color == 2)
        glyphs[143 + index] = icon_mask(pixels, lambda color: color == 1)
  return glyphs, widths


def write_asm(png, asm, label, glyphs, widths=None):
  with open(asm, "w", encoding="utf8") as file:
    file.write(f"; generated by fonts.py from {png}\n")
    file.write(f"{label}Glyphs:\n")
    for code, rows in enumerate(glyphs):
      file.write("  DB " + ",".join(f"${row:02X}" for row in rows) + f" ;{code}\n")
    if widths:
      file.write(f"{label}Widths:\n")
      for i in range(0, 256, 16):
        file.write("  DB " + ",".join(str(w) for w in widths[i:i + 16]) + "\n")


def convert(png, asm, label, fixed_width):
  glyphs, widths = font_glyphs(png, fixed_width)
  write_asm(png, asm, label, glyphs, widths)


def stretch(row, columns):
  bits, x = 0, 0
  for col, width in enumerate(columns):
    if row & (0x80 >> col):
      bits |= ((0xFF << (8 - width)) & 0xFF) >> x
    x += width
  return bits


def heading(rows, level):
  if not rows[0]:
    rows = rows[1:4] + rows[3:8] # 1 pixel taller: row 3 twice
  return [stretch(row, STRETCH[level - 1]) for row in rows]


def bold(rows, fixed):
  return [stretch(row, STRETCH[2]) for row in rows] if fixed else [row | row >> 1 for row in rows]


def italic(rows):
  return [row >> 1 for row in rows[:4]] + rows[4:]


def derive(force):
  fixed, _ = font_glyphs(FONTS[1][0], FONTS[1][3])
  vwf, _ = font_glyphs(FONTS[2][0], FONTS[2][3])
  styles = [lambda g, n=n: heading(g, n) for n in range(1, 5)]
  for base, is_fixed in ((fixed, True), (vwf, False)):
    styles += [lambda g, b=base, f=is_fixed: bold(g, f), lambda g: italic(g), lambda g, f=is_fixed: italic(bold(g, f))]
  bases = [fixed] * 4 + [fixed] * 3 + [vwf] * 3
  palette = Image.open(FONTS[1][0]).getpalette()
  for (png, _, _), base, style in zip(STYLED, bases, styles):
    if os.path.isfile(png) and not force:
      print(f'Skipping "{png}", it exists (--force draws it again).')
      continue
    img = Image.new("P", (128, 128), 3)
    img.putpalette(palette)
    for code, rows in enumerate(base):
      for y, row in enumerate(style(rows)):
        for x in range(8):
          if row & (0x80 >> x):
            img.putpixel(((code % 16) * 8 + x, (code // 16) * 8 + y), 0)
    img.save(png)
    print(f'Drew "{png}".')


def convert_styled(png, asm, label):
  img = Image.open(png)
  write_asm(png, asm, label, [glyph_rows(img, code) for code in range(256)])


def styled_widths(png, fixed):
  img = Image.open(png)
  extents = []
  for code in range(256):
    used = 0
    for row in glyph_rows(img, code):
      used |= row
    extents.append(max(x for x in range(8) if used & (0x80 >> x)) + 2 if used else 0)
  if fixed:
    used = [e for e in extents if e]
    width = max(set(used), key=used.count)
    return [width] * 256
  return [e or EMPTY_WIDTH for e in extents]


def write_styled_widths():
  with open(STYLED_WIDTHS_ASM, "w", encoding="utf8") as file:
    file.write("; generated by fonts.py: virtual fixed-width IDs, then VWF widths\n")
    for index, (label, png, fixed) in enumerate(STYLED_WIDTHS):
      widths = styled_widths(png, fixed)
      if fixed:
        assert widths == [8 - index] * 256
        file.write(f"DEF {label} EQU ${index * 256:04X} ; fixed {widths[0]}\n")
        continue
      file.write(f"{label}: ;{png}{', fixed ' + str(widths[0]) if fixed else ''}\n")
      for i in range(0, 256, 16):
        file.write("  DB " + ",".join(str(w) for w in widths[i:i + 16]) + "\n")


def up_to_date(png, asm):
  if png == "img/fonts/vwf_font.png" and os.path.isfile(asm) and os.path.getmtime("img/ui_font.png") >= os.path.getmtime(asm):
    return False
  return os.path.isfile(asm) and os.path.getmtime(asm) > max(os.path.getmtime(png), os.path.getmtime(__file__))


def main():
  if "derive" in sys.argv:
    derive("--force" in sys.argv)
  for png, asm, label, fixed_width in FONTS:
    if up_to_date(png, asm):
      print(f'Skipping "{png}". Generated font is up to date.')
      continue
    convert(png, asm, label, fixed_width)
  for png, asm, label in STYLED:
    if up_to_date(png, asm):
      print(f'Skipping "{png}". Generated font is up to date.')
      continue
    convert_styled(png, asm, label)
  if all(up_to_date(png, STYLED_WIDTHS_ASM) for _, png, _ in STYLED_WIDTHS):
    print(f'Skipping "{STYLED_WIDTHS_ASM}". Generated widths are up to date.')
  else:
    write_styled_widths()


if __name__ == "__main__":
  main()
