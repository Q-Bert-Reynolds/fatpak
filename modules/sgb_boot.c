// Optional fullscreen bootstrap. It runs transiently in the normal module page;
// the persistent terminal replaces only the audited renderer interval.
#include "../build/modules/sdk.h"
#include "../src/overlays/overlay.h"
#define REG(a) (*(volatile unsigned char*)(a))
#define WINDOW ((volatile unsigned char*)0xBE00)
#define SNAP 0x3C00
static ModuleLoad file;
static unsigned char header[32],packet[16];
static unsigned char saved[6];
static unsigned int crc;
static unsigned int selected_block;
static void Block(unsigned int block) {
  if(block==selected_block)return;
  REG(0xBD03)=block>>8;REG(0xBD02)=block;selected_block=block;
}
static unsigned char Read(unsigned long pos) {
  unsigned int b=SGB_FILE_BLOCK+(unsigned int)(pos>>9);
  Block(b);
  return WINDOW[(unsigned int)pos&511];
}
static unsigned long Long(const unsigned char* p) {
  return p[0]|((unsigned long)p[1]<<8)|((unsigned long)p[2]<<16)|((unsigned long)p[3]<<24);
}
// CRC-16/CCITT ($1021, as the OS's ModuleCRC) through a table: crc = crc << 8 ^ T[crc >> 8 ^ byte], T's high
// bytes in one page and its low bytes in the next (about 60 cycles a byte rather than ModuleCRC's 200: the
// package is 60 KiB)
static unsigned char crc_space[768];
static unsigned char crc_page,crc_groups;
static void CRCTables(void) {
  unsigned int i,v;
  unsigned char k;
  unsigned char* t;
  crc_page=((unsigned int)crc_space+255)>>8;
  t=(unsigned char*)((unsigned int)crc_page<<8);
  for(i=0;i<256;++i) {
    v=i<<8;
    for(k=0;k<8;++k) v=v&0x8000?(v<<1)^0x1021:v<<1;
    t[i]=v>>8;t[256+i]=v;
  }
}
// Each native loop stays within the selected 512-byte cartridge window.
// These use SDCC's SM83 register ABI: first pointer in DE, second word in BC (here at most 1023: groups of 4
// bytes counted in a byte, then the rest).
static void CRCBlock(const unsigned char* from, unsigned int count) __naked {
  from; count;
  __asm
    ld a, c
    and 3
    push af
    srl b
    rr c
    srl b
    rr c
    ld a, c
    ld [_crc_groups], a
    ld a, [_crc]
    ld c, a
    ld a, [_crc+1]
    ld b, a
    ld a, [_crc_page]
    ld h, a
    ld a, [_crc_groups]
    and a
    jr z, .rest
.group:
    ld a, [de]
    inc de
    xor b
    ld l, a
    ld a, [hl]
    xor c
    ld b, a
    inc h
    ld c, [hl]
    dec h
    ld a, [de]
    inc de
    xor b
    ld l, a
    ld a, [hl]
    xor c
    ld b, a
    inc h
    ld c, [hl]
    dec h
    ld a, [de]
    inc de
    xor b
    ld l, a
    ld a, [hl]
    xor c
    ld b, a
    inc h
    ld c, [hl]
    dec h
    ld a, [de]
    inc de
    xor b
    ld l, a
    ld a, [hl]
    xor c
    ld b, a
    inc h
    ld c, [hl]
    dec h
    ld a, [_crc_groups]
    dec a
    ld [_crc_groups], a
    jr nz, .group
.rest:
    pop af
    and a
    jr z, .done
.byte:
    push af
    ld a, [de]
    inc de
    xor b
    ld l, a
    ld a, [hl]
    xor c
    ld b, a
    inc h
    ld c, [hl]
    dec h
    pop af
    dec a
    jr nz, .byte
.done:
    ld a, c
    ld [_crc], a
    ld a, b
    ld [_crc+1], a
    ret
  __endasm;
}

static unsigned int copy_count;
static void CopyVideo(unsigned char* to, const unsigned char* from) __naked {
  to; from;
  __asm
    ld h, b
    ld l, c
    ld a, [_copy_count]
    ld c, a
    ld a, [_copy_count+1]
    ld b, a
    or c
    ret z
.byte:
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .byte
    ret
  __endasm;
}

// Exchange a whole window with VRAM while the LCD is off, for rollback.
static void SwapWindow(unsigned char* video) __naked {
  video;
  __asm
    ld hl, $BE00
    ld b, 2
.byte:
    ld a, [de]
    ld c, a
    ld a, [hl]
    ld [de], a
    ld [hl], c
    inc hl
    inc de
    ld a, l
    or a
    jr nz, .byte
    dec b
    jr nz, .byte
    ret
  __endasm;
}

static unsigned char Validate(void) {
  unsigned long i,p,f,o,e,load,entry;
  unsigned int block,count,offset;
  static const unsigned char zero_crc[2]={0,0};
  if(file.size<32) return 1;
  for(i=0;i<32;++i) header[i]=Read(i);
  p=Long(header+14);f=Long(header+18);o=Long(header+22);e=header[6]|((unsigned int)header[7]<<8); // the extension, last
  load=Long(header+8)&0xFFFFFF;entry=Long(header+11)&0xFFFFFF;
  if(header[0]!='S'||header[1]!='G'||header[2]!='B'||header[3]!='1'||header[4]!=1||header[5]!=32||
     e>0x2400||(e&&!o)||!p||load<0x7F0000||load>=0x800000||(load&4095)||
     p>0x800000-load||f>0x800000-load-p||entry<load||entry>=load+p||o!=0x1D00||
     file.size!=32+p+f+o+e||header[28]!=REG(0x14E)||header[29]!=REG(0x14F)||header[30]!=1||header[31]!=1) return 1;
  CRCTables();crc=0xFFFF;
  // The stored CRC field contributes two zero bytes, without changing PSRAM.
  CRCBlock(header,26);CRCBlock(zero_crc,2);
  i=file.size-28;block=SGB_FILE_BLOCK;offset=28;
  while(i) {
    count=512-offset;if(i<count)count=(unsigned int)i;
    Block(block);CRCBlock((const unsigned char*)WINDOW+offset,count);
    i-=count;++block;offset=0;
  }
  return crc!=(header[26]|((unsigned int)header[27]<<8));
}
static void Send(unsigned char code) {
  unsigned char i;
  Block(SGB_FILE_BLOCK+SGB_FILE_BLOCKS-1);
  packet[0]=(code<<3)|1;
  for(i=0;i<16;++i)WINDOW[i]=packet[i];
  ModDriver(0x42);
}
static void SwapVideo(void) {
  unsigned int i;
  for(i=0;i<0x2000;i+=512) {
    Block(SNAP+(i>>9));SwapWindow((unsigned char*)(0x8000+i));
  }
}
static void Off(void) {
  if(REG(0xFF40)&128)while(REG(0xFF44)<144);
  REG(0xFF40)=0;
}
static void Save(void) {
  saved[0]=REG(0xFFFF);REG(0xFFFF)=0;
  saved[1]=REG(0xFF40);saved[2]=REG(0xFF42);saved[3]=REG(0xFF43);
  saved[4]=REG(0xFF47);saved[5]=REG(0xBD06);REG(0xBD06)&=~2;
  packet[1]=1;Send(0x17);packet[1]=0;
  Off();SwapVideo();
}
static void Restore(void) {
  Off();SwapVideo();REG(0xFF42)=saved[2];REG(0xFF43)=saved[3];REG(0xFF47)=saved[4];REG(0xFF40)=saved[1];
  packet[1]=0;Send(0x17);REG(0xBD06)=saved[5];REG(0xFF0F)=0;REG(0xFFFF)=saved[0];
}
static void Upload(void) {
  unsigned long n=Long(header+14)+Long(header+18),load=Long(header+8)&0xFFFFFF;
  unsigned int i,map,count,run,source=SGB_FILE_BLOCK,offset=32;
  unsigned char row,column,tile;
  // DATA_TRN reads this same tile map each time; only its tile data changes.
  Off();
  for(i=0;i<1024;++i) REG(0x9800+i)=255;
  tile=0;
  for(row=0;row<13;++row)for(column=0;column<20;++column) {
    map=((unsigned int)row<<5)+column;REG(0x9800+map)=tile++;
    if(!tile)goto mapped;
  }
mapped:
  while(n) {
    Off();
    count=n>4096?4096:(unsigned int)n;
    for(i=0;i<count;i+=run) {
      run=512-offset;if(run>count-i)run=count-i;
      Block(source);copy_count=run;
      CopyVideo((unsigned char*)(0x8000+i),(const unsigned char*)WINDOW+offset);
      offset+=run;if(offset==512){offset=0;++source;}
    }
    for(;i<4096;++i)REG(0x8000+i)=0;
    n-=count;
    REG(0xFF42)=REG(0xFF43)=0;REG(0xFF47)=0xE4;REG(0xFF40)=0x91;
    packet[1]=load;packet[2]=load>>8;packet[3]=load>>16;Send(0x10);load+=4096;
  }
  load=Long(header+11)&0xFFFFFF;
  for(i=0;i<16;++i)packet[i]=0;
  packet[1]=load;packet[2]=load>>8;packet[3]=load>>16;
  // Native vectors point into the SNES image's stable boot/NMI/IRQ jump directory.
  load=(Long(header+8)&0xFFFFFF)+4;packet[4]=load;packet[5]=load>>8;packet[6]=load>>16;
  load+=4;packet[7]=load;packet[8]=load>>8;packet[9]=load>>16;Send(0x12);
}
// One player on the ICD2: the joypad's ID doesn't change from one read to the next (the kernel's mailbox
// cycles four, the BIOS has one, as sgb_Check finds an SGB)
static unsigned char OnePlayer(void) {
  unsigned char a,b;
  REG(0xFF00)=0x30;a=REG(0xFF00);a=REG(0xFF00);a=REG(0xFF00);a=REG(0xFF00);
  REG(0xFF00)=0x20;REG(0xFF00)=0x10;REG(0xFF00)=0x30;
  b=REG(0xFF00);b=REG(0xFF00);b=REG(0xFF00);b=REG(0xFF00);
  return !((a^b)&15);
}
// The exit (src/sgb/client.c's SGBExit, once the kernel ACKed EXIT): the SNES restores the BIOS (snes/bios.s,
// about 2 seconds) and returns to it; the GB's renderer comes back here, the OS lays the GB screen out again.
// Returns 1 if the BIOS never showed (it carries on: the kernel has gone either way)
static unsigned char Exit(void) {
  unsigned int n;
  unsigned char i,lost;
  unsigned char* info=(unsigned char*)ModDriver(0x43);
  REG(0xFFFF)=0; // (RunModule gives the interrupts back) nothing else reads P1 meanwhile
  for(n=0;n<600&&!OnePlayer();++n) {
    while(REG(0xFF44)==144);
    while(REG(0xFF44)!=144);
  }
  lost=n==600;
  Off();
  if(ModOverlay(2)) for(;;);
  *info&=~4;
  REG(0xFF0F)=0;
  for(i=0;i<16;++i)packet[i]=0;
  Send(0x17); // MASK_EN 0: the BIOS shows the GB's screen again (SGBBOOT froze it before JUMP)
  return lost;
}
unsigned char ModuleMain(const unsigned char* context) {
  OverlayRequest* request;
  unsigned long offset;
  unsigned char i,result,mouse;
  unsigned char* info=(unsigned char*)ModDriver(0x43);
  selected_block=0xFFFF;
  if(context) return Exit();
  if((*info&3)!=1) return 1;
  file.block=SGB_FILE_BLOCK;file.blocks=SGB_FILE_BLOCKS;
  if(ModLoad("/GBCSYS/SGB.DAT",&file)||Validate()) return 1;
  for(i=0;i<16;++i)packet[i]=0;
  // Stop the BIOS mouse bridge before JUMP takes ownership of both ports (its stop jump through the $0800 hook,
  // then a command to run it: KBDriverStop's packets). The SNES mouse driver stays: in fullscreen it reads the
  // kernel's mouse events (fs_mouse) instead
  mouse=*(unsigned char*)ModDriver(0x40)==4;
  if(mouse) {
    packet[1]=0;packet[2]=8;packet[3]=0;packet[4]=3;packet[5]=0x4C;packet[6]=0x03;packet[7]=0x18;Send(0x0F);
    for(i=1;i<8;++i)packet[i]=0;
    packet[1]=1;Send(0x19);packet[1]=0;
  }
  Save();
  request=(OverlayRequest*)ModOverlay(0);
  offset=32+Long(header+14)+Long(header+18);
  request->source=SGB_FILE_BLOCK+(unsigned int)(offset>>9);request->offset=(unsigned int)offset&511;
  result=(unsigned char)ModOverlay(1);
  if(!result) {
    Upload();
    result=(unsigned char)ModOverlay(5);
    if(result) { Off(); *info&=~4; if(ModOverlay(2)) for(;;); }
  }
  if(result) {
    Restore();
    if(mouse) ModDriver(0x80); // (its bridge stopped: as before fullscreen existed, choose it again)
  }
  else {REG(0xFF0F)=0;REG(0xFFFF)=saved[0]&~2;}
  return result;
}
