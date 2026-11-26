#!/usr/bin/env bash
# Retake README images from the built OS (make assemble first): 160x144 and 256x224 doubled, 512x448 as is.
# Gearboy runs the frontend; SGB recordings are rendered by the real kernel in Mesen.
set -euo pipefail
export GEARBOY_EVERDRIVE_LATCH_BD03=1
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$root/../Gearboy"}
work=$(mktemp -d /tmp/fatpak-screenshots.XXXXXX)
trap 'shots_status=$?; if (( shots_status )); then echo "Capture files kept at $work" >&2; else rm -rf "$work"; fi' EXIT
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" \
    "$root/scripts/screenshots.cpp" \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" \
    -latomic -o "$work/screenshots"
"$work/screenshots" "$root/bin/GBCOS.BIN" "$root/bin/GBCOS.sym" "$root/bin/EDITOR.DAT" \
    "$root/bin/MODULES" "$root" "$work"
python3 "$root/scripts/screenshots_sgb.py" "$work"
mkdir -p "$root/screenshots"
python3 - "$work" "$root/screenshots" <<'PY'
import sys, pathlib
from PIL import Image
for ppm in sorted(pathlib.Path(sys.argv[1]).glob('*.ppm')):
    image = Image.open(ppm)
    scale = 1 if image.width >= 512 else 2  # 512x448 as it is; the rest doubled
    image.resize((image.width * scale, image.height * scale), Image.NEAREST).save(pathlib.Path(sys.argv[2]) / (ppm.stem + '.png'))
    print(ppm.stem + '.png')
PY
