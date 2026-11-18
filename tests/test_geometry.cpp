// Runtime geometry and overlapping logical row buffers through the real GB CPU.
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
static unsigned Call(GearboyCore& core, unsigned address, unsigned argument = 0, u8 a = 0, unsigned bc = 0, unsigned text = 0)
{
    auto cpu = core.GetProcessor()->GetState(); auto memory = core.GetMemory();
    cpu->SP->SetValue(0xCB10); memory->Write(0xCB10, 0xFF); memory->Write(0xCB11, 0x7F);
    memory->Write(0xCB12,text);memory->Write(0xCB13,text>>8);
    *cpu->Halt=false;*cpu->IME=false;
    cpu->BC->SetValue(bc); cpu->DE->SetValue(argument); cpu->AF->SetValue(a << 8); cpu->PC->SetValue(address);
    for (unsigned i = 0; i < 80000000 && cpu->PC->GetValue() != 0x7FFF; ++i)
    {
        unsigned ticks = 0; core.RunCycle(frame.data(), ticks);
        if (i % 3000 == 2999) { s16 audio[AUDIO_BUFFER_SIZE]; int n = 0; core.EndFrame(audio, &n); }
    }
    if(cpu->PC->GetValue()!=0x7fff)fprintf(stderr,"call %04x stalled at pc=%04x sp=%04x page=%u\n",address,cpu->PC->GetValue(),cpu->SP->GetValue(),memory->Read(0xbd08));
    Check(cpu->PC->GetValue() == 0x7FFF, "OS routine returns");
    return cpu->AF->GetValue() >> 8;
}

static void Geometry(const char* image,const char* symbols,const char* data,bool color) {
    char folder[]="/tmp/fatpak-geometry-XXXXXX";Check(mkdtemp(folder),"geometry SD");
    std::string root(folder);mkdir((root+"/GBCSYS").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));
    std::vector<u8> document(70000,'a');
    for(unsigned i=63;i<document.size();i+=64)document[i]='\n';
    Write(root+"/Document.txt",document);
    auto syms=Symbols(symbols);
    GearboyCore core;core.Init();core.SetEverdriveFolder(folder);
    Check(core.LoadROM(image,!color),"geometry OS");Frames(core,600);
    auto memory=core.GetMemory();
    auto byte=[&](const char* name){return memory->Read(syms.at(name));};
    auto word=[&](unsigned at){return memory->Read(at)+256*memory->Read(at+1);};
    auto set=[&](const char* name,unsigned v){memory->Write(syms.at(name),v);};
    auto call=[&](const char* name,unsigned de=0,unsigned a=0,unsigned bc=0){return Call(core,syms.at(name),de,a,bc);};
    Check(byte("_screen_rows")==18 && byte("_screen_stride")==40 && byte("_screen_width")==160 && byte("_screen_header")==18,"startup retains GB geometry");
    Check(word(syms.at("_tile_attrs"))==syms.at("tile_attrs"),"GB attribute pointer");
    auto pad=[&](Gameboy_Keys key){core.KeyPressed(key);Frames(core,4);core.KeyReleased(key);Frames(core,120);};
    pad(Down_Key);pad(A_Key);Frames(core,600);
    Check(byte("_render_text") && byte("_doc_large"),"large document opens in editor");
    for(unsigned keyboard=0;keyboard<2;++keyboard){
        if(keyboard)pad(Select_Key);
        pad(Start_Key);
        unsigned menu=word(syms.at("_render_box_text"));
        Check(word(syms.at("_lang_count"))>0,"menu language loaded");
        Check(byte("_render_box_w")==57,"editor menu sizes itself to SETTINGS");
        Check(memory->Read(menu+20)==' ' && memory->Read(menu+21)=='E',"editor menu has its actual EDIT label");
        unsigned x=byte("_render_box_x"),y=(byte("_render_box_top")+2)*8;
        u16 paper=frame[y*160+x+2];bool ink[8][160]={};
        unsigned at=x+4;
        for(const char* label=" EDIT";*label;++label){
            for(unsigned line=0;line<8;++line){unsigned bits=memory->Read(syms.at("FontVWFGlyphs")+unsigned(*label)*8+line);
                for(unsigned bit=0;bit<8;++bit)if(bits&(128>>bit))ink[line][at+bit]=true;}
            at+=memory->Read(syms.at("FontVWFWidths")+unsigned(*label));
        }
        for(unsigned line=0;line<8;++line)for(unsigned px=x+1;px<x+byte("_render_box_w")-1;++px)
            Check((frame[(y+line)*160+px]!=paper)==ink[line][px],"menu text reaches the actual DMG/CGB pixels");
        printf("%s editor menu pixels and sizing passed (%s keyboard)\n",color?"CGB":"DMG",keyboard?"with":"without");
        pad(Start_Key);
    }
    pad(Select_Key);
    memory->Write(0xffff,0);memory->Write(0xff40,0); // logical tests do not run a video backend
    { // Menu sizing and text storage must work through the real C/assembly ABI.
        unsigned text=syms.at("str_buffer");const char* label="Loading...";
        for(unsigned i=0;i<=strlen(label);++i)memory->Write(text+i,label[i]);
        unsigned expected=0;for(unsigned i=0;i<strlen(label);++i)expected+=memory->Read(syms.at("FontVWFWidths")+label[i]);
        unsigned measured=call("_RenderTextWidth",text);
        Check(measured==expected,"menu font width matches glyph metrics");
        unsigned lines=call("_BoxText",text,0);
        call("_OpenBox__far",0,lines);
        unsigned stored=word(syms.at("_render_box_text"));
        Check(byte("_render_box_w")==expected+9,"menu fits its real text with symmetric padding");
        for(unsigned i=0;i<=strlen(label);++i)Check(memory->Read(stored+i)==label[i],"menu text survives sizing");
    }
    call("_GeometryWide");
    Check(byte("_screen_rows")==28 && byte("_screen_stride")==64 && byte("_screen_width")==248 && byte("_screen_header")==26,"wide geometry and bar slots");
    Check(word(syms.at("_tile_attrs"))==syms.at("wide_tile_attrs"),"wide attribute pointer");
    unsigned offsets=word(syms.at("_screen_offsets"));
    for(unsigned i=0;i<32;++i)Check(word(offsets+2*i)==64*i,"wide row-offset table including sentinel");
    call("_RowAddress",0,27);Check(core.GetProcessor()->GetState()->BC->GetValue()==0xd000+27*64,"last character row address");
    call("_AttrAddress",0,27);Check(core.GetProcessor()->GetState()->BC->GetValue()==syms.at("wide_tile_attrs")+27*64,"last attribute row address");
    call("_tb_Clear");call("_SetFont",0,2);
    set("_tb_rows",28);set("_tb_nowrap",0);set("_tb_lang",0);
    memory->Write(syms.at("_tb_find"),0);memory->Write(syms.at("_tb_find")+1,0);
    unsigned temp=syms.at("str_buffer");
    for(unsigned i=0;i<64;++i)memory->Write(temp+i,'a');
    for(unsigned n=0;n<32;++n)Check(call("_tb_Append",temp,0,64)==1,"append wide scan fixture");
    call("_tb_Render",0);
    unsigned chars=syms.at("wide_tile_buffer"),attrs=syms.at("wide_tile_attrs");
    for(unsigned r=0;r<28;++r){
        Check(memory->Read(syms.at("_tb_row_counts")+r)==62,"248px wraps at 62 four-pixel characters");
        Check(word(syms.at("_tb_row_starts")+2*r)==62*r,"row starts across all 28 rows");
        for(unsigned c=0;c<64;++c){
            Check(memory->Read(chars+r*64+c)==(c<62?'a':' '),"wide characters and padding");
            Check(memory->Read(attrs+r*64+c)==(c<62?4:0),"wide styles and padding");
        }
    }
    Check(word(syms.at("_tb_bottom"))==28*62,"bottom sentinel");
    set("_tb_found_row",27);
    Check(call("_RenderCursorX",0,62)==247,"cursor clamps at runtime right edge");
    // Logical layout must fill all 28 rows without touching the GB tile map.
    set("_bars",1);set("_tb_rows",26);set("_ring_pos",0);set("_ring_top",0);
    std::vector<u8> beforeMap(1024);
    for(unsigned i=0;i<1024;++i)beforeMap[i]=memory->Read(0x9800+i);
    call("_Layout__far");call("_NoHighlight__far");
    Check(memory->Read(syms.at("_render_row_lines"))==26 && memory->Read(syms.at("_render_row_lines")+27)==27,"wide layout assigns both bars");
    Check(memory->Read(syms.at("_render_sel")+1)==255 && memory->Read(syms.at("_render_sel")+55)==255,"wide bar selection bounds");
    for(unsigned i=0;i<1024;++i)Check(memory->Read(0x9800+i)==beforeMap[i],"wide logical layout leaves GB video alone");
    // Exercise DrawRow's stack argument across its assembly far-call gate.
    const char* sample="sample";
    for(unsigned i=0;i<=6;++i)memory->Write(temp+i,sample[i]);
    Call(core,syms.at("_DrawRow"),3,26,0,temp);
    for(unsigned i=0;i<64;++i)Check(memory->Read(chars+26*64+i)==(i>=3 && i<9?sample[i-3]:' '),"wide DrawRow clears and places text");
    for(unsigned i=0;i<64;++i)memory->Write(chars+27*64+i,' ');
    call("_FooterCompose",chars+27*64);
    Check(memory->Read(chars+27*64+56)==127 && memory->Read(chars+27*64+57)==memory->Read(syms.at("_footer_time")),"wide clock uses final eight cells");
    set("_tb_rows",28);
    // Distinct row contents and attributes expose wrong strides in either copy direction.
    for(unsigned r=0;r<28;++r)for(unsigned c=0;c<64;++c){memory->Write(chars+r*64+c,r+32);memory->Write(attrs+r*64+c,r);}
    call("_tb_ScrollRows",0,1);
    for(unsigned r=0;r<27;++r)for(unsigned c=0;c<64;++c)
        Check(memory->Read(chars+r*64+c)==r+33 && memory->Read(attrs+r*64+c)==r+1,"scroll up uses both wide buffers");
    call("_tb_ScrollRows",0,0);
    for(unsigned r=1;r<28;++r)for(unsigned c=0;c<64;++c)
        Check(memory->Read(chars+r*64+c)==r+32 && memory->Read(attrs+r*64+c)==r,"scroll down uses both wide buffers");
    // The next glyph can overflow eight-bit X at the wider pixel boundary.
    memory->Write(syms.at("_font_widths")+'Z',15);
    Check(call("_tb_Insert",62,'Z')==1,"insert a wide boundary glyph");
    call("_tb_Render",0);
    Check(memory->Read(syms.at("_tb_row_counts"))==62 && word(syms.at("_tb_row_starts")+2)==62,"pixel addition overflow wraps before the glyph");
    // Narrow glyphs reach the character capacity before the pixel limit.
    memory->Write(syms.at("_font_widths")+'a',1);call("_tb_Render",0);
    Check(memory->Read(syms.at("_tb_row_counts"))==64,"runtime 64-character limit");
    // Move the gap through multiple PSRAM blocks using the 32-byte wide scratch.
    Check(call("_tb_Insert",513,'Z')==1,"wide gap move and insert");
    Check(call("_tb_GetChar",513)=='Z' && call("_tb_GetChar",514)=='a',"wide scratch preserves document bytes");
    Check(call("_tb_Copy",500,0,160)==1 && call("_tb_Paste",1025)==1,"wide clipboard crosses staging chunks");
    Check(call("_tb_GetChar",1038)=='Z' && call("_tb_GetChar",1039)=='a',"wide clipboard preserves copied bytes");
    memory->Write(0xbd08,15);set("loaded_bank",15);
    memory->Write(syms.at("_log_ptr"),0);memory->Write(syms.at("_log_ptr")+1,0);
    call("_log_SaveText",1025,0,160);
    memory->Write(syms.at("_log_ptr"),0);memory->Write(syms.at("_log_ptr")+1,0);
    call("_log_RestoreText",1800,0,160);
    Check(call("_tb_GetChar",1813)=='Z' && call("_tb_GetChar",1814)=='a',"wide undo-log staging preserves bytes");
    for(unsigned i=0;i<28*64;++i)memory->Write(attrs+i,0x44);
    call("_OSKDraw",23,0);
    const char* first="1qaz";
    for(unsigned r=0;r<4;++r)Check(memory->Read(chars+(23+r)*64)==first[r],"wide keyboard row stride");
    for(unsigned r=23;r<28;++r)for(unsigned c=20;c<64;++c)Check(memory->Read(chars+r*64+c)==' ',"wide keyboard padding");
    for(unsigned i=0;i<28*64;++i)Check(memory->Read(attrs+i)==0x44,"keyboard clear respects character-buffer boundary");
    call("_GeometryGB");
    offsets=word(syms.at("_screen_offsets"));
    for(unsigned i=0;i<32;++i)Check(word(offsets+2*i)==40*i,"restored GB row-offset table");
    Check(byte("_screen_rows")==18 && byte("_screen_width")==160 && word(syms.at("_tile_attrs"))==syms.at("tile_attrs"),"return to GB geometry");
    printf("%s runtime geometry, 28x64 buffers, wrapping, layout, cursor, scroll, clipboard, undo and keyboard staging passed\n",color?"CGB":"DMG");
}
int main(int argc,char** argv){
    Check(argc==4,"usage: test GBCOS.BIN GBCOS.sym EDITOR.DAT");
    Geometry(argv[1],argv[2],argv[3],false);Geometry(argv[1],argv[2],argv[3],true);
}
