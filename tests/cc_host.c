// Runs CC's three passes (modules/cc) on a PC: files, include search, an emulated PSRAM and
// diagnostics; the passes hand over only through that PSRAM. tests/test_cc.py drives it.
// usage: cc_host [-I dir]... [-D name[=value]]... [-u unit] [-M deps] in.c -o out.asm
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../modules/cc/cc.h"

typedef struct { char path[1024]; char* data; long size; int used; } HostFile;
static HostFile files[64];
static const char* include_dirs[32];
static int ninclude;
static FILE* deps;
// PSRAM: one 512-byte window, written back and reloaded at every select, so a pointer kept
// past a select reads the wrong block here as it would on the Game Boy
static unsigned char psram[0x4000 * 512];
static unsigned char window_buf[512];
static long window_block = -1;
u8* cc_win = window_buf;
void cc_sel(u16 block) {
  if (window_block >= 0) memcpy(psram + window_block * 512, window_buf, 512);
  memcpy(window_buf, psram + (long)block * 512, 512);
  window_block = block;
}
static int errors;

static u8 open_path(const char* path) {
  FILE* f = fopen(path, "rb");
  int i;
  if (!f) return 0xFF;
  for (i = 0; i < 64 && files[i].used; ++i) {}
  if (i == 64) { fclose(f); return 0xFF; }
  fseek(f, 0, SEEK_END); files[i].size = ftell(f); fseek(f, 0, SEEK_SET);
  files[i].data = malloc(files[i].size + 1);
  if (fread(files[i].data, 1, files[i].size, f) != (size_t)files[i].size) { fclose(f); free(files[i].data); return 0xFF; }
  fclose(f);
  snprintf(files[i].path, sizeof(files[i].path), "%s", path);
  files[i].used = 1;
  if (deps) fprintf(deps, "%s\n", path);
  return (u8)i;
}
u8 cc_host_open(const char* name, u8 angled, u8 from) {
  char full[2048]; int i; u8 h;
  if (from == 0xFF || name[0] == '/') return open_path(name);
  if (!angled) { // beside the including file
    const char* dir = files[from].path, *slash = strrchr(dir, '/');
    snprintf(full, sizeof(full), "%.*s%s", slash ? (int)(slash - dir + 1) : 0, dir, name);
    if ((h = open_path(full)) != 0xFF) return h;
  }
  for (i = 0; i < ninclude; ++i) {
    snprintf(full, sizeof(full), "%s/%s", include_dirs[i], name);
    if ((h = open_path(full)) != 0xFF) return h;
  }
  return 0xFF;
}
u16 cc_host_read(u8 file, u32 pos, char* dest, u16 n) {
  HostFile* f = &files[file];
  if (pos >= (u32)f->size) return 0;
  if (pos + n > (u32)f->size) n = (u16)(f->size - pos);
  memcpy(dest, f->data + pos, n);
  return n;
}
void cc_host_close(u8 file) { free(files[file].data); files[file].used = 0; }
const char* cc_host_name(u8 file) { return file < 64 && files[file].used ? files[file].path : "?"; }
extern const char* const cc_messages[];
void cc_host_diag(u8 error, const char* file, u16 line, u8 code, const char* extra) {
  const char* message = cc_messages[code];
  if (extra && (code == E_HASH_ERROR_TEXT || code == E_HASH_WARNING_TEXT) && *extra) message = extra, extra = 0;
  fprintf(stderr, "%s:%u: %s: %s%s%s\n", file, line, error ? "error" : "warning", message, extra ? ": " : "", extra ? extra : "");
  if (error) ++errors;
}

int main(int argc, char** argv) {
  const char *in = 0, *out = 0, *unit = 0;
  char unit_buf[64];
  int i;
  memset(psram, 0xA5, sizeof(psram)); // not zero: nothing may rely on it
  cc_pass_a_init(); // keywords first: their ids are fixed
  for (i = 1; i < argc; ++i) {
    if (!strcmp(argv[i], "-I") && i + 1 < argc) include_dirs[ninclude++] = argv[++i];
    else if (!strcmp(argv[i], "-o") && i + 1 < argc) out = argv[++i];
    else if (!strcmp(argv[i], "-u") && i + 1 < argc) unit = argv[++i];
    else if (!strcmp(argv[i], "-M") && i + 1 < argc) deps = fopen(argv[++i], "w");
    else if (!strcmp(argv[i], "-D") && i + 1 < argc) {
      char* def = argv[++i], *eq = strchr(def, '=');
      if (eq) *eq = 0;
      cc_define(def, eq ? eq + 1 : 0);
    } else if (argv[i][0] == '-') { fprintf(stderr, "unknown option %s\n", argv[i]); return 2; }
    else in = argv[i];
  }
  if (!in || !out) { fprintf(stderr, "usage: cc_host [-I dir] [-D name[=value]] [-u unit] [-M deps] in.c -o out.asm\n"); return 2; }
  if (!unit) { // the file's base name, as letters, digits and _
    const char* base = strrchr(in, '/');
    size_t n = 0;
    base = base ? base + 1 : in;
    while (*base && *base != '.' && n < sizeof(unit_buf) - 1) {
      char c = *base++;
      unit_buf[n++] = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') ? c : '_';
    }
    unit_buf[n] = 0; unit = unit_buf;
  }
  if (cc_pass_a(in, unit, 0) || cc_pass_b() || cc_pass_c() || errors) { remove(out); return 1; }
  {
    CcState st;
    FILE* f;
    if (window_block >= 0) memcpy(psram + window_block * 512, window_buf, 512);
    memcpy(&st, psram + (long)CC_STATE_BLOCK * 512, sizeof(st));
    f = fopen(out, "w");
    if (!f) { fprintf(stderr, "can't write %s\n", out); return 1; }
    fprintf(f, "; %s, compiled by CC\n", in);
    fwrite(psram + (long)CC_OUT_BLOCK * 512, 1, st.out_n, f);
    fclose(f);
  }
  if (deps) fclose(deps);
  return 0;
}
