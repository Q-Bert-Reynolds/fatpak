#!/usr/bin/env bash
set -euo pipefail
export GEARBOY_EVERDRIVE_LATCH_BD03=1
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$root/../Gearboy"}
cd "$root"
mkdir -p build/overlays
python3 - <<'PY'
from pathlib import Path
import sys
sys.path.insert(0,'scripts')
import overlays
rom=Path('bin/GBCOS.BIN').read_bytes(); s=overlays.symbols('bin/GBCOS.sym')
# Unaligned, multi-sector payload with a partial final sector.
payload=bytes([0x3E,42,0xC9])+bytes((i*73)&255 for i in range(612))
image=overlays.pack(payload,rom[0x14E:0x150],s['_RenderOverlayStart'],s['_RenderOverlayStart'],s['_RenderOverlayStart'],s['_RenderOverlayEnd'])
assert overlays.unpack(image,rom[0x14E:0x150],s['_RenderOverlayStart'],s['_RenderOverlayEnd'])[2]==payload
Path('build/overlays/test.ovl').write_bytes(image)
payload=bytes([0x3E,42,0xC9])+bytes((i*29)&255 for i in range(s['_RenderOverlayEnd']-s['_RenderOverlayStart']-3))
Path('build/overlays/test.ovl.full').write_bytes(overlays.pack(payload,rom[0x14E:0x150],s['_RenderOverlayStart'],s['_RenderOverlayStart'],s['_RenderOverlayStart'],s['_RenderOverlayEnd']))
PY
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" tests/test_overlays.cpp \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" \
    -latomic -o build/overlays/test
build/overlays/test bin/GBCOS.BIN bin/GBCOS.sym bin/EDITOR.DAT build/overlays/test.ovl
