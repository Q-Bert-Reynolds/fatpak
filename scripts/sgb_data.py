#!/usr/bin/env python3
"""Link the host-bound GB terminal overlay and package a supplied SNES kernel."""
from pathlib import Path
import argparse
import subprocess
import re
import overlays
import sgb_protocol

ROOT=Path(__file__).resolve().parents[1]
WORK=ROOT/'build/sgb'


def client(no_log=False):
    WORK.mkdir(parents=True,exist_ok=True)
    definitions=[]
    values={}
    for raw in (ROOT/'bin/GBCOS.sym').read_text().splitlines():
        parts=raw.split()
        if len(parts)!=2 or ':' not in parts[0] or '.' in parts[1]:
            continue
        bank,at=(int(x,16) for x in parts[0].split(':'))
        name=parts[1]
        values[name]=at
        definitions += [f'DEF {name} EQU ${at:04X}',f'DEF HOST_BANK_{name} EQU {bank}']
    # All external control transfers have a small reviewed hardware/metric ABI.
    # The long-lived draw/VBlank paths never call a borrowed OS page.
    code=(ROOT/'src/sgb/display.asm').read_text()
    internal=set(re.findall(r'^(Fs\w+):',code,re.M))
    branches=set(re.findall(r'^\s*(?:call|jp)\s+(?:(?:n?[zc]),\s*)?([A-Za-z_]\w*)(?=\s*(?:;[^\n]*)?$)',code,re.M|re.I))
    allowed={'mem_Set','RenderLineStyled','RenderRowAddress','RenderRowRead','RowHashCached','RowHashStore','RowsNext','RowsSame','RowsSnap','RowsClear','RowsTouchAll','_GeometryWide','_Layout__far',
             'Trampoline','UpdateInputReturn','VBLContinue','_BoxLine','_FileWriteImage','_SGBCellsMap'}
    unknown=branches-internal-allowed
    if unknown: raise ValueError('unaudited terminal imports: '+str(sorted(unknown)))
    if values['ProcessKeyCodes']<0xA000:
        raise ValueError('keyboard driver is no longer page-mapped')
    (WORK/'host.inc').write_text('\n'.join(definitions)+'\n')
    defines=['-D','SGB_LOG_DISABLE=1'] if no_log else []
    subprocess.run(['rgbasm',*defines,'-o',str(WORK/'client.o'),'src/sgb/display.asm'],cwd=ROOT,check=True)
    subprocess.run(['rgblink','-p','0','-n',str(WORK/'client.sym'),'-o',str(WORK/'client.gb'),str(WORK/'client.o')],cwd=ROOT,check=True)
    low,high=values['_RenderOverlayStart'],values['_RenderOverlayEnd']
    body=bytearray((WORK/'client.gb').read_bytes()[low:high])
    if len(body)<high-low: body.extend(bytes(high-low-len(body)))
    os=(ROOT/'bin/GBCOS.BIN').read_bytes()
    # Metrics have their original addresses in ROM0 helpers and remain shared.
    at=values['FontVWFWidths']
    body[at-low:at-low+256]=os[at:at+256]
    image=overlays.pack(body,os[0x14E:0x150],low,low,low,high)
    (WORK/'client.ovl').write_bytes(image)
    return image,os[0x14E:0x150]


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--snes',type=Path)
    parser.add_argument('--fonts',type=Path)
    parser.add_argument('--ext',type=Path,help="the kernel's extension (sgb_kernel.py's ext.bin), sent in CODE commands")
    parser.add_argument('--output',type=Path,default=ROOT/'bin/SGB.DAT')
    parser.add_argument('--no-log',action='store_true',help='control build without SD recorder writes')
    args=parser.parse_args()
    image,binding=client(args.no_log)
    if args.snes:
        fonts=args.fonts.read_bytes() if args.fonts else b''
        args.output.parent.mkdir(parents=True,exist_ok=True)
        ext=args.ext.read_bytes() if args.ext else b''
        args.output.write_bytes(sgb_protocol.data_file(args.snes.read_bytes(),fonts,image,host_checksum=binding,extension=ext))
        print(f'SGB.DAT: {args.output}')


if __name__=='__main__': main()
