// CC test fixtures: main returns 0, or the line of the first failed CHECK (tests/test_cc.py)
#ifndef CHECK_H
#define CHECK_H
#define CHECK(c) do { if (!(c)) return __LINE__; } while (0)
#define RUN(f) do { int line_ = f(); if (line_) return line_; } while (0)
#endif
