"""EverDrive X OS mode build check: everything in ROMX banks 2-7 has to be a page (src/pages.asm),
code assembled for $4000 there can't run. Prints how full each page is.

usage: python3 check_pages.py build/main.map
"""
import re
import sys

PAGE_SIZE = 0x1D00


def main(map_path):
  bank = None
  bad = []
  used = {}
  for line in open(map_path, encoding="utf8"):
    match = re.match(r'(ROM0|ROMX|SRAM|WRAM\w*|HRAM|VRAM|OAM) bank #(\d+)', line)
    if match:
      bank = (match.group(1), int(match.group(2)))
      continue
    match = re.search(r'SECTION: \$[0-9a-f]{4}(?:-\$[0-9a-f]{4})? \(\$([0-9a-f]{4}) bytes?\) \["([^"]+)"\]', line)
    if not match or not bank:
      continue
    size, name = int(match.group(1), 16), match.group(2)
    if bank[0] == "ROMX" and bank[1] >= 2 and size and not re.fullmatch(r'Page \d+', name):
      bad.append(f"{name} (bank {bank[1]}, {size} bytes)")
    page = re.fullmatch(r'Page (\d+) RAM', name)
    if page:
      used[int(page.group(1))] = size
  print("pages: " + " ".join(f"{n}:{used.get(n, 0) * 100 // PAGE_SIZE}%" for n in range(4, 16)))
  if bad:
    print("check_pages.py: these aren't in a page and can't run in OS mode:\n  " + "\n  ".join(bad))
    sys.exit(1)


if __name__ == "__main__":
  main(sys.argv[1])
