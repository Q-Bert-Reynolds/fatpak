"""Regression checks for separately compiled modules sharing one RGBDS unit."""
import subprocess
import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / 'scripts/bank_split.py'


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

    def test_generated_modules_stay_in_build(self):
        for source in self.sources:
            source = Path(source)
            self.assertTrue((self.root / 'build/asm' / source.with_suffix('.asm')).is_file())
            self.assertFalse((self.root / source.with_name('_' + source.stem + '.asm')).exists())
        self.assertNotIn('__far', self.output('build/c/src/first.asm'))
        self.assertNotIn('INCLUDE "src/', self.output('build/c_modules.inc'))

    def test_external_calls_use_one_shared_thunk(self):
        first = self.output('build/asm/src/first.asm')
        second = self.output('build/asm/src/second.asm')
        calls = self.output('build/c_calls.asm')
        self.assertIn('call _Public__far', first)
        self.assertIn('jp Z, _Public__far', first)
        self.assertIn('call _Public__far', second)
        self.assertEqual(calls.count('_Public__far:'), 1)
        self.assertIn('DB BANK(_Public)\n\tDW _Public', calls)

    def test_home_and_assembly_calls_stay_direct(self):
        first = self.output('build/asm/src/first.asm')
        self.assertIn('call _Resident\n', first)
        self.assertIn('call _AssemblyAPI\n', first)
        self.assertNotIn('_Resident__far', self.output('build/c_calls.asm'))
        self.assertIn('"src/api.c_HOME",ROM0', self.output('build/asm/src/api.asm'))

    def test_private_functions_and_data_are_module_local(self):
        first = self.output('build/asm/src/first.asm')
        second = self.output('build/asm/src/second.asm')
        self.assertIn('call _src_first_c_helper__far', first)
        self.assertIn('call _src_second_c_helper\n', second)
        self.assertIn('_src_first_c_message:', first)
        self.assertIn('_src_second_c_message:', second)
        self.assertIn('_shared:\n', first)
        self.assertIn('DB "_helper; literal text"', first)

    def test_repeated_passes_use_raw_compiler_output(self):
        paths = ['build/asm/src/first.asm', 'build/asm/src/second.asm', 'build/asm/src/api.asm',
                 'build/c_calls.asm', 'build/c_modules.inc']
        before = {path: self.output(path) for path in paths}
        self.run_split()
        self.assertEqual(before, {path: self.output(path) for path in paths})
        self.assertEqual(self.output('build/c_modules.inc').count('INCLUDE "build/asm/src/first.asm"'), 1)

    def test_omitted_library_entries_leave_no_export_or_body(self):
        self.module('src/library.c', '*: 8\nOMIT: Unused\n', '''
\tEXPORT _Unused
\tEXPORT _Kept
\tSECTION FRAGMENT "src/library.c_CODE",ROMX
; Function Unused
_Unused::
\tld a, 99
\tret
; Function Kept
_Kept::
\tret
''')
        self.run_split()
        output = self.output('build/asm/src/library.asm')
        self.assertNotIn('_Unused', output)
        self.assertNotIn('ld a, 99', output)
        self.assertIn('EXPORT _Kept', output)
        self.assertIn('_Kept::', output)


class LocalJumpTest(unittest.TestCase):
    @staticmethod
    def shorten(source):
        spec = importlib.util.spec_from_file_location('bank_split', SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return '\n'.join(module.shorten_local_jumps(source.splitlines()))

    def test_forward_backward_and_external(self):
        source = '_Fn::\n.start:\n\tjp Z, .end\n\tld a, 1\n\tjp .start\n.end:\n\tjp _External\n'
        output = self.shorten(source)
        self.assertIn('jr Z, .end', output)
        self.assertIn('jr .start', output)
        self.assertIn('jp _External', output)

    def test_far_branch_and_bound(self):
        source = '_Fn::\n\tjp .end\n' + '\tld [$c000], sp\n' * 43 + '.end:\n\tret\n'
        self.assertIn('jp .end', self.shorten(source))

    def test_directives_and_global_scope_are_barriers(self):
        for barrier in ('\tDS 200', '_Other::', '\tSECTION "Other",ROM0', '\tREPT 200'):
            source = '_Fn::\n\tjp .end\n' + barrier + '\n.end:\n\tret\n'
            self.assertIn('jp .end', self.shorten(source))

    def test_switch_table_entries_keep_three_byte_size(self):
        source = '_Fn::\n\tjp hl\n.table:\n\tjp .one\n\tjp .two\n\tjp .three\n.one:\n\tret\n.two:\n\tret\n.three:\n\tret\n'
        output = self.shorten(source)
        for target in ('.one', '.two', '.three'):
            self.assertIn('jp ' + target, output)

    def test_assembled_short_branch(self):
        source = 'SECTION "Code",ROM0[$100]\n_Fn::\n\tjp .end\n\tld [$c000], sp\n.end:\n\tret\n'
        output = self.shorten(source)
        with tempfile.TemporaryDirectory() as folder:
            asm = Path(folder) / 'short.asm'
            asm.write_text(output)
            subprocess.run(['rgbasm','-o',folder+'/short.o',str(asm)],check=True)
            subprocess.run(['rgblink','-o',folder+'/short.gb',folder+'/short.o'],check=True)
            data = (Path(folder)/'short.gb').read_bytes()
            self.assertEqual(data[0x100:0x102], bytes([0x18,3]))


if __name__ == '__main__':
    unittest.main()
