#!/usr/bin/env bash
# The SNES mouse in fullscreen on the real kernel and SGB BIOS in Mesen (tests/sgb/mouse.lua): after the synthetic
# session (tests/sgb/text_replay.py build), port 2's mouse moves, clicks and drags; the mailbox events and the pointer.
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
python3 tests/sgb/text_replay.py build
python3 - <<'PY'
from pathlib import Path
labels={n.lstrip('.'):int(a,16) for _,a,n in (s.split() for s in Path('build/sgb/kernel.lbl').read_text().splitlines())}
Path('build/sgb/kernel-symbols.lua').write_text('return {'+','.join(f'["{n}"]={a}' for n,a in labels.items())+'}')
PY
work=$(mktemp -d /tmp/fatpak-mouse.XXXXXX)
trap 'cp -f "$work"/config/MesenCE/mouse.png "$work"/config/MesenCE/mouse.txt "$root/build/sgb/" 2>/dev/null || true; cp -f "$work/config/MesenCE/result.txt" "$root/build/sgb/mouse-result.txt" 2>/dev/null || true; rm -rf "$work"' EXIT
mkdir -p "$work/config/MesenCE/Firmware"
cp "${SGB_BIOS:-$HOME/Desktop/sgb/sgb1v2.sfc}" "$work/config/MesenCE/Firmware/SGB1.sfc"
cp "${SGB_BOOT:-$HOME/Downloads/sgb_boot.bin}" "$work/config/MesenCE/Firmware/sgb_boot.bin"
cp build/sgb/kernel.gb build/sgb/kernel-symbols.lua "$work/config/MesenCE/"
printf '{}\n' > "$work/config/MesenCE/settings.json"
cd "$work"
XDG_CONFIG_HOME="$work/config" dotnet "${MESEN_DLL:-$root/../MesenCE/bin/linux-x64/Release/Mesen.dll}" --testRunner --timeout=600 \
 --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy --Gameboy.UseSgb2=false \
 --Snes.Port1.Type=SnesController --Snes.Port2.Type=SnesMouse ${MESEN_EXTRA:-} "$root/tests/sgb/mouse.lua" "$work/config/MesenCE/kernel.gb" >mesen.log 2>&1 || { cat config/MesenCE/result.txt; grep -v 'SGB Command' mesen.log | tail -10; exit 1; }
cat config/MesenCE/result.txt
