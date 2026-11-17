`client.pages.gz` is the 102 accepted LCD page transactions extracted from the
Phase 5 real-OS test (`test_sgb_client.cpp`, its `client.fph` recording). It covers
bootstrap, browser, opening C text, editing, saving, a 30-key scrolling burst and
selection. Gzip uses a zero timestamp. `client.png` is the final reference raster
from that same run. Neither fixture contains an emulator implementation.

`kernel_build.py:recording()` can extract the original recording. The committed
compact fixture lets the real-SNES test run without the optional Gearboy host
branch or its 117 MB recording. `run_sgb_kernel.sh` uploads the production kernel
using the real BIOS in Mesen, replays those transactions over LCD capture, and
compares the actual SNES PPU output pixel for pixel. It never injects SNES code,
register state, protocol replies or pixels through Lua.
