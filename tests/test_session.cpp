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
    { // Shift + an arrow selects (the arrow held as the d-pad: its modifiers are the queued key's)
      core->QueuePS2KeyboardScanCode(0x12);Frames(*core,4);
      core->QueuePS2KeyboardScanCode(0xE0);core->QueuePS2KeyboardScanCode(0x6B);Frames(*core,4);
      core->QueuePS2KeyboardScanCode(0xE0);core->QueuePS2KeyboardScanCode(0xF0);core->QueuePS2KeyboardScanCode(0x6B);Frames(*core,30);
      core->QueuePS2KeyboardScanCode(0xF0);core->QueuePS2KeyboardScanCode(0x12);Frames(*core,60);
      printf("shift+left: selecting %u mods %u\n",byte("_selecting"),byte("kb_modifiers"));
      Check(byte("_selecting"),"Shift + Left selects");}
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
    { // a held PS/2 arrow repeats at the d-pad's rate while the keyboard repeats it; a lost release byte can't
      // leave it repeating: it counts as released once the keyboard's own repeats stop
      auto down=[&](){core->QueuePS2KeyboardScanCode(0xE0);core->QueuePS2KeyboardScanCode(0x72);};
      down();Frames(*core,20);Check(byte("kb_held_key"),"a PS/2 arrow key held");
      for(unsigned i=0;i<20;++i){down();Frames(*core,6);}
      Check(byte("kb_held_key"),"still held while the keyboard repeats it");
      Frames(*core,120);Check(!byte("kb_held_key"),"released once the keyboard's repeats stop (its release byte lost)");
      core->QueuePS2KeyboardScanCode(0xE0);core->QueuePS2KeyboardScanCode(0xF0);core->QueuePS2KeyboardScanCode(0x72);Frames(*core,30);
    }
    power();Check(byte("_render_text")==1 && byte("_doc_large") && text("_file_name")=="Large.txt","cold boot reopens large file without restoring a stale window");
    close(false);power();Check(byte("_render_text")==0 && !byte("_doc_large") && text("_file_name").empty(),"closed large file stays closed");
    delete core;
    printf("%s cold-start open, modified, closed, last-folder, missing-folder and large-file sessions passed\n",color?"CGB":"DMG");
}
// UTF-8 (FileLoad/FileSave): two-byte sequences (U+0080-U+00FF) decoded to the text buffer's one byte and encoded
// again, also across a read's 512 bytes; Latin-1 and UTF-8 beyond U+00FF keep their bytes (FS_RAW); CR LF kept
static void Utf8(const char* image,const char* symbols,const char* data) {
    char folder[]="/tmp/fatpak-utf8-XXXXXX";Check(mkdtemp(folder),"UTF-8 SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);Write(root+"/GBCSYS/EDITOR.DAT",Read(data));
    auto bytes=[](const std::string& s){return std::vector<u8>(s.begin(),s.end());};
    std::string split(511,'x');split+="\xC3\xA9 end\n";
    const struct {const char* name;std::string text;unsigned at;u8 want,flags;} cases[]={
        {"utf8.txt","caf\xC3\xA9 \xC2\xBF?\n",3,0xE9,0},{"latin.txt","caf\xE9\n",3,0xE9,2},
        {"emoji.txt","a\xF0\x9F\x98\x80" "b\n",1,0xF0,2},{"crlf.txt","\xC3\xB1o\r\n",0,0xF1,1},
        {"split.txt",split,511,0xE9,0},{"cut.txt","ab\xC3",2,0xC3,2}};
    for(const auto& c:cases)Write(root+"/"+c.name,bytes(c.text));
    GearboyCore core;core.Init();core.SetEverdriveFolder(folder);Check(core.LoadROM(image,false),"UTF-8 OS");Frames(core,600);
    auto syms=Symbols(symbols);auto m=core.GetMemory();unsigned path=syms.at("tile_buffer");
    for(const auto& c:cases){
        Text(m,path,std::string("/")+c.name);
        Check(Call(core,syms.at("_FileLoad"),path)==0,"load");
        u8 got=Call(core,syms.at("_tb_GetChar"),c.at);
        if(got!=c.want || m->Read(syms.at("_fs_crlf"))!=c.flags)fprintf(stderr,"%s: char %02x flags %u\n",c.name,got,m->Read(syms.at("_fs_crlf")));
        Check(got==c.want,"UTF-8 decoded to one byte a character, other files' bytes kept");
        Check(m->Read(syms.at("_fs_crlf"))==c.flags,"UTF-8, raw (FS_RAW) and CR LF (FS_CRLF) remembered");
        Text(m,path,std::string("/out-")+c.name);
        Check(Call(core,syms.at("_FileSave"),path)==0,"save");
        Check(Read(root+"/out-"+c.name)==bytes(c.text),"saved byte for byte as loaded");
    }
    // a new file (fs_crlf 0) with a Latin-1 character: saved as UTF-8
    Call(core,syms.at("_tb_Clear"));m->Write(syms.at("_fs_crlf"),0);
    Check(Call(core,syms.at("_tb_Insert"),0,0xE9),"type a Latin-1 character");
    Text(m,path,"/new.txt");Check(Call(core,syms.at("_FileSave"),path)==0,"save a new file");
    Check(Read(root+"/new.txt")==bytes("\xC3\xA9"),"a new file's characters saved as UTF-8");
    printf("UTF-8 load/save, Latin-1 and UTF-8 beyond U+00FF kept, CR LF and split sequences passed\n");
}
int main(int argc,char** argv) {
    Check(argc==4,"usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT");
    Utf8(argv[1],argv[2],argv[3]);
    Sessions(argv[1],argv[2],argv[3],false);Sessions(argv[1],argv[2],argv[3],true);
}
