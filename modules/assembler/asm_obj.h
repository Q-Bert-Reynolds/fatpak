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
#define FILE_UNITS 49152u // ASM.MOD's files table's first symbol: below it, a file is a number in a unit's list

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
#define OBJ_FILE 5 // a file the unit read (2): its symbol in ASM.MOD's files table, or in build.obj its
                   // number in the unit's list (from 1); before the first unit, the prelude's
#define OBJ_KEEP 6 // ASM.MOD's, for an unchanged unit: its number (1); LINK.MOD reads its object in the
                   // last build.obj, its first section in ASM_PREP_BLOCK + 2
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
  unsigned char assembled; // units assembled (the rest came from build.obj)
  unsigned int data_end; // data blocks used, to here
  Fix fix;
} AsmLink;

// build.obj (beside project.gbp): each unit's object as the last build that worked left it, so an
// unchanged unit isn't assembled again. Blocks from its start (ASM_BUILD_BLOCK as it's put
// together, ASM_OLD_BLOCK as it's read): BuildHead and the file lists (the prelude's, each
// unit's) in its first BUILD_HEAD_BLOCKS, all PREP.MOD loads when nothing changed; then the
// section records as ASM.MOD made them (before the link; data counts blocks from build.obj's
// start), the data blocks, then each unit's object stream. A file's
// record: its directory entry's sector (4) and place in it (2), the entry (32), the path's length
// and the path (its symbol's name). An unchanged unit is one whose files' entries all read the
// same (written by the clock: one dated 2026-01-01 00:00, the date without a clock, never is),
// with project.gbp's and the prelude's. With every unit unchanged, and the ROM there with its
// size and dated no earlier than build.obj (both by the clock), the build is up to date: neither
// module runs (ASM_CURRENT).
#define OBJ_MAGIC 0x4F4B5046UL // "FPKO"
#define OBJ_VERSION 2
#define FILE_RECORD 38 // a file record's bytes before its path
typedef struct {
  unsigned int first, n; // its sections (in build.obj's section records)
  unsigned int data, data_n; // its data blocks: the first (from build.obj's start), how many
  UVal obj, obj_n; // its object stream: from build.obj's start, bytes
  UVal files; // its file list, from build.obj's start
  unsigned char files_n;
} BuildUnit;
#define BUILD_HEAD_BLOCKS 64 // the head and file lists (beisbol's 348 files' are 22 KB)
typedef struct {
  UVal magic;
  unsigned char version, units;
  unsigned int nsects; // section records, from block BUILD_HEAD_BLOCKS
  unsigned int data; // the data blocks' first block in build.obj
  UVal size; // build.obj's bytes
  unsigned char project[FILE_RECORD]; // project.gbp's record (no path)
  UVal prelude; // the prelude's file list
  unsigned char prelude_n;
  unsigned int rom_blocks; // the ROM's size
  char output[65]; // its path from project.gbp's folder (AsmContext's name)
  BuildUnit unit[63];
} BuildHead;

// ASM_PREP_BLOCK: LINK.MOD's check, before ASM.MOD; the second block has each unchanged unit's
// sections (an unsigned int each), the third its first section's number (ASM.MOD's Keep)
typedef struct {
  unsigned char valid; // build.obj is at ASM_OLD_BLOCK, and these are good
  unsigned char all_clean; // no unit is assembled (nor the prelude)
  unsigned char clean[8]; // a bit for each unchanged unit
} AsmPrep;
#endif
