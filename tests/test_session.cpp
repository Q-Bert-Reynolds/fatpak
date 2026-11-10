// Cold-start session persistence through real browser/editor actions.
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
static void Sessions(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-session-XXXXXX";Check(mkdtemp(folder),"session SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);mkdir((root+"/Work").c_str(),0700);
    mkdir((root+"/Work/Nested").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));Write(root+"/Work/Clean.txt",{'h','i','\n'});
    std::vector<u8> large(70000,'z');for(unsigned i=63;i<large.size();i+=64)large[i]='\n';
    Write(root+"/Work/Large.txt",large);
    auto syms=Symbols(symbols);
    auto boot=[&](){
        GearboyCore* core=new GearboyCore;core->Init();core->SetEverdriveFolder(folder);core->SetPS2KeyboardEnabled(true);
        Check(core->LoadROM(image,!color),"session OS");Frames(*core,600);return core;
    };
    GearboyCore* core=boot();
    auto byte=[&](const char* name){return core->GetMemory()->Read(syms.at(name));};
    auto text=[&](const char* name){return Text(core->GetMemory(),syms.at(name));};
    auto header=[&](){std::string value;for(unsigned i=0;i<40;++i)value+=char(core->GetMemory()->Read(syms.at("tile_buffer")+18*40+i));return value;};
    auto pad=[&](Gameboy_Keys key){core->KeyPressed(key);Frames(*core,4);core->KeyReleased(key);Frames(*core,70);};
    auto key=[&](u8 code){core->QueuePS2KeyboardScanCode(code);Frames(*core,4);core->QueuePS2KeyboardScanCode(0xF0);core->QueuePS2KeyboardScanCode(code);Frames(*core,160);};
    auto power=[&](){delete core;core=boot();};
    auto close=[&](bool discard){pad(Start_Key);for(unsigned i=0;i<4;++i)pad(Down_Key);pad(A_Key);
        if(discard){pad(Down_Key);pad(A_Key);}};
    Check(byte("_render_text")==0,"fresh boot starts in browser");
    pad(Down_Key);pad(A_Key); // Work
    pad(Down_Key);pad(Down_Key);pad(A_Key); // Clean.txt after Nested
    Check(byte("_render_text")==1 && text("_file_name")=="Clean.txt" && !byte("_modified"),"open clean file");
    power();Check(byte("_render_text")==1 && text("_file_name")=="Clean.txt" && !byte("_modified"),"cold boot resumes a clean open file");
    key(0x1C);Check(byte("_modified"),"edit restored file");
    power();Check(byte("_render_text")==1 && byte("_modified") && Call(*core,syms.at("_tb_GetChar"),0)=='a',"cold boot preserves matching unsaved text");
    // The direct buffer call above bypasses the frame loop, so boot again before input.
    power();close(true);
    Check(byte("_render_text")==0 && text("_file_name").empty() && !byte("_modified"),"Close clears the document and enters browser");
    pad(Down_Key);pad(A_Key); // Nested
    power();Check(byte("_render_text")==0 && header().find("/Work/Nested")!=std::string::npos && text("_file_name").empty(),"closed file stays closed; cold boot restores last browser folder");
    delete core;Check(rmdir((root+"/Work/Nested").c_str())==0,"remove remembered directory");core=boot();
    Check(byte("_render_text")==0 && text("_file_dir").empty() && header().substr(0,2)==" /","missing remembered directory falls back to root");
    pad(Down_Key);pad(A_Key);pad(Down_Key);pad(Down_Key);pad(A_Key); // Work / Large.txt
    Frames(*core,600);
    Check(byte("_doc_large") && text("_file_name")=="Large.txt","open large file");
    power();Check(byte("_render_text")==1 && byte("_doc_large") && text("_file_name")=="Large.txt","cold boot reopens large file without restoring a stale window");
    close(false);power();Check(byte("_render_text")==0 && !byte("_doc_large") && text("_file_name").empty(),"closed large file stays closed");
    delete core;
    printf("%s cold-start open, modified, closed, last-folder, missing-folder and large-file sessions passed\n",color?"CGB":"DMG");
}
int main(int argc,char** argv) {
    Check(argc==4,"usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT");
    Sessions(argv[1],argv[2],argv[3],false);Sessions(argv[1],argv[2],argv[3],true);
}
