#!/usr/bin/env bash
set -euo pipefail
export GEARBOY_EVERDRIVE_LATCH_BD03=1
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
gearboy_root=${GEARBOY_ROOT:-"$root/../Gearboy"}
cd "$root"
python3 tests/sgb/build.py hello
# This is a host-test fixture, not the real SNES terminal firmware.
python3 scripts/sgb_data.py --snes build/sgb/hello.bin --output build/sgb/client-test.SGB.DAT
"${CXX:-c++}" -O2 -std=c++11 -fno-rtti -I"$gearboy_root/src" tests/test_sgb_client.cpp \
    "$gearboy_root"/src/*.o "$gearboy_root"/src/audio/*.o \
    "$gearboy_root/platforms/shared/dependencies/miniz/miniz.o" \
    "$gearboy_root/platforms/shared/desktop/trace_logger_formatter.o" -latomic -o build/sgb/client-test
build/sgb/client-test bin/GBCOS.BIN bin/GBCOS.sym bin/EDITOR.DAT "${SGB_CLIENT_DATA:-build/sgb/client-test.SGB.DAT}" bin/MODULES/SGBBOOT.MOD

python3 tests/sgb/check_ui_stream.py build/sgb/client.fph
