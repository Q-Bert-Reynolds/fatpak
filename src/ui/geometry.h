#ifndef FATPAK_UI_GEOMETRY_H
#define FATPAK_UI_GEOMETRY_H

#include "../constants.h"

// Logical geometry. The GB pixel renderer still uses TB_* hardware constants.
extern unsigned char screen_rows;
extern unsigned char screen_width;
extern unsigned char screen_stride;
extern unsigned char screen_header;
extern unsigned char* tile_attrs;
extern unsigned int* screen_offsets;

// Selecting geometry invalidates the overlapping row buffers. Call with the
// renderer stopped and interrupts disabled, then rebuild layout and all rows.
extern void GeometryGB(void);
extern void GeometryWide(void); // 28 rows, 64 chars, 248 text pixels; no backend activation
extern unsigned char* AttrAddress(unsigned char row);

#undef HEADER_LINE
#undef STATUS_LINE
#define HEADER_LINE screen_header
#define STATUS_LINE ((unsigned char)(screen_header + 1))

#endif
