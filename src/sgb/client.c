#include "client.h"
#include "../modules/runtime.h"
// Explicit SETTINGS action; always boot in BIOS mode so test ROMs remain usable.
// Absence or validation/upload failure leaves the original renderer available.
void SGBBegin(void) {
  if((sys_info&7)!=1) return;
  RUN_MODULE(SGBBOOT);
}
