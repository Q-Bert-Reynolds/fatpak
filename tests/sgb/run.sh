#!/usr/bin/env bash
set -euo pipefail
probe=${1:-hello}
case "$probe" in hello|bench|handoff) ;; *) exit 2 ;; esac
root=$(cd -- "$(dirname -- "$0")/../.." && pwd)
mesen=${MESEN_DLL:-"$root/../MesenCE/bin/linux-x64/Release/Mesen.dll"}
bios=${SGB_BIOS:-"$HOME/Downloads/program.rom"}
boot=${SGB_BOOT:-"$HOME/Downloads/sgb1.boot.rom"}
work=$(mktemp -d /tmp/fatpak-sgb-${probe}.XXXXXX)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/config/MesenCE/Firmware"
cp -- "$bios" "$work/config/MesenCE/Firmware/SGB1.sfc"
cp -- "$boot" "$work/config/MesenCE/Firmware/sgb_boot.bin"
cp -- "$root/build/sgb/${probe}.bin" "$work/config/MesenCE/${probe}.bin"
printf '{}\n' > "$work/config/MesenCE/settings.json"
script=${SGB_TEST_SCRIPT:-"$root/tests/sgb/${probe}.lua"}
cd "$work"
XDG_CONFIG_HOME="$work/config" dotnet "$mesen" --testRunner --timeout=60 \
  --Debug.ScriptWindow.AllowIoOsAccess=true --Gameboy.Model=SuperGameboy \
  --Gameboy.UseSgb2=false --Snes.Port1.Type=SnesController --Snes.Port2.Type=SnesMouse \
  "$script" "$root/build/sgb/${probe}.gb" \
  > mesen.log 2>&1 || {
    cp -- mesen.log "$root/build/sgb/${probe}-mesen.log"
    if [[ -f config/MesenCE/result.txt ]]; then
      cp -- config/MesenCE/result.txt "$root/build/sgb/${probe}-result.txt"
    fi
    if [[ -f config/MesenCE/${probe}.png ]]; then
      cp -- config/MesenCE/${probe}.png "$root/build/sgb/${probe}.png"
    fi
    if [[ -f config/MesenCE/metrics.json ]]; then
      cp -- config/MesenCE/metrics.json "$root/build/sgb/${probe}-metrics.json"
    fi
    cat config/MesenCE/result.txt 2>/dev/null
    tail -15 mesen.log
    exit 1
  }
cat config/MesenCE/result.txt
cp -- config/MesenCE/result.txt "$root/build/sgb/${probe}-result.txt"
cp -- config/MesenCE/${probe}.png "$root/build/sgb/${probe}.png"
if [[ -f config/MesenCE/metrics.json ]]; then
  cp -- config/MesenCE/metrics.json "$root/build/sgb/${probe}-metrics.json"
fi
