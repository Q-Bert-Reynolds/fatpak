#!/usr/bin/env python3
"""The SGB fullscreen map view's recorded pages (build/sgb/map.fph, tests/run_sgb_map.sh) on the real SNES
kernel (Mesen, tests/sgb/map.lua). build: the kernel, the replay ROM paused at checkpoints (before the
map; on it after running east, before the menu; at 512x448 after running south, before its menu), and the
expected map pictures from the pages' MAP commands. check: the map's rows match them pixel for pixel (512x448
sampled at every other pixel and line, as Mesen's picture is saved), and closing the map gives back the text
rows exactly as they were before it."""
import sys,struct
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'scripts'));sys.path.insert(0,str(ROOT/'tests/sgb'))
import sgb_protocol as wire
W=ROOT/'build/sgb'

def checkpoints(pages):
    """Pages before each picture: the browser with Test.gbmap selected, the map before the menu, and the
    512x448 map before its menu"""
    commands=[wire.decode_page(p)[1] for p in pages]
    first=next(i for i,c in enumerate(commands) if any(op==wire.SGBFS_CMD_MAP for op,_ in c))
    menu=next(i for i,c in enumerate(commands) if i>first and any(op==wire.SGBFS_CMD_BOX for op,_ in c))
    browser=max(i for i,c in enumerate(commands[:first]) for op,b in c
                if op==wire.SGBFS_CMD_ROW and b[3]!=b[4] and b'Test.gbmap' in b[7:7+b[5]])+1
    hires=next(i for i,c in enumerate(commands) if any(op==wire.SGBFS_CMD_MAP and b[0]&wire.SGBFS_MAP_HIRES for op,b in c))
    himenu=next(i for i,c in enumerate(commands) if i>hires and any(op in (wire.SGBFS_CMD_MAP,wire.SGBFS_CMD_BOX) for op,_ in c))
    after=next(i for i,c in enumerate(commands) if i>himenu+1 and any(op==wire.SGBFS_CMD_MAP for op,_ in c))
    hibox=max(i for i,c in enumerate(commands[:after]) if any(op==wire.SGBFS_CMD_BOX for op,_ in c))
    return browser,menu,himenu,hibox

def box(pages):
    """The open box's rows after these pages: the first and past the last"""
    top=rows=0
    for p in pages:
        for op,b in wire.decode_page(p)[1]:
            if op==wire.SGBFS_CMD_BOX:x,width,top,rows=struct.unpack('<BHBB',b)
    return top,top+rows

def expected(pages):
    """256x224 BGR555 of BG1's map after these pages (MAP/TILES/COLORS/CELLS/SCROLL); 512x448's every other
    pixel and line (its horizontal scroll counts 2 pixels)."""
    tiles=bytearray(4096);colors=[0]*32;cells=[0]*8192;x0=y0=0;hi=0
    for p in pages:
        for op,b in wire.decode_page(p)[1]:
            if op==wire.SGBFS_CMD_MAP:hi=1 if b[0]&wire.SGBFS_MAP_HIRES else 0
            elif op==wire.SGBFS_CMD_MAP_TILES:tiles[b[0]*16:(b[0]+b[1])*16]=b[2:]
            elif op==wire.SGBFS_CMD_MAP_COLORS:colors[b[0]*4:(b[0]+b[1])*4]=struct.unpack('<'+'H'*4*b[1],b[2:])
            elif op==wire.SGBFS_CMD_MAP_CELLS:
                x,y=(b[0],b[1]) if hi else (b[0]&63,b[1]&31)
                for i in range(b[3]):
                    cells[y*128+x]=b[4+2*i]|b[5+2*i]<<10
                    if b[2]:y=(y+1)&(63 if hi else 31)
                    else:x=(x+1)&(127 if hi else 63)
            elif op==wire.SGBFS_CMD_MAP_SCROLL:x0,y0=struct.unpack_from('<HH',b)
    if hi:x0&=~1
    out=[]
    for y in range(224):
        for x in range(256):
            bx,by=((x<<hi)+x0)&(1023 if hi else 511),((y<<hi)+y0)&(511 if hi else 255);c=cells[(by>>3)*128+(bx>>3)]
            row=tiles[(c&255)*16+(by&7)*2:];bit=7-(bx&7)
            out.append(colors[((c>>10)&7)*4+((row[0]>>bit)&1|((row[1]>>bit)&1)<<1)])
    return out

def build():
    import sgb_kernel
    from kernel_build import recording,replay_rom
    sgb_kernel.build()
    pages=recording(W/'map.fph')
    first,menu,himenu,hibox=checkpoints(pages)
    (W/'map-checkpoints.txt').write_text(f'{first}\n{menu}\n{himenu}\n{hibox}\n{len(pages)}\n')
    replay_rom(pages,checkpoints=(first,menu,himenu,hibox))
    print(f'{len(pages)} pages, checkpoints after {first} (the browser on Test.gbmap), {menu} (the map, before the menu),'
          f' {himenu} (512x448, before its menu) and {hibox} (its menu)')

def ppm(path):
    data=Path(path).read_bytes();assert data.startswith(b'P6\n256 224\n255\n');data=data[15:]
    return [(data[i]>>3)|(data[i+1]>>3)<<5|(data[i+2]>>3)<<10 for i in range(0,len(data),3)]

def check(work):
    pages=__import__('kernel_build').recording(W/'map.fph')
    first,menu,himenu,hibox=checkpoints(pages)
    want=expected(pages[:menu]);got=ppm(Path(work)/f'map-{menu}.ppm')
    bad=[(i%256,i//256) for i in range(8*256,216*256) if got[i]!=want[i]]
    assert not bad, f'map pixels differ from its pages: {len(bad)}, first at {bad[0]}'
    print(f'PASS: the real kernel draws the map: all {208*256} pixels between the bars match its pages')
    want=expected(pages[:himenu]);got=ppm(Path(work)/f'map-{himenu}.ppm')
    bad=[(i%256,i//256) for i in range(224*256) if got[i]!=want[i]]
    assert not bad, f'512x448 pixels differ from its pages: {len(bad)}, first at {bad[0]}'
    print(f'PASS: the real kernel draws the 512x448 map (full screen): all {224*256} sampled pixels match its pages')
    want=expected(pages[:hibox]);got=ppm(Path(work)/f'map-{hibox}.ppm');top,end=box(pages[:hibox])
    assert 0<top<end<27, f'no box: rows {top}-{end}'
    rows=[r for r in range(1,27) if not top<=r<end]
    bad=[(i%256,i//256) for r in rows for i in range(r*8*256,(r+1)*8*256) if got[i]!=want[i]]
    assert not bad, f'512x448 pixels around the menu differ from its pages: {len(bad)}, first at {bad[0]}'
    ui=[r for r in [0,27]+list(range(top,end)) if got[r*8*256:(r+1)*8*256]==want[r*8*256:(r+1)*8*256]]
    assert not ui, f'512x448 rows {ui} show the map, not the bars or the box (mode 1)'
    print(f'PASS: 512x448 with its menu: the bars and box rows ({top}-{end-1}) in mode 1, the map in the {len(rows)} others')
    before,after=ppm(Path(work)/f'map-{first}.ppm'),ppm(Path(work)/'map-end.ppm')
    bad=[i for i in range(8*256,216*256) if before[i]!=after[i]]
    assert not bad, f'closing the map changed {len(bad)} text pixels'
    print('PASS: closing the map gives back the browser, every text pixel as it was')

if __name__=='__main__':
    build() if sys.argv[1:]==['build'] else check(sys.argv[2])
