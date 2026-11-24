#!/usr/bin/env bash
# Real SNES CPU/BIOS, mouse device, GB CPU and P1 transport. No Gearboy shortcuts.
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
mesen=${MESEN_DLL:-"$root/../MesenCE/bin/linux-x64/Release/Mesen.dll"}
bios=${SGB_BIOS:-"$HOME/Desktop/sgb/sgb1v2.sfc"}
boot=${SGB_BOOT:-"$HOME/Downloads/sgb_boot.bin"}
work=$(mktemp -d /tmp/fatpak-snes-mouse.XXXXXX)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/config/MesenCE/Firmware"
cp -- "$bios" "$work/config/MesenCE/Firmware/SGB1.sfc"
cp -- "$boot" "$work/config/MesenCE/Firmware/sgb_boot.bin"
printf '{}\n' > "$work/config/MesenCE/settings.json"
cd "$root"
rgbasm -o "$work/test.o" tests/snes_mouse.asm
rgblink -o build/snes_mouse.gb "$work/test.o"
rgbfix -v -s -l 0x33 -t SNESMOUSE -m 0 -p 255 build/snes_mouse.gb
cd "$work"
XDG_CONFIG_HOME="$work/config" dotnet "$mesen" --testRunner --timeout=60 \
  --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy \
  --Gameboy.UseSgb2=false --Snes.Port1.Type=SnesController --Snes.Port2.Type=SnesMouse \
  "$root/tests/snes_mouse.lua" "$root/build/snes_mouse.gb" > mesen.log 2>&1 || {
    cat config/MesenCE/result.txt 2>/dev/null
    tail -15 mesen.log
    exit 1
  }
cat config/MesenCE/result.txt
