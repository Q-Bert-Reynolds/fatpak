// UTF-8 filenames, display conversion and path assembly.
#include "paths.h"
#include "../ui/text.h"
#include "../editor/state.h"
#include "../editor/settings.h"

// UTF-8 to Latin-1 (? for chars it doesn't have), at most count chars, returns the end (no 0)
char* ToLatin1(char* dest, const char* text, unsigned char count) {
  unsigned char c, next;
  while ((c = *text++) && count--) {
    if (c >= 0x80) {
      next = *text;
      if ((c & 0xFE) == 0xC2 && (next & 0xC0) == 0x80) { // U+0080-U+00FF
        ++text;
        c = (c << 6) | (next & 0x3F);
        if (c < 0xA0) c = '?';
      }
      else {
        while ((*text & 0xC0) == 0x80) ++text;
        c = '?';
      }
    }
    *dest++ = c;
  }
  return dest;
}

// Latin-1 to UTF-8, with a 0
void ToUtf8(char* dest, const char* text) {
  unsigned char c;
  while ((c = *text++)) {
    if (c >= 0x80) {
      *dest++ = 0xC0 | (c >> 6);
      c = 0x80 | (c & 0x3F);
    }
    *dest++ = c;
  }
  *dest = 0;
}

// path with a 0, "/" for the root, its end with ... if it's longer than count chars
void PutPath(char* dest, const char* path, unsigned char count) {
  unsigned char length = 0;
  while (path[length]) ++length;
  if (!length) path = "/";
  else if (length > count) {
    dest = PutText(dest, "...");
    path += length - count;
  }
  *ToLatin1(dest, path, count) = 0;
}

// dir + "/" + name with a 0, returns 0 if it doesn't fit in size bytes
unsigned char JoinPath(char* dest, const char* dir, const char* name, unsigned char size) {
  while (*dir) {
    if (!--size) return 0;
    *dest++ = *dir++;
  }
  if (!--size) return 0;
  *dest++ = '/';
  while (*name) {
    if (!--size) return 0;
    *dest++ = *name++;
  }
  *dest = 0;
  return 1;
}

// Keep Save pointed at the same document after moving it or an ancestor.
void FileMoved(const char* source, const char* destination) {
  char old[PATH_SIZE + FS_NAME_SIZE], target[PATH_SIZE + FS_NAME_SIZE];
  unsigned char prefix = 0, size = 0, length = 0, slash = 0;
  JoinPath(old, file_dir, file_name, sizeof(old));
  while (source[prefix] && source[prefix] == old[prefix]) ++prefix;
  if (source[prefix] || (old[prefix] && old[prefix] != '/')) return;
  while (destination[size]) ++size;
  while (old[prefix + length]) ++length;
  if ((unsigned int)size + length >= sizeof(target)) goto unnamed;
  CopyName(PutText(target, destination), old + prefix);
  for (length = 0; target[length]; ++length) if (target[length] == '/') slash = length;
  if (slash >= PATH_SIZE) goto unnamed;
  CopyName(file_name, target + slash + 1);
  target[slash] = 0;
  CopyName(file_dir, target);
  SettingsSave();
  return;
unnamed:
  file_name[0] = 0; // Save As remains available if the new directory is too long
  file_dir[0] = 0;
  SettingsSave();
}
