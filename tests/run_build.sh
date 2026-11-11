#!/usr/bin/env bash
# FILE > BUILD / RUN with ASM.MOD in Gearboy. Requires the sibling Gearboy desktop core and RGBDS.
set -euo pipefail
fatpak_root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$fatpak_root/../Gearboy"}
work=$(mktemp -d /tmp/fatpak-build-test.XXXXXX)
trap 'rm -rf "$work"' EXIT
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" \
    "$fatpak_root/tests/test_build.cpp" \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" \
    -latomic -o "$work/test"
rgbasm -o "$work/hello.o" "$fatpak_root/tests/asm/hello.asm"
rgblink -o "$work/hello.gb" "$work/hello.o"
rgbfix -v -p 0 "$work/hello.gb"
cd "$fatpak_root"
python3 tests/test_asm.py
"$work/test" "$fatpak_root/bin/GBCOS.BIN" "$fatpak_root/bin/GBCOS.sym" \
    "$fatpak_root/bin/EDITOR.DAT" "$fatpak_root/tests/asm/hello.asm" "$work/hello.gb"
