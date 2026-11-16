"""Link replaceable keyboard drivers against this OS's shared state and entries.
Each FPKD v1 file has one 512-byte header followed by the $550-byte page-15 slot.
"""
from pathlib import Path
import binascii, re, struct, subprocess

ROOT = Path(__file__).resolve().parent.parent

def build():
    symbols = {}
    for line in (ROOT / 'bin/GBCOS.sym').read_text().splitlines():
        match = re.match(r'([0-9a-fA-F]+):([0-9a-fA-F]+) (\S+)', line)
        if match: symbols[match[3]] = int(match[2], 16)
    size = 0x550
    assert symbols["KeyboardDriverStart"] == 0xA000
    assert symbols["KeyboardDriverEnd"] == 0xA000 + size
    work = ROOT / 'build/drivers'
    work.mkdir(exist_ok=True)
    own = '\n'.join((ROOT / ('src/keyboard/' + f)).read_text() for f in
                    ['driver_common.asm', 'driver_igkb.asm', 'driver_mouse.asm', 'driver_snes_mouse.asm', 'igkb_handlers.asm'])
    defined = set(re.findall(r'^([A-Za-z_][\w]*):', own, re.M))
    imports = ['DEF %s EQU $%04X' % (name, value) for name, value in symbols.items()
               if re.match(r'^(kb_|sys_info$|sgb_PacketTransfer$|sgb_PacketTransferFast$|SNESMouseSelectOne$|_mouse_|igkb_|KeyboardDriverInit$|oam_buffer$|_render_|_module_busy$|_PosAtX__far$|_cursor$|_anchor$|_selecting$|_redraw$|_moved$|_tb_rows$|tile_buffer$|mem_CopyVRAM$)', name) and '.' not in name and name not in defined]
    config = (ROOT / 'src/keyboard/keyboard.asm').read_text().split('SECTION', 1)[0]
    config = '\n'.join(line for line in config.splitlines() if line.startswith('DEF '))
    prelude = '''INCLUDE "src/hardware.inc"
INCLUDE "src/constants.asm"
INCLUDE "src/macros.asm"
''' + config + '\n' + '\n'.join(imports) + '''
SECTION "Driver", ROM0[0]
LOAD "Driver RAM", SRAM[$A000], BANK[15]
KeyboardDriverStart:
  jp KeyboardDriverInit
  jp DRIVER_PROCESS
INCLUDE "src/keyboard/driver_common.asm"
INCLUDE DRIVER_SOURCE
ASSERT @ - KeyboardDriverStart <= $550
DS $550 - (@ - KeyboardDriverStart), 0
ENDL
'''
    subprocess.run(['ca65', '-o', str(work/'mouse.o'), 'src/sgb/mouse.s'], cwd=ROOT, check=True)
    subprocess.run(['ld65', '-C', 'src/sgb/mouse.cfg', '-Ln', str(work/'mouse.lbl'), '-o', str(work/'mouse.bin'), str(work/'mouse.o')], cwd=ROOT, check=True)
    labels = {name.lstrip('.'): int(addr,16) for _,addr,name in (line.split() for line in (work/'mouse.lbl').read_text().splitlines())}
    assert labels['Install'] == 0x1800 and labels['Stop'] == 0x1803
    (work/'mouse_stop.inc').write_text('DEF SGB_MOUSE_STOP EQU $%04X\n' % labels['Stop'])
    assembly = prelude.replace('DRIVER_PROCESS', 'IGKBProcess').replace('DRIVER_SOURCE', '"src/keyboard/driver_igkb.asm"')
    (work / 'igkb.asm').write_text(assembly)
    subprocess.run(['rgbasm', '-o', str(work/'igkb.o'), str(work/'igkb.asm')], cwd=ROOT, check=True)
    subprocess.run(['rgblink', '-o', str(work/'igkb.bin'), str(work/'igkb.o')], cwd=ROOT, check=True)
    assembly = prelude.replace('DRIVER_PROCESS', 'SNESMouseProcess').replace('DRIVER_SOURCE', '"src/keyboard/driver_snes_mouse.asm"')
    (work/'snes.asm').write_text(assembly)
    subprocess.run(['rgbasm', '-o', str(work/'snes.o'), str(work/'snes.asm')], cwd=ROOT, check=True)
    subprocess.run(['rgblink', '-o', str(work/'snes.bin'), str(work/'snes.o')], cwd=ROOT, check=True)
    packets = []
    snes = (work/'mouse.bin').read_bytes()
    for offset in range(0, len(snes), 11):
        data = snes[offset:offset+11]
        packets.append(bytes([0x79, (0x1800+offset)&255, (0x1800+offset)>>8, 0, len(data)]) + data.ljust(11,b'\0'))
    packets += [bytes([0x79,0,8,0,3,0x4c,0,0x18]) + bytes(8), bytes([0xc9,1]) + bytes(14)]
    assert len(packets) <= 64, 'SNES upload exceeds driver staging limit'
    (work/'mouse.packets').write_bytes(b''.join(packets))
    images = [('PS2', 1, (ROOT/'bin/GBCOS.BIN').read_bytes()[15*8192:15*8192+size]),
              ('IGKB', 2, (work/'igkb.bin').read_bytes()[:size]), ('SGBMOUSE', 4, (work/'snes.bin').read_bytes()[:size])]
    out = ROOT / 'bin/DRIVERS'
    out.mkdir(exist_ok=True)
    for name, kind, payload in images:
        assert len(payload) == size
        count = len(packets) if kind == 4 else 0
        if count: payload = payload.ljust(1536,b'\0') + b''.join(packets)
        header = struct.pack('<4sBBHHHH', b'FPKD', 1, kind, symbols['kb_type'], symbols['KeyboardDriverInit'],
                             binascii.crc_hqx(payload, 0xFFFF), size)
        header += (ROOT/'bin/GBCOS.BIN').read_bytes()[0x14E:0x150]
        (out/(name+'.DRV')).write_bytes((header + bytes([count])).ljust(512,b'\0') + payload)
        print(f'{name}.DRV: {size} bytes, driver ABI 1')

if __name__ == '__main__': build()
