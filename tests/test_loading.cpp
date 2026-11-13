// Startup feedback, loading speed transitions and bulk-copy boundaries.
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iterator>
#include <map>
#include <set>
#include <string>
#include <vector>
#include <sys/stat.h>
#include "../src/constants.h" // DATA_WIDTHS
#include <unistd.h>
#include "GearboyCore.h"
#include "Memory.h"
#include "Processor.h"
#include "EverdriveOSMemoryRule.h"

bool g_mcp_stdio_mode = true;
static std::vector<u16> frame(256 * 224);
static void Check(bool ok, const char* message)
{
    if (!ok) { fprintf(stderr, "FAIL: %s\n", message); exit(1); }
}
static std::vector<u8> Read(const std::string& path)
{
    std::ifstream file(path.c_str(), std::ios::binary);
    return std::vector<u8>((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
}
static void Write(const std::string& path, const std::vector<u8>& bytes)
{
    std::ofstream file(path.c_str(), std::ios::binary);
    file.write(reinterpret_cast<const char*>(bytes.data()), bytes.size());
    Check(file.good(), "write fixture");
}
static std::map<std::string, unsigned> Symbols(const char* path)
{
    std::map<std::string, unsigned> result;
    FILE* file = fopen(path, "r"); Check(file, "open symbols");
    char line[512], name[256]; unsigned bank, address;
    while (fgets(line, sizeof(line), file))
        if (sscanf(line, "%x:%x %255s", &bank, &address, name) == 3) result[name] = address;
    fclose(file); return result;
}
static void Frames(GearboyCore& core, unsigned count)
{
    s16 audio[AUDIO_BUFFER_SIZE];
    while (count--) { int n = 0; core.RunToVBlank(frame.data(), audio, &n); }
}
static unsigned Call(GearboyCore& core, unsigned address, unsigned argument = 0, u8 a = 0)
{
    auto cpu = core.GetProcessor()->GetState(); auto memory = core.GetMemory();
    cpu->SP->SetValue(0xDFFE); memory->Write(0xDFFE, 0xFF); memory->Write(0xDFFF, 0x7F);
    cpu->DE->SetValue(argument); cpu->AF->SetValue(a << 8); cpu->PC->SetValue(address);
    for (unsigned i = 0; i < 80000000 && cpu->PC->GetValue() != 0x7FFF; ++i)
    {
        unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
        if (i % 3000 == 2999) { s16 audio[AUDIO_BUFFER_SIZE]; int n = 0; core.EndFrame(audio, &n); }
    }
    Check(cpu->PC->GetValue() == 0x7FFF, "OS routine returns");
    return cpu->AF->GetValue() >> 8;
}

static void Text(Memory* memory, unsigned address, const std::string& text) {
    for (unsigned i = 0; i <= text.size(); ++i) memory->Write(address+i, text[i]);
}
static std::string Text(Memory* memory, unsigned address) {
    std::string value;
    while (memory->Read(address)) value += char(memory->Read(address++));
    return value;
}

static void SetText(Memory* memory, const char* text) { Text(memory, 0xC200, text); }
static void Checksum(std::vector<u8>& registry)
{
    unsigned sum = 0; for (unsigned i = 0; i < 264; ++i) sum += registry[i];
    registry[264] = sum; registry[265] = sum >> 8;
}
static std::vector<u8> Game(bool color)
{
    std::vector<u8> rom(65536, 0);
    const u8 jump[] = {0xC3, 0x50, 1}; memcpy(rom.data() + 0x100, jump, sizeof(jump));
    memcpy(rom.data() + 0x134, "STATETEST", 9);
    rom[0x143] = color ? 0x80 : 0; rom[0x147] = 0x1B; rom[0x148] = 1; rom[0x149] = 3;
    const u8 irq[] = {0xF5,0xFA,0,0xC1,0x3C,0xEA,0,0xC1,0xF1,0xD9};
    memcpy(rom.data() + 0x40, irq, sizeof(irq));
    const u8 main[] = {0xF3,0x31,0xFF,0xDF,0xAF,0xE0,0x0F,0x3E,1,0xEA,0xFF,0xFF,0x3E,0x91,0xE0,0x40,0xFB,0x76,0x18,0xFD};
    memcpy(rom.data() + 0x150, main, sizeof(main));
    for (unsigned bank = 0; bank < 4; ++bank)
        for (unsigned i = 0x123; i <= 0x125; ++i) rom[bank * 16384 + i] = 0x33;
    for (unsigned i = 0x134; i < 0x14D; ++i) rom[0x14D] = rom[0x14D] - rom[i] - 1;
    return rom;
}
class RTCBusProbe : public MemoryRule
{
public:
    MemoryRule* rule;
    bool receiving, busy;
    unsigned transfers;
    std::vector<std::pair<u16, u8> > writes;
    RTCBusProbe(Memory* memory, MemoryRule* original) : MemoryRule(memory, NULL), rule(original), receiving(false), busy(false), transfers(0) {}
    virtual void Reset(bool) {}
    virtual u8 PerformRead(u16 address)
    {
        if (address == 0xBD0C && busy) return 0x80;
        u8 value = rule->PerformRead(address);
        // A slave ACK is only meaningful while transmitting. The receive path
        // must tolerate either value of this bit, as stock I2C_ReadBytes does.
        return address == 0xBD0C && receiving ? value | 1 : value;
    }
    virtual void PerformWrite(u16 address, u8 value)
    {
        if (address == 0xBD0C) receiving = value == 0x10;
        if (address == 0xBD0D) ++transfers;
        if (address >= 0xBD10 && address <= 0xBD13) writes.push_back(std::make_pair(address, value));
        rule->PerformWrite(address, value);
    }
    virtual u8* GetRomBank0() { return rule->GetRomBank0(); }
    virtual u8* GetCurrentRomBank1() { return rule->GetCurrentRomBank1(); }
    virtual int GetCurrentRomBank0Index() { return rule->GetCurrentRomBank0Index(); }
    virtual int GetCurrentRomBank1Index() { return rule->GetCurrentRomBank1Index(); }
};

// Guard the fast-path contract on the bus. This cannot reproduce electrical
// timing, but checks CPU speed preservation and excludes active HDMA.
class ROMTransferBusProbe : public RTCBusProbe
{
public:
    Processor* cpu;
    unsigned argument_bytes, write_bytes, reads, busy_reads, delay, streamed_bytes, mode;
    u8 command;
    bool token_timeout, write_token, fast;
    ROMTransferBusProbe(Memory* memory, MemoryRule* original, Processor* processor, unsigned test_mode) :
        RTCBusProbe(memory, original), cpu(processor), argument_bytes(0), write_bytes(0), reads(0), busy_reads(0), delay(0),
        streamed_bytes(0), mode(test_mode), command(0), token_timeout(false), write_token(false), fast(processor->CGBSpeed()) {}
    void CheckStream()
    {
        Check(!(m_pMemory->Read(0xFFFF) & ~2), "only LCD interrupts during SPI-to-PSRAM streaming");
        Check(!m_pMemory->IsHDMAEnabled(), "finish HBlank DMA before streaming");
        Check(cpu->CGBSpeed() == fast, "stream preserves caller CPU speed");
    }
    virtual u8 PerformRead(u16 address)
    {
        u8 value = RTCBusProbe::PerformRead(address);
        if (address == 0xBD01 && delay) { --delay; ++busy_reads; return value | 0x80; }
        if (address == 0xBD00) {
            Check(!delay, "poll SPI command-byte completion");
            if (command == 0x52 && !argument_bytes && value == 0xFE) {
                if (mode == 3) token_timeout = true;
                if (mode == 4) token_timeout = true;
            }
            if (command == 0x52 && token_timeout) return mode == 4 ? 0xFD : 0xFF;
        }
        return value;
    }
    virtual void PerformWrite(u16 address, u8 value)
    {
        bool corrupt = false;
        if (address == 0xBD01 && (value & 1)) {
            argument_bytes = write_bytes = 0; command = 0; write_token = false;
        }
        if (address == 0xBD00) {
            Check(!delay, "finish previous SPI command byte");
            // CMD24 payloads can contain any command-looking byte. They are
            // ordinary file writes, outside the ROM streaming contract.
            if (write_bytes) --write_bytes;
            else if (argument_bytes) --argument_bytes;
            else if (write_token) {
                if (value == 0xFE) { write_token = false; write_bytes = 514; }
            }
            else if ((value & 0xC0) == 0x40) {
                command = value;
                argument_bytes = 5;
                write_token = value == 0x58;
                if (value == 0x52 || value == 0x4C) CheckStream();
                if (value == 0x52) {
                    ++reads;
                    if (mode == 2) value = 0x7F;
                }
            }
            if (mode == 1) delay = 3;
        }
        if (address == 0xBD06 && (value & 1)) CheckStream();
        if (address >= 0xBE00 && (m_pMemory->Read(0xBD06) & 1)) {
            CheckStream();
            Check(cpu->GetState()->PC->GetValue() < 0x4000, "stream window writes execute from ROM0");
            ++streamed_bytes;
            corrupt = mode == 5 && address == 0xBF53 && !m_pMemory->Read(0xBD02) && !m_pMemory->Read(0xBD03);
        }
        RTCBusProbe::PerformWrite(address, value);
        if (corrupt) {
            // Change a stored header byte after the stream writes it, without
            // consuming another SPI byte (window writes ignore CPU data).
            u8 config = rule->PerformRead(0xBD06);
            rule->PerformWrite(0xBD06, config & ~1);
            rule->PerformWrite(address, rule->PerformRead(address) ^ 1);
            rule->PerformWrite(0xBD06, config);
        }
    }
};

static void ROMTransferTest(const char* image, const char* symbols)
{
    char folder[] = "/tmp/girlboss-rom-transfer-XXXXXX"; Check(mkdtemp(folder), "ROM transfer SD");
    mkdir((std::string(folder)+"/GBCSYS").c_str(), 0700);
    std::vector<u8> registry(512, 0); registry[0] = 0x34; registry[1] = 0x12;
    registry[2] = registry[5] = 1; Checksum(registry);
    Write(std::string(folder)+"/GBCSYS/REGISTRY.BIN", registry);
    auto game = Game(true);
    for (unsigned i = 0x200; i < game.size(); ++i) game[i] = i*73 + (i>>8)*31 + (i>>16);
    Write(std::string(folder)+"/Transfer.gbc", game);
    auto syms = Symbols(symbols);
    for (unsigned mode = 0; mode < 6; ++mode) for (unsigned machine = 0; machine < 4; ++machine) {
        bool color = machine != 0, fast = machine >= 2, ime = machine == 3;
        GearboyCore core; core.Init(); core.SetEverdriveFolder(folder); Check(core.LoadROM(image, !color), "transfer OS");
        auto memory = core.GetMemory(); auto cpu = core.GetProcessor()->GetState();
        // Match Main's RAM clearing: DMG power-up RAM is not zeroed by the core.
        for (unsigned address = 0xC000; address < 0xE000; ++address) memory->Write(address, 0);
        for (unsigned address = 0xFF80; address < 0xFFFF; ++address) memory->Write(address, 0);
        memory->Write(0xBD0A, 0xA5); memory->Write(0xBD06, 4); memory->Write(0xBD08, 4);
        memory->Write(syms.at("loaded_bank"), 4); memory->Write(syms.at("sys_info"), color ? 2 : 0);
        SetText(memory, "/Transfer.gbc");
        Check(!Call(core, syms.at("_FileGameOpen"), 0xC200), "open transfer fixture");
        if (fast) Call(core, syms.at("gbdk_CPUFast"));
        unsigned ie = machine == 2 ? 0 : 0x0B;
        memory->Write(0xFFFF, ie); memory->Write(0xFF0F, ime ? 0 : 1); *cpu->IME = ime;
        if (ime) {
            for (unsigned irq = 0; irq < 2; ++irq) {
                unsigned vector = irq ? 0x48 : 0x40, handler = 0xD800 + irq*16;
                const u8 code[] = {0xF5,0xFA,(u8)(0x20+irq),0xD8,0x3C,0xEA,(u8)(0x20+irq),0xD8,0xF1,0xD9};
                memory->Write(vector, 0xC3); memory->Write(vector+1, handler); memory->Write(vector+2, handler>>8);
                for (unsigned i = 0; i < sizeof(code); ++i) memory->Write(handler+i, code[i]);
                memory->Write(0xD820+irq, 0);
            }
            memory->Write(0xFF40, 0x91); memory->Write(0xFF45, 20); memory->Write(0xFF41, 0x40);
            memory->Write(0xFF51, 0xDE); memory->Write(0xFF52, 0x50);
            memory->Write(0xFF53, 0); memory->Write(0xFF54, 0); memory->Write(0xFF55, 0x93);
            Check(memory->IsHDMAEnabled(), "exercise an active row DMA at transfer start");
        }
        ROMTransferBusProbe probe(memory, memory->GetCurrentRule(), core.GetProcessor(), mode); memory->SetCurrentRule(&probe);
        auto word = [&](const char* name) { unsigned a = syms.at(name); return memory->Read(a) | memory->Read(a+1)<<8; };
        unsigned result = 0;
        while (!result && word("_game_block") < word("_game_blocks")) result = Call(core, syms.at("_FileGameCopy"));
        Check(probe.reads > 0, "exercise multiblock transfer");
        Check(memory->Read(0xFFFF) == ie && *cpu->IME == ime, "success/error preserves IE and IME");
        Check(core.GetProcessor()->CGBSpeed() == fast, "success/error restores caller CPU speed");
        if (!ime) Check(memory->Read(0xFF0F) & 1, "stream preserves pending VBlank");
        Check(!(memory->Read(0xBD06) & 1) && !(memory->Read(0xBD01) & 4), "disable streaming/auto-read on every return");
        Check(memory->Read(0xBD02) == 0 && memory->Read(0xBD03) == 1, "restore editor PSRAM window on success/error");
        if (mode >= 2) {
            Check(result == 1, "command/token/header failure returns disk error");
            if (mode != 5) Check(!word("_game_block"), "failed transfer does not advance copy progress");
        }
        else {
            if (result || probe.streamed_bytes != game.size()) fprintf(stderr, "transfer mode=%u machine=%u result=%u bytes=%u block=%u/%u\n", mode, machine, result, probe.streamed_bytes, word("_game_block"), word("_game_blocks"));
            Check(!result && probe.streamed_bytes == game.size(), "stream every ROM byte");
            if (mode == 1) Check(probe.busy_reads > 0, "exercise delayed SPI command completion");
            memory->Write(0xBD04, 1);
            std::vector<u8> rom, ram;
            static_cast<EverdriveOSMemoryRule*>(probe.rule)->TakeLaunch(rom, ram);
            Check(rom == game, "complete patterned ROM bytes survive transfer");
        }
        memory->SetCurrentRule(probe.rule);
    }
    puts("Fast ROM transfers, preserved CPU speed, DMA exclusion, restored CPU/interrupt state and error cleanup passed");
}


static void LookupTables(GearboyCore& core, const std::map<std::string,unsigned>& syms, const char* data) {
    auto memory = core.GetMemory(); auto cpu = core.GetProcessor()->GetState();
    const u8 glyph[] = {0x80,0x01,0xFE,0x33,0x81,0xFF,0,0x55};
    auto assets = Read(data);
    Check(memory->Read(syms.at("_data_loaded")) == 1, "external editor data loads");
    unsigned plane = syms.at("cmd_buffer");
    for (unsigned cached = 0; cached < 2; ++cached) {
        memory->Write(syms.at("_data_loaded"), cached);
        for (unsigned x = 0; x < 160; ++x) {
            std::vector<u8> expected(160, 0x22);
            for (unsigned y = 0; y < 8; ++y) {
                memory->Write(0xD000+y, glyph[y]);
                for (unsigned bit = 0; bit < 8 && x+bit < 160; ++bit)
                    if (glyph[y] & (128 >> bit)) expected[((x+bit)&~7)+y] |= 128 >> ((x+bit)&7);
            }
            for (unsigned i = 0; i < 160; ++i) memory->Write(plane+i, 0x22);
            memory->Write(plane+160, 0xA5);
            memory->Write(syms.at("render_x"), x);
            memory->Write(0xBD03, 0x3C); memory->Write(0xBD02, 0x14);
            cpu->BC->SetValue(0xD000);
            Call(core, syms.at("RenderGlyphPlane"), plane&0xFF00);
            for (unsigned i = 0; i < 160; ++i) Check(memory->Read(plane+i) == expected[i], "cached/fallback glyph pixels at every x and clipped edge");
            Check(memory->Read(plane+160) == 0xA5, "glyph drawing stays within its plane");
            Check(memory->Read(0xBD02) == 0x14 && memory->Read(0xBD03) == 0x3C, "glyph drawing preserves PSRAM selection");
        }
        for (unsigned c = 0; c < 256; ++c) {
            cpu->BC->SetValue(0xA500|c); cpu->HL->SetValue(0x1234);
            unsigned width = Call(core, syms.at("StyledWidth"), 0x7777, 5);
            unsigned expected = cached ? assets[DATA_WIDTHS*512+c] : memory->Read(syms.at("FontVWFWidths")+c);
            Check(width == expected, "cached/fallback bold width");
            Check(cpu->BC->GetValue() == (0xA500|c) && cpu->DE->GetValue() == 0x7777 && cpu->HL->GetValue() == 0x1234, "width lookup preserves registers");
            Check(memory->Read(0xBD02) == 0x14 && memory->Read(0xBD03) == 0x3C, "width lookup preserves PSRAM selection");
        }
    }
    memory->Write(syms.at("_data_loaded"), 1);
    puts("External/fallback shifts, clipped edges, widths and window/register preservation passed");
}

// Real DMGs read KEY1 as $FF and halt on a speed-switch STOP until a button press;
// Gearboy ignores STOP outside CGB mode, so check the executed opcodes instead.
static void NoDMGSpeedSwitch(GearboyCore& core, const std::map<std::string, unsigned>& syms)
{
    auto cpu = core.GetProcessor()->GetState(); auto memory = core.GetMemory();
    for (const char* routine : {"gbdk_CPUSlow", "gbdk_CPUFast"}) {
        memory->Load(0xFF4D, 0xFF);
        cpu->SP->SetValue(0xDFFE); memory->Write(0xDFFE, 0xFF); memory->Write(0xDFFF, 0x7F);
        cpu->PC->SetValue(syms.at(routine));
        for (unsigned i = 0; i < 10000 && cpu->PC->GetValue() != 0x7FFF; ++i) {
            Check(memory->Read(cpu->PC->GetValue()) != 0x10, "DMG never executes a CGB speed-switch STOP");
            unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
        }
        Check(cpu->PC->GetValue() == 0x7FFF, "speed routine returns on DMG");
    }
}

static void Loading(const char* image, const char* symbols, const char* data, bool color) {
    char folder[] = "/tmp/fatpak-loading-XXXXXX";
    Check(mkdtemp(folder), "loading SD");
    std::string root(folder);
    mkdir((root + "/GBCSYS").c_str(), 0700);
    Write(root + "/GBCSYS/EDITOR.DAT", Read(data));
    auto syms = Symbols(symbols);
    GearboyCore core; core.Init(); core.SetEverdriveFolder(folder);
    Check(core.LoadROM(image, !color), "loading OS");
    auto memory = core.GetMemory();
    auto cpu = core.GetProcessor()->GetState();
    bool reached = false;
    for (unsigned i = 0; i < 3000000; ++i) {
        if (cpu->PC->GetValue() == syms.at("_FileBackupSave")) { reached = true; break; }
        unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
        if (i % 3000 == 2999) { s16 audio[AUDIO_BUFFER_SIZE]; int n = 0; core.EndFrame(audio, &n); }
    }
    Check(reached, "startup reaches card IO");
    unsigned tiles = syms.at("tile_buffer");
    Check(Text(memory, tiles + 18*40).find(" FatPak") == 0, "header is drawn before card IO");
    unsigned box = syms.at("_render_box_text");
    box = memory->Read(box) | (memory->Read(box + 1) << 8);
    Check(Text(memory, box) == "Loading...", "startup uses the standard loading box");
    Check(memory->Read(syms.at("_render_box_rows")) == 3 && memory->Read(syms.at("_render_box_top")) == 7, "startup loading box is centered");
    Check(memory->Read(tiles + 19*40 + 1) == ' ', "loading text stays out of the footer");
    Check(memory->Read(tiles + 19*40 + 32) == 127, "startup footer includes clock");
    Check(memory->Read(syms.at("_bars")) == 1 && memory->Read(syms.at("_render_text")) == 0, "startup uses browser layout");
    Check(memory->Read(0xFF40) & 0x80, "startup feedback has LCD enabled");
    Frames(core, 600);
    Check(memory->Read(0xFE08) == 0 && memory->Read(0xFE09) == 0, "unused busy sprite stays hidden during VBlank");
    memory->Write(syms.at("_render_cpu_copy"), 1);
    u8 original_ie = memory->Read(0xFFFF);
    Call(core, syms.at("_GameLoadingBegin"));
    Check(core.GetProcessor()->CGBSpeed() == color && memory->Read(0xFFFF) == 2, "loading retains CPU speed with only LCD interrupts");
    Check(memory->Read(syms.at("_render_cpu_copy")) == 1 && !memory->IsHDMAEnabled(), "loading uses CPU copies without HDMA");
    Check(memory->Read(0xFF40) & 0x80, "loading display stays enabled");
    Call(core, syms.at("_GameLoadingEnd"));
    Check(core.GetProcessor()->CGBSpeed() == color && memory->Read(0xFFFF) == original_ie, "error recovery restores speed and interrupts");
    Check(!memory->Read(syms.at("_render_cpu_copy")), "error recovery restores normal renderer");
    LookupTables(core, syms, data);
    if (!color) NoDMGSpeedSwitch(core, syms);
    printf("%s startup bars/clock/loading, loading/error speed preservation and DMG speed guard passed\n", color ? "CGB" : "DMG");
}
static void Copies(const char* image, const char* symbols) {
    GearboyCore core; core.Init(); Check(core.LoadROM(image, true), "copy OS");
    auto syms = Symbols(symbols); auto memory = core.GetMemory(); auto cpu = core.GetProcessor()->GetState();
    memory->Write(0xFFFF, 0); memory->Write(0xFF40, 0);
    for (unsigned count : {0u,1u,7u,8u,9u,127u,128u,255u,256u,511u,512u,513u,1024u}) {
        for (unsigned i = 0; i < 1024; ++i) memory->Write(0xD000+i, i*73+31);
        for (unsigned i = 0; i < 1026; ++i) memory->Write(0xD7FF+i, 0xA5);
        cpu->HL->SetValue(0xD000); cpu->BC->SetValue(count);
        Call(core, syms.at("mem_Copy"), 0xD800);
        for (unsigned i = 0; i < 1024; ++i)
            Check(memory->Read(0xD800+i) == (i < count ? u8(i*73+31) : 0xA5), "bulk copy bytes and tail");
        Check(memory->Read(0xD7FF) == 0xA5 && memory->Read(0xDC00) == 0xA5, "copy canaries");
        Check(cpu->BC->GetValue() == 0 && cpu->HL->GetValue() == 0xD000+count && cpu->DE->GetValue() == 0xD800+count, "copy register contract");
    }
    puts("Bulk-copy zero, short, chunk and page boundaries passed");
}
int main(int argc, char** argv) {
    Check(argc == 4, "usage: test ROM SYM DATA");
    Copies(argv[1], argv[2]);
    ROMTransferTest(argv[1], argv[2]);
    Loading(argv[1], argv[2], argv[3], false);
    Loading(argv[1], argv[2], argv[3], true);
}
