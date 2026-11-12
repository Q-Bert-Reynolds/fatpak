#!/usr/bin/env python3
"""Packer bounds/import checks and malformed on-cartridge fixtures."""
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from module_build import package, assembly, sdk, PAGE_SIZE, C


def rejected(function, *args):
    try:
        function(*args)
    except ValueError:
        return
    raise AssertionError('invalid module accepted')


def fixtures():
    out = Path('build/modules/fixtures')
    out.mkdir(parents=True, exist_ok=True)
    versions = sdk()
    table = C['MODULE_TABLE']
    # Checks zeroed BSS, then exercises module-page pointers through host APIs.
    # Failure returns FR_INT_ERR; normal return is zero.
    code = bytearray([0xFA,0x00,0xA1,0xB7,0x28,0x03,0x3E,0x02,0xC9])
    code += bytes([0xCD,table&255,table>>8,0xFE,C['MODULE_ABI'],0x28,3,0x3E,2,0xC9]) # Version
    code += bytes([0x11,0x10,0xA1,0xCD,0x0F,0x7F]) # Keyboard(BSS)
    code += bytes([0xFA,0x12,0xA1,0xFE,37,0x28,3,0x3E,2,0xC9]) # Snapshot in BSS
    code += bytes([0x11,0x20,0xA1,0xCD,0x1B,0x7F]) # Clock(BSS)
    code += bytes([0x11,0x60,0xA0,0x3E,3,0xCD,0x03,0x7F]) # Row(3,literal)
    code += bytes([0x11,0x60,0xA0,0xCD,0x15,0x7F,0xCD,0x18,0x7F]) # Box/Hide
    code += bytes([0x3E,0x5A,0xEA,0x00,0xA1,0xAF,0xC9])
    code += bytes(0x60-len(code)) + b'MODULE STRING\0'
    valid=package(code,0,1,0x100,0x26) # ABI 1: older modules keep running
    variants={'valid':valid,'short':valid[:10],'trailing':valid+b'!','empty':b''}
    for name,offset in [('magic',0),('version',C['MODULE_H_FORMAT']),('abi',C['MODULE_H_ABI']),
                        ('id',C['MODULE_H_ID']),('page',C['MODULE_H_PAGE']),('address',C['MODULE_H_ADDRESS']+1),
                        ('entry',C['MODULE_H_ENTRY']+1),('length',C['MODULE_H_LENGTH']+1),
                        ('bss',C['MODULE_H_BSS']+1),('reserved',C['MODULE_H_RESERVED']),('crc',C['MODULE_H_CRC'])]:
        value=bytearray(valid);value[offset]^=0x80;variants[name]=value
    for name,abi in [('abizero',0),('abinew',C['MODULE_ABI']+1)]:
        value=bytearray(valid);value[C['MODULE_H_ABI']]=abi;variants[name]=value
    # Returns the low byte of the context pointer it was given in DE.
    variants['context']=package(bytes([0x7B,0xC9]),0,1,2,0)
    # A maximal page exercises the 256-byte final sector, without touching BD00.
    variants['max']=package(code+bytes(PAGE_SIZE-len(code)),0,1,PAGE_SIZE,0)
    # Wide: page 13 calls page 12 through a ModFar thunk; page 12 checks its WRAMX BSS is
    # zero, writes it and returns $42 (2 if the BSS wasn't zeroed).
    import json
    entries=[entry[0] for entry in json.loads(Path('modules/abi.json').read_text())['entries']]
    far=table+3*entries.index('Far')
    first=bytes([0xCD,0x06,0xA0,0xC9,0,0,0xCD,far&255,far>>8,C['MODULE_PAGE2'],0x00,0xA0])
    second=bytes([0x21,0x00,0xD0,0x7E,0xB7,0x20,0x05,0x36,0x5A,0x3E,0x42,0xC9,0x3E,0x02,0xC9])
    variants['wide']=package(first,0,1,0,1,C['MODULE_ABI'],second)
    value=bytearray(variants['wide']);value[C['MODULE_H_PAGE2']]^=1;variants['widepage']=value
    value=bytearray(variants['wide']);value[C['MODULE_H_LENGTH2']]+=1;variants['widelength']=value
    value=bytearray(variants['wide']);value[C['MODULE_H_BSS_SIZE']+1]=0x10;variants['widebss']=value
    # Three pages: page 13 calls page 5, which calls page 12 (the wide fixture's code), then adds 1.
    third=bytes([0xCD,0x05,0xA0,0x3C,0xC9, 0xCD,far&255,far>>8,C['MODULE_PAGE2'],0x00,0xA0]) # call thunk; inc a; ret
    call3=bytes([0xCD,0x06,0xA0,0xC9,0,0,0xCD,far&255,far>>8,C['MODULE_PAGE3'],0x00,0xA0])
    variants['wide3']=package(call3,0,1,0,1,C['MODULE_ABI'],second,third)
    value=bytearray(variants['wide3']);value[C['MODULE_H_PAGE3']]^=1;variants['widepage3']=value
    value=bytearray(variants['wide']);value[C['MODULE_H_LENGTH3']]=1;variants['widelength3']=value
    rejected(package,b'\xC9',0,1,0,0,1,None,b'\xC9')
    for name,value in variants.items(): (out/(name+'.MOD')).write_bytes(value)
    rejected(package,b'\xC9',0,1,5,0,1,b'\xC9')
    rejected(package,b'\xC9',0,1,0,C['MODULE_BSS_SIZE']+1,1,b'\xC9')
    rejected(package,b'\xC9',0,1,0,0,1,b'')
    rejected(package,b'\xC9',0,1,0,0,1,bytes(PAGE_SIZE+1))
    rejected(package,b'',0,1,0,0)
    rejected(package,bytes(PAGE_SIZE+1),0,1,PAGE_SIZE+1,0)
    rejected(package,b'\xC9',1,1,1,0)
    rejected(package,b'\xC9',0,1,0,1)
    rejected(package,b'\xC9',0,1,PAGE_SIZE,1)
    rejected(package,b'\xC9',0,1,1,0,C['MODULE_ABI']+1)
    rejected(assembly,'SECTION FRAGMENT "x_CODE",ROMX\n_ModuleMain:\n call _f_open',set())
    rejected(assembly,'SECTION FRAGMENT "_GSINIT",ROM0\n ld a,1',set())
    rejected(assembly,'SECTION FRAGMENT "x_CODE",ROMX\n_ModuleMain:\n call ___mulint',set())
    one='SECTION FRAGMENT "a_CODE",ROMX\n_ModuleMain:\n call _ModRow\n call _Helper'
    two='SECTION FRAGMENT "b_CODE",ROMX\n_Helper:\n call _ModText\n ret'
    rejected(assembly,[one,two.replace('_Helper:','_ModuleMain:')],versions)
    _, used = assembly([one,two],versions)
    assert used == {'_ModRow','_ModText'}, used
    assert max(versions[name] for name in used) == 2, 'an ABI 2 entry makes an ABI 2 module'
    one=one.replace(' call','\tcall') # SDCC's tabs, as BRANCH_RE expects
    wide, used = assembly([one],versions,[two])
    assert '_Helper__far:' in wide and 'call _Helper__far' in wide and 'call _ModFar' in wide, wide
    assert used == {'_ModRow','_ModText','_ModFar'}, used
    rejected(assembly,[one+'\n\tld hl, _Helper'],versions,[two])
    print('Module packer bounds and SDK import checks passed')

if __name__ == '__main__': fixtures()
