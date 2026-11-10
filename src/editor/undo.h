#ifndef FATPAK_EDITOR_UNDO_H
#define FATPAK_EDITOR_UNDO_H

#include "../constants.h"

extern void UndoClear(unsigned char modified); // forgets the history, modified = the text isn't saved
extern void UndoInserted(unsigned int pos, unsigned int count); // after inserting
extern void UndoDeleting(unsigned int pos, unsigned int count); // before deleting
extern void UndoSaved(void);
extern unsigned char Undo(void); // 0 if there's nothing to undo, sets undo_cursor and undo_at_save
extern unsigned char Redo(void);
extern unsigned char undo_merge; // 0 = the next edit starts a new undo step
extern unsigned char undo_join; // 1 = the next edit is undone with the one before it
extern unsigned int undo_cursor;
extern unsigned char undo_at_save;

#endif
