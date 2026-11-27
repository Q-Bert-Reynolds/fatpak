#!/usr/bin/env bash
# The SGB BIOS's pace for SGB attributes (tests/sgb/attr.asm) on every BIOS dump in SGB_DUMPS (~/Desktop/sgb, as
# tests/run_sgb_bios_return.sh names them), in Mesen. Requires RGBDS, .NET and the sibling MesenCE build.
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
mesen=${MESEN_DLL:-"$root/../MesenCE/bin/linux-x64/Release/Mesen.dll"}
dumps=${SGB_DUMPS:-"$HOME/Desktop/sgb"}
boot=${SGB_BOOT:-"$HOME/Downloads/sgb_boot.bin"}
cd "$root"
mkdir -p build/sgb
rgbasm -o build/sgb/attr.o tests/sgb/attr.asm
rgblink -o build/sgb/attr.gb build/sgb/attr.o
rgbfix -v -s -l 0x33 -t SGBATTR -m 0 -p 255 build/sgb/attr.gb
status=0
for dump in sgb1v0 sgb1v1 sgb1v2 sgb2; do
    [[ -f "$dumps/$dump.sfc" ]] || { [[ $dump == sgb1v2 ]] && { echo "missing $dumps/$dump.sfc"; exit 1; }; continue; }
    work=$(mktemp -d /tmp/fatpak-sgb-attr.XXXXXX)
    mkdir -p "$work/config/MesenCE/Firmware"
    sgb2=false; [[ $dump == sgb2 ]] && sgb2=true
    cp -- "$dumps/$dump.sfc" "$work/config/MesenCE/Firmware/$([[ $sgb2 == true ]] && echo SGB2 || echo SGB1).sfc"
    cp -- "$boot" "$work/config/MesenCE/Firmware/sgb_boot.bin"
    cp -- "$boot" "$work/config/MesenCE/Firmware/sgb2_boot.bin"
    printf '{}\n' > "$work/config/MesenCE/settings.json"
    (cd "$work" && XDG_CONFIG_HOME="$work/config" dotnet "$mesen" --testRunner --timeout=60 \
        --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy --Gameboy.UseSgb2=$sgb2 \
        --Snes.Port1.Type=SnesController "$root/tests/sgb/attr.lua" "$root/build/sgb/attr.gb" > mesen.log 2>&1) || status=1
    printf '%s: ' "$dump"; cat "$work/config/MesenCE/result.txt" 2>/dev/null || { echo "no result"; status=1; }
    rm -rf "$work"
done
exit $status
