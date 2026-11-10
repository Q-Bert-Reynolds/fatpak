"""Place separately compiled C modules in EverDrive OS pages.

The Makefile compiles each source to build/c/<source>.asm. This pass reads all
modules and their adjacent .banks files before rewriting any calls, so calls to
another C module obey the same page rules as calls within one module. Outputs
are build/asm/<source>.asm, build/c_calls.asm and build/c_modules.inc.

.banks entries assign function names to ROM0, FIXED (resident bank 1), or pages
4-15. * sets the default code page; DATA defaults to FIXED. Constants passed to
code on another page must live in resident memory. THUNKS defaults to FIXED.
OMIT excludes named unused library entry points and their exports.
"""
import argparse
import re
from pathlib import Path

SECTION_RE = re.compile(r'^\tSECTION FRAGMENT "([^"]+)",(\w+)')
FUNCTION_RE = re.compile(r'^; Function (\w+)')
LABEL_RE = re.compile(r'^(_\w+)::?$')
BRANCH_RE = re.compile(r'^(\t(?:call|jp)\s+(?:N?[ZC],\s*)?)(_\w+)(.*)$')
EXPORT_RE = re.compile(r'^\tEXPORT (_\w+)$')
NEAR = ('ROM0', 'FIXED')
SYMBOL_RE = re.compile(r'"(?:\\.|[^"\\])*"|;.*|(?P<symbol>\b_\w+\b)')


def read_config(path):
    destinations, defaults = {}, {}
    if not path.exists():
        return destinations, defaults
    for line in path.read_text().splitlines():
        line = line.split('#')[0].strip()
        if not line:
            continue
        dest, names = (part.strip() for part in line.split(':', 1))
        if dest in ('*', 'DATA', 'THUNKS'):
            defaults[dest] = names
        else:
            for name in names.split():
                destinations['_' + name] = dest
    return destinations, defaults


def section(dest, base):
    if dest == 'ROM0':
        return f'\tSECTION FRAGMENT "{base} ROM0",ROM0'
    if dest == 'FIXED':
        return f'\tSECTION FRAGMENT "{base} FIXED",ROMX,BANK[1]'
    page = int(dest)
    if not 4 <= page <= 15:
        raise ValueError(f'Invalid OS page: {page}')
    return (f'\tSECTION FRAGMENT "Page {page}",ROMX,BANK[{page >> 1}]\n'
            f'\tLOAD FRAGMENT "Page {page} RAM",SRAM,BANK[{page}]')


class Module:
    def __init__(self, source, build):
        self.source = source
        self.output = build / 'asm' / source.with_suffix('.asm')
        self.lines = [line.rstrip() for line in (build / 'c' / source.with_suffix('.asm')).read_text().splitlines()]
        self.config, self.defaults = read_config(source.with_suffix('.banks'))
        # Explicitly excluded library entry points save space without changing
        # vendored sources. References to them still fail at assembly/link time.
        omitted = {name for name, dest in self.config.items() if dest == 'OMIT'}
        kept, skip = [], False
        for line in self.lines:
            if match := FUNCTION_RE.match(line):
                skip = '_' + match[1] in omitted
            elif SECTION_RE.match(line):
                skip = False
            if (match := EXPORT_RE.match(line)) and match[1] in omitted:
                continue
            if not skip:
                kept.append(line)
        self.lines = kept
        self.base = next(m[1][:-5] for line in self.lines
                         if (m := SECTION_RE.match(line)) and m[1].endswith('_CODE'))
        self.prefix = re.sub(r'\W', '_', self.base)
        self.exports = {m[1] for line in self.lines if (m := EXPORT_RE.match(line))}
        # All C output is included by one RGBDS unit. Qualify private functions,
        # data and compiler string labels so independent modules can reuse names.
        self.private = {m[1]: '_' + self.prefix + m[1] for line in self.lines
                        if (m := LABEL_RE.match(line)) and m[1] not in self.exports}
        self.functions = {}
        in_code = False
        for line in self.lines:
            if match := SECTION_RE.match(line):
                in_code = match[1].endswith('_CODE')
            if match := FUNCTION_RE.match(line):
                name = '_' + match[1]
                # SDCC's HOME/runtime helpers already live in resident ROM0.
                self.functions[self.name(name)] = (self.config.get(name, self.defaults.get('*', '4'))
                                                    if in_code else 'ROM0')

    def name(self, symbol):
        return self.private.get(symbol, symbol)

    def rewrite(self, global_functions, thunk_locations, thunks):
        functions = global_functions | self.functions
        out, in_code, block, dest = [], False, None, None
        for line in self.lines:
            match = SECTION_RE.match(line)
            if match:
                in_code = match[1].endswith('_CODE')
                out.append(section(dest, self.base) if in_code and dest else line)
                continue
            match = FUNCTION_RE.match(line)
            label = LABEL_RE.match(line)
            if in_code and match:
                block = self.name('_' + match[1])
                dest = self.functions[block]
                out.append(section(dest, self.base))
            elif in_code and label and self.name(label[1]) != block:
                block = self.name(label[1])
                dest = self.functions.get(block) or self.config.get(label[1]) or self.defaults.get('DATA', 'FIXED')
                out.append(section(dest, self.base))
            line = SYMBOL_RE.sub(lambda m: self.name(m[0]) if m['symbol'] else m[0], line)
            branch = BRANCH_RE.match(line)
            if in_code and branch and dest:
                target = branch[2]
                target_dest = functions.get(target)
                if target_dest and target_dest not in NEAR and target_dest != dest:
                    # One resident thunk per target, shared by every caller.
                    thunks[target] = thunk_locations[target]
                    line = branch[1] + target + '__far' + branch[3]
            out.append(line)
        self.output.parent.mkdir(parents=True, exist_ok=True)
        self.output.write_text('\n'.join(out) + '\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--build-dir', type=Path, default=Path('build'))
    parser.add_argument('sources', type=Path, nargs='+')
    args = parser.parse_args()
    modules = [Module(source, args.build_dir) for source in args.sources]
    exported, thunk_locations = {}, {}
    for module in modules:
        for name, dest in module.functions.items():
            thunk_locations[name] = module.defaults.get('THUNKS', 'FIXED')
            if name in module.exports:
                if name in exported:
                    raise ValueError(f'Duplicate C function: {name}')
                exported[name] = dest
    thunks = {}
    for module in modules:
        module.rewrite(exported, thunk_locations, thunks)
    calls = ['; Generated resident C call thunks. Do not edit.']
    for target, dest in sorted(thunks.items()):
        calls += [section(dest, 'C calls'), target + '__far:',
                  '\tcall FarCallInline', f'\tDB BANK({target})', f'\tDW {target}']
    (args.build_dir / 'c_calls.asm').write_text('\n'.join(calls) + '\n')
    includes = ['; Generated C modules. Do not edit.']
    includes += [f'INCLUDE "{module.output.as_posix()}"' for module in modules]
    includes += [f'INCLUDE "{args.build_dir.as_posix()}/c_calls.asm"']
    (args.build_dir / 'c_modules.inc').write_text('\n'.join(includes) + '\n')
    print(f'bank_split.py: {len(modules)} modules, {len(thunks)} resident call thunks')


if __name__ == '__main__':
    main()
