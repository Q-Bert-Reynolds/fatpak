#ifndef FATPAK_SGB_CLIENT_H
#define FATPAK_SGB_CLIENT_H
void SGBBegin(void);
unsigned char SGBCells(void); // SETTINGS > RESOLUTION: 512x448 text on or off; 1 if it changed
void SGBCellsMapC(void);
void SGBText(unsigned char mode); // the fullscreen client's TEXT (src/ui/geometry.asm)
void SGBProgress(unsigned int loaded, unsigned int total); // sector counts; 0/0 hides progress
extern unsigned char sys_info;
#define SYS_INFO_SGB 1
#define SYS_INFO_SGBFS 4
// SETTINGS > RESOLUTION, saved (src/sram.asm): the order of S_RES_160's strings is 160, 256, 512
#define RESOLUTION_256 0 // SGB fullscreen, the default
#define RESOLUTION_160 1 // the SGB BIOS's: no takeover at boot
#define RESOLUTION_512 2 // maps and the text (in characters, whatever the font) at 512x448
extern unsigned char resolution;
#endif
