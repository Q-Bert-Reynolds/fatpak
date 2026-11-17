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
static void CRC(unsigned char a) {
  // CRC-16/CCITT byte update, equivalent to the transport's FsCRC.
  a^=(unsigned char)(crc>>8);
  a^=a>>4;
  crc=(crc<<8)^((unsigned int)a<<12)^((unsigned int)a<<5)^a;
}
static unsigned char Validate(void) {
  unsigned long i,p,f,o,load,entry;
  unsigned int block,count,j;
  if(file.size<32) return 1;
  for(i=0;i<32;++i) header[i]=Read(i);
  p=Long(header+14);f=Long(header+18);o=Long(header+22);
  load=Long(header+8)&0xFFFFFF;entry=Long(header+11)&0xFFFFFF;
  if(header[0]!='S'||header[1]!='G'||header[2]!='B'||header[3]!='1'||header[4]!=1||header[5]!=32||
     header[6]||header[7]||!p||load<0x7F0000||load>=0x800000||(load&4095)||
     p>0x800000-load||f>0x800000-load-p||entry<load||entry>=load+p||o!=0x1D00||
     file.size!=32+p+f+o||header[28]!=REG(0x14E)||header[29]!=REG(0x14F)||header[30]!=1||header[31]!=1) return 1;
  crc=0xFFFF;
  // Walk the window in blocks: no 32-bit address calculation per file byte.
  i=file.size;block=SGB_FILE_BLOCK;
  while(i) {
    count=i>512?512:(unsigned int)i;Block(block);
    for(j=0;j<count;++j)CRC(block==SGB_FILE_BLOCK&&(j==26||j==27)?0:WINDOW[j]);
    i-=count;++block;
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
  unsigned char value;
  for(i=0;i<0x2000;++i) {
    Block(SNAP+(i>>9));value=REG(0x8000+i);
    REG(0x8000+i)=WINDOW[i&511];WINDOW[i&511]=value;
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
  unsigned int i,map,count,source=SGB_FILE_BLOCK,offset=32;
  unsigned char row,column,tile;
  while(n) {
    Off();
    count=n>4096?4096:(unsigned int)n;Block(source);
    for(i=0;i<count;++i) {
      REG(0x8000+i)=WINDOW[offset++];
      if(offset==512){offset=0;Block(++source);}
    }
    for(;i<4096;++i)REG(0x8000+i)=0;
    n-=count;
    for(i=0;i<1024;++i) REG(0x9800+i)=255;
    tile=0;
    for(row=0;row<13;++row)for(column=0;column<20;++column) {
      map=((unsigned int)row<<5)+column;REG(0x9800+map)=tile++;
      if(!tile)goto mapped;
    }
mapped:
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
unsigned char ModuleMain(const unsigned char* context) {
  OverlayRequest* request;
  unsigned long offset;
  unsigned char i,result;
  unsigned char* info=(unsigned char*)ModDriver(0x43);
  context;
  selected_block=0xFFFF;
  if((*info&3)!=1) return 1;
  file.block=SGB_FILE_BLOCK;file.blocks=SGB_FILE_BLOCKS;
  if(ModLoad("/GBCSYS/SGB.DAT",&file)||Validate()) return 1;
  for(i=0;i<16;++i)packet[i]=0;
  // Stop the BIOS mouse bridge before JUMP takes ownership of both ports.
  if(*(unsigned char*)ModDriver(0x40)==4) ModDriver(0x80);
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
  if(result) Restore();
  else {REG(0xFF0F)=0;REG(0xFFFF)=saved[0]&~2;}
  return result;
}
