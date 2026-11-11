"""Reject module ABI and interrupt call chains reaching the borrowed page.

usage: python3 check_module_abi.py bin/GBCOS.sym <C sources>

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

# Audited assembly: name -> what it can reach. Each must stay resident or save,
# switch and restore the page itself. EditorDraw's plain-row path uses page 12;
# rows are already lexed, so drawing never reaches KeywordLookup (page 13).
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
    '_SetWindowBlock': [], '_SettingsSave': [],  # register writes; mem_Copy and its own loop (ROM0)
    '_ThemeApply': ['EditorSetPalettes'],  # THEME_PAGE
    'EditorSetPalettes': ['sgb_SetPal', '_EditorInvertCursor'],
    'sgb_SetPal': ['sgb_PacketTransfer'], 'sgb_PacketTransfer': [], '_EditorInvertCursor': [],
    # ScrollRows -> Layout: ROM0 renderer and row-table helpers only
    '_RenderSetMapRow': [], '_RenderStage': [], '_tb_ScrollRows': [],
    # interrupt handlers
    'VBLInterrupt': ['gbdk_DMATransfer', 'LatchPad'],
    'LCDInterrupt': ['RenderLCDInterrupt'],  # via rLCDInterrupt; the editor's handler
    'SerialInterrupt': ['PS2KeyboardInterrupt'],
    'gbdk_DMATransfer': [], 'LatchPad': [], 'RenderLCDInterrupt': [], 'PS2KeyboardInterrupt': [],
}
INTERRUPTS = ['VBLInterrupt', 'LCDInterrupt', 'SerialInterrupt']


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
    visited = set()

    def visit(name, chain):
        if name in visited:
            return
        visited.add(name)
        chain = chain + [name]
        if destinations.get(name) == str(PAGE):
            raise ValueError('module ABI reaches displaced page: ' + ' -> '.join(chain))
        if name in edges:
            for target in edges[name]:
                visit(target, chain)
        elif name in ASM:
            if name not in symbols:
                raise ValueError('audited assembly gate is missing from the symbols: ' + name)
            bank, address = symbols[name]
            if 0xA000 <= address < 0xBD00 and bank == PAGE:
                raise ValueError('assembly ABI gate moved into the borrowed page: ' + name)
            for target in ASM[name]:
                visit(target, chain)
        else:
            raise ValueError('unaudited assembly ABI gate: ' + ' -> '.join(chain))
    for module in modules:
        if module.source == Path('src/modules/runtime.c'):
            for name, dest in module.functions.items():
                if dest not in ('FIXED', 'ROM0'):
                    raise ValueError('module runtime must remain resident: ' + name)
    for name, *_ in abi['entries']:
        visit('_ModuleAPI' + name, [])
    for name in INTERRUPTS:
        visit(name, [])
    print(f'module ABI: {len(visited)} reachable functions, no page-{PAGE} imports')


if __name__ == '__main__':
    check(sys.argv[2:], sys.argv[1])
