// Browser menus and real FatFs file/folder operations in the assembled OS.
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
static unsigned call_stack;
static unsigned call_bc;
static unsigned Call(GearboyCore& core, unsigned address, unsigned argument = 0, u8 a = 0, unsigned bc = 0)
{
    auto cpu = core.GetProcessor()->GetState(); auto memory = core.GetMemory();
    cpu->SP->SetValue(call_stack); memory->Write(call_stack, 0xFF); memory->Write(call_stack+1, 0x7F);
    cpu->BC->SetValue(bc); cpu->DE->SetValue(argument); cpu->AF->SetValue(a << 8); cpu->PC->SetValue(address);
    for (unsigned i = 0; i < 80000000 && cpu->PC->GetValue() != 0x7FFF; ++i)
    {
        unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
        if (i % 3000 == 2999) { s16 audio[AUDIO_BUFFER_SIZE]; int n = 0; core.EndFrame(audio, &n); }
    }
    Check(cpu->PC->GetValue() == 0x7FFF, "OS routine returns");
    call_bc = cpu->BC->GetValue(); // 16-bit results come back in bc
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
static std::vector<u8> Page(Memory* m,unsigned page=13) {
    unsigned old=m->Read(0xBD08);m->Write(0xBD08,page);
    std::vector<u8> bytes(0x1D00);
    for(unsigned i=0;i<bytes.size();++i)bytes[i]=m->Read(0xA000+i);
    m->Write(0xBD08,old);return bytes;
}
static void Modules(const char* image,const char* symbols,const char* data,const char* fixtures,bool color) {
    char folder[]="/tmp/fatpak-module-XXXXXX";Check(mkdtemp(folder),"module SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));
    // Each malformed file has a distinct path: the emulator's FAT image is a
    // snapshot of the folder when mounted.
    const char* names[]={"valid","magic","version","abi","id","page","address","entry","length","bss","reserved","crc","short","trailing","empty","abizero","abinew","context","max","wide","widepage","widelength","widebss","wide3","widepage3","widelength3","wide4","widepage4"};
    for(const char* name:names)Write(root+"/"+name+".MOD",Read(std::string(fixtures)+"/"+name+".MOD"));
    std::vector<u8> large(70000,'z');for(unsigned i=63;i<large.size();i+=64)large[i]='\n';
    Write(root+"/Large.txt",large);
    // INCLUDE paths (ModuleAPIFile): a project at proj/ with its document in proj/src/
    mkdir((root+"/proj").c_str(),0700);mkdir((root+"/proj/src").c_str(),0700);mkdir((root+"/proj/src/inc").c_str(),0700);
    Write(root+"/proj/src/inc/deep.inc",{'D','E','E','P'});Write(root+"/proj/src/base.inc",{'B','A','S','E','!'});
    GearboyCore core;core.Init();core.SetEverdriveFolder(folder);
    Check(core.LoadROM(image,!color),"module OS");Frames(core,600);
    auto memory=core.GetMemory();auto syms=Symbols(symbols);
    memory->Write(syms.at("_kb_interrupt_count"),37);
    auto original=Page(memory);
    call_stack=syms.at("stack_bottom")-2;
    for(unsigned i=0;i<32;++i)memory->Write(syms.at("stack_top")+i,0xA5);
    // Exercise swaps independently with the save-RAM window selected. The
    // final sector's upper half is a canary outside the 7424-byte page.
    memory->Write(0xBD06,4);memory->Write(0xBD03,0x3D);memory->Write(0xBD02,0x9E);
    for(unsigned i=256;i<512;++i)memory->Write(0xBE00+i,0xA5);
    memory->Write(0xBD06,6);memory->Write(0xBD03,1);memory->Write(0xBD02,0x34);
    unsigned oldpage=memory->Read(0xBD08), oldie=memory->Read(0xFFFF);
    auto swap=[&](unsigned mode){
        Check(Call(core,syms.at("_ModuleSwap"),0,mode)==0,"swap reads back what it copied");
        Check(memory->Read(0xBD08)==oldpage && memory->Read(0xFFFF)==oldie,"swap preserves mapping and interrupts");
        Check(memory->Read(0xBD06)==6 && memory->Read(0xBD02)==0x34 && memory->Read(0xBD03)==1,"swap preserves window/config");
    };
    swap(0);swap(1);swap(2);
    Check(Page(memory)==original,"low-level swaps restore all page bytes");
    memory->Write(0xBD06,4);memory->Write(0xBD03,0x3D);memory->Write(0xBD02,0x9E);
    for(unsigned i=256;i<512;++i)Check(memory->Read(0xBE00+i)==0xA5,"last backup sector stays bounded");
    unsigned path=syms.at("_str_buffer");
    // Use existing WRAM path scratch rather than overwriting stack/document data.
    auto run=[&](const char* name,unsigned expected) {
        Text(memory,path,std::string("/")+name+".MOD");
        memory->Write(0xBD03,0x01);memory->Write(0xBD02,0x34);
        unsigned before_page=memory->Read(0xBD08), before_ie=memory->Read(0xFFFF), before_config=memory->Read(0xBD06);
        unsigned actual=Call(core,syms.at("_RunModule"),path,1);
        if(actual!=expected)fprintf(stderr,"%s: status %u expected %u pc %04x\n",name,actual,expected,core.GetProcessor()->GetState()->PC->GetValue());
        Check(actual==expected,"module result");Check(Page(memory)==original,"byte-identical OS page restoration");
        Check(memory->Read(0xBD08)==before_page,"caller page restored");
        Check(memory->Read(0xBD06)==before_config,"window config restored");
        // UI APIs may use the window themselves, so its entry selector is only
        // guaranteed by the low-level swap and staging functions individually.
        Check(memory->Read(0xFFFF)==before_ie,"interrupt mask restored");
        Check(memory->Read(syms.at("_module_busy"))==0,"module guard released");
    };
    memory->Write(syms.at("_module_busy"),1);
    Text(memory,path,"/valid.MOD");Check(Call(core,syms.at("_RunModule"),path,1)==16,"nested invocation rejected");
    Check(Page(memory)==original,"nested rejection leaves page alone");memory->Write(syms.at("_module_busy"),0);
    const unsigned invalid=9, abi=20; // FR_INVALID_OBJECT, MODULE_ERR_ABI
    run("missing",4);
    for(unsigned i=1;i<15;++i)run(names[i],std::string(names[i])=="abi"?abi:invalid);
    run("abizero",abi);run("abinew",abi);
    run("valid",0);run("valid",0);run("max",0);
    Check(memory->Read(syms.at("_module_status"))==0,"module result kept in module_status");
    // wide: both pages and the WRAMX buffers come back; the BSS is zeroed for every run
    auto original12=Page(memory,12);
    std::vector<u8> buffers(3072);for(unsigned i=0;i<buffers.size();++i)buffers[i]=memory->Read(0xD000+i);
    for(unsigned pass=0;pass<2;++pass){
        run("wide",0);
        Check(memory->Read(syms.at("_module_status"))==0x42,"wide module calls across its pages with zeroed BSS");
        Check(Page(memory,12)==original12,"second borrowed page restored");
        bool same=true;for(unsigned i=0;i<buffers.size();++i)same=same&&memory->Read(0xD000+i)==buffers[i];
        Check(same,"editor buffers restored after a wide module");
    }
    run("widepage",invalid);run("widelength",invalid);run("widebss",invalid);
    // three pages: 13 -> 5 -> 12 and back; page 5 comes back too
    auto original5=Page(memory,5);
    run("wide3",0);
    Check(memory->Read(syms.at("_module_status"))==0x43,"three-page module calls across all its pages");
    Check(Page(memory,5)==original5 && Page(memory,12)==original12,"third borrowed page restored");
    run("widepage3",invalid);run("widelength3",invalid);
    // four pages: 13 -> 4 -> 5 -> 12 and back; page 4 comes back too
    auto original4=Page(memory,4);
    run("wide4",0);
    Check(memory->Read(syms.at("_module_status"))==0x44,"four-page module calls across all its pages");
    Check(Page(memory,4)==original4 && Page(memory,5)==original5 && Page(memory,12)==original12,"fourth borrowed page restored");
    run("widepage4",invalid);
    memory->Write(syms.at("_module_context"),0x34);memory->Write(syms.at("_module_context")+1,0x12);
    run("context",0);
    Check(memory->Read(syms.at("_module_status"))==0x34,"module receives module_context in DE");
    Check(memory->Read(syms.at("_module_context"))==0 && memory->Read(syms.at("_module_context")+1)==0,"context cleared after the call");
    Check(Text(memory,syms.at("tile_buffer")+3*40).substr(0,13)=="MODULE STRING","module-local literal marshaled before page change");
    {
        auto file=[&](const char* name){Text(memory,path,name);Call(core,syms.at("_ModuleAPIFile"),path,0,0x1000);return call_bc;};
        auto first=[&](){memory->Write(0xBD03,0x10);memory->Write(0xBD02,0x00);return memory->Read(0xBE00);};
        Text(memory,syms.at("_file_dir"),"proj/src");
        Check(file("inc/deep.inc")==4 && first()=='D',"INCLUDE finds a path from the document's folder");
        Check(file("src/inc/deep.inc")==4 && first()=='D',"INCLUDE finds a path from a folder above it (a project's root)");
        Check(file("lib/base.inc")==5 && first()=='B',"INCLUDE falls back to the base name in the document's folder");
        Check(file("nothere.inc")==0,"a missing INCLUDE reads nothing");
        memory->Write(syms.at("_file_dir"),0);
        memory->Write(0xBD03,1);memory->Write(0xBD02,0x34);
    }
    Text(memory,path,"/Large.txt");Check(Call(core,syms.at("_FileLoadLarge"),path)==0,"open large document");
    unsigned position=syms.at("_doc_pos");
    std::vector<u8> state;for(unsigned i=0;i<4;++i)state.push_back(memory->Read(position+i));
    run("valid",0);
    Check(memory->Read(syms.at("_doc_large")),"module preserves large document handle");
    for(unsigned i=0;i<4;++i)Check(memory->Read(position+i)==state[i],"module preserves document position");
    Check(Call(core,syms.at("_FileLoadWindow"))==0,"large document reads after module return");
    for(unsigned i=0;i<32;++i)Check(memory->Read(syms.at("stack_top")+i)==0xA5,"loader and SDK stay within host stack");
    printf("%s modules: malformed files, ABI versions, context, BSS, repeated calls, pointer marshaling, full page restoration and open document passed\n",color?"CGB":"DMG");
}
int main(int argc,char** argv) {
    Check(argc==5,"usage: modules GBCOS.BIN GBCOS.sym EDITOR.DAT fixtures");
    Modules(argv[1],argv[2],argv[3],argv[4],false);
    Modules(argv[1],argv[2],argv[3],argv[4],true);
}
