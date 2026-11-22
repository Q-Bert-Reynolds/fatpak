// What CC's passes and the Game Boy's host (src/editor/build.c) share: the context the host
// hands each pass, and the state at CC_STATE_BLOCK the passes leave (notes/COMPILER.md).
// Plain C types: the OS includes this without the compiler's headers.
#ifndef CC_CTX_H
#define CC_CTX_H
#define CC_OUT_BLOCK      0x0200 // the unit's assembly, ASM.MOD's document (ASM_TEXT)
#define CC_STATE_BLOCK    0x0400 // CcState
#define CC_FILENAME_BLOCK 0x0401 // 64-byte paths by file handle (64 of them): 0 the document
#define CC_WRAP 1 // CcContext.flags: INCLUDE the runtime (/GBCSYS/CC/crt0.asm, ccrt.asm, crtend.asm) around the unit
enum { SINK_CODE, SINK_RODATA, SINK_STR, SINK_DATA, SINK_INIT, SINK_BSS, CC_SINKS }; // the output's order

// what the Game Boy's host (BuildC) hands each module, in the storage of ASM.MOD's AsmContext,
// which CCC.MOD fills in at the end (module_context)
typedef struct {
  unsigned int next;       // out: the module to run next (its ID), 0 when done; first, as AsmContext's length
  char path[32];           // out: its path (/GBCSYS/MODULES/CCERR.MOD is the longest)
  const char* name;        // in: the document's name (the host's file_name)
  char* text;              // in: CCERR.MOD writes the error box's text here (host memory), and
                           // AsmContext's pos and kind for ErrorCursor
} CcContext;

// what the passes hand on, at CC_STATE_BLOCK
typedef struct {
  unsigned char status;    // 0, or the first error's code (cc_msg.h)
  unsigned char err_file;  // its file (a CC_FILENAME_BLOCK record) and line
  unsigned int err_line;
  char err_extra[55];      // the name it's about, or #error's text (CC_NAME_MAX + 1)
  char unit[24];
  unsigned char flags;     // CcContext's
  unsigned int nnames, nstream, next_label, ntypes, nfields, nsyms, nnodes;
  unsigned long heap_n, ir_n;
  unsigned int sink_n[CC_SINKS];
  unsigned char sink_open; // a bit per sink whose section line is written
  unsigned int out_n;      // the assembly's bytes at CC_OUT_BLOCK
} CcState;
#endif
