// test.c
// 
// Some simple compiler tests.
// Looking at what gets generated.
// Seeing what I can get away with.

// extern means it's going to look for assembly named _label (notice the underscore)
extern char name_buffer[];// _name_buffer in src/wram.asm
extern void RevealTextAndWait(char drawFlags, char text[]);// _RevealTextAndWait in src/ui.asm
extern void str_Number(unsigned long n);

char fib(char i) {
    if (i < 2) return i;
    return fib(i-1) + fib(i-2);
}

// compiler replaces \n with \x0A, but our newline char is \x80
const char some_text[] = "This is a test.\x80"
                         "As is this.";

void cFunctionTest(void) {
    RevealTextAndWait(1, some_text);
    for (char i = 0; i < 12; i++) {
        str_Number(fib(i));
        RevealTextAndWait(1, name_buffer);
    }
}