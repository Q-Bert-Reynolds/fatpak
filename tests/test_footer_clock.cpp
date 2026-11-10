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
    memory->Write(syms.at("_src_ui_footer_c_ready"),0);
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
    memory->Write(syms.at("_src_ui_footer_c_ready"),0);
    memory->Write(syms.at("_src_ui_footer_c_frames"),0);
    for(unsigned i=0;i<8;++i)memory->Write(syms.at("_footer_time")+i,0);
    Check(Call(core,syms.at("_ClockRead"),0xC200)==1,"fixture RTC is unavailable");
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
    for(unsigned i=0;i<sizeof(loop);++i) memory->Write(0xFFF0+i,loop[i]);
    auto cpu=core.GetProcessor()->GetState();cpu->SP->SetValue(syms.at("stack_bottom"));cpu->PC->SetValue(0xFFF0);*cpu->IME=true;*cpu->Halt=false;
    Frames(core,120);
    Check(Time(memory,syms.at("_footer_time"))=="10:42pm","clock refreshes while idle");
    Pixels(core,syms,color);
    printf("%s browser clock pixels and idle refresh passed\n",color?"CGB":"DMG");
}
int main(int argc,char** argv) {
    Check(argc==4,"usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT");
    Format(argv[1],argv[2]);Unavailable(argv[1],argv[2]);
    UI(argv[1],argv[2],argv[3],false);UI(argv[1],argv[2],argv[3],true);
}
