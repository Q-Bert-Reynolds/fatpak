#ifndef FATPAK_MODULE_TEXT_H
#define FATPAK_MODULE_TEXT_H
// Text building for modules. No SDCC arithmetic helpers: modules can't import them.
char* PutText(char* dest, const char* text);
char* PutNumber(char* dest, unsigned long n); // decimal, no leading zeros
char* PutNumber2(char* dest, unsigned char n); // two digits, n < 100
char* PutHex(char* dest, unsigned char n);
#endif
