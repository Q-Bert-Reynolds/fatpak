/* Real-CPU comparison: native layout vs the original C layout, including
 * existing shade under italic overlaps, right clipping and colored icons. */
static u8 glyph_initial[2048],glyph_native[2048];
volatile u16 glyph_checks,glyph_mismatches;
volatile u8 glyph_failures[74];
static void GlyphChecks(void) {
 Row row;u8 f,s,i,test;u16 p,left,right;
 static const u8 sample[]={1,2,8,129,130,131,'A','j','f','i','W',' ',127,127,'1',':','2','3','p','m',' ',' '};
 memset(&row,0,sizeof(row));row.n=sizeof(sample);memcpy(row.chars,sample,sizeof(sample));
 for(p=0;p<sizeof(shade);++p)glyph_initial[p]=(p%11==0)?5:0;
 for(f=0;f<7;++f)for(test=0;test<3;++test)for(s=0;s<(test==1?16:1);++s){
  if(f>=3 && s!=0 && s!=7 && s!=14)continue;
  row.font=f;row.flags=!!test;
  for(i=0;i<row.n;++i)row.attrs[i]=((test==2?3:s)<<4)|(i%9+1);
  left=test==2?231:3;right=(test==2 || (s&2))?249:256;
  memcpy(shade,glyph_initial,sizeof(shade));glyphs(&row,left,right);
  memcpy(glyph_native,shade,sizeof(shade));
  memcpy(shade,glyph_initial,sizeof(shade));glyphs_reference(&row,left,right);
  if(memcmp(glyph_native,shade,sizeof(shade))){glyph_failures[glyph_checks]=1;++glyph_mismatches;}
  ++glyph_checks;Capture();
 }
 memset(shade,0,sizeof(shade));
}
