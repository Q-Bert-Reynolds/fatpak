// Real OS startup, LCD transport integrity and raster output in Gearboy's SGB mode.
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
#include "SGB.h"

bool g_mcp_stdio_mode = true;
static std::vector<u16> frame(256 * 224);
static void Check(bool ok, const char* message) {
    if (!ok) { fprintf(stderr, "FAIL: %s\n", message); exit(1); }
}
static std::vector<u8> Read(const std::string& path) {
    std::ifstream file(path.c_str(), std::ios::binary);
    Check(file.good(), "open fixture");
    return std::vector<u8>((std::istreambuf_iterator<char>(file)), {});
}
static void Write(const std::string& path, const std::vector<u8>& bytes) {
    std::ofstream file(path.c_str(), std::ios::binary);
    file.write(reinterpret_cast<const char*>(bytes.data()), bytes.size());
    Check(file.good(), "write fixture");
}
static std::map<std::string, unsigned> Symbols(const char* path) {
    std::map<std::string, unsigned> result;
    FILE* file = fopen(path, "r"); Check(file, "open symbols");
    char line[512], name[256]; unsigned bank, address;
    while (fgets(line, sizeof(line), file))
        if (sscanf(line, "%x:%x %255s", &bank, &address, name) == 3) result[name] = address;
    fclose(file); return result;
}
static void Frames(GearboyCore& core, unsigned count) {
    s16 audio[AUDIO_BUFFER_SIZE];
    while (count--) { int n = 0; core.RunToVBlank(frame.data(), audio, &n); }
}
static void Modes(const char* image) {
    GearboyCore core; core.Init();
    Check(core.LoadROM(image, false), "load dual-compatible OS");
    Check(core.IsCGB() && !core.IsSGB(), "automatic mode keeps CGB preference");
    core.SetForceSGB(true); core.ResetROM(false);
    Check(core.IsSGB() && !core.IsCGB() && !core.IsGBA(), "force SGB on reset");
    core.ResetROM(true);
    Check(!core.IsSGB() && !core.IsCGB(), "explicit DMG still wins");
    core.SetSGBEnabled(false); core.ResetROM(false);
    Check(core.IsCGB() && !core.IsSGB(), "disabled SGB keeps CGB mode");
    core.SetSGBEnabled(true);
    auto rom = Read(image); rom[0x143] = rom[0x146] = 0;
    Check(core.LoadROMFromBuffer(rom.data(), rom.size(), false), "load ordinary DMG cartridge");
    Check(core.IsSGB() && core.GetSGB()->AreCommandsDisabled(), "force SGB applies to non-SGB games too");
    core.SetForceSGB(false);
    Check(core.LoadROM(image, false), "reload OS without force");
    Check(core.IsCGB() && !core.IsSGB(), "clear override restores automatic selection");
    puts("Gearboy console selection passed");
}
static std::vector<u8> VRAM(Memory* memory) {
    std::vector<u8> result(0x1800);
    for (unsigned i=0; i<result.size(); ++i) result[i]=memory->ReadCGBLCDRAM(0x8800+i, false);
    return result;
}
static void Pixels(GearboyCore& core, const std::map<std::string,unsigned>& syms) {
    auto memory=core.GetMemory();
    auto pixels=core.GetVideo()->GetFrameBuffer();
    // Derive every visible pixel from the row's assigned block, independently
    // of the map and the LCD interrupt's tile-address/window mode selection.
    for (unsigned row=0; row<18; ++row) {
        unsigned block=memory->Read(syms.at("_render_row_blocks")+row);
        unsigned base=block<6 ? 0x8020+block*320 : block<9 ? 0x8800+(block-6)*320 :
                      block<15 ? 0x9000+(block-9)*320 : 0x8BC0+(block-15)*320;
        for (unsigned y=0; y<8; ++y) for(unsigned x=0; x<160; ++x) {
            unsigned addr=base+(x/8)*16+y*2, bit=128>>(x&7);
            unsigned expected=bool(memory->ReadCGBLCDRAM(addr,false)&bit) |
                              (bool(memory->ReadCGBLCDRAM(addr+1,false)&bit)<<1);
            if (pixels[(row*8+y)*160+x] != expected) {
                fprintf(stderr,"pixel row=%u block=%u x=%u y=%u expected=%u actual=%u\n",
                        row,block,x,y,expected,pixels[(row*8+y)*160+x]);
                Check(false,"browser raster matches assigned tiles across all rows");
            }
        }
    }
}
static void Startup(const char* image, const char* symbols, const char* data) {
    char folder[]="/tmp/fatpak-sgb-XXXXXX"; Check(mkdtemp(folder),"temporary SD");
    std::string root(folder); mkdir((root+"/GBCSYS").c_str(),0700);
    auto bytes=Read(data); Write(root+"/GBCSYS/EDITOR.DAT",bytes);
    for(unsigned i=0;i<24;++i) Write(root+"/Document "+std::to_string(i)+".txt",{'h','i','\n'});
    GearboyCore core; core.Init(); core.SetForceSGB(true); core.SetEverdriveFolder(folder);
    Check(core.LoadROM(image,false),"SGB OS startup");
    auto syms=Symbols(symbols); auto memory=core.GetMemory(); auto cpu=core.GetProcessor()->GetState();
    // The probe runs before Main clears WRAM. A stale source flag must not
    // turn the palette pointer into a PSRAM block number.
    memory->Write(syms.at("sgb_from_window"),0xA5);
    unsigned swaps=0, returned=0, saved_window=0, scx=0, scy=0;
    std::vector<u8> saved;
    for(unsigned i=0;i<40000000 && !returned;++i) {
        if(!core.GetProcessor()->DuringOpCode() && cpu->PC->GetValue()==syms.at("sgb_SwapDisplay")) {
            Check(memory->Read(0xFFFF)==0,"interrupts masked during LCD transfers");
            Check(!(memory->Read(0xFF40)&128),"display off while saving/restoring VRAM");
            ++swaps;
            if(swaps==1) {
                saved=VRAM(memory);
                saved_window=memory->Read(0xBD02) | memory->Read(0xBD03)<<8;
                scx=memory->Read(0xFF43); scy=memory->Read(0xFF42);
                memory->Write(0xFF43,3); memory->Write(0xFF42,11);
            } else {
                unsigned sp=cpu->SP->GetValue();
                unsigned destination=memory->Read(sp) | memory->Read(sp+1)<<8;
                do { unsigned ticks=0; core.RunCycle(frame.data(),ticks); }
                while(cpu->PC->GetValue()!=destination);
                auto restored=VRAM(memory);
                for (unsigned j=0;j<saved.size();++j) if(restored[j]!=saved[j]) {
                    fprintf(stderr,"VRAM %04x: before=%02x after=%02x window=%02x:%02x PC=%04x\n",
                            0x8800+j,saved[j],restored[j],memory->Read(0xBD03),memory->Read(0xBD02),cpu->PC->GetValue());
                    break;
                }
                Check(restored==saved,"border upload restores all borrowed tiles and map bytes");
                Check((memory->Read(0xBD02) | memory->Read(0xBD03)<<8)==saved_window,"restore PSRAM window");
                Check(memory->Read(0xFF43)==3 && memory->Read(0xFF42)==11,"restore distinct SCX and SCY values");
                memory->Write(0xFF43,scx); memory->Write(0xFF42,scy);
                returned=1;
            }
        }
        unsigned ticks=0;
        if (core.RunCycle(frame.data(),ticks)) core.RenderFrameBuffer(frame.data());
        if(i%3000==2999) { s16 audio[AUDIO_BUFFER_SIZE];int n=0;core.EndFrame(audio,&n); }
    }
    Check(swaps==2 && returned,"startup completes border transfers");
    Frames(core,500);
    Check(memory->Read(syms.at("sys_info"))&1,"OS detects SGB (SYS_INFO_SGB)");
    Check(memory->Read(syms.at("_data_loaded"))==1,"load editor assets");
    auto rom=Read(image);
    Check(!memcmp(core.GetSGB()->GetSystemPalettes(),rom.data()+15*8192+syms.at("DefaultPalettes")-0xA000,128),
          "PAL_TRN uses ROM palettes despite uninitialized WRAM source flag");
    auto border=core.GetSGB()->GetBorder();
    Check(!memcmp(border->tiles,bytes.data()+41*512,8192),"both CHR_TRN payloads survive LCD transport");
    Check(!memcmp(border->map,bytes.data()+57*512,2048),"PCT_TRN map survives LCD transport");
    Check(!memcmp(border->palette,bytes.data()+57*512+2048,128),"PCT_TRN palettes survive LCD transport");
    Pixels(core,syms);
    if (const char* path=getenv("FATPAK_SGB_SCREENSHOT")) {
        FILE* file=fopen(path,"wb"); Check(file,"create screenshot");
        fprintf(file,"P6\n256 224\n255\n");
        for (u16 pixel : frame) {
            const u8 rgb[]={u8((pixel>>11)*255/31),u8(((pixel>>5)&63)*255/63),u8((pixel&31)*255/31)};
            fwrite(rgb,1,3,file);
        }
        fclose(file);
    }
    core.KeyPressed(Down_Key);Frames(core,40);core.KeyReleased(Down_Key);Frames(core,20);
    Pixels(core,syms);
    core.KeyPressed(Start_Key);Frames(core,4);core.KeyReleased(Start_Key);Frames(core,20);
    Pixels(core,syms);
    printf("SGB startup, border payloads, browser scrolling and menu raster passed (%s)\n",folder);
}
int main(int argc,char** argv) {
    Check(argc==4,"usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT");
    Modes(argv[1]); Startup(argv[1],argv[2],argv[3]);
}
