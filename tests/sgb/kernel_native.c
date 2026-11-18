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
static u8 fonts[27584];
static u16 screen[256*224];
static unsigned snapshots,encodes;
static int snapshot_seq=-1;
void Capture(void){}
void Snapshot(u8 slot){(void)slot;++snapshots;if(snapshot_seq>=0)test_snapshot[0]=snapshot_seq;}
u8 FontWidth(u16 at){unsigned font=at>>8;assert(font<7);return font==1?fonts[FONT_WIDTHS+(at&255)]:font==0?8:font==2?4:11-font;}
void ClearRaster(void){memset(raster,0,sizeof(raster));memset(shade,0,sizeof(shade));}
void EncodeRow(void){++encodes;}
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
u16 Clock(void){return hw_frames;}
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
 n=snapshots;page(0);assert(good_pages==1 && qcount==1 && snapshots==n);
 test_snapshot[0]=0;page(1);assert(snapshots==n);
 test_snapshot[0]=3;page(0);assert(snapshots==n);
 /* An in-progress capture may change after the peek; copied sequence wins. */
 test_snapshot[0]=2;snapshot_seq=3;page(0);snapshot_seq=-1;
 assert(snapshots==n+1u && good_pages==1 && expected==2);
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
 /* Empty overlays erase old tiles without the per-pixel encoder. Indicators
    still encode when their row has no bar or other UI paper behind them. */
 bars=osk_rows=busy=debug_enabled=0;box_width=total=0;
 n=encodes;memset(raster,255,sizeof(raster));draw_ui(10);assert(encodes==n);
 {unsigned i;for(i=0;i<sizeof(raster);++i)assert(!raster[i]);}
 busy=1;draw_ui(0);assert(encodes==n+1u);busy=0;
 total=5;loaded=1;draw_ui(27);assert(encodes==n+2u);total=loaded=0;
 /* Bars cover the whole row with the same highlight as GB/GBC, including X=0. */
 bars=3;draw_ui(0);assert(pixel_start==0 && pixel_end==256 && ui_left==0 && ui_right==256);
 draw_ui(27);assert(pixel_start==0 && pixel_end==256);bars=0;
 /* Held event is immutable through bad CRC/status, then advances on echo. */
 enqueue(5,1,5);events();assert(active_event && mailbox[1]==5);
 enqueue(1,'Q',0);memset(test_status,0,16);test_status[0]=83;test_status[1]=1;test_status[4]=mailbox[0];
 events();assert(qcount==2 && mailbox[1]==5);
 n=crc(test_status,14);test_status[14]=n;test_status[15]=n>>8;events();assert(qcount==1 && mailbox[1]==1 && mailbox[2]=='Q');
 assert(status_valid && status_echo==test_status[4]);
 test_status[2]^=1;events();assert(!status_valid && qcount==1);
 /* Mouse buttons on port 2 must never become Enter/X gamepad commands. */
 empty_queue();pad_held[0]=pad_edges[0]=0;
 pad_held[1]=pad_edges[1]=0x00C1;pads();assert(!qcount && !pad_edges[1]);
 pad_held[0]=pad_edges[0]=0x0800;pads();
 assert(qcount==1 && queue[qhead][0]==SGBFS_EVENT_PAD && queue[qhead][1]==64 && queue[qhead][2]==64);
 pad_held[0]=0;pads();assert(qcount==2 && queue[(qhead+1)&63][1]==0);
 empty_queue();sent_pad=0;
 {static const u16 snes[]={0x80,0x8000,0x2000,0x1000,0x100,0x200,0x800,0x400};
  unsigned j;for(j=0;j<8;++j){pad_held[0]=snes[j];pads();assert(queue[qhead][1]==(1u<<j));empty_queue();sent_pad=0;}}
 pad_held[0]=0;sent_pad=0;
 pad_edges[0]=0x80;pads();assert(qcount==2 && queue[qhead][1]==1 && queue[(qhead+1)&63][1]==0);
 empty_queue();pad_held[0]=pad_edges[0]=0x4070;pads();assert(!qcount);pad_held[0]=0;
 /* Boxes, OSK and progress change overlay state without dirtying base rows. */
 {const u8 ui[]={6,5,0,11,120,0,5,4,7,6,0,1,1,3,'O','N','E',8,1,0,1,10,2,0,0,12,12,1,0,1,13,8,0,1,0,0,0,2,0,0,0};
  memset(dirty,0,28);assert(commands(ui,sizeof(ui),0));assert(commands(ui,sizeof(ui),1));
  assert(box_x==11 && box_rows==4 && box_hi==1 && box_lines[1].n==3 && osk_key==12 && busy);
  assert(progress_width()==128);
  for(n=0;n<28;++n)assert(!dirty[n]);
  {const u8 close[]={6,5,0,0,0,0,0,0};assert(commands(close,sizeof(close),1));}
  assert(!box_width);for(n=0;n<28;++n)assert(!dirty[n]);
 }
 /* Forced GB redraws must not rasterize identical rows again. */
 {u8 row[]={1,13,0,0,2,0,0,0,4,1,'T','E','S','T',4,4};
  assert(commands(row,sizeof(row),0));assert(commands(row,sizeof(row),1));
  dirty[0]=0;assert(commands(row,sizeof(row),1));assert(!dirty[0]);
  row[10]='B';assert(commands(row,sizeof(row),1));assert(dirty[0]);
  dirty[0]=0;row[15]=0x14;assert(commands(row,sizeof(row),1));assert(dirty[0]);
 }
 /* The local diagnostic shortcut changes the top layer, preserving base rows. */
 memset(dirty,0,28);memset(overlay_dirty,0,28);debug_enabled=0;
 pad_held[0]=0x2030;pad_edges[0]=0x2000;pads();
 assert(debug_enabled && overlay_dirty[26] && overlay_dirty[27] && !dirty[27]);
 overlay_dirty[27]=0;pad_edges[0]=0x2000;pads();
 assert(!debug_enabled && overlay_dirty[27] && !dirty[27]);
 printf("PASS: production SNES parser/model: atomic rejection, CRC, sequence, duplicate, %u frontend pages, held mailbox, diagnostic toggle\n",count);
 return 0;
}
