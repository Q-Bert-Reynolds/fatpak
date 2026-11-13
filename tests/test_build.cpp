// FILE > BUILD and RUN through ASM.MOD (a wide module) in Gearboy: the ROM written to the
// card matches RGBDS's, errors name the line and move the cursor, RUN reaches the launch,
// and the borrowed second page comes back. Run with tests/run_build.sh.
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <map>
#include <string>
#include <vector>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include "gearboy.h"

bool g_mcp_stdio_mode = true;
static std::vector<u16> frame(256 * 224);
static void Check(bool ok, const char* message) {
    if (!ok) { fflush(stdout); fprintf(stderr, "FAIL: %s\n", message); exit(1); }
}
static std::vector<u8> Read(const std::string& path) {
    std::ifstream file(path, std::ios::binary);
    return std::vector<u8>((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
}
static void Write(const std::string& path, const std::vector<u8>& bytes) {
    std::ofstream file(path, std::ios::binary);
    file.write((const char*)bytes.data(), bytes.size());
    Check(file.good(), "write card file");
}
static std::map<std::string, unsigned> Symbols(const char* path) {
    std::map<std::string, unsigned> result;
    FILE* file = fopen(path, "r"); Check(file, "symbol file");
    char line[512], name[256]; unsigned bank, address;
    while (fgets(line, sizeof(line), file))
        if (sscanf(line, "%x:%x %255s", &bank, &address, name) == 3) result[name] = address;
    fclose(file); return result;
}
static unsigned Bank(const char* path, const char* symbol) {
    FILE* file = fopen(path, "r"); Check(file, "symbol file");
    char line[512], name[256]; unsigned bank = 0, address, found = 0;
    while (fgets(line, sizeof(line), file))
        if (sscanf(line, "%x:%x %255s", &bank, &address, name) == 3 && !strcmp(name, symbol)) { found = bank; break; }
    fclose(file); return found;
}
static void Frames(GearboyCore& core, unsigned count) {
    s16 audio[AUDIO_BUFFER_SIZE];
    while (count--) { int n = 0; core.RunToVBlank(frame.data(), audio, &n); }
}
static std::vector<u8> Page(Memory* m, unsigned page) {
    unsigned old = m->Read(0xBD08); m->Write(0xBD08, page);
    std::vector<u8> bytes(0x1D00);
    for (unsigned i = 0; i < bytes.size(); ++i) bytes[i] = m->Read(0xA000 + i);
    m->Write(0xBD08, old); return bytes;
}
static void InstallModules(const std::string& root, const char* data) {
    std::string bin = std::string(data).substr(0, std::string(data).find_last_of('/')) + "/MODULES/";
    mkdir((root + "/GBCSYS/MODULES").c_str(), 0700);
    DIR* dir = opendir(bin.c_str()); Check(dir, "bin/MODULES"); unsigned count = 0;
    while (dirent* entry = readdir(dir)) {
        std::string name = entry->d_name;
        if (name.size() < 5 || name.substr(name.size() - 4) != ".MOD") continue;
        Write(root + "/GBCSYS/MODULES/" + name, Read(bin + name)); ++count;
    }
    closedir(dir); Check(count >= 6, "every built module installed");
}

struct Session {
    std::string root;
    GearboyCore core;
    Memory* memory;
    std::map<std::string, unsigned> syms;
    unsigned tiles;
    // one source file on a fresh card, opened in the editor; includes go in a "lib" folder
    // (listed after GBCSYS, before the file)
    Session(const char* image, const char* symbols, const char* data, bool color, const char* name, const std::string& source,
            const std::map<std::string, std::string>& includes = {}, const std::map<std::string, std::string>& beside = {}) {
        char folder[] = "/tmp/fatpak-build-XXXXXX"; Check(mkdtemp(folder), "build SD");
        root = folder; mkdir((root + "/GBCSYS").c_str(), 0700);
        Write(root + "/GBCSYS/EDITOR.DAT", Read(data)); InstallModules(root, data);
        Write(root + "/" + name, std::vector<u8>(source.begin(), source.end()));
        if (!includes.empty()) mkdir((root + "/lib").c_str(), 0700);
        for (auto& file : includes) Write(root + "/lib/" + file.first, std::vector<u8>(file.second.begin(), file.second.end()));
        for (auto& file : beside) Write(root + "/" + file.first, std::vector<u8>(file.second.begin(), file.second.end()));
        core.Init(); core.SetEverdriveFolder(folder);
        Check(core.LoadROM(image, !color), "build OS"); Frames(core, 600);
        memory = core.GetMemory(); syms = Symbols(symbols); tiles = syms.at("tile_buffer");
        pad(Down_Key); if (!includes.empty()) pad(Down_Key);
        pad(A_Key); Frames(core, 60); // GBCSYS, lib, then the file
        Check(row(18).find(name) != std::string::npos, "source opens in the editor");
    }
    void pad(Gameboy_Keys key) { core.KeyPressed(key); Frames(core, 4); core.KeyReleased(key); Frames(core, 70); }
    std::string row(unsigned n) {
        std::string s;
        for (unsigned i = 0; i < 40; ++i) { unsigned c = memory->Read(tiles + n * 40 + i); s += c ? char(c) : ' '; } // the footer tick may leave a 0 mid-row
        while (!s.empty() && s.back() == ' ') s.pop_back();
        return s;
    }
    unsigned word(const char* symbol) { unsigned a = syms.at(symbol); return memory->Read(a) | (memory->Read(a + 1) << 8); }
    std::string box() {
        unsigned at = syms.at("_render_box_text"); at = memory->Read(at) | (memory->Read(at + 1) << 8);
        std::string text; while (memory->Read(at)) text += char(memory->Read(at++));
        return memory->Read(syms.at("_render_box_top")) == 255 ? "" : text;
    }
    // the box's lines joined by '|' (BOX_STRIDE chars apart, half rows above and below), "" if it's hidden
    std::string lines() {
        if (box().empty()) return "";
        unsigned at = syms.at("_render_box_text"); at = memory->Read(at) | (memory->Read(at + 1) << 8);
        unsigned count = memory->Read(syms.at("_render_box_rows")) - 2;
        std::string text;
        for (unsigned i = 0; i < count; ++i, at += 20) {
            if (i) text += '|';
            for (unsigned c = at; memory->Read(c); ++c) text += char(memory->Read(c));
        }
        return text;
    }
    // FILE > BUILD (item 4) or RUN (5); returns the frames until the status row or the box shows text,
    // writing: those spent in the "Writing..." box, progress: the box's redraws meanwhile (ModProgress;
    // its text can't be read here, the module's BSS is on it while it runs)
    unsigned writing, progress;
    unsigned command(unsigned item, const char* until, unsigned limit = 4000) {
        pad(Start_Key); pad(A_Key);
        for (unsigned i = 0; i < item; ++i) pad(Down_Key);
        core.KeyPressed(A_Key); Frames(core, 4); core.KeyReleased(A_Key);
        unsigned waited = 0; writing = progress = 0;
        unsigned generation = memory->Read(syms.at("_render_box_gen"));
        while (waited < limit && row(19).find(until) == std::string::npos && lines().find(until) == std::string::npos) {
            Frames(core, 1); ++waited;
            if (box() == "Writing...") ++writing;
            if (memory->Read(syms.at("_render_box_gen")) != generation) { ++progress; generation = memory->Read(syms.at("_render_box_gen")); }
        }
        if (waited < limit) Frames(core, 10); // the rest of the row (DMG draws it over more than a frame)
        if (waited == limit) {
            unsigned box = syms.at("_render_box_text"); box = memory->Read(box) | (memory->Read(box + 1) << 8);
            std::string text; while (memory->Read(box)) text += char(memory->Read(box++));
            fprintf(stderr, "timeout: box '%s' top %u status %u busy %u pc %04x page %u\n", text.c_str(),
                    memory->Read(syms.at("_render_box_top")), memory->Read(syms.at("_module_status")),
                    memory->Read(syms.at("_module_busy")), core.GetProcessor()->GetState()->PC->GetValue(), memory->Read(0xBD08));
            for (unsigned i = 0; i < 20; ++i) fprintf(stderr, "%2u|%s\n", i, row(i).c_str());
        }
        return waited;
    }
};

static void Build(const char* image, const char* symbols, const char* data, const char* source, const char* expected, bool color) {
    std::string text((const char*)Read(source).data(), Read(source).size());
    Session s(image, symbols, data, color, "Hello.asm", text);
    auto page12 = Page(s.memory, 12);
    unsigned frames = s.command(4, "Built ");
    Check(frames < 4000, "BUILD reports the ROM size");
    Check(s.lines() == "Hello.gb|Built 32 KB", "BUILD reports the ROM and its size in a box");
    Check(Page(s.memory, 12) == page12, "the second borrowed page comes back");
    s.pad(A_Key);
    Check(s.box().empty(), "a key closes the result box");
    Check(s.row(0).find("; Hello: a checkerboard.") == 0 && s.row(18).find("Hello.asm") != std::string::npos, "the editor view survives the wide module");
    Check(Read(s.root + "/Hello.gb") == Read(expected), "Hello.gb matches rgbasm, rgblink and rgbfix");
    printf("%s BUILD: %u frames from the keypress to the message, %u of them writing the ROM, %u box updates\n", color ? "CGB" : "DMG", frames, s.writing, s.progress);
}

static void Errors(const char* image, const char* symbols, const char* data, bool color) {
    const std::string bad = "SECTION \"x\", ROM0[$150]\n nop\n jp Nowhere\n ld a, 1\n";
    Session s(image, symbols, data, color, "Bad.asm", bad);
    unsigned frames = s.command(4, "Line 3");
    if (s.lines() != "Bad.asm|Line 3|UNKNOWN SYMBOL") fprintf(stderr, "box: \"%s\"\n", s.lines().c_str());
    Check(frames < 4000 && s.lines() == "Bad.asm|Line 3|UNKNOWN SYMBOL", "an error names its file and line in a box");
    Check(s.word("_cursor") == bad.find(" jp") && s.word("_cursor") == s.word("_anchor"), "the cursor moves to the line");
    s.pad(A_Key);
    Check(access((s.root + "/Bad.gb").c_str(), F_OK) != 0, "no ROM is written for a failed build");
    printf("%s build errors passed\n", color ? "CGB" : "DMG");
}

static void NotAssembly(const char* image, const char* symbols, const char* data, bool color) {
    Session s(image, symbols, data, color, "Note.txt", "just text\n");
    Check(s.command(4, "NOT AN ASM") < 4000, "BUILD on a text file is refused");
    s.pad(A_Key);
    printf("%s BUILD refuses other files\n", color ? "CGB" : "DMG");
}

static void Run(const char* image, const char* symbols, const char* data, const char* source, const char* expected, bool color) {
    std::string text((const char*)Read(source).data(), Read(source).size());
    Session s(image, symbols, data, color, "Hello.asm", text);
    s.pad(Start_Key); s.pad(A_Key);
    for (unsigned i = 0; i < 5; ++i) s.pad(Down_Key);
    s.core.KeyPressed(A_Key); Frames(s.core, 4); s.core.KeyReleased(A_Key);
    auto cpu = s.core.GetProcessor()->GetState();
    bool launched = false;
    unsigned launch = s.syms.at("_GameLaunch"), bank = Bank(symbols, "_GameLaunch"); // a paged address: modules pass it too
    for (unsigned i = 0; i < 60000000 && !launched; ++i) {
        launched = cpu->PC->GetValue() == launch && s.memory->Read(0xBD08) == bank;
        unsigned ticks = 0; s.core.RunCycle(frame.data(), ticks);
        if (i % 3000 == 2999) { s16 audio[AUDIO_BUFFER_SIZE]; int n = 0; s.core.EndFrame(audio, &n); }
    }
    Check(launched, "RUN assembles, writes and launches the ROM");
    Check(Read(s.root + "/Hello.gb") == Read(expected), "RUN wrote the ROM first");
    Check(Read(s.root + "/GBCSYS/EDITOR.SWP").size() > 0, "the editor's state is on the card before the launch");
    printf("%s RUN reaches the launch\n", color ? "CGB" : "DMG");
}

static std::string Text(const std::string& path) { auto bytes = Read(path); return std::string(bytes.begin(), bytes.end()); }

// INCLUDE, IF, REPT and macros on the device: tests/asm/features.asm with its lib/ files
// a sample from tests/asm built on the device, with every file of tests/asm/lib beside it in
// lib/: features.asm (INCLUDE/IF/REPT/MACRO), strings.asm (EQUS, {}), loops.asm (FOR, INCBIN)
static void Sample(const char* image, const char* symbols, const char* data, const std::string& dir,
                   const std::string& work, const char* name, bool color) {
    std::map<std::string, std::string> lib;
    DIR* folder = opendir((dir + "/lib").c_str()); Check(folder, "tests/asm/lib");
    while (dirent* entry = readdir(folder)) if (entry->d_name[0] != '.') lib[entry->d_name] = Text(dir + "/lib/" + entry->d_name);
    closedir(folder);
    std::string file = std::string(name) + ".asm";
    Session s(image, symbols, data, color, file.c_str(), Text(dir + "/" + file), lib);
    unsigned frames = s.command(4, "Built ");
    Check(frames < 4000, "the sample builds");
    Check(Read(s.root + "/" + name + ".gb") == Read(work + "/" + name + ".gb"), "the sample matches RGBDS");
    s.pad(A_Key);
    printf("%s %s.asm: %u frames\n", color ? "CGB" : "DMG", name, frames);
}

// an error inside an included file names the file (wrapped, it's long) and its line, and the cursor goes to the INCLUDE
static void IncludeError(const char* image, const char* symbols, const char* data, bool color) {
    const std::string main = "SECTION \"x\", ROM0[$150]\n nop\nINCLUDE \"lib/bad_include_with_a_long_name.inc\"\n nop\n";
    Session s(image, symbols, data, color, "Main.asm", main, {{"bad_include_with_a_long_name.inc", "; first\n ld a, 1\n ld a, 999\n"}});
    bool named = s.command(4, "Line 3") < 4000 && s.lines() == "bad_include_with_a_|long_name.inc|Line 3|VALUE TOO BIG";
    if (!named) fprintf(stderr, "box: \"%s\"\n", s.lines().c_str());
    Check(named, "an included file's error names it and its line");
    Check(s.word("_cursor") == main.find("INCLUDE"), "the cursor goes to the INCLUDE line");
    s.pad(A_Key);
    printf("%s include errors passed\n", color ? "CGB" : "DMG");
}

// FatPak's gbdk.asm, which includes memory1.asm and hardware.inc by "src/..." paths that resolve
// beside it, all unmodified (memory1.asm's rev_Check_hardware_inc runs hardware.inc's EQUS macro)
static void Library(const char* image, const char* symbols, const char* data, const std::string& src, const char* expected, bool color) {
    std::string memory1 = Text(src + "/memory1.asm");
    Session s(image, symbols, data, color, "gbdk.asm", Text(src + "/gbdk.asm"), {},
              {{"memory1.asm", memory1}, {"hardware.inc", Text(src + "/hardware.inc")}});
    unsigned frames = s.command(4, "Built ", 40000);
    Check(frames < 40000, "gbdk.asm builds");
    Check(s.progress >= frames / 300 - 2, "the box shows progress every 5 s");
    Check(Read(s.root + "/gbdk.gb") == Read(expected), "gbdk.gb matches RGBDS");
    s.pad(A_Key);
    printf("%s gbdk.asm with memory1.asm and hardware.inc: %u frames, %u box updates\n", color ? "CGB" : "DMG", frames, s.progress);
}

int main(int argc, char** argv) {
    Check(argc == 10, "usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT hello.asm hello.gb tests/asm features.gb src gbdk.gb");
    for (int color = 0; color < 2; ++color) {
        Build(argv[1], argv[2], argv[3], argv[4], argv[5], color);
        Errors(argv[1], argv[2], argv[3], color);
        NotAssembly(argv[1], argv[2], argv[3], color);
        Run(argv[1], argv[2], argv[3], argv[4], argv[5], color);
        std::string work = std::string(argv[7]).substr(0, std::string(argv[7]).find_last_of('/'));
        for (const char* name : {"features", "strings", "loops", "charmap", "sections"}) Sample(argv[1], argv[2], argv[3], argv[6], work, name, color);
        IncludeError(argv[1], argv[2], argv[3], color);
        Library(argv[1], argv[2], argv[3], argv[8], argv[9], color);
    }
}
