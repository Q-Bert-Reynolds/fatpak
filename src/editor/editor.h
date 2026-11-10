#ifndef FATPAK_EDITOR_EDITOR_H
#define FATPAK_EDITOR_EDITOR_H

#include "../constants.h"

void EditorInit(void); // default editor state, then restored settings
unsigned char GetSelection(void);
unsigned char Copy(void);
void Paste(void);
void UndoRedo(unsigned char redo);
void SelectAll(void);
void Cut(void);
void ToggleWrap(void);
void Editor(void);

extern void EditorSetup(void);
extern void EditorShowCursor(unsigned char show); // uses tb_found_col/row
extern void EditorInvertCursor(unsigned char invert); // white cursor, for the start of a selection

#endif
