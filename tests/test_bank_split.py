"""Regression checks for separately compiled modules sharing one RGBDS unit."""
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / 'bank_split.py'


class BankSplitTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.sources = []
        self.module('src/first.c', '*: 4\n7: helper\n', '''
\tEXPORT _First
\tEXPORT _shared
\tSECTION FRAGMENT "src/first.c_DATA",WRAM0
_shared:
\tDS 1
\tSECTION FRAGMENT "src/first.c_CODE",ROMX
; Function First
_First::
\tcall _Public
\tjp Z, _Public
\tcall _Resident
\tcall _helper
\tcall _AssemblyAPI
\tret
_message:
\tDB "_helper; literal text"
; Function helper
_helper:
\tret
''')
        self.module('src/second.c', '*: 4\n', '''
\tEXPORT _Second
\tSECTION FRAGMENT "src/second.c_CODE",ROMX
; Function Second
_Second::
\tcall _Public
\tcall _helper
\tret
; Function helper
_helper:
\tret
_message:
\tDB "private data"
''')
        self.module('src/api.c', '*: 6\nDATA: FIXED\n', '''
\tEXPORT _Public
\tEXPORT _Resident
\tSECTION FRAGMENT "src/api.c_HOME",ROM0
; Function Resident
_Resident::
\tret
\tSECTION FRAGMENT "src/api.c_CODE",ROMX
; Function Public
_Public::
\tret
''')
        self.run_split()

    def module(self, name, config, assembly):
        source = self.root / name
        source.parent.mkdir(parents=True, exist_ok=True)
        source.write_text('/* compilation fixture */\n')
        source.with_suffix('.banks').write_text(config)
        raw = self.root / 'build/c' / Path(name).with_suffix('.asm')
        raw.parent.mkdir(parents=True, exist_ok=True)
        raw.write_text(assembly.lstrip('\n'))
        self.sources.append(name)

    def run_split(self):
        subprocess.run([sys.executable, str(SCRIPT), *self.sources], cwd=self.root,
                       check=True, capture_output=True, text=True)

    def output(self, path):
        return (self.root / path).read_text()

    def test_external_calls_use_one_shared_thunk(self):
        first = self.output('src/_first.asm')
        second = self.output('src/_second.asm')
        calls = self.output('build/c_calls.asm')
        self.assertIn('call _Public__far', first)
        self.assertIn('jp Z, _Public__far', first)
        self.assertIn('call _Public__far', second)
        self.assertEqual(calls.count('_Public__far:'), 1)
        self.assertIn('DB BANK(_Public)\n\tDW _Public', calls)

    def test_home_and_assembly_calls_stay_direct(self):
        first = self.output('src/_first.asm')
        self.assertIn('call _Resident\n', first)
        self.assertIn('call _AssemblyAPI\n', first)
        self.assertNotIn('_Resident__far', self.output('build/c_calls.asm'))
        self.assertIn('"src/api.c_HOME",ROM0', self.output('src/_api.asm'))

    def test_private_functions_and_data_are_module_local(self):
        first = self.output('src/_first.asm')
        second = self.output('src/_second.asm')
        self.assertIn('call _src_first_c_helper__far', first)
        self.assertIn('call _src_second_c_helper\n', second)
        self.assertIn('_src_first_c_message:', first)
        self.assertIn('_src_second_c_message:', second)
        self.assertIn('_shared:\n', first)
        self.assertIn('DB "_helper; literal text"', first)

    def test_repeated_passes_use_raw_compiler_output(self):
        paths = ['src/_first.asm', 'src/_second.asm', 'src/_api.asm',
                 'build/c_calls.asm', 'build/c_modules.inc']
        before = {path: self.output(path) for path in paths}
        self.run_split()
        self.assertEqual(before, {path: self.output(path) for path in paths})
        self.assertEqual(self.output('build/c_modules.inc').count('INCLUDE "src/_first.asm"'), 1)


if __name__ == '__main__':
    unittest.main()
