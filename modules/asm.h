#ifndef FATPAK_MODULE_ASM_H
#define FATPAK_MODULE_ASM_H
// ASM.MOD's context (notes/ASSEMBLER.md): the host passes the source length, the module reports back.
typedef struct {
  unsigned int length; // in: the text buffer's length
  unsigned int line;   // out: the line an error is on (from 1) in its file
  unsigned int pos;    // out: that line's start in the document (the INCLUDE line for an included file), for the cursor
  unsigned int blocks; // out: the ROM image's size in 512-byte blocks from ASM_IMAGE_BLOCK
  unsigned int symbols; // out: labels, constants, macros and includes defined
  unsigned int file;   // out: 0 the document, else the included file's symbol
  char name[65];       // out: then its path as written (the last 64 characters; FS_NAME_SIZE), or after a
                       // project build, the ROM's path from the project's folder
  unsigned char base;  // out: name + base is the file's name without folders
  unsigned char kind;  // in: ASM_DOC if the document is assembly; out: ASM_PROJECT too if project.gbp built it
  unsigned char pass;  // progress (ModProgress(0), while it runs): the pass, file, name and line above,
  unsigned int progress; // and pass 1's lines in thousands or pass 2's percent
} AsmContext;

#define ASM_DOC     1
#define ASM_PROJECT 2
#define ASM_PROJECT_FILE "project.gbp" // BUILD's project: the nearest one in the document's folder or above
#define ASM_NOT_ASM 0xFF // module_status: no project, and the document isn't assembly

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
#define ASM_ERR_NAME        11 // over 79 characters
#define ASM_ERR_DIVIDE      12
#define ASM_ERR_MNEMONIC    13
#define ASM_ERR_PHASE       14 // a label moved between passes (assembler bug)
#define ASM_ERR_STRING      15
#define ASM_ERR_SCOPE       16 // local label before any global one
#define ASM_ERR_SYMBOLS     17 // table full
#define ASM_ERR_EMPTY       18 // nothing in ROM
#define ASM_ERR_BANK        19
#define ASM_ERR_ASSERT      20 // ASSERT false, or FAIL
#define ASM_ERR_FILE        21 // INCLUDE can't open it
#define ASM_ERR_NESTING     22 // frames, IF levels, arguments, includes or sections: too many
#define ASM_ERR_OVERLAP     23 // two sections with addresses overlap
#define ASM_ERR_COUNT       23
#endif
