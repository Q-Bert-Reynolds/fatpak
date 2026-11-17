#include "client.h"
#include "../modules/runtime.h"
// Optional bootstrap module: absence or validation/upload failure is silent.
// This check never changes DMG/CGB startup or requires the Gearboy test host.
void SGBBegin(void) {
  if((sys_info&3)!=1) return;
  RUN_MODULE(SGBBOOT);
}
