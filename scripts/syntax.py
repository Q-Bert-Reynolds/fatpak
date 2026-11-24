#!/usr/bin/env python3
"""Compiles data/syntax/*.txt to bin/SYNTAX/<KEY>.SYN, one per extension or name, for /GBCSYS/SYNTAX: how the
editor styles a file with that extension (src/editor/text_buffer.asm's TBLexCode, loaded by
src/fatfs/fatfs.c's fs_LoadSyntax). Markdown is built in and has no definition.

A source has one setting per line, # starts a comment line:
  extensions c h        the extensions it's for
  names Makefile        or whole names, for files without an extension. A file's key is the text after
                        its last dot (.gitignore: gitignore) or, with no dot, its name; KEY.SYN is its
                        definition
  line //               line comment, 1 or 2 chars
  block /* */           block comment open and close, 1 or 2 chars each
  quotes " '            1 or 2 string quotes (the second is styled the same, like C's chars)
  escape \\             escapes the char after it in a string
  directive #           at a line's start (after spaces), styles it and the word after it as a directive
  fold                  keywords are case insensitive (write them in lowercase)
  dot                   . can be in a word
  labels                a word at column 0, or one starting with . after spaces, is a label
  radix                 $ (hex) and % (binary) start numbers
  keyword / type / number / directive-word words...   keywords and their style; a word's first style wins

The .SYN file: "SYN" and SYN_VERSION, then flags, line comment (2), block open (2) and close (2),
quote, second quote, escape, directive char (unused ones are 0), a 0, 32 bucket offsets (DW, 0 = empty) for
words by first char & 31, and the buckets: DB length, style << 4, chars per word, then 0. A bucket
never crosses a 512 byte block (the editor reads them through the PSRAM window), the file fits
SYNTAX_BLOCKS blocks."""
import pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
VERSION = 1
HEADER = 16  # bytes before the bucket offsets (SYN_HEADER)

def constants():
  values = {}
  for line in (ROOT / 'src/constants.asm').read_text().splitlines():
    m = re.match(r'\s*DEF\s+(\w+)\s+EQU\s+(\$[0-9A-Fa-f]+|%[01]+|\d+)\s*(?:;|$)', line)
    if m:
      v = m.group(2)
      values[m.group(1)] = int(v[1:], 16) if v[0] == '$' else int(v[1:], 2) if v[0] == '%' else int(v)
  return values

C = constants()
FLAGS = {'fold': C['SYN_FOLD'], 'dot': C['SYN_DOT'], 'labels': C['SYN_LABEL'], 'radix': C['SYN_RADIX']}
STYLES = {'keyword': C['STYLE_KEYWORD'], 'type': C['STYLE_TYPE'], 'number': C['STYLE_NUMBER'],
          'directive-word': C['STYLE_PREPROC']}

def fail(source, message):
  sys.exit(f'{source}: {message}')

def marker(source, text, name):
  if not 1 <= len(text) <= 2: fail(source, f'{name} must be 1 or 2 chars')
  return [ord(c) for c in text] + [0] * (2 - len(text))

def compile_source(source):
  flags = 1 << C['SYN_LOADED']
  line, block_open, block_close, quotes, escape, directive = [0, 0], [0, 0], [0, 0], [0, 0], 0, 0
  extensions, words = [], {}
  for raw in source.read_text().splitlines():
    if not raw.strip() or raw.lstrip().startswith('#'): continue
    key, *args = raw.split()
    if key in ('extensions', 'names'): extensions += args
    elif key == 'line': line = marker(source, args[0], 'line')
    elif key == 'block':
      block_open, block_close = marker(source, args[0], 'block'), marker(source, args[1], 'block')
    elif key == 'quotes':
      if not 1 <= len(args) <= 2 or any(len(q) != 1 for q in args): fail(source, 'quotes are 1 or 2 chars')
      quotes = [ord(q) for q in args] + [0] * (2 - len(args))
    elif key == 'escape': escape = ord(args[0])
    elif key == 'directive': directive = ord(args[0])
    elif key in FLAGS: flags |= 1 << FLAGS[key]
    elif key in STYLES:
      for w in args:
        if len(w) > C['KEYWORD_MAX']: fail(source, f'{w} is longer than KEYWORD_MAX')
        if flags & 1 << C['SYN_FOLD'] and w != w.lower(): fail(source, f'{w}: fold words are lowercase')
        words.setdefault(w, STYLES[key])
    else: fail(source, f'unknown setting {key}')
  if not extensions: fail(source, 'no extensions')
  buckets = [[] for _ in range(32)]
  for w, style in sorted(words.items()):
    buckets[ord(w[0]) & 31].append(bytes([len(w), style << 4]) + w.encode('ascii'))
  data = bytearray(b'SYN' + bytes([VERSION, flags] + line + block_open + block_close + quotes + [escape, directive, 0]))
  assert len(data) == HEADER
  offsets = len(data)
  data += bytes(64)
  for i, bucket in enumerate(buckets):
    if not bucket: continue
    body = b''.join(bucket) + b'\0'
    if len(data) // 512 != (len(data) + len(body) - 1) // 512:
      data += bytes(512 - len(data) % 512)  # the next block
    data[offsets + 2 * i:offsets + 2 * i + 2] = len(data).to_bytes(2, 'little')
    data += body
  if len(data) > C['SYNTAX_BLOCKS'] * 512: fail(source, f'{len(data)} bytes, more than SYNTAX_BLOCKS blocks')
  return extensions, bytes(data)

def main():
  out = ROOT / 'bin/SYNTAX'
  out.mkdir(parents=True, exist_ok=True)
  for old in out.glob('*.SYN'): old.unlink()
  for source in sorted((ROOT / 'data/syntax').glob('*.txt')):
    extensions, data = compile_source(source)
    for ext in extensions:
      if len(ext) > C['SYN_KEY_MAX']: fail(source, f'{ext}: keys are at most SYN_KEY_MAX chars')
      (out / f'{ext.upper()}.SYN').write_bytes(data)

if __name__ == '__main__':
  main()
