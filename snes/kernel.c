/* Production 65816 terminal. cc65 supplies the C ABI, hardware.s owns the PPU
 * and ICD2. Validation is a separate pass: a bad trailing TLV changes nothing. */
#include "kernel.h"
#include "../src/sgb/protocol.h"
#include <string.h>

volatile u8 capture_ready, capture_last;
volatile u16 capture_rows,capture_missed,tick,pad_held[2],pad_edges[2];
u8 raster[1024],shade[2048],mailbox[4];
u16 palette[16]={0x6FBD,0x7F34,0x3A2E,0x0C42,0x6124,0x1093,0x50AF,0x0155};
u8 cursor_row,cursor_x,cursor_look;
typedef struct { u8 font,flags,start,end,n; u8 chars[64],attrs[64]; } Row;
Row rows[28];
u8 dirty[28],top,text_rows=28,bars,osk_rows,ring_offset;
u8 last_page[2],expected=1;
u16 good_pages,bad_pages,drawn_rows;
u8 queue[64][3],qhead,qcount,event_seq=1,active_event;
u8 palette_dirty,cursor_dirty,scan_row;
u8 scroll_target,scroll_current=255,scroll_smooth,scroll_pending;
u8 debug_enabled,debug_dirty;
u16 debug_frame;
u8 box_rows,box_top,box_x,box_hi=255;
u16 box_width;
/* Overlay storage is independent of the base rows, even when closed. */
Row box_lines[28],bar_lines[2];
u8 overlay_dirty[28],osk_layer,osk_key=255,busy;
u32 loaded,total;

static u16 word(const u8 *p) { return p[0]|((u16)p[1]<<8); }
static u32 dword(const u8 *p) { return word(p)|((u32)word(p+2)<<16); }
static u16 crc(const u8 *p,u16 n) {
 u16 c=65535u; u8 j;
 while(n--) { c^=(u16)*p++<<8; for(j=0;j<8;++j)c=(c&0x8000)?(c<<1)^0x1021:c<<1; Capture(); }
 return c;
}
static u8 next(u8 s) { return s==255?1:s+1; }
static void enqueue(u8 type,u8 a,u8 b) {
 u8 at,i,place;
 if(qcount>=64)return;
 /* Keep the held event immutable; control replies go ahead of queued keys. */
 place=(type==1)?qcount:active_event;
 for(i=qcount;i>place;--i){
  memcpy(queue+((qhead+i)&63),queue+((qhead+i-1)&63),3);Capture();
 }
 at=(qhead+place)&63;queue[at][0]=type;queue[at][1]=a;queue[at][2]=b;++qcount;
}
static void events(void) {
 u8 status[16],i;
 for(i=0;i<16;++i)status[i]=STATUS[i];
 if(active_event && status[0]==83 && status[1]==1 && !(status[5]&254) &&
    !status[8]&&!status[9]&&!status[10]&&!status[11]&&!status[12]&&!status[13] &&
    crc(status,14)==word(status+14) && status[4]==mailbox[0]) {
  active_event=0;qhead=(qhead+1)&63;--qcount;
  event_seq=event_seq==127?1:event_seq+1;
 }
 if(!active_event && qcount) {
  mailbox[0]=event_seq;memcpy(mailbox+1,queue[qhead],3);PublishMailbox();active_event=1;
 }
}
/* Shadow only the state needed by validators, never the 8 KiB model. */
static u8 commands(const u8 *p,u16 n,u8 apply) {
 u16 at=0,len,w,i,k,width; const u8 *b; u8 op,r,shadow_rows=text_rows,shadow_box=box_rows;
 signed char delta;
 Row *out;
 while(at<n) {
  Capture();if(n-at<3)return 0;
  op=p[at];len=word(p+at+1);at+=3;if(len>n-at)return 0;b=p+at;at+=len;
  switch(op) {
  case 1:
   if(len<7 || b[0]>=28 || b[1]>6 || b[2]>1 || b[3]>248 ||
      (b[4]!=255 && (b[4]<b[3] || b[4]>248)) || b[5]>64 || len!=7u+b[5]+2u*b[6])return 0;
   k=width=0;
   for(i=7u+b[5];i<len;i+=2) {
    if(!b[i] || !(b[i+1]&15) || (b[i+1]>>4)>14 || k+b[i]>b[5])return 0;
    width+=(u16)b[i]*(b[i+1]&15);k+=b[i];Capture();
   }
   if(k!=b[5] || width>248)return 0;
   if(apply) {
    out=rows+b[0];out->font=b[1];out->flags=b[2];out->start=b[3];out->end=b[4];out->n=b[5];
    memcpy(out->chars,b+7,b[5]);k=0;
    for(i=7u+b[5];i<len;i+=2){memset(out->attrs+k,b[i+1],b[i]);k+=b[i];Capture();}
    dirty[b[0]]=1;
   } break;
  case 2:
   if(len!=2 || b[0]>=28 || b[1]>=28)return 0;
   if(apply){rows[b[0]]=rows[b[1]];dirty[b[0]]=1;}break;
  case 3:
   if(len!=2)return 0;
   delta=(signed char)b[0];r=delta<0?-delta:delta;
   if(!r || r>27 || r>shadow_rows || b[1]>1)return 0;
   if(apply) {
    /* Rotate physical slots; preserve top/bottom bars by redrawing only them. */
    ring_offset=(ring_offset+delta)&31;
    if(delta>0)for(i=0;i<text_rows;++i){
     if(i+r<text_rows){rows[top+i]=rows[top+i+r];dirty[top+i]=dirty[top+i+r];}
     else {memset(rows+top+i,0,sizeof(Row));dirty[top+i]=1;}Capture();
    } else for(i=text_rows;i>0;--i){
     if(i>r){rows[top+i-1]=rows[top+i-1-r];dirty[top+i-1]=dirty[top+i-1-r];}
     else{memset(rows+top+i-1,0,sizeof(Row));dirty[top+i-1]=1;}Capture();
    }
    if(top)dirty[0]=1;
    if(top+text_rows<28)dirty[27]=1;
    scroll_target=ring_offset*8-1;scroll_smooth=b[1];scroll_pending=1;
   }break;
  case 4:
   if(len!=4 || b[0]>=28 || !b[1] || b[1]>28 || b[2]>3 || (b[3] && b[3]!=5) ||
      (u16)b[0]+b[1]+b[3]+!!(b[2]&2)>28)return 0;
   shadow_rows=b[1];if(apply){top=b[0];text_rows=b[1];bars=b[2];osk_rows=b[3];dirty[0]=dirty[27]=1;}break;
  case 5:
   if(len!=3 || b[0]>=28 || b[2]>2)return 0;
   if(apply){cursor_row=b[0];cursor_x=b[1];cursor_look=b[2];cursor_dirty=1;}break;
  case 6:
   if(len!=5)return 0;
   w=word(b+1);
   if(!w){if(b[0]||b[1]||b[2]||b[3]||b[4])return 0;}
   else if(w<8 || b[0]+w>256 || !b[4] || (u16)b[3]+b[4]>28)return 0;
   shadow_box=b[4];if(apply){box_x=b[0];box_width=w;box_top=b[3];box_rows=b[4];box_hi=255;
    memset(box_lines,0,sizeof(box_lines));memset(overlay_dirty,1,28);}break;
  case 7:case 9:
   if(len<3 || b[1]>6 || b[2]>64 || len!=3u+b[2] || b[0]>=(op==7?shadow_box:2))return 0;
   if(apply){out=op==7?box_lines+b[0]:bar_lines+b[0];memset(out,0,sizeof(Row));
    out->font=b[1];out->n=b[2];memcpy(out->chars,b+3,b[2]);memset(overlay_dirty,1,28);}break;
  case 8:
   if(len!=1 || (b[0]!=255 && b[0]>=shadow_box))return 0;
   if(apply){box_hi=b[0];memset(overlay_dirty,1,28);}break;
  case 10:
   if(len!=2 || b[0]>3 || (b[1]>=50 && b[1]!=255))return 0;
   if(apply){osk_layer=b[0];osk_key=b[1];memset(overlay_dirty,1,28);}break;
  case 11:
   if(len<4 || !b[1] || b[1]>16 || b[0]+b[1]>16 || len!=2u+2u*b[1])return 0;
   for(i=0;i<b[1];++i)if(b[3+i*2]&128)return 0;
   if(apply){for(i=0;i<b[1];++i)palette[b[0]+i]=word(b+2+i*2);palette_dirty=1;}break;
  case 12:
   if(len!=1 || b[0]>1)return 0;
   if(apply)busy=b[0];
   break;
  case 13:
   if(len!=8 || dword(b)>dword(b+4))return 0;
   if(apply){loaded=dword(b);total=dword(b+4);}break;
  /* Launch is intentionally held for Phase 10, never arm a cartridge here. */
  case 14:return 0;
  case 15:case 16:
   if(len!=2 || b[0]!=1 || b[1])return 0;
   /* Reset cannot be mixed with mutations: restart is a fresh session. */
   if(n!=5)return 0;
   if(apply){memset(rows,0,sizeof(rows));memset(dirty,1,28);top=0;text_rows=28;ring_offset=0;SetScroll(255);}break;
  default:return 0;
  }
 }
 return 1;
}
static void page(u8 slot) {
 u8 seq;u16 n;const u8 *p=SNAPSHOT;
 Snapshot(slot);seq=p[0];if(!seq)return;
 if(seq==last_page[slot]) {
  /* An ACK already queued/held is sufficient, never fill the queue on retries. */
  return;
 }
 if(seq!=expected || qcount>61)return;
 n=word(p+1);if(n>1915)return;
 if(crc(p,n+3)!=word(p+n+3) || !commands(p+3,n,0)){++bad_pages;return;}
 commands(p+3,n,1);last_page[slot]=seq;expected=next(seq);++good_pages;enqueue(6,slot,seq);
}
/* Shade planes retain overlapping italic glyphs, dim and syntax accents. */
u16 glyph_offset,glyph_x,glyph_icon;u8 glyph_color;
static void glyphs(const Row *row,u16 left,u16 right) {
 u16 x=left;u8 i,c,f,style,color; signed char icon;
 for(i=0;i<row->n && x<right;++i) {
  c=row->chars[i];style=row->flags?row->attrs[i]>>4:0;f=row->font;
  if(f<3) {
   if(style==5)f=2;
   else if(style==1||style==3||style==7||style==13||style==2)
    f=(f==2?7:10)+(style==3?2:style==2?1:0);
  }
  color=style==4||style==8?2:3;
  if(style==5||style==11)color=5;
  else if(style==6||style==7||style==9||style==10)color=4;
  else if(style==12)color=6;else if(style==13||style==14)color=7;
  icon=c>=1&&c<=8?c-1:c>=129&&c<=131?c-121:-1;
  glyph_offset=(u16)f*2048+(u16)c*8;glyph_x=x;glyph_color=color;
  glyph_icon=(!row->flags && icon>=0)?FONT_ICONS+(u16)icon*64:65535u;
  BlitGlyph();
  x+=row->flags?(row->attrs[i]&15):FontByte(FONT_WIDTHS+(u16)row->font*256+c);
 }
}
u16 pixel_start=256,pixel_end=256;
static void pixels(const Row *row,u16 left,u16 right,u8 selected) {
 (void)left;(void)right;
 pixel_start=selected?0:row->start==row->end?256:8u+row->start;
 pixel_end=selected?256:row->start==row->end?256:row->end==255?256:8u+row->end;
 EncodeRow();
}
static void hex4(u8 *p,u16 v) {
 static const u8 digits[]="0123456789ABCDEF";u8 i;
 for(i=0;i<4;++i){p[3-i]=digits[v&15];v>>=4;}
}
static void draw(u8 row) {
 Row debug;const Row *source=rows+row;
 if(row==0 && (bars&1))source=bar_lines;
 if(row==27 && (bars&2))source=bar_lines+1;
 if(row==27 && debug_enabled){
  memset(&debug,0,sizeof(debug));debug.font=2;debug.n=44;
  memcpy(debug.chars,"SGB GOOD:0000 BAD:0000 MISS:0000 ROW:0000 Q:00",44);
  hex4(debug.chars+9,good_pages);hex4(debug.chars+18,bad_pages);
  hex4(debug.chars+28,capture_missed);hex4(debug.chars+37,capture_rows);source=&debug;
 }
 ClearRaster();glyphs(source,8,256);pixels(source,8,256,0);
 PresentRow((row+ring_offset)&31);dirty[row]=0;++drawn_rows;
}
static void pads(void) {
 u16 e;u8 key=0;
 e=pad_edges[0]|pad_edges[1];pad_edges[0]=pad_edges[1]=0;
 if(((pad_held[0]|pad_held[1])&0x2030)==0x2030 && (e&0x2030)) {
  debug_enabled^=1;dirty[27]=1;return;
 }
 if(e&0x0800)key=0x82; /* up */
 else if(e&0x0400)key=0x83;
 else if(e&0x0200)key=0x80;
 else if(e&0x0100)key=0x81;
 else if(e&0x0080)key=10;
 else if(e&0x8000)key=8;
 else if(e&0x1000)key=0x89;
 if(key && qcount<61)enqueue(1,key,0);
}
void main(void) {
 u16 frame=65535u;u8 slot;
 memset(dirty,1,28);enqueue(5,1,5);
 for(;;) {
  Capture();events();
  if(capture_ready&1){capture_ready&=254;page(0);events();}
  if(capture_ready&2){capture_ready&=253;page(1);events();}
  if(frame!=tick){
   frame=tick;pads();
   if(debug_enabled && (u16)(tick-debug_frame)>=60){debug_frame=tick;dirty[27]=1;}
   if(scroll_pending){
    u8 i,waiting=0;for(i=top;i<top+text_rows;++i)waiting|=dirty[i];
    if(!waiting){
     if(!scroll_smooth)scroll_current=scroll_target;
     else if((signed char)(scroll_target-scroll_current)>0)scroll_current+=2;
     else scroll_current-=2;
     if((u8)(scroll_current-scroll_target)<=1){scroll_current=scroll_target;scroll_pending=0;}
     WaitBlank();SetScroll(scroll_current);
    }
   }
  }
  slot=scan_row++;if(scan_row==28)scan_row=0;
  if(dirty[slot])draw(slot);
  if(palette_dirty || cursor_dirty) {
   WaitBlank();
   if(palette_dirty){PresentPalette();palette_dirty=0;}
   if(cursor_dirty){PresentCursor();cursor_dirty=0;}
  }
 }
}
