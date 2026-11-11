#ifndef FATPAK_MODULE_RUNTIME_H
#define FATPAK_MODULE_RUNTIME_H

#include "../../build/modules/modules.h"

// Synchronous, non-nested invocation of /GBCSYS/MODULES/<name>.MOD; prefer
// RUN_MODULE(NAME). Returns 0 when the module ran (its own result is in
// module_status), an FRESULT, MODULE_ERR_ABI or MODULE_ERR_VERIFY.
unsigned char RunModule(const char* path, unsigned char id);
void ShowModuleError(unsigned char result); // for a nonzero RunModule result
extern unsigned char module_busy, module_status;
extern unsigned int module_entry;
extern void* module_context; // set just before RunModule, cleared after: passed to ModuleMain

#endif
