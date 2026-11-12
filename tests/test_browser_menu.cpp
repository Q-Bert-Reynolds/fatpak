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
#include <dirent.h>
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
    Write(root+"/Mixed.txt",{'a',' ','b','\r','\n','c','\r','d','\n'});
    Write(root+"/Tail.txt",{'a','\t','b'}); Write(root+"/Blank.txt",{'\n','\n'});
    Write(root+"/Binary.txt",{'a',0,'b'});Write(root+"/Large.txt",std::vector<u8>(32769,'a'));
    std::vector<u8> game(512);std::string title="TEST GAME";
    for(unsigned i=0;i<title.size();++i)game[0x134+i]=title[i];
    game[0x143]=0xC0;game[0x146]=3;game[0x147]=0x10;game[0x148]=6;game[0x149]=3;
    game[0x14A]=1;game[0x14C]=2;
    for(unsigned i=0x134;i<=0x14C;++i)game[0x14D]-=game[i]+1;
    Write(root+"/Game.gbc",game);game[0x14D]^=1;Write(root+"/Bad.gb",game);
    Write(root+"/Short.gb",std::vector<u8>(0x140));
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
    auto number=[&](unsigned address){unsigned long n=0;for(unsigned i=0;i<4;++i)n|=(unsigned long)memory->Read(address+i)<<(8*i);return n;};
    auto inspect=[&](const char* path,bool game,unsigned status,unsigned words,unsigned lines){
        Text(memory,0xDC00,path);memory->Write(0xDD00+36,game);
        core.GetProcessor()->GetState()->BC->SetValue(0xDD00);
        Check(Call(core,syms.at("_FileInspect"),0xDC00)==0,"inspect succeeds");
        Check(memory->Read(0xDD00+37)==status,"inspect completion/binary/header status");
        if(!game && status==1)Check(number(0xDD00)==words && number(0xDD04)==lines,"word and CR/LF/CRLF line counts");
    };
    inspect("/Mixed.txt",false,1,4,3);inspect("/Tail.txt",false,1,2,1);
    inspect("/Blank.txt",false,1,0,2);inspect("/Tree/Zero.txt",false,1,0,0);
    inspect("/Binary.txt",false,2,0,0);inspect("/Large.txt",false,0,0,0);
    inspect("/Game.gbc",true,1,0,0);
    Check(memory->Read(0xDD08+15)==0xC0 && memory->Read(0xDD08+19)==0x10,"inspect retains cartridge header fields");
    inspect("/Bad.gb",true,2,0,0);inspect("/Short.gb",true,0,0,0);
    memory->Write(syms.at("_doc_large"),0);
    Text(memory,0xDC00,"/Large.txt");
    Check(Call(core,syms.at("_FileLoadLarge"),0xDC00)==0,"open persistent large document before inspection");
    inspect("/Mixed.txt",false,1,4,3);inspect("/Game.gbc",true,1,0,0);
    Check(number(syms.at("_doc_len"))==32769 && memory->Read(syms.at("_doc_large")),"inspection preserves document state");
    for(unsigned i=0;i<4;++i)memory->Write(syms.at("_win_start")+i,8192UL>>(i*8));
    Check(Call(core,syms.at("_FileLoadWindow"))==0,"inspection preserves persistent file handle for subsequent window reads");
    Check(Call(core,syms.at("_tb_GetChar"),0)=='a',"document data survives inspection");
    Call(core,syms.at("_FileCloseLarge"));
    const char* filenames[]={"test.C","test.H","test.INC","test.s","test.asm","test.MD","test.txt"};
    const unsigned languages[]={2,2,3,3,3,1,0};
    for(unsigned i=0;i<7;++i){Text(memory,0xDC00,filenames[i]);
        Check(Call(core,syms.at("_FileLanguage__far"),0xDC00)==languages[i],"file types share case-insensitive editor language detection");}
    const unsigned long sizes[]={0,512,1024,1536,1048576,3145728,0xFFFFFFFFUL};
    const char* formatted[]={"0B","512B","1KB","1.5KB","1MB","3MB","4095.9MB"};
    // PutSize lives in FILEINFO.MOD: install its page by hand and call it there.
    std::string bin=std::string(image).substr(0,std::string(image).find_last_of('/'));
    std::vector<u8> module=Read(bin+"/MODULES/FILEINFO.MOD");Check(module.size()>32,"FILEINFO.MOD built");
    auto modsyms=Symbols((bin+"/../build/modules/FILEINFO/module.sym").c_str());
    unsigned page=memory->Read(0xBD08);std::vector<u8> saved(module.size()-32);
    memory->Write(0xBD08,13);memory->Write(syms.at("loaded_bank"),13);
    for(unsigned i=0;i<saved.size();++i){saved[i]=memory->Read(0xA000+i);memory->Write(0xA000+i,module[32+i]);}
    for(unsigned i=0;i<7;++i){
        for(unsigned b=0;b<4;++b)memory->Write(0xE000+b,sizes[i]>>(8*b));
        Call(core,modsyms.at("_PutSize"),0xDC00);
        memory->Write(core.GetProcessor()->GetState()->BC->GetValue(),0);
        Check(Text(memory,0xDC00)==formatted[i],"compact size formatting including 32-bit maximum");
    }
    for(unsigned i=0;i<saved.size();++i)memory->Write(0xA000+i,saved[i]);
    memory->Write(0xBD08,page);memory->Write(syms.at("loaded_bank"),page);
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

static void HelpScroll(GearboyCore& core,const std::map<std::string,unsigned>& syms,bool color) {
    auto memory=core.GetMemory();auto cpu=core.GetProcessor()->GetState();
    Check(memory->Read(syms.at("_bars"))==1 && memory->Read(syms.at("_tb_rows"))==16,"help keeps standard bars and sixteen text rows");
    Check(memory->Read(syms.at("_render_row_lines"))==18 && memory->Read(syms.at("_render_row_lines")+17)==19,"help maps fixed header/footer rows");
    Check(memory->Read(syms.at("tile_buffer")+19*40+32)==127,"help footer includes the clock");
    Check(memory->Read(syms.at("tile_buffer")+19*40+1)==130,"help footer uses combined vertical D-pad icon");
    for(unsigned i=0;i<16*40;++i)
        Check(memory->Read(syms.at("tile_buffer")+i)!=0,"help text is space padded without terminator glyphs");
    unsigned ring=memory->Read(syms.at("_ring_top"));
    std::set<unsigned> blocks;
    std::vector<unsigned> positions(1,memory->Read(0xFF42));bool scrolled=false;
    core.KeyPressed(Down_Key);
    for(unsigned i=0;i<400000;++i) {
        unsigned pc=cpu->PC->GetValue();
        if(pc==syms.at("_ScrollRows") && memory->Read(syms.at("loaded_bank"))==5) {
            scrolled=true;core.KeyReleased(Down_Key);
        }
        if(pc==syms.at("RenderEncode")) {
            unsigned block=memory->Read(syms.at("render_block"));
            if(block!=8 && block!=17) blocks.insert(block);
        }
        unsigned ticks=0;core.RunCycle(frame.data(),ticks);
        unsigned y=memory->Read(0xFF42);if(y!=positions.back())positions.push_back(y);
        if(i%3000==2999) { s16 audio[AUDIO_BUFFER_SIZE];int n=0;core.EndFrame(audio,&n); }
    }
    core.KeyReleased(Down_Key);
    Check(scrolled && memory->Read(syms.at("_ring_top"))==((ring+1)&31),"help uses shared one-row scrolling ring");
    // RunCycle can expose one instruction's PC over several timing steps.
    // Count the physical row blocks written, rather than those repeated PCs.
    Check(blocks.size()==1,"scroll redraws only the incoming help row");
    Check(positions.back()==((positions.front()+8)&255),"help scroll advances exactly one row");
    Check(positions.size()==(color?5u:2u),"CGB animates in two-pixel steps; DMG uses one row step");
    for(unsigned i=1;i<positions.size();++i)
        Check(((positions[i]-positions[i-1])&255)==(color?2u:8u),"help reuses editor scroll animation");
}

// Every built module, as make assemble installs them on the card.
static void InstallModules(const std::string& root,const char* data)
{
    std::string bin=std::string(data).substr(0,std::string(data).find_last_of('/'))+"/MODULES/";
    mkdir((root+"/GBCSYS/MODULES").c_str(),0700);
    DIR* dir=opendir(bin.c_str());Check(dir,"bin/MODULES");unsigned count=0;
    while(dirent* entry=readdir(dir)) {
        std::string name=entry->d_name;
        if(name.size()<5 || name.substr(name.size()-4)!=".MOD") continue;
        std::vector<u8> module=Read(bin+name);Check(!module.empty(),"built module");
        Write(root+"/GBCSYS/MODULES/"+name,module);++count;
    }
    closedir(dir);Check(count>=5,"every built module installed");
}

static void UI(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-browser-XXXXXX";Check(mkdtemp(folder),"temporary browser SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));
    InstallModules(root,data);Write(root+"/Document.txt",{'h','i','\n'});
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
    Check(row(19).find(" \001Open \003Info \004Menu")==0,"browser footer shows button shortcuts");
    // Select loads FILEINFO.MOD; wait for its page rather than a fixed delay.
    core.KeyPressed(Select_Key);Frames(core,4);core.KeyReleased(Select_Key);
    for(unsigned waited=0;row(0)!=" Type: Plain Text" && waited<300;++waited)Frames(core,1);
    Frames(core,10);
    Check(row(18).find("Document.txt")!=std::string::npos,"Select directly opens file info");
    Check(row(19).find("Esc")==std::string::npos,"info footer has no keyboard shortcut hints");
    pad(B_Key);
    menu();pad(A_Key);Check(byte("_render_box_rows")==4,"file submenu");
    pad(B_Key);Check(byte("_render_box_rows")==7,"B returns to main menu");
    pad(A_Key);pad(A_Key);
    Check(byte("_render_box_top")==255 && byte("_bars")==1 && byte("_tb_rows")==16,"file info is a full page with bars");
    Check(row(18).find("Document.txt")!=std::string::npos,"info header displays filename");
    Check(row(0)==" Type: Plain Text" && row(1)==" Size: 3B","info type and byte size");
    Check(row(7)==" Words: 1" && row(8)==" Lines: 1","info counts text without trailing empty line");
    Check(row(3).find(" Created: ")==0 && row(4).find(" Accessed: ")==0 && row(5).find(" Modified: ")==0,"info displays all FAT timestamps");
    Check(row(19).find("\002Exit")!=std::string::npos && memory->Read(syms.at("tile_buffer")+19*40+32)==127,"info footer includes exit hint and clock");
    pad(A_Key);Check(row(18).find("Document.txt")!=std::string::npos,"only B or Esc dismisses file info");
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
    Check(byte("_render_box_rows")==5,"browser has three settings");
    Check(Text(memory,syms.at("tile_buffer")+20*40)==" THEME","theme is a browser setting");
    Check(Text(memory,syms.at("tile_buffer")+20*40+20)==" CLOCK","clock is a browser setting");
    Check(Text(memory,syms.at("tile_buffer")+20*40+40)==" KEYBOARD TEST","keyboard test is a browser setting");
    pad(Down_Key);pad(A_Key);Frames(core,120); // clock settings
    Check(row(19).find("\201 Edit \001Set \002Back")!=std::string::npos,"clock footer uses direction and action icons");
    auto field=[&](unsigned line){return Text(memory,syms.at("tile_buffer")+20*40+line*20);};
    Check(field(0).find(" Year 20")==0 && field(5).find(" Second ")==0 && byte("_render_box_rows")==8,"clock module lists six fields in a box");
    Check(byte("_render_box_sel")==1,"clock starts on the year");
    std::string month=field(1);pad(Down_Key);Check(byte("_render_box_sel")==2,"down selects the month");
    pad(Right_Key);Check(field(1)!=month && field(1).find(" Month ")==0,"right adjusts the selected field");
    pad(B_Key);Check(byte("_render_box_top")==255,"B exits clock settings as advertised");
    menu();pad(Down_Key);pad(Down_Key);pad(A_Key);
    pad(Down_Key);pad(Down_Key);pad(A_Key);Frames(core,180);Check(row(0)=="KEYBOARD TEST","browser settings launches keyboard test");pad(B_Key);
    Check(byte("_render_text")==0 && byte("_tb_rows")==16 && byte("_bars")==1,"settings restore browser layout");
    menu();pad(Down_Key);pad(Down_Key);pad(Down_Key);pad(A_Key); // HELP.MOD: wait for its page
    for(unsigned waited=0;row(18).find("FILE BROWSER")==std::string::npos && waited<300;++waited)Frames(core,1);
    Frames(core,150);
    Check(row(18).find("FILE BROWSER")!=std::string::npos,"help directly opens browser help with header");
    HelpScroll(core,syms,color);
    pad(A_Key);Check(byte("_tb_rows")==16,"A does not dismiss help");pad(B_Key);
    Check(byte("_render_text")==0 && byte("_tb_rows")==16,"help returns to browser");
    pad(B_Key); // root
    Check(row(18)==" /","B goes up to root");
    pad(B_Key);key(0x66);pad(Left_Key);
    Check(byte("_render_text")==0 && row(18)==" /","B, Backspace and Left stay in browser at root");
    key(0x76); // Escape still returns to the editor
    menu();pad(Down_Key);pad(Down_Key);pad(A_Key);
    Check(byte("_render_box_rows")==5,"editor has three settings");
    Check(Text(memory,syms.at("tile_buffer")+20*40)==" LINE WRAP","line wrap is an editor setting");
    Check(Text(memory,syms.at("tile_buffer")+20*40+20)==" FULL SCREEN","full screen is an editor setting");
    Check(Text(memory,syms.at("tile_buffer")+20*40+40)==" THEME","theme is an editor setting");
    pad(B_Key);pad(Down_Key);pad(A_Key); // HELP.MOD: wait for its page
    for(unsigned waited=0;row(18).find("TEXT EDITOR")==std::string::npos && waited<300;++waited)Frames(core,1);
    Frames(core,150);
    Check(row(18).find("TEXT EDITOR")!=std::string::npos,"editor help opens directly with editor header");
    HelpScroll(core,syms,color);
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
    for(unsigned base : {0u,0x800u}) for(unsigned glyph : {0u,95u,97u,233u,255u}) {
        memory->Write(0xBD02,0x79);memory->Write(0xBD03,1);
        core.GetProcessor()->GetState()->BC->SetValue(base+glyph*8);
        Call(core,syms.at("RenderFixedGlyph"));
        for(unsigned row=0;row<8;++row)
            Check(memory->Read(syms.at("render_glyph")+row)==asset[(base?73:65)*512+glyph*8+row],"fixed/monospaced glyph matches EDITOR.DAT");
        Check(memory->Read(0xBD02)==0x79 && memory->Read(0xBD03)==1,"glyph fetch restores text window");
    }
    Call(core,syms.at("_SetFont"),0,2);
    for(unsigned i=0;i<256;++i) Check(memory->Read(syms.at("_font_widths")+i)==4,"fixed font widths");
    Call(core,syms.at("_SetFont"),0,0);
    for(unsigned i=0;i<256;++i) Check(memory->Read(syms.at("_font_widths")+i)==8,"monospaced font widths");
    for(unsigned level=1;level<=4;++level) for(unsigned glyph : {32u,65u,233u})
        Check(Call(core,syms.at("_HeadingCharWidth"),glyph,level)==9-level,"constant heading widths preserve glyph layout");
    printf("%s browser menus, info, rename, copy/paste, settings, help, restart and fonts passed\n",color?"CGB":"DMG");
}

static void GameProperties(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-info-XXXXXX";Check(mkdtemp(folder),"properties SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));
    InstallModules(root,data);
    std::vector<u8> game(1536);std::string title="CRYSTAL";
    for(unsigned i=0;i<title.size();++i)game[0x134+i]=title[i];
    game[0x143]=0xC0;game[0x146]=3;game[0x147]=0x10;game[0x148]=6;game[0x149]=3;
    game[0x14A]=1;game[0x14C]=2;
    for(unsigned i=0x134;i<=0x14C;++i)game[0x14D]-=game[i]+1;
    Write(root+"/Crystal.gbc",game);
    GearboyCore core;core.Init();core.SetEverdriveFolder(folder);core.SetPS2KeyboardEnabled(true);
    Check(core.LoadROM(image,!color),"properties OS");auto memory=core.GetMemory();auto syms=Symbols(symbols);
    auto pad=[&](Gameboy_Keys key){core.KeyPressed(key);Frames(core,4);core.KeyReleased(key);Frames(core,70);};
    auto row=[&](unsigned n){std::string s;for(unsigned i=0;i<40;++i)s+=char(memory->Read(syms.at("tile_buffer")+n*40+i));
        while(!s.empty() && s.back()==' ')s.pop_back();return s;};
    auto info=[&](){pad(Select_Key);Frames(core,120);};
    Frames(core,600);info();
    Check(row(0)==" Type: Folder" && row(1)==" Size: --","folder properties avoid misleading total size");
    pad(B_Key);pad(A_Key); // enter GBCSYS, select its parent row
    pad(Select_Key);Check(row(18).find("GBCSYS")!=std::string::npos && row(0).find(" ..")==0,"Select ignores parent navigation row");
    pad(B_Key);pad(Down_Key);info();
    Check(row(18)==" Crystal.gbc" && row(0)==" Type: Game Boy ROM" && row(1)==" Size: 1.5KB","game properties filename, type and scaled size");
    Check(row(7)==" Title: CRYSTAL" && row(8)==" Platform: Color only" && row(9)==" Super GB: Yes","cartridge title and platform fields");
    Check(row(10)==" Mapper: MBC3" && row(11)==" ROM: 2MB" && row(12)==" RAM: 32KB","mapper and declared cartridge sizes");
    Check(row(13)==" Region: Overseas" && row(14)==" Revision: 2" && row(15)==" Header checksum: OK","cartridge region, version and checksum");
    Check(memory->Read(syms.at("_render_row_lines"))==18 && memory->Read(syms.at("_render_row_lines")+17)==19,"game info keeps header and footer");
    // Esc exits through the same input path as B.
    core.QueuePS2KeyboardScanCode(0x76);Frames(core,4);
    core.QueuePS2KeyboardScanCode(0xF0);core.QueuePS2KeyboardScanCode(0x76);Frames(core,70);
    Check(row(18).find("Crystal.gbc")==std::string::npos,"Esc returns to file browser");
    // The module formats whatever header the host read: rewrite the ROM in place.
    auto reopen=[&](){pad(B_Key);info();};
    for(unsigned flag : {0u,0x80u}) {
        game[0x143]=flag;game[0x14D]=0;for(unsigned i=0x134;i<=0x14C;++i)game[0x14D]-=game[i]+1;
        Write(root+"/Crystal.gbc",game);reopen();
        Check(row(8)==(flag?" Platform: GB / Color":" Platform: Game Boy"),"DMG and dual-platform cartridge flags");
    }
    game[0x147]=5;game[0x149]=0;game[0x14D]^=1;Write(root+"/Crystal.gbc",game);reopen();
    Check(row(10)==" Mapper: MBC2" && row(12)==" RAM: 512 x 4 bits" && row(15)==" Header checksum: Bad","MBC2 RAM and invalid header checksum");
    printf("%s full-screen folder and cartridge properties passed\n",color?"CGB":"DMG");
}

static void RenameEdges(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-rename-XXXXXX";Check(mkdtemp(folder),"rename edge SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);mkdir((root+"/Folder").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));
    InstallModules(root,data);
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
// The OSK's shift key in the editor and in the rename prompt, which only draws
// when a key is typed: the screen (bkg_buffer) must follow every layer change.
static void OSKShift(const char* image,const char* symbols,const char* data,bool color) {
    for(bool rename : {false,true}) {
        char folder[]="/tmp/fatpak-shift-XXXXXX";Check(mkdtemp(folder),"shift SD");
        std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);
        Write(root+"/GBCSYS/EDITOR.DAT",Read(data));InstallModules(root,data);Write(root+"/Document.txt",{'h','i','\n'});
        GearboyCore core;core.Init();core.SetEverdriveFolder(folder);
        Check(core.LoadROM(image,!color),"shift OS");auto memory=core.GetMemory();auto syms=Symbols(symbols);
        auto byte=[&](const char* name){return memory->Read(syms.at(name));};
        auto tap=[&](Gameboy_Keys key,unsigned wait){core.KeyPressed(key);Frames(core,4);core.KeyReleased(key);Frames(core,wait);};
        auto pad=[&](Gameboy_Keys key){tap(key,70);};
        auto shown=[&](unsigned osk_row){ // what the screen shows for a keyboard row
            unsigned block=memory->Read(syms.at("_osk_blocks")+osk_row);
            return Text(memory,syms.at("bkg_buffer")+block*40).substr(0,19);};
        auto at=[&](unsigned x,unsigned y){memory->Write(syms.at("_osk_x"),x);memory->Write(syms.at("_osk_y"),y);};
        Frames(core,600);pad(Down_Key); // Document.txt
        if(rename){pad(Start_Key);pad(A_Key);pad(Down_Key);pad(A_Key);} else {pad(A_Key);pad(Select_Key);}
        Check(byte("_osk_shown")==1,"keyboard open");
        auto typed=[&](){return rename?Text(memory,syms.at("tile_buffer")+byte("_name_row")*40):Text(memory,syms.at("tile_buffer"));};
        Check(shown(1)=="q w e r t y u i o p","lower case keys");
        at(0,4);pad(A_Key);
        Check(byte("_osk_layer")==1 && shown(1)=="Q W E R T Y U I O P","one shift tap shows capitals on screen");
        at(0,1);pad(A_Key);
        Check(typed().find("Q")!=std::string::npos,"shift types a capital");
        Check(byte("_osk_layer")==0 && shown(1)=="q w e r t y u i o p","shift is one shot, screen follows");
        at(0,4);tap(A_Key,8);tap(A_Key,70); // double tap
        Check(byte("_osk_layer")==3 && shown(1)=="Q W E R T Y U I O P","double tap locks capitals");
        Check((u8)Text(memory,syms.at("bkg_buffer")+memory->Read(syms.at("_osk_blocks")+4)*40)[0]==25,"caps lock shows its glyph on the shift key");
        at(1,1);pad(A_Key);at(2,1);pad(A_Key);
        Check(typed().find("QWE")!=std::string::npos && byte("_osk_layer")==3,"caps lock stays on while typing");
        at(0,4);pad(A_Key);
        Check(byte("_osk_layer")==0 && shown(1)=="q w e r t y u i o p","a tap releases caps lock");
        pad(A_Key);Frames(core,40);pad(A_Key);
        Check(byte("_osk_layer")==0,"a slow second tap only turns shift off");
    }
    printf("%s OSK shift, one-shot and caps lock in editor and rename passed\n",color?"CGB":"DMG");
}

// SETTINGS > THEME: dark mode applies at once, survives a power cycle through the swap
// file, and an old SET2 settings record (no theme byte) still loads, as light.
static void Theme(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-theme-XXXXXX";Check(mkdtemp(folder),"theme SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));InstallModules(root,data);
    const u16 light_paper=27<<10|29<<5|29, dark_paper=4<<10|3<<5|3; // theme.asm
    auto boot=[&](GearboyCore& core){core.Init();core.SetEverdriveFolder(folder);
        Check(core.LoadROM(image,!color),"theme OS");Frames(core,600);};
    auto paper=[&](GearboyCore& core){return (*core.GetVideo()->GetCGBBackgroundPalettes())[0][0][0];};
    auto dark=[&](GearboyCore& core){auto m=core.GetMemory();
        return color ? paper(core)==dark_paper && (*core.GetVideo()->GetCGBSpritePalettes())[0][3][0]!=0
                     : m->Read(0xFF47)==0x1B && m->Read(0xFF48)==0x1B && m->Read(0xFF49)==0x27;}; // white cursor
    auto light=[&](GearboyCore& core){auto m=core.GetMemory();
        return color ? paper(core)==light_paper : m->Read(0xFF47)==0xE4 && m->Read(0xFF48)==0xE4 && m->Read(0xFF49)==0xE4;};
    {
        GearboyCore core;boot(core);auto memory=core.GetMemory();auto syms=Symbols(symbols);
        auto pad=[&](Gameboy_Keys key){core.KeyPressed(key);Frames(core,4);core.KeyReleased(key);Frames(core,70);};
        auto line=[&](){return Text(memory,syms.at("tile_buffer")+20*40);};
        Check(light(core),"light theme by default");
        pad(Start_Key);pad(Down_Key);pad(Down_Key);pad(A_Key);
        Check(line()==" THEME" && memory->Read(syms.at("_render_box_rows"))==5,"theme is the browser's first setting");
        pad(A_Key);Frames(core,120);
        Check(line()==" Dark mode  Off","theme module shows the dark mode toggle");
        pad(A_Key);
        Check(memory->Read(syms.at("_theme"))==1 && dark(core) && line()==" Dark mode  On ","A turns dark mode on at once");
        pad(B_Key);Frames(core,60);
        Check(memory->Read(syms.at("_render_box_top"))==255 && dark(core),"dark mode stays after leaving the menu");
        Check(Read(root+"/GBCSYS/EDITOR.SWP").size()>0xE9 && Read(root+"/GBCSYS/EDITOR.SWP")[0xE9]==1,"theme saved in the swap file");
    }
    {
        GearboyCore core;boot(core);auto memory=core.GetMemory();auto syms=Symbols(symbols);
        Check(memory->Read(syms.at("_theme"))==1 && dark(core),"dark mode comes back after a power cycle");
        auto pad=[&](Gameboy_Keys key){core.KeyPressed(key);Frames(core,4);core.KeyReleased(key);Frames(core,70);};
        pad(Start_Key);pad(Down_Key);pad(Down_Key);pad(A_Key);pad(A_Key);Frames(core,120);pad(Right_Key);
        Check(memory->Read(syms.at("_theme"))==0 && light(core),"turning it off restores the light palettes");
        pad(B_Key);Frames(core,60);
    }
    auto swap=Read(root+"/GBCSYS/EDITOR.SWP");
    swap[0x23]='2';swap[0xE9]=0x5A;swap[0x25]=0; // SET2, junk where the theme now is, bars off
    Write(root+"/GBCSYS/EDITOR.SWP",swap);
    {
        GearboyCore core;boot(core);auto memory=core.GetMemory();auto syms=Symbols(symbols);
        Check(memory->Read(syms.at("_theme"))==0 && light(core),"SET2 settings load with the light theme");
        Check(memory->Read(syms.at("_bars_on"))==0,"SET2 settings keep their other values");
    }
    printf("%s theme dark mode, persistence and SET2 settings passed\n",color?"CGB":"DMG");
}

// A binary file (a NUL in its first sector) opens HEXVIEW.MOD: 8 bytes a row in hex and as
// characters (non-printing ones a dim period), the selected byte highlighted and in the footer.
// FATPAK_SCREENSHOT=dir saves the page as a PPM.
static void HexView(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-hex-XXXXXX";Check(mkdtemp(folder),"hex SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));InstallModules(root,data);
    std::vector<u8> bytes={0xD9,'F','a','t','P','a','k',0};
    while(bytes.size()<300) bytes.push_back(u8(bytes.size()*37));
    Write(root+"/Data.bin",bytes);Write(root+"/Text.txt",{'h','i','\n'});
    GearboyCore core;core.Init();core.SetEverdriveFolder(folder);core.SetPS2KeyboardEnabled(true);
    Check(core.LoadROM(image,!color),"hex OS");auto memory=core.GetMemory();auto syms=Symbols(symbols);
    auto byte=[&](const char* name){return memory->Read(syms.at(name));};
    auto pad=[&](Gameboy_Keys key){core.KeyPressed(key);Frames(core,4);core.KeyReleased(key);Frames(core,30);};
    auto extended=[&](u8 code){core.QueuePS2KeyboardScanCode(0xE0);core.QueuePS2KeyboardScanCode(code);Frames(core,4);
        core.QueuePS2KeyboardScanCode(0xE0);core.QueuePS2KeyboardScanCode(0xF0);core.QueuePS2KeyboardScanCode(code);Frames(core,60);};
    auto row=[&](unsigned n){std::string s;for(unsigned i=0;i<40;++i)s+=char(memory->Read(syms.at("tile_buffer")+n*40+i));
        while(!s.empty() && s.back()==' ')s.pop_back();return s;};
    auto expected=[&](unsigned offset){ // the row starting at offset
        std::string hex="  ",chars;char pair[4];
        for(unsigned i=0;i<8 && offset+i<bytes.size();++i){
            u8 c=bytes[offset+i];snprintf(pair,sizeof(pair),"%02X ",c);hex+=pair;
            chars+=c>=' ' && c<='~'?char(c):'.';}
        if(chars.empty())return std::string();
        hex.resize(29,' ');return hex+chars;};
    auto footer=[&](unsigned offset){
        u8 c=bytes[offset];char text[40];snprintf(text,sizeof(text)," $%06X  %%",offset);std::string s=text;
        for(unsigned bit=0x80;bit;bit>>=1)s+=c&bit?'1':'0';return s+"  "+std::to_string(c);};
    auto selected=[&](unsigned text_row,unsigned first){
        for(unsigned r=0;r<16;++r){unsigned at=syms.at("_render_sel")+(r+1)*2;
            if(memory->Read(at)!=(r==text_row?first:0) || memory->Read(at+1)!=(r==text_row?first+2:0))return false;}
        return true;};
    Frames(core,600);
    if(row(1).find("Data.bin")==std::string::npos)pad(Down_Key);
    pad(Down_Key);
    core.KeyPressed(A_Key);Frames(core,4);core.KeyReleased(A_Key);
    for(unsigned waited=0;row(19).find(" $000000")!=0 && waited<400;++waited)Frames(core,1);
    Frames(core,30);
    Check(row(18)==" Data.bin","hex view header shows the file name");
    Check(byte("_render_text")==1 && byte("_tb_rows")==16 && byte("_bars")==1,"hex view uses styled text rows between the bars");
    Check(row(0)=="  D9 46 61 74 50 61 6B 00    .FatPak.","first row: 8 hex bytes, 4 spaces, the characters");
    for(unsigned r=0;r<16;++r)Check(row(r)==expected(r*8),"every row matches the file");
    unsigned attrs=syms.at("tile_attrs");
    Check(memory->Read(attrs+29)==0x44 && memory->Read(attrs+30)==0x04 && memory->Read(attrs+36)==0x44,"non-printing bytes are dim periods, the rest plain");
    Check(memory->Read(attrs+2)==0x04,"hex digits are plain 4 px cells");
    Check(row(19).find(footer(0))==0 && memory->Read(syms.at("tile_buffer")+19*40+32)==127,"footer: address, binary, decimal and the clock");
    Check(selected(0,2),"the first byte's hex digits are highlighted");
    if(const char* dir=getenv("FATPAK_SCREENSHOT")){ // 160x144 RGB565, once DMG has drawn every row
        Frames(core,90);
        std::string path=std::string(dir)+(color?"/hex_cgb.ppm":"/hex_dmg.ppm");
        FILE* f=fopen(path.c_str(),"wb");fprintf(f,"P6 160 144 255\n");
        for(unsigned i=0;i<160*144;++i){u16 p=frame[i];u8 rgb[3]={u8((p>>11)<<3),u8(((p>>5)&63)<<2),u8((p&31)<<3)};fwrite(rgb,1,3,f);}
        fclose(f);}
    pad(Right_Key);Check(row(19).find(footer(1))==0 && selected(0,5),"right moves a byte");
    pad(Down_Key);Check(row(19).find(footer(9))==0 && selected(1,5),"down moves a row");
    pad(Left_Key);pad(Up_Key);Check(row(19).find(footer(0))==0 && selected(0,2),"left and up move back");
    pad(Up_Key);pad(Left_Key);Check(row(19).find(footer(0))==0,"the cursor stops at the start");
    unsigned ring=byte("_ring_top");
    for(unsigned i=0;i<16;++i)pad(Down_Key);
    Check(row(19).find(footer(128))==0 && selected(15,2),"down past the last row");
    Check(byte("_ring_top")==((ring+1)&31),"scrolls one row through the ring");
    for(unsigned r=0;r<16;++r)Check(row(r)==expected(8+r*8),"rows after scrolling");
    Check(memory->Read(attrs+15*40+29)==(bytes[128]>=' ' && bytes[128]<='~'?0x04:0x44),"the incoming row has its own styles");
    extended(0x69); // End
    Check(row(19).find(footer(299))==0 && selected(15,11),"End selects the last byte");
    Check(row(15)==expected(296) && row(14)==expected(288),"the last, partial row at the bottom");
    pad(Down_Key);Check(row(19).find(footer(299))==0,"the cursor stops at the end");
    extended(0x6C); // Home
    Check(row(19).find(footer(0))==0 && row(0)==expected(0),"Home goes back to the start");
    extended(0x7A); // Page down
    Check(row(19).find(footer(128))==0 && row(15)==expected(128),"Page down moves 16 rows");
    pad(B_Key); // the browser lists the folder again
    for(unsigned waited=0;byte("_render_box_top")!=255 && waited<300;++waited)Frames(core,1);
    Check(byte("_render_text")==0 && row(18)==" /" && (row(0)+row(1)+row(2)).find("Data.bin")!=std::string::npos,"B returns to the browser");
    unsigned text_row=row(1).find("Text.txt")!=std::string::npos?1:2;
    while(memory->Read(syms.at("_render_sel")+(text_row+1)*2+1)!=0xFF)pad(Down_Key);
    pad(A_Key);Frames(core,120);
    Check(byte("_render_text")==1 && Text(memory,syms.at("_file_name"))=="Text.txt" && row(0)=="hi","a text file still opens in the editor");
    printf("%s hex view of binary files passed\n",color?"CGB":"DMG");
}

int main(int argc,char** argv) {
    Check(argc==4,"usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT");
    Operations(argv[1],argv[2]);UI(argv[1],argv[2],argv[3],false);UI(argv[1],argv[2],argv[3],true);
    GameProperties(argv[1],argv[2],argv[3],false);GameProperties(argv[1],argv[2],argv[3],true);
    RenameEdges(argv[1],argv[2],argv[3],false);RenameEdges(argv[1],argv[2],argv[3],true);
    OSKShift(argv[1],argv[2],argv[3],false);OSKShift(argv[1],argv[2],argv[3],true);
    Theme(argv[1],argv[2],argv[3],false);Theme(argv[1],argv[2],argv[3],true);
    HexView(argv[1],argv[2],argv[3],false);HexView(argv[1],argv[2],argv[3],true);
}
