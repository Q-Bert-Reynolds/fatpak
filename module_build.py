#!/usr/bin/env python3
"""Build independently linked, fixed-address FatPak modules and their SDK.

usage: python3 module_build.py [--headers]

modules/abi.json lists the resident ABI, modules/modules.json the modules: "sources" go in
the borrowed page; a module with "sources2" (and maybe "sources3") is wide
(MODULE_FORMAT_WIDE): those go in a second (third) page, calls between the pages pass
through ModFar thunks, and its BSS lives in the editor's WRAMX buffers (MODULE_BSS). Pointers must not cross pages: a page's constant data
is only read by its own code. Memory layout, versions and header offsets come from src/constants.asm.
Modules link only against the SDK; never against the host's symbol file.
--headers only regenerates build/modules/{sdk.h,modules.h,imports.inc,table.inc}.
"""
import binascii
import json
from pathlib import Path
import re
import subprocess
import sys

import utils
from bank_split import BRANCH_RE

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / 'build/modules'
C = utils.constants(str(ROOT / 'src/constants.asm'))
PAGE_SIZE = 0x1D00
PAGE_ADDRESS = 0xA000
# The main build's flags (Makefile): peephole.def also fixes `jp (hl)` for RGBDS.
SDCC = ['sdcc', '-msm83', '--asm=rgbds', '--opt-code-size', '--dataseg', 'WRAM0',
        '--no-peep', '--peep-file', 'peephole.def', '--disable-warning', '218', '-S']


def package(payload, entry, module_id, bss_offset, bss_size, abi=1, payload2=None, payload3=None):
    """The .MOD bytes. payload2 (the second page's code, with payload3 a third) makes a wide
    module: bss_offset is then unused (0) and bss_size counts WRAMX bytes at MODULE_BSS."""
    wide = payload2 is not None
    if not 0 < len(payload) <= PAGE_SIZE or not 0 <= entry < len(payload):
        raise ValueError('module payload/entry exceeds executable page')
    if not 1 <= module_id <= 255:
        raise ValueError('module ID must be 1..255')
    if wide:
        if not 0 < len(payload2) <= PAGE_SIZE or bss_offset or not 0 <= bss_size <= C['MODULE_BSS_SIZE']:
            raise ValueError('wide module second page or BSS exceeds its region')
        if payload3 is not None and not 0 < len(payload3) <= PAGE_SIZE:
            raise ValueError('wide module third page exceeds its region')
    elif payload3 is not None:
        raise ValueError('a third page needs a second')
    elif not len(payload) <= bss_offset <= PAGE_SIZE or not 0 <= bss_size <= PAGE_SIZE - bss_offset:
        raise ValueError('module BSS overlaps payload or exceeds page')
    if not 1 <= abi <= C['MODULE_ABI']:
        raise ValueError('module ABI must be 1..MODULE_ABI')
    header = bytearray(C['MODULE_HEADER'])
    header[0:4] = b'FPKM'
    header[C['MODULE_H_FORMAT']] = C['MODULE_FORMAT_WIDE'] if wide else C['MODULE_FORMAT']
    header[C['MODULE_H_ABI']] = abi
    header[C['MODULE_H_ID']] = module_id
    header[C['MODULE_H_PAGE']] = C['MODULE_PAGE']
    fields = [('ADDRESS', PAGE_ADDRESS), ('ENTRY', entry), ('LENGTH', len(payload)),
              ('BSS', bss_offset), ('BSS_SIZE', bss_size),
              ('CRC', binascii.crc_hqx(payload + (payload2 or b'') + (payload3 or b''), 0xFFFF))]
    if wide:
        header[C['MODULE_H_PAGE2']] = C['MODULE_PAGE2']
        fields.append(('LENGTH2', len(payload2)))
    if payload3 is not None:
        header[C['MODULE_H_PAGE3']] = C['MODULE_PAGE3']
        fields.append(('LENGTH3', len(payload3)))
    for field, value in fields:
        offset = C['MODULE_H_' + field]
        header[offset:offset + 2] = value.to_bytes(2, 'little')
    return bytes(header) + payload + (payload2 or b'') + (payload3 or b'')


def write_if_changed(path, text):
    # Unchanged headers keep their timestamps, so make doesn't recompile the OS.
    if not path.exists() or path.read_text() != text:
        path.write_text(text)


def manifest():
    modules = json.loads((ROOT / 'modules/modules.json').read_text())['modules']
    ids, names = set(), set()
    for module in modules:
        if not re.fullmatch(r'[A-Z0-9_]{1,8}', module['name']):
            raise ValueError(f'module name must be an 8.3 base name: {module["name"]}')
        if module['id'] in ids or module['name'] in names or not 1 <= module['id'] <= 255:
            raise ValueError(f'duplicate or invalid module: {module["name"]}')
        ids.add(module['id'])
        names.add(module['name'])
    return modules


def sdk(output=OUTPUT):
    """Write the SDK and host headers. Returns {'_ModName': abi version that added it}."""
    entries = json.loads((ROOT / 'modules/abi.json').read_text())['entries']
    since = [entry[3] if len(entry) > 3 else 1 for entry in entries]
    if since != sorted(since) or since[-1] != C['MODULE_ABI']:
        raise ValueError('abi.json must be append-only and end at MODULE_ABI')
    if len(entries) > C['MODULE_SLOTS'] or C['MODULE_TABLE'] + 3 * C['MODULE_SLOTS'] > 0x8000:
        raise ValueError('module ABI table is full')
    output.mkdir(parents=True, exist_ok=True)
    declarations = ['/* Generated from modules/abi.json by module_build.py. SDCC SM83 ABI. */',
                    '#ifndef FATPAK_MODULE_SDK_H', '#define FATPAK_MODULE_SDK_H',
                    '#include "../../src/constants.h"', '#include "../../src/pad.h"',
                    'typedef struct { unsigned char type, write, bytes, errors; } ModuleKeyboard;',
                    'typedef struct { unsigned char year, month, day, hour, minute, second; } ModuleClock;']
    imports = []
    table = ['; Generated from modules/abi.json. Append only: addresses are the ABI.',
             'SECTION "Module ABI", ROMX[MODULE_TABLE], BANK[1]', 'ModuleABI::']
    for index, (name, result, args, *_) in enumerate(entries):
        declarations.append(f'{result} Mod{name}({args}); // ABI {since[index]}')
        imports.append(f'DEF _Mod{name} EQU ${C["MODULE_TABLE"] + 3 * index:04X}')
        table += [f'ASSERT @ == MODULE_TABLE + {3 * index}', f'  jp _ModuleAPI{name}']
    table.append(f'  DS 3 * (MODULE_SLOTS - {len(entries)}), 0;reserved for later ABI versions')
    declarations.append('#endif')
    hosts = ['/* Generated from modules/modules.json by module_build.py. */',
             '#ifndef FATPAK_MODULE_IDS_H', '#define FATPAK_MODULE_IDS_H']
    for module in manifest():
        hosts += [f'#define MODULE_{module["name"]} {module["id"]}',
                  f'#define MODULE_{module["name"]}_PATH "/GBCSYS/MODULES/{module["name"]}.MOD"']
    hosts += ['#define RUN_MODULE(name) RunModule(MODULE_##name##_PATH, MODULE_##name)', '#endif']
    write_if_changed(output / 'sdk.h', '\n'.join(declarations) + '\n')
    write_if_changed(output / 'modules.h', '\n'.join(hosts) + '\n')
    write_if_changed(output / 'imports.inc', '\n'.join(imports) + '\n')
    write_if_changed(output / 'table.inc', '\n'.join(table) + '\n')
    return {'_Mod' + entry[0]: version for entry, version in zip(entries, since)}


def sections(raw):
    """Split one SDCC output into code and zero-initialized data lines."""
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
    return code, bss


def definitions(lines):
    return set(re.findall(r'^\s*(_[\w]+):', '\n'.join(lines), re.M))


def references(lines):
    referenced = set()
    for line in lines:
        line = re.sub(r'"(?:[^"\\]|\\.)*"', '', line)
        line = line.split(';', 1)[0]
        referenced.update(re.findall(r'(?<![\w.])_+[A-Za-z][\w]*', line))
    return referenced


def thunked(code, remote, suffix=''):
    """Calls and jumps from code to functions in remote ({name: page}, other pages) go through
    ModFar thunks, appended to code. Any other reference to a remote symbol is a pointer that
    would be read with the wrong page mapped, so it's rejected."""
    out, thunks = [], []
    for line in code:
        branch = BRANCH_RE.match(line)
        if branch and branch[2] in remote:
            if branch[2] not in thunks:
                thunks.append(branch[2])
            line = branch[1] + branch[2] + '__far' + suffix + branch[3]
        out.append(line)
    crossing = references(out) & set(remote)
    if crossing:
        raise ValueError('pointer into another page: ' + ', '.join(sorted(crossing)))
    for target in thunks:
        out += [f'{target}__far{suffix}:', '\tcall _ModFar', f'\tDB {remote[target]}', f'\tDW {target}']
    return out


PAGES = ('MODULE_PAGE', 'MODULE_PAGE2', 'MODULE_PAGE3')


def assembly(raws, allowed, raws2=None, raws3=None):
    """Link-ready source for one module from its SDCC outputs; also returns the SDK names used.

    Everything goes in one LOAD block at the borrowed page: code and literals, then BSS.
    A wide module (raws2, maybe raws3) gets a LOAD block per further page and its BSS in WRAMX.
    Rejects initialized data, duplicate symbols and any import outside the SDK,
    including SDCC's arithmetic helpers.
    """
    if isinstance(raws, str):
        raws = [raws]
    groups = [raws, raws2 or [], raws3 or []]
    pages = [[], [], []]
    bss, defined = [], set()
    for index, group in enumerate(groups):
        for raw in group:
            part_code, part_bss = sections(raw)
            names = definitions(part_code + part_bss)
            duplicates = defined & names
            if duplicates:
                raise ValueError('symbol defined twice in module: ' + ', '.join(sorted(duplicates)))
            defined.update(names)
            pages[index] += part_code
            bss += part_bss
    wide = raws2 is not None
    if raws3 is not None and not wide:
        raise ValueError('a third page needs a second')
    if wide:
        if '_ModFar' not in allowed:
            raise ValueError('wide modules need the ModFar ABI entry')
        homes = {name: C[PAGES[index]] for index in range(3) for name in definitions(pages[index])}
        for index in range(3):
            own = definitions(pages[index])
            pages[index] = thunked(pages[index], {name: page for name, page in homes.items() if name not in own},
                                   '' if index == 0 else str(index + 1))  # each page has its own thunks
    referenced = references(pages[0] + pages[1] + pages[2] + bss)
    unknown = referenced - defined - set(allowed) - {name + '__far' + n for name in defined for n in ('', '2', '3')}
    if unknown:
        raise ValueError('non-SDK imports: ' + ', '.join(sorted(unknown)))
    page = C['MODULE_PAGE']
    lines = ['INCLUDE "build/modules/imports.inc"',
             'SECTION "Module", ROMX[$4000], BANK[1]',
             f'LOAD "Module RAM", SRAM[${PAGE_ADDRESS:04X}], BANK[{page}]',
             'ModuleStart:', *pages[0], 'ModulePayloadEnd:']
    if wide:
        lines += ['ModuleEnd:', f'ASSERT ModuleEnd <= ${PAGE_ADDRESS + PAGE_SIZE:04X}', 'ENDL']
        for index, suffix in ((1, 'B'), (2, 'C')):
            if index == 2 and raws3 is None:
                break
            lines += [f'SECTION "Module {suffix}", ROMX[$4000], BANK[{index + 1}]',
                      f'LOAD "Module RAM {suffix}", SRAM[${PAGE_ADDRESS:04X}], BANK[{C[PAGES[index]]}]',
                      f'ModuleStart{suffix}:', *pages[index], f'ModulePayloadEnd{suffix}:',
                      f'ASSERT ModulePayloadEnd{suffix} <= ${PAGE_ADDRESS + PAGE_SIZE:04X}', 'ENDL']
        lines += [f'SECTION "Module BSS", WRAMX[${C["MODULE_BSS"]:04X}], BANK[1]',
                  'ModuleBSS:', *bss, 'ModuleBSSEnd:',
                  f'ASSERT ModuleBSSEnd <= ${C["MODULE_BSS"] + C["MODULE_BSS_SIZE"]:04X}']
    else:
        lines += [*bss, 'ModuleEnd:', f'ASSERT ModuleEnd <= ${PAGE_ADDRESS + PAGE_SIZE:04X}', 'ENDL']
    return '\n'.join(lines) + '\n', referenced & set(allowed)


def compile_sources(work, sources):
    raws = []
    for source in sources:
        raw = work / (Path(source).stem + '.raw.asm')
        subprocess.run(SDCC + [str(ROOT / 'modules' / source), '-o', str(raw)], check=True, cwd=ROOT)
        raws.append(raw.read_text())
    return raws


def build_module(module, versions):
    """Builds bin/MODULES/<name>.MOD; returns the SDK names it uses."""
    name = module['name']
    work = OUTPUT / name
    work.mkdir(parents=True, exist_ok=True)
    wide = 'sources2' in module
    raws = compile_sources(work, module['sources'])
    raws2 = compile_sources(work, module['sources2']) if wide else None
    raws3 = compile_sources(work, module['sources3']) if 'sources3' in module else None
    text, used = assembly(raws, versions, raws2, raws3)
    (work / 'module.asm').write_text(text)
    subprocess.run(['rgbasm', '-o', str(work / 'module.o'), str(work / 'module.asm')], check=True, cwd=ROOT)
    subprocess.run(['rgblink', '-n', str(work / 'module.sym'), '-o', str(work / 'module.bin'),
                    str(work / 'module.o')], check=True, cwd=ROOT)
    symbols = {}
    for line in (work / 'module.sym').read_text().splitlines():
        match = re.match(r'[0-9a-fA-F]+:([0-9a-fA-F]+) (\w+)$', line)
        if match:
            symbols[match[2]] = int(match[1], 16)
    if '_ModuleMain' not in symbols or not PAGE_ADDRESS <= symbols['_ModuleMain'] < symbols['ModulePayloadEnd']:
        raise ValueError(f'{name}: no ModuleMain in the first page')
    size = symbols['ModulePayloadEnd'] - PAGE_ADDRESS
    abi = max([versions[symbol] for symbol in used], default=1)
    image = (work / 'module.bin').read_bytes()
    payload = image[0x4000:0x4000 + size]
    payload2 = payload3 = None
    if wide:
        size2 = symbols['ModulePayloadEndB'] - PAGE_ADDRESS
        payload2 = image[0x8000:0x8000 + size2]
        bss_offset, bss = 0, symbols['ModuleBSSEnd'] - symbols['ModuleBSS']
        report = f'{size} + {size2}'
        if raws3 is not None:
            size3 = symbols['ModulePayloadEndC'] - PAGE_ADDRESS
            payload3 = image[0xC000:0xC000 + size3]
            report += f' + {size3}'
        report += f' code/data bytes in {2 + (raws3 is not None)} pages, {bss} BSS bytes in WRAMX'
    else:
        bss_offset, bss = size, symbols['ModuleEnd'] - symbols['ModulePayloadEnd']
        report = f'{size} code/data bytes, {bss} BSS bytes'
    destination = ROOT / f'bin/MODULES/{name}.MOD'
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(package(payload, symbols['_ModuleMain'] - PAGE_ADDRESS, module['id'],
                                    bss_offset, bss, abi, payload2, payload3))
    print(f'{name}.MOD: {report}, ABI {abi}')
    return used


def build(headers_only=False):
    versions = sdk()
    if headers_only:
        return
    wide_used = set()
    for module in manifest():
        used = build_module(module, versions)
        if 'sources2' in module or 'sources3' in module:
            wide_used |= used
    # check_module_abi.py keeps these entries out of the second page too
    write_if_changed(OUTPUT / 'wide.txt', ''.join(sorted(name.replace('_Mod', '_ModuleAPI', 1) + '\n' for name in wide_used)))


if __name__ == '__main__':
    build('--headers' in sys.argv[1:])
