#ifndef FATPAK_SNES_KERNEL_H
#define FATPAK_SNES_KERNEL_H
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
void Capture(void);
void WaitBlank(void);
void __fastcall__ Snapshot(u8 slot);
u8 __fastcall__ FontByte(u16 offset);
void ClearRaster(void);
void EncodeRow(void);
void BlitGlyph(void);
void PpuInit(void);
void OverlayInit(void);
void __fastcall__ PresentOverlay(u8 row);
void __fastcall__ PresentRow(u8 slot);
void PresentPalette(void);
void PresentCursor(void);
void __fastcall__ SetScroll(u16 scroll);
void PublishMailbox(void);
extern volatile u8 capture_ready, capture_last;
extern volatile u16 capture_rows, capture_missed, tick;
extern volatile u16 pad_held[2],pad_edges[2];
extern u8 raster[1024], shade[2048], mailbox[4];
extern u16 palette[16];
extern u8 cursor_row,cursor_x,cursor_look;
#ifdef SNES_TEST
extern u8 test_status[16],test_snapshot[1920];
#define STATUS test_status
#define SNAPSHOT test_snapshot
#else
#define PAGE_A ((volatile u8*)0xC000)
#define PAGE_B ((volatile u8*)0xC780)
#define STATUS ((volatile u8*)0xCF00)
#define SNAPSHOT ((const u8*)0xD100)
#endif
#define FONT_WIDTHS (13u*2048u)
#define FONT_ICONS (FONT_WIDTHS+7u*256u)
#endif
