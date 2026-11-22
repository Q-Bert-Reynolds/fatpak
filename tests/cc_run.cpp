// Runs a ROM built by CC (modules/cc/rt/crt0.asm) in Gearboy until main returns, then
// prints "exit <value>"; or "timeout pc=<pc>" if it doesn't within the frame limit.
// usage: cc_run rom.gb rom.sym [frames] [dmg|cgb] [symbol bytes]...  (symbols: dumped as hex)
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <map>
#include <string>
#include <vector>
#include "gearboy.h"

bool g_mcp_stdio_mode = true;

static std::map<std::string, unsigned> Symbols(const char* path) {
    std::map<std::string, unsigned> result;
    FILE* file = fopen(path, "r");
    if (!file) { fprintf(stderr, "no symbol file %s\n", path); exit(2); }
    char line[512], name[256]; unsigned bank, address;
    while (fgets(line, sizeof(line), file))
        if (sscanf(line, "%x:%x %255s", &bank, &address, name) == 3) result[name] = address;
    fclose(file);
    return result;
}

int main(int argc, char** argv) {
    if (argc < 3) { fprintf(stderr, "usage: cc_run rom.gb rom.sym [frames] [dmg|cgb] [symbol bytes]...\n"); return 2; }
    std::map<std::string, unsigned> syms = Symbols(argv[2]);
    unsigned limit = argc > 3 ? atoi(argv[3]) : 600;
    bool dmg = argc > 4 && !strcmp(argv[4], "dmg");
    if (!syms.count("_cc_done") || !syms.count("_cc_exit")) { fprintf(stderr, "no _cc_done/_cc_exit\n"); return 2; }
    std::vector<u16> frame(256 * 224);
    GearboyCore core;
    core.Init();
    if (!core.LoadROM(argv[1], dmg)) { fprintf(stderr, "can't load %s\n", argv[1]); return 2; }
    Memory* memory = core.GetMemory();
    unsigned frames = 0;
    s16 audio[AUDIO_BUFFER_SIZE];
    while (frames < limit && memory->Read(syms["_cc_done"]) != 0xA5) {
        int n = 0;
        core.RunToVBlank(frame.data(), audio, &n);
        ++frames;
    }
    if (memory->Read(syms["_cc_done"]) != 0xA5) {
        printf("timeout pc=%04x\n", core.GetProcessor()->GetState()->PC->GetValue());
        return 1;
    }
    unsigned exit_value = memory->Read(syms["_cc_exit"]) | (memory->Read(syms["_cc_exit"] + 1) << 8);
    printf("exit %u frames %u\n", exit_value, frames);
    for (int i = 5; i + 1 < argc; i += 2) {
        unsigned at = syms.count(argv[i]) ? syms[argv[i]] : strtoul(argv[i], 0, 16), n = atoi(argv[i + 1]);
        printf("%s:", argv[i]);
        for (unsigned k = 0; k < n; ++k) printf(" %02x", memory->Read(at + k));
        printf("\n");
    }
    return 0;
}
