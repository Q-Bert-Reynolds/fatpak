// CC pass B, page 1: the pass, statements and the statement stream.
#define CC_PAGE parse_stmt
#define CC_NEED_sy_r8
#define CC_NEED_sy_r16
#define CC_NEED_sy_w8
#define CC_NEED_sy_w16
#define CC_NEED_ty_r8
#define CC_NEED_ty_r16
#define CC_NEED_fl_r16
#define CC_NEED_nd_r8
#define CC_NEED_nd_r16
#define CC_NEED_nd_w16
#define CC_NEED_nd_r32
#define CC_NEED_nd_w32
#include "cc_parse.h"

// the pass's variables (declared in the header)
u8 spec_storage;
u16 decl_name;
u16 member_top;
s16 cg_depth;
u16 ntypes, nfields, nsyms, nnodes;
Tok tok, ahead;
u8 has_ahead, nesting, block_depth;
u16 func_sym;
u16 brk_label, cont_label;
s16 brk_depth, cont_depth;
u16 block_bytes; // locals allocated by the innermost block so far
u16 stream_at;   // the next token of pass A's stream
u16 stream_line;
u8 stream_file;
u8 ndops; // records at CC_DOP_BLOCK: kind, qual, a, b
u16 dcl_name;
u16 nitems; // records at CC_ITEM_BLOCK: offset, node
u8 init_static;
u16 init_done;
u16 ncases, switch_base, default_label;
s16 default_depth;
u8 in_switch;
u16 switch_type;
u16 nlabels, ngotos;

void gen_func_begin(u16 sym) { u16 stack; s16 pos[CC_PARAMS]; ir_put8(IR_FUNC); ir_put16(sym); cg_depth = (s16)abi_params(SY_TYPE(sym), pos, &stack); }

void gen_func_end(void) { ir_put8(IR_FEND); }

void gen_place(u16 label) { ir_put8(IR_PLACE); ir_put16(label); }

void gen_jump(u16 label, s16 depth) { ir_put8(IR_JUMP); ir_put16(label); ir_put16((u16)depth); }

void gen_expr(u16 n) { ir_put8(IR_EXPR); ir_put16(n); }

void gen_branch(u16 n, u16 label, u8 when) { ir_put8(IR_BRANCH); ir_put16(n); ir_put16(label); ir_put8(when); }

void gen_return(u16 n) { ir_put8(IR_RETURN); ir_put16(n); }

void gen_alloc(u16 bytes) { ir_put8(IR_ALLOC); ir_put16(bytes); cg_depth = (s16)(cg_depth + bytes); }

void gen_free(u16 bytes) { ir_put8(IR_FREE); ir_put16(bytes); cg_depth = (s16)(cg_depth - bytes); }

void gen_zero_local(u16 sym, u16 bytes) { ir_put8(IR_ZERO); ir_put16(sym); ir_put16(bytes); }

void gen_switch_value(u16 n, u16 dispatch) { ir_put8(IR_SWVAL); ir_put16(n); ir_put16(dispatch); }

void gen_comment_line(u16 line) { ir_put8(IR_LINE); ir_put16(line); }

void gen_depth(s16 depth) { ir_put8(IR_DEPTH); ir_put16((u16)depth); cg_depth = depth; } // code after a jump, at this depth

void declare_params(u16 ft) {
  s16 pos[CC_PARAMS]; u16 i, stack;
  abi_params(ft, pos, &stack);
  for (i = 0; i < TY_COUNT(ft); ++i) {
    u16 f = TY_EXTRA(ft) + i, s, name = FL_NAME(f);
    if (!name) cc_error(E_PARAMETER_NEEDS_A_NAME);
    s = sym_add(name, S_LOCAL, FL_TYPE(f));
    SY_POS_SET(s, pos[i]);
  }
}

void function_body(u16 s) {
  u16 mark;
  if (SY_DEFINED(s)) cc_error2(E_FUNCTION_DEFINED_TWICE, SY_NAME(s));
  SY_DEFINED_SET(s, 2);
  func_sym = s;
  gen_func_begin(s);
  mark = nsyms; ++block_depth;
  declare_params(SY_TYPE(s));
  block_bytes = 0;
  compound();
  scope_pop(mark);  --block_depth;
  gen_func_end();
}

void external_declaration(void) {
  u16 base; u8 first = 1, storage;
  if (tok.kind == ';') { next(); return; }
  if (!starts_type(&tok)) cc_error(E_EXPECTED_A_DECLARATION);
  base = declspec(); storage = spec_storage;
  if (tok.kind == ';') { next(); return; }
  for (;;) {
    u16 t = declarator(base), name = decl_name, s;
    if (!name) cc_error(E_DECLARATION_NEEDS_A_NAME);
    if (storage == KW_TYPEDEF) { s = sym_add(name, S_TYPEDEF, t); }
    else {
      if (storage == KW_AUTO || storage == KW_REGISTER) cc_error(E_AUTO_OR_REGISTER_AT_FILE_SCOPE);
      s = declare_global(name, t, storage);
      if (TK(t) == T_FUNC) {
        if (tok.kind == '{') {
          if (!first) cc_error(E_FUNCTION_DEFINITION_IN_A_DECLARATION_L);
          SY_TYPE_SET(s, t); // the definition's parameter names
          function_body(s);
          return;
        }
      } else if (tok.kind == '=') {
        if (storage == KW_EXTERN) cc_warn(E_EXTERN_WITH_AN_INITIALIZER);
        if (SY_DEFINED(s) == 2) cc_error2(E_DEFINED_TWICE, name);
        define_static(s);
      } else if (storage != KW_EXTERN && !SY_DEFINED(s)) SY_DEFINED_SET(s, 1); // tentative
    }
    first = 0;
    if (tok.kind != ',') break;
    next();
  }
  expect(';', E_EXPECTED_AFTER_THE_DECLARATION_SEMI);
}

// ---- statements ----

void reset_nodes(void) {} // the trees stay: code generation may run later

void expr_statement(void) {
  u16 n = expr();
  gen_expr(n);
  reset_nodes();
}

u16 condition(void) { // ( expr ) as a scalar
  u16 n;
  expect('(', E_EXPECTED_3);
  n = rval(expr());
  if (!ty_is_scalar(NT(n))) cc_error(E_CONDITION_NEEDS_A_SCALAR);
  expect(')', E_EXPECTED);
  return n;
}

void branch_on(u16 n, u16 label, u8 when) {
  if (IS_NUM(n)) { if ((ND_VAL(n) != 0) == when) gen_jump(label, cg_depth); }
  else gen_branch(n, label, when);
  reset_nodes();
}

u16 label_find(u16 name) { u16 i; for (i = 0; i < nlabels; ++i) if (LB_NAME(i) == name) break; return i; }

u16 label_new(u16 name) {
  if (nlabels == CC_GOTOS) cc_error(E_TOO_MANY_LABELS);
  rec_w16(CC_LABEL_BLOCK, nlabels, 0, name); rec_w16(CC_LABEL_BLOCK, nlabels, 2, gen_label()); rec_w16(CC_LABEL_BLOCK, nlabels, 6, 0);
  return nlabels++;
}

void statement(void) {
  u16 l1, l2, l3, n;
  u16 sb = brk_label, sc = cont_label; s16 db = brk_depth, dc = cont_depth;
  enter();
  gen_comment_line(tok.line);
  if (tok.kind == '{') { compound(); leave(); return; }
  if (tok.kind == ';') { next(); leave(); return; }
  if (tok.kind == TK_ID && peek()->kind == ':' && !(tok.a < KW_COUNT && tok.a)) {
    u16 name = tok.a, i;
    next(); next();
    i = label_find(name);
    if (i < nlabels && LB_DEFINED(i)) cc_error2(E_LABEL_DEFINED_TWICE, name);
    if (i == nlabels) label_new(name);
    rec_w16(CC_LABEL_BLOCK, i, 6, 1); rec_w16(CC_LABEL_BLOCK, i, 4, (u16)cg_depth);
    { // pending gotos from other depths go through a stub that moves SP
      u16 j, skip = 0;
      for (j = 0; j < ngotos; ++j) if (GT_NAME(j) == name) {
        if (GT_DEPTH(j) == cg_depth) continue;
        if (!skip) { skip = gen_label(); gen_jump(skip, cg_depth); }
        { s16 save = cg_depth; gen_depth(GT_DEPTH(j)); gen_place(GT_STUB(j)); gen_jump(LB_LABEL(i), save); gen_depth(save); }
      }
      if (skip) gen_place(skip);
      for (j = 0; j < ngotos; ++j) if (GT_NAME(j) == name && GT_DEPTH(j) == cg_depth) gen_place(GT_STUB(j));
    }
    gen_place(LB_LABEL(i));
    statement();
    leave(); return;
  }
  if (tok.kind != TK_ID || tok.a >= KW_COUNT || !tok.a) {
    if (starts_type(&tok)) cc_error(E_DECLARATION_NEEDS_TO_BE_IN_A_BLOCK);
    expr_statement(); expect(';', E_EXPECTED_SEMI); leave(); return;
  }
  switch (tok.a) {
  case KW_IF:
    next(); n = condition();
    l1 = gen_label();
    branch_on(n, l1, 0);
    statement();
    if (is_kw(KW_ELSE)) {
      next(); l2 = gen_label();
      gen_jump(l2, cg_depth); gen_place(l1);
      statement();
      gen_place(l2);
    } else gen_place(l1);
    break;
  case KW_WHILE:
    next();
    cont_label = gen_label(); brk_label = gen_label(); cont_depth = brk_depth = cg_depth;
    gen_place(cont_label);
    n = condition();
    branch_on(n, brk_label, 0);
    statement();
    gen_jump(cont_label, cg_depth);
    gen_place(brk_label);
    break;
  case KW_DO:
    next();
    l1 = gen_label(); cont_label = gen_label(); brk_label = gen_label(); cont_depth = brk_depth = cg_depth;
    gen_place(l1);
    statement();
    if (!is_kw(KW_WHILE)) cc_error(E_EXPECTED_WHILE_AFTER_DO);
    next();
    gen_place(cont_label);
    n = condition();
    branch_on(n, l1, 1);
    expect(';', E_EXPECTED_AFTER_DO_WHILE_SEMI);
    gen_place(brk_label);
    break;
  case KW_FOR: {
    u16 mark = nsyms, bytes = block_bytes;
    next(); expect('(', E_EXPECTED_AFTER_FOR);
    ++block_depth; block_bytes = 0;
    if (tok.kind != ';') {
      if (starts_type(&tok)) local_declaration();
      else { expr_statement(); expect(';', E_EXPECTED_SEMI); }
    } else next();
    l1 = gen_label(); l2 = gen_label(); l3 = gen_label();
    brk_label = gen_label(); cont_label = l3; cont_depth = brk_depth = cg_depth;
    gen_place(l1); // the condition
    if (tok.kind != ';') {
      n = rval(expr());
      if (!ty_is_scalar(NT(n))) cc_error(E_CONDITION_NEEDS_A_SCALAR);
      branch_on(n, brk_label, 0);
    }
    expect(';', E_EXPECTED_IN_FOR_SEMI);
    gen_jump(l2, cg_depth);
    gen_place(l3); // the step
    if (tok.kind != ')') expr_statement();
    expect(')', E_EXPECTED_IN_FOR);
    gen_jump(l1, cg_depth);
    gen_place(l2); // the body
    statement();
    gen_jump(l3, cg_depth);
    gen_place(brk_label);
    if (block_bytes) gen_free(block_bytes);
    scope_pop(mark);  --block_depth; block_bytes = bytes;
    break;
  }
  case KW_SWITCH: {
    u16 base = switch_base, dflt = default_label, st = switch_type; s16 ddepth = default_depth; u8 was = in_switch;
    u16 dispatch, i;
    next(); n = condition();
    if (!ty_is_int(NT(n))) cc_error(E_SWITCH_NEEDS_AN_INTEGER);
    n = cast(n, promote(NT(n)));
    if (ty_size(NT(n)) > 2) cc_error(E_SWITCH_ON_A_LONG_IS_NOT_SUPPORTED_YET);
    switch_type = NT(n);
    dispatch = gen_label(); brk_label = gen_label(); brk_depth = cg_depth;
    gen_switch_value(n, dispatch);
    reset_nodes();
    switch_base = ncases; default_label = 0; in_switch = 1;
    statement();
    gen_jump(brk_label, brk_depth);
    gen_place(dispatch);
    ir_put8(IR_SWTAB); ir_put16((u16)(ncases - switch_base));
    ir_put16(default_label ? default_label : brk_label); ir_put16((u16)(default_label ? default_depth : brk_depth));
    for (i = switch_base; i < ncases; ++i) { ir_put16(CASE_VAL(i)); ir_put16(CASE_LABEL(i)); ir_put16((u16)CASE_DEPTH(i)); }
    gen_place(brk_label);
    ncases = switch_base; switch_base = base; default_label = dflt; default_depth = ddepth; in_switch = was; switch_type = st;
    break;
  }
  case KW_CASE: {
    s32 v; u16 i;
    if (!in_switch) cc_error(E_CASE_OUTSIDE_A_SWITCH);
    next(); v = norm(const_expr(), switch_type); expect(':', E_EXPECTED_AFTER_CASE);
    reset_nodes();
    for (i = switch_base; i < ncases; ++i) if (CASE_VAL(i) == (u16)v) cc_error(E_DUPLICATE_CASE);
    if (ncases == CC_SWITCH_CASES) cc_error(E_TOO_MANY_CASES);
    rec_w16(CC_CASE_BLOCK, ncases, 0, (u16)v); rec_w16(CC_CASE_BLOCK, ncases, 2, gen_label()); rec_w16(CC_CASE_BLOCK, ncases, 4, (u16)cg_depth);
    gen_place(CASE_LABEL(ncases)); ++ncases;
    statement();
    break;
  }
  case KW_DEFAULT:
    if (!in_switch) cc_error(E_DEFAULT_OUTSIDE_A_SWITCH);
    if (default_label) cc_error(E_TWO_DEFAULTS);
    next(); expect(':', E_EXPECTED_AFTER_DEFAULT);
    default_label = gen_label(); default_depth = cg_depth;
    gen_place(default_label);
    statement();
    break;
  case KW_BREAK:
    next(); if (!brk_label) cc_error(E_BREAK_OUTSIDE_A_LOOP_OR_SWITCH);
    gen_jump(brk_label, brk_depth); expect(';', E_EXPECTED_AFTER_BREAK_SEMI);
    break;
  case KW_CONTINUE:
    next(); if (!cont_label) cc_error(E_CONTINUE_OUTSIDE_A_LOOP);
    gen_jump(cont_label, cont_depth); expect(';', E_EXPECTED_AFTER_CONTINUE_SEMI);
    break;
  case KW_RETURN: {
    u16 rt = TY_BASE(SY_TYPE(func_sym));
    next();
    if (tok.kind == ';') { if (TK(rt) != T_VOID) cc_error(E_RETURN_NEEDS_A_VALUE); gen_return(0); }
    else {
      n = expr();
      if (TK(rt) == T_VOID) { if (TK(NT(n)) != T_VOID) cc_error(E_RETURN_WITH_A_VALUE_IN_A_VOID_FUNCTION); gen_expr(n); gen_return(0); }
      else gen_return(convert(n, rt, E_RETURN_VALUE_OF_THE_WRONG_TYPE));
      reset_nodes();
    }
    expect(';', E_EXPECTED_AFTER_RETURN_SEMI);
    break;
  }
  case KW_GOTO: {
    u16 name, i;
    next();
    if (tok.kind != TK_ID) cc_error(E_GOTO_NEEDS_A_LABEL);
    name = tok.a; next();
    i = label_find(name);
    if (i < nlabels && LB_DEFINED(i)) gen_jump(LB_LABEL(i), LB_DEPTH(i));
    else {
      if (i == nlabels) label_new(name);
      if (ngotos == CC_GOTOS) cc_error(E_TOO_MANY_GOTOS);
      rec_w16(CC_GOTO_BLOCK, ngotos, 0, name); rec_w16(CC_GOTO_BLOCK, ngotos, 2, gen_label()); rec_w16(CC_GOTO_BLOCK, ngotos, 4, (u16)cg_depth);
      gen_jump(GT_STUB(ngotos), cg_depth);
      ++ngotos;
    }
    expect(';', E_EXPECTED_AFTER_GOTO_SEMI);
    break;
  }
  default:
    if (starts_type(&tok)) cc_error(E_DECLARATION_NEEDS_TO_BE_IN_A_BLOCK);
    expr_statement(); expect(';', E_EXPECTED_SEMI);
  }
  brk_label = sb; cont_label = sc; brk_depth = db; cont_depth = dc;
  leave();
}

void local_declaration(void) {
  u16 base = declspec(); u8 storage = spec_storage;
  if (tok.kind == ';') { next(); return; }
  for (;;) {
    u16 t = declarator(base), name = decl_name, s;
    if (!name) cc_error(E_DECLARATION_NEEDS_A_NAME);
    if (storage == KW_TYPEDEF) sym_add(name, S_TYPEDEF, t);
    else if (storage == KW_EXTERN || TK(t) == T_FUNC) {
      if (storage == KW_STATIC) cc_error(E_STATIC_FUNCTION_IN_A_BLOCK);
      declare_global(name, t, KW_EXTERN);
      if (tok.kind == '=') cc_error(E_EXTERN_IN_A_BLOCK_WITH_AN_INITIALIZER);
    } else if (storage == KW_STATIC) {
      s = sym_add(name, S_STATIC, t);
      SY_LABEL_SET(s, gen_label()); SY_LINKAGE_SET(s, L_INTERNAL);
      define_static(s);
    } else {
      u16 size, i;
      s = sym_add(name, S_LOCAL, t);
      if (tok.kind == '=') {
        next();
        nitems = 0; init_static = 0;
        if (TK(t) == T_ARRAY || TK(t) == T_STRUCT || TK(t) == T_UNION) t = init_any(t, 0);
        else { rec_w16(CC_ITEM_BLOCK, 0, 0, 0); rec_w16(CC_ITEM_BLOCK, 0, 2, convert(assign(), t, E_INITIALIZER_OF_THE_WRONG_TYPE)); nitems = 1; }
        SY_TYPE_SET(s, t);
        if (!is_complete(t)) cc_error2(E_STORAGE_SIZE_UNKNOWN, name);
        size = ty_size(t);
        gen_alloc(size); block_bytes = (u16)(block_bytes + size);
        SY_POS_SET(s, (s16)-cg_depth);
        if (TK(t) == T_ARRAY || TK(t) == T_STRUCT || TK(t) == T_UNION) gen_zero_local(s, size);
        for (i = 0; i < nitems; ++i) {
          u16 v = rec_r16(CC_ITEM_BLOCK, i, 2), dest = nd(N_SYM, NT(v), s, 0), a;
          ND_VAL_SET(dest, rec_r16(CC_ITEM_BLOCK, i, 0));
          if (TK(NT(v)) == T_STRUCT || TK(NT(v)) == T_UNION) ND_TYPE_SET(dest, NT(v));
          a = nd(N_ASSIGN, NT(dest), dest, v);
          gen_expr(a);
        }
        reset_nodes();
      } else {
        if (!is_complete(t)) cc_error2(E_STORAGE_SIZE_UNKNOWN, name);
        size = ty_size(t);
        gen_alloc(size); block_bytes = (u16)(block_bytes + size);
        SY_POS_SET(s, (s16)-cg_depth);
      }
    }
    if (tok.kind != ',') break;
    next();
  }
  expect(';', E_EXPECTED_AFTER_THE_DECLARATION_SEMI);
}

void compound(void) {
  u16 mark = nsyms, bytes = block_bytes;
  next(); // {
  ++block_depth; block_bytes = 0;
  while (tok.kind != '}') {
    if (tok.kind == TK_EOF) cc_error(E_MISSING);
    if (starts_type(&tok) && !(tok.kind == TK_ID && peek()->kind == ':')) local_declaration();
    else statement();
  }
  next();
  if (block_bytes) gen_free(block_bytes);
  scope_pop(mark);  --block_depth; block_bytes = bytes;
}

// ---- the unit ----

void basic_types(void) {
  static const u8 kinds[] = { T_VOID, T_BOOL, T_CHAR, T_SCHAR, T_UCHAR, T_INT, T_UINT, T_LONG, T_ULONG };
  u8 i;
  ntypes = 1;
  for (i = 0; i < sizeof(kinds); ++i) ty_new(kinds[i], 0, 0, 0, 0, i == 0 ? 0 : (kinds[i] >= T_LONG ? 4 : kinds[i] >= T_INT ? 2 : 1));
}

void end_function_labels(void) {
  u16 i;
  for (i = 0; i < nlabels; ++i) if (!LB_DEFINED(i)) cc_error2(E_GOTO_TO_AN_UNDEFINED_LABEL, LB_NAME(i));
  nlabels = ngotos = 0;
}

u8 cc_pass_b(void) {
  u16 i;
  cc_state_load();
  CC_CATCH();
  basic_types();
  nsyms = 1; nnodes = 1; nfields = 0;
  next();
  while (tok.kind != TK_EOF) {
    external_declaration();
    if (nlabels) end_function_labels();
    reset_nodes();
  }
  for (i = 1; i < nsyms; ++i) // tentative definitions
    if (SY_KIND(i) == S_GLOBAL && SY_DEFINED(i) == 1) {
      if (TK(SY_TYPE(i)) == T_ARRAY && TY_COUNT(SY_TYPE(i)) == 0xFFFF) SY_TYPE_SET(i, ty_array(TY_BASE(SY_TYPE(i)), 1));
      tok.kind = 0; define_static(i);
    }
  ir_put8(IR_END);
  cc_st.ntypes = ntypes; cc_st.nfields = nfields; cc_st.nsyms = nsyms; cc_st.nnodes = nnodes;
  cc_state_save();
  return 0;
}

// ---- the statement stream from the parser to the generator ----

void ir_put8(u8 v) {
  u32 n = cc_st.ir_n;
  if (n >= (u32)CC_IR_BLOCKS * 512) cc_error(E_OUTPUT_TOO_LARGE);
  cc_sel((u16)(CC_IR_BLOCK + (u16)(n >> 9)));
  cc_win[(u16)n & 511] = v;
  cc_st.ir_n = n + 1;
}

void ir_put16(u16 v) { ir_put8((u8)v); ir_put8((u8)(v >> 8)); }
