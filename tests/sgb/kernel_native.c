/* Same parser/model source as the cc65 build; MMIO is the only test seam. */
#define __fastcall__
#define SNES_TEST
#define main KernelMain
#include "../../snes/kernel.c"
#undef main
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
u8 test_status[16],test_snapshot[1920];
static u8 fonts[29120];
static u16 screen[256*224];
void Capture(void){}
void Snapshot(u8 slot){(void)slot;}
u8 FontByte(u16 at){assert(at<sizeof(fonts));return fonts[at];}
void ClearRaster(void){memset(raster,0,sizeof(raster));memset(shade,0,sizeof(shade));}
void EncodeRow(void){}
void BlitGlyph(void){}
void PpuInit(void){}
void OverlayInit(void){}
void PresentOverlay(u8 row){(void)row;}
void PresentRow(u8 slot){(void)slot;}
void PresentPalette(void){}
void PresentCursor(void){}
void SetScroll(u16 v){(void)v;}
void PublishMailbox(void){}
void WaitBlank(void){}
static void reseal(u16 n){u16 c;test_snapshot[1]=n;test_snapshot[2]=n>>8;c=crc(test_snapshot,n+3);test_snapshot[n+3]=c;test_snapshot[n+4]=c>>8;}
static void empty_queue(void){qcount=qhead=active_event=0;}
int main(int argc,char **argv){
 FILE *f;unsigned count=0;u16 n;u8 saved[sizeof(rows)],pal[sizeof(palette)];
 assert(argc==2);(void)fonts;(void)screen;
 /* A valid ROW followed by an unknown opcode must reject atomically. */
 memset(test_snapshot,0,1920);test_snapshot[0]=1;
 {const u8 payload[]={1,10,0,0,2,0,0,0,1,1,'A',1,4,255,0,0};
 memcpy(test_snapshot+3,payload,sizeof(payload));reseal(sizeof(payload));}
 memcpy(saved,rows,sizeof(rows));memcpy(pal,palette,sizeof(palette));
 page(0);assert(!good_pages && !memcmp(saved,rows,sizeof(rows)) && !memcmp(pal,palette,sizeof(palette)));
 /* Repair exactly that transaction; CRC errors and sequence gaps cannot ACK. */
 reseal(13);test_snapshot[17]^=1;page(0);assert(!good_pages);test_snapshot[17]^=1;
 test_snapshot[0]=2;reseal(13);page(0);assert(!good_pages);
 test_snapshot[0]=1;reseal(13);page(0);assert(good_pages==1 && rows[0].chars[0]=='A');
 page(0);assert(good_pages==1 && qcount==1);
 /* RLE width/range failures, even with a valid page CRC, preserve the model. */
 test_snapshot[0]=2;test_snapshot[15]=0;reseal(13);page(0);assert(good_pages==1);
 /* Replay the real GB frontend transactions. */
 memset(rows,0,sizeof(rows));memset(bar_lines,0,sizeof(bar_lines));
 last_page[0]=last_page[1]=0;expected=1;good_pages=bad_pages=0;empty_queue();
 f=fopen(argv[1],"rb");assert(f);
 while(fread(test_snapshot,1,1920,f)==1920){
  n=good_pages;page(0);assert(good_pages==n+1);++count;empty_queue();
 }
 fclose(f);assert(count==102 && good_pages==102);
 /* Held event is immutable through bad CRC/status, then advances on echo. */
 enqueue(5,1,5);events();assert(active_event && mailbox[1]==5);
 enqueue(1,'Q',0);memset(test_status,0,16);test_status[0]=83;test_status[1]=1;test_status[4]=mailbox[0];
 events();assert(qcount==2 && mailbox[1]==5);
 n=crc(test_status,14);test_status[14]=n;test_status[15]=n>>8;events();assert(qcount==1 && mailbox[1]==1 && mailbox[2]=='Q');
 /* Boxes, OSK and progress change overlay state without dirtying base rows. */
 {const u8 ui[]={6,5,0,11,120,0,5,4,7,6,0,1,1,3,'O','N','E',8,1,0,1,10,2,0,0,12,12,1,0,1,13,8,0,1,0,0,0,2,0,0,0};
  memset(dirty,0,28);assert(commands(ui,sizeof(ui),0));assert(commands(ui,sizeof(ui),1));
  assert(box_x==11 && box_rows==4 && box_hi==1 && box_lines[1].n==3 && osk_key==12 && busy);
  assert(progress_width()==128);
  for(n=0;n<28;++n)assert(!dirty[n]);
  {const u8 close[]={6,5,0,0,0,0,0,0};assert(commands(close,sizeof(close),1));}
  assert(!box_width);for(n=0;n<28;++n)assert(!dirty[n]);
 }
 printf("PASS: production SNES parser/model: atomic rejection, CRC, sequence, duplicate, %u frontend pages, held mailbox\n",count);
 return 0;
}
