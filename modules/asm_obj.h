#ifndef FATPAK_MODULE_ASM_OBJ_H
#define FATPAK_MODULE_ASM_OBJ_H
// What ASM.MOD leaves in PSRAM for LINK.MOD (notes/ASSEMBLER.md). Each unit is assembled on its
// own, as rgbasm assembles a file: its sections' bytes (ASM_DATA_BLOCK), and its object
// (ASM_OBJ_BLOCK): patches for every value only the link can know, its section names, labels and
// exported constants. LINK.MOD places the sections, resolves names, patches and writes the image.

// Values are 32 bits and signed, like RGBDS's
#ifdef HOST_TEST
typedef signed Val __attribute__((mode(SI))); // the PC harness builds with -Dint=short
typedef unsigned UVal __attribute__((mode(SI)));
#else
typedef long Val;
typedef unsigned long UVal;
#endif

// sections: 32-byte records in PSRAM from ASM_SECTION_BLOCK, numbered for the whole build
#define ASM_SECTIONS 512
#define SECT_SIZE 32
#define SECT_PER_BLOCK (512 / SECT_SIZE)
#define ROM_BANKS 64 // ASM_IMAGE_BLOCKS / 32
#define SECT_ADDRESS 1 // flags: the address was given
#define SECT_BANK 2 // the bank was given
#define SECT_PLACED 4 // Link placed it
#define SECT_FRAGMENT 8 // SECTION FRAGMENT: later ones with its name continue it
#define SECT_OPEN 16 // pass 2 has opened it
typedef struct {
  unsigned char type, bank, align, flags; // type: index into the region tables (ROM0 ROMX VRAM SRAM WRAM0 WRAMX OAM HRAM)
  unsigned int start, size, base; // the address both passes start it at (the given one, or the region's start), size; Link's address
  unsigned int file; // where it was declared, for errors
  unsigned int line, pos;
  unsigned int ofs; // the alignment's offset: base % (1 << align) == ofs (DS ALIGN tightens both)
  unsigned char align0; // as declared: each pass starts from these
  unsigned char rank; // Link's order, biggest first: rank, then size, then the index
  unsigned int ofs0;
  unsigned int fill; // this pass's address after its last byte so far (FRAGMENTs and POPS go on there)
  unsigned int next; // Link: the next placed section in its bank by address, NO_SECT for none
  unsigned int data; // ROM: the block in ASM_DATA_BLOCK holding its start address's 512 bytes
  unsigned int root; // LINK.MOD: the section a FRAGMENT joins (itself if none)
  unsigned int piece; // and where it starts in it
} Sect;
#define NO_SECT 0xFFFF

// rgbfix's options from project.gbp
typedef struct {
  char title[16], licensee[2], id[4]; // rgbfix -t, -k, -i: only their own characters are written
  unsigned char title_n, licensee_n, id_n;
  unsigned char bytes[8]; // -j $14A, -c/-C $143, -s $146, -l $14B, -m $147, -r $149, -n $14C, -p the padding
  unsigned char given; // a bit for each of bytes[]
} Fix;

// The object stream (ASM_OBJ_BLOCK): each unit's records, which start with a kind: its patches
// (from pass 2), then its section names, labels and EXPORTed constants
#define OBJ_UNIT 0 // the unit's first section (2) and how many (2): the unit's sections below count from it
#define OBJ_PATCH 1 // a section (2), the pass address (2), type (1), file (2), line (2), pos (2), length (1), RPN
#define OBJ_SECTION 2 // a section (2), its name's length and '"' with the name
#define OBJ_LABEL 3 // a section (2), the pass value (2), the name's length and name ("Global.local" for a local)
#define OBJ_CONST 4 // an EXPORTed constant: its value (4), the name's length and name
#define OBJ_END 0xFF
#define PATCH_HEAD 12 // a patch's bytes after its kind, up to the RPN
// a patch's type: the field it fills
#define P_BYTE 0 // db, an 8-bit operand: -128..255
#define P_WORD 1
#define P_LONG 2
#define P_JR 3 // jr's offset to the value
#define P_HRAM 4 // ldh's address: $FF00-$FFFF or 0-$FF, its low byte
#define P_RST 5 // the opcode itself: $C7 | the vector
#define P_SIGNED 6 // sp+e8: -128..127
#define P_ASSERT 7 // no bytes: the value must not be 0
// RPN, postfix: operands
#define RPN_CONST 0x80 // the value (4)
#define RPN_SREL 0x81 // a section of the unit (2) and a pass value in it (4): a label or @, wherever Link puts it
#define RPN_SYM 0x82 // a name's length and the name: another unit's label or exported constant
#define RPN_BANKSECT 0x83 // a section of the unit (2): its bank
#define RPN_BANKSYM 0x84 // a name, as RPN_SYM: its bank
// and operators: Apply's binary ones ('+', 's' for <<, ...), and these unary ones
#define RPN_NEG 'n'
#define RPN_NOT 't' // ~
#define RPN_LNOT 'z' // !
#define RPN_HIGH 'h'
#define RPN_LOW 'w'
#define RPN_SIZE 128 // an expression's RPN at most

// ASM_LINK_BLOCK: what ASM.MOD hands LINK.MOD with the context
typedef struct {
  unsigned char error, error_ch; // ASM.MOD's result (LINK.MOD only writes build.log then), the byte it stopped at
  unsigned int macro_line; // the error was in a macro's body, at this line of it (0: not)
  unsigned int nsects, units, patches; // units: 0 for the document alone
  unsigned int lines; // 64-line steps read, both passes
  unsigned int seconds; // ASM.MOD's own time
  unsigned long card_frames; // its share finding and reading files
  unsigned int files_read, cache_files;
  unsigned int retries; // its PSRAM copies retried
  unsigned char project; // project.gbp built it: context->name is the ROM's path
  Fix fix;
} AsmLink;
#endif
