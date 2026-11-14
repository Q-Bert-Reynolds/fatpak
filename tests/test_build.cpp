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
        if (row(18).find(name) == std::string::npos) for (unsigned r = 0; r < 20; ++r) fprintf(stderr, "%2u|%s\n", r, row(r).c_str());
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
    // the assembly arithmetic (Apply, page 12) reports through Fail (page 13)
    Session d(image, symbols, data, color, "Div.asm", "SECTION \"x\", ROM0[$150]\n db 7 / 2\n db 5 % (2 - 2)\n");
    d.command(4, "Line 3");
    if (d.lines() != "Div.asm|Line 3|DIVIDE BY ZERO") fprintf(stderr, "box: \"%s\"\n", d.lines().c_str());
    Check(d.lines() == "Div.asm|Line 3|DIVIDE BY ZERO", "a division by zero in the assembly arithmetic is an error");
    d.pad(A_Key);
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
    // build.log beside it: each step's time, and a total that agrees with the frames counted here
    std::string log = Text(s.root + "/build.log");
    unsigned minutes = 0, seconds = 0; size_t at = log.find("total");
    if (at != std::string::npos) sscanf(log.c_str() + at + 5, "%u:%u", &minutes, &seconds);
    int total = minutes * 60 + seconds, expected_s = frames / 60;
    if (log.find("the document") != 0 || log.find("\npass 1 ") == std::string::npos || log.find("\n  card ") == std::string::npos ||
        log.find("\npass 2 ") == std::string::npos || log.find("\nfinishing ") == std::string::npos || log.find("built 32 KB") == std::string::npos ||
        total < expected_s - 10 || total > expected_s) fprintf(stderr, "build.log (%u frames):\n%s", frames, log.c_str());
    Check(log.find("\npass 2 ") != std::string::npos && log.find("built 32 KB") != std::string::npos, "build.log has each step");
    Check(total >= expected_s - 10 && total <= expected_s, "build.log's total matches the build's time (less saving, loading the module and writing)");
    s.pad(A_Key);
    printf("%s gbdk.asm with memory1.asm and hardware.inc: %u frames, %u box updates\n", color ? "CGB" : "DMG", frames, s.progress);
}

// A PSRAM copy that fails while the progress box is drawn (ModuleSwapRAM operation op: 32 saves the
// editor's buffers after drawing, 38 brings the module's BSS back) stops the build with COPY FAILED
// op:block, and the editor carries on with its text, instead of restarting the device (which froze a
// GBA SP). Every ModuleCompare of that copy returns "different", from the second draw on.
static void CopyFailure(const char* image, const char* symbols, const char* data, const std::string& src, unsigned op, bool color) {
    Session s(image, symbols, data, color, "gbdk.asm", Text(src + "/gbdk.asm"), {},
              {{"memory1.asm", Text(src + "/memory1.asm")}, {"hardware.inc", Text(src + "/hardware.inc")}});
    std::string first = s.row(0);
    unsigned compare = s.syms.at("ModuleCompare"), operation = s.syms.at("module_operation"), gen = s.syms.at("_render_box_gen");
    s.pad(Start_Key); s.pad(A_Key); for (unsigned i = 0; i < 4; ++i) s.pad(Down_Key);
    s.core.KeyPressed(A_Key); Frames(s.core, 4); s.core.KeyReleased(A_Key);
    auto cpu = s.core.GetProcessor()->GetState();
    unsigned gen0 = s.memory->Read(gen), failed = 0, frames = 0;
    s16 audio[AUDIO_BUFFER_SIZE]; int n;
    while (frames < 6000 && s.row(19).find("COPY FAILED") == std::string::npos) {
        unsigned ticks = 0;
        if (s.core.RunCycle(frame.data(), ticks)) { s.core.EndFrame(audio, &n); ++frames; }
        if (cpu->PC->GetValue() == compare && s.memory->Read(0xBD08) && s.memory->Read(operation) == op &&
            (unsigned)((s.memory->Read(gen) - gen0) & 0xFF) >= 2 && failed < 1000) { // ret nz
            unsigned sp = cpu->SP->GetValue();
            cpu->PC->SetValue(s.memory->Read(sp) | s.memory->Read(sp + 1) << 8);
            cpu->SP->SetValue(sp + 2);
            cpu->AF->SetLow(cpu->AF->GetLow() & 0x7F);
            ++failed;
        }
    }
    Frames(s.core, 10);
    std::string want = "COPY FAILED " + std::to_string(op) + ":0"; // in the status bar
    if (s.row(19).find(want) == std::string::npos) {
        fprintf(stderr, "op %u: box \"%s\" after %u failed compares, %u frames, pc %04x page %u busy %u\n", op, s.lines().c_str(), failed, frames,
                cpu->PC->GetValue(), s.memory->Read(0xBD08), s.memory->Read(s.syms.at("_module_busy")));
        for (unsigned r = 0; r < 20; ++r) fprintf(stderr, "%2u|%s\n", r, s.row(r).c_str());
    }
    Check(s.row(19).find(want) != std::string::npos, "a failed copy in the progress draw stops the build with its message");
    Check(access((s.root + "/gbdk.gb").c_str(), F_OK) != 0, "no ROM is written");
    if (s.row(0) != first) fprintf(stderr, "op %u: row 0 \"%s\"\n", op, s.row(0).c_str());
    Check(s.row(0) == first && s.row(18).find("gbdk.asm") != std::string::npos, "the editor's text and bars come back");
    unsigned before = s.word("_cursor");
    s.pad(Right_Key); s.pad(Right_Key);
    if (s.word("_cursor") != before + 1) fprintf(stderr, "cursor %u then %u\n", before, s.word("_cursor"));
    Check(s.word("_cursor") == before + 1 || s.word("_cursor") == before + 2, "the editor still takes keys"); // the first may only clear the message
    printf("%s a failed copy (operation %u) during a build stops it: %u frames\n", color ? "CGB" : "DMG", op, frames);
}

// Reads long enough that the progress box is drawn between their sectors (ModLoad's ticks): the
// deepest the stack gets. With the include path on the stack it ran past stack_top into
// module_wide, and the next draw went over the module's BSS (NO SECTION). The stack below what
// the editor uses is filled first: some of it must be untouched after.
static void LongReads(const char* image, const char* symbols, const char* data, const std::string& dir, bool color) {
    std::map<std::string, std::string> lib;
    for (unsigned i = 0; i < 3; ++i) lib["huge" + std::to_string(i) + ".bin"] = Text(dir + "/lib/huge" + std::to_string(i) + ".bin");
    Session s(image, symbols, data, color, "Huge.asm", Text(dir + "/Huge.asm"), lib);
    unsigned top = s.syms.at("stack_top"), sp = s.core.GetProcessor()->GetState()->SP->GetValue();
    for (unsigned a = top; a < sp - 64; ++a) s.memory->Write(a, 0xA5);
    unsigned frames = s.command(4, "Built ", 8000);
    unsigned low = top; while (low < sp && s.memory->Read(low) == 0xA5) ++low;
    if (s.lines() != "Huge.gb|Built 32 KB") fprintf(stderr, "box: \"%s\"\n", s.lines().c_str());
    Check(s.lines() == "Huge.gb|Built 32 KB" && Read(s.root + "/Huge.gb") == Read(dir + "/../huge.gb"), "long reads with the box drawn between their sectors build like RGBDS");
    Check(s.progress >= 2, "the box was drawn while files were read");
    Check(low >= top + 64, "the stack keeps 64 bytes from stack_top");
    s.pad(A_Key);
    printf("%s 600 KB of INCBIN files: %u frames, %u box updates, the stack %u bytes from its end\n", color ? "CGB" : "DMG", frames, s.progress, low - top);
}

// project.gbp (tests/asm/project): BUILD from any file builds its main with its rgbasm and rgbfix
// options; an error goes to its line when it's in the open document
static void Project(const char* image, const char* symbols, const char* data, const std::string& dir, const char* expected, bool color) {
    std::string project = Text(dir + "/project.gbp"), root = Text(dir + "/Base.asm");
    std::map<std::string, std::string> lib = {{"main.asm", Text(dir + "/lib/main.asm")}, {"part.asm", Text(dir + "/lib/part.asm")}};
    {
        Session s(image, symbols, data, color, "About.md", "# not assembly\n", lib, {{"project.gbp", project}, {"Base.asm", root}});
        unsigned frames = s.command(4, "Built ");
        if (s.lines() != "game.gb|Built 32 KB") fprintf(stderr, "box: \"%s\"\n", s.lines().c_str());
        Check(s.lines() == "game.gb|Built 32 KB", "BUILD in a markdown file builds the project");
        Check(Read(s.root + "/game.gb") == Read(expected), "the project's ROM matches rgbasm and rgbfix with its options");
        Check(Text(s.root + "/build.log").find("game.gb from project.gbp\n") == 0, "build.log goes beside project.gbp");
        Check(Read(s.root + "/build.cache").size() >= 512, "build.cache goes beside project.gbp");
        s.pad(A_Key);
        unsigned again = s.command(4, "Built ");
        std::string log = Text(s.root + "/build.log");
        if (log.find(", 3 through build.cache") == std::string::npos) fprintf(stderr, "build.log:\n%s", log.c_str());
        Check(log.find(", 3 through build.cache") != std::string::npos, "the next build reads main.asm, part.asm and Base.asm through build.cache");
        Check(Read(s.root + "/game.gb") == Read(expected), "the same ROM through build.cache");
        s.pad(A_Key);
        printf("%s project.gbp builds from About.md: %u frames, again %u through build.cache\n", color ? "CGB" : "DMG", frames, again);
    }
    {
        // an edit after build.cache is written: the build reads the file as it is now
        Session s(image, symbols, data, color, "Base.asm", root, lib, {{"project.gbp", project}});
        s.command(4, "Built ");
        s.pad(A_Key);
        auto key = [&](u8 code) { s.core.QueuePS2KeyboardScanCode(code); Frames(s.core, 4); s.core.QueuePS2KeyboardScanCode(0xF0); s.core.QueuePS2KeyboardScanCode(code); Frames(s.core, 160); };
        key(0x22); key(0x5A); // "x" and a line feed before the first line
        s.command(4, "SAVED"); // BUILD saves the edit first; its message waits for a key, then the build goes on
        s.pad(B_Key);
        for (unsigned f = 0; f < 6000 && s.lines().find("INSTRUCTION") == std::string::npos; ++f) Frames(s.core, 1);
        std::string log = Text(s.root + "/build.log");
        if (s.lines() != "Base.asm|Line 1|BAD INSTRUCTION" || log.find(", 3 through build.cache") == std::string::npos)
            fprintf(stderr, "box: \"%s\"\n%s", s.lines().c_str(), log.c_str());
        Check(s.lines() == "Base.asm|Line 1|BAD INSTRUCTION", "a file edited since build.cache is read as it is");
        Check(log.find(", 3 through build.cache") != std::string::npos, "through its cached entry, which the save kept");
        s.pad(A_Key);
    }
    {
        const std::string bad = root + "DEF Bad EQU Later\n"; // line 3, in the open document
        Session s(image, symbols, data, color, "Base.asm", bad, lib, {{"project.gbp", project}});
        s.command(4, "Line 3");
        if (s.lines() != "Base.asm|Line 3|NOT YET DEFINED") fprintf(stderr, "box: \"%s\"\n", s.lines().c_str());
        Check(s.lines() == "Base.asm|Line 3|NOT YET DEFINED", "a project's error names the included file");
        Check(s.word("_cursor") == bad.find("DEF Bad"), "the cursor goes to the line in the open document");
        Check(Text(s.root + "/build.log").find("stopped: Base.asm line 3: NOT YET DEFINED") != std::string::npos, "build.log says where and why it stopped");
        s.pad(A_Key);
    }
    {
        const std::string bad = "main lib/main.asm\nrgbfix -x\n";
        Session s(image, symbols, data, color, "project.gbp", bad, lib); // it fails before any pass reads Base.asm
        unsigned attrs = s.syms.at("tile_attrs"); // "main" is a keyword (STYLE_PREPROC), its path isn't
        if (s.memory->Read(attrs) >> 4 != 13) fprintf(stderr, "styles %02x %02x\n", s.memory->Read(attrs), s.memory->Read(attrs + 5));
        Check(s.memory->Read(attrs) >> 4 == 13 && s.memory->Read(attrs + 5) >> 4 != 13, "project.gbp's words are highlighted");
        s.command(4, "Line 2");
        if (s.lines() != "project.gbp|Line 2|NOT SUPPORTED") fprintf(stderr, "box: \"%s\"\n", s.lines().c_str());
        Check(s.lines() == "project.gbp|Line 2|NOT SUPPORTED", "an error in project.gbp is reported at its line");
        Check(s.word("_cursor") == bad.find("rgbfix"), "the cursor goes to project.gbp's line");
        Check(access((s.root + "/lib/main.gb").c_str(), F_OK) != 0, "no ROM is written");
        s.pad(A_Key);
    }
    printf("%s project errors passed\n", color ? "CGB" : "DMG");
}

int main(int argc, char** argv) {
    Check(argc == 12, "usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT hello.asm hello.gb tests/asm features.gb src gbdk.gb project.gb huge-folder");
    for (int color = 0; color < 2; ++color) {
        Build(argv[1], argv[2], argv[3], argv[4], argv[5], color);
        Errors(argv[1], argv[2], argv[3], color);
        NotAssembly(argv[1], argv[2], argv[3], color);
        Run(argv[1], argv[2], argv[3], argv[4], argv[5], color);
        std::string work = std::string(argv[7]).substr(0, std::string(argv[7]).find_last_of('/'));
        for (const char* name : {"features", "strings", "loops", "charmap", "sections", "values"}) Sample(argv[1], argv[2], argv[3], argv[6], work, name, color);
        IncludeError(argv[1], argv[2], argv[3], color);
        Library(argv[1], argv[2], argv[3], argv[8], argv[9], color);
        Project(argv[1], argv[2], argv[3], argv[6] + std::string("/project"), argv[10], color);
        for (unsigned op : {32u, 38u}) CopyFailure(argv[1], argv[2], argv[3], argv[8], op, color);
        LongReads(argv[1], argv[2], argv[3], argv[11], color);
    }
}
