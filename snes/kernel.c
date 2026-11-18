/* Production 65816 terminal. cc65 supplies the C ABI, hardware.s owns the PPU
 * and ICD2. Validation is a separate pass: a bad trailing TLV changes nothing. */
#include "kernel.h"
#include "../src/sgb/protocol.h"
#include <string.h>

volatile u8 capture_ready, capture_last;
volatile u16 capture_rows,capture_missed,tick,pad_held[2],pad_edges[2];
volatile u16 hw_frames;
u16 perf_draw,perf_ui,perf_page,perf_mail,event_started;
u16 trace_frame;
u8 trace_field,screen_received;
u8 raster[1024],shade[2048],mailbox[4];
u16 palette[16]={0x6FBD,0x7F34,0x3A2E,0x0C42,0x6124,0x1093,0x50AF,0x0155};
u8 cursor_row,cursor_x,cursor_look;
typedef struct { u8 font,flags,start,end,n; u8 chars[64],attrs[64]; } Row;
Row rows[28];
u8 row_attrs[64];
u8 dirty[28],top,text_rows=28,bars,osk_rows,ring_offset;
u8 last_page[2],expected=1;
u16 good_pages,bad_pages,drawn_rows;
u8 queue[64][3],qhead,qcount,event_seq=1,active_event;
u8 sent_pad;
u8 status_echo,status_page,status_valid;
u16 status_frame;
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
#ifdef SNES_TEST
static u16 crc(const u8 *p,u16 n) {
 u16 c=65535u; u8 j;
 while(n--) { c^=(u16)*p++<<8; for(j=0;j<8;++j)c=(c&0x8000)?(c<<1)^0x1021:c<<1; Capture(); }
 return c;
}
#else
const u8 *crc_data;
u16 crc_count;
static u16 crc(const u8 *p,u16 n) {
 crc_data=p;crc_count=n;return CRC16();
}
#endif
static u8 next(u8 s) { return s==255?1:s+1; }
static void peak(u16 *value,u16 start){u16 elapsed=Clock()-start;if(elapsed>*value)*value=elapsed;}
static void enqueue(u8 type,u8 a,u8 b) {
 u8 at,i,place;
 if(qcount>=64)return;
 /* Keep the held event immutable; control replies go ahead of queued keys. */
 place=(type==1 || type==SGBFS_EVENT_PAD || type>=SGBFS_EVENT_DIAG_GOOD)?qcount:active_event;
 for(i=qcount;i>place;--i){
  memcpy(queue+((qhead+i)&63),queue+((qhead+i-1)&63),3);Capture();
 }
 at=(qhead+place)&63;queue[at][0]=type;queue[at][1]=a;queue[at][2]=b;++qcount;
}
static void events(void) {
 u8 status[16],i;
 for(i=0;i<16;++i)status[i]=STATUS[i];
 status_echo=status[4];status_page=status[6];status_frame=word(status+2);
 status_valid=status[0]==83 && status[1]==1 && !(status[5]&254) &&
    !status[8]&&!status[9]&&!status[10]&&!status[11]&&!status[12]&&!status[13] &&
    crc(status,14)==word(status+14);
 if(active_event && status_valid && status_echo==mailbox[0]) {
  peak(&perf_mail,event_started);active_event=0;qhead=(qhead+1)&63;--qcount;
  event_seq=event_seq==127?1:event_seq+1;
 }
 if(!active_event && qcount) {
  mailbox[0]=event_seq;memcpy(mailbox+1,queue[qhead],3);event_started=Clock();PublishMailbox();active_event=1;
 }
}
static void ui_all(void){memset(overlay_dirty,1,28);}
static u8 osk_top(void){return 28-!!(bars&2)-7;}
static void ui_osk(void){u8 y;if(osk_rows)for(y=osk_top();y<osk_top()+7;++y)overlay_dirty[y]=1;}
static void ui_box(void){u8 y;for(y=0;y<box_rows;++y)overlay_dirty[box_top+y]=1;}
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
    k=0;for(i=7u+b[5];i<len;i+=2){memset(row_attrs+k,b[i+1],b[i]);k+=b[i];Capture();}
    out=rows+b[0];
    if(out->font==b[1] && out->flags==b[2] && out->start==b[3] && out->end==b[4] && out->n==b[5] &&
       !memcmp(out->chars,b+7,b[5]) && !memcmp(out->attrs,row_attrs,b[5]))break;
    out->font=b[1];out->flags=b[2];out->start=b[3];out->end=b[4];out->n=b[5];
    memcpy(out->chars,b+7,b[5]);memcpy(out->attrs,row_attrs,b[5]);
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
      (u16)b[0]+b[1]+!!(b[2]&2)>28)return 0;
   shadow_rows=b[1];if(apply && (top!=b[0] || text_rows!=b[1] || bars!=b[2] || osk_rows!=b[3])){
    top=b[0];text_rows=b[1];bars=b[2];osk_rows=b[3];ui_all();
   }break;
  case 5:
   if(len!=3 || b[0]>=28 || b[2]>2)return 0;
   if(apply){cursor_row=b[0];cursor_x=b[1];cursor_look=b[2];cursor_dirty=1;screen_received=1;}break;
  case 6:
   if(len!=5)return 0;
   w=word(b+1);
   if(!w){if(b[0]||b[1]||b[2]||b[3]||b[4])return 0;}
   else if(w<8 || b[0]+w>256 || !b[4] || (u16)b[3]+b[4]>28)return 0;
   shadow_box=b[4];if(apply){
    ui_box();box_x=b[0];box_width=w;box_top=b[3];box_rows=b[4];box_hi=255;
    for(i=0;i<28;++i){memset(box_lines+i,0,sizeof(Row));Capture();}ui_box();
   }break;
  case 7:case 9:
   if(len<3 || b[1]>6 || b[2]>64 || len!=3u+b[2] || b[0]>=(op==7?shadow_box:2))return 0;
   if(apply){out=op==7?box_lines+b[0]:bar_lines+b[0];memset(out,0,sizeof(Row));
    out->font=b[1];out->n=b[2];memcpy(out->chars,b+3,b[2]);
    overlay_dirty[op==7?box_top+b[0]:b[0]?27:0]=1;}break;
  case 8:
   if(len!=1 || (b[0]!=255 && b[0]>=shadow_box))return 0;
   if(apply && box_hi!=b[0]){if(box_hi<box_rows)overlay_dirty[box_top+box_hi]=1;box_hi=b[0];if(box_hi<box_rows)overlay_dirty[box_top+box_hi]=1;}break;
  case 10:
   if(len!=2 || b[0]>3 || (b[1]>=50 && b[1]!=255))return 0;
   if(apply && (osk_layer!=b[0] || osk_key!=b[1])){osk_layer=b[0];osk_key=b[1];ui_osk();}break;
  case 11:
   if(len<4 || !b[1] || b[1]>16 || b[0]+b[1]>16 || len!=2u+2u*b[1])return 0;
   for(i=0;i<b[1];++i)if(b[3+i*2]&128)return 0;
   if(apply){for(i=0;i<b[1];++i)palette[b[0]+i]=word(b+2+i*2);palette_dirty=1;}break;
  case 12:
   if(len!=1 || b[0]>1)return 0;
   if(apply && busy!=b[0]){busy=b[0];overlay_dirty[0]=1;}
   break;
  case 13:
   if(len!=8 || dword(b)>dword(b+4))return 0;
   if(apply){loaded=dword(b);total=dword(b+4);overlay_dirty[27]=1;}break;
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
 /* Most capture notifications repeat an already-applied page (or empty B).
    Avoid the 1920-byte copy, but recheck the copied sequence and full CRC below. */
 seq=slot?PAGE_B[0]:PAGE_A[0];
 if(!seq || seq==last_page[slot] || seq!=expected || qcount>61)return;
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
static void receive(u8 slot){u16 start=Clock();page(slot);peak(&perf_page,start);}
/* Shade planes retain overlapping italic glyphs, dim and syntax accents. */
u16 glyph_offset,glyph_x,glyph_icon,glyph_right;u8 glyph_color;
static void glyphs(const Row *row,u16 left,u16 right) {
 u16 x=left;u8 i,c,f,style,color,j,k; signed char icon;
 for(i=0;i<row->n && x<right;++i) {
  c=row->chars[i];
  if(!row->flags && c==127){
   while(i+1<row->n && row->chars[i+1]==127)++i;
   x=252;
   k=row->n;while(k>i+1 && row->chars[k-1]==' ')--k;
   for(j=i+1;j<k;++j){x-=FontWidth((u16)row->font*256+row->chars[j]);Capture();}
   continue;
  }
  /* Every font's space bitmap is empty; selection is painted by EncodeRow. */
  if(c==' '){x+=row->flags?(row->attrs[i]&15):FontWidth((u16)row->font*256+c);continue;}
  style=row->flags?row->attrs[i]>>4:0;f=row->font;
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
  glyph_offset=(u16)f*2048+(u16)c*8;glyph_x=x;glyph_right=right;glyph_color=color;
  glyph_icon=(!row->flags && icon>=0)?FONT_ICONS+(u16)icon*64:65535u;
  BlitGlyph();
  x+=row->flags?(row->attrs[i]&15):FontWidth((u16)row->font*256+c);
 }
}
u16 pixel_start=256,pixel_end=256;
static void pixels(const Row *row,u16 left,u16 right,u8 selected) {
 (void)left;(void)right;
 pixel_start=selected?left:row->start==row->end?256:row->start;
 pixel_end=selected?right:row->start==row->end?256:row->end==255?256:row->end;
 EncodeRow();
}
static void hex4(u8 *p,u16 v) {
 static const u8 digits[]="0123456789ABCDEF";u8 i;
 for(i=0;i<4;++i){p[3-i]=digits[v&15];v>>=4;}
}
static void draw(u8 row) {
 u16 start=Clock();
 const Row *source=rows+row;
 ClearRaster();glyphs(source,source->font?1:0,source->font?249:248);pixels(source,0,256,0);
 PresentRow((row+ring_offset)&31);dirty[row]=0;++drawn_rows;peak(&perf_draw,start);
}
u16 ui_left,ui_right;
static u16 progress_width(void){
 u8 i;u16 result=0;u32 rem=loaded;
 if(!total)return 0;
 if(loaded==total)return 256;
 for(i=0;i<8;++i){
  result<<=1;
  if(rem>=total-rem){rem-=total-rem;++result;}else rem+=rem;
 }
 return result;
}
static void draw_ui(u8 row){
 static const u8 keys[3][41]={
  "1234567890qwertyuiopasdfghjkl;zxcvbnm,./",
  "!@#$%^&*()QWERTYUIOPASDFGHJKL:ZXCVBNM<>?",
  "`~-_=+[]{}\\|'\"\241\277\341\351\355\363\372\361\374"};
 static const u8 bottom[20]={29,' ','#',' ',31,' ','_','_','_','_','_','_','_','_',15,' ',16,' ',30,' '};
 Row keyrow;u8 y,i,rel;u16 x,width,start=Clock();
 ClearRaster();pixel_start=pixel_end=256;ui_left=ui_right=0;
 if((row==0 && (bars&1)) || (row==27 && (bars&2))){
  glyphs(bar_lines+(row?1:0),bar_lines[row?1:0].font?1:0,256);ui_right=256;
  pixel_start=0;pixel_end=256;
 }
 if(osk_rows && row>=osk_top() && row<osk_top()+7){
  /* 168px panel centered on the SNES, independent of the document rows. */
  ui_left=44;ui_right=212;
  for(y=0;y<8;++y){memset(shade+(u16)y*256+44,0,168);Capture();}
  rel=row-osk_top();
  if(rel && rel<6){
   --rel;memset(&keyrow,0,sizeof(keyrow));keyrow.n=20;memset(keyrow.chars,' ',20);
   if(rel<4)for(i=0;i<10;++i){y=rel*10+i;if(keys[osk_layer==3?1:osk_layer][y])keyrow.chars[i*2]=keys[osk_layer==3?1:osk_layer][y];}
   else{memcpy(keyrow.chars,bottom,20);if(osk_layer==3)keyrow.chars[0]=25;}
   glyphs(&keyrow,52,204);
   if(osk_key!=255 && osk_key/10==rel){pixel_start=52+(osk_key%10)*16;pixel_end=pixel_start+8;}
  }
  for(y=0;y<8;++y){shade[(u16)y*256+44]=1;shade[(u16)y*256+211]=1;}
  if(row==osk_top() || row==osk_top()+6){
   y=row==osk_top()?0:7;for(x=44;x<212;++x)shade[(u16)y*256+x]=1;
  }
 }
 if(box_width && row>=box_top && row<box_top+box_rows){
  for(y=0;y<8;++y){memset(shade+(u16)y*256+box_x,0,box_width);Capture();}
  glyphs(box_lines+(row-box_top),box_x+4,box_x+box_width-4);
  if(!ui_right || box_x<ui_left)ui_left=box_x;
  if(box_x+box_width>ui_right)ui_right=box_x+box_width;
  if(row-box_top==box_hi){pixel_start=box_x;pixel_end=box_x+box_width;}
  for(y=0;y<8;++y){shade[(u16)y*256+box_x]=1;shade[(u16)y*256+box_x+box_width-1]=1;}
  if(row==box_top || row==box_top+box_rows-1){
   y=row==box_top?0:7;for(x=box_x;x<box_x+box_width;++x)shade[(u16)y*256+x]=1;
  }
 }
 if(row==0 && busy)for(y=0;y<4;++y)for(i=248;i<252;++i)shade[(u16)y*256+i]=1;
 if(row==27 && total){width=progress_width();for(x=0;x<width;++x)shade[1792+x]=1;}
 /* Diagnostics must cover the status bar, which otherwise hides BG1 row 27. */
 if(row>=25 && debug_enabled){
  ClearRaster();memset(&keyrow,0,sizeof(keyrow));keyrow.font=2;
  if(row==27){
   keyrow.n=46;memcpy(keyrow.chars,"SGB GOOD:0000 BAD:0000 MISS:0000 ROW:0000 Q:00",46);
   hex4(keyrow.chars+9,good_pages);hex4(keyrow.chars+18,bad_pages);
   hex4(keyrow.chars+28,capture_missed);hex4(keyrow.chars+37,capture_rows);
   keyrow.chars[44]="0123456789ABCDEF"[qcount>>4];keyrow.chars[45]="0123456789ABCDEF"[qcount&15];
  }else if(row==26){
   keyrow.n=48;memcpy(keyrow.chars,"DRAW:0000 UI:0000 PAGE:0000 MAIL:0000 FRAME:0000",48);
   hex4(keyrow.chars+5,perf_draw);hex4(keyrow.chars+13,perf_ui);
   hex4(keyrow.chars+23,perf_page);hex4(keyrow.chars+33,perf_mail);hex4(keyrow.chars+44,Clock());
  }else{
   keyrow.n=43;memcpy(keyrow.chars,"MB:0000/0000 E:00 GB:0000 P:00 V:00 NEXT:00",43);
   hex4(keyrow.chars+3,((u16)mailbox[0]<<8)|mailbox[1]);
   hex4(keyrow.chars+8,((u16)mailbox[2]<<8)|mailbox[3]);
   keyrow.chars[15]="0123456789ABCDEF"[status_echo>>4];
   keyrow.chars[16]="0123456789ABCDEF"[status_echo&15];
   hex4(keyrow.chars+21,status_frame);
   keyrow.chars[28]="0123456789ABCDEF"[status_page>>4];
   keyrow.chars[29]="0123456789ABCDEF"[status_page&15];
   keyrow.chars[34]=status_valid?'1':'0';
   keyrow.chars[41]="0123456789ABCDEF"[expected>>4];
   keyrow.chars[42]="0123456789ABCDEF"[expected&15];
  }
  glyphs(&keyrow,8,256);pixel_start=pixel_end=256;ui_left=0;ui_right=256;
 }
 /* ClearRaster already supplied transparent tiles for an empty UI row.
    Still upload them and its empty mask to erase any previous overlay. */
 if(ui_left!=ui_right || (row==0 && busy) || (row==27 && total))EncodeRow();
 PresentOverlay(row);overlay_dirty[row]=0;peak(&perf_ui,start);
}
static u8 pad_bits(u16 state){
 u8 pad=0;
 if(state&0x0080)pad|=1;
 if(state&0x8000)pad|=2;
 if(state&0x2000)pad|=4;
 if(state&0x1000)pad|=8;
 if(state&0x0100)pad|=16;
 if(state&0x0200)pad|=32;
 if(state&0x0800)pad|=64;
 if(state&0x0400)pad|=128;
 return pad;
}
static void pads(void) {
 u16 held=pad_held[0],e=pad_edges[0];u8 pad,pulse;
 /* Keep short presses latched across drawing, with room for their release. */
 if(qcount>=60)return;
 pad_edges[0]=pad_edges[1]=0;
 if((held&0x2030)==0x2030) {
  if(e&0x2030){debug_enabled^=1;overlay_dirty[25]=overlay_dirty[26]=overlay_dirty[27]=1;}
  held&=~0x2000u;e&=~0x2000u; /* reserve L+R+Select for diagnostics */
 }
 /* Port 2 belongs to the mouse. GB code interprets pad state in UI context. */
 pad=pad_bits(held);pulse=pad|pad_bits(e);
 if(pulse!=sent_pad){enqueue(SGBFS_EVENT_PAD,pulse,pulse&~sent_pad);sent_pad=pulse;}
 if(pad!=sent_pad){enqueue(SGBFS_EVENT_PAD,pad,0);sent_pad=pad;}
}

void main(void) {
 u16 frame=65535u;u8 slot;
 trace_field=4; /* Start with rendering cost, then finish the counter rotation. */
 OverlayInit();memset(dirty,1,28);ui_all();enqueue(5,1,5);
 for(;;) {
  Capture();events();
  if(capture_ready&1){capture_ready&=254;receive(0);events();}
  if(capture_ready&2){capture_ready&=253;receive(1);events();}
  if(frame!=tick){
   frame=tick;
   /* A held event is immutable until its status echo. Reissue it once per
      frame so a missed ICD2 commit cannot strand all later page ACKs. */
   if(active_event)PublishMailbox();
   pads();
   /* Keep diagnostics out of startup. A single optional sample must not
      occupy the mailbox until the first screen has been received and drawn. */
   if(screen_received && drawn_rows>=28 && !qcount && (u16)(Clock()-trace_frame)>=120){
    u16 value;
    trace_frame=Clock();
    switch(trace_field){
     case 0:value=good_pages;break;case 1:value=bad_pages;break;
     case 2:value=capture_missed;break;case 3:value=capture_rows;break;
     case 4:value=perf_draw;break;case 5:value=perf_ui;break;
     case 6:value=perf_page;break;case 7:value=perf_mail;break;
     default:value=Clock();break;
    }
    enqueue(SGBFS_EVENT_DIAG_GOOD+trace_field,value,value>>8);
    if(++trace_field==9)trace_field=0;
   }
   if(debug_enabled && (u16)(tick-debug_frame)>=60){debug_frame=tick;overlay_dirty[25]=overlay_dirty[26]=overlay_dirty[27]=1;}
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
  /* A fault report must not wait behind the initial 28-row repaint. */
  if(debug_enabled && overlay_dirty[27])draw_ui(27);
  if(debug_enabled && overlay_dirty[26])draw_ui(26);
  if(debug_enabled && overlay_dirty[25])draw_ui(25);
  slot=scan_row++;if(scan_row==28)scan_row=0;
  if(dirty[slot])draw(slot);
  else if(overlay_dirty[slot])draw_ui(slot);
  if(palette_dirty || cursor_dirty) {
   WaitBlank();
   if(palette_dirty){PresentPalette();palette_dirty=0;}
   if(cursor_dirty){PresentCursor();cursor_dirty=0;}
  }
 }
}
