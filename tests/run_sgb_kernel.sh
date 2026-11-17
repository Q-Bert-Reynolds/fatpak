#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
python3 tests/sgb/kernel_build.py
"${CC:-cc}" -O2 -std=c99 -Wall -Wextra -Werror -Wno-main tests/sgb/kernel_native.c -o build/sgb/kernel-native
build/sgb/kernel-native build/sgb/replay-base.pages
python3 - <<'PY'
from pathlib import Path
labels={n.lstrip('.'):int(a,16) for _,a,n in (s.split() for s in Path('build/sgb/kernel.lbl').read_text().splitlines())}
labels['_test_pages']=Path('build/sgb/replay.pages').stat().st_size//1920
Path('build/sgb/kernel-symbols.lua').write_text('return {'+','.join(f'["{n}"]={a}' for n,a in labels.items())+'}')
PY
work=$(mktemp -d /tmp/fatpak-kernel.XXXXXX)
trap 'cp -f "$work"/config/MesenCE/kernel* "$root/build/sgb/" 2>/dev/null || true; cp -f "$work"/config/MesenCE/result.txt "$root/build/sgb/kernel-result.txt" 2>/dev/null || true; cp -f "$work/mesen.log" "$root/build/sgb/kernel-mesen.log" 2>/dev/null || true; rm -rf "$work"' EXIT
mkdir -p "$work/config/MesenCE/Firmware"
cp "${SGB_BIOS:-$HOME/Downloads/program.rom}" "$work/config/MesenCE/Firmware/SGB1.sfc"
cp "${SGB_BOOT:-$HOME/Downloads/sgb1.boot.rom}" "$work/config/MesenCE/Firmware/sgb_boot.bin"
cp build/sgb/kernel.bin build/sgb/kernel-symbols.lua build/sgb/kernel-golden.png "$work/config/MesenCE/"
printf '{}\n' > "$work/config/MesenCE/settings.json"
cd "$work"
XDG_CONFIG_HOME="$work/config" dotnet "${MESEN_DLL:-$root/../MesenCE/bin/linux-x64/Release/Mesen.dll}" --testRunner --timeout=900 \
 --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy --Gameboy.UseSgb2=false \
 --Snes.Port1.Type=SnesController "$root/tests/sgb/kernel.lua" "$root/build/sgb/kernel.gb" >mesen.log 2>&1 || { cat config/MesenCE/result.txt; tail -10 mesen.log; exit 1; }
cat config/MesenCE/result.txt

python3 - "$root" <<'PY'
from pathlib import Path
from PIL import Image,ImageChops
import sys
root=Path(sys.argv[1]);actual=Image.open('config/MesenCE/kernel.ppm');golden=Image.open('config/MesenCE/kernel-golden.png')
assert actual.size==golden.size
assert ImageChops.difference(actual,golden).getbbox() is None, 'SNES PPU differs from the recorded frontend golden'
print('PASS: all 57,344 SNES pixels match the frontend golden')
closed=Path('config/MesenCE/kernel-closed.ppm')
if closed.exists():
    assert ImageChops.difference(Image.open(closed),Image.open(root/'tests/sgb/fixtures/client.png')).getbbox() is None, 'closing the menu did not restore the original image'
    print('PASS: closing the menu restores every original PPU pixel')
PY
