#!/usr/bin/env python3
"""The SGB fullscreen map view's recorded pages (build/sgb/map.fph, tests/run_sgb_map.sh) on the real SNES
kernel (Mesen, tests/sgb/map.lua). build: the kernel, the replay ROM paused at two checkpoints (before the
map, and on it after running east, before the menu), and the expected map picture from the pages' MAP
commands. check: the map's rows match it pixel for pixel, and closing the map gives back the text rows
exactly as they were before it."""
import sys,struct
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'scripts'));sys.path.insert(0,str(ROOT/'tests/sgb'))
import sgb_protocol as wire
W=ROOT/'build/sgb'

def checkpoints(pages):
    """Pages before each picture: the browser with Test.gbmap selected, and the map before the menu"""
    commands=[wire.decode_page(p)[1] for p in pages]
    first=next(i for i,c in enumerate(commands) if any(op==wire.SGBFS_CMD_MAP for op,_ in c))
    menu=next(i for i,c in enumerate(commands) if i>first and any(op==wire.SGBFS_CMD_BOX for op,_ in c))
    browser=max(i for i,c in enumerate(commands[:first]) for op,b in c
                if op==wire.SGBFS_CMD_ROW and b[3]!=b[4] and b'Test.gbmap' in b[7:7+b[5]])+1
    return browser,menu

def expected(pages):
    """256x224 BGR555 of BG1's map after these pages (MAP_TILES/COLORS/CELLS/SCROLL)."""
    tiles=bytearray(4096);colors=[0]*32;cells=[0]*2048;x0=y0=0
    for p in pages:
        for op,b in wire.decode_page(p)[1]:
            if op==wire.SGBFS_CMD_MAP_TILES:tiles[b[0]*16:(b[0]+b[1])*16]=b[2:]
            elif op==wire.SGBFS_CMD_MAP_COLORS:colors[b[0]*4:(b[0]+b[1])*4]=struct.unpack('<'+'H'*4*b[1],b[2:])
            elif op==wire.SGBFS_CMD_MAP_CELLS:
                x,y=b[0],b[1]
                for i in range(b[3]):
                    cells[y*64+x]=b[4+2*i]|b[5+2*i]<<10
                    if b[2]:y=(y+1)&31
                    else:x=(x+1)&63
            elif op==wire.SGBFS_CMD_MAP_SCROLL:x0,y0=struct.unpack_from('<H',b)[0],b[2]
    out=[]
    for y in range(224):
        for x in range(256):
            bx,by=(x+x0)&511,(y+y0)&255;c=cells[(by>>3)*64+(bx>>3)]
            row=tiles[(c&255)*16+(by&7)*2:];bit=7-(bx&7)
            out.append(colors[((c>>10)&7)*4+((row[0]>>bit)&1|((row[1]>>bit)&1)<<1)])
    return out

def build():
    import sgb_kernel
    from kernel_build import recording,replay_rom
    sgb_kernel.build()
    pages=recording(W/'map.fph')
    first,menu=checkpoints(pages)
    (W/'map-checkpoints.txt').write_text(f'{first}\n{menu}\n{len(pages)}\n')
    replay_rom(pages,checkpoints=(first,menu))
    print(f'{len(pages)} pages, checkpoints after {first} (the browser on Test.gbmap) and {menu} (the map, before the menu)')

def ppm(path):
    data=Path(path).read_bytes();assert data.startswith(b'P6\n256 224\n255\n');data=data[15:]
    return [(data[i]>>3)|(data[i+1]>>3)<<5|(data[i+2]>>3)<<10 for i in range(0,len(data),3)]

def check(work):
    pages=__import__('kernel_build').recording(W/'map.fph')
    first,menu=checkpoints(pages)
    want=expected(pages[:menu]);got=ppm(Path(work)/f'map-{menu}.ppm')
    bad=[(i%256,i//256) for i in range(8*256,216*256) if got[i]!=want[i]]
    assert not bad, f'map pixels differ from its pages: {len(bad)}, first at {bad[0]}'
    print(f'PASS: the real kernel draws the map: all {208*256} pixels between the bars match its pages')
    before,after=ppm(Path(work)/f'map-{first}.ppm'),ppm(Path(work)/'map-end.ppm')
    bad=[i for i in range(8*256,216*256) if before[i]!=after[i]]
    assert not bad, f'closing the map changed {len(bad)} text pixels'
    print('PASS: closing the map gives back the browser, every text pixel as it was')

if __name__=='__main__':
    build() if sys.argv[1:]==['build'] else check(sys.argv[2])
