#!/usr/bin/env python3
"""Build the real 65816 display server. Nothing here changes an emulator."""
from pathlib import Path
import subprocess
import data_file
import fonts
import os
ROOT=Path(__file__).resolve().parents[1]
WORK=ROOT/'build/sgb'

def build():
    WORK.mkdir(parents=True,exist_ok=True)
    names=['mono','vwf','fixed','h1','h2','h3','h4','fixed_bold','fixed_italic',
           'fixed_bold_italic','vwf_bold','vwf_italic','vwf_bold_italic']
    assets=b''.join(data_file.db_bytes(f'img/fonts/font_{n}.asm')[:2048] for n in names)
    assert all(not any(assets[i*2048+256:i*2048+264]) for i in range(13)), 'space glyph must stay blank'
    for font in (2,7):
        assert all(not (v & 15) for v in assets[font*2048:(font+1)*2048]), 'fixed tile font exceeds four pixels'
    # Only VWF needs a width table; the other six fonts have constant widths.
    assets+=data_file.db_bytes('img/fonts/font_vwf.asm')[2048:2304]
    assets+=bytes(v for icon in fonts.button_pixels().values() for row in icon for v in row)
    assert len(assets)==27584
    (WORK/'fonts.bin').write_bytes(assets)
    def run(*args): subprocess.run(args,cwd=ROOT,check=True)
    checks=[flag for flag in ('SNES_GLYPH_CHECK','SNES_CACHE_CHECK','SNES_TILE_CHECK','SNES_PLAIN_CHECK','SNES_SHARED_CHECK') if os.environ.get(flag.replace('SNES_', 'SGB_'))]
    shared = os.environ.get('SGB_SHARED_RENDER') == '1' or 'SNES_SHARED_CHECK' in checks
    if shared: checks.append('SNES_SHARED_RENDER')
    asm_shared = ('-D', 'SHARED_RENDER=1') if shared else ()
    run('cc65',*[arg for flag in checks for arg in ('-D',flag)],'-g','-t','none','-Oirs','-Cl','--cpu','6502','-o',str(WORK/'kernel.s'),'snes/kernel.c')
    run('ca65','-g','-o',str(WORK/'kernel.o'),str(WORK/'kernel.s'))
    run('ca65',*asm_shared,'-o',str(WORK/'hardware.o'),'snes/hardware.s')
    run('ca65','-o',str(WORK/'raster.o'),'snes/raster.s')
    run('ca65','-o',str(WORK/'glyphs.o'),'snes/glyphs.s')
    run('ca65','-o',str(WORK/'overlay.o'),'snes/overlay.s')
    run('ca65','-o',str(WORK/'cache.o'),'snes/cache.s')
    run('ca65',*asm_shared,'-o',str(WORK/'fixed.o'),'snes/fixed.s')
    run('ca65','-o',str(WORK/'plain.o'),'snes/plain.s')
    run('ca65','-o',str(WORK/'map.o'),'snes/map.s')
    run('ca65','-o',str(WORK/'ext.o'),'snes/ext.s')
    run('ca65',*asm_shared,'-o',str(WORK/'shared.o'),'snes/shared.s')
    run('ld65','-C','snes/kernel.cfg','-m',str(WORK/'kernel.map'),'-Ln',str(WORK/'kernel.lbl'),
        '-o',str(WORK/'kernel.bin'),str(WORK/'hardware.o'),str(WORK/'kernel.o'),str(WORK/'raster.o'),str(WORK/'glyphs.o'),str(WORK/'overlay.o'),str(WORK/'cache.o'),str(WORK/'fixed.o'),str(WORK/'plain.o'),str(WORK/'map.o'),str(WORK/'ext.o'),str(WORK/'shared.o'),'/usr/share/cc65/lib/none.lib')
    labels={name.lstrip('.'):int(at,16) for _,at,name in (line.split() for line in (WORK/'kernel.lbl').read_text().splitlines())}
    image=(WORK/'kernel.bin').read_bytes();split=labels['__FONTS_LOAD__']
    row_size=labels['_native_row_size']-labels['__RODATA_RUN__']+labels['__RODATA_LOAD__']
    assert image[row_size]==133, 'native glyph Row ABI changed'
    assert image[split:]==assets and len(image)<=49152
    (WORK/'program.bin').write_bytes(image[:split])
    # The extension: $7E:DC00 on, the 4 px cache's; shared builds keep $F000 on for their lookups.
    ext=(WORK/'kernel.bin.ext').read_bytes()
    assert ext[:2]==len(ext).to_bytes(2,'little') and len(ext)<=(0x1400 if shared else 0x2400), 'kernel extension too big'
    (WORK/'ext.bin').write_bytes(ext)
    print(f'SNES program {split} + fonts {len(assets)} = {len(image)}/49152 bytes, extension {len(ext)}')
if __name__=='__main__':build()
