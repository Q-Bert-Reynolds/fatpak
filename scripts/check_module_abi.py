"""Reject module ABI and interrupt call chains reaching the borrowed page.

usage: python3 scripts/check_module_abi.py bin/GBCOS.sym <C sources>

C edges come from SDCC output and .banks metadata. Handwritten assembly gates
are explicitly audited below; a new unknown assembly gate fails the build.
Interrupts stay enabled while a module runs, so their handlers are roots too.
"""
import json
from pathlib import Path
import re
import sys
from bank_split import Module, FUNCTION_RE, BRANCH_RE
import utils

PAGE = utils.constants()['MODULE_PAGE']
PAGE2 = utils.constants()['MODULE_PAGE2']  # wide modules borrow it too (module_build.py writes which entries they use)
PAGE3 = utils.constants()['MODULE_PAGE3']
PAGE4 = utils.constants()['MODULE_PAGE4']
PAGE5 = utils.constants()['MODULE_PAGE5']  # the keyboard handlers ('ProcessKeyCodes' and its tables)

# Audited assembly: name -> what it can reach. Each must stay resident or save,
# switch and restore the page itself. EditorDraw switches only to bank 1 (RenderRow,
# the fonts' widths); rows are already lexed, so drawing never reaches KeywordLookup (page 13).
ASM = {
    '_EditorDraw': ['RenderRow'],
    '_WaitFrame': ['UpdateInput', '_FooterTick'],
    '_FooterTick': ['_footer_Tick'],
    '_ClockRead': ['_rtc_Read'],
    '_ClockWrite': ['_rtc_Write'],
    'UpdateInput': ['ProcessKeyCodes'],
    'ProcessKeyCodes': [],  # page 15 with its jump tables and handlers
    '_RenderTextWidth': [], '_RTCRead': [], '_RTCWrite': [], '_KBListen': [], '_KBPopEvent': [], '_PadPressed': [],
    'RenderRow': [],
    '_RenderRawRow': [],  # resident bank 1: mem_Copy, mem_CopyVRAM (ROM0), the row upload
    '_SetWindowBlock': [], '_SettingsSave': [],  # register writes; mem_Copy and its own loop (ROM0)
    '_ThemeApply': ['EditorSetPalettes'],  # THEME_PAGE
    'EditorSetPalettes': ['sgb_SetPal', '_EditorInvertCursor'],
    'sgb_SetPal': ['sgb_PacketTransfer'], 'sgb_PacketTransfer': [], '_EditorInvertCursor': [],
    # ScrollRows -> Layout: ROM0 renderer and row-table helpers only
    '_RenderSetMapRow': [], '_RenderStage': [], '_tb_ScrollRows': [],
    '_tb_Read': [],  # ROM0 text buffer readers
    '_FileLoadFile': ['_fs_LoadFile'],  # BANKED_C stub (ROM0)
    '_FileViewRead': ['_fs_ViewRead'],  # BANKED_C stub (ROM0)
    '_ClockFatTime': ['_rtc_FatTime'],  # BANKED_C stub (ROM0)
    '___memcpy': [],  # FatFs disk/memory helpers (ROM0)
    '_memset': [],  # FatFs disk/memory helpers (ROM0)
    '_strchr': [],  # FatFs disk/memory helpers (ROM0)
    '_memcmp': [],  # FatFs disk/memory helpers (ROM0)
    '_sd_ReadSector': [],  # FatFs disk/memory helpers (ROM0)
    '_sd_WriteSector': [],  # FatFs disk/memory helpers (ROM0)
    '_sd_Init': [],  # FatFs disk/memory helpers (ROM0)
    '_ModuleAPIFar': ['FarCallInline'], 'FarCallInline': [],  # ROM0
    '_RestartDevice': [],  # ROM0: resets the cart and waits
    '_ModuleSwapRAM': [],  # bank 1: its copy, compare and mem_Set (ROM0), RenderWaitDMA
    '___sdcc_call_hl': ['_src_editor_build_c_BuildProgress'],  # ROM0; ModProgress(0)'s only function pointer
    '_PutNumber': ['math_Divide32'], 'math_Divide32': [],  # ROM0 (strings.asm, math.asm)
    # interrupt handlers
    'VBLInterrupt': ['gbdk_DMATransfer', 'LatchPad'],
    'LCDInterrupt': ['RenderLCDInterrupt'],  # via rLCDInterrupt; the editor's handler
    'SerialInterrupt': ['PS2KeyboardInterrupt'],
    'gbdk_DMATransfer': [], 'LatchPad': [], 'RenderLCDInterrupt': [], 'PS2KeyboardInterrupt': [],
}
INTERRUPTS = ['VBLInterrupt', 'LCDInterrupt', 'SerialInterrupt']
# Not followed for wide modules: FatFs calls get_fattime (RTC, page 12) only when it creates or
# writes a file, and the only file entry wide modules use (ModFile and ModLoad -> fs_LoadFile) opens read-only.
WIDE_UNREACHED = {'_get_fattime'}


def check(sources, symbol_path):
    modules = [Module(Path(source), Path('build')) for source in sources]
    destinations = {name: dest for module in modules for name, dest in module.functions.items()}
    edges = {}
    for module in modules:
        current = None
        for line in module.lines:
            if match := FUNCTION_RE.match(line):
                current = module.name('_' + match[1])
                edges[current] = []
            elif current and (match := BRANCH_RE.match(line)):
                edges[current].append(module.name(match[2]))
    symbols = {}
    for line in Path(symbol_path).read_text().splitlines():
        if match := re.match(r'([\da-f]+):([\da-f]+) (\w+)$', line):
            symbols[match[3]] = (int(match[1], 16), int(match[2], 16))
    abi = json.loads(Path('modules/abi.json').read_text())
    def walk(roots, pages, unreached=()):
        visited = set(unreached)

        def visit(name, chain):
            if name in visited:
                return
            visited.add(name)
            chain = chain + [name]
            if destinations.get(name) in pages:
                raise ValueError(f'module ABI reaches a borrowed page ({destinations[name]}): ' + ' -> '.join(chain))
            if name in edges:
                for target in edges[name]:
                    visit(target, chain)
            elif name in ASM:
                if name not in symbols:
                    raise ValueError('audited assembly gate is missing from the symbols: ' + name)
                bank, address = symbols[name]
                if 0xA000 <= address < 0xBD00 and str(bank) in pages:
                    raise ValueError('assembly ABI gate moved into a borrowed page: ' + name)
                for target in ASM[name]:
                    visit(target, chain)
            else:
                raise ValueError('unaudited assembly ABI gate: ' + ' -> '.join(chain))
        for name in roots:
            visit(name, [])
        return visited
    for module in modules:
        if module.source == Path('src/modules/runtime.c'):
            for name, dest in module.functions.items():
                if dest not in ('FIXED', 'ROM0'):
                    raise ValueError('module runtime must remain resident: ' + name)
    visited = walk(['_ModuleAPI' + name for name, *_ in abi['entries']] + INTERRUPTS, {str(PAGE)})
    wide = Path('build/modules/wide.txt')
    wide = wide.read_text().split() if wide.exists() else []
    walk(wide + INTERRUPTS, {str(PAGE), str(PAGE2), str(PAGE3), str(PAGE4), str(PAGE5)}, WIDE_UNREACHED)
    print(f'module ABI: {len(visited)} reachable functions, no page-{PAGE} imports; {len(wide)} wide entries clear of pages {PAGE2}, {PAGE3}, {PAGE4} and {PAGE5}')


if __name__ == '__main__':
    check(sys.argv[2:], sys.argv[1])
