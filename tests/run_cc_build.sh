#!/usr/bin/env bash
# FILE > BUILD on .c files with CCA/CCB/CCC.MOD in Gearboy (tests/test_cc_build.cpp). Requires the
# sibling Gearboy desktop core and a built OS (make assemble SD_MOUNT=/nonexistent).
# usage: tests/run_cc_build.sh [fixture...]  (tests/cc/<fixture>.c; all of them by default;
# CC_MODELS=cgb or dmg for one model)
set -euo pipefail
export GEARBOY_EVERDRIVE_LATCH_BD03=1 # as tests/run_build.sh: high block byte first
fatpak_root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$fatpak_root/../Gearboy"}
work=$(mktemp -d /tmp/fatpak-cc-build.XXXXXX)
trap 'rm -rf "$work"' EXIT
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" \
    "$fatpak_root/tests/test_cc_build.cpp" \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" \
    -latomic -o "$work/test"
# the PC's assembly of each fixture, for the device's to match (tests/test_cc.py builds cc_host)
[ -x "$fatpak_root/build/cc_host" ] || python3 "$fatpak_root/tests/test_cc.py" arith > /dev/null
mkdir -p "$work/host"
for source in "$fatpak_root"/tests/cc/*.c; do
    "$fatpak_root/build/cc_host" -I "$fatpak_root/modules/cc/include" "$source" -o "$work/host/$(basename "$source" .c).asm"
done
"$work/test" "$fatpak_root/bin/GBCOS.BIN" "$fatpak_root/bin/GBCOS.sym" "$fatpak_root/bin/EDITOR.DAT" "$fatpak_root/tests/cc" "$work/host" "$@"
