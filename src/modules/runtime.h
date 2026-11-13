#ifndef FATPAK_MODULE_RUNTIME_H
#define FATPAK_MODULE_RUNTIME_H

#include "../../build/modules/modules.h"

// Synchronous, non-nested invocation of /GBCSYS/MODULES/<name>.MOD; prefer
// RUN_MODULE(NAME). Returns 0 when the module ran (its own result is in
// module_status), an FRESULT, MODULE_ERR_ABI or MODULE_ERR_VERIFY.
unsigned char RunModule(const char* path, unsigned char id);
void ShowModuleError(unsigned char result);
void ShowModuleRestart(void); // at startup: a restore that failed before the last restart // for a nonzero RunModule result
extern unsigned char module_busy, module_status;
extern unsigned int module_entry;
extern unsigned char file_level; // ModFile/ModLoad: the folder level (characters of file_dir) of the first file found
extern void (*module_progress)(char* text); // set with module_context: the text for ModProgress(0)
extern void* module_context; // set just before RunModule, cleared after: passed to ModuleMain

#endif
