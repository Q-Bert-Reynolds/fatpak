"""Writes each CC page file's CC_PAGE name and CC_NEED_* block (modules/cc/cc_acc.h): which page-local accessors
it calls, through cc_int.h's macros or directly. A page is a source on its own module page.
usage: python3 scripts/cc_pages.py [--check]"""
import re, sys
from pathlib import Path
CC = Path(__file__).resolve().parent.parent / 'modules/cc'
LOCAL = ['sy_r8', 'sy_r16', 'sy_w8', 'sy_w16', 'ty_r8', 'ty_r16', 'ty_w8', 'ty_w16', 'fl_r16', 'fl_w16',
         'nd_r8', 'nd_r16', 'nd_w8', 'nd_w16', 'nd_r32', 'nd_w32', 'nm_r16', 'nm_w16', 'out_str', 'cc_copy']

def macros():
    """macro name -> the accessors its expansion calls, through other macros too"""
    defs = {}
    for header in sorted(CC.glob('*.h')):
        for m in re.finditer(r'^#define\s+(\w+)(?:\([^)]*\))?\s+(.*)$', header.read_text(), re.M):
            defs[m.group(1)] = m.group(2)
    def calls(name, seen=()):
        body = defs.get(name, '')
        found = {f for f in LOCAL if re.search(r'\b' + f + r'\s*\(', body)}
        for other in re.findall(r'\b([A-Z_][A-Z0-9_]*)\s*\(', body):
            if other in defs and other not in seen:
                found |= calls(other, seen + (name,))
        return found
    return {name: calls(name) for name in defs}

def needs(body, table):
    found = {f for f in LOCAL if re.search(r'(?<![\w.])' + f + r'\s*\(', body)}
    for name in re.findall(r'\b([A-Z_][A-Z0-9_]*)\s*\(', body):
        found |= table.get(name, set())
    return [f for f in LOCAL if f in found]

def main():
    table = macros()
    stale = []
    for page in sorted(CC.glob('cc_*.c')):
        if page.name in ('cc_msgs.c', 'cc_err.c'): # not a pass's page
            continue
        text = page.read_text()
        lines = text.split('\n')
        head = [l for l in lines if l.startswith('//')][:0]
        body = '\n'.join(l for l in lines if not l.startswith(('#define CC_NEED_', '#define CC_PAGE ')))
        include = re.search(r'^#include "(cc_\w+\.h)"', body, re.M)
        block = f'#define CC_PAGE {page.stem[3:]}\n' + ''.join(f'#define CC_NEED_{f}\n' for f in needs(body, table))
        new = body[:include.start()] + block + body[include.start():]
        if new != text:
            stale.append(page.name)
            if '--check' not in sys.argv:
                page.write_text(new)
    if stale and '--check' in sys.argv:
        sys.exit('stale CC_NEED_ blocks (run scripts/cc_pages.py): ' + ' '.join(stale))

if __name__ == '__main__':
    main()
