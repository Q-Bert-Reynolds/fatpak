// Footer clock formatting, idle updates and rendered pixels in the assembled OS.
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
static unsigned call_bc, call_de; // a routine's BC and DE when it returned (a 32-bit result: DEBC)
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
    call_bc = cpu->BC->GetValue(); call_de = cpu->DE->GetValue();
    return cpu->AF->GetValue() >> 8;
}
static void SetText(Memory* memory, const char* text)
{
    for (unsigned i = 0; i <= strlen(text); ++i) memory->Write(0xC200 + i, text[i]);
}
static std::string Time(Memory* memory, unsigned address) {
    std::string result;
    for (unsigned i=0;i<8 && memory->Read(address+i);++i) result += char(memory->Read(address+i));
    return result;
}
static void Date(GearboyCore& core, const std::map<std::string,unsigned>& syms, unsigned hour, unsigned minute) {
    auto memory=core.GetMemory();
    const u8 date[]={26,11,9,u8(hour),u8(minute),0};
    for(unsigned i=0;i<sizeof(date);++i) memory->Write(0xC200+i,date[i]);
    Check(Call(core,syms.at("_ClockWrite"),0xC200)==0,"set test calendar");
}
static void Format(const char* image,const char* symbols) {
    GearboyCore core;core.Init();Check(core.LoadROM(image,false),"format OS");
    auto memory=core.GetMemory();auto syms=Symbols(symbols);
    memory->Write(0xBD0A,0xA5);memory->Write(0xBD06,4);memory->Write(0xBD08,4);
    memory->Write(syms.at("loaded_bank"),4);memory->Write(0xFFFF,0);memory->Write(0xFF40,0);
    // These direct API calls bypass Main's WRAM initialization.
    memory->Write(syms.at("far_depth"),0);
    Call(core,syms.at("_GeometryGB"));
    memory->Write(syms.at("_footer_ready"),0);
    memory->Write(syms.at("_src_ui_footer_c_frames"),0);
    for(unsigned i=0;i<8;++i)memory->Write(syms.at("_footer_time")+i,0);
    const unsigned hours[]={0,1,11,12,13,22,23};
    const char* expected[]={"12:09am","1:09am","11:09am","12:09pm","1:09pm","10:09pm","11:09pm"};
    for(unsigned n=0;n<7;++n) {
        Date(core,syms,hours[n],9);
        for(unsigned i=0;i<60;++i) Call(core,syms.at("_FooterPoll"));
        Check(Time(memory,syms.at("_footer_time"))==expected[n],"12-hour format, midnight, noon and lowercase suffix");
        for(unsigned i=0;i<40;++i) memory->Write(0xC300+i,'W');
        Call(core,syms.at("_FooterCompose"),0xC300);
        Check(memory->Read(0xC320)==127,"right-alignment marker");
        unsigned width=0;
        for(unsigned i=0;i<32 && memory->Read(0xC300+i)!=127;++i)
            width+=memory->Read(syms.at("FontVWFWidths")+memory->Read(0xC300+i));
        Check(width<=111,"footer messages leave room for the clock");
        for(unsigned i=0;expected[n][i];++i)
            Check(memory->Read(0xC321+i)==u8(expected[n][i]),"clock appended to footer row");
    }
    puts("12-hour footer formatting and message spacing passed");
}
static void Unavailable(const char* image,const char* symbols) {
    setenv("GEARBOY_RTC","0",1);
    GearboyCore core;core.Init();unsetenv("GEARBOY_RTC");
    Check(core.LoadROM(image,false),"clockless OS");
    auto memory=core.GetMemory();auto syms=Symbols(symbols);
    memory->Write(0xBD0A,0xA5);memory->Write(0xBD06,4);memory->Write(0xBD08,4);
    memory->Write(syms.at("loaded_bank"),4);memory->Write(0xFFFF,0);memory->Write(0xFF40,0);
    // These direct API calls bypass Main's WRAM initialization.
    memory->Write(syms.at("far_depth"),0);
    Call(core,syms.at("_GeometryGB"));
    memory->Write(syms.at("_footer_ready"),0);
    memory->Write(syms.at("_src_ui_footer_c_frames"),0);
    for(unsigned i=0;i<8;++i)memory->Write(syms.at("_footer_time")+i,0);
    Check(Call(core,syms.at("_ClockRead"),0xC200)==1,"fixture RTC is unavailable");
    Call(core,syms.at("_ClockFatTime"));
    Check(call_de==0x5C21&&call_bc==0,"FatFs's time without a clock is 2026-01-01");
    for(unsigned i=0;i<10;++i)memory->Write(0xC300+i,i*7);
    Check(Call(core,syms.at("_ClockAdvance"),0xC300)==1,"ClockAdvance without a clock fails");
    for(unsigned i=0;i<10;++i)Check(memory->Read(0xC300+i)==i*7,"and leaves the registers alone");
    for(unsigned i=0;i<60;++i) Call(core,syms.at("_FooterPoll"));
    Check(Time(memory,syms.at("_footer_time"))=="--:--","unavailable RTC has a placeholder");
    puts("Unavailable RTC footer passed");
}
static void Pixels(GearboyCore& core,const std::map<std::string,unsigned>& syms,bool color) {
    auto memory=core.GetMemory();auto time=Time(memory,syms.at("_footer_time"));
    unsigned x=memory->Read(syms.at("_footer_x")),width=0;
    bool pixels[8][160]={};
    for(unsigned i=0;i<time.size();++i) {
        unsigned c=u8(time[i]);
        for(unsigned y=0;y<8;++y) {
            u8 bits=memory->Read(syms.at("FontVWFGlyphs")+c*8+y);
            for(unsigned bit=0;bit<8 && x+width+bit<160;++bit)
                if(bits&(128>>bit)) pixels[y][x+width+bit]=true;
        }
        width+=memory->Read(syms.at("FontVWFWidths")+c);
    }
    Check(x+width==156,"clock ends four pixels from the right edge");
    for(unsigned y=0;y<8;++y) for(unsigned column=112;column<160;++column) {
        // Status block 17 uses tiles 228-247, bank 1 on CGB, bank 0 on DMG.
        u8 byte=memory->ReadCGBLCDRAM(0x8E40+(column/8)*16+y*2+1,color);
        bool actual=(byte&(128>>(column&7)))!=0;
        Check(actual==(color?pixels[y][column]:!pixels[y][column]),"right-aligned footer clock pixels");
    }
}
static void UI(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-footer-XXXXXX";Check(mkdtemp(folder),"temporary SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));Write(root+"/Document.txt",{'h','i','\n'});
    GearboyCore core;core.Init();core.SetEverdriveFolder(folder);Check(core.LoadROM(image,!color),"footer UI OS");
    auto memory=core.GetMemory();auto syms=Symbols(symbols);Frames(core,500);
    unsigned line=syms.at("tile_buffer")+19*40;
    Check(memory->Read(line+32)==127,"browser has a footer clock");
    const std::string hints=" \001Open \003Info \004Menu";
    for(unsigned i=0;i<hints.size();++i)Check(memory->Read(line+i)==u8(hints[i]),"browser footer shows gamepad action icons");
    u8 action_pixels[8][112]={};unsigned x=1;
    for(unsigned char c : hints) {
        int icon=c>=1 && c<=8 ? c-1 : c>=129 && c<=131 ? c-121 : -1;
        for(unsigned y=0;y<8;++y)for(unsigned bit=0;bit<8 && x+bit<112;++bit) {
            bool ink=memory->Read(syms.at("FontVWFGlyphs")+c*8+y)&(128>>bit);
            unsigned pixel=ink?3:0;
            if(icon>=0) {
                if(memory->Read(syms.at("FontVWFGlyphs")+(132+icon)*8+y)&(128>>bit))pixel=2;
                if(memory->Read(syms.at("FontVWFGlyphs")+(143+icon)*8+y)&(128>>bit))pixel=1;
            }
            action_pixels[y][x+bit]=pixel;
        }
        x+=memory->Read(syms.at("FontVWFWidths")+c);
    }
    for(unsigned y=0;y<8;++y)for(unsigned column=0;column<112;++column) {
        unsigned address=0x8E40+(column/8)*16+y*2, bit=128>>(column&7);
        unsigned pixel=bool(memory->ReadCGBLCDRAM(address,color)&bit) |
                       bool(memory->ReadCGBLCDRAM(address+1,color)&bit)<<1;
        unsigned source=action_pixels[y][column];
        Check(pixel==(color?(source?source:1):(source^3)),"2bpp footer icons preserve all shades with existing selection palettes");
    }
    Pixels(core,syms,color);
    Date(core,syms,22,42);
    // Continue waiting through the real shared frame handler without requiring
    // any key, cursor movement or menu redraw to refresh the time.
    unsigned wait=syms.at("_WaitFrame");const u8 loop[]={0xCD,u8(wait),u8(wait>>8),0x18,0xFB};
    for(unsigned i=0;i<sizeof(loop);++i) memory->Write(0xFFF8+i,loop[i]);
    auto cpu=core.GetProcessor()->GetState();cpu->SP->SetValue(syms.at("stack_bottom"));cpu->PC->SetValue(0xFFF8);*cpu->IME=true;*cpu->Halt=false;
    Frames(core,120);
    Check(Time(memory,syms.at("_footer_time"))=="10:42pm","clock refreshes while idle");
    Pixels(core,syms,color);
    printf("%s browser clock pixels and idle refresh passed\n",color?"CGB":"DMG");
}
// src/rtc/rtc.c's arithmetic, as it was in C (2026-11-22): the assembly must agree with it
namespace model {
static unsigned MonthDays(unsigned year, unsigned month) {
    static const unsigned days[] = {31,28,31,30,31,30,31,31,30,31,30,31};
    return days[month - 1] + (month == 2 && !(year & 3));
}
static unsigned Days(const u8* d) {
    unsigned days = 0;
    for (unsigned y = 0; y < d[0]; ++y) days += 365 + !(y & 3);
    for (unsigned m = 1; m < d[1]; ++m) days += MonthDays(d[0], m);
    return (days + d[2] - 1) & 0xFFFF;
}
static uint32_t Seconds(unsigned d, unsigned h, unsigned m, unsigned s) { return ((uint32_t(d) * 24 + h) * 60 + m) * 60 + s; }
static uint32_t ClockSeconds(const u8* d) { return Seconds(Days(d), d[3], d[4], d[5]); }
static uint32_t FatTime(const u8* d) {
    return (uint32_t(d[0] + 20) << 25) | (uint32_t(d[1]) << 21) | (uint32_t(d[2]) << 16) | (uint32_t(d[3]) << 11) | (d[4] << 5) | (d[5] >> 1);
}
static uint32_t GameSeconds(const u8* r) { return Seconds(r[3] | ((r[4] & 1) << 8), r[2], r[1], r[0]); }
static void Advance(u8* r, const u8* date) {
    const uint32_t wrap = 44236800UL;
    uint32_t now = ClockSeconds(date), before, seconds;
    while (now >= wrap) now -= wrap;
    before = GameSeconds(r + 5);
    before = now < before ? now + wrap - before : now - before;
    seconds = GameSeconds(r);
    if (!(r[4] & 0x40)) seconds += before;
    if (seconds >= wrap) { seconds -= wrap; r[4] |= 0x80; }
    unsigned days = 0;
    while (seconds >= 86400UL) { seconds -= 86400UL; ++days; }
    r[3] = days; r[4] = (r[4] & 0xC0) | ((days >> 8) & 0xFF);
    r[2] = 0; while (seconds >= 3600) { seconds -= 3600; ++r[2]; }
    r[1] = 0; while (seconds >= 60) { seconds -= 60; ++r[1]; } r[0] = seconds;
    days = Days(date); r[8] = days; r[9] = (days >> 8) & 1;
    r[5] = date[5]; r[6] = date[4]; r[7] = date[3];
}
}
// ClockSeconds, ClockFatTime and ClockAdvance against the model, over random calendars and
// game registers. The emulated clock can tick during a case: then it's tried again.
static void ClockMath(const char* image, const char* symbols) {
    GearboyCore core; core.Init(); Check(core.LoadROM(image, false), "clock OS");
    auto memory = core.GetMemory(); auto syms = Symbols(symbols);
    memory->Write(0xBD0A, 0xA5); memory->Write(0xBD06, 4); memory->Write(0xBD08, 4);
    memory->Write(syms.at("loaded_bank"), 4); memory->Write(0xFFFF, 0); memory->Write(0xFF40, 0);
    memory->Write(syms.at("far_depth"), 0);
    srand(7);
    auto date = [&](u8* d) { Check(Call(core, syms.at("_ClockRead"), 0xC210) == 0, "read the clock"); for (unsigned i = 0; i < 6; ++i) d[i] = memory->Read(0xC210 + i); };
    unsigned cases = 0;
    for (unsigned n = 0; n < 300; ++n) {
        u8 d[6] = { u8(n < 3 ? (n == 0 ? 0 : n == 1 ? 99 : 4) : rand() % 100), u8(1 + rand() % 12), 1, u8(rand() % 24), u8(rand() % 60), u8(rand() % 59) };
        d[2] = 1 + rand() % model::MonthDays(d[0], d[1]);
        if (n == 1) { d[1] = 12; d[2] = 31; d[3] = 23; d[4] = 59; d[5] = 58; } // the last second of 2099
        for (unsigned i = 0; i < 6; ++i) memory->Write(0xC200 + i, d[i]);
        Check(Call(core, syms.at("_ClockWrite"), 0xC200) == 0, "set the clock");
        for (unsigned attempt = 0; attempt < 5; ++attempt) {
            u8 before[6], after[6], r[10], want[10];
            date(before);
            Call(core, syms.at("_ClockSeconds"), 0xC210);
            uint32_t seconds = call_de << 16 | call_bc;
            Call(core, syms.at("_ClockFatTime"));
            uint32_t fat = call_de << 16 | call_bc;
            r[0] = rand() % 60; r[1] = rand() % 60; r[2] = rand() % 24; r[3] = rand(); r[4] = rand() & 0xC1;
            r[5] = rand() % 60; r[6] = rand() % 60; r[7] = rand() % 24; r[8] = rand(); r[9] = rand() & 1;
            if (n % 7 == 0) r[4] &= ~0x40; // most cases run, these surely
            for (unsigned i = 0; i < 10; ++i) { memory->Write(0xC300 + i, r[i]); want[i] = r[i]; }
            unsigned result = Call(core, syms.at("_ClockAdvance"), 0xC300);
            date(after);
            if (memcmp(before, after, 6)) continue; // it ticked
            model::Advance(want, before);
            if (seconds != model::ClockSeconds(before) || fat != model::FatTime(before) || result) {
                fprintf(stderr, "date %u-%u-%u %u:%u:%u: seconds %u want %u, fat %08x want %08x, result %u\n", before[0], before[1], before[2],
                        before[3], before[4], before[5], seconds, model::ClockSeconds(before), fat, model::FatTime(before), result);
                Check(false, "ClockSeconds and ClockFatTime match the model");
            }
            for (unsigned i = 0; i < 10; ++i)
                if (memory->Read(0xC300 + i) != want[i]) {
                    fprintf(stderr, "date %u-%u-%u %u:%u:%u, registers in", before[0], before[1], before[2], before[3], before[4], before[5]);
                    for (unsigned k = 0; k < 10; ++k) fprintf(stderr, " %02x", r[k]);
                    fprintf(stderr, "\n  got"); for (unsigned k = 0; k < 10; ++k) fprintf(stderr, " %02x", memory->Read(0xC300 + k));
                    fprintf(stderr, "\n want"); for (unsigned k = 0; k < 10; ++k) fprintf(stderr, " %02x", want[k]);
                    fprintf(stderr, "\n");
                    Check(false, "ClockAdvance matches the model");
                }
            ++cases;
            break;
        }
    }
    Check(cases >= 290, "the clock held still for nearly every case");
    printf("Clock arithmetic: %u cases match the model\n", cases);
}

int main(int argc,char** argv) {
    Check(argc==4,"usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT");
    ClockMath(argv[1],argv[2]);
    Format(argv[1],argv[2]);Unavailable(argv[1],argv[2]);
    UI(argv[1],argv[2],argv[3],false);UI(argv[1],argv[2],argv[3],true);
}
