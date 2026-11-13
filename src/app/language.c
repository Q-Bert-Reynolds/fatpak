// The UI's language (notes/LANGUAGES.md): English comes with EDITOR.DAT (its tail), the others
// from /GBCSYS/LANG/<code>.DAT. Either is copied to LANG_BLOCK, where PutStr reads it.
#include "language.h"
#include "dialogs.h"
#include "../fatfs/file_api.h"
#include "../editor/settings.h"
#include "../editor/state.h"
#include "../ui/dialogs.h"
#include "../ui/text.h"

static const char codes[] = LANG_CODES;

unsigned char LoadLanguage(void) {
  char path[] = "/GBCSYS/LANG/xx.DAT";
  unsigned char missing = 0;
  if (language >= LANGUAGES) language = 0;
  if (language) {
    path[13] = codes[language << 1];
    path[14] = codes[(language << 1) + 1];
    if (!FileLoadLanguage(path, 0)) return 0;
    language = 0;
    missing = 1;
  }
  if (FileLoadLanguage("/GBCSYS/EDITOR.DAT", DATA_BLOCKS)) lang_count = 0;
  return missing;
}

void LanguageSetup(void) {
  unsigned char choice = Choose(0, S_LANG_EN, LANGUAGES, language);
  if (choice >= BACK || choice == language) return;
  language = choice;
  ShowBusy(Str(S_LOADING));
  if (LoadLanguage()) ShowMessage(Str(S_LANGUAGE_MISSING));
  HideBox();
  SettingsSave();
  dirty = 1; // the bars again, in the new language
}
