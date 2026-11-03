// src/editor/undo.c
// Undo log: a ring of records in SRAM banks UNDO_BANK and up, from undo_tail (oldest) to undo_head (the
// current state), then records that can be redone up to undo_top. A record is its header (length, type,
// position), the text it inserted or deleted, then its length again so it can be found from its end.
// Typing a word, holding delete or backspace, merges into one record until the cursor moves.
// NOTE: no static initializers (_GSINIT doesn't run) and no int multiply/divide (no SDCC libs)
#include "editor.h"

#define UNDO_INS    0
#define UNDO_DEL    1
#define UNDO_BACK   2 // deleted with backspace, the text is stored last char first
#define UNDO_JOIN   0x80 // undone and redone with the record before it
#define UNDO_HEADER 5
#define UNDO_EXTRA  7 // header and footer
#define UNDO_NONE   0xFFFF

typedef struct {
  unsigned int length;
  unsigned char type;
  unsigned int pos;
} UndoRecord;

// src/editor/undo.asm
extern unsigned int log_ptr;
extern void log_Write(const void* src, unsigned int count);
extern void log_Read(void* dest, unsigned int count);
extern void log_SaveText(unsigned int pos, unsigned int count);
extern void log_RestoreText(unsigned int pos, unsigned int count);

unsigned int undo_tail;
unsigned int undo_head;
unsigned int undo_top;
unsigned int undo_saved; // undo_head when the text was saved, UNDO_NONE if it can't get back there
unsigned int undo_last; // newest record, rec is its header while undo_merge is set
unsigned char undo_merge;
unsigned char undo_join;
unsigned int undo_cursor;
unsigned char undo_at_save;
UndoRecord rec;

static unsigned int Forward(unsigned int offset, unsigned int count) {
  unsigned int room = UNDO_SIZE - offset;
  return count >= room ? count - room : offset + count;
}

static unsigned int Back(unsigned int offset, unsigned int count) {
  return offset >= count ? offset - count : offset + (UNDO_SIZE - count);
}

// bytes from undo_tail to offset
static unsigned int Used(unsigned int offset) {
  return Back(offset, undo_tail);
}

// drops the oldest records until count more bytes fit after undo_head, returns 0 if they never will
static unsigned char Reserve(unsigned int count) {
  unsigned int length;
  if (count >= UNDO_SIZE) return 0;
  while (count >= UNDO_SIZE - Used(undo_head)) {
    if (undo_tail == undo_saved) undo_saved = UNDO_NONE;
    if (undo_tail == undo_last) undo_merge = 0;
    log_ptr = undo_tail;
    log_Read(&length, 2);
    undo_tail = Forward(undo_tail, length + UNDO_EXTRA);
  }
  return 1;
}

// a new record of count chars at pos, from the text
static void Push(unsigned char type, unsigned int pos, unsigned int count) {
  if (Used(undo_saved) > Used(undo_head)) undo_saved = UNDO_NONE; // it was undone, redo is lost
  undo_top = undo_head;
  if (!Reserve(count + UNDO_EXTRA)) { // too big, older records can't be undone past it
    undo_tail = undo_top = undo_head;
    undo_saved = UNDO_NONE;
    undo_merge = 0;
    return;
  }
  rec.length = count;
  rec.type = type | (undo_join ? UNDO_JOIN : 0);
  rec.pos = pos;
  undo_last = log_ptr = undo_head;
  log_Write(&rec, UNDO_HEADER);
  log_SaveText(pos, count);
  log_Write(&count, 2);
  undo_head = undo_top = log_ptr;
  undo_join = 0;
  undo_merge = count == 1;
}

// returns 1 if the char at pos can be added to the newest record
static unsigned char CanMerge(unsigned char ok) {
  return ok && undo_merge && Reserve(1) && undo_merge;
}

// adds the char at pos to the end of the newest record's text
static void Merge(unsigned int pos) {
  log_ptr = Back(undo_head, 2);
  log_SaveText(pos, 1);
  ++rec.length;
  log_Write(&rec.length, 2);
  undo_head = undo_top = log_ptr;
  log_ptr = undo_last;
  log_Write(&rec, UNDO_HEADER);
}

static unsigned char IsSpace(unsigned char c) {
  return c == ' ' || c == ASCII_LF || c == ASCII_TAB;
}

void undo_Clear(unsigned char modified) {
  undo_tail = undo_head = undo_top = undo_last = 0;
  undo_saved = modified ? UNDO_NONE : 0;
  undo_merge = 0;
  undo_join = 0;
}

// after count chars were inserted at pos
void undo_Inserted(unsigned int pos, unsigned int count) {
  if (CanMerge(count == 1 && !(rec.type & ~UNDO_JOIN) && pos == rec.pos + rec.length &&
               !(pos && IsSpace(tb_GetChar(pos - 1)) && !IsSpace(tb_GetChar(pos))))) Merge(pos); // a word and the spaces after it
  else Push(UNDO_INS, pos, count);
}

// before count chars at pos are deleted
void undo_Deleting(unsigned int pos, unsigned int count) {
  unsigned char type = rec.type & ~UNDO_JOIN;
  if (CanMerge(count == 1 && rec.pos == pos + 1 && (type == UNDO_BACK || (type == UNDO_DEL && rec.length == 1)))) {
    rec.type = (rec.type & UNDO_JOIN) | UNDO_BACK;
    rec.pos = pos;
    Merge(pos);
  }
  else if (CanMerge(count == 1 && type == UNDO_DEL && rec.pos == pos)) Merge(pos);
  else Push(UNDO_DEL, pos, count);
}

void undo_Saved(void) {
  undo_saved = undo_head;
  undo_merge = 0;
}

// inserts the text of rec, log_ptr is at its start
static void Restore(void) {
  unsigned int i;
  unsigned char c;
  if (rec.type & UNDO_BACK) {
    for (i = rec.length; i; --i) {
      log_Read(&c, 1);
      tb_Insert(rec.pos, c);
    }
  }
  else log_RestoreText(rec.pos, rec.length);
}

static void Done(void) {
  undo_merge = 0;
  undo_at_save = undo_head == undo_saved;
}

// undoes the newest record (and the ones joined to it), sets undo_cursor and undo_at_save, returns 0 if there's none
unsigned char undo_Undo(void) {
  if (undo_head == undo_tail) return 0;
  do {
    log_ptr = Back(undo_head, 2);
    log_Read(&rec.length, 2);
    log_ptr = undo_head = Back(undo_head, rec.length + UNDO_EXTRA);
    log_Read(&rec, UNDO_HEADER);
    undo_cursor = rec.pos;
    if (!(rec.type & (UNDO_DEL | UNDO_BACK))) tb_DeleteRange(rec.pos, rec.length);
    else {
      Restore();
      if (rec.type & UNDO_BACK) undo_cursor += rec.length;
    }
  } while ((rec.type & UNDO_JOIN) && undo_head != undo_tail);
  Done();
  return 1;
}

// redoes the record after undo_head (and the ones joined to it)
unsigned char undo_Redo(void) {
  if (undo_head == undo_top) return 0;
  do {
    log_ptr = undo_head;
    log_Read(&rec, UNDO_HEADER);
    undo_cursor = rec.pos;
    if (rec.type & (UNDO_DEL | UNDO_BACK)) tb_DeleteRange(rec.pos, rec.length);
    else {
      log_RestoreText(rec.pos, rec.length);
      undo_cursor += rec.length;
    }
    undo_head = Forward(undo_head, rec.length + UNDO_EXTRA);
    if (undo_head == undo_top) break;
    log_ptr = undo_head;
    log_Read(&rec, UNDO_HEADER);
  } while (rec.type & UNDO_JOIN);
  Done();
  return 1;
}
