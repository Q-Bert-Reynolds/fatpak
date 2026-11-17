"""UI protocol vectors and an independent source-font image expectation."""
from pathlib import Path
import struct
from PIL import Image
import sgb_protocol as wire
import data_file

LIGHT=[29|29<<5|27<<10,20|25<<5|31<<10,14|17<<5|14<<10,2|2<<5|3<<10,
       4|9<<5|24<<10,19|4<<5|4<<10,15|5<<5|20<<10,21|10<<5]+[0]*8
DARK=[3|3<<5|4<<10,6|10<<5|18<<10,13|15<<5|13<<10,27|27<<5|25<<10,
      13|19<<5|31<<10,31|15<<5|13<<10,25|14<<5|30<<10,31|22<<5|10<<10]+[0]*8

def rgb(c):return tuple(((c>>s)&31)*8+(((c>>s)&31)>>2) for s in (0,5,10))
def command(op,body):return wire.command(op,body)
def box():return command(6,bytes((13,150,0,8,6)))+b''.join(command(7,bytes((i,1,len(s)))+s) for i,s in enumerate((b'',b'FILE',b'OPEN',b'SAVE',b'BACK',b'')))+command(8,b'\x03')

def pages():
    footer=b'READY'+b'\x7f'*10+b'12:34pm  '
    vectors=[b'',box(),command(8,b'\x02'),command(6,bytes(5)),
        command(4,bytes((1,21,3,5)))+command(10,bytes((0,12))),
        command(9,bytes((0,1,13))+b'FATPAK FILES '),
        command(9,bytes((1,1,len(footer)))+footer)+command(12,b'\x01')+command(13,struct.pack('<II',25,100)),
        box(),command(11,bytes((0,16))+struct.pack('<16H',*DARK))]
    return [wire.page(103+i,p) for i,p in enumerate(vectors)]

def golden(root,output):
    source=Image.open(root/'tests/sgb/fixtures/client.png').convert('RGB')
    colors={rgb(c):rgb(DARK[i]) for i,c in enumerate(LIGHT[:8])}
    image=Image.new('RGB',source.size);image.putdata([colors[c] for c in source.getdata()])
    pixels=image.load()
    fonts=[data_file.db_bytes('img/fonts/font_mono.asm'),data_file.db_bytes('img/fonts/font_vwf.asm')]
    def line(text,row,font,left=8,right=256,selected=False):
        for y in range(row*8,row*8+8):
            for x in range(left,right):pixels[x,y]=rgb(DARK[1 if selected else 0])
        x=left
        for code in text:
            for y in range(8):
                bits=fonts[font][code*8+y]
                for bit in range(8):
                    if x+bit<right and bits&(128>>bit):pixels[x+bit,row*8+y]=rgb(DARK[3])
            x+=fonts[1][2048+code] if font else 8
            if x>=right:break
    line(b'FATPAK FILES ',0,1);line(b'READY',27,1)
    clock=b'12:34pm';clock_x=252-sum(fonts[1][2048+c] for c in clock)
    line(clock,27,1,clock_x)
    lower=b'1234567890qwertyuiopasdfghjkl;zxcvbnm,./'
    for row in range(5):
        text=bytearray(b' '*20)
        if row<4:
            for x in range(10):
                if row*10+x<len(lower):text[x*2]=lower[row*10+x]
        else:text=bytes((29,32,35,32,31,32,95,95,95,95,95,95,95,95,15,32,16,32,30,32))
        line(text,22+row,0,4)
        if row==1:
            for y in range((22+row)*8,(23+row)*8):
                for x in range(36,44):
                    if pixels[x,y]==rgb(DARK[0]):pixels[x,y]=rgb(DARK[1])
    for i,text in enumerate((b'',b'FILE',b'OPEN',b'SAVE',b'BACK',b'')):
        line(text,8+i,1,13,163,i==3)
        for y in range((8+i)*8,(9+i)*8):pixels[13,y]=pixels[162,y]=rgb(DARK[3])
    for x in range(13,163):pixels[x,64]=pixels[x,111]=rgb(DARK[3])
    for y in range(4):
        for x in range(248,252):pixels[x,y]=rgb(DARK[3])
    for x in range(64):pixels[x,223]=rgb(DARK[1])
    image.save(output)
