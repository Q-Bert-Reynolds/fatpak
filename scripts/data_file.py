"""Builds the OS mode data file (/GBCSYS/EDITOR.DAT): what doesn't fit in the 128KB image, loaded
into PSRAM at boot and read through the $BE00 window. Layout (DATA_* in src/constants.asm), in 512
byte blocks: 0 = "EDITOR.DAT" and DATA_VERSION, then the styled fonts (FontStyles order in
src/ui/render.asm), the SGB border's tiles and its map, then the base fixed font, help texts, base monospaced font, glyph shift tables and VWF bold widths.

usage: python3 scripts/data_file.py out_file
"""
import re
import utils
import sys

BLOCK = 512
FONTS = ["h1", "h2", "h3", "h4", "fixed_bold", "fixed_italic", "fixed_bold_italic",
         "vwf_bold", "vwf_italic", "vwf_bold_italic"]


def constants():
  return utils.constants()


def number(text):
  text = text.strip()
  if text.startswith("$"):
    return int(text[1:], 16)
  if text.startswith("%"):
    return int(text[1:], 2)
  return int(text)


def db_bytes(path, start=None, end=None):
  """the DB bytes of an rgbds file, from label start to label end"""
  out = bytearray()
  inside = start is None
  with open(path, encoding="utf8") as file:
    for line in file:
      code = line.split(";")[0].strip()
      if code.endswith(":"):
        label = code[:-1]
        if label == start:
          inside = True
        elif label == end:
          inside = False
        continue
      if inside and code.startswith("DB"):
        out += bytes(number(x) for x in code[2:].split(","))
  return out


def put(data, block, chunk, size):
  assert len(chunk) <= size, f"{len(chunk)} bytes don't fit in {size}"
  offset = block * BLOCK
  data[offset:offset + len(chunk)] = chunk


def main(out_path):
  c = constants()
  data = bytearray(c["DATA_BLOCKS"] * BLOCK)
  put(data, 0, b"EDITOR.DAT" + bytes([c["DATA_VERSION"]]), BLOCK)
  for i, font in enumerate(FONTS):
    put(data, c["DATA_FONTS"] + i * 4, db_bytes(f"img/fonts/font_{font}.asm"), 4 * BLOCK)
  border = "img/default_sgb_border.asm"
  put(data, c["DATA_BORDER_TILES"], db_bytes(border, "DefaultSgbBorderTiles", "DefaultSgbBorderTileMap"),
      (c["DATA_BORDER_MAP"] - c["DATA_BORDER_TILES"]) * BLOCK)
  put(data, c["DATA_BORDER_MAP"], db_bytes(border, "DefaultSgbBorderTileMap"),
      (c["DATA_FIXED"] - c["DATA_BORDER_MAP"]) * BLOCK)
  put(data, c["DATA_FIXED"], db_bytes("img/fonts/font_fixed.asm", "FontFixedGlyphs", "FontFixedWidths"), 4 * BLOCK)
  put(data, c["DATA_MONO"], db_bytes("img/fonts/font_mono.asm", "FontMonoGlyphs", "FontMonoWidths"), 4 * BLOCK)
  for shift in range(1, 8):
    table = bytes(b >> shift for b in range(256)) + bytes((b << (8 - shift)) & 255 for b in range(256))
    put(data, c["DATA_SHIFTS"] + shift - 1, table, BLOCK)
  put(data, c["DATA_WIDTHS"], db_bytes("img/fonts/styled_widths.asm", "VWFBoldWidths"), BLOCK)
  buttons = {token: chr(int(code)) for token, code in
             re.findall(r'charmap "(<BTN_[A-Z]+>)", (\d+)', open("src/charmap.asm", encoding="utf8").read())}
  for context, name in enumerate(("editor", "browser")):
    lines = open(f"data/help/{name}.txt", encoding="utf8").read().splitlines()
    assert len(lines) == 32, f"{name} help must have 32 lines"
    for i, line in enumerate(lines):
      for token, char in buttons.items():
        line = line.replace(token, char)
      encoded = line.encode("latin1")
      assert len(encoded) < 32, f"help line too long: {line}"
      offset = (c["DATA_HELP"] + context * 2) * BLOCK + i * 32
      data[offset:offset + len(encoded)] = encoded
  with open(out_path, "wb") as file:
    file.write(data)
  print(f"data_file.py: {out_path} {len(data)} bytes")


if __name__ == "__main__":
  main(sys.argv[1])
