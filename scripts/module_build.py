#!/usr/bin/env python3
"""Build independently linked, fixed-address FatPak modules and their SDK.

usage: python3 scripts/module_build.py [--headers]

modules/abi.json lists the resident ABI, modules/modules.json the modules: "sources" go in
the borrowed page; a module with "sources2" (and maybe "sources3" up to "sources5") is wide
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

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / 'build/modules'
C = utils.constants(str(ROOT / 'src/constants.asm'))
PAGE_SIZE = 0x1D00
PAGE_ADDRESS = 0xA000
# The main build's flags (Makefile): peephole.def also fixes `jp (hl)` for RGBDS.
# Modules also turn jp into jr where it reaches (modules/peephole_jr.def), written to PEEPHOLE.
PEEPHOLE = OUTPUT / 'peephole.def'
SDCC = ['sdcc', '-msm83', '--asm=rgbds', '--opt-code-size', '--dataseg', 'WRAM0',
        '--no-peep', '--peep-file', str(PEEPHOLE), '--disable-warning', '218', '-S']


def package(payload, entry, module_id, bss_offset, bss_size, abi=1, payload2=None, payload3=None, payload4=None,
            payload5=None):
    """The .MOD bytes. payload2 (the second page's code, with payload3 up to payload5 more) makes
    a wide module: bss_offset is then unused (0) and bss_size counts WRAMX bytes at MODULE_BSS."""
    extra = [payload2, payload3, payload4, payload5]
    while extra and extra[-1] is None:
        extra.pop()
    if None in extra:
        raise ValueError("a wide module's pages come in order: a third needs a second")
    wide = bool(extra)
    if not 0 < len(payload) <= PAGE_SIZE or not 0 <= entry < len(payload):
        raise ValueError('module payload/entry exceeds executable page')
    if not 1 <= module_id <= 255:
        raise ValueError('module ID must be 1..255')
    if wide:
        if any(not 0 < len(page) <= PAGE_SIZE for page in extra):
            raise ValueError('wide module page exceeds its region')
        if bss_offset or not 0 <= bss_size <= C['MODULE_BSS_SIZE']:
            raise ValueError('wide module BSS exceeds its region')
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
              ('CRC', binascii.crc_hqx(payload + b''.join(extra), 0xFFFF))]
    for number, page in enumerate(extra, 2):
        header[C[f'MODULE_H_PAGE{number}']] = C[f'MODULE_PAGE{number}']
        fields.append((f'LENGTH{number}', len(page)))
    for field, value in fields:
        offset = C['MODULE_H_' + field]
        header[offset:offset + 2] = value.to_bytes(2, 'little')
    return bytes(header) + payload + b''.join(extra)


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
                    'typedef struct { unsigned char year, month, day, hour, minute, second; } ModuleClock;',
                    'typedef struct { unsigned int block, blocks; unsigned long size; } ModuleLoad; // ModLoad: in, in, out']
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


PAGES = ('MODULE_PAGE', 'MODULE_PAGE2', 'MODULE_PAGE3', 'MODULE_PAGE4', 'MODULE_PAGE5')
SUFFIXES = ('', 'B', 'C', 'D', 'E')  # labels of each page's LOAD block


def assembly(raws, allowed, raws2=None, raws3=None, raws4=None, raws5=None):
    """Link-ready source for one module from its SDCC outputs; also returns the SDK names used.

    Everything goes in one LOAD block at the borrowed page: code and literals, then BSS.
    A wide module (raws2, maybe raws3 up to raws5) gets a LOAD block per further page and its BSS
    in WRAMX. Rejects initialized data, duplicate symbols and any import outside the SDK,
    including SDCC's arithmetic helpers.
    """
    if isinstance(raws, str):
        raws = [raws]
    groups = [raws, raws2, raws3, raws4, raws5]
    while groups[-1] is None:
        groups.pop()
    if None in groups:
        raise ValueError("a wide module's pages come in order: a third needs a second")
    count = len(groups)
    pages = [[] for _ in groups]
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
    wide = count > 1
    if wide:
        if '_ModFar' not in allowed:
            raise ValueError('wide modules need the ModFar ABI entry')
        homes = {name: C[PAGES[index]] for index in range(count) for name in definitions(pages[index])}
        for index in range(count):
            own = definitions(pages[index])
            pages[index] = thunked(pages[index], {name: page for name, page in homes.items() if name not in own},
                                   '' if index == 0 else str(index + 1))  # each page has its own thunks
    referenced = references(sum(pages, []) + bss)
    unknown = referenced - defined - set(allowed) - {name + '__far' + n for name in defined for n in ('', '2', '3', '4', '5')}
    if unknown:
        raise ValueError('non-SDK imports: ' + ', '.join(sorted(unknown)))
    page = C['MODULE_PAGE']
    lines = ['INCLUDE "build/modules/imports.inc"',
             'SECTION "Module", ROMX[$4000], BANK[1]',
             f'LOAD "Module RAM", SRAM[${PAGE_ADDRESS:04X}], BANK[{page}]',
             'ModuleStart:', *pages[0], 'ModulePayloadEnd:']
    if wide:
        lines += ['ModuleEnd:', f'ASSERT ModuleEnd <= ${PAGE_ADDRESS + PAGE_SIZE:04X}', 'ENDL']
        for index in range(1, count):
            suffix = SUFFIXES[index]
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
    PEEPHOLE.parent.mkdir(parents=True, exist_ok=True)
    write_if_changed(PEEPHOLE, (ROOT / 'peephole.def').read_text() + (ROOT / 'modules/peephole_jr.def').read_text())
    raws = []
    for source in sources:
        raw = work / (Path(source).stem + '.raw.asm')
        subprocess.run(SDCC + [str(ROOT / 'modules' / source), '-o', str(raw)], check=True, cwd=ROOT)
        raws.append(raw.read_text())
    return raws


def link(work):
    """rgbasm and rgblink. SDCC's labelInRange misjudges a few jumps (the thunks and pages
    module_build adds aren't in its count): each jr the assembler or linker finds out of range
    goes back to jp, and it tries again."""
    source = work / 'module.asm'
    for _ in range(16):
        steps = [['rgbasm', '-o', str(work / 'module.o'), str(source)],
                 ['rgblink', '-n', str(work / 'module.sym'), '-o', str(work / 'module.bin'), str(work / 'module.o')]]
        for step in steps:
            done = subprocess.run(step, capture_output=True, text=True, cwd=ROOT)
            if done.returncode:
                break
        else:
            return
        far = [int(n) for n in re.findall(r'`JR` target must be[^\n]*\n\s*at [^\n]*?\((\d+)\)', done.stderr)]
        if not far:
            sys.stderr.write(done.stderr)
            raise subprocess.CalledProcessError(done.returncode, done.args)
        lines = source.read_text().split('\n')
        for n in far:
            lines[n - 1] = lines[n - 1].replace('\tjr\t', '\tjp\t', 1)
        source.write_text('\n'.join(lines))
    raise ValueError(f'{work.name}: jumps still out of range')


def build_module(module, versions):
    """Builds bin/MODULES/<name>.MOD; returns the SDK names it uses."""
    name = module['name']
    work = OUTPUT / name
    work.mkdir(parents=True, exist_ok=True)
    keys = ['sources', 'sources2', 'sources3', 'sources4', 'sources5']
    groups = [compile_sources(work, module[key]) if key in module else None for key in keys]
    wide = groups[1] is not None
    text, used = assembly(*groups[:1], versions, *groups[1:])
    (work / 'module.asm').write_text(text)
    link(work)
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
    extra = []
    if wide:
        for index in range(1, len(keys)):
            if groups[index] is None:
                break
            length = symbols['ModulePayloadEnd' + SUFFIXES[index]] - PAGE_ADDRESS
            extra.append(image[0x4000 * (index + 1):0x4000 * (index + 1) + length])
        bss_offset, bss = 0, symbols['ModuleBSSEnd'] - symbols['ModuleBSS']
        report = ' + '.join(str(len(page)) for page in [payload] + extra)
        report += f' code/data bytes in {1 + len(extra)} pages, {bss} BSS bytes in WRAMX'
    else:
        bss_offset, bss = size, symbols['ModuleEnd'] - symbols['ModulePayloadEnd']
        report = f'{size} code/data bytes, {bss} BSS bytes'
    destination = ROOT / f'bin/MODULES/{name}.MOD'
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(package(payload, symbols['_ModuleMain'] - PAGE_ADDRESS, module['id'],
                                    bss_offset, bss, abi, *extra))
    print(f'{name}.MOD: {report}, ABI {abi}')
    return used


def build(headers_only=False):
    versions = sdk()
    if headers_only:
        return
    wide_used = set()
    for module in manifest():
        used = build_module(module, versions)
        if 'sources2' in module:
            wide_used |= used
    # check_module_abi.py keeps these entries out of the second page too
    write_if_changed(OUTPUT / 'wide.txt', ''.join(sorted(name.replace('_Mod', '_ModuleAPI', 1) + '\n' for name in wide_used)))


if __name__ == '__main__':
    build('--headers' in sys.argv[1:])
