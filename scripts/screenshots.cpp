// README screenshots: boots the OS in the sibling Gearboy core on a sample SD card, walks to each
// screen at 160x144 (GBC, and DMG), SGB fullscreen 256x224 and 512x448, and to the keyboard and menu
// in each theme. Native pixels go to PPM; SGB LCD recordings go to Mesen.
// usage: screenshots GBCOS.BIN GBCOS.sym EDITOR.DAT MODULES_DIR repo_root out_dir
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <functional>
#include <iterator>
#include <map>
#include <string>
#include <vector>
#include <sys/stat.h>
#include <dirent.h>
#include "GearboyCore.h"
#include "Memory.h"
#include "SGB.h"
#include "FatPakSGBHost.h"

bool g_mcp_stdio_mode = true;
static std::vector<u16> frame(256 * 224);
static const char *image, *symbols, *data, *modules, *repo, *out;

static void Fail(const char* message) { fprintf(stderr, "screenshots: %s\n", message); exit(1); }
static std::vector<u8> Read(const std::string& path) {
    std::ifstream file(path.c_str(), std::ios::binary);
    if (!file) Fail(("can't read " + path).c_str());
    return std::vector<u8>((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
}
static void Write(const std::string& path, const std::string& text) {
    std::ofstream file(path.c_str(), std::ios::binary); file << text;
}
static void Write(const std::string& path, const std::vector<u8>& bytes) {
    std::ofstream file(path.c_str(), std::ios::binary);
    file.write(reinterpret_cast<const char*>(bytes.data()), bytes.size());
}
static std::map<std::string, unsigned> Symbols() {
    std::map<std::string, unsigned> result;
    FILE* file = fopen(symbols, "r"); if (!file) Fail("symbols");
    char line[512], name[256]; unsigned bank, address;
    while (fgets(line, sizeof(line), file))
        if (sscanf(line, "%x:%x %255s", &bank, &address, name) == 3) result[name] = address;
    fclose(file); return result;
}

static const std::vector<const char*>& Themes() {
    static const std::vector<const char*> names = {"Light", "Dark", "Pink", "HighContrast", "Pastel", "Sepia", "Toybox", "Arcade"};
    return names;
}

// the sample card: files are listed folders first, then in the order they're written
static std::string Card(unsigned theme) {
    char folder[] = "/tmp/fatpak-shots-XXXXXX"; if (!mkdtemp(folder)) Fail("temporary SD");
    std::string root(folder);
    mkdir((root + "/GBCSYS").c_str(), 0700); mkdir((root + "/GBCSYS/MODULES").c_str(), 0700);
    Write(root + "/GBCSYS/EDITOR.DAT", Read(data));
    Write(root + "/GBCSYS/SGB.DAT", Read(std::string(modules) + "/../SGB.DAT"));
    DIR* dir = opendir(modules); if (!dir) Fail("modules folder");
    while (dirent* entry = readdir(dir)) {
        std::string name = entry->d_name;
        if (name.size() > 4 && name.substr(name.size() - 4) == ".MOD")
            Write(root + "/GBCSYS/MODULES/" + name, Read(std::string(modules) + "/" + name));
    }
    closedir(dir);
    mkdir((root + "/GBCSYS/LANG").c_str(), 0700); // bin/LANG beside bin/MODULES
    for (const char* name : {"EN.DAT", "ES.DAT"}) Write(root + "/GBCSYS/LANG/" + name, Read(std::string(modules) + "/../LANG/" + name));
    mkdir((root + "/GBCSYS/SYNTAX").c_str(), 0700); // bin/SYNTAX: how code is styled
    if (DIR* syntax = opendir((std::string(modules) + "/../SYNTAX").c_str())) {
        while (dirent* entry = readdir(syntax)) {
            std::string name = entry->d_name;
            if (name.size() > 4 && name.substr(name.size() - 4) == ".SYN")
                Write(root + "/GBCSYS/SYNTAX/" + name, Read(std::string(modules) + "/../SYNTAX/" + name));
        }
        closedir(syntax);
    }
    mkdir((root + "/GBCSYS/THEMES").c_str(), 0700); // data/themes, like make assemble's card
    // Light and the theme to show: the emulated card lists a folder in the host's order, but from Light,
    // SETTINGS > THEME's > is the other of two either way
    for (unsigned i : {0u, theme}) if (!i || i == theme) {
        const char* name = Themes()[i];
        Write(root + "/GBCSYS/THEMES/" + name + ".json", Read(std::string(modules) + "/../../data/themes/" + name + ".json"));
    }
    mkdir((root + "/Games").c_str(), 0700); mkdir((root + "/Notes").c_str(), 0700);
    Write(root + "/Welcome.md",
        "# FatPak\n"
        "Write on your **Game Boy**,\n"
        "right on the EverDrive's SD card.\n"
        "\n"
        "## Features\n"
        "- Styled *markdown*, C and asm\n"
        "- Build and run `.asm` files\n"
        "- Browse, copy and rename files\n"
        "- Launch games with their saves\n"
        "\n"
        "### Typing\n"
        "Use the on-screen keyboard, or\n"
        "plug in a PS/2 keyboard.\n");
    Write(root + "/hello.asm",
        "; Hello, Game Boy\n"
        "INCLUDE \"hardware.inc\"\n"
        "\n"
        "DEF SPEED EQU 2\n"
        "\n"
        "SECTION \"Header\", ROM0[$100]\n"
        "  jp Start\n"
        "  ds $150 - @, 0\n"
        "\n"
        "SECTION \"Main\", ROM0\n"
        "Start:\n"
        "  ld a, LCDCF_ON | LCDCF_BGON\n"
        "  ldh [rLCDC], a\n"
        "  ld hl, Message\n"
        ".loop\n"
        "  halt ; wait for VBlank\n"
        "  jr .loop\n"
        "\n"
        "Message: DB \"Hello!\", 0\n");
    Write(root + "/font.tiles", Read(std::string(repo) + "/img/ui_font.tiles"));
    std::vector<u8> mod = Read(std::string(modules) + "/HEXVIEW.MOD"); mod.resize(512);
    Write(root + "/module.bin", mod);
    return root;
}

// FATPAK_SHOTS_LANG=es: in Spanish (SETTINGS > LANGUAGE), the files end in _es
static bool Spanish() { const char* lang = getenv("FATPAK_SHOTS_LANG"); return lang && !strcmp(lang, "es"); }

enum Mode { DMG, GBC, SGB, SGB512 };
static const char* Suffix(Mode mode) { return mode == DMG ? "_dmg" : mode == GBC ? "_gbc" : mode == SGB ? "_sgb" : "_sgb512"; }

struct Shot {
    GearboyCore core; Memory* memory; std::map<std::string, unsigned> syms; bool color, sgb; Mode mode; std::string recording;
    Shot(Mode mode, unsigned theme = 0) : color(mode != DMG), sgb(mode >= SGB), mode(mode) {
        core.Init(); core.SetEverdriveFolder(Card(theme).c_str()); core.SetPS2KeyboardEnabled(true);
        core.SetForceSGB(sgb);
        if (sgb) core.GetSGB()->GetFatPakHost()->Configure(FatPakSGBHost::TerminalV1);
        if (!core.LoadROM(image, !color && !sgb)) Fail("load OS");
        if (sgb) {
            static unsigned sequence = 0;
            recording = std::string(out) + "/sgb-" + std::to_string(++sequence) + ".fph";
            if (!core.GetSGB()->GetFatPakHost()->SetRecording(recording)) Fail("record SGB frontend");
        }
        memory = core.GetMemory(); syms = Symbols(); Frames(sgb ? 1800 : 600);
        if (sgb && memory->Read(syms.at("_screen_rows")) != 28) Fail("SGB fullscreen startup");
        if (theme) { // browser START > SETTINGS > THEME, > on the theme's row (Card's other theme), then START > CLOSE
            Pad(Start_Key); Pad(Down_Key); Pad(Down_Key); Pad(A_Key); Pad(Down_Key); Pad(A_Key, 180);
            Pad(Right_Key, 120);
            Pad(Start_Key); Pad(Up_Key); Pad(A_Key, 120);
            if (theme == 1 && memory->Read(syms.at("_theme")) != 1) Fail("dark theme");
        }
        if (mode == SGB512) { // START > SETTINGS > RESOLUTION > 512x448
            Pad(Start_Key); Pad(Down_Key); Pad(Down_Key); Pad(A_Key);
            for (unsigned i = 0; i < 7; ++i) Pad(Down_Key, 30);
            Pad(A_Key); Pad(Down_Key); Pad(A_Key, 600);
            if (memory->Read(syms.at("_screen_rows")) != 56) Fail("512x448");
        }
        if (Spanish()) { // START > SETTINGS > LANGUAGE > ESPAÑOL
            Pad(Start_Key); Pad(Down_Key); Pad(Down_Key); Pad(A_Key); Pad(Down_Key); Pad(A_Key); Pad(Down_Key); Pad(A_Key, 180);
            if (memory->Read(syms.at("_language")) != 1) Fail("Spanish");
        }
    }
    void Frames(unsigned count) {
        s16 audio[AUDIO_BUFFER_SIZE];
        while (count--) { int n = 0; core.RunToVBlank(frame.data(), audio, &n); }
    }
    void Pad(Gameboy_Keys key, unsigned wait = 90) {
        if (sgb) {
            auto host=core.GetSGB()->GetFatPakHost(); unsigned bits=((unsigned(key)&15)<<4)|(unsigned(key)>>4);
            if (!host->Inject(9,bits,bits) || !host->Inject(9,0,0)) Fail("SGB pad input");
            Frames(wait+180);
        } else { core.KeyPressed(key); Frames(4); core.KeyReleased(key); Frames(wait); }
    }
    void Key(u8 code, bool extended = false) {
        if (extended) core.QueuePS2KeyboardScanCode(0xE0);
        core.QueuePS2KeyboardScanCode(code); Frames(4);
        if (extended) core.QueuePS2KeyboardScanCode(0xE0);
        core.QueuePS2KeyboardScanCode(0xF0); core.QueuePS2KeyboardScanCode(code); Frames(60);
    }
    std::string Row(unsigned n) {
        std::string s; for (unsigned i = 0; i < 40; ++i) s += char(memory->Read(syms.at("tile_buffer") + n * 40 + i));
        return s;
    }
    // the SGB frontend's selected row (its rows are in PSRAM on the GB side)
    std::string Selected() {
        for (const auto& row : core.GetSGB()->GetFatPakHost()->GetModel().rows)
            if (row.start != row.end) return std::string(row.chars.begin(), row.chars.end());
        return std::string();
    }
    // selects the browser row showing name
    void Select(const std::string& name) {
        for (unsigned tries = 0; tries < 20; ++tries) {
            if (sgb) { if (Selected().find(name) != std::string::npos) return; }
            else for (unsigned r = 0; r < 16; ++r)
                if (Row(r).find(name) != std::string::npos && memory->Read(syms.at("_render_sel") + (r + 1) * 2 + 1) == 0xFF) return;
            Pad(Down_Key, 30);
        }
        Fail(("can't find " + name).c_str());
    }
    void Open(const std::string& name, unsigned wait = 240) { Select(name); Pad(A_Key, wait); }
    void Save(const std::string& name) {
        Frames(sgb ? 240 : 30);
        if (sgb) {
            struct stat status; if (stat(recording.c_str(), &status)) Fail("recording size");
            std::ofstream marks((std::string(out)+"/sgb-shots.tsv").c_str(),std::ios::app);
            marks << recording << '\t' << status.st_size << '\t' << name << Suffix(mode) << (Spanish() ? "_es" : "") << '\n';
            return;
        }
        std::string path = std::string(out) + "/" + name + (name.compare(0, 6, "theme_") ? Suffix(mode) : "") + (Spanish() ? "_es" : "") + ".ppm";
        FILE* f = fopen(path.c_str(), "wb"); if (!f) Fail("write screenshot");
        fprintf(f, "P6 160 144 255\n");
        for (unsigned i = 0; i < 160 * 144; ++i) {
            u16 p = frame[i]; u8 rgb[3] = {u8((p >> 11) << 3 | (p >> 13)), u8(((p >> 5) & 63) << 2 | ((p >> 9) & 3)), u8((p & 31) << 3 | ((p >> 2) & 7))};
            fwrite(rgb, 1, 3, f);
        }
        fclose(f);
    }
};

int main(int argc, char** argv) {
    if (argc != 7) Fail("usage: screenshots GBCOS.BIN GBCOS.sym EDITOR.DAT MODULES_DIR repo_root out_dir");
    image = argv[1]; symbols = argv[2]; data = argv[3]; modules = argv[4]; repo = argv[5]; out = argv[6];
    const char* only = getenv("FATPAK_SHOTS_THEMES"); // set: just the theme gallery
    if (!only || !*only) for (Mode mode : {GBC, DMG, SGB, SGB512}) {
        { Shot s(mode); s.Select("Welcome.md"); s.Save("browser"); }
        { Shot s(mode); s.Select("hello.asm"); s.Pad(Select_Key, 240); s.Save("info"); }
        { Shot s(mode); s.Open("Welcome.md"); s.Save("markdown");
          s.Pad(Select_Key, 120); s.Save("keyboard"); s.Pad(Select_Key, 60);
          s.Pad(Start_Key, 120); s.Save("menu"); }
        { Shot s(mode); s.Open("hello.asm"); s.Save("assembly"); }
        { Shot s(mode); s.Open("module.bin", 300); s.Pad(Right_Key, 30); s.Pad(Down_Key, 60); s.Save("hex"); }
        { Shot s(mode); s.Open("font.tiles", 300); s.Pad(Right_Key, 120); s.Save("tiles"); }
    }
    for (unsigned theme = 0; theme < Themes().size(); ++theme) { // the keyboard with the menu over it
        Shot s(GBC, theme); s.Open("Welcome.md"); s.Pad(Select_Key, 120); s.Pad(Start_Key, 120);
        std::string name = Themes()[theme]; for (char& c : name) c = char(tolower(c));
        s.Save("theme_" + name);
    }
    puts("screenshots written");
}
