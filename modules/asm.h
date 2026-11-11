#ifndef FATPAK_MODULE_ASM_H
#define FATPAK_MODULE_ASM_H
// ASM.MOD's context (notes/ASSEMBLER.md): the host passes the source length, the module reports back.
typedef struct {
  unsigned int length; // in: the text buffer's length
  unsigned int line;   // out: the line an error is on (from 1), or lines assembled
  unsigned int pos;    // out: that line's start, for the cursor
  unsigned int blocks; // out: the ROM image's size in 512-byte blocks from ASM_IMAGE_BLOCK
  unsigned int symbols; // out: labels and constants defined
} AsmContext;

// ModuleMain's result (module_status), 0 when the image is complete
#define ASM_ERR_SYNTAX      1
#define ASM_ERR_SYMBOL      2 // undefined
#define ASM_ERR_DUPLICATE   3
#define ASM_ERR_RANGE       4 // value doesn't fit the operand
#define ASM_ERR_JR          5
#define ASM_ERR_OPERAND     6 // no such form of the instruction
#define ASM_ERR_SECTION     7 // code outside a section, or data in RAM
#define ASM_ERR_FULL        8 // past the section's region
#define ASM_ERR_FORWARD     9 // a size depends on a later symbol
#define ASM_ERR_UNSUPPORTED 10
#define ASM_ERR_NAME        11 // over 32 characters
#define ASM_ERR_DIVIDE      12
#define ASM_ERR_MNEMONIC    13
#define ASM_ERR_PHASE       14 // a label moved between passes (assembler bug)
#define ASM_ERR_STRING      15
#define ASM_ERR_SCOPE       16 // local label before any global one
#define ASM_ERR_SYMBOLS     17 // table full
#define ASM_ERR_EMPTY       18 // nothing in ROM
#define ASM_ERR_BANK        19
#define ASM_ERR_COUNT       19
#endif
