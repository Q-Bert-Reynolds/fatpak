#!/usr/bin/env bash
# Writes the README's screenshots (screenshots/*_dmg.png, *_gbc.png, *_dark.png, 2x) from the built OS
# (make assemble first), using the sibling Gearboy core like the tests do.
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$root/../Gearboy"}
work=$(mktemp -d /tmp/fatpak-screenshots.XXXXXX)
trap 'rm -rf "$work"' EXIT
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" \
    "$root/scripts/screenshots.cpp" \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" \
    -latomic -o "$work/screenshots"
"$work/screenshots" "$root/bin/GBCOS.BIN" "$root/bin/GBCOS.sym" "$root/bin/EDITOR.DAT" \
    "$root/bin/MODULES" "$root" "$work"
mkdir -p "$root/screenshots"
python3 - "$work" "$root/screenshots" <<'PY'
import sys, pathlib
from PIL import Image
for ppm in sorted(pathlib.Path(sys.argv[1]).glob('*.ppm')):
    image = Image.open(ppm)
    image.resize((image.width * 2, image.height * 2), Image.NEAREST).save(pathlib.Path(sys.argv[2]) / (ppm.stem + '.png'))
    print(ppm.stem + '.png')
PY
