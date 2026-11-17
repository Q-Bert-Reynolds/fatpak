#!/usr/bin/env python3
"""Extract committed transactions from the Phase 5 LCD recording and replay
through a plain MBC5 ROM. The SNES receives no emulator-injected responses."""
from pathlib import Path
import sys,struct,subprocess,gzip,os
ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT/'scripts'))
import sgb_kernel,sgb_protocol as wire
W=ROOT/'build/sgb'

def compact(raw):
    sequence,commands=wire.decode_page(raw)
    payload=b''
    for op,body in commands:
        if op==wire.SGBFS_CMD_ROW:
            count=body[5];runs=[]
            for at in range(7+count,len(body),2):
                n,attr=body[at:at+2]
                if runs and runs[-1][1]==attr:runs[-1][0]+=n
                else:runs.append([n,attr])
            body=body[:6]+bytes((len(runs),))+body[7:7+count]+bytes(v for run in runs for v in run)
        payload+=wire.command(op,body)
    return wire.page(sequence,payload)

def recording(path):
    pages=[];expected=1;active=False
    with open(path,'rb') as f:
        assert f.read(5)==b'FPH1\x01'
        while header:=f.read(5):
            typ,n=struct.unpack('<BI',header);data=f.read(n);assert len(data)==n
            if typ==1 and data[0]>>3==0x12: active=True
            if typ!=2 or not active:continue
            # Tiles are transmitted low-plane/high-plane, not scanline order.
            for slot in (0,1):
                first=slot*48*160
                seq=sum((data[first+x]&1)<<(7-x) for x in range(8))
                if seq!=expected:continue
                page=bytearray()
                for tile in range(slot*120,(slot+1)*120):
                    y,x=divmod(tile,20)
                    for line in range(8):
                        pixels=data[(y*8+line)*160+x*8:(y*8+line)*160+x*8+8]
                        for plane in (0,1):page.append(sum(((v>>plane)&1)<<(7-i) for i,v in enumerate(pixels)))
                try:wire.decode_page(page)
                except ValueError:continue
                assert slot==0,'fixture currently streams page A'
                pages.append(bytes(page));expected=1 if expected==255 else expected+1
    assert pages
    return pages

def build():
    sgb_kernel.build()
    raw=gzip.decompress((ROOT/'tests/sgb/fixtures/client.pages.gz').read_bytes())
    assert len(raw)%1920==0
    pages=[raw[i:i+1920] for i in range(0,len(raw),1920)]
    for page in pages:wire.decode_page(page)
    if os.environ.get('SGB_KERNEL_COMPACT'):
        before=sum(int.from_bytes(p[1:3],'little') for p in pages)
        pages=[compact(p) for p in pages]
        after=sum(int.from_bytes(p[1:3],'little') for p in pages)
        print(f'ROW run merging: {before} -> {after} payload bytes')
    (W/'replay-base.pages').write_bytes(b''.join(pages))
    import ui_fixture
    ui_fixture.base_golden(ROOT,W/'kernel-base-golden.png')
    if os.environ.get('SGB_KERNEL_UI'):
        pages+=ui_fixture.pages()
        ui_fixture.golden(ROOT,W/'kernel-golden.png')
    else:
        (W/'kernel-golden.png').write_bytes((W/'kernel-base-golden.png').read_bytes())
    (W/'replay.pages').write_bytes(b''.join(pages));print(f'{len(pages)} frontend pages')
    image=(W/'kernel.bin').read_bytes();image=image.ljust((len(image)+4095)//4096*4096,b'\0');(W/'upload.bin').write_bytes(image)
    source=('DEF UI_REPLAY EQU 1\n' if os.environ.get('SGB_KERNEL_UI') else '')+(ROOT/'tests/sgb/kernel.asm').read_text()
    source=source.replace('UPLOAD_COUNT',str(len(image)//4096)).replace('PAGE_COUNT',str(len(pages)))
    for off in range(0,len(image),16384):
        source+=f'\nSECTION "Upload{off}", ROMX[$4000],BANK[{1+off//16384}]\nINCBIN "build/sgb/upload.bin",{off},{min(16384,len(image)-off)}\n'
    # A separate 2 KiB ROM chunk per page, no bank-crossing copy.
    start=1+(len(image)+16383)//16384
    (W/'replay.inc').write_text(f'DEF FIRST_PAGE_BANK EQU {start}\n')
    for i,page in enumerate(pages):
        (W/f'replay-{i}.bin').write_bytes(page)
        source+=f'\nSECTION "Page{i}",ROMX[${0x4000+(i%8)*2048:04X}],BANK[{start+i//8}]\nINCBIN "build/sgb/replay-{i}.bin"\n'
    (W/'kernel-gb.asm').write_text(source)
    def run(*a):subprocess.run(a,cwd=ROOT,check=True)
    run('rgbasm','-o',str(W/'kernel-gb.o'),str(W/'kernel-gb.asm'))
    run('rgblink','-n',str(W/'kernel.sym'),'-o',str(W/'kernel.gb'),str(W/'kernel-gb.o'))
    run('rgbfix','-v','-s','-l','0x33','-m','0x19','-p','255',str(W/'kernel.gb'))
if __name__=='__main__':build()
