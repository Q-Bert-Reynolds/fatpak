#!/usr/bin/env bash
# The SGB fullscreen map view on the real SNES kernel: tests/run_sgb_map.sh's recorded pages replayed in Mesen
# through the SGB BIOS (tests/sgb/map_replay.py, tests/sgb/map.lua). Run tests/run_sgb_map.sh first.
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
python3 tests/sgb/map_replay.py build
python3 - <<'PY'
from pathlib import Path
labels={n.lstrip('.'):int(a,16) for _,a,n in (s.split() for s in Path('build/sgb/kernel.lbl').read_text().splitlines())}
Path('build/sgb/kernel-symbols.lua').write_text('return {'+','.join(f'["{n}"]={a}' for n,a in labels.items())+'}')
PY
work=$(mktemp -d /tmp/fatpak-mapkernel.XXXXXX)
trap 'cp -f "$work"/config/MesenCE/map*.ppm "$root/build/sgb/" 2>/dev/null || true; cp -f "$work/config/MesenCE/result.txt" "$root/build/sgb/map-kernel-result.txt" 2>/dev/null || true; rm -rf "$work"' EXIT
mkdir -p "$work/config/MesenCE/Firmware"
cp "${SGB_BIOS:-$HOME/Desktop/sgb/sgb1v2.sfc}" "$work/config/MesenCE/Firmware/SGB1.sfc"
cp "${SGB_BOOT:-$HOME/Downloads/sgb_boot.bin}" "$work/config/MesenCE/Firmware/sgb_boot.bin"
cp build/sgb/kernel.gb build/sgb/kernel-symbols.lua "$work/config/MesenCE/"
printf '{}\n' > "$work/config/MesenCE/settings.json"
cd "$work"
XDG_CONFIG_HOME="$work/config" dotnet "${MESEN_DLL:-$root/../MesenCE/bin/linux-x64/Release/Mesen.dll}" --testRunner --timeout=1500 \
 --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy --Gameboy.UseSgb2=false \
 --Snes.Port1.Type=SnesController "$root/tests/sgb/map.lua" "$work/config/MesenCE/kernel.gb" >mesen.log 2>&1 || { cat config/MesenCE/result.txt; tail -10 mesen.log; exit 1; }
cat config/MesenCE/result.txt
python3 "$root/tests/sgb/map_replay.py" check "$work/config/MesenCE"
