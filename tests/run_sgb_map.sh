#!/usr/bin/env bash
# SGB fullscreen map view (tests/test_sgb_map.cpp) on the real GB frontend and Gearboy's SNES protocol model.
# Requires the sibling Gearboy desktop core to have been built already, and make assemble.
set -euo pipefail
export GEARBOY_EVERDRIVE_LATCH_BD03=1
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$root/../Gearboy"}
cd "$root"
python3 tests/sgb/build.py hello
# The SNES side is Gearboy's model; the SGB.DAT carries the real GB overlay.
# The real kernel's extension, so the recording replays on the real kernel (run_sgb_map_kernel.sh)
python3 scripts/sgb_kernel.py
python3 scripts/sgb_data.py --snes build/sgb/hello.bin --ext build/sgb/ext.bin --output build/sgb/client-test.SGB.DAT
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" tests/test_sgb_map.cpp \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" -latomic -o build/sgb/map-test
build/sgb/map-test bin/GBCOS.BIN bin/GBCOS.sym bin/EDITOR.DAT build/sgb/client-test.SGB.DAT
