# Fonts

[Architecture](ARCHITECTURE.md#fonts-and-icons) · [TODO](TODO.md)

The editor draws text as pixels, so fonts can be any width (src/ui/render.asm). `scripts/fonts.py` converts:
- img/ui_font.png, the 8 pixel fixed width font (the on screen keyboard)
- img/fonts/fixed_font.png, the 4 pixel fixed width font for text (40 characters per row), the
  left 4 pixels of each cell
- img/fonts/tiny5mono_font.png, a 6 pixel fixed width font (26 characters per row), not built yet
  (see font selection in [TODO.md](TODO.md))
- img/fonts/vwf_font.png, the variable width font. Glyphs are moved to the left edge of their cell
  and each character's width is its last pixel + 2. Empty glyphs (space) are 4 pixels.

All are 16x16 grids of 8x8 glyphs indexed by character code, dark pixels are drawn.
Styled text uses its own fonts, drawn as they are (not moved left). Their widths are measured from
the images: a fixed width font (headings, fixed bold) is its most common last pixel + 2 wide (a few
glyphs can draw into the gap), VWF bold is each glyph's last pixel + 2 (4 if it's empty), italic
fonts use their upright font's widths:
- img/fonts/heading1_font.png to heading4_font.png, markdown headings 1-4
- img/fonts/fixed_bold_font.png, fixed_italic_font.png, fixed_bold_italic_font.png
- img/fonts/vwf_bold_font.png, vwf_italic_font.png, vwf_bold_italic_font.png

`python3 scripts/fonts.py derive` draws any that are missing from the base fonts (headings stretched with 2
pixel strokes and 1 pixel taller, bold ORed 1 pixel right or stretched in the fixed font, italic's
top 4 rows 1 pixel right), `--force` draws them all again (overwriting edits).

img/ui_font.png is 256 tiles. Tile index matches the character code:
- 0-31: UI glyphs (box drawing, arrows, etc.)
- 32-126: ASCII
- 160-255: Latin-1 (ISO-8859-1), only the accented characters used by translations so far
- "\n" in engine strings is 128
