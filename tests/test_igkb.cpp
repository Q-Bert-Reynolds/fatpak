// Driver selection through real menus, serial input, mouse hit testing and cold boot.
#include <cstdio>
#include <algorithm>
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
            const std::map<std::string, std::string>& includes = {}, const std::map<std::string, std::string>& beside = {}, unsigned bad_driver = 0) {
        char folder[] = "/tmp/fatpak-build-XXXXXX"; Check(mkdtemp(folder), "build SD");
        root = folder; mkdir((root + "/GBCSYS").c_str(), 0700);
        Write(root + "/GBCSYS/EDITOR.DAT", Read(data)); InstallModules(root, data);
        Write(root + "/" + name, std::vector<u8>(source.begin(), source.end()));
        if (!includes.empty()) mkdir((root + "/lib").c_str(), 0700);
        for (auto& file : includes) Write(root + "/lib/" + file.first, std::vector<u8>(file.second.begin(), file.second.end()));
        for (auto& file : beside) Write(root + "/" + file.first, std::vector<u8>(file.second.begin(), file.second.end()));
        mkdir((root + "/GBCSYS/DRIVERS").c_str(), 0700);
        std::string driver_bin = std::string(data).substr(0, std::string(data).find_last_of('/')) + "/DRIVERS/";
        for (const char* driver : {"PS2.DRV", "IGKB.DRV"}) {
            auto payload = Read(driver_bin + driver);
            if (!strcmp(driver,"IGKB.DRV") && bad_driver) payload[bad_driver == 1 ? 532 : 14] ^= 1;
            Write(root + "/GBCSYS/DRIVERS/" + driver, payload);
        }
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


static void SelectMenu(Session& s, unsigned type) {
    s.pad(Start_Key); s.pad(Down_Key); s.pad(Down_Key); s.pad(A_Key);
    for (unsigned i=0;i<6;++i) s.pad(Down_Key);
    s.pad(A_Key); Frames(s.core,30);
    unsigned selected=s.memory->Read(s.syms.at("_kb_driver"));
    for (unsigned i=0;i<((type-selected)&3);++i) s.pad(Down_Key);
    s.pad(A_Key); Frames(s.core,240);
 }
static void Select(Session& s,unsigned type) {
    SelectMenu(s,type);
    if(s.memory->Read(s.syms.at("_kb_type"))!=type) fprintf(stderr,"driver wanted%u actual%u box%s busy%u\n",type,s.memory->Read(s.syms.at("_kb_type")),s.lines().c_str(),s.memory->Read(s.syms.at("_module_busy")));
    Check(s.memory->Read(s.syms.at("_kb_type"))==type,"menu activates selected driver");
    Check(s.memory->Read(s.syms.at("_kb_driver"))==type,"selected driver is saved");
    Check(!s.memory->Read(s.syms.at("_module_busy")),"setup module returns");
}
int main(int argc,char** argv) {
    Check(argc==4,"usage: test ROM SYM DATA");
    for(unsigned color=0;color<2;++color) {
        Session s(argv[1],argv[2],argv[3],color,"Typing.txt","abc\ndef\n");
        auto before=Page(s.memory,15);
        s.core.SetIGKBMode(1);
        Select(s,2);
        auto active=Page(s.memory,15);
        Check(before!=active,"selection replaces the driver payload");
        Check(std::vector<u8>(before.begin()+0x580,before.end())==std::vector<u8>(active.begin()+0x580,active.end()),"the rest of page 15 stays intact");
        Check(!s.core.IsPS2KeyboardEnabled() && s.core.GetIGKBMode()==1,"serial devices are exclusive");
        Check(s.core.QueueIGKBKey(4,false) && s.core.QueueIGKBKey(4,true) && s.core.QueueIGKBKey(0x1E,false),"queue manufacturer key bytes");
        Frames(s.core,180);
        if(s.word("_cursor")!=3) fprintf(stderr,"cursor%u row%s\n",s.word("_cursor"),s.row(0).c_str());
        Check(s.word("_cursor")==3 && s.row(0).find("aA1abc")==0,"iGKB serial bytes insert lowercase, uppercase and numbers");
        s.core.QueueIGKBKey(0x2A,false); Frames(s.core,100);
        Check(s.word("_cursor")==2,"iGKB backspace deletes once");
        s.core.QueueIGKBKey(0x7F,false); Frames(s.core,50);
        Check(s.word("_cursor")==2,"unknown adapter bytes are bounded");
        s.core.SetIGKBMode(2); Select(s,3);
        Check(s.core.QueueIGKBMouse(-74,-64,1),"queue mouse move and click"); Frames(s.core,100);
        Check(s.memory->Read(s.syms.at("_mouse_x"))==6 && s.memory->Read(s.syms.at("_mouse_y"))==8,"mouse signs and pixel coordinates decode");
        unsigned anchor=s.word("_cursor");
        Check(s.core.QueueIGKBMouse(18,0,1),"queue drag"); Frames(s.core,100);
        Check(s.memory->Read(s.syms.at("_selecting")) && s.word("_cursor")!=anchor && s.word("_anchor")==anchor,"mouse drag selects text using row hit testing");
        s.core.QueueIGKBMouse(0,0,0); Frames(s.core,30);
        Check(!s.memory->Read(s.syms.at("_mouse_buttons")),"stationary button release reaches the driver");
        s.core.QueueIGKBMouse(127,127,0); Frames(s.core,30);
        Check(s.memory->Read(s.syms.at("_mouse_x"))==151 && s.memory->Read(s.syms.at("_mouse_y"))==135,"$FF movement bytes are valid magnitudes, not idle");
        s.core.QueueIGKBMouse(-127,-127,0); Frames(s.core,30);
        Check(s.memory->Read(s.syms.at("oam_buffer")+9)==32,"mouse pointer uses its own sprite");
        s.core.QueueIGKBMouse(0,0,2); Frames(s.core,100);
        Check(!s.lines().empty(),"right click opens the menu");
        s.core.QueueIGKBMouse(0,0,0); Frames(s.core,30); s.pad(Start_Key);
        Select(s,0);
        unsigned cursor=s.word("_cursor");
        s.core.SetIGKBMode(1); s.core.QueueIGKBKey(4,false); Frames(s.core,80);
        Check(s.word("_cursor")==cursor,"NONE stops peripheral input");
        Select(s,1); s.core.SetPS2KeyboardEnabled(true);
        unsigned insert = s.word("_cursor");
        if (s.memory->Read(s.syms.at("_selecting"))) insert = std::min(insert,s.word("_anchor"));
        s.core.QueuePS2KeyboardScanCode(0x1C); Frames(s.core,100);
        if(s.word("_cursor")!=insert+1) fprintf(stderr,"PS2 cursor%u expected%u type%u SC%02x bytes%u row%s\n",s.word("_cursor"),insert+1,s.memory->Read(s.syms.at("_kb_type")),s.memory->Read(0xFF02),s.memory->Read(s.syms.at("_kb_interrupt_count")),s.row(0).c_str());
        Check(s.word("_cursor")==insert+1,"PS/2 works after swapping back from USB");
        s.core.SetIGKBMode(2); Select(s,3);
        GearboyCore cold; cold.Init(); cold.SetEverdriveFolder(s.root.c_str()); cold.SetIGKBMode(2);
        Check(cold.LoadROM(argv[1],!color),"cold boot selected driver"); Frames(cold,1000);
        Check(cold.GetMemory()->Read(s.syms.at("_kb_type"))==3 && cold.GetMemory()->Read(s.syms.at("_kb_driver"))==3,"cold boot restores selected driver from settings and loads its payload");
        printf("%s driver switching, iGKB typing, mouse click/drag, PS/2 return and saved selection passed\n",color?"CGB":"DMG"); fflush(stdout);
        for(unsigned bad=1;bad<=2;++bad) {
            Session rejected(argv[1],argv[2],argv[3],color,"Reject.txt","safe\n",{}, {},bad);
            auto original=Page(rejected.memory,15);
            SelectMenu(rejected,2);
            Check(rejected.lines().find("MODULE DAMAGED")!=std::string::npos,"reject corrupt or mismatched driver file");
            rejected.pad(A_Key); Frames(rejected.core,50);
            Check(Page(rejected.memory,15)==original && rejected.memory->Read(rejected.syms.at("_kb_type"))==1,"bad driver leaves the active PS/2 payload intact");
        }
        printf("%s corrupt payload and foreign OS driver rejected before replacement\n",color?"CGB":"DMG"); fflush(stdout);

    }
}
