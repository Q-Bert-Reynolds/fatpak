char fib(char i) {
    if (i < 2) return i;
    return fib(i-1) + fib(i-2);
}

extern char name_buffer[];
extern void RevealTextAndWait(char drawFlags, char buffer[]);
extern void StringNumber(unsigned long n);

const char some_text[] = "This is a test."
                         "As is this.";

void cFunctionTest(void) {
    char n = fib(11);
    StringNumber(n);
#if LANG_EN
    RevealTextAndWait(1, name_buffer);
#else
    RevealTextAndWait(1, some_text);
#endif
}