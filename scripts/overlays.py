#!/usr/bin/env python3
"""Host-bound OVL1 fixed-code overlay envelope, inside SGB.DAT's overlay page."""
from pathlib import Path
import argparse
import binascii
import utils
import struct

HEADER=struct.Struct('<4sBB2sHHHH')
ABI=1
KIND_RENDER=1
PAGE=0x1D00


def symbols(path):
    result={}
    for line in Path(path).read_text().splitlines():
        fields=line.split()
        if len(fields)==2 and ':' in fields[0]:
            result[fields[1]]=int(fields[0].split(':')[1],16)
    return result


def pack(payload,host,target,entry,lower,upper):
    payload=bytes(payload)
    if len(host)!=2 or not payload or len(payload)>PAGE-HEADER.size:
        raise ValueError('overlay payload/binding')
    if not lower<=target<=entry<target+len(payload)<=upper:
        raise ValueError('overlay outside audited renderer interval')
    crc=utils.module_sum(payload)
    return (HEADER.pack(b'OVL1',ABI,KIND_RENDER,bytes(host),target,len(payload),entry,crc)+payload).ljust(PAGE,b'\0')


def unpack(image,host,lower,upper):
    if len(image)!=PAGE:
        raise ValueError('overlay container size')
    magic,abi,kind,binding,target,size,entry,crc=HEADER.unpack_from(image)
    if (magic,abi,kind,binding)!=(b'OVL1',ABI,KIND_RENDER,bytes(host)):
        raise ValueError('overlay host/ABI/kind')
    body=image[HEADER.size:HEADER.size+size]
    if utils.module_sum(body)!=crc or pack(body,host,target,entry,lower,upper)!=image:
        raise ValueError('overlay CRC/geometry/padding')
    return target,entry,body


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('payload',type=Path)
    p.add_argument('output',type=Path)
    p.add_argument('--os',type=Path,default=Path('bin/GBCOS.BIN'))
    p.add_argument('--symbols',type=Path,default=Path('bin/GBCOS.sym'))
    p.add_argument('--target',type=lambda x:int(x,0))
    p.add_argument('--entry',type=lambda x:int(x,0))
    args=p.parse_args(); syms=symbols(args.symbols)
    low,high=syms['_RenderOverlayStart'],syms['_RenderOverlayEnd']
    target=args.target if args.target is not None else low
    entry=args.entry if args.entry is not None else target
    args.output.write_bytes(pack(args.payload.read_bytes(),args.os.read_bytes()[0x14E:0x150],target,entry,low,high))


if __name__=='__main__':
    main()
