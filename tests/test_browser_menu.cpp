// Browser menus and real FatFs file/folder operations in the assembled OS.
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

static void Text(Memory* memory, unsigned address, const std::string& text) {
    for (unsigned i = 0; i <= text.size(); ++i) memory->Write(address+i, text[i]);
}
static std::string Text(Memory* memory, unsigned address) {
    std::string value;
    while (memory->Read(address)) value += char(memory->Read(address++));
    return value;
}
static void Operations(const char* image, const char* symbols) {
    char folder[]="/tmp/fatpak-files-XXXXXX"; Check(mkdtemp(folder),"temporary SD");
    std::string root(folder);
    mkdir((root+"/Tree").c_str(),0700); mkdir((root+"/Tree/Nested").c_str(),0700);
    mkdir((root+"/Tree/Empty").c_str(),0700); mkdir((root+"/Destination").c_str(),0700);
    std::vector<u8> bytes(1703); for(unsigned i=0;i<bytes.size();++i) bytes[i]=u8(i*37);
    Write(root+"/Tree/Nested/Long file name.txt",bytes);
    Write(root+"/Tree/Zero.txt",{}); Write(root+"/Original.txt",bytes);
    GearboyCore core; core.Init();core.SetEverdriveFolder(folder);Check(core.LoadROM(image,false),"file API OS");
    auto memory=core.GetMemory();auto syms=Symbols(symbols);
    memory->Write(0xBD0A,0xA5);memory->Write(0xBD06,4);memory->Write(0xBD08,4);
    memory->Write(syms.at("loaded_bank"),4);memory->Write(0xFFFF,0);memory->Write(0xFF40,0);
    Check(Call(core,syms.at("_FileMount"))==0,"mount fixture");
    auto operation=[&](const char* routine,const char* from,const char* to) {
        Text(memory,0xDC00,from); Text(memory,0xDD00,to);
        core.GetProcessor()->GetState()->BC->SetValue(0xDD00);
        return Call(core,syms.at(routine),0xDC00);
    };
    Check(operation("_FileCopy","/Original.txt","/Duplicate.txt")==0,"copy file across sectors");
    Check(Read(root+"/Duplicate.txt")==bytes,"file copy preserves all bytes");
    Check(operation("_FileCopy","/Original.txt","/Duplicate.txt")==8,"copy refuses overwrite");
    Check(operation("_FileCopy","/Tree","/Destination/Tree")==0,"copy nested folder");
    Check(Read(root+"/Destination/Tree/Nested/Long file name.txt")==bytes,"nested long-name file preserved");
    struct stat st;
    Check(stat((root+"/Destination/Tree/Empty").c_str(),&st)==0 && S_ISDIR(st.st_mode),"empty subfolder copied");
    Check(stat((root+"/Destination/Tree/Zero.txt").c_str(),&st)==0 && st.st_size==0,"empty file copied");
    Check(operation("_FileCopy","/Tree","/Tree/Loop")==7,"copy rejects own descendant");
    Check(operation("_FileRename","/Tree","/Tree/Loop")==7,"move rejects own descendant");
    Check(operation("_FileRename","/Tree","/Destination/Tree")==8,"move refuses overwrite");
    Text(memory,syms.at("_file_dir"),"/Tree/Nested");
    Text(memory,syms.at("_file_name"),"Long file name.txt");
    Check(operation("_FileRename","/Tree","/Moved")==0,"move folder");
    Check(Text(memory,syms.at("_file_dir"))=="/Moved/Nested","move updates open document directory");
    Check(operation("_FileRenameName","/Moved/Nested/Long file name.txt","Renamed.txt")==0,"rename file");
    Check(Text(memory,syms.at("_file_name"))=="Renamed.txt","rename updates document save target");
    // Folder mode retains the old host-directory mapping after f_rename.
    // Read through FatFs to check the actual on-card path and contents.
    Check(operation("_FileCopy","/Moved/Nested/Renamed.txt","/Verified.txt")==0,"renamed FAT path is readable");
    Check(Read(root+"/Verified.txt")==bytes,"move and rename preserve contents");
    Check(operation("_FileRenameName","/Moved","..")==6,"reject parent name");
    Check(operation("_FileRenameName","/Moved/Nested/Renamed.txt","RENAMED.TXT")==0,"case-only rename");
    Check(Text(memory,syms.at("_file_name"))=="RENAMED.TXT","case-only rename updates save target");
    Check(operation("_FileCopy","/Missing.txt","/MissingCopy.txt")==4,"missing source returns error");
    puts("File/folder copy, cut/move, rename, collisions and document paths passed");
}

static void UI(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-browser-XXXXXX";Check(mkdtemp(folder),"temporary browser SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));Write(root+"/Document.txt",{'h','i','\n'});
    GearboyCore core;core.Init();core.SetEverdriveFolder(folder);core.SetPS2KeyboardEnabled(true);
    Check(core.LoadROM(image,!color),"browser UI OS");auto memory=core.GetMemory();auto syms=Symbols(symbols);
    auto byte=[&](const char* name){return memory->Read(syms.at(name));};
    auto pad=[&](Gameboy_Keys key){core.KeyPressed(key);Frames(core,4);core.KeyReleased(key);Frames(core,70);};
    auto key=[&](u8 code){Check(core.QueuePS2KeyboardScanCode(code),"key down");Frames(core,4);
        core.QueuePS2KeyboardScanCode(0xF0);core.QueuePS2KeyboardScanCode(code);Frames(core,50);};
    auto ctrl=[&](u8 code){core.QueuePS2KeyboardScanCode(0x14);Frames(core,4);key(code);
        core.QueuePS2KeyboardScanCode(0xF0);core.QueuePS2KeyboardScanCode(0x14);Frames(core,20);};
    auto row=[&](unsigned n){std::string s;for(unsigned i=0;i<40;++i) {
        unsigned c=memory->Read(syms.at("tile_buffer")+n*40+i);if(!c)break;s+=char(c);
        } while(!s.empty() && s.back()==' ')s.pop_back();return s;};
    auto menu=[&](){pad(Start_Key);Check(byte("_render_box_rows")==7,"untitled five-item browser menu");
        Check(Text(memory,syms.at("tile_buffer")+20*40)==" FILE","first menu entry without title");};
    Frames(core,600);
    for(unsigned i=0;i<32;++i) memory->Write(syms.at("stack_top")+i,0xA5);
    pad(Down_Key); // select Document.txt
    menu();pad(A_Key);Check(byte("_render_box_rows")==4,"file submenu");
    pad(B_Key);Check(byte("_render_box_rows")==7,"B returns to main menu");
    pad(A_Key);pad(A_Key);Check(byte("_render_box_rows")>=6,"file info popup");
    pad(B_Key);Check(byte("_render_text")==0 && byte("_render_box_top")==255,"info returns to browser");
    menu();pad(A_Key);pad(Down_Key);pad(A_Key); // rename prompt
    Check(byte("_osk_shown")==1,"rename automatically opens on-screen keyboard");
    Check(row(1).find("Document.txt_")!=std::string::npos,"rename edits selected row in place");
    Check(row(18).find("Rename")==std::string::npos,"rename leaves path header intact");
    key(0x1C);ctrl(0x1A);Check(row(1).find("Document.txt_")!=std::string::npos,"keyboard undo restores filename");
    ctrl(0x35);Check(row(1).find("Document.txta_")!=std::string::npos,"keyboard redo restores filename edit");
    // The OSK undo and redo keys must edit this field, not the document.
    memory->Write(syms.at("_osk_y"),4);memory->Write(syms.at("_osk_x"),7);
    pad(A_Key);Check(row(1).find("Document.txt_")!=std::string::npos,"OSK undo edits filename");
    memory->Write(syms.at("_osk_x"),8);pad(A_Key);
    Check(row(1).find("Document.txta_")!=std::string::npos,"OSK redo edits filename");
    ctrl(0x1A);
    for(unsigned i=0;i<12;++i) key(0x66); // erase Document.txt
    key(0x1C);key(0x5A); // a, enter
    struct stat st;Check(stat((root+"/a").c_str(),&st)==0,"browser rename action");
    menu();pad(Down_Key);pad(A_Key);pad(Down_Key);pad(A_Key); // Edit > Copy
    pad(Up_Key);pad(A_Key); // enter GBCSYS
    menu();pad(Down_Key);pad(A_Key);pad(Down_Key);pad(Down_Key);pad(A_Key); // Paste
    Check(Read(root+"/GBCSYS/a")==std::vector<u8>({'h','i','\n'}),"browser clipboard pastes in another directory");
    menu();pad(Down_Key);pad(Down_Key);pad(A_Key);
    Check(byte("_render_box_rows")==4,"browser has exactly two settings");
    Check(Text(memory,syms.at("tile_buffer")+20*40)==" CLOCK","clock is a browser setting");
    Check(Text(memory,syms.at("tile_buffer")+20*40+20)==" KEYBOARD TEST","keyboard test is a browser setting");
    pad(Down_Key);pad(A_Key);Check(row(0)=="KEYBOARD TEST","browser settings launches keyboard test");pad(B_Key);
    Check(byte("_render_text")==0 && byte("_tb_rows")==16 && byte("_bars")==1,"settings restore browser layout");
    menu();pad(Down_Key);pad(Down_Key);pad(Down_Key);pad(A_Key);
    Check(row(0)=="FILE BROWSER","help directly opens browser help");
    pad(Down_Key);Check(row(0)!="FILE BROWSER","browser help scrolls down");
    pad(A_Key);Check(byte("_tb_rows")==18,"A does not dismiss help");pad(B_Key);
    Check(byte("_render_text")==0 && byte("_tb_rows")==16,"help returns to browser");
    pad(B_Key);pad(B_Key); // root, then editor
    menu();pad(Down_Key);pad(Down_Key);pad(A_Key);
    Check(byte("_render_box_rows")==4,"editor has exactly two settings");
    Check(Text(memory,syms.at("tile_buffer")+20*40)==" LINE WRAP","line wrap is an editor setting");
    Check(Text(memory,syms.at("tile_buffer")+20*40+20)==" FULL SCREEN","full screen is an editor setting");
    pad(B_Key);pad(Down_Key);pad(A_Key);
    Check(row(0)=="TEXT EDITOR","editor help opens directly with editor controls");
    pad(Down_Key);Check(row(0)!="TEXT EDITOR","editor help scrolls");
    pad(B_Key);Check(byte("_render_text")==1,"B returns from help to editor");
    key(0x1C);pad(Select_Key);
    memory->Write(syms.at("_osk_y"),4);memory->Write(syms.at("_osk_x"),7);pad(A_Key);
    Check(memory->Read(syms.at("tb_len"))==0,"editor OSK undo still edits the document");
    memory->Write(syms.at("_osk_x"),8);pad(A_Key);
    Check(memory->Read(syms.at("tb_len"))==1,"editor OSK redo still edits the document");
    pad(Select_Key);ctrl(0x1A);
    ctrl(0x44);Check(byte("_render_text")==0,"reopen browser");
    for(unsigned i=0;i<32;++i) Check(memory->Read(syms.at("stack_top")+i)==0xA5,"menu and transfers stay within stack");
    menu();for(unsigned i=0;i<4;++i) pad(Down_Key);
    core.KeyPressed(A_Key);
    bool reset=false;
    for(unsigned i=0;i<1000000 && !reset;++i) {
        reset=static_cast<EverdriveOSMemoryRule*>(memory->GetCurrentRule())->PeekSwitch()==2;
        if(reset) break;
        unsigned ticks=0;core.RunCycle(frame.data(),ticks);
        if(i%3000==2999) { s16 audio[AUDIO_BUFFER_SIZE];int n=0;core.EndFrame(audio,&n); }
    }
    Check(reset,"Restart requests full cartridge reset rather than a warm jump");
    core.KeyReleased(A_Key);
    Check(memory->Read(0xBD06)==0x10,"restart selects cartridge reset configuration");
    Check(!*core.GetProcessor()->GetState()->IME,"restart disables interrupts while waiting for reset");
    // Gearboy consumes OS reset requests only after a game has been launched.
    // Verify the hardware request here, then clear it for the font API checks.
    static_cast<EverdriveOSMemoryRule*>(memory->GetCurrentRule())->TakeSwitch();
    auto asset=Read(data);
    for(unsigned glyph : {0u,97u,233u,255u}) {
        memory->Write(0xBD02,0x79);memory->Write(0xBD03,1);
        core.GetProcessor()->GetState()->BC->SetValue(glyph*8);
        Call(core,syms.at("RenderFixedGlyph"));
        for(unsigned row=0;row<8;++row)
            Check(memory->Read(syms.at("render_glyph")+row)==asset[65*512+glyph*8+row],"fixed glyph matches EDITOR.DAT");
        Check(memory->Read(0xBD02)==0x79 && memory->Read(0xBD03)==1,"glyph fetch restores text window");
    }
    Call(core,syms.at("_SetFont"),0,2);
    for(unsigned i=0;i<256;++i) Check(memory->Read(syms.at("_font_widths")+i)==4,"fixed font widths");
    printf("%s browser menus, info, rename, copy/paste, settings, help, restart and fixed font passed\n",color?"CGB":"DMG");
}

static void RenameEdges(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-rename-XXXXXX";Check(mkdtemp(folder),"rename edge SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);mkdir((root+"/Folder").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));
    for(unsigned i=0;i<19;++i) { char file[32];snprintf(file,sizeof(file),"/Z%02u.txt",i);Write(root+file,{'x'}); }
    GearboyCore core;core.Init();core.SetEverdriveFolder(folder);core.SetPS2KeyboardEnabled(true);
    Check(core.LoadROM(image,!color),"rename edge OS");auto memory=core.GetMemory();auto syms=Symbols(symbols);
    auto pad=[&](Gameboy_Keys key){core.KeyPressed(key);Frames(core,4);core.KeyReleased(key);Frames(core,70);};
    auto extended=[&](u8 code){core.QueuePS2KeyboardScanCode(0xE0);core.QueuePS2KeyboardScanCode(code);Frames(core,4);
        core.QueuePS2KeyboardScanCode(0xE0);core.QueuePS2KeyboardScanCode(0xF0);core.QueuePS2KeyboardScanCode(code);Frames(core,70);};
    auto rename=[&](){pad(Start_Key);pad(A_Key);pad(Down_Key);pad(A_Key);};
    Frames(core,600);extended(0x69);rename(); // final entry, initially at screen bottom
    Check(memory->Read(syms.at("_name_row"))==10,"bottom entry moves above keyboard");
    Check(Text(memory,syms.at("tile_buffer")+10*40).find("Z18.txt_")!=std::string::npos,"bottom rename stays visible");
    pad(Start_Key); // cancel
    extended(0x6C);
    if(Text(memory,syms.at("tile_buffer")).substr(0,40).find("Folder/")==std::string::npos) pad(Down_Key);
    rename(); // Folder
    unsigned field=memory->Read(syms.at("_name_row"));
    Check(Text(memory,syms.at("tile_buffer")+field*40).find("Folder_")!=std::string::npos,"folder name edited in place");
    for(unsigned i=0;i<6;++i)pad(B_Key);
    pad(A_Key); // default keyboard selection types 1
    for(unsigned i=0;i<4;++i)pad(Down_Key);pad(Left_Key);pad(A_Key); // return key
    Check(Text(memory,syms.at("tile_buffer")).find("1/")!=std::string::npos,"folder rename accepts joypad keyboard input");
    Check(memory->Read(syms.at("tb_len"))==0,"rename history preserves document text");
    printf("%s bottom-row and folder rename with joypad keyboard passed\n",color?"CGB":"DMG");
}
int main(int argc,char** argv) {
    Check(argc==4,"usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT");
    Operations(argv[1],argv[2]);UI(argv[1],argv[2],argv[3],false);UI(argv[1],argv[2],argv[3],true);
    RenameEdges(argv[1],argv[2],argv[3],false);RenameEdges(argv[1],argv[2],argv[3],true);
}
