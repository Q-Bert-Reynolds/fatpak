// Runs the assembled menu in Gearboy against an isolated temporary SD folder.
// Usage: tests/run_ingame_return.sh (requires built Gearboy desktop objects)
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
static void SetText(Memory* memory, const char* text)
{
    for (unsigned i = 0; i <= strlen(text); ++i) memory->Write(0xC200 + i, text[i]);
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
    for (unsigned i = 0x134; i < 0x14D; ++i) rom[0x14D] = rom[0x14D] - rom[i] - 1;
    return rom;
}
static void CancelledHDMATest(const char* image, const char* symbols)
{
    GearboyCore core; core.Init(); Check(core.LoadROM(image, false), "HDMA test OS");
    auto syms = Symbols(symbols); auto memory = core.GetMemory();
    auto cpu = core.GetProcessor()->GetState();
    memory->Write(0xBD0A, 0xA5); memory->Write(0xBD06, 4);
    memory->Write(0xFFFF, 0); memory->Write(0xFF40, 0);
    // Gearboy reports $FF after cancellation. Inject the hardware's retained
    // count explicitly so this regression does not depend on that shortcut.
    for (unsigned status : {0x80u, 0x81u, 0x8Fu, 0xFEu, 0xFFu}) {
        memory->SetHDMARegister(5, status);
        cpu->SP->SetValue(0xDFFE);
        memory->Write(0xDFFE, 0xFF); memory->Write(0xDFFF, 0x7F);
        cpu->PC->SetValue(syms.at("RenderWaitDMA"));
        for (unsigned i = 0; i < 1000 && cpu->PC->GetValue() != 0x7FFF; ++i) {
            unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
        }
        Check(cpu->PC->GetValue() == 0x7FFF, "cancelled HDMA never stalls the renderer");
        memory->Write(0xFF45, 144);
        memory->Write(syms.at("_render_pending"), 1);
        memory->Write(syms.at("_render_pending_scy"), 0);
        memory->Write(syms.at("render_pending_anim"), 0);
        memory->Write(syms.at("render_pending_lcdc"), 0);
        memory->Write(syms.at("render_pending_count"), 0);
        Call(core, syms.at("RenderLCDInterrupt"));
        Check(memory->Read(syms.at("_render_pending")) == 0,
              "cancelled HDMA allows pending display changes to commit");
    }
    memory->SetHDMARegister(5, 0x0F);
    cpu->SP->SetValue(0xDFFE);
    memory->Write(0xDFFE, 0xFF); memory->Write(0xDFFF, 0x7F);
    cpu->PC->SetValue(syms.at("RenderWaitDMA"));
    for (unsigned i = 0; i < 1000; ++i) {
        unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
        Check(cpu->PC->GetValue() != 0x7FFF, "active HDMA still blocks VRAM access");
    }
    memory->SetHDMARegister(5, 0x8F);
    for (unsigned i = 0; i < 1000 && cpu->PC->GetValue() != 0x7FFF; ++i) {
        unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
    }
    Check(cpu->PC->GetValue() == 0x7FFF, "HDMA wait ends when the transfer is cancelled");
    puts("Cancelled HDMA status, display commit and active-transfer waits passed");
}
static void Run(const char* image, const char* symbols, const char* data, bool color)
{
    char folder[] = "/tmp/fatpak-return-XXXXXX";
    Check(mkdtemp(folder), "temporary SD folder");
    std::string root(folder), sys = root + "/GBCSYS";
    mkdir(sys.c_str(), 0700);
    mkdir((sys + "/SAVE").c_str(), 0700);
    mkdir((sys + "/SNAP").c_str(), 0700);
    Write(root + "/StateTest.gbc", Game(color));
    Write(sys + "/EDITOR.DAT", Read(data));
    Write(sys + "/SAVE/StateTest.srm", std::vector<u8>(32768, 0xA7));
    GearboyCore core; core.Init(); core.SetEverdriveFolder(folder);
    Check(core.LoadROM(image, false), "load OS");
    auto syms = Symbols(symbols); auto memory = core.GetMemory();
    auto word = [&](const char* name) {
        unsigned a = syms.at(name); return memory->Read(a) | memory->Read(a+1) << 8;
    };
    auto key = [&](Gameboy_Keys button, unsigned wait = 4) {
        core.KeyPressed(button); Frames(core, 4);
        core.KeyReleased(button); Frames(core, wait);
    };
    for (unsigned launch = 0; launch < 2; ++launch) {
        memory->Write(0xBD0A, 0xA5); memory->Write(0xBD06, 4);
        memory->Write(0xBD08, 4); memory->Write(syms.at("loaded_bank"), 4);
        SetText(memory, "/StateTest.gbc");
        Check(!Call(core, syms.at("_FileGameOpen"), 0xC200), "open game");
        while (word("_game_block") < word("_game_blocks"))
            Check(!Call(core, syms.at("_FileGameCopy")), "copy game");
        Check(!Call(core, syms.at("_FileGameFinish"), 0xC200), "prepare game");
        memory->Write(0xBD08, 6);
        core.GetProcessor()->GetState()->PC->SetValue(syms.at("_GameLaunch"));
        Frames(core, 180);
        Check(core.CanPressEverdriveButton(), "launch game, including after returning to OS");
        memory->Write(0, 0x0A); memory->Write(0xA000, 0x5A + launch);
        core.PressEverdriveButton(); Frames(core, 300);
        Check(!core.CanPressEverdriveButton(), "open menu");
        if (!launch) {
            key(B_Key, 180);
            Check(core.CanPressEverdriveButton(), "resume game");
            core.PressEverdriveButton(); Frames(core, 300);
            key(Down_Key); key(A_Key, 1000);
            Check(core.CanPressEverdriveButton(), "Save state resumes game");
            Check(Read(sys + "/SNAP/StateTest.sav").size() == 83968, "save state written");
            core.PressEverdriveButton(); Frames(core, 300);
        }
        key(Up_Key);
        Check(memory->Read(syms.at("menu_sel")) == 3, "select Return to OS");
        core.KeyPressed(A_Key); Frames(core, 4); core.KeyReleased(A_Key);
        bool reached_main = false;
        for (unsigned i = 0; i < 1000000 && !reached_main; ++i) {
            Check(static_cast<EverdriveOSMemoryRule*>(memory->GetCurrentRule())->PeekSwitch() != 2,
                  "warm return never requests a cartridge reboot");
            reached_main = core.GetProcessor()->GetState()->PC->GetValue() == syms.at("WarmMain");
            unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
            if (i % 3000 == 2999) {
                s16 audio[AUDIO_BUFFER_SIZE]; int n = 0; core.EndFrame(audio, &n);
            }
        }
        Check(reached_main, "return jumps directly to OS startup");
        bool reached_clear = false;
        for (unsigned i = 0; i < 10000 && !reached_clear; ++i) {
            unsigned pc = core.GetProcessor()->GetState()->PC->GetValue();
            Check(pc != syms.at("CartConfigureFeatures"),
                  "warm startup preserves FPGA and RTC feature controls");
            reached_clear = pc == syms.at("MainStart.clearHRAM");
            unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
        }
        Check(reached_clear, "warm startup establishes OS mapping before clearing RAM");
        if (color) memory->SetHDMARegister(5, 0x80);
        Frames(core, 500);
        Check(!core.CanPressEverdriveButton(), "leave game mapping");
        Check(memory->Read(syms.at("_render_cpu_copy")) == 1,
              "warm return keeps the renderer on CPU tile copies");
        Check(memory->Read(syms.at("_data_loaded")) == 1, "OS startup loads editor data");
        Check(memory->Read(syms.at("_src_browser_browser_c_list_result")) == 0,
              "browser lists SD folder after reboot");
        Check(word("_src_browser_browser_c_list_count") == 2, "browser shows game and GBCSYS");
        auto save = Read(sys + "/SAVE/StateTest.srm");
        Check(save.size() == 32768 && save[0] == 0x5A + launch, "OS backs up the game's save");
        // Closing the browser must still respond after the restart.
        key(B_Key, 180);
        Check(memory->Read(syms.at("_render_cpu_copy")) == 1,
              "CPU tile copies stay enabled after closing the browser");
        if (color) Check(memory->GetHDMARegister(5) == 0x80,
                         "warm OS rendering never starts another HDMA transfer");
        Check(memory->Read(syms.at("busy_frames")) <= 2, "OS continues processing frames and input");
    }
    printf("%s menu Resume, Save state, repeated Return to OS and save backup passed (%s)\n",
           color ? "CGB" : "DMG", folder);
}
int main(int argc, char** argv)
{
    Check(argc == 4, "usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT");
    CancelledHDMATest(argv[1], argv[2]);
    Run(argv[1], argv[2], argv[3], false);
    Run(argv[1], argv[2], argv[3], true);
}
