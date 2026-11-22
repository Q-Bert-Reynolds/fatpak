// Page-local helpers (notes/COMPILER.md). On the Game Boy each page of a pass (a 7 KB piece of
// a module) is mapped alone at $A000: a call to another page is a far call, and another page
// can't read this one's constants through a pointer. So each page compiles its own copy of the
// hot accessors, and of out_str, which copies a literal to the stack before out_bytes (which
// may be on another page) reads it. Each page defines CC_NEED_<function> for what it calls
// before including this (scripts/cc_pages.py writes them): SDCC keeps static functions nobody calls.
#ifndef CC_ACC_H
#define CC_ACC_H
#include "cc_int.h"
// A module is one assembly file, so each page's copies get its name (CC_PAGE) as a suffix.
#define CC_CAT_(a, b) a##_##b
#define CC_CAT(a, b) CC_CAT_(a, b)
#define CC_LOCAL_NAME(n) CC_CAT(n, CC_PAGE)
#define cc_at CC_LOCAL_NAME(cc_at)
#define rd16 CC_LOCAL_NAME(rd16)
#define wr16 CC_LOCAL_NAME(wr16)
#define sy_r8 CC_LOCAL_NAME(sy_r8)
#define sy_r16 CC_LOCAL_NAME(sy_r16)
#define sy_w8 CC_LOCAL_NAME(sy_w8)
#define sy_w16 CC_LOCAL_NAME(sy_w16)
#define ty_r8 CC_LOCAL_NAME(ty_r8)
#define ty_r16 CC_LOCAL_NAME(ty_r16)
#define ty_w8 CC_LOCAL_NAME(ty_w8)
#define ty_w16 CC_LOCAL_NAME(ty_w16)
#define fl_r16 CC_LOCAL_NAME(fl_r16)
#define fl_w16 CC_LOCAL_NAME(fl_w16)
#define nd_r8 CC_LOCAL_NAME(nd_r8)
#define nd_r16 CC_LOCAL_NAME(nd_r16)
#define nd_w8 CC_LOCAL_NAME(nd_w8)
#define nd_w16 CC_LOCAL_NAME(nd_w16)
#define nd_r32 CC_LOCAL_NAME(nd_r32)
#define nd_w32 CC_LOCAL_NAME(nd_w32)
#define nm_r16 CC_LOCAL_NAME(nm_r16)
#define nm_w16 CC_LOCAL_NAME(nm_w16)
#define out_str CC_LOCAL_NAME(out_str)
#define cc_copy CC_LOCAL_NAME(cc_copy)
#ifdef CC_HOST
#define CC_LOCAL static __attribute__((unused)) // a page may not need all three below
#else
#define CC_LOCAL static
#endif
CC_LOCAL u8* cc_at(u16 base, u16 i, u8 shift) { // record i of (1 << shift)-byte records from block base
  cc_sel((u16)(base + (i >> (9 - shift))));
  return cc_win + ((u16)(i << shift) & 511);
}
CC_LOCAL u16 rd16(const u8* p) { return (u16)(p[0] | (u16)p[1] << 8); }
CC_LOCAL void wr16(u8* p, u16 v) { p[0] = (u8)v; p[1] = (u8)(v >> 8); }
// a table's accessors, each only where a page needs it (scripts/cc_pages.py writes the CC_NEED_*)
#define CC_R8(p, base, shift) static u8 p##_r8(u16 i, u8 off) { return cc_at(base, i, shift)[off]; }
#define CC_R16(p, base, shift) static u16 p##_r16(u16 i, u8 off) { return rd16(cc_at(base, i, shift) + off); }
#define CC_W8(p, base, shift) static void p##_w8(u16 i, u8 off, u8 v) { cc_at(base, i, shift)[off] = v; }
#define CC_W16(p, base, shift) static void p##_w16(u16 i, u8 off, u16 v) { wr16(cc_at(base, i, shift) + off, v); }
#ifdef CC_NEED_sy_r8
CC_R8(sy, CC_SYM_BLOCK, 4)
#endif
#ifdef CC_NEED_sy_r16
CC_R16(sy, CC_SYM_BLOCK, 4)
#endif
#ifdef CC_NEED_sy_w8
CC_W8(sy, CC_SYM_BLOCK, 4)
#endif
#ifdef CC_NEED_sy_w16
CC_W16(sy, CC_SYM_BLOCK, 4)
#endif
#ifdef CC_NEED_ty_r8
CC_R8(ty, CC_TYPE_BLOCK, 4)
#endif
#ifdef CC_NEED_ty_r16
CC_R16(ty, CC_TYPE_BLOCK, 4)
#endif
#ifdef CC_NEED_ty_w8
CC_W8(ty, CC_TYPE_BLOCK, 4)
#endif
#ifdef CC_NEED_ty_w16
CC_W16(ty, CC_TYPE_BLOCK, 4)
#endif
#ifdef CC_NEED_fl_r16
CC_R16(fl, CC_FIELD_BLOCK, 3)
#endif
#ifdef CC_NEED_fl_w16
CC_W16(fl, CC_FIELD_BLOCK, 3)
#endif
#ifdef CC_NEED_nd_r8
CC_R8(nd, CC_NODE_BLOCK, 4)
#endif
#ifdef CC_NEED_nd_r16
CC_R16(nd, CC_NODE_BLOCK, 4)
#endif
#ifdef CC_NEED_nd_w8
CC_W8(nd, CC_NODE_BLOCK, 4)
#endif
#ifdef CC_NEED_nd_w16
CC_W16(nd, CC_NODE_BLOCK, 4)
#endif
#ifdef CC_NEED_nd_r32
static s32 nd_r32(u16 i, u8 off) { u8* q = cc_at(CC_NODE_BLOCK, i, 4) + off; return (s32)((u32)rd16(q) | (u32)rd16(q + 2) << 16); }
#endif
#ifdef CC_NEED_nd_w32
static void nd_w32(u16 i, u8 off, s32 v) { u8* q = cc_at(CC_NODE_BLOCK, i, 4) + off; wr16(q, (u16)v); wr16(q + 2, (u16)((u32)v >> 16)); }
#endif
#ifdef CC_NEED_nm_r16
static u16 nm_r16(u16 id, u8 off) { return rd16(cc_at(CC_NAME_BLOCK, id, 6) + off); }
#endif
#ifdef CC_NEED_nm_w16
static void nm_w16(u16 id, u8 off, u16 v) { wr16(cc_at(CC_NAME_BLOCK, id, 6) + off, v); }
#endif
#ifdef CC_NEED_cc_copy
// n bytes from s to d: on the device a 32-cycle loop (SDCC's byte loops took ~150 a byte)
#ifdef CC_HOST
static void cc_copy(u8* d, const u8* s, u16 n) { while (n) { *d++ = *s++; --n; } }
#else
static void cc_copy(u8* d, const u8* s, u16 n) __naked {
  d; s; n;
  __asm
    ld hl, sp+2
    ld a, [hl+]
    ld h, [hl]
    ld l, a ;// n
    or a, h
    jr z, .done
    push de
    ld d, h
    ld e, l
    ld h, b
    ld l, c ;// s
    pop bc ;// d
.loop:
    ld a, [hl+]
    ld [bc], a
    inc bc
    dec de
    ld a, d
    or a, e
    jr nz, .loop
.done:
    pop hl
    pop af ;// n
    jp hl
  __endasm;
}
#endif
#endif
#ifdef CC_NEED_out_str
static void out_str(u8 sink, const char* s) {
  char buf[16]; u8 n;
  while (*s) { for (n = 0; *s && n < sizeof(buf); ) buf[n++] = *s++; out_bytes(sink, buf, n); }
}
#endif
#endif
