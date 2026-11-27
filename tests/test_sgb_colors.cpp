// SGB colours at 160x144 (src/sgb/attributes.asm): the SGB's 4 palettes from the theme's 8 (the text's, then the
// most used of those with its paper), each screen cell's palette as the GB renderer drew it (syntax highlighting,
// after scrolling too), a map's palettes 0-3 and cells (MAPVIEW.MOD, ModBackground 8 and 9) as it scrolls, and the
// theme's again after it. Gearboy's SGB (no SGB.DAT: the BIOS's 160x144) applies the packets; the BIOS's pace (a
// packet a frame) is tests/sgb's (Mesen, the real BIOS).
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <map>
#include <string>
#include <vector>
#include <functional>
#include <dirent.h>
#include <sys/stat.h>
#include "gearboy.h"
bool g_mcp_stdio_mode=true;

static std::vector<u16> pixels(256*224);
static void Check(bool b,const char* msg){if(!b){fprintf(stderr,"FAIL: %s\n",msg);exit(1);}}
static std::vector<u8> Read(const std::string& p){std::ifstream f(p,std::ios::binary);return std::vector<u8>((std::istreambuf_iterator<char>(f)),{});}
static void Write(const std::string& p,const std::vector<u8>& b){std::ofstream f(p,std::ios::binary);f.write((const char*)b.data(),b.size());Check(f.good(),"write SD fixture");}
static std::vector<u8> Text(const std::string& s){return std::vector<u8>(s.begin(),s.end());}
static std::map<std::string,unsigned> Symbols(const char* p){std::map<std::string,unsigned> r;FILE* f=fopen(p,"r");Check(f,"symbols");char line[512],name[256];unsigned b,a;while(fgets(line,sizeof(line),f))if(sscanf(line,"%x:%x %255s",&b,&a,name)==3)r[name]=a;fclose(f);return r;}
static void Frames(GearboyCore& c,unsigned n){s16 a[AUDIO_BUFFER_SIZE];while(n--){int count=0;c.RunToVBlank(pixels.data(),a,&count);}}
static u16 RGB(unsigned r,unsigned g,unsigned b){return u16(b<<10|g<<5|r);}

int main(int n,char** v){
    setvbuf(stdout,nullptr,_IOLBF,0);
    Check(n==4,"arguments: OS symbols EDITOR.DAT");
    char dir[]="/tmp/fatpak-sgbcolors-XXXXXX";Check(mkdtemp(dir),"SD");std::string root(dir);
    mkdir((root+"/GBCSYS").c_str(),0700);mkdir((root+"/GBCSYS/MODULES").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(v[3])); // (no SGB.DAT: the BIOS's 160x144)
    Write(root+"/GBCSYS/MAPVIEW.INC",Read("bin/MAPVIEW.INC"));
    if(DIR* d=opendir("bin/MODULES")){while(dirent* e=readdir(d)){std::string name=e->d_name;
        if(name.size()>4 && name.substr(name.size()-4)==".MOD")Write(root+"/GBCSYS/MODULES/"+name,Read("bin/MODULES/"+name));}closedir(d);}
    mkdir((root+"/GBCSYS/SYNTAX").c_str(),0700);
    if(DIR* d=opendir("bin/SYNTAX")){while(dirent* e=readdir(d)){std::string name=e->d_name;
        if(name.size()>4 && name.substr(name.size()-4)==".SYN")Write(root+"/GBCSYS/SYNTAX/"+name,Read("bin/SYNTAX/"+name));}closedir(d);}
    mkdir((root+"/img").c_str(),0700);mkdir((root+"/img/maps").c_str(),0700);
    Write(root+"/map_stamps.gbstamp",Text("GBStamps:: ;7 bytes\nGBStampBox: ;7 bytes\n  DB 2;width\n  DB 2;height\n"
        ".tiles\n  DB 128, 129\n  DB 129, 128\n.palette\n  DB 130\n"));
    Write(root+"/img/ui_font.tiles",std::vector<u8>(2048,0));
    std::vector<u8> tiles(2048,0);
    for(unsigned y=0;y<8;++y){tiles[y*2]=0xFF;tiles[16+y*2+1]=0xFF;} // 128: colour 1, 129: colour 2
    Write(root+"/img/maps/test.tiles",tiles);
    Write(root+"/Test.gbmap",Text(
        "MapTest:: ;the header, as gbmapeditor writes it\n  DB 0\n  DW MapTestPalettes\n  DW 0\n  DW 0\n"
        "  DW MapTestChunks\n  DW 0\n  DW 0\n  DW 0\n  DW 0\n  DB BANK(_TestTiles)\n  DW _TestTiles\n"
        "  DB BANK(_WorldSpritesTiles)\n  DW _WorldSpritesTiles\n\nMapTestPalettes:\n.background\n"
        "  RGB 31, 31, 31\n  RGB 31, 0, 0\n  RGB 0, 31, 0\n\n  RGB 0, 0, 31\n  RGB 31, 31, 0\n  RGB 0, 31, 31\n\n"
        "  RGB 31, 0, 31\n  RGB 24, 12, 0\n  RGB 0, 12, 24\n\n"
        "  RGB 1, 2, 3\n  RGB 1, 2, 3\n  RGB 1, 2, 3\n  RGB 1, 2, 3\n  RGB 1, 2, 3\n  RGB 1, 2, 3\n"
        "  RGB 1, 2, 3\n  RGB 1, 2, 3\n  RGB 1, 2, 3\n  RGB 1, 2, 3\n  RGB 1, 2, 3\n  RGB 1, 2, 3\n"
        "  RGB 1, 2, 3\n  RGB 1, 2, 3\n  RGB 1, 2, 3\n\n"
        "DEF MAP_TEST_CHUNK_A EQU 0\nDEF MAP_TEST_CHUNK_B EQU 1\n\nMapTestChunks: ;4 bytes\n"
        "  DW MapTestChunkA\n  DW MapTestChunkB\n\n"
        "MapTestChunkA:\n.tile:    DB 0\n.palette: DB 0\n.area:    DB 0\n.north:   DB MAP_TEST_CHUNK_A\n"
        ".east:    DB MAP_TEST_CHUNK_B\n.south:   DB MAP_TEST_CHUNK_A\n.west:    DB MAP_TEST_CHUNK_B\n"
        "  DB MAP_OBJ_TILE_FILL | MAP_COLLISION_NONE ;Floor, 7 bytes\n  DB 2;x1\n  DB 2;y1\n  DB 128;tile\n"
        "  DB 1;palette\n  DB 6;x2\n  DB 4;y2\n"
        "  DB MAP_OBJ_TILE | MAP_COLLISION_SCRIPT ;Sign\n  DB 8\n  DB 1\n  DB 129\n  DB 1\n  DB 0;script\n"
        "  DB MAP_OBJ_STAMP | MAP_COLLISION_NONE\n  DB 10;x\n  DB 5;y\n  DW GBStampBox\n"
        "  DB MAP_OBJ_STAMP_FILL | MAP_COLLISION_NONE\n  DB 2;x1\n  DB 8;y1\n  DW GBStampBox\n  DB 6;x2\n  DB 10;y2\n"
        "  DB 0;terminator\n  DB 0;sprites\n\n"
        "MapTestChunkB:\n.tile:    DB 129\n.palette: DB 2\n.area:    DB 0\n.north:   DB MAP_TEST_CHUNK_B\n"
        ".east:    DB MAP_TEST_CHUNK_A\n.south:   DB MAP_TEST_CHUNK_B\n.west:    DB MAP_TEST_CHUNK_A\n"
        "  DB 0\n  DB 0\n"));


    {auto hello=Read("tests/asm/hello.asm");std::vector<u8> twice(hello);twice.insert(twice.end(),hello.begin(),hello.end());
     Write(root+"/Hello.asm",twice);} // (twice: something to scroll)

    auto syms=Symbols(v[2]);GearboyCore core;core.Init();core.SetForceSGB(true);core.SetEverdriveFolder(dir);
    Check(core.LoadROM(v[1],false),"load OS");auto m=core.GetMemory();auto sgb=core.GetSGB();
    auto byte=[&](const char* s){return unsigned(m->Read(syms.at(s)));};
    auto pad=[&](Gameboy_Keys k){core.KeyPressed(k);Frames(core,4);core.KeyReleased(k);Frames(core,60);};
    auto hold=[&](Gameboy_Keys k,unsigned frames){core.KeyPressed(k);Frames(core,frames);core.KeyReleased(k);Frames(core,60);};
    auto attr=[&](unsigned x,unsigned y){return unsigned(sgb->GetAttributeMap()[y*20+x]);};
    auto pal=[&](unsigned p,unsigned c){return sgb->GetEffectivePalettes()[p*4+c];};
    // the cells the OS has for screen row r (a block's, the screen's rows' while a module has the BG map)
    auto shadow=[&](unsigned x,unsigned r){unsigned row=m->Read(syms.at("_render_background"))?r:m->Read(syms.at("_render_row_blocks")+r);
        return unsigned(m->Read(syms.at("sgb_attr_rows")+row*5+x/4)>>(6-2*(x&3))&3);};
    auto same=[&](const char* what){unsigned bad=0;
        for(unsigned y=0;y<18;++y)for(unsigned x=0;x<20;++x)if(attr(x,y)!=shadow(x,y)){if(++bad<4)printf("cell %u,%u: SNES %u, OS %u\n",x,y,attr(x,y),shadow(x,y));}
        if(bad)printf("%s: %u cells differ\n",what,bad);Check(!bad,what);};
    auto screen=[&](){for(unsigned y=0;y<18;++y){for(unsigned x=0;x<20;++x)printf("%u",attr(x,y));printf("\n");}};
    Frames(core,900);
    Check((byte("sys_info")&7)==1,"an SGB at 160x144 (no SGB.DAT)");

    // the theme's palettes: the built-in theme's text palette 0, then 1 (4 looks), 2 and 4 (2 each: the first of equals);
    // 3 (numbers, 1 look) drawn in 0
    const unsigned map[8]={0,1,2,0,3,0,0,0};
    for(unsigned p=0;p<8;++p)Check(m->Read(syms.at("sgb_pal_map")+p)==map[p],"sgb_pal_map: palettes 0, 1, 2, 4");
    Check(pal(0,0)==RGB(29,29,27) && pal(0,1)==RGB(20,25,31) && pal(0,3)==RGB(2,2,3),"SGB palette 0: the text's");
    Check(pal(1,1)==RGB(4,9,24) && pal(2,1)==RGB(19,4,4) && pal(3,1)==RGB(21,10,0),"SGB palettes 1-3: the theme's 1, 2 and 4");
    Frames(core,60);
    same("the browser's cells");

    pad(Down_Key);pad(Down_Key);pad(A_Key); // img/, then Hello.asm
    Frames(core,180);
    Check(byte("_render_text")==1,"Hello.asm open");
    same("the editor's cells as the GB renderer drew them");
    {unsigned used[4]={0,0,0,0};for(unsigned y=1;y<17;++y)for(unsigned x=0;x<20;++x)++used[attr(x,y)];
     printf("text cells in SGB palettes 0-3: %u %u %u %u\n",used[0],used[1],used[2],used[3]);
     Check(used[1] && used[2] && used[3],"syntax highlighting: keywords, strings, directives in SGB palettes 1-3");}
    screen();
    for(unsigned i=0;i<30;++i){core.KeyPressed(Down_Key);Frames(core,3);core.KeyReleased(Down_Key);Frames(core,3);}
    Frames(core,90);
    Check(m->Read(syms.at("_tb_row_starts"))|m->Read(syms.at("_tb_row_starts")+1),"scrolled");
    same("the cells after scrolling (the rows' blocks moved)");

    // a map: its palettes 0-3 (colour 0 palette 0's), each cell its tile's
    pad(Start_Key);for(unsigned i=0;i<4;++i)pad(Down_Key);pad(A_Key); // FILE > CLOSE
    Frames(core,120);
    Check(byte("_render_text")==0,"the browser again");
    for(unsigned i=0;i<4;++i)pad(Down_Key); // Test.gbmap (after map_stamps.gbstamp)
    pad(A_Key);
    unsigned waited=0;for(;waited<40000 && !(m->Read(syms.at("_render_background")) && pal(1,1)==RGB(31,31,0));++waited)Frames(core,1);
    printf("map built and shown: %u frames\n",waited);
    Frames(core,120);
    Check(pal(0,0)==RGB(31,31,31) && pal(0,1)==RGB(31,0,0) && pal(0,2)==RGB(0,31,0) && pal(0,3)==0,"SGB palette 0: the map's 0");
    Check(pal(1,1)==RGB(31,31,0) && pal(1,2)==RGB(0,31,31) && pal(2,1)==RGB(24,12,0) && pal(2,2)==RGB(0,12,24),"SGB palettes 1 and 2: the map's");
    screen();
    same("the map's cells");
    Check(attr(2,2)==1 && attr(5,3)==1 && attr(6,3)==0 && attr(5,4)==0 && attr(8,1)==1,"the floor (2-5, 2-3: to x2, y2) and the sign (8, 1) in palette 1");
    Check(attr(10,5)==2 && attr(11,6)==2 && attr(2,8)==2 && attr(5,9)==2 && attr(6,9)==0,"the stamps (10, 5 and 2-5, 8-9) in palette 2");
    Check(attr(0,0)==0 && attr(0,17)==0,"the bars palette 0");
    hold(Right_Key,16); // 16 pixels: the floor 2 cells to the left
    screen();
    same("the map's cells after scrolling");
    Check(attr(0,2)==1 && attr(3,2)==1 && attr(4,2)==0,"scrolled: the floor at 0-3");
    pad(Start_Key);pad(Up_Key);pad(A_Key); // CLOSE
    Frames(core,240);
    Check(!m->Read(syms.at("_render_background")) && byte("_render_text")==0,"the browser after the map");
    Check(pal(0,0)==RGB(29,29,27) && pal(1,1)==RGB(4,9,24),"the theme's palettes again");
    same("the browser's cells after the map");
    printf("SGB 160x144 colours: the theme's palettes, syntax highlighting, a map's palettes and cells passed\n");
}
