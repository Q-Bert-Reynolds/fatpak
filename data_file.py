"""Builds the OS mode data file (/GBCSYS/EDITOR.DAT): what doesn't fit in the 128KB image, loaded
into PSRAM at boot and read through the $BE00 window. Layout (DATA_* in src/constants.asm), in 512
byte blocks: 0 = "EDITOR.DAT" and DATA_VERSION, then the styled fonts (FontStyles order in
src/editor/render.asm), the SGB border's tiles and its map.

usage: python3 data_file.py out_file
"""
import re
import sys

BLOCK = 512
FONTS = ["h1", "h2", "h3", "h4", "fixed_bold", "fixed_italic", "fixed_bold_italic",
         "vwf_bold", "vwf_italic", "vwf_bold_italic"]


def constants():
  values = {}
  with open("src/constants.asm", encoding="utf8") as file:
    for line in file:
      match = re.match(r"DEF (DATA_\w+)\s+EQU \$?(\w+)", line)
      if match:
        values[match.group(1)] = int(match.group(2), 16 if "$" in line.split(";")[0] else 10)
  return values


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
      (c["DATA_BLOCKS"] - c["DATA_BORDER_MAP"]) * BLOCK)
  with open(out_path, "wb") as file:
    file.write(data)
  print(f"data_file.py: {out_path} {len(data)} bytes")


if __name__ == "__main__":
  main(sys.argv[1])
