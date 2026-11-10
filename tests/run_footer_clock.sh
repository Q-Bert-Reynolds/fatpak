#!/usr/bin/env bash
# Requires the sibling Gearboy desktop core to have been built already.
set -euo pipefail
fatpak_root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$fatpak_root/../Gearboy"}
test_binary=$(mktemp /tmp/fatpak-footer-test.XXXXXX)
trap 'rm -f "$test_binary"' EXIT
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" \
    "$fatpak_root/tests/test_footer_clock.cpp" \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" \
    -latomic -o "$test_binary"
"$test_binary" "$fatpak_root/bin/GBCOS.BIN" "$fatpak_root/bin/GBCOS.sym" \
    "$fatpak_root/bin/EDITOR.DAT"
