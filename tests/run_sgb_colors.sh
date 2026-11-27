#!/usr/bin/env bash
# SGB colours at 160x144 (tests/test_sgb_colors.cpp) on Gearboy's SGB. Requires the sibling Gearboy desktop core and
# make assemble.
set -euo pipefail
export GEARBOY_EVERDRIVE_LATCH_BD03=1
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$root/../Gearboy"}
cd "$root"
mkdir -p build/sgb
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" tests/test_sgb_colors.cpp \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" -latomic -o build/sgb/colors-test
build/sgb/colors-test bin/GBCOS.BIN bin/GBCOS.sym bin/EDITOR.DAT
