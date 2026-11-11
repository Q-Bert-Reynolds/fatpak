#!/usr/bin/env python3
"""Build independently linked, fixed-address FatPak modules and their SDK.

Only SDK imports are linked; never consume the host's symbol file.
"""
import binascii
import json
from pathlib import Path
import re
import struct
import subprocess

ROOT = Path(__file__).resolve().parent
PAGE_SIZE = 0x1D00
HEADER = struct.Struct('<4sBBBBHHHHHH12s')


def package(payload, entry, module_id, bss_offset, bss_size):
    if not 0 < len(payload) <= PAGE_SIZE or not 0 <= entry < len(payload):
        raise ValueError('module payload/entry exceeds executable page')
    if not 1 <= module_id <= 255:
        raise ValueError('module ID must be 1..255')
    if not len(payload) <= bss_offset <= PAGE_SIZE or not 0 <= bss_size <= PAGE_SIZE - bss_offset:
        raise ValueError('module BSS overlaps payload or exceeds page')
    return HEADER.pack(b'FPKM', 1, 1, module_id, 13, 0xA000, entry,
                       len(payload), bss_offset, bss_size,
                       binascii.crc_hqx(payload, 0xFFFF), bytes(12)) + payload


def sdk(output):
    abi = json.loads((ROOT / 'modules/abi.json').read_text())
    output.mkdir(parents=True, exist_ok=True)
    declarations = ['/* Generated from modules/abi.json. SDCC SM83 ABI. */',
                    '#ifndef FATPAK_MODULE_SDK_H', '#define FATPAK_MODULE_SDK_H',
                    '#define MODULE_ABI_VERSION 1',
                    '#define MODULE_PAD_B 0x02', '#define MODULE_PAD_START 0x08',
                    'typedef struct { unsigned char type, write, bytes, errors; } ModuleKeyboard;',
                    'typedef struct { unsigned char year, month, day, hour, minute, second; } ModuleClock;']
    imports, table = [], ['; Generated stable resident ABI; never reorder ABI 1 entries.',
                         f'SECTION "Module ABI", ROMX[${abi["address"]:04X}], BANK[1]',
                         'ModuleABI::']
    for index, (name, result, args) in enumerate(abi['entries']):
        address = abi['address'] + 3 * index
        declarations.append(f'{result} Mod{name}({args});')
        imports.append(f'DEF _Mod{name} EQU ${address:04X}')
        table += [f'ASSERT @ == ${address:04X}', f'  jp _ModuleAPI{name}']
    declarations.append('#endif')
    (output / 'sdk.h').write_text('\n'.join(declarations) + '\n')
    (output / 'imports.inc').write_text('\n'.join(imports) + '\n')
    (output / 'table.inc').write_text('\n'.join(table) + '\n')
    return {'_Mod' + item[0] for item in abi['entries']}


def assembly(raw, allowed):
    # Put all executable/literal sections in one LOAD; append private BSS last.
    code, bss = [], []
    target = None
    for line in raw.splitlines():
        if re.match(r'\s*EXPORT\b', line):
            continue
        section = re.match(r'\s*SECTION\s+FRAGMENT\s+"([^"]+)"\s*,\s*(\w+)', line)
        if section:
            name, kind = section.groups()
            if name.endswith('_DATA') and kind == 'WRAM0':
                target = bss
            elif name.endswith('_CODE') and kind == 'ROMX':
                target = code
            else:
                target = None
            continue
        if target is not None:
            target.append(re.sub(r'^\s*\.byte ', ' DB ', line))
        elif line.strip() and not line.lstrip().startswith(';'):
            raise ValueError(f'unsupported module startup/section: {line}')
    defined = set(re.findall(r'^\s*(_[\w]+):', '\n'.join(code + bss), re.M))
    # SDCC external references are underscore-prefixed identifiers, including
    # compiler arithmetic helpers. Reject those too unless provided locally.
    referenced = set()
    for line in code + bss:
        line = re.sub(r'"(?:[^"\\]|\\.)*"', '', line)
        line = line.split(';', 1)[0]
        referenced.update(re.findall(r'(?<![\w.])_+[A-Za-z][\w]*', line))
    unknown = referenced - defined - allowed
    if unknown:
        raise ValueError('non-SDK imports: ' + ', '.join(sorted(unknown)))
    return '\n'.join(['INCLUDE "build/modules/imports.inc"',
        'SECTION "Module", ROMX[$4000], BANK[1]',
        'LOAD "Module RAM", SRAM[$A000], BANK[13]',
        'ModuleStart:', *code, 'ModulePayloadEnd:', *bss, 'ModuleEnd:',
        'ASSERT ModuleEnd <= $BD00', 'ENDL']) + '\n'


def build():
    output = ROOT / 'build/modules'
    allowed = sdk(output)
    source = ROOT / 'modules/keyboard.c'
    subprocess.run(['sdcc', str(source), '-msm83', '--asm=rgbds', '--opt-code-size',
                    '--dataseg', 'WRAM0', '--no-peep', '-S', '-o', str(output/'keyboard.raw.asm')], check=True, cwd=ROOT)
    (output/'keyboard.asm').write_text(assembly((output/'keyboard.raw.asm').read_text(), allowed))
    subprocess.run(['rgbasm', '-o', str(output/'keyboard.o'), str(output/'keyboard.asm')], check=True, cwd=ROOT)
    subprocess.run(['rgblink', '-n', str(output/'keyboard.sym'), '-o', str(output/'keyboard.bin'), str(output/'keyboard.o')], check=True, cwd=ROOT)
    symbols = {}
    for line in (output/'keyboard.sym').read_text().splitlines():
        match = re.match(r'[0-9a-fA-F]+:([0-9a-fA-F]+) (\w+)$', line)
        if match:
            symbols[match[2]] = int(match[1], 16)
    size = symbols['ModulePayloadEnd'] - 0xA000
    payload = (output/'keyboard.bin').read_bytes()[0x4000:0x4000+size]
    destination = ROOT / 'bin/MODULES/KEYTEST.MOD'
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(package(payload, symbols['_ModuleMain'] - 0xA000, 1,
                                   size, symbols['ModuleEnd'] - symbols['ModulePayloadEnd']))
    print(f'KEYTEST.MOD: {size} code/data bytes, {symbols["ModuleEnd"] - symbols["ModulePayloadEnd"]} BSS bytes')


if __name__ == '__main__':
    build()
