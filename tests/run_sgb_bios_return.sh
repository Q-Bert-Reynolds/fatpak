#!/usr/bin/env bash
# EXIT on the real SNES kernel through the real SGB BIOS in Mesen (tests/sgb/bios_return.lua): the synthetic
# 512x448 session (tests/sgb/text_replay.py exit-build), then EXIT. The BIOS's video, WRAM and ARAM must be as
# they were at JUMP, the BIOS back in its command loop with its border, the ICD2 at one player and its menu opening.
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
python3 tests/sgb/text_replay.py exit-build
python3 - <<'PY'
from pathlib import Path
labels={n.lstrip('.'):int(a,16) for _,a,n in (s.split() for s in Path('build/sgb/kernel.lbl').read_text().splitlines())}
Path('build/sgb/kernel-symbols.lua').write_text('return {'+','.join(f'["{n}"]={a}' for n,a in labels.items())+'}')
PY
work=$(mktemp -d /tmp/fatpak-biosreturn.XXXXXX)
trap 'cp -f "$work"/config/MesenCE/bios-*.png "$work"/config/MesenCE/bios-*.txt "$root/build/sgb/" 2>/dev/null || true; cp -f "$work/config/MesenCE/result.txt" "$root/build/sgb/bios-return-result.txt" 2>/dev/null || true; rm -rf "$work"' EXIT
mkdir -p "$work/config/MesenCE/Firmware"
cp "${SGB_BIOS:-$HOME/Downloads/SGB1.sfc}" "$work/config/MesenCE/Firmware/SGB1.sfc"
cp "${SGB_BOOT:-$HOME/Downloads/sgb_boot.bin}" "$work/config/MesenCE/Firmware/sgb_boot.bin"
cp build/sgb/kernel.gb build/sgb/kernel-symbols.lua "$work/config/MesenCE/"
printf '{}\n' > "$work/config/MesenCE/settings.json"
cd "$work"
XDG_CONFIG_HOME="$work/config" dotnet "${MESEN_DLL:-$root/../MesenCE/bin/linux-x64/Release/Mesen.dll}" --testRunner --timeout=600 \
 --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy --Gameboy.UseSgb2=false \
 --Snes.Port1.Type=SnesController "$root/tests/sgb/bios_return.lua" "$work/config/MesenCE/kernel.gb" >mesen.log 2>&1 || { cat config/MesenCE/result.txt; grep -v 'SGB Command' mesen.log | tail -10; exit 1; }
cat config/MesenCE/result.txt
