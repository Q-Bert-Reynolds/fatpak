// initialized data, const data in ROM, static locals, tentative definitions, strings
#include "check.h"
int zero;
int tentative;
int tentative;
int five = 5;
unsigned char bytes[] = { 1, 2, 3 };
const int table[4] = { 10, 20, 30, 40 };
const char* const names[] = { "zero", "one", "two" };
char greeting[] = "hi!";
char sized[8] = "ab";
int* ptr = &five;
const int* mid = &table[0] + 2 - 2 + 0;
const int* tp = table + 2;
long big = -100000l;
struct pair { char a; int b; } pairs[2] = { { 'p', 300 }, { 'q', -1 } };
static int hidden = 12;
static int bump(void) { static int n = 100; static int m; m += 2; return ++n + m; }
int main(void) {
  CHECK(zero == 0 && tentative == 0); CHECK(five == 5);
  CHECK(sizeof(bytes) == 3 && bytes[2] == 3);
  CHECK(table[3] == 40); CHECK(names[2][1] == 'w'); CHECK(names[0][4] == 0);
  CHECK(sizeof(greeting) == 4 && greeting[2] == '!'); CHECK(sized[1] == 'b' && sized[2] == 0 && sized[7] == 0);
  CHECK(*ptr == 5); CHECK(*tp == 30); CHECK(big == -100000l); CHECK(hidden == 12);
  CHECK(pairs[0].a == 'p' && pairs[0].b == 300 && pairs[1].b == -1 && pairs[1].a == 'q');
  CHECK(bump() == 103); CHECK(bump() == 106); CHECK(*mid == 10);
  five = 6; CHECK(*ptr == 6);
  greeting[0] = 'H'; CHECK(greeting[0] == 'H');
  CHECK((unsigned)table < 0x8000 && (unsigned)names < 0x8000); // ROM
  CHECK((unsigned)&five >= 0xC000);
  tentative = 3; CHECK(tentative == 3);
  return 0;
}
