#!/usr/bin/env python3
"""512x448 character-tile text (SGBFS_CMD_TEXT 1, snes/char.s) on the real SNES kernel, from pages made here
(Mesen, tests/sgb/text.lua). build: the kernel, the pages and the replay ROM paused at checkpoints: 256x224
raster text; then the extension (CODE) and TEXT 1 with bars, styled rows, a selection, right-aligned text and the
cursor; a box, the OSK, busy and progress over them; a scroll of 3 rows; TEXT 0 and the first raster rows again.
check: each 512x448 picture matches a reference drawn here from the same model (a character an 8x8 cell from
the mono font, the classes' paper and ink) pixel for pixel, and TEXT 0 gives back the raster text exactly."""
import sys,struct
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'scripts'));sys.path.insert(0,str(ROOT/'tests/sgb'))
import sgb_protocol as wire
W=ROOT/'build/sgb'
ROWS,COLS=wire.SGBFS_TEXT_ROWS,wire.SGBFS_TEXT_COLS
LIGHT=[29|29<<5|27<<10,20|25<<5|31<<10,14|17<<5|14<<10,2|2<<5|3<<10,4|9<<5|24<<10,19|4<<5|4<<10,15|5<<5|20<<10,21|10<<5]
PAPER,INK=[0,0,0,0,0,0,1,3],[3,2,4,5,6,7,3,0] # a class's palette entries (char.s)
STYLE_CLASS=[0,0,0,0,1,3,2,2,1,2,2,3,4,5,5,0]
SELECTED,INVERSE=6,7
HLINE,VLINE,TOPLEFT,TOPRIGHT,BOTLEFT,BOTRIGHT=range(256,262)
FRAMES=[[0,0,0,0xFF,0,0,0,0],[0x10]*8,[0,0,0,0x1F,0x10,0x10,0x10,0x10],[0,0,0,0xF0,0x10,0x10,0x10,0x10],
        [0x10,0x10,0x10,0x1F,0,0,0,0],[0x10,0x10,0x10,0xF0,0,0,0,0]]
KEYS=[b'1234567890qwertyuiopasdfghjkl;zxcvbnm,./',b'!@#$%^&*()QWERTYUIOPASDFGHJKL:ZXCVBNM<>?',
      b'`~-_=+[]{}\\|\'"\xa1\xbf\xe1\xe9\xed\xf3\xfa\xf1\xfc'.ljust(40,b'\0')]
BOTTOM=bytes([29,32,35,32,31,32]+[95]*8+[15,32,16,32,30,32])

class Model:
    """What the pages built: the kernel's state for the reference"""
    def __init__(s):
        s.text=0;s.top=0;s.count=28;s.palette=list(LIGHT)+[0]*8
        s.rows=[(0,b'',b'',0,0)]*ROWS # flags, chars, attrs, selection start, end (columns)
        s.bars=0;s.bar=[b'',b''];s.box=None;s.lines=[];s.hi=255;s.osk=0;s.layer=0;s.key=255
        s.busy=0;s.progress=(0,0);s.cursor=(0,0,0)

def styled(text,styles):
    """chars and attrs: styles a string of hex digits (a character's style, the last one on), width 4"""
    styles=styles[:len(text)].ljust(len(text),styles[-1])
    return text.encode('latin-1'),bytes((int(c,16)<<4)|4 for c in styles)

def pages_and_models():
    """(pages, {checkpoint: (model or None, text mode)})"""
    pages,commands,out=[],[],{}
    text=[0]
    def flush():
        nonlocal commands
        payload=b''
        for c in commands:
            if len(payload)+len(c)>wire.SGBFS_PAGE_PAYLOAD:
                pages.append(wire.page(len(pages)+1,payload,text[0]));payload=b''
            payload+=c
        if payload:pages.append(wire.page(len(pages)+1,payload,text[0]))
        commands=[]
    def add(op,body):commands.append(wire.command(op,body,text[0]))
    # 256x224 text first: what TEXT 0 must give back
    add(wire.SGBFS_CMD_PALETTE,bytes([0,8])+struct.pack('<8H',*LIGHT))
    add(wire.SGBFS_CMD_LAYOUT,bytes([0,28,0,0]))
    raster=[]
    for y in range(28):
        chars=f'Raster row {y}: the quick brown fox'.encode()
        raster.append(wire.row(y,2,0,0,0,chars,bytes([4]*len(chars))))
    commands+=raster
    add(wire.SGBFS_CMD_CURSOR,bytes([0,0,0]))
    flush();out[len(pages)]=(None,0)
    # the extension, a page a chunk
    ext=(W/'ext.bin').read_bytes()
    for at in range(0,len(ext),wire.SGBFS_CODE_MAX):
        part=ext[at:at+wire.SGBFS_CODE_MAX]
        add(wire.SGBFS_CMD_CODE,bytes([at+len(part)==len(ext)])+struct.pack('<H',at)+part);flush()
    m=Model()
    add(wire.SGBFS_CMD_TEXT,b'\1');text[0]=1
    add(wire.SGBFS_CMD_LAYOUT,bytes([1,54,3,0]));m.bars=3
    m.bar=[b' FILE  EDIT  notes/SGB_HIRES_TEXT.md\x7f12:34',b' Ln 5, Col 11\x7f\x7fUTF-8 ']
    for i,b in enumerate(m.bar):add(wire.SGBFS_CMD_BAR,bytes([i,0,len(b)])+b)
    samples=[
        styled('int main(void) { return printf("%d\\n", 42); } // the answer',
               'AAA0999900AAAA0000999999000BBBBBB00CC000000000008'),
        styled('# A heading: *bold*, _italic_, `code` and plain text to the end of a long row',
               '66666666666660411110004222222400455555400000'),
        styled('label:  ld a, [hl+]  ; a comment','EEEEEE00999A00AAAA00088888888888'),
    ]
    for y in range(1,55):
        if y%9==4:
            chars=f'{y:2} plain {"x"*40}'.encode();attrs=bytes([4]*len(chars));flags=0
        elif y%9==7:
            chars=b'README.md\x7f   12,345 bytes  ';attrs=bytes([4]*len(chars));flags=0 # trailing spaces dropped
        elif y==20:
            chars=bytes(range(32,96));attrs=bytes([4]*64);flags=0 # a full row of 64
        else:
            chars,attrs=samples[y%3];flags=1
            chars,attrs=chars[:COLS],attrs[:COLS]
        start,end=(5,12) if y==6 else (0,255) if y==8 else (60,255) if y==10 else (0,0)
        m.rows[y]=(flags,chars,attrs,start,end)
        add(wire.SGBFS_CMD_ROW,_row(y,flags,start,end,chars,attrs))
    m.cursor=(5,40,1);add(wire.SGBFS_CMD_CURSOR,bytes([5,40,1]))
    flush();out[len(pages)]=(_copy(m),1)
    # a box, the OSK, busy and progress
    add(wire.SGBFS_CMD_LAYOUT,bytes([1,47,3,5]));m.osk=1
    m.box=(64,128,12,6);add(wire.SGBFS_CMD_BOX,struct.pack('<BHBB',*m.box))
    m.lines=[b' Open file ',b'notes/SGB.md',b'notes/SGB_HIRES_TEXT.md',b'README.md\x7fsize',b'TODO.md',b'']
    for i,b in enumerate(m.lines):add(wire.SGBFS_CMD_BOX_LINE,bytes([i,1,len(b)])+b)
    m.hi=2;add(wire.SGBFS_CMD_BOX_HI,b'\2')
    m.layer,m.key=1,23;add(wire.SGBFS_CMD_OSK,bytes([1,23]))
    m.busy=1;add(wire.SGBFS_CMD_BUSY,b'\1')
    m.progress=(3,8);add(wire.SGBFS_CMD_PROGRESS,struct.pack('<II',3,8))
    m.cursor=(30,100,2);add(wire.SGBFS_CMD_CURSOR,bytes([30,100,2]))
    flush();out[len(pages)]=(_copy(m),1)
    # all closed, then a scroll of 3: the rows move up, three new ones at the bottom
    add(wire.SGBFS_CMD_BOX,bytes(5));m.box=None;m.lines=[];m.hi=255
    add(wire.SGBFS_CMD_LAYOUT,bytes([1,54,3,0]));m.osk=0
    add(wire.SGBFS_CMD_BUSY,b'\0');m.busy=0
    add(wire.SGBFS_CMD_PROGRESS,bytes(8));m.progress=(0,0)
    add(wire.SGBFS_CMD_SCROLL,bytes([3,0]))
    m.rows[1:55]=m.rows[4:55]+[(0,b'',b'',0,0)]*3
    for y in (52,53,54):
        chars=f'new row {y} after the scroll'.encode();m.rows[y]=(0,chars,bytes([4]*len(chars)),0,0)
        add(wire.SGBFS_CMD_ROW,_row(y,0,0,0,chars,bytes([4]*len(chars))))
    m.cursor=(2,0,1);add(wire.SGBFS_CMD_CURSOR,bytes([2,0,1]))
    flush();out[len(pages)]=(_copy(m),1)
    # back to the raster: its rows again
    add(wire.SGBFS_CMD_TEXT,b'\0');text[0]=0
    add(wire.SGBFS_CMD_LAYOUT,bytes([0,28,0,0]))
    commands+=raster
    add(wire.SGBFS_CMD_CURSOR,bytes([0,0,0]))
    flush()
    return pages,out

def _row(y,flags,start,end,chars,attrs):
    runs=wire.rle_encode(attrs)
    return bytes([y,2 if flags else 0,flags,start,end,len(chars),len(runs)//2])+chars+runs

def _copy(m):
    c=Model();c.__dict__.update({k:(list(v) if isinstance(v,list) else v) for k,v in m.__dict__.items()});return c

def put(cg,cc,chars,attrs,flags,x,end,cls):
    """char.s's Put: a character a column from x up to end, ALIGN_RIGHT in an unstyled row against end"""
    i,n=0,len(chars)
    while i<n and x<end:
        c=chars[i]
        if not flags and c==127:
            while i+1<n and chars[i+1]==127:i+=1
            k=n
            while k>i+1 and chars[k-1]==32:k-=1
            x=max(x,end-(k-i-1));i+=1;continue
        cg[x]=c;cc[x]=STYLE_CLASS[attrs[i]>>4] if flags else cls
        x+=1;i+=1

def frame_row(cg,left,right,corner):
    cg[left]=corner;cg[right]=corner+1
    for x in range(left+1,right):
        if cg[x]==32:cg[x]=HLINE

def compose(m,r):
    cg,cc=[32]*COLS,[0]*COLS
    bar=m.bar[0] if r==0 and m.bars&1 else m.bar[1] if r==ROWS-1 and m.bars&2 else None
    if bar is not None:
        cc=[SELECTED]*COLS;put(cg,cc,bar,b'',0,0,63,SELECTED)
    else:
        flags,chars,attrs,start,end=m.rows[r];put(cg,cc,chars,attrs,flags,0,63,0)
        if start!=end:
            for x in range(start,COLS if end==255 else end):cc[x]=SELECTED
    if m.osk:
        top=ROWS-(1 if m.bars&2 else 0)-7
        if top<=r<top+7:
            rel=r-top
            for x in range(11,53):cg[x],cc[x]=32,0
            if rel==0:frame_row(cg,11,52,TOPLEFT)
            elif rel==6:frame_row(cg,11,52,BOTLEFT)
            else:
                cg[11]=cg[52]=VLINE;k=rel-1
                if k<4:
                    keys=KEYS[1 if m.layer==3 else m.layer]
                    for i in range(10):
                        if keys[k*10+i]:cg[13+4*i]=keys[k*10+i]
                else:
                    for j in range(20):cg[13+2*j]=BOTTOM[j]
                    if m.layer==3:cg[13]=25
                if m.key!=255 and m.key//10==k:
                    x=13+4*(m.key%10);cc[x]=cc[x+1]=SELECTED
    if m.box:
        bx,bw,top,n=m.box
        if top<=r<top+n:
            rel=r-top;left,right=bx//4,(bx+bw)//4-1
            for x in range(left,right+1):cg[x],cc[x]=32,0
            cg[left]=cg[right]=VLINE
            line=m.lines[rel] if rel<len(m.lines) else b''
            put(cg,cc,line,b'',0,left+1,right,0)
            if rel==0:frame_row(cg,left,right,TOPLEFT)
            if rel==n-1:frame_row(cg,left,right,BOTLEFT)
            if rel==m.hi:
                for x in range(left,right+1):cc[x]=SELECTED
    if r==0 and m.busy:cg[63],cc[63]=32,INVERSE
    if r==ROWS-1 and m.progress[1]:
        loaded,total=m.progress
        width=256 if loaded==total else _progress(loaded,total)
        for x in range(width>>2):cc[x]=INVERSE
    return cg,cc

def _progress(loaded,total):
    result,rem=0,loaded
    for _ in range(8):
        result<<=1
        if rem>=total-rem:rem-=total-rem;result+=1
        else:rem+=rem
    return result

def expected(m):
    """512x448 BGR555: every cell's glyph in its class's ink on its paper, then the cursor (2x8 hi-res pixels)"""
    import data_file
    font=data_file.db_bytes(str(ROOT/'img/fonts/font_mono.asm'))[:2048]
    glyph=lambda g,y:font[g*8+y] if g<256 else FRAMES[g-256][y]
    out=[0]*(512*448)
    for r in range(ROWS):
        cg,cc=compose(m,r)
        for x in range(COLS):
            paper,ink=m.palette[PAPER[cc[x]]],m.palette[INK[cc[x]]]
            for y in range(8):
                bits=glyph(cg[x],y);at=(r*8+y)*512+x*8
                for p in range(8):out[at+p]=ink if bits&(0x80>>p) else paper
    row,x,look=m.cursor
    if look:
        color=m.palette[3] if look==1 else 0x7FFF
        for y in range(8):
            for p in (0,1):out[(row*8+y)*512+2*x+p]=color
    return out

def build():
    import sgb_kernel
    from kernel_build import replay_rom
    sgb_kernel.build()
    pages,out=pages_and_models()
    (W/'text-checkpoints.txt').write_text(''.join(f'{n}\n' for n in out)+f'{len(pages)}\n')
    replay_rom(pages,checkpoints=tuple(out))
    print(f'{len(pages)} pages, checkpoints after {", ".join(map(str,out))}')

def ppm(path):
    data=Path(path).read_bytes()
    w,h=(512,448) if data.startswith(b'P6\n512 448\n255\n') else (256,224)
    data=data[len(f'P6\n{w} {h}\n255\n'):]
    return w,[(data[i]>>3)|(data[i+1]>>3)<<5|(data[i+2]>>3)<<10 for i in range(0,len(data),3)]

def check(work):
    pages,out=pages_and_models()
    raster=None
    for n,(m,mode) in out.items():
        w,got=ppm(Path(work)/f'text-{n}.ppm')
        if not mode:
            assert w==256, f'{n}: raster text at {w} pixels';raster=got;continue
        assert w==512, f'{n}: character mode at {w} pixels'
        want=expected(m)
        bad=[(i%512,i//512) for i in range(512*448) if got[i]!=want[i]]
        if bad:
            rows=sorted({y//8 for x,y in bad})
            raise AssertionError(f'{n}: {len(bad)} pixels differ, first at {bad[0]}, rows {rows[:12]}: '
                                 f'got {got[bad[0][1]*512+bad[0][0]]:04x} want {want[bad[0][1]*512+bad[0][0]]:04x}')
        print(f'PASS: after page {n}: all 512x448 pixels match the reference')
    w,end=ppm(Path(work)/'text-end.ppm')
    assert w==256 and end==raster, f'TEXT 0 changed {sum(a!=b for a,b in zip(end,raster))} raster pixels'
    print('PASS: TEXT 0 gives back the raster text, every pixel as it was')

def apply(m,op,b):
    """a page's command on the model (the kernel's), for a recorded session"""
    R=ROWS if m.text else 28
    if op==wire.SGBFS_CMD_TEXT:
        if b[0]!=m.text:
            pal,bars,bar=m.palette,m.bars,m.bar
            m.__init__();m.text=b[0];m.palette,m.bars,m.bar=pal,bars,bar;m.top,m.count=0,ROWS if b[0] else 28
    elif op==wire.SGBFS_CMD_ROW:
        n=b[5];chars=b[7:7+n];attrs=wire.rle_decode(b[7+n:],n)
        m.rows[b[0]]=(b[2],chars,attrs,b[3],b[4])
    elif op==wire.SGBFS_CMD_ROW_SAME:m.rows[b[0]]=m.rows[b[1]]
    elif op==wire.SGBFS_CMD_SCROLL:
        d=struct.unpack('b',b[:1])[0];view=m.rows[m.top:m.top+m.count]
        view=(view[d:]+[(0,b'',b'',0,0)]*d) if d>0 else ([(0,b'',b'',0,0)]*-d+view[:d])
        m.rows[m.top:m.top+m.count]=view
    elif op==wire.SGBFS_CMD_LAYOUT:m.top,m.count,m.bars,m.osk=b[0],b[1],b[2],bool(b[3])
    elif op==wire.SGBFS_CMD_CURSOR:m.cursor=(b[0],b[1],b[2])
    elif op==wire.SGBFS_CMD_BOX:
        x,w,top,n=struct.unpack('<BHBB',b);m.box=(x,w,top,n) if w else None;m.lines=[b'']*n;m.hi=255
    elif op==wire.SGBFS_CMD_BOX_LINE:m.lines[b[0]]=b[3:]
    elif op==wire.SGBFS_CMD_BOX_HI:m.hi=b[0]
    elif op==wire.SGBFS_CMD_BAR:m.bar[b[0]]=b[3:]
    elif op==wire.SGBFS_CMD_OSK:m.layer,m.key=b[0],b[1]
    elif op==wire.SGBFS_CMD_BUSY:m.busy=b[0]
    elif op==wire.SGBFS_CMD_PROGRESS:m.progress=struct.unpack('<II',b)
    elif op==wire.SGBFS_CMD_PALETTE:
        for i in range(b[1]):m.palette[b[0]+i]=struct.unpack_from('<H',b,2+2*i)[0]
    elif op in (wire.SGBFS_CMD_HELLO,wire.SGBFS_CMD_RESET):m.__init__()

def session_pages():
    """The recorded pages and the model before each TEXT 0 sent from character mode: a map opening, and
    RESOLUTION > 256x224 at the end (the browser in 512x448 text, before the map and after it)"""
    from kernel_build import recording
    pages=recording(W/'text.fph');m=Model();out={}
    for i,p in enumerate(pages):
        commands=wire.decode_page(p,m.text)[1]
        if m.text and any(op==wire.SGBFS_CMD_TEXT and not b[0] for op,b in commands):out[i]=_copy(m)
        for op,b in commands:apply(m,op,b)
    assert len(out)==2, f'TEXT 0 from character mode {len(out)} times, not 2'
    return pages,out

def session_build():
    import sgb_kernel
    from kernel_build import replay_rom
    sgb_kernel.build()
    pages,out=session_pages()
    replay_rom(pages,checkpoints=tuple(out))
    print(f'{len(pages)} recorded pages, checkpoints after {", ".join(map(str,out))}')

def exit_build():
    """The synthetic session (the extension loaded, 512x448 text) and then EXIT: back to the BIOS (bios.s)"""
    import sgb_kernel
    from kernel_build import replay_rom
    sgb_kernel.build()
    pages,out=pages_and_models()
    pages.append(wire.page(len(pages)+1,wire.command(wire.SGBFS_CMD_EXIT,b'',1),1))
    replay_rom(pages,exit=True)
    print(f'{len(pages)} pages, the last EXIT')

def session_check(work):
    pages,out=session_pages()
    for n,m in out.items():
        w,got=ppm(Path(work)/f'text-{n}.ppm')
        assert w==512, f'{n}: not character mode ({w} pixels)'
        want=expected(m)
        bad=[(i%512,i//512) for i in range(512*448) if got[i]!=want[i]]
        if bad:
            rows=sorted({y//8 for x,y in bad})
            raise AssertionError(f'{n}: {len(bad)} pixels differ, first at {bad[0]}, rows {rows[:12]}')
        print(f'PASS: the recorded session after page {n}: all 512x448 pixels match the reference')

if __name__=='__main__':
    a=sys.argv[1:]
    if a==['build']:build()
    elif a==['session-build']:session_build()
    elif a==['exit-build']:exit_build()
    elif a[0]=='session-check':session_check(a[1])
    else:check(a[1])
