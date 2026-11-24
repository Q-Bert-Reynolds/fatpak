#!/usr/bin/env python3
"""Names the addresses in /GBCSYS/CRASH.LOG (src/fatfs/fatfs.c's CrashLog writes a line at the boot
after a module failure): the code (operation and block; FE 00 is an RST $38, usually a jump into
bytes that aren't code), the module's ID, the page mapped at $A000, SP and the stack's top 8 words.
A crash's first word is the address after the RST $38. Words that look like code addresses are named
from bin/GBCOS.sym and the module's build/modules/<name>/module.sym (a page's symbols are its bank).
usage: python3 scripts/crash_log.py [CRASH.LOG]  (default: the mounted card's)"""
import bisect, collections, json, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CARD = Path('/media') / Path.home().name / 'GAMEBOY/GBCSYS/CRASH.LOG'


def symbols(path):
    table = collections.defaultdict(list)
    try:
        for line in open(path):
            parts = line.split()
            if len(parts) == 2 and ':' in parts[0] and not line.startswith(';'):
                bank, address = parts[0].split(':')
                if '.' not in parts[1]:
                    table[int(bank, 16)].append((int(address, 16), parts[1]))
    except FileNotFoundError:
        pass
    for v in table.values():
        v.sort()
    return table


def name(table, bank, address):
    entries = table.get(bank)
    if not entries:
        return None
    i = bisect.bisect_right(entries, (address, '￿')) - 1
    if i < 0:
        return None
    base, label = entries[i]
    return f'{label}+{address - base:X}' if address != base else label


def describe(word, os_table, module_table, page):
    if word < 0x4000:
        found = name(os_table, 0, word)
    elif word < 0x8000:
        found = name(os_table, 1, word)
    elif 0xA000 <= word < 0xBD00:
        found = name(module_table, page, word) or (name(os_table, page, word) and 'OS ' + name(os_table, page, word))
    else:
        found = None
    return found or ''


def main():
    log = Path(sys.argv[1]) if len(sys.argv) > 1 else CARD
    modules = json.loads((ROOT / 'modules/modules.json').read_text())
    modules = modules['modules'] if isinstance(modules, dict) else modules
    names = {m['id']: m['name'] for m in modules}
    os_table = symbols(ROOT / 'bin/GBCOS.sym')
    for line in log.read_text().splitlines():
        fields = line.split()
        if len(fields) < 5:
            continue
        code, block, module, page = (int(f, 16) for f in fields[:4])
        sp = int(fields[4], 16)
        module_name = names.get(module, f'module {module}')
        module_table = symbols(ROOT / f'build/modules/{module_name}/module.sym')
        kind = 'crash (RST $38)' if code == 0xFE else f'copy failed, operation {code:02X} block {block:02X}'
        print(f'{kind} in {module_name}, page {page:02X}, SP {sp:04X}')
        for i, word in enumerate(int(f, 16) for f in fields[5:]):
            print(f'  SP+{2 * i:<2} {word:04X}  {describe(word, os_table, module_table, page)}')


if __name__ == '__main__':
    main()
