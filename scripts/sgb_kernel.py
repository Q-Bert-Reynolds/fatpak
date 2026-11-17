#!/usr/bin/env python3
"""Build the real 65816 display server. Nothing here changes an emulator."""
from pathlib import Path
import subprocess
import data_file
import fonts
ROOT=Path(__file__).resolve().parents[1]
WORK=ROOT/'build/sgb'

def build():
    WORK.mkdir(parents=True,exist_ok=True)
    names=['mono','vwf','fixed','h1','h2','h3','h4','fixed_bold','fixed_italic',
           'fixed_bold_italic','vwf_bold','vwf_italic','vwf_bold_italic']
    assets=b''.join(data_file.db_bytes(f'img/fonts/font_{n}.asm')[:2048] for n in names)
    for i in range(7):
        assets+=data_file.db_bytes('img/fonts/font_vwf.asm')[2048:2304] if i==1 else bytes([8 if i==0 else 4 if i==2 else 11-i])*256
    assets+=bytes(v for icon in fonts.button_pixels().values() for row in icon for v in row)
    assert len(assets)==29120
    (WORK/'fonts.bin').write_bytes(assets)
    def run(*args): subprocess.run(args,cwd=ROOT,check=True)
    run('cc65','-t','none','-Oirs','--cpu','6502','-o',str(WORK/'kernel.s'),'snes/kernel.c')
    run('ca65','-o',str(WORK/'kernel.o'),str(WORK/'kernel.s'))
    run('ca65','-o',str(WORK/'hardware.o'),'snes/hardware.s')
    run('ca65','-o',str(WORK/'raster.o'),'snes/raster.s')
    run('ca65','-o',str(WORK/'overlay.o'),'snes/overlay.s')
    run('ld65','-C','snes/kernel.cfg','-m',str(WORK/'kernel.map'),'-Ln',str(WORK/'kernel.lbl'),
        '-o',str(WORK/'kernel.bin'),str(WORK/'hardware.o'),str(WORK/'kernel.o'),str(WORK/'raster.o'),str(WORK/'overlay.o'),'/usr/share/cc65/lib/none.lib')
    labels={name.lstrip('.'):int(at,16) for _,at,name in (line.split() for line in (WORK/'kernel.lbl').read_text().splitlines())}
    image=(WORK/'kernel.bin').read_bytes();split=labels['__FONTS_LOAD__']
    assert image[split:]==assets and len(image)<=65280
    (WORK/'program.bin').write_bytes(image[:split])
    print(f'SNES program {split} + fonts {len(assets)} = {len(image)}/65280 bytes')
if __name__=='__main__':build()
