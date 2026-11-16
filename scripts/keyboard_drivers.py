"""Link replaceable keyboard drivers against this OS's shared state and entries.
Each FPKD v1 file has one 512-byte header followed by the $580-byte page-15 slot.
"""
from pathlib import Path
import binascii, re, struct, subprocess

ROOT = Path(__file__).resolve().parent.parent

def build():
    symbols = {}
    for line in (ROOT / 'bin/GBCOS.sym').read_text().splitlines():
        match = re.match(r'([0-9a-fA-F]+):([0-9a-fA-F]+) (\S+)', line)
        if match: symbols[match[3]] = int(match[2], 16)
    size = 0x580
    assert symbols["KeyboardDriverStart"] == 0xA000
    assert symbols["KeyboardDriverEnd"] == 0xA000 + size
    work = ROOT / 'build/drivers'
    work.mkdir(exist_ok=True)
    own = '\n'.join((ROOT / ('src/keyboard/' + f)).read_text() for f in
                    ['driver_common.asm', 'driver_igkb.asm', 'igkb_handlers.asm'])
    defined = set(re.findall(r'^([A-Za-z_][\w]*):', own, re.M))
    imports = ['DEF %s EQU $%04X' % (name, value) for name, value in symbols.items()
               if re.match(r'^(kb_|_mouse_|igkb_|KeyboardDriverInit$|oam_buffer$|_render_|_module_busy$|_PosAtX__far$|_cursor$|_anchor$|_selecting$|_redraw$|_moved$|_tb_rows$)', name) and '.' not in name and name not in defined]
    config = (ROOT / 'src/keyboard/keyboard.asm').read_text().split('SECTION', 1)[0]
    config = '\n'.join(line for line in config.splitlines() if line.startswith('DEF '))
    assembly = '''INCLUDE "src/hardware.inc"
INCLUDE "src/constants.asm"
INCLUDE "src/macros.asm"
''' + config + '\n' + '\n'.join(imports) + '''
SECTION "Driver", ROM0[0]
LOAD "Driver RAM", SRAM[$A000], BANK[15]
KeyboardDriverStart:
  jp KeyboardDriverInit
  jp IGKBProcess
INCLUDE "src/keyboard/driver_common.asm"
INCLUDE "src/keyboard/driver_igkb.asm"
ASSERT @ - KeyboardDriverStart <= $580
DS $580 - (@ - KeyboardDriverStart), 0
ENDL
'''
    (work / 'igkb.asm').write_text(assembly)
    subprocess.run(['rgbasm', '-o', str(work/'igkb.o'), str(work/'igkb.asm')], cwd=ROOT, check=True)
    subprocess.run(['rgblink', '-o', str(work/'igkb.bin'), str(work/'igkb.o')], cwd=ROOT, check=True)
    images = [('PS2', 1, (ROOT/'bin/GBCOS.BIN').read_bytes()[15*8192:15*8192+size]),
              ('IGKB', 2, (work/'igkb.bin').read_bytes()[:size])]
    out = ROOT / 'bin/DRIVERS'
    out.mkdir(exist_ok=True)
    for name, kind, payload in images:
        assert len(payload) == size
        header = struct.pack('<4sBBHHHH', b'FPKD', 1, kind, symbols['kb_type'], symbols['KeyboardDriverInit'],
                             binascii.crc_hqx(payload, 0xFFFF), size)
        header += (ROOT/'bin/GBCOS.BIN').read_bytes()[0x14E:0x150]
        (out/(name+'.DRV')).write_bytes(header.ljust(512,b'\0') + payload)
        print(f'{name}.DRV: {size} bytes, driver ABI 1')

if __name__ == '__main__': build()
