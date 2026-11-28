// Large-file mode (src/fatfs/fatfs.c: the piece table, its window in the text buffer, saving)
// against a model: random edits in the window, window moves (commit, load), line starts, line
// counts and saves of a 200 KB file, its bytes compared after each save, then saves of a CR LF
// file. Run with tests/run_large_doc.sh.
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iterator>
#include <map>
#include <string>
#include <vector>
#include <sys/stat.h>
#include <unistd.h>
#include "GearboyCore.h"
#include "Memory.h"
#include "Processor.h"

bool g_mcp_stdio_mode = true;
static std::vector<u16> frame(256 * 224);
static void Check(bool ok, const char* message) { if (!ok) { fflush(stdout); fprintf(stderr, "FAIL: %s\n", message); exit(1); } }
static std::string ReadFile(const std::string& path) {
    std::ifstream file(path.c_str(), std::ios::binary);
    return std::string((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
}
static void WriteFile(const std::string& path, const std::string& bytes) {
    std::ofstream file(path.c_str(), std::ios::binary);
    file.write(bytes.data(), bytes.size());
    Check(file.good(), "write fixture");
}
static std::map<std::string, unsigned> Symbols(const char* path) {
    std::map<std::string, unsigned> result;
    FILE* file = fopen(path, "r"); Check(file, "open symbols");
    char line[512], name[256]; unsigned bank, address;
    while (fgets(line, sizeof(line), file))
        if (sscanf(line, "%x:%x %255s", &bank, &address, name) == 3) result[name] = address;
    fclose(file); return result;
}
static unsigned call_bc, call_sp = 0xDFFE; // (the OS's stack instead for calls that need WRAMX's variables kept)
// an OS routine with DE, BC and A; returns A (BC in call_bc)
static unsigned Call(GearboyCore& core, unsigned address, unsigned de = 0, u8 a = 0, unsigned bc = 0) {
    auto cpu = core.GetProcessor()->GetState(); auto memory = core.GetMemory();
    cpu->SP->SetValue(call_sp); memory->Write(call_sp, 0xFF); memory->Write(call_sp + 1, 0x7F);
    cpu->DE->SetValue(de); cpu->BC->SetValue(bc); cpu->AF->SetValue(a << 8); cpu->PC->SetValue(address);
    for (unsigned i = 0; i < 400000000 && cpu->PC->GetValue() != 0x7FFF; ++i) {
        unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
        if (i % 3000 == 2999) { s16 audio[AUDIO_BUFFER_SIZE]; int n = 0; core.EndFrame(audio, &n); }
    }
    if (cpu->PC->GetValue() != 0x7FFF) fprintf(stderr, "routine %04x stuck at pc %04x page %u\n", address, cpu->PC->GetValue(), memory->Read(0xBD08));
    Check(cpu->PC->GetValue() == 0x7FFF, "OS routine returns");
    call_bc = cpu->BC->GetValue();
    return cpu->AF->GetValue() >> 8;
}

struct Doc {
    GearboyCore core;
    Memory* memory;
    std::map<std::string, unsigned> syms;
    std::string root, model; // the document as it should be
    unsigned long win_start = 0, win_len = 0; // the window: the text buffer's bytes of the document
    bool check_len = true; // doc_len is the model's length (not while CR LF file pieces are in it)
    unsigned sym(const char* name) { return syms.at(name); }
    unsigned long Long(const char* name) { unsigned long n = 0; for (unsigned i = 0; i < 4; ++i) n |= (unsigned long)memory->Read(sym(name) + i) << (8 * i); return n; }
    void SetLong(const char* name, unsigned long n) { for (unsigned i = 0; i < 4; ++i) memory->Write(sym(name) + i, n >> (8 * i)); }
    unsigned Word(const char* name) { return memory->Read(sym(name)) | memory->Read(sym(name) + 1) << 8; }
    void Path(const char* path) { for (unsigned i = 0; i <= strlen(path); ++i) memory->Write(0xDC00 + i, path[i]); }
    unsigned long WinEnd() { return win_start + win_len; }
    void Load(unsigned long start) { win_start = start; win_len = std::min<unsigned long>(0xC000, model.size() - start); } // a load fills the buffer
    // the text buffer holds the model's window
    void CheckWindow(const char* when) {
        std::string text;
        memory->Write(sym("_tb_read_pos"), 0); memory->Write(sym("_tb_read_pos") + 1, 0);
        for (;;) {
            Call(core, sym("_tb_Read"), 0xD800, 0, 1024);
            if (!call_bc) break;
            for (unsigned i = 0; i < call_bc; ++i) text += char(memory->Read(0xD800 + i));
        }
        std::string want = model.substr(win_start, WinEnd() - win_start);
        if (text != want || (check_len && Long("_doc_len") != model.size()) || Long("_win_start") != win_start) {
            size_t i = 0; while (i < text.size() && i < want.size() && text[i] == want[i]) ++i;
            fprintf(stderr, "%s: window %zu bytes, want %zu (first difference at %zu); doc_len %lu, want %zu; win_start %lu, want %lu\n",
                    when, text.size(), want.size(), i, Long("_doc_len"), model.size(), Long("_win_start"), win_start);
            Check(false, "the window, document length and start match the model");
        }
    }
};

// The scroll bar's jumps in a large document (src/editor/window.c's EditorScrollTo, KEY_SCROLL): the window
// moves around the position the thumb was let go at, the top row and cursor at its line's start (the fonts'
// widths are 0 here: rows are lines); its bottom is the end (GoEnd), its top the start
static void ScrollJumps(Doc& d) {
    Memory* m = d.memory;
    call_sp = d.sym("stack_bottom") - 2; // a window load goes deep: not over WRAMX's top, where scroll_range is
    auto jump = [&](unsigned fraction) {
        m->Write(d.sym("_tb_rows"), 16);
        m->Write(d.sym("_tb_row_starts") + 32, 1000 & 255); m->Write(d.sym("_tb_row_starts") + 33, 1000 >> 8); // 1000 bytes on screen
        m->Write(d.sym("_top"), 0); m->Write(d.sym("_top") + 1, 0);
        m->Write(d.sym("scroll_target"), fraction);
        Call(d.core, d.sym("_EditorScrollTo__far"));
        d.Load(d.Long("_win_start"));
        d.CheckWindow("scroll bar jump");
        if (fraction != 255 && d.Word("_top") != d.Word("_cursor")) fprintf(stderr, "fraction %u: top %u cursor %u\n", fraction, d.Word("_top"), d.Word("_cursor"));
        Check(fraction == 255 || d.Word("_top") == d.Word("_cursor"), "the cursor on the top row (the bottom's is GoEnd's, Refresh puts the top)");
    };
    for (unsigned fraction : {128u, 10u, 200u, 1u}) {
        unsigned long largest = d.model.size() - 1000, l = largest; unsigned shifts = 0; // (the length less the text on screen)
        while (l > 0xFFFF) { l >>= 1; ++shifts; }
        unsigned long want = (l * fraction / 255) << shifts, start = d.win_start;
        jump(fraction);
        unsigned long at = d.win_start + d.Word("_cursor"), line = want;
        while (line > d.win_start && d.model[line - 1] != '\n') --line;
        if (at != line) fprintf(stderr, "fraction %u: want %lu, its line %lu, at %lu (window %lu from %lu)\n", fraction, want, line, at, d.win_start, start);
        Check(at == line && want <= d.WinEnd(), "the window has the position, the top row its line's start");
    }
    jump(255);
    Check(d.WinEnd() == d.model.size() && d.Word("_cursor") == d.win_len, "the bar's bottom is the document's end");
    jump(0);
    Check(!d.win_start && !d.Word("_cursor"), "its top the start");
    call_sp = 0xDFFE;
    printf("Large file: scroll bar jumps move the window to the model's positions\n");
}

static void Session(const char* image, const char* symbols) {
    Doc d;
    char folder[] = "/tmp/fatpak-large-XXXXXX"; Check(mkdtemp(folder), "temporary SD");
    d.root = folder;
    srand(11);
    for (unsigned line = 0; d.model.size() < 200000; ++line) { // lines of varied lengths, no CR or 0
        unsigned n = rand() % 120;
        d.model += std::to_string(line) + ":";
        for (unsigned i = 0; i < n; ++i) d.model += char('a' + rand() % 26 + (rand() % 9 == 0 ? ' ' - 'a' : 0));
        d.model += '\n';
        if (line % 97 == 0) d.model += std::string(4500, 'x') + '\n'; // longer than DocLineStart looks back
    }
    WriteFile(d.root + "/Doc.txt", d.model);
    d.core.Init(); d.core.SetEverdriveFolder(folder); Check(d.core.LoadROM(image, false), "large file OS");
    d.memory = d.core.GetMemory(); d.syms = Symbols(symbols);
    Memory* m = d.memory;
    m->Write(0xBD0A, 0xA5); m->Write(0xBD06, 4); m->Write(0xBD08, 4);
    m->Write(d.sym("loaded_bank"), 4); m->Write(0xFFFF, 0); m->Write(0xFF40, 0);
    m->Write(d.sym("far_depth"), 0);
    Call(d.core, d.sym("_GeometryGB")); // the text buffer moves its gap through the layout's scratch, [screen_chunk] at a time
    Check(Call(d.core, d.sym("_FileMount")) == 0, "mount");
    m->Write(d.sym("_doc_large"), 0);
    d.Path("/Doc.txt");
    Check(Call(d.core, d.sym("_FileLoadLarge"), 0xDC00) == 0, "open the large file");
    d.Load(0);
    d.CheckWindow("opened");
    unsigned edits = 0, moves = 0, saves = 0, scans = 0;
    for (unsigned step = 0; step < 400; ++step) {
        unsigned kind = rand() % 100, length = d.WinEnd() - d.win_start;
        if (kind < 55) { // an edit in the window
            unsigned pos = rand() % (length + 1), what = rand() % 3;
            if (what == 0 || length == 0) {
                char c = rand() % 5 ? 'A' + rand() % 26 : '\n';
                Check(Call(d.core, d.sym("_tb_Insert"), pos, c) != 0, "insert");
                d.model.insert(d.win_start + pos, 1, c); ++d.win_len;
            } else if (what == 1 && pos < length) {
                Call(d.core, d.sym("_tb_Delete"), pos);
                d.model.erase(d.win_start + pos, 1); --d.win_len;
            } else if (pos < length) {
                unsigned n = std::min<unsigned>(1 + rand() % 2000, length - pos);
                Call(d.core, d.sym("_tb_DeleteRange"), pos, 0, n);
                d.model.erase(d.win_start + pos, n); d.win_len -= n;
            }
            m->Write(d.sym("_win_edited"), 1);
            ++edits;
        } else if (kind < 80) { // the window moves
            unsigned long start = rand() % (d.model.size() + 1);
            if (rand() % 4 == 0) start = d.model.size() - std::min<size_t>(d.model.size(), rand() % 0xC000); // near the end
            Check(Call(d.core, d.sym("_FileCommitWindow")) == 1, "commit the window");
            d.SetLong("_win_start", start); d.SetLong("_win_mark", 0xFFFFFFFFUL);
            Check(Call(d.core, d.sym("_FileLoadWindow")) == 0, "load the window");
            d.Load(start);
            d.CheckWindow("moved");
            ++moves;
        } else if (kind < 90) { // a line's start, then a line count, of the committed document
            Check(Call(d.core, d.sym("_FileCommitWindow")) == 1, "commit before scanning");
            d.CheckWindow("committed");
            unsigned long pos = rand() % (d.model.size() + 1), want = pos, back = 0;
            for (unsigned long scanned = 0, p = pos; p && scanned < 4096 + 512; ) { // DocLineStart's look-back, a sector at a time
                unsigned long count = p & 511 ? p & 511 : 512;
                if (scanned >= 4096) break;
                bool found = false;
                for (unsigned long i = p; i > p - count; --i) if (d.model[i - 1] == '\n') { want = i; found = true; break; }
                if (found) break;
                p -= count; scanned += count;
                if (!p) want = 0;
            }
            back = pos - want;
            d.SetLong("_doc_pos", pos);
            Call(d.core, d.sym("_DocLineStart"));
            if (d.Long("_doc_pos") != want || d.Word("_doc_back") != back) {
                fprintf(stderr, "DocLineStart from %lu: %lu back %u, want %lu back %lu\n", pos, d.Long("_doc_pos"), d.Word("_doc_back"), want, back);
                Check(false, "DocLineStart matches the model");
            }
            unsigned long target = pos + rand() % 60000; if (target > d.model.size()) target = d.model.size();
            d.SetLong("_scan_pos", pos); d.SetLong("_scan_target", target); d.SetLong("_scan_lines", 0);
            for (unsigned i = 0; i < 10000 && !Call(d.core, d.sym("_FileScanStep")); ++i) {}
            unsigned long lines = 0; for (unsigned long i = pos; i < target; ++i) lines += d.model[i] == '\n';
            Check(d.Long("_scan_pos") == target && d.Long("_scan_lines") == lines, "FileScanStep counts the model's line feeds");
            ++scans;
        } else { // a save, then the file is the model and the window stays at its text
            d.Path("/Doc.txt");
            Check(Call(d.core, d.sym("_FileSaveLarge"), 0xDC00) == 0, "save");
            std::string file = ReadFile(d.root + "/Doc.txt");
            if (file != d.model) {
                size_t i = 0; while (i < file.size() && i < d.model.size() && file[i] == d.model[i]) ++i;
                fprintf(stderr, "saved %zu bytes, want %zu, first difference at %zu\n", file.size(), d.model.size(), i);
                Check(false, "the saved file is the model");
            }
            d.Load(d.win_start); // the window reloads from the new file
            d.CheckWindow("saved");
            ++saves;
        }
    }
    d.Path("/Doc.txt");
    Check(Call(d.core, d.sym("_FileSaveLarge"), 0xDC00) == 0 && ReadFile(d.root + "/Doc.txt") == d.model, "the last save");
    d.Load(d.win_start);
    ScrollJumps(d);
    // (the temporary file can't be checked from here: Gearboy's VirtualFat writes new and changed files to
    // the host folder but never deletes them, so ~EDITOR.TMP stays there after the rename)
    printf("Large file: %u edits, %u window moves, %u line starts and counts, %u saves match the model (%zu bytes)\n",
           edits, moves, scans, saves, d.model.size());
}

// a CR LF file in one window: the window drops the CRs, saving writes one before each line feed
static std::string CRLF(const std::string& text) {
    std::string result;
    for (char c : text) { if (c == '\n') result += '\r'; result += c; }
    return result;
}
static void CRLFSession(const char* image, const char* symbols) {
    Doc d;
    char folder[] = "/tmp/fatpak-large-XXXXXX"; Check(mkdtemp(folder), "temporary SD");
    d.root = folder;
    srand(23);
    for (unsigned line = 0; d.model.size() < 30000; ++line) {
        unsigned n = rand() % 200;
        d.model += std::to_string(line) + ":";
        for (unsigned i = 0; i < n; ++i) d.model += char('a' + rand() % 26);
        d.model += '\n';
    }
    WriteFile(d.root + "/Doc.txt", CRLF(d.model));
    d.core.Init(); d.core.SetEverdriveFolder(folder); Check(d.core.LoadROM(image, false), "large file OS");
    d.memory = d.core.GetMemory(); d.syms = Symbols(symbols);
    Memory* m = d.memory;
    m->Write(0xBD0A, 0xA5); m->Write(0xBD06, 4); m->Write(0xBD08, 4);
    m->Write(d.sym("loaded_bank"), 4); m->Write(0xFFFF, 0); m->Write(0xFF40, 0);
    m->Write(d.sym("far_depth"), 0);
    Call(d.core, d.sym("_GeometryGB"));
    Check(Call(d.core, d.sym("_FileMount")) == 0, "mount");
    m->Write(d.sym("_doc_large"), 0);
    d.Path("/Doc.txt");
    Check(Call(d.core, d.sym("_FileLoadLarge"), 0xDC00) == 0, "open the CR LF file");
    Check(m->Read(d.sym("_fs_crlf")) != 0, "the file uses CR LF");
    d.check_len = false;
    d.Load(0);
    d.CheckWindow("CR LF opened");
    unsigned saves = 0;
    for (unsigned step = 0; step < 120; ++step) {
        unsigned length = d.win_len, pos = rand() % (length + 1);
        if (step % 12 == 11) {
            d.Path("/Doc.txt");
            Check(Call(d.core, d.sym("_FileSaveLarge"), 0xDC00) == 0, "save the CR LF file");
            std::string file = ReadFile(d.root + "/Doc.txt"), want = CRLF(d.model);
            if (file != want) {
                size_t i = 0; while (i < file.size() && i < want.size() && file[i] == want[i]) ++i;
                fprintf(stderr, "saved %zu bytes, want %zu, first difference at %zu\n", file.size(), want.size(), i);
                Check(false, "the saved CR LF file is the model");
            }
            d.Load(0);
            d.CheckWindow("CR LF saved");
            ++saves;
        } else if (rand() % 3 || !length) {
            char c = rand() % 4 ? 'A' + rand() % 26 : '\n';
            Check(Call(d.core, d.sym("_tb_Insert"), pos, c) != 0, "insert");
            d.model.insert(pos, 1, c); ++d.win_len;
        } else if (pos < length) {
            unsigned n = std::min<unsigned>(1 + rand() % 300, length - pos);
            Call(d.core, d.sym("_tb_DeleteRange"), pos, 0, n);
            d.model.erase(pos, n); d.win_len -= n;
        }
        m->Write(d.sym("_win_edited"), 1);
    }
    printf("CR LF file: %u saves match the model (%zu bytes)\n", saves, CRLF(d.model).size());
}

int main(int argc, char** argv) {
    if (argc < 3) { fprintf(stderr, "usage: test_large_doc GBCOS.BIN GBCOS.sym\n"); return 2; }
    CRLFSession(argv[1], argv[2]);
    Session(argv[1], argv[2]);
    return 0;
}
