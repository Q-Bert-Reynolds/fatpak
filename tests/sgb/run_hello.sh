#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/../.." && pwd)
mesen=${MESEN_DLL:-"$root/../MesenCE/bin/linux-x64/Release/Mesen.dll"}
bios=${SGB_BIOS:-"$HOME/Downloads/program.rom"}
boot=${SGB_BOOT:-"$HOME/Downloads/sgb1.boot.rom"}
work=$(mktemp -d /tmp/fatpak-sgb-hello.XXXXXX)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/config/MesenCE/Firmware"
cp -- "$bios" "$work/config/MesenCE/Firmware/SGB1.sfc"
cp -- "$boot" "$work/config/MesenCE/Firmware/sgb_boot.bin"
cp -- "$root/build/sgb/hello.bin" "$work/config/MesenCE/hello.bin"
printf '{}\n' > "$work/config/MesenCE/settings.json"
cd "$work"
XDG_CONFIG_HOME="$work/config" dotnet "$mesen" --testRunner --timeout=60 \
  --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy \
  --Gameboy.UseSgb2=false "$root/tests/sgb/hello.lua" "$root/build/sgb/hello.gb" \
  > mesen.log 2>&1 || {
    cp -- mesen.log "$root/build/sgb/hello-mesen.log"
    if [[ -f config/MesenCE/result.txt ]]; then
      cp -- config/MesenCE/result.txt "$root/build/sgb/hello-result.txt"
    fi
    cat config/MesenCE/result.txt 2>/dev/null
    tail -15 mesen.log
    exit 1
  }
cat config/MesenCE/result.txt
cp -- config/MesenCE/result.txt "$root/build/sgb/hello-result.txt"
cp -- config/MesenCE/hello.png "$root/build/sgb/hello.png"
