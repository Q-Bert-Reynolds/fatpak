#!/usr/bin/env bash
# FILE > BUILD / RUN with ASM.MOD in Gearboy. Requires the sibling Gearboy desktop core and RGBDS.
set -euo pipefail
# The X7 hypothesis that found the 2026-11-12 PSRAM corruption: a $BD03 write takes effect
# at the next $BD02 write, so block switches must write the high byte first (notes/EVERDRIVE.md)
export GEARBOY_EVERDRIVE_LATCH_BD03=1
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
for sample in features strings loops charmap sections values; do
    (cd "$fatpak_root/tests/asm" && rgbasm -Wno-obsolete -o "$work/$sample.o" $sample.asm)
    rgblink -o "$work/$sample.gb" "$work/$sample.o"
    rgbfix -v -p 0 "$work/$sample.gb"
done
mkdir -p "$work/lib/src"
cp "$fatpak_root/src/gbdk.asm" "$fatpak_root/src/hardware.inc" "$fatpak_root/src/memory1.asm" "$work/lib/src/"
(cd "$work/lib" && rgbasm -o "$work/gbdk.o" src/gbdk.asm)
rgblink -o "$work/gbdk.gb" "$work/gbdk.o"
rgbfix -v -p 0 "$work/gbdk.gb"
(cd "$fatpak_root/tests/asm/project" && rgbasm -D _DEMO -D LANG=3 -o "$work/project.o" lib/main.asm)
rgblink -o "$work/project.gb" "$work/project.o"
rgbfix -jvcs -k 01 -l 0x33 -m 0x1B -p 255 -t PROJECT "$work/project.gb"
cd "$fatpak_root"
python3 tests/test_asm.py
"$work/test" "$fatpak_root/bin/GBCOS.BIN" "$fatpak_root/bin/GBCOS.sym" \
    "$fatpak_root/bin/EDITOR.DAT" "$fatpak_root/tests/asm/hello.asm" "$work/hello.gb" \
    "$fatpak_root/tests/asm" "$work/features.gb" "$fatpak_root/src" "$work/gbdk.gb" "$work/project.gb"
