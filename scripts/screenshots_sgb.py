#!/usr/bin/env python3
"""Replay screenshot frontend recordings through FatPak's real SNES renderer."""
from collections import defaultdict
from pathlib import Path
import json
import os
import shutil
import subprocess
import sys
import tempfile
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path[:0] = [str(ROOT / 'scripts'), str(ROOT / 'tests/sgb')]
import kernel_build


def main():
    output = Path(sys.argv[1]).resolve()
    groups = defaultdict(list)
    if not (output / 'sgb-shots.tsv').exists(): return  # no SGB shots taken (FATPAK_SHOTS_THEMES)
    for line in (output / 'sgb-shots.tsv').read_text().splitlines():
        recording, end, name = line.split('\t')
        groups[recording].append((int(end), name))
    kernel_build.sgb_kernel.build()
    for recording, marks in groups.items():
        pages = kernel_build.recording(recording)
        checkpoints = defaultdict(list)
        for end, name in marks:
            checkpoints[len(kernel_build.recording(recording, end))].append(name)
        kernel_build.replay_rom(pages, checkpoints=checkpoints)
        with tempfile.TemporaryDirectory(prefix='fatpak-shots-mesen-') as temp:
            work = Path(temp)
            config = work / 'config/MesenCE'
            firmware = config / 'Firmware'
            firmware.mkdir(parents=True)
            shutil.copyfile(os.environ.get('SGB_BIOS', Path.home() / 'Desktop/sgb/sgb1v2.sfc'), firmware / 'SGB1.sfc')
            shutil.copyfile(os.environ.get('SGB_BOOT', Path.home() / 'Downloads/sgb_boot.bin'), firmware / 'sgb_boot.bin')
            (config / 'settings.json').write_text('{}\n')
            labels = {name.lstrip('.'): int(address, 16) for _, address, name in
                      (line.split() for line in (ROOT / 'build/sgb/kernel.lbl').read_text().splitlines())}
            (config / 'kernel-symbols.lua').write_text('return {' + ','.join(
                f'["{name}"]={address}' for name, address in labels.items()) + '}\n')
            # the replay's page counter ($C111) is a byte: a module's or 512x448's recording passes 255
            if len({page % 256 for page in checkpoints}) != len(checkpoints):
                raise RuntimeError(f'{recording}: two checkpoints 256 pages apart')
            (config / 'shots.lua').write_text('return {' + ','.join(
                f'[{page % 256}]={{' + ','.join(json.dumps(name) for name in names) + '}'
                for page, names in checkpoints.items()) + '}\n')
            env = dict(os.environ, XDG_CONFIG_HOME=str(work / 'config'))
            command = ['dotnet', os.environ.get('MESEN_DLL', str(ROOT / '../MesenCE/bin/linux-x64/Release/Mesen.dll')),
                       '--testRunner', '--timeout=300', '--Debug.ScriptWindow.AllowIoOsAccess=true',
                       '--Gameboy.Model=SuperGameboy', '--Gameboy.UseSgb2=false',
                       '--Snes.Port1.Type=SnesController', '--Snes.Port2.Type=SnesMouse',
                       str(ROOT / 'scripts/screenshots_sgb.lua'), str(ROOT / 'build/sgb/kernel.gb')]
            with (work / 'mesen.log').open('w') as log:
                result = subprocess.run(command, cwd=work, env=env, stdout=log, stderr=subprocess.STDOUT)
            expected = [name for names in checkpoints.values() for name in names]
            if result.returncode or any(not (config / f'{name}.ppm').exists() for name in expected):
                raise RuntimeError((work / 'mesen.log').read_text())
            for name in expected:
                image = Image.open(config / f'{name}.ppm')
                if image.size != ((512, 448) if '_sgb512' in name else (256, 224)) or len(image.getcolors(512 * 448)) < 2:
                    raise RuntimeError(f'Incomplete SGB capture: {name}')
                shutil.copyfile(config / f'{name}.ppm', output / f'{name}.ppm')
                print(f'{name}: real SNES PPU', flush=True)


if __name__ == '__main__':
    main()
