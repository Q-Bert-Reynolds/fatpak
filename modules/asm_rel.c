// ASM.MOD: values only the link knows (see asm_shared.h, asm_obj.h). A unit is assembled before
// its sections are placed, so a label in a section without an address is a pass value there
// (xs 1), and a name the unit doesn't have is another unit's (xs 2, in pass 2). The parser keeps
// known values as they were; the first operator that can't stay a pass value turns its operands
// into RPN, which a patch carries to LINK.MOD with the field it fills.
#include "asm_shared.h"

unsigned char xs, prel, rpn_n, importing;
unsigned int xsect, psect;
unsigned char rpn[RPN_SIZE];
Val pval;
unsigned char x_ls, x_lmark;
unsigned int x_lsect;
unsigned int patches;

static void RpnPut(unsigned char b) {
  if (rpn_n == RPN_SIZE) { Fail(ASM_ERR_NESTING); return; }
  rpn[rpn_n++] = b;
}
static void Rpn16(unsigned int v) {
  RpnPut((unsigned char)v);
  RpnPut((unsigned char)(v >> 8));
}
// a known value (s 0) or a pass value in section sect (1) as RPN, at the end
static void Item(unsigned char s, const unsigned char* v, unsigned int sect) {
  unsigned char i;
  if (s) {
    RpnPut(RPN_SREL);
    Rpn16(sect - unit_sect0);
  }
  else RpnPut(RPN_CONST);
  for (i = 0; i < 4; ++i) RpnPut(v[i]); // little-endian, both here and on the PC
}
void RelSect(unsigned char op, unsigned int s) {
  RpnPut(op);
  Rpn16((s & ~LABEL_FIXED) - unit_sect0);
  xs = 2;
}
void Import(void) {
  unsigned char i;
  RpnPut(RPN_SYM);
  RpnPut(ident_len);
  for (i = 0; i < ident_len; ++i) RpnPut(ident[i]);
  xs = 2;
}
Val Rel(unsigned char o, Val v) {
  if (xs == 1) Item(1, (unsigned char*)&v, xsect);
  RpnPut(o);
  xs = 2;
  return 0;
}
// o on a (x_ls, x_lsect; its RPN from x_lmark) and b (xs, xsect): a pass value plus or minus a
// known one stays one, two in the same section subtract to a known distance, the rest is RPN
Val Combine(unsigned char o, Val a, Val b) {
  unsigned char n, k, i, item[8], to;
  to = x_ls == 1 ? (!xs ? (o == '+' || o == '-' ? 1 : 3) : xs == 1 && o == '-' && x_lsect == xsect ? 0 : 3)
                 : !x_ls && xs == 1 && o == '+' ? 1 : 3;
  if (to != 3) { // known (0), or a pass value (1) in the one section
    if (x_ls == 1) xsect = x_lsect;
    xs = to;
    return Apply(o, a, b);
  }
  if (x_ls != 2) { // the left operand's RPN goes before the right's
    n = rpn_n;
    Item(x_ls, (unsigned char*)&a, x_lsect);
    k = rpn_n - n;
    for (i = 0; i < k; ++i) item[i] = rpn[n + i];
    for (i = n; i-- > x_lmark; ) rpn[i + k] = rpn[i];
    for (i = 0; i < k; ++i) rpn[x_lmark + i] = item[i];
  }
  if (xs != 2) Item(xs, (unsigned char*)&b, xsect);
  RpnPut(o);
  xs = 2;
  return 0;
}
// an expression that must not need the link (IF, DS's fill, and through Constant every size)
Val Known(void) {
  Val v = Eval();
  if (prel) {
    prel = 0;
    Fail(ASM_ERR_FORWARD);
  }
  return v;
}

// the streams: patches in pass 2, then each unit's exports
unsigned int out_block, out_ofs, out_end;
void Out(unsigned char b) {
  if (out_block == out_end) { Fail(ASM_ERR_FULL); return; }
  Window(out_block);
  WINDOW[out_ofs] = b;
  if (++out_ofs == 512) {
    out_ofs = 0;
    ++out_block;
  }
}
void Out16(unsigned int v) {
  Out((unsigned char)v);
  Out((unsigned char)(v >> 8));
}
// prel's value, for the field about to be emitted at pc (in pass 2; pass 1 only drops it)
void Patch(unsigned char type) {
  unsigned char i;
  if (pass == 2) {
    if (prel == 1) { // a pass value: its section and the value
      rpn_n = 0;
      Item(1, (unsigned char*)&pval, psect);
    }
    Where();
    Out(OBJ_PATCH);
    Out16(in_section ? cur - unit_sect0 : 0);
    Out16(pc); // a pass address, like a label's
    Out(type);
    Out16(where_file);
    Out16(where_line);
    Out16(where_pos);
    Out(rpn_n);
    for (i = 0; i < rpn_n; ++i) Out(rpn[i]);
    ++patches;
  }
  prel = 0;
  rpn_n = 0;
}
