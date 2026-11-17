#!/usr/bin/env python3
"""Check a reference raster against the source font PNG, independently of C++."""
from pathlib import Path
from PIL import Image
root=Path(__file__).resolve().parents[2]
font=Image.open(root/'img/fonts/fixed_font.png')
image=Image.open('/tmp/gearboy-fatpak-reference.ppm').convert('RGB')
def color(r,g,b):
    return tuple((v<<3)|(v>>2) for v in (r,g,b))
paper=color(29,29,27); highlight=color(20,25,31); ink=color(2,2,3)
# Selected A at row 1, x=8. Selection is half-open [0,4), not tile rounded.
for y in range(8):
    for x in range(256):
        occupied=8<=x<16 and font.getpixel(((65%16)*8+x-8,(65//16)*8+y))<2
        expected=ink if occupied else highlight if 8<=x<12 else paper
        assert image.getpixel((x,8+y))==expected, (x,y,image.getpixel((x,8+y)),expected)
print('Reference raster matches source PNG and pixel selection boundaries')

image=Image.open('/tmp/gearboy-fatpak-or.ppm').convert('RGB')
for y in range(8):
    for x in range(256):
        occupied=any(left<=x<left+8 and font.getpixel(((code%16)*8+x-left,(code//16)*8+y))<2
                     for code,left in ((65,8),(66,9)))
        expected=ink if occupied else highlight if x==9 else paper
        assert image.getpixel((x,y))==expected, ('OR',x,y)
print('Overlapping glyph overhangs match OR of independent source PNG pixels')
