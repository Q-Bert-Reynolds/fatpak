#!/usr/bin/env bash
# EXIT on the real SNES kernel through the real SGB BIOS in Mesen (tests/sgb/bios_return.lua): the synthetic
# 512x448 session (tests/sgb/text_replay.py exit-build), then EXIT. The BIOS's video, WRAM and ARAM must be as
# they were at JUMP, the BIOS back in its command loop with its border, the ICD2 at one player and its menu opening.
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
# Without SGB_BIOS: each BIOS EXIT knows, from SGB_DUMPS (named as ISSOtm's SGB disassembly expects):
# SGB1 1.2 required; 1.0, 1.1 and SGB2 if their dumps are there
if [[ -z ${SGB_BIOS:-} ]]; then
 dumps=${SGB_DUMPS:-$HOME/Desktop/sgb}
 SGB_BIOS="$dumps/sgb1v2.sfc" SGB2=0 bash "$0"
 for spec in "0:$dumps/sgb1v0.sfc" "0:$dumps/sgb1v1.sfc" "1:$dumps/sgb2.sfc"; do
  if [[ -f ${spec#*:} ]]; then SGB_BIOS="${spec#*:}" SGB2="${spec%%:*}" bash "$0"; else echo "skipped (no dump): ${spec#*:}"; fi
 done
 exit 0
fi
echo "BIOS: $(basename "$SGB_BIOS")"
python3 tests/sgb/text_replay.py exit-build
python3 - <<'PY'
from pathlib import Path
labels={n.lstrip('.'):int(a,16) for _,a,n in (s.split() for s in Path('build/sgb/kernel.lbl').read_text().splitlines())}
Path('build/sgb/kernel-symbols.lua').write_text('return {'+','.join(f'["{n}"]={a}' for n,a in labels.items())+'}')
PY
work=$(mktemp -d /tmp/fatpak-biosreturn.XXXXXX)
trap 'cp -f "$work"/config/MesenCE/bios-*.png "$work"/config/MesenCE/bios-*.txt "$root/build/sgb/" 2>/dev/null || true; cp -f "$work/config/MesenCE/result.txt" "$root/build/sgb/bios-return-result.txt" 2>/dev/null || true; rm -rf "$work"' EXIT
mkdir -p "$work/config/MesenCE/Firmware"
# SGB_BIOS: the BIOS ROM; SGB2=1 runs it as an SGB2 (Mesen's SGB2.sfc, its GB clock)
sgb2=${SGB2:-0}
bios_name=SGB1.sfc; boot_name=sgb_boot.bin
[[ $sgb2 == 1 ]] && { bios_name=SGB2.sfc; boot_name=sgb2_boot.bin; }
cp "${SGB_BIOS:-$HOME/Desktop/sgb/sgb1v2.sfc}" "$work/config/MesenCE/Firmware/$bios_name"
cp "${SGB_BOOT:-$HOME/Downloads/sgb_boot.bin}" "$work/config/MesenCE/Firmware/$boot_name"
cp build/sgb/kernel.gb build/sgb/kernel-symbols.lua "$work/config/MesenCE/"
printf '{}\n' > "$work/config/MesenCE/settings.json"
cd "$work"
XDG_CONFIG_HOME="$work/config" dotnet "${MESEN_DLL:-$root/../MesenCE/bin/linux-x64/Release/Mesen.dll}" --testRunner --timeout=600 \
 --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy --Gameboy.UseSgb2=$([[ $sgb2 == 1 ]] && echo true || echo false) \
 --Snes.Port1.Type=SnesController "$root/tests/sgb/bios_return.lua" "$work/config/MesenCE/kernel.gb" >mesen.log 2>&1 || { cat config/MesenCE/result.txt; grep -v 'SGB Command' mesen.log | tail -10; exit 1; }
cat config/MesenCE/result.txt
