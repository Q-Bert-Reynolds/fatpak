// Game loading UI and launch orchestration.
#include "loader.h"
#include "../app/dialogs.h"
#include "../browser/paths.h"
#include "../editor/document.h"
#include "../editor/settings.h"
#include "../editor/state.h"
#include "../editor/text_buffer.h"
#include "../fatfs/file_api.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/text.h"


// a .gb or .gbc file
unsigned char IsGame(const char* name) {
  const char* dot = 0;
  for (; *name; ++name) if (*name == '.') dot = name;
  return dot && (dot[1] | 0x20) == 'g' && (dot[2] | 0x20) == 'b' && (!dot[3] || ((dot[3] | 0x20) == 'c' && !dot[4]));
}

// Updates only the loading box: its size stays fixed while the numbers change.
static void ShowGameProgress(char* text) {
  char* end = PutStr(text, S_PART(S_LOADING_KB, 0));
  end = PutStr(PutNumber(end, game_block >> 1), S_PART(S_LOADING_KB, 1));
  PutStr(PutNumber(end, game_blocks >> 1), S_PART(S_LOADING_KB, 2));
  CopyName(render_box_text, text);
  ++render_box_gen;
  EditorDraw();
}

// copies the game to PSRAM and resets the Game Boy into it (see fs_LoadGame), the text and settings go in
// the swap file first, returns if it can't. A large file's unsaved edits can't be kept
void LaunchGame(const char* path) {
  unsigned char result;
  char text[TB_STRIDE];
  const char *basename, *scan;
  if (doc_large) {
    if (!CanDiscard()) return;
    FileCloseLarge();
    tb_Clear();
    file_name[0] = 0;
    modified = 0;
    SettingsSave();
  }
  render_cpu_copy = 1; // keep CGB layout/palettes, draw loading tiles without HDMA
  ShowBusy(Str(S_LOADING));
  if ((result = FileSaveSwap())) {
    render_cpu_copy = 0;
    HideBox();
    ShowError(result, S_DISK_FULL);
    return;
  }
  result = FileGameOpen(path);
  if (!result) {
    GameLoadingBegin();
    // Four-digit KB counts cover every supported ROM; 8 is a widest digit.
    PutStr(PutText(PutStr(PutText(PutStr(text, S_PART(S_LOADING_KB, 0)), "8888"), S_PART(S_LOADING_KB, 1)), "8888"),
           S_PART(S_LOADING_KB, 2));
    render_box_w = RenderTextWidth(text) + BOX_PADDING;
    render_box_x = (TB_WIDTH - render_box_w) >> 1;
    ShowGameProgress(text);
    while (!result && game_block != game_blocks) {
      result = FileGameCopy();
      if (!result) ShowGameProgress(text);
    }
    if (!result) {
      PutStr(render_box_text, S_PREPARING_GAME);
      ++render_box_gen;
      EditorDraw();
      result = FileGameFinish(path);
    }
    if (result) GameLoadingEnd();
  }
  if (result) {
    render_cpu_copy = 0;
    HideBox();
    ShowError(result, S_TOO_BIG);
    Reboot(); // PSRAM's text may be overwritten, booting restores it from the swap file
  }
  // Preserve the basename as pixels before game RAM replaces the editor state.
  basename = path;
  for (scan = path; *scan; ++scan) if (*scan == '/') basename = scan + 1;
  *ToLatin1(text, basename, sizeof(text) - 1) = 0;
  InGameLanguage(); // the menu's text and tiles in the language
  InGameHeader(text);
  GameLaunch();
}
