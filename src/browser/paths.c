// UTF-8 filenames, display conversion and path assembly.
#include "paths.h"
#include "../ui/text.h"

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
