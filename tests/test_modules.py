#!/usr/bin/env python3
"""Packer bounds/import checks and malformed on-cartridge fixtures."""
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from module_build import package, assembly, sdk, PAGE_SIZE


def rejected(function, *args):
    try:
        function(*args)
    except ValueError:
        return
    raise AssertionError('invalid module accepted')


def fixtures():
    out = Path('build/modules/fixtures')
    out.mkdir(parents=True, exist_ok=True)
    # Checks zeroed BSS, then exercises module-page pointers through host APIs.
    # Failure returns FR_INT_ERR; normal return is zero.
    code = bytearray([0xFA,0x00,0xA1,0xB7,0x28,0x03,0x3E,0x02,0xC9])
    code += bytes([0xCD,0x00,0x7F,0xFE,1,0x28,3,0x3E,2,0xC9]) # Version
    code += bytes([0x11,0x10,0xA1,0xCD,0x0F,0x7F]) # Keyboard(BSS)
    code += bytes([0xFA,0x12,0xA1,0xFE,37,0x28,3,0x3E,2,0xC9]) # Snapshot in BSS
    code += bytes([0x11,0x20,0xA1,0xCD,0x1B,0x7F]) # Clock(BSS)
    code += bytes([0x11,0x60,0xA0,0x3E,3,0xCD,0x03,0x7F]) # Row(3,literal)
    code += bytes([0x11,0x60,0xA0,0xCD,0x15,0x7F,0xCD,0x18,0x7F]) # Box/Hide
    code += bytes([0x3E,0x5A,0xEA,0x00,0xA1,0xAF,0xC9])
    code += bytes(0x60-len(code)) + b'MODULE STRING\0'
    valid=package(code,0,1,0x100,0x26)
    variants={'valid':valid,'short':valid[:10],'trailing':valid+b'!','empty':b''}
    for name,offset in [('magic',0),('version',4),('abi',5),('id',6),('page',7),
                        ('address',8),('entry',11),('length',13),('bss',15),('reserved',20),('crc',18)]:
        value=bytearray(valid);value[offset]^=0x80;variants[name]=value
    # A maximal page exercises the 256-byte final sector, without touching BD00.
    variants['max']=package(code+bytes(PAGE_SIZE-len(code)),0,1,PAGE_SIZE,0)
    for name,value in variants.items(): (out/(name+'.MOD')).write_bytes(value)
    rejected(package,b'',0,1,0,0)
    rejected(package,bytes(PAGE_SIZE+1),0,1,PAGE_SIZE+1,0)
    rejected(package,b'\xC9',1,1,1,0)
    rejected(package,b'\xC9',0,1,0,1)
    rejected(package,b'\xC9',0,1,PAGE_SIZE,1)
    rejected(assembly,'SECTION FRAGMENT "x_CODE",ROMX\n_ModuleMain:\n call _f_open',set())
    rejected(assembly,'SECTION FRAGMENT "_GSINIT",ROM0\n ld a,1',set())
    rejected(assembly,'SECTION FRAGMENT "x_CODE",ROMX\n_ModuleMain:\n call ___mulint',set())
    print('Module packer bounds and SDK import checks passed')

if __name__ == '__main__': fixtures()
