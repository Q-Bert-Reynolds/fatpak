#ifndef FATPAK_MODULE_RUNTIME_H
#define FATPAK_MODULE_RUNTIME_H

// Synchronous, non-nested invocation. Returns FRESULT (module status on success).
unsigned char RunModule(const char* path, unsigned char id);
extern unsigned char module_busy;
extern unsigned int module_entry;

#endif
