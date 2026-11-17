#ifndef FATPAK_SGB_CLIENT_H
#define FATPAK_SGB_CLIENT_H
void SGBBegin(void);
void SGBProgress(unsigned int loaded, unsigned int total); // sector counts; 0/0 hides progress
extern unsigned char sys_info;
#define SYS_INFO_SGBFS 4
#endif
