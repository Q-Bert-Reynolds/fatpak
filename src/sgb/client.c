#include "client.h"
#include "../modules/runtime.h"
// Default SGB startup (unless RESOLUTION is 160x144) and SETTINGS > RESOLUTION > 256x224.
// Absence or validation/upload failure leaves the original renderer available.
void SGBBegin(void) {
  if((sys_info&7)!=1 || resolution == RESOLUTION_160) return;
  RUN_MODULE(SGBBOOT);
}
