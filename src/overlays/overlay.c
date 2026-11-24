// A single fixed-code overlay. This loader and all its callees live outside
// the replaceable interval. PSRAM writes use the CPU, never DMA.
#include "overlay.h"
#include "../constants.h"
#define WINDOW ((volatile unsigned char*)0xBE00)
#define BLOCK (*(volatile unsigned int*)0xBD02)
#define CONFIG (*(volatile unsigned char*)0xBD06)
#define LCD (*(volatile unsigned char*)0xFF40)
#define IE (*(volatile unsigned char*)0xFFFF)
extern unsigned char RenderOverlayStart[], RenderOverlayEnd[];
extern unsigned int overlay_saved[3];
extern void SetWindowBlock(unsigned int block);
extern unsigned int ModuleSum(const unsigned char* data, unsigned int n, unsigned int sum); // runtime.asm: the modules' Fletcher-16

static unsigned int Word(const unsigned char* p) { return p[0] | ((unsigned int)p[1]<<8); }
static unsigned int Chunk(unsigned int offset, unsigned int n) {
  unsigned int rest=512-offset;
  return n<rest?n:rest;
}
static unsigned int WindowCRC(unsigned int block, unsigned int offset, unsigned int n) {
  unsigned int crc=0xFFFF, count;
  while(n) {
    SetWindowBlock(block++); count=Chunk(offset,n);
    crc=ModuleSum((const unsigned char*)WINDOW+offset,count,crc);
    n-=count; offset=0;
  }
  return crc;
}
// Copies count (> 0) bytes, reading each back: 1 if one didn't stick. DE = to, BC = from, the count on the
// stack (removed, as ModuleSum's)
static unsigned char CopyCheck(unsigned char* to, const unsigned char* from, unsigned int count) __naked {
  to; from; count;
  __asm
    ld hl, sp+2
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push hl
    ld h, b
    ld l, c
    pop bc
.byte:
    ld a, [hl]
    ld [de], a
    ld a, [de]
    cp [hl]
    jr nz, .bad
    inc hl
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .byte
    xor a
    jr .done
.bad:
    ld a, 1
.done:
    pop hl
    add sp, 2
    jp hl
  __endasm;
}
// Copy/compare each chunk, including unaligned headers and a partial tail.
static unsigned char Transfer(unsigned char save, unsigned int block, unsigned int offset,
                              unsigned char* target, unsigned int n) {
  unsigned int count;
  unsigned char* p;
  while(n) {
    SetWindowBlock(block++); count=Chunk(offset,n); n-=count;
    p=(unsigned char*)WINDOW+offset;
    if(save ? CopyCheck(p,target,count) : CopyCheck(target,p,count)) return 1;
    target+=count; offset=0;
  }
  return 0;
}
static unsigned char Header(const unsigned char* h) {
  if(h[0]!='O' || h[1]!='V' || h[2]!='L' || h[3]!='1' || h[4]!=1 || h[5]!=1 ||
     Word(h+6)!=*(const unsigned int*)0x14E) return OVERLAY_INVALID;
  overlay_request.target=Word(h+8); overlay_request.length=Word(h+10);
  overlay_entry=Word(h+12); overlay_request.crc=Word(h+14);
  return OVERLAY_OK;
}
static unsigned char Shape(void) {
  if(!overlay_request.length || overlay_request.target<(unsigned int)RenderOverlayStart ||
     overlay_request.target>=(unsigned int)RenderOverlayEnd ||
     overlay_request.length>(unsigned int)RenderOverlayEnd-overlay_request.target ||
     overlay_entry<overlay_request.target || overlay_entry-overlay_request.target>=overlay_request.length ||
     (overlay_request.offset+overlay_request.length+511)/512>SGB_FILE_BLOCK+SGB_FILE_BLOCKS-overlay_request.source) return OVERLAY_INVALID;
  return OVERLAY_OK;
}
static unsigned char Prepare(void) {
  unsigned char h[16],i;
  unsigned int block=overlay_request.source, offset=overlay_request.offset;
  if(block<SGB_FILE_BLOCK || block>=SGB_FILE_BLOCK+SGB_FILE_BLOCKS || offset>511 ||
     (block==SGB_FILE_BLOCK+SGB_FILE_BLOCKS-1 && offset>496)) return OVERLAY_INVALID;
  for(i=0;i<16;++i) {
    SetWindowBlock(block); h[i]=WINDOW[offset++];
    if(offset==512) { offset=0; ++block; }
  }
  overlay_request.source=block; overlay_request.offset=offset;
  if(Header(h) || Shape()) return OVERLAY_INVALID;
  return WindowCRC(block,offset,overlay_request.length)!=overlay_request.crc;
}
static unsigned char Restore(void) {
  if(WindowCRC(OVERLAY_BACKUP,0,overlay_saved[1])!=overlay_saved[2] ||
     Transfer(0,OVERLAY_BACKUP,0,(unsigned char*)overlay_saved[0],overlay_saved[1]) ||
     ModuleSum((const unsigned char*)overlay_saved[0],overlay_saved[1],0xFFFF)!=overlay_saved[2]) return OVERLAY_FATAL;
  overlay_live=0; return OVERLAY_OK;
}
unsigned char OverlayInstallBody(void) {
  unsigned int window=BLOCK;
  unsigned char config=CONFIG,result;
  if(overlay_live) return OVERLAY_BUSY;
  if(IE || LCD&128) return OVERLAY_BUSY;
  CONFIG=config&~2;
  result=Prepare();
  if(!result) {
    overlay_saved[0]=overlay_request.target; overlay_saved[1]=overlay_request.length;
    overlay_saved[2]=ModuleSum((const unsigned char*)overlay_saved[0],overlay_saved[1],0xFFFF);
    // Transfer reads each byte back, so the backup equals the CRC'd renderer and the installed bytes the CRC'd
    // source (Prepare): no CRC passes over them again
    result=Transfer(1,OVERLAY_BACKUP,0,(unsigned char*)overlay_saved[0],overlay_saved[1]);
    if(!result) {
      overlay_live=1;
      if(Transfer(0,overlay_request.source,overlay_request.offset,(unsigned char*)overlay_saved[0],overlay_saved[1]))
        result=Restore()?OVERLAY_FATAL:OVERLAY_INVALID;
    }
  }
  SetWindowBlock(window); CONFIG=config; return result;
}
unsigned char OverlayRestoreBody(void) {
  unsigned int window=BLOCK;
  unsigned char config=CONFIG,result;
  if(IE || LCD&128) return OVERLAY_BUSY;
  if(!overlay_live) return OVERLAY_OK;
  CONFIG=config&~2; result=Restore();
  SetWindowBlock(window); CONFIG=config; return result;
}
