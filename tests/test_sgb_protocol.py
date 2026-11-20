#!/usr/bin/env python3
"""Phase 1 executable wire specification; no emulator or OS build required."""
from pathlib import Path
import random
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
import sgb_protocol as p


class Protocol(unittest.TestCase):
    def reject(self, function, *args, **kwargs):
        with self.assertRaises(ValueError):
            function(*args, **kwargs)

    def test_generated_consumers_and_real_assemblers(self):
        p.generate(check=True)
        self.assertEqual(len(p.COMMANDS), 21)
        self.assertEqual(len(p.EVENTS), 18)
        with tempfile.TemporaryDirectory() as tmp:
            work = Path(tmp)
            fixtures = {
                'rgb.asm': 'INCLUDE "src/sgb/protocol.asm"\nSECTION "Test", ROM0\nDW SGBFS_PAGE_SIZE\nDB SGBFS_CMD_RESET\n',
                'ca.s': '.include "snes/protocol.inc"\n.segment "CODE"\n.word SGBFS_PAGE_SIZE\n.byte SGBFS_CMD_RESET\n',
                'host.cpp': '#include "tests/sgb/protocol.hpp"\nstatic_assert(sgbfs::SGBFS_PAGE_SIZE==1920, "size");\nstatic_assert(sgbfs::SGBFS_CMD_RESET==16,"opcode");\n',
                'host.c': '#include "src/sgb/protocol.h"\n_Static_assert(SGBFS_PAGE_SIZE==1920,"size");\n_Static_assert(SGBFS_CMD_RESET==16,"opcode");\n',
            }
            for name, content in fixtures.items():
                (work / name).write_text(content)
            for tool, args in [('rgbasm', ['-o', str(work/'rgb.o'), str(work/'rgb.asm')]),
                               ('ca65', ['-I', str(ROOT), '-o', str(work/'ca.o'), str(work/'ca.s')]),
                               ('c++', ['-std=c++11', '-I', str(ROOT), '-c', str(work/'host.cpp'), '-o', str(work/'cpp.o')]),
                               ('cc', ['-std=c11', '-I', str(ROOT), '-c', str(work/'host.c'), '-o', str(work/'c.o')])]:
                self.assertTrue(shutil.which(tool), f'{tool} is required')
                subprocess.run([tool, *args], cwd=ROOT, check=True)

    def examples(self):
        row = p.row(2, 2, 1, 4, 20, b'example', bytes([4,4,0x94,0x94,4,4,4]))
        bodies = {
            'ROW_SAME': bytes([3,2]), 'SCROLL': bytes([255,1]),
            'LAYOUT': bytes([1,21,3,5]), 'CURSOR': bytes([2,255,1]),
            'BOX': struct.pack('<BHBB', 0,256,2,5),
            'BOX_LINE': bytes([1,1,4])+b'OPEN', 'BOX_HI': b'\1',
            'BAR': bytes([1,1,4])+b'TEST', 'OSK': bytes([0,49]),
            'PALETTE': bytes([0,3])+struct.pack('<HHH',0x7fff,0,0x1234),
            'BUSY': b'\1', 'PROGRESS': struct.pack('<II',65536,100000),
            'LAUNCH': b'\1', 'HELLO': bytes([p.SGBFS_VERSION,p.SGBFS_PROFILE]),
            'RESET': bytes([p.SGBFS_VERSION,p.SGBFS_PROFILE]),
            'MAP': b'\2', 'MAP_TILES': bytes([255,1])+bytes(range(16)),
            'MAP_COLORS': bytes([7,1])+struct.pack('<4H',0x7fff,0x1234,0,0x0421),
            'MAP_CELLS': bytes([127,63,1,2,128,7,0,0]), 'MAP_SCROLL': struct.pack('<HH',1023,511),
        }
        return [row]+[p.command(getattr(p,'SGBFS_CMD_'+name), body) for name, body in bodies.items()]

    def test_every_command_and_page_round_trip(self):
        payload = b''.join(self.examples())
        decoded = p.commands(payload)
        self.assertEqual({op for op, body in decoded}, set(p.COMMANDS))
        self.assertEqual(b''.join(p.command(*item) for item in decoded), payload)
        self.assertEqual(p.decode_page(p.page(255,payload)), (255,decoded))
        self.assertEqual(p.decode_page(p.page(1,b'')), (1,[]))
        self.assertEqual(p.crc(b'123456789'), 0x29b1)

    def test_map_limits(self):
        for name, body in [('MAP',b'\3'),('MAP',b'\x10'),('MAP',b'\x13'),('MAP',b'\x21'),('MAP_TILES',bytes([255,2])+bytes(32)),('MAP_TILES',bytes([0,65])+bytes(1040)),
                           ('MAP_TILES',bytes([0,1])+bytes(15)),('MAP_COLORS',bytes([7,2])+bytes(16)),
                           ('MAP_COLORS',bytes([0,1])+struct.pack('<4H',0x8000,0,0,0)),('MAP_CELLS',bytes([128,0,0,1,0,0])),
                           ('MAP_CELLS',bytes([0,64,0,1,0,0])),('MAP_CELLS',bytes([0,0,2,1,0,0])),('MAP_CELLS',bytes([0,0,0,1,0,8])),
                           ('MAP_CELLS',bytes([0,0,0,2,0,0])),('MAP_SCROLL',struct.pack('<HH',1024,0)),('MAP_SCROLL',struct.pack('<HH',0,512)),('MAP_SCROLL',struct.pack('<HB',0,0))]:
            self.reject(p.command,getattr(p,'SGBFS_CMD_'+name),body)

    def test_rle_random_and_limits(self):
        rng = random.Random(0x534742)
        for count in range(65):
            attrs = bytes((rng.randrange(15)<<4)|rng.randrange(1,16) for _ in range(count))
            self.assertEqual(p.rle_decode(p.rle_encode(attrs),count), attrs)
        self.assertEqual(p.rle_encode(bytes([4]*64)), bytes([64,4]))
        for data, size in [(b'\0\4',0), (b'\2\4',1), (b'\1\4',2), (b'\1',1), (b'\1\0',1),(b'\1\xf4',1)]:
            self.reject(p.rle_decode,data,size)
        self.reject(p.row, 0,2,1,0,0,b'x'*64,bytes([4]*64))  # 256 px exceeds 248
        p.row(0,2,1,0,255,b'x'*62,bytes([4]*62))
        self.reject(p.row, 28,2,1,0,0,b'',b'')
        self.reject(p.row, 0,7,1,0,0,b'',b'')

    def test_tears_corruption_truncation_and_atomic_parse(self):
        encoded = p.page(42,b''.join(self.examples()))
        length = struct.unpack_from('<H',encoded,1)[0]+5
        for position in range(length):
            broken=bytearray(encoded);broken[position]^=1
            self.reject(p.decode_page,broken)
        for length in [0,1,1919,1921]:
            self.reject(p.decode_page,encoded[:length] if length<1920 else encoded+b'\0')
        for broken in [b'\xff\0\0',b'\1',b'\1\xff\xff',p.command(p.SGBFS_CMD_BUSY,b'\1')+b'\x03\x02\x00\x00\x00']:
            self.reject(p.commands,broken)
        self.reject(p.page,0,b'')
        self.reject(p.page,1,p.command(p.SGBFS_CMD_BUSY,b'\1')*500)
        self.reject(p.command,p.SGBFS_CMD_HELLO,b'\2\0')
        self.reject(p.command,p.SGBFS_CMD_PALETTE,b'\0\1\0\x80')
        self.reject(p.command,p.SGBFS_CMD_LAYOUT,bytes([1,27,3,5]))
        self.reject(p.command,p.SGBFS_CMD_BOX,struct.pack('<BHBB',1,256,0,1))
        self.reject(p.command,p.SGBFS_CMD_PROGRESS,struct.pack('<II',2,1))

    def test_sequences_order_and_retransmission(self):
        self.assertEqual(p.next_sequence(255),1)
        self.assertEqual(p.next_sequence(127,127),1)
        self.assertTrue(p.newer(1,255))
        self.assertFalse(p.newer(255,1))
        self.assertFalse(p.newer(1,1))
        self.reject(p.newer,0,1)
        # Receiver applies only its next global sequence. An early page remains
        # unacknowledged and can be recaptured after the missing page arrives.
        expected=1
        applied=[]
        for sequence in [2,1,1,2,3]:
            actual, decoded=p.decode_page(p.page(sequence,b''))
            if actual==expected:
                applied.append(actual);expected=p.next_sequence(expected)
        self.assertEqual(applied,[1,2,3])

    def test_mailbox_all_events_seqlock_and_buttons(self):
        values={'KEY':(0x81,3),'MOUSE_DOWN':(27|0x60,255),'MOUSE_DRAG':(1|0x20,4),
                'MOUSE_UP':(0,0),'MOUSE_MOVE':(27,255),'HELLO':(1,7),'ACK':(1,255),'LAUNCH_READY':(1,0),'PAD':(0x82,0x80)}
        for name,payload in values.items():
            data=p.mailbox(127,getattr(p,'SGBFS_EVENT_'+name),*payload)
            self.assertEqual(p.decode_mailbox(127,data,127),tuple(data))
            self.reject(p.decode_mailbox,126,data,127)
            self.reject(p.decode_mailbox,255,data,255)
        self.reject(p.mailbox,1,p.SGBFS_EVENT_PAD,0,2)
        self.reject(p.mailbox,0,p.SGBFS_EVENT_KEY,1,0)
        self.reject(p.mailbox,1,p.SGBFS_EVENT_ACK,2,1)
        self.reject(p.mailbox,1,p.SGBFS_EVENT_MOUSE_DOWN,28,0)
        self.reject(p.mailbox,1,p.SGBFS_EVENT_MOUSE_DOWN,128,0)

    def test_status_and_data_file(self):
        data=p.status(65535,127,True,255,1)
        self.assertEqual(p.decode_status(data),(65535,127,True,255,1))
        for i in range(16):
            broken=bytearray(data);broken[i]^=1
            self.reject(p.decode_status,broken)
        program,fonts,overlays=b'\xea'*4097,b'font',bytes(p.SGBFS_OVERLAY_PAGE_SIZE)
        binding=b'\x12\x34'
        data=p.data_file(program,fonts,overlays,entry=0x7f0001,host_checksum=binding)
        self.assertEqual(p.decode_data_file(data,host_checksum=binding),(0x7f0000,0x7f0001,(program,fonts,overlays)))
        self.reject(p.decode_data_file,data)
        self.reject(p.decode_data_file,data,host_checksum=b'\x12\x35')
        self.assertEqual(p.decode_data_file(p.data_file(b'x')),(0x7f0000,0x7f0000,(b'x',b'',b'')))
        for i in [0,4,5,8,11,14,18,22,26,28,31,32,len(data)-1]:
            broken=bytearray(data);broken[i]^=1
            self.reject(p.decode_data_file,broken,host_checksum=binding)
        self.reject(p.decode_data_file,data[:-1],host_checksum=binding)
        self.reject(p.decode_data_file,data+b'\0')
        self.reject(p.data_file,b'x',overlays=b'x')
        self.reject(p.data_file,b'x',load=0x7f0001,entry=0x7f0001)
        self.reject(p.data_file,b'x'*65537)


if __name__ == '__main__':
    unittest.main()
