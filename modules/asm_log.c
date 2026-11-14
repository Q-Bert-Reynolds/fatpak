// ASM.MOD: build.log (see asm_shared.h). Main marks the frames (ModStat) as each step ends, and
// at the end this writes what happened and how long each step took into PSRAM from
// ASM_LOG_BLOCK; the host writes it to build.log beside the project (or the document):
//
//   beisbol.gb from project.gbp
//   pass 1       24:03   ~34816 lines
//     card        9:12   1108 files found and read, 1100 through build.cache
//   sections      0:12   379
//   pass 2       16:02
//   finishing     0:05
//   total        41:40
//   PSRAM copies retried: 0
//   built 512 KB
#include "asm_shared.h"

unsigned int log_marks[LOG_STEPS + 1]; // ModStat seconds at the start and after each step
unsigned char log_steps; // steps finished
static unsigned int log_n;
static const char* const log_names[LOG_STEPS] = {"pass 1    ", "sections  ", "pass 2    ", "finishing "};

static void LogChar(char c) {
  if (log_n == ASM_LOG_BLOCKS * 512) return;
  Window(ASM_LOG_BLOCK + (log_n >> 9));
  WINDOW[log_n & 511] = c;
  ++log_n;
}
static void LogText(const char* s) { while (*s) LogChar(*s++); }
static void LogNumber(unsigned int v) {
  char digits[5];
  unsigned char n = 0;
  do { v = (unsigned int)Div(v, 10); digits[n++] = '0' + (unsigned char)div_rem; } while (v);
  while (n) LogChar(digits[--n]);
}
// seconds as minutes:seconds, the minutes right-aligned in 4 (no SDCC helpers: subtraction)
static void LogTime(unsigned int seconds) {
  unsigned int minutes = 0;
  unsigned char tens = 0;
  for (; seconds >= 60; seconds -= 60) ++minutes;
  for (; seconds >= 10; seconds -= 10) ++tens;
  if (minutes < 1000) LogChar(' ');
  if (minutes < 100) LogChar(' ');
  if (minutes < 10) LogChar(' ');
  LogNumber(minutes);
  LogChar(':');
  LogChar('0' + tens);
  LogChar('0' + (unsigned char)seconds);
  LogText("   ");
}
static unsigned int Stat(unsigned char which) { return (unsigned int)ModStat(which); }

void Log(void) {
  unsigned char i;
  char text[LANG_MAX + 1];
  log_n = 0;
  LogText(main_file ? (const char*)output : "the document");
  LogText(main_file ? " from " ASM_PROJECT_FILE "\n" : "\n");
  for (i = 0; i < log_steps; ++i) {
    LogText(log_names[i]);
    LogTime(log_marks[i + 1] - log_marks[i]);
    if (i == 0 || i == 2) { // Progress counts 64-line steps, and one as the pass starts
      LogChar('~');
      LogNumber((i ? progress_units : pass1_units) - 1 << 6);
      LogText(" lines");
    }
    if (i == 1) LogNumber(nsects);
    LogChar('\n');
    if (i == 0) {
      LogText("  card    ");
      LogTime((unsigned int)Div(*(unsigned long*)card_frames, 60));
      LogNumber(files_read);
      LogText(" files found and read, ");
      LogNumber(cache_files);
      LogText(" through build.cache\n");
    }
  }
  LogText("total     ");
  LogTime(Stat(MODULE_STAT_SECONDS) - log_marks[0]);
  LogText("\nPSRAM copies retried: ");
  LogNumber(Stat(MODULE_STAT_RETRIES));
  LogChar('\n');
  if (error) { // where and why it stopped
    LogText("stopped: ");
    LogText(context->file ? (const char*)context->name : "the document");
    LogText(" line ");
    LogNumber(context->line);
    LogText(": ");
    ModString(text, S_ERR_SYNTAX + error - 1);
    LogText(text);
  }
  else {
    LogText("built ");
    LogNumber(context->blocks >> 1);
    LogText(" KB");
  }
  LogChar('\n');
  context->log_bytes = log_n | 0x8000; // FileWriteImage's count
}
