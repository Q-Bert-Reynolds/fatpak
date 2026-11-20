// 512x448 character text (SETTINGS > FONT > 8X8 TILES with RESOLUTION > 512x448) through the real GB frontend
// and Gearboy's protocol model of the SNES side: the browser switches to it (the kernel's extension, TEXT 1, 56
// rows of 62 4-pixel columns, the selection in columns), a 120-line file fills 54 rows and scrolls, a map gives
// way to 256x224's 28 rows while it's open and 512x448 comes back after it, and RESOLUTION > 256x224 ends it.
// The page stream goes to build/sgb/text.fph.
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
using sgbfs::SGBFS_MAP_HIRES;

static std::vector<u16> pixels(256*224);
static void Check(bool b,const char* msg){if(!b){fprintf(stderr,"FAIL: %s\n",msg);exit(1);}}
static std::vector<u8> Read(const std::string& p){std::ifstream f(p,std::ios::binary);return std::vector<u8>((std::istreambuf_iterator<char>(f)),{});}
static void Write(const std::string& p,const std::vector<u8>& b){std::ofstream f(p,std::ios::binary);f.write((const char*)b.data(),b.size());Check(f.good(),"write SD fixture");}
static std::vector<u8> Text(const std::string& s){return std::vector<u8>(s.begin(),s.end());}
static std::map<std::string,unsigned> Symbols(const char* p){std::map<std::string,unsigned> r;FILE* f=fopen(p,"r");Check(f,"symbols");char line[512],name[256];unsigned b,a;while(fgets(line,sizeof(line),f))if(sscanf(line,"%x:%x %255s",&b,&a,name)==3)r[name]=a;fclose(f);return r;}
static void Frames(GearboyCore& c,unsigned n){s16 a[AUDIO_BUFFER_SIZE];while(n--){int count=0;c.RunToVBlank(pixels.data(),a,&count);}}
static std::string Chars(const FatPakSGBHost::Row& r){return std::string(r.chars.begin(),r.chars.end());}

// the fixture map's cell (tile | palette << 10) at x (0-63: chunk A, then its east neighbour B), y
int main(int n,char** v){
    setvbuf(stdout,nullptr,_IOLBF,0);
    Check(n==5,"arguments: OS symbols EDITOR.DAT SGB.DAT");
    char dir[]="/tmp/fatpak-sgbtext-XXXXXX";Check(mkdtemp(dir),"SD");std::string root(dir);
    mkdir((root+"/GBCSYS").c_str(),0700);mkdir((root+"/GBCSYS/MODULES").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(v[3]));Write(root+"/GBCSYS/SGB.DAT",Read(v[4]));
    Write(root+"/GBCSYS/MAPVIEW.INC",Read("bin/MAPVIEW.INC"));
    if(DIR* d=opendir("bin/MODULES")){while(dirent* e=readdir(d)){std::string name=e->d_name;
        if(name.size()>4 && name.substr(name.size()-4)==".MOD")Write(root+"/GBCSYS/MODULES/"+name,Read("bin/MODULES/"+name));}closedir(d);}
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

    {std::string text;for(unsigned i=1;i<=120;++i)text+="line "+std::to_string(i)+" of the long file\n";Write(root+"/long.txt",Text(text));}

    auto syms=Symbols(v[2]);GearboyCore core;core.Init();core.SetForceSGB(true);core.SetEverdriveFolder(dir);
    auto h=core.GetSGB()->GetFatPakHost();h->Configure(FatPakSGBHost::TerminalV1);
    Check(h->SetRecording("build/sgb/text.fph"),"record the session's page stream");
    Check(core.LoadROM(v[1],false),"load OS");auto m=core.GetMemory();
    for(unsigned i=0;i<4000 && !(h->Active() && m->Read(syms.at("_screen_rows"))==28);++i)Frames(core,1);
    Frames(core,600);
    Check(h->Active() && (m->Read(syms.at("sys_info"))&4),"fullscreen");
    auto& model=h->GetModel();
    auto key=[&](unsigned code){Check(h->Inject(1,code,0),"inject key");Frames(core,120);};
    auto pad=[&](unsigned held,unsigned frames){Check(h->Inject(9,held,held),"inject pad");Frames(core,frames);
        Check(h->Inject(9,0,0),"release pad");Frames(core,90);};
    auto selected=[&](){for(const auto& r:model.rows)if(r.start!=r.end)return Chars(r);return std::string();};
    auto box=[&](){std::string b;for(unsigned i=0;i<model.boxRows;++i)b+=Chars(model.boxLines[i])+"|";return b;};
    auto wait=[&](unsigned frames,const std::function<bool()>& done){unsigned i=0;for(;i<frames && !done();++i)Frames(core,1);return i;};
    auto settings=[&](unsigned item){pad(8,4);key(0x83);key(0x83);key(10); // SETTINGS, then its item'th
        Check(box().find(" RESOLUTION|")!=std::string::npos,"SETTINGS: RESOLUTION on an SGB");
        for(unsigned i=0;i<item;++i)key(0x83);key(10);};
    auto rows=[&](){return unsigned(m->Read(syms.at("_screen_rows")));};

    settings(6); // RESOLUTION: 512x448 only with 8X8 TILES (or in a map)
    Check(box().find("| 256x224|")!=std::string::npos && box().find("512x448")==std::string::npos,"RESOLUTION: 256x224 alone with the standard font");
    key(10);
    settings(5);key(0x83);key(10); // FONT > 8X8 TILES
    Check(m->Read(syms.at("_font_tiles"))==1 && !model.text && rows()==28,"8X8 TILES at 256x224: still 28 rows");
    settings(6);
    Check(box().find("| 256x224| 512x448|")!=std::string::npos,"RESOLUTION with 8X8 TILES: 256x224, 512x448");
    key(0x83);key(10);
    unsigned waited=wait(3000,[&]{return model.text && model.textRows==54 && selected().size();});
    printf("512x448 text: %u GB frames, %u of the extension's bytes\n",waited,model.codeBytes);
    {std::vector<u8> dat=Read(v[4]);Check(model.codeBytes==(dat[6]|dat[7]<<8u),"the kernel's extension sent whole before TEXT 1");}
    Check(model.text==1 && rows()==56 && m->Read(syms.at("_screen_cells"))==1,"TEXT 1: 56 rows");
    Check(model.barFlags==3 && model.top==1 && model.textRows==54,"the browser's 54 rows between the bars");
    Check(m->Read(syms.at("_resolution"))==2,"saved as the RESOLUTION setting");
    Check(h->WritePPM("build/sgb/text-browser.ppm"),"browser screenshot");

    for(unsigned i=0;i<12 && selected().find("long.txt")==std::string::npos;++i)key(0x83);
    std::string sel=selected();
    Check(sel.find("long.txt")!=std::string::npos,"browser selects long.txt");
    for(const auto& r:model.rows)if(r.start!=r.end)Check(r.start==0 && (r.end==255 || r.end<=64),"the selection in columns");
    key(10);
    wait(2000,[&]{return Chars(model.rows[54]).find("line 54 ")!=std::string::npos;});
    for(unsigned y=1;y<=54;++y){std::string want="line "+std::to_string(y)+" of";
        if(Chars(model.rows[y]).find(want)!=0){fprintf(stderr,"row %u: '%s'\n",y,Chars(model.rows[y]).c_str());Check(false,"the file's first 54 lines in rows 1-54");}}
    wait(120,[&]{return model.cursorLook!=0;}); // (it blinks)
    printf("cursor: row %u x %u look %u\n",model.cursorRow,model.cursorX,model.cursorLook);
    Check(model.cursorLook && model.cursorRow==1 && model.cursorX==0,"the cursor at row 1");
    for(unsigned i=0;i<60;++i){Check(h->Inject(1,0x83,0),"Down");Frames(core,6);}
    wait(1500,[&]{return model.cursorRow==54 && Chars(model.rows[54]).find("line 61 ")==0;});
    printf("after 60 Downs: cursor row %u, row 1 '%s', row 54 '%s'\n",model.cursorRow,Chars(model.rows[1]).c_str(),Chars(model.rows[54]).c_str());
    Check(Chars(model.rows[54]).find("line 61 ")==0 && Chars(model.rows[1]).find("line 8 ")==0,"scrolled: lines 8-61");
    Check(h->WritePPM("build/sgb/text-editor.ppm"),"editor screenshot");
    pad(8,4);key(0x82);key(10); // FILE > CLOSE: the browser again
    wait(1500,[&]{return selected().size();});

    for(unsigned i=0;i<12 && selected().find("Test.gbmap")==std::string::npos;++i)key(0x83);
    if(selected().find("Test.gbmap")==std::string::npos){printf("box '%s' bars '%s' '%s'\n",box().c_str(),Chars(model.bars[0]).c_str(),Chars(model.bars[1]).c_str());
        for(unsigned y=0;y<12;++y)printf("%2u %u-%u '%s'\n",y,model.rows[y].start,model.rows[y].end,Chars(model.rows[y]).c_str());}
    Check(selected().find("Test.gbmap")!=std::string::npos,"browser selects Test.gbmap");
    key(10);
    waited=wait(30000,[&]{return model.mapMode && model.mapCells[28*128+32];});
    printf("map built and sent: %u GB frames\n",waited);
    Frames(core,120);
    Check(model.mapMode==(1|SGBFS_MAP_HIRES) && !model.text && rows()==28 && model.textRows==26,"the map at 512x448, the text 256x224's meanwhile");
    pad(8,4);key(0x82);key(10); // CLOSE
    waited=wait(3000,[&]{return !model.mapMode && model.text && selected().find("Test.gbmap")!=std::string::npos;});
    printf("map closed: %u GB frames\n",waited);
    Check(!model.mapMode && model.text==1 && rows()==56 && model.textRows==54,"Close: 512x448 text again");
    Check(selected().find("Test.gbmap")!=std::string::npos,"the browser's rows again");

    settings(6);key(0x82);key(10); // RESOLUTION > 256x224
    wait(1500,[&]{return !model.text && selected().size();});
    Check(!model.text && rows()==28 && model.textRows==26 && m->Read(syms.at("_resolution"))==0,"256x224 again: 28 rows");
    printf("SGB fullscreen 512x448 text passed\n");
}
