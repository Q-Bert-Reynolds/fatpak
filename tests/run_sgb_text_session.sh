#!/usr/bin/env bash
# The recorded 512x448 text session (tests/run_sgb_text.sh: the GB frontend) replayed on the real SNES kernel in
# Mesen: every page accepted, and the browser in character mode (before a map, after it) as the pages say.
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
python3 tests/sgb/text_replay.py session-build
python3 - <<'PY'
from pathlib import Path
labels={n.lstrip('.'):int(a,16) for _,a,n in (s.split() for s in Path('build/sgb/kernel.lbl').read_text().splitlines())}
Path('build/sgb/kernel-symbols.lua').write_text('return {'+','.join(f'["{n}"]={a}' for n,a in labels.items())+'}')
PY
work=$(mktemp -d /tmp/fatpak-textsession.XXXXXX)
trap 'cp -f "$work"/config/MesenCE/text*.ppm "$root/build/sgb/" 2>/dev/null || true; cp -f "$work/config/MesenCE/result.txt" "$root/build/sgb/text-session-result.txt" 2>/dev/null || true; rm -rf "$work"' EXIT
mkdir -p "$work/config/MesenCE/Firmware"
cp "${SGB_BIOS:-$HOME/Downloads/program.rom}" "$work/config/MesenCE/Firmware/SGB1.sfc"
cp "${SGB_BOOT:-$HOME/Downloads/sgb1.boot.rom}" "$work/config/MesenCE/Firmware/sgb_boot.bin"
cp build/sgb/kernel.gb build/sgb/kernel-symbols.lua "$work/config/MesenCE/"
printf '{}\n' > "$work/config/MesenCE/settings.json"
cd "$work"
XDG_CONFIG_HOME="$work/config" dotnet "${MESEN_DLL:-$root/../MesenCE/bin/linux-x64/Release/Mesen.dll}" --testRunner --timeout=1500 \
 --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy --Gameboy.UseSgb2=false \
 --Snes.Port1.Type=SnesController "$root/tests/sgb/text.lua" "$work/config/MesenCE/kernel.gb" >mesen.log 2>&1 || { cat config/MesenCE/result.txt; tail -10 mesen.log; exit 1; }
cat config/MesenCE/result.txt
python3 "$root/tests/sgb/text_replay.py" session-check "$work/config/MesenCE"
