#!/usr/bin/env bash
set -euo pipefail
fatpak_root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$fatpak_root/../Gearboy"}
cd "$fatpak_root"
python3 tests/sgb/build.py bench
python3 tests/sgb/host_assets.py --check --gearboy "$gearboy_root"
# Build independent core objects with Gearboy's test flags.
make -C "$gearboy_root/tests" -j"${JOBS:-4}" serial fatpak
python3 tests/sgb/host_image.py
python3 tests/sgb/host_vectors.py
"$gearboy_root/tests/gearboy-fatpak-tests" build/sgb/host-vectors.bin
mkdir -p build/sgb
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -DGEARBOY_DISABLE_DISASSEMBLER=1 -DGEARBOY_DISABLE_VGMRECORDER=1 -I"$gearboy_root/src" \
    tests/test_sgb_host.cpp "$gearboy_root"/tests/.objects/src/*.o "$gearboy_root"/tests/.objects/src/audio/*.o \
    "$gearboy_root/tests/.objects/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/tests/.objects/platforms/shared/desktop/trace_logger_formatter.o" \
    -latomic -o build/sgb/host-test
build/sgb/host-test build/sgb/bench.gb build/sgb/bench.bin build/sgb/bench.fph build/sgb/bench.SGB.DAT
