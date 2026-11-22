// FILE > BUILD on a .c file in Gearboy: CCA.MOD, CCB.MOD and CCC.MOD compile it, ASM.MOD and
// LINK.MOD build the ROM beside it (the runtime from /GBCSYS/CC), and that ROM runs: main
// returns 0 (tests/cc/*.c, as tests/test_cc.py runs them on the PC). An error shows its line
// and C ERROR code, and the cursor goes there. Records the deepest far-call nesting and the
// lowest SP while the compiler runs: the OS's far-call stack has 16 frames and its stack 1 KiB.
// The assembly the modules wrote (at CC_OUT_BLOCK, which ASM.MOD leaves alone) must equal what
// the same compiler wrote on the PC (tests/cc_host.c): that finds SDCC miscompiling the modules.
// Run with tests/run_cc_build.sh.
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
static std::string Text(const std::string& path) { auto b = Read(path); return std::string(b.begin(), b.end()); }
static void Write(const std::string& path, const std::string& bytes) {
    std::ofstream file(path, std::ios::binary);
    file.write(bytes.data(), bytes.size());
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
static void Frames(GearboyCore& core, unsigned count) {
    s16 audio[AUDIO_BUFFER_SIZE];
    while (count--) { int n = 0; core.RunToVBlank(frame.data(), audio, &n); }
}
static void CopyFolder(const std::string& from, const std::string& to, const char* suffix) {
    DIR* dir = opendir(from.c_str()); Check(dir, "a bin folder");
    unsigned count = 0;
    while (dirent* entry = readdir(dir)) {
        std::string name = entry->d_name;
        if (name.size() < strlen(suffix) || name.substr(name.size() - strlen(suffix)) != suffix) continue;
        Write(to + "/" + name, Text(from + "/" + name)); ++count;
    }
    closedir(dir); Check(count > 0, "files copied");
}

struct Session {
    std::string root;
    GearboyCore core;
    Memory* memory;
    std::map<std::string, unsigned> syms;
    unsigned tiles, max_depth = 0, min_sp = 0xFFFF, min_pc = 0, min_page = 0, min_module = 0;
    std::map<unsigned, unsigned> module_sp = {{13, 0xFFFF}, {14, 0xFFFF}, {15, 0xFFFF}, {16, 0xFFFF}}; // the lowest SP in each C module
    std::vector<unsigned> runs; // the modules build() ran, by ID
    // name on a fresh card with EDITOR.DAT, the modules and /GBCSYS/CC; beside: files next to it
    Session(const char* image, const char* symbols, const char* data, bool color, const char* name, const std::string& source,
            const std::map<std::string, std::string>& beside = {}) {
        char folder[] = "/tmp/fatpak-cc-XXXXXX"; Check(mkdtemp(folder), "card folder");
        root = folder;
        std::string bin = std::string(data).substr(0, std::string(data).find_last_of('/'));
        mkdir((root + "/GBCSYS").c_str(), 0700);
        mkdir((root + "/GBCSYS/MODULES").c_str(), 0700);
        mkdir((root + "/GBCSYS/CC").c_str(), 0700);
        mkdir((root + "/GBCSYS/CC/include").c_str(), 0700);
        Write(root + "/GBCSYS/EDITOR.DAT", Text(data));
        CopyFolder(bin + "/MODULES", root + "/GBCSYS/MODULES", ".MOD");
        CopyFolder(bin + "/CC", root + "/GBCSYS/CC", ".asm");
        CopyFolder(bin + "/CC/include", root + "/GBCSYS/CC/include", ".h");
        Write(root + "/" + name, source);
        for (auto& file : beside) Write(root + "/" + file.first, file.second);
        core.Init(); core.SetEverdriveFolder(folder);
        Check(core.LoadROM(image, !color), "the OS");
        Frames(core, 600);
        memory = core.GetMemory(); syms = Symbols(symbols); tiles = syms.at("tile_buffer");
        int first = -1, at = -1; // the list starts with GBCSYS, selected; the card's order isn't the files' creation order
        for (unsigned r = 0; r < 18; ++r) {
            if (first < 0 && row(r).find("GBCSYS") != std::string::npos) first = r;
            if (row(r).find(name) != std::string::npos) at = r;
        }
        Check(first >= 0 && at > first, "the file is listed");
        for (int i = first; i < at; ++i) pad(Down_Key);
        pad(A_Key); Frames(core, 60);
        if (row(18).find(name) == std::string::npos) for (unsigned r = 0; r < 20; ++r) fprintf(stderr, "%2u|%s\n", r, row(r).c_str());
        Check(row(18).find(name) != std::string::npos, "the source opens in the editor");
    }
    void pad(Gameboy_Keys key) { core.KeyPressed(key); Frames(core, 4); core.KeyReleased(key); Frames(core, 70); }
    std::string row(unsigned n) {
        std::string s;
        for (unsigned i = 0; i < 40; ++i) { unsigned c = memory->Read(tiles + n * 40 + i); s += c ? char(c) : ' '; }
        while (!s.empty() && s.back() == ' ') s.pop_back();
        return s;
    }
    unsigned word(const char* symbol) { unsigned a = syms.at(symbol); return memory->Read(a) | (memory->Read(a + 1) << 8); }
    std::string box() {
        unsigned at = syms.at("_render_box_text"); at = memory->Read(at) | (memory->Read(at + 1) << 8);
        std::string text; while (memory->Read(at)) text += char(memory->Read(at++));
        return memory->Read(syms.at("_render_box_top")) == 255 ? "" : text;
    }
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
    // FILE > BUILD (item 4); steps the CPU, keeping the deepest far-call nesting and the lowest SP,
    // until the status row or the box shows text; returns the frames it took
    std::map<unsigned, unsigned long long> prof; // CC_PROFILE: (module << 24 | page << 16 | pc) -> cycles
    unsigned long long total_cycles = 0;
    bool profile = getenv("CC_PROFILE") != nullptr;
    std::map<unsigned, unsigned> swaps; // CC_PROFILE: ModuleSwap ($1xx), ModuleSwapRAM ($2xx) by A, RunModule ($3xx) by ID
    unsigned swap_pc = 0, swap_ram_pc = 0;
    unsigned build(const char* until, bool measure, unsigned limit = 40000) {
        pad(Start_Key); pad(A_Key);
        for (unsigned i = 0; i < 4; ++i) pad(Down_Key);
        core.KeyPressed(A_Key); Frames(core, 4); core.KeyReleased(A_Key);
        auto cpu = core.GetProcessor()->GetState();
        unsigned depth = syms.at("far_depth"), frames = 0, cycles = 0, run_module = syms.at("_RunModule");
        runs.clear();
        swap_pc = syms.at("_ModuleSwap"); swap_ram_pc = syms.at("_ModuleSwapRAM");
        while (frames < limit && row(19).find(until) == std::string::npos && lines().find(until) == std::string::npos) {
            if (!measure) { Frames(core, 10); frames += 10; continue; } // faster: no depth or SP
            unsigned ticks = 0;
            bool vblank = core.RunCycle(frame.data(), ticks);
            unsigned d = memory->Read(depth), sp = cpu->SP->GetValue(), pc = cpu->PC->GetValue();
            if (pc == run_module) runs.push_back(cpu->AF->GetHigh()); // each module run: its ID
            // a C pass's far calls and stack (the OS's fast copies borrow SP; ASM.MOD and LINK.MOD aren't counted)
            if (!runs.empty() && runs.back() >= 13 && runs.back() <= 16 && pc >= 0xA000 && pc < 0xBD00) {
                if (d > max_depth && d < 64) max_depth = d;
                if (sp >= 0xC000 && sp < 0xD000 && sp < min_sp) { min_sp = sp; min_pc = pc; min_page = memory->Read(0xBD08); min_module = runs.back(); }
                if (sp >= 0xD000 && sp < 0xE000 && sp < module_sp[runs.back()]) module_sp[runs.back()] = sp; // its own stack
            }
            if (profile && (pc == swap_pc || pc == swap_ram_pc || pc == run_module)) // operations by kind
                ++swaps[(pc == swap_pc ? 0x100 : pc == swap_ram_pc ? 0x200 : 0x300) | cpu->AF->GetHigh()];
            if (profile) { // CC_PROFILE=1: cycles by module, mapped page and PC
                unsigned module = runs.empty() ? 0 : runs.back(), page = memory->Read(0xBD08);
                if (pc >= 0xA000 && pc < 0xBD00) prof[(module << 24) | (page << 16) | pc] += ticks;
                else prof[(module << 24) | (pc < 0x4000 ? 0xFE0000u : 0xFF0000u) | pc] += ticks;
                total_cycles += ticks;
            }
            cycles += ticks;
            if (vblank || cycles >= 70224) { s16 audio[AUDIO_BUFFER_SIZE]; int n = 0; core.EndFrame(audio, &n); ++frames; cycles = 0; }
        }
        Frames(core, 10);
        return frames;
    }
};

// main's result in a ROM CC built: crt0.asm keeps it at $C000, and $A5 at $C002 when it's done
static int RunROM(const std::string& path, bool color) {
    GearboyCore core;
    core.Init();
    Check(core.LoadROM(path.c_str(), !color), "the built ROM loads");
    Memory* m = core.GetMemory();
    for (unsigned i = 0; i < 600 && m->Read(0xC002) != 0xA5; ++i) Frames(core, 1);
    if (m->Read(0xC002) != 0xA5) return -1;
    return m->Read(0xC000) | (m->Read(0xC001) << 8);
}

static std::string host_dir; // the PC's assembly of each fixture: <name>.asm
// the unit's assembly at CC_OUT_BLOCK ($0200), without the runtime's INCLUDEs
static std::string DeviceAssembly(Memory* memory) {
    std::string text;
    for (unsigned block = 0x200; block < 0x280; ++block) {
        memory->Write(0xBD03, block >> 8); memory->Write(0xBD02, block & 0xFF);
        for (unsigned i = 0; i < 512; ++i) text += char(memory->Read(0xBE00 + i));
        size_t end = text.find("crtend.asm\"\n");
        if (end != std::string::npos) { text.resize(end + 12); break; }
    }
    std::string out; size_t at = 0;
    while (at < text.size()) {
        size_t nl = text.find('\n', at); if (nl == std::string::npos) nl = text.size() - 1;
        std::string line = text.substr(at, nl - at + 1);
        if (line.find("INCLUDE \"GBCSYS/CC/") != 0) out += line;
        at = nl + 1;
    }
    return out;
}
static void Fixture(const char* image, const char* symbols, const char* data, const std::string& dir, const char* name, bool color, bool measure) {
    std::string file = std::string(name) + ".c";
    std::map<std::string, std::string> beside = {{"check.h", Text(dir + "/check.h")}};
    if (!strcmp(name, "preproc")) beside["preproc.h"] = Text(dir + "/preproc.h");
    Session s(image, symbols, data, color, file.c_str(), Text(dir + "/" + file), beside);
    unsigned stack_top = s.syms.at("stack_bottom");
    unsigned frames = s.build("Built ", measure);
    if (s.lines().find("Built ") == std::string::npos) {
        fprintf(stderr, "box: \"%s\" status \"%s\" after %u frames, module_status %u\n", s.lines().c_str(), s.row(19).c_str(),
                frames, s.memory->Read(s.syms.at("_module_status")));
        for (unsigned r = 0; r < 20; ++r) fprintf(stderr, "%2u|%s\n", r, s.row(r).c_str());
    }
    Check(s.lines().find("Built ") != std::string::npos, "the .c file builds");
    {
        std::string device = DeviceAssembly(s.memory), host = Text(host_dir + "/" + name + ".asm");
        host = host.substr(host.find('\n') + 1); // past its first line, the PC's comment
        if (device != host) {
            size_t i = 0, line = 1;
            while (i < device.size() && i < host.size() && device[i] == host[i]) { if (device[i] == '\n') ++line; ++i; }
            size_t from = device.rfind('\n', i) + 1;
            fprintf(stderr, "%s: the device's assembly differs from the PC's at line %zu:\n  device: %s\n  PC:     %s\n", file.c_str(), line,
                    device.substr(from, device.find('\n', from) - from).c_str(), host.substr(from, host.find('\n', from) - from).c_str());
            Write(s.root + "/device.asm", device);
            fprintf(stderr, "all of it: %s/device.asm\n", s.root.c_str());
        }
        Check(device == host, "the modules write the same assembly as the PC");
    }
    int result = RunROM(s.root + "/" + name + ".gb", color);
    if (result) fprintf(stderr, "%s: main returned %d (-1: never finished)\n", file.c_str(), result);
    Check(result == 0, "the ROM CC built on the device runs and main returns 0");
    if (measure) {
        unsigned own[3]; // each pass's own stack (cc_dev_*.c): its top from the module's symbols
        for (unsigned m = 0; m < 3; ++m) {
            std::string sym = std::string(symbols).substr(0, std::string(symbols).find_last_of('/')) + "/../build/modules/CC" + char('A' + m) + "/module.sym";
            auto module = Symbols(sym.c_str());
            unsigned size = m ? 2560 : 1792, top = module.at("_cc_stack") + size;
            own[m] = s.module_sp[13 + m] == 0xFFFF ? 0 : top - s.module_sp[13 + m];
            if (s.module_sp[13 + m] != 0xFFFF) Check(s.module_sp[13 + m] >= module.at("_cc_stack"), "a pass stays in its own stack");
        }
        printf("%s %s: %u frames, far calls %u deep; the OS stack %u bytes deep (of %u, module %u, page %u, pc %04x); own stacks %u, %u, %u\n",
               color ? "CGB" : "DMG", file.c_str(), frames, s.max_depth, stack_top - s.min_sp, stack_top - s.syms.at("stack_top"),
               s.min_module, s.min_page, s.min_pc, own[0], own[1], own[2]);
        Check(s.min_sp >= s.syms.at("stack_top"), "the C modules stay in the OS stack");
        Check(s.max_depth < 16, "the far-call stack (16 frames) holds");
    } else printf("%s %s: %u frames\n", color ? "CGB" : "DMG", file.c_str(), frames);
    if (s.profile) { // raw samples for a script to name (CC_PROFILE=<file>)
        FILE* out = fopen(getenv("CC_PROFILE"), "w");
        if (out) { for (auto& e : s.prof) fprintf(out, "%02x %02x %04x %llu\n", e.first >> 24, (e.first >> 16) & 0xFF, e.first & 0xFFFF, e.second); fclose(out); }
        printf("profile: %llu cycles in %s\n", s.total_cycles, getenv("CC_PROFILE"));
        for (auto& e : s.swaps) printf("  %s %u: %u\n", e.first >> 8 == 1 ? "ModuleSwap" : e.first >> 8 == 2 ? "ModuleSwapRAM" : "RunModule", e.first & 0xFF, e.second);
    }
    s.pad(A_Key);
}

static void ErrorCase(const char* image, const char* symbols, const char* data, bool color) {
    const std::string bad = "int f(int a) { return a; }\nint main(void) {\n  return f(nowhere);\n}\n";
    Session s(image, symbols, data, color, "Bad.c", bad);
    unsigned frames = s.build("C ERROR", true);
    if (s.lines() != "Bad.c|Line 3|C ERROR 80|nowhere") {
        fprintf(stderr, "box: \"%s\" after %u frames, module_status %u, far depth %u, modules run:", s.lines().c_str(), frames,
                s.memory->Read(s.syms.at("_module_status")), s.max_depth);
        for (unsigned id : s.runs) fprintf(stderr, " %u", id);
        fprintf(stderr, "\n");
        for (unsigned a = 0xC000; a < 0xE000; ++a) { // where CCERR.MOD's text went, if anywhere
            std::string t; for (unsigned k = 0; k < 7; ++k) t += char(s.memory->Read(a + k));
            if (t == "C ERROR") { std::string all; for (unsigned k = a; k > a - 40 && k > 0xC000; --k) {} 
                for (unsigned k = a - 24; k < a + 24; ++k) { unsigned c = s.memory->Read(k); all += c >= 32 && c < 127 ? char(c) : '.'; }
                fprintf(stderr, "found at %04x: %s\n", a, all.c_str()); }
        }
        fprintf(stderr, "cursor %u anchor %u\n", s.word("_cursor"), s.word("_anchor"));
        for (unsigned r = 0; r < 20; ++r) fprintf(stderr, "%2u|%s\n", r, s.row(r).c_str());
    }
    Check(s.lines() == "Bad.c|Line 3|C ERROR 80|nowhere", "an error shows its line, code and name");
    Check(s.word("_cursor") == bad.find("  return f"), "the cursor moves to the line");
    s.pad(A_Key);
    Check(access((s.root + "/Bad.gb").c_str(), F_OK) != 0, "no ROM after an error");
    printf("%s C errors passed\n", color ? "CGB" : "DMG");
}

int main(int argc, char** argv) {
    if (argc < 6) { fprintf(stderr, "usage: test_cc_build GBCOS.BIN GBCOS.sym EDITOR.DAT tests/cc host-assembly-dir [fixture...]\n"); return 2; }
    host_dir = argv[5];
    std::vector<std::string> names;
    for (int i = 6; i < argc; ++i) names.push_back(argv[i]);
    const char* models = getenv("CC_MODELS"); // "cgb", "dmg" or both
    if (names.empty()) names = {"arith", "control", "calls", "structs", "globals", "long", "pointers", "preproc", "frames", "misc", "hardware"};
    for (bool color : {true, false}) {
        if (models && strcmp(models, color ? "cgb" : "dmg")) continue;
        ErrorCase(argv[1], argv[2], argv[3], color);
        for (auto& name : names) // control.c nests deepest: measured (CC_MEASURE=1: all)
            Fixture(argv[1], argv[2], argv[3], argv[4], name.c_str(), color, name == "control" || getenv("CC_MEASURE") || getenv("CC_PROFILE"));
    }
    printf("CC on the device: all passed\n");
    return 0;
}
