#!/usr/bin/env bash
# Requires the sibling Gearboy desktop core to have been built already.
set -euo pipefail
# The X7 hypothesis that found the 2026-11-12 PSRAM corruption: a $BD03 write takes effect
# at the next $BD02 write, so block switches must write the high byte first (notes/EVERDRIVE.md)
export GEARBOY_EVERDRIVE_LATCH_BD03=1
fatpak_root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$fatpak_root/../Gearboy"}
test_binary=$(mktemp /tmp/fatpak-session-test.XXXXXX)
trap 'rm -f "$test_binary"' EXIT
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" \
    "$fatpak_root/tests/test_session.cpp" \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" \
    -latomic -o "$test_binary"
"$test_binary" "$fatpak_root/bin/GBCOS.BIN" "$fatpak_root/bin/GBCOS.sym" \
    "$fatpak_root/bin/EDITOR.DAT"
