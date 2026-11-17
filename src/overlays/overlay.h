#ifndef FATPAK_OVERLAY_H
#define FATPAK_OVERLAY_H
// Install one host-bound OVL1 image staged in protected PSRAM. LCD and IE must
// be off. No entry in the replaced interval may be on the caller's stack.
// source/offset address the image header. Other fields are loader outputs.
typedef struct {
  unsigned int source, offset, target, length, crc, host;
} OverlayRequest;
extern OverlayRequest overlay_request;
extern unsigned char overlay_live;
extern unsigned int overlay_entry;
#define OVERLAY_OK 0
#define OVERLAY_INVALID 1
#define OVERLAY_BUSY 2
#define OVERLAY_FATAL 3 // restore failed: never call the replaced renderer
unsigned char OverlayInstall(void);
unsigned char OverlayRestore(void);
#endif
