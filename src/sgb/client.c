#include "client.h"
#include "../modules/runtime.h"
// Default SGB startup and explicit SETTINGS retry after a failed bootstrap.
// Absence or validation/upload failure leaves the original renderer available.
void SGBBegin(void) {
  if((sys_info&7)!=1) return;
  RUN_MODULE(SGBBOOT);
}
