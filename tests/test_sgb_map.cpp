// SGB fullscreen map view: MAPVIEW.MOD's map on the SNES (SGBFS_CMD_MAP*), through the real GB frontend and
// Gearboy's protocol model of the SNES side. The browser opens a .gbmap, ASM.MOD and LINK.MOD build it, and
// the view sends the map's 256 tiles, its 8 palettes and the cells in view: every one checked against the
// map. Holding Right scrolls and draws the incoming columns, B runs east into the next chunk (the second
// screen of the SNES's 64-wide map), Start's menu is over the map, Full screen hides the bars, Hi-res sends
// it again at 512x448 (65x57 cells of a 128x64 map), running south there crosses into the 64-row map's
// second half, Hi-res again gives 256x224 back and Close the text. The page stream goes to
// build/sgb/map.fph for the real kernel (Mesen).
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <map>
#include <string>
#include <vector>
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
static unsigned Expected(unsigned x,unsigned y){
    x&=63;y&=31;
    if(x>=32)return 129|2<<10;
    if(x>=2 && x<6 && y>=2 && y<4)return 128|1<<10; // tile fill
    if(x==8 && y==1)return 129|1<<10; // tile
    if(x>=10 && x<12 && y>=5 && y<7)return ((x-10+y-5)&1?129:128)|2<<10; // stamp
    if(x>=2 && x<6 && y>=8 && y<10)return ((x+y)&1?129:128)|2<<10; // stamp fill
    return 0;
}

int main(int n,char** v){
    setvbuf(stdout,nullptr,_IOLBF,0);
    Check(n==5,"arguments: OS symbols EDITOR.DAT SGB.DAT");
    char dir[]="/tmp/fatpak-sgbmap-XXXXXX";Check(mkdtemp(dir),"SD");std::string root(dir);
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

    auto syms=Symbols(v[2]);GearboyCore core;core.Init();core.SetForceSGB(true);core.SetEverdriveFolder(dir);
    auto h=core.GetSGB()->GetFatPakHost();h->Configure(FatPakSGBHost::TerminalV1);
    Check(h->SetRecording("build/sgb/map.fph"),"record the session's page stream");
    Check(core.LoadROM(v[1],false),"load OS");auto m=core.GetMemory();
    for(unsigned i=0;i<4000 && !(h->Active() && m->Read(syms.at("_screen_rows"))==28);++i)Frames(core,1);
    Frames(core,600);
    Check(h->Active() && (m->Read(syms.at("sys_info"))&4),"fullscreen");
    auto& model=h->GetModel();
    auto key=[&](unsigned code){Check(h->Inject(1,code,0),"inject key");Frames(core,120);};
    auto pad=[&](unsigned held,unsigned frames){Check(h->Inject(9,held,held),"inject pad");Frames(core,frames);
        Check(h->Inject(9,0,0),"release pad");Frames(core,90);};
    auto selected=[&](){for(const auto& r:model.rows)if(r.start!=r.end)return Chars(r);return std::string();};
    for(unsigned i=0;i<8 && selected().find("Test.gbmap")==std::string::npos;++i)key(0x83); // Down
    Check(selected().find("Test.gbmap")!=std::string::npos,"browser selects Test.gbmap");
    key(10);
    unsigned waited=0;
    for(;waited<30000 && !(model.mapMode==1 && model.mapCells[28*128+32]);++waited)Frames(core,1);
    printf("map built and sent: %u GB frames\n",waited);
    Frames(core,120);
    Check(model.mapMode==1,"MAP 1: the map under the bars");
    {std::vector<u8> dat=Read(v[4]);printf("extension: %u of %u bytes\n",model.codeBytes,dat[6]|dat[7]<<8u);Check(dat.size()>32 && model.codeBytes==(dat[6]|dat[7]<<8u),"the kernel's extension sent whole before the map");}
    for(unsigned i=0;i<16;++i)Check(model.mapTiles[128*16+i]==tiles[i] && model.mapTiles[129*16+i]==tiles[16+i],"the tileset's tiles");
    Check(model.mapColors[0]==0x7FFF && model.mapColors[1]==31 && model.mapColors[4]==31<<10 && model.mapColors[9]==(24|12<<5),"the map's palettes");
    // the cells in view from mapX, mapY: 33x29 of the SNES's 64x32 map, 65x57 of 128x64 at 512x448. The
    // fixture's chunks repeat every 64 columns and 32 rows, so a cell of the map is the fixture's at its place
    auto matches=[&](bool report){
        unsigned hi=model.mapMode&SGBFS_MAP_HIRES?1:0,x0=model.mapX>>3,y0=model.mapY>>3;
        for(unsigned y=y0;y<y0+(hi?57:29);++y)for(unsigned x=x0;x<x0+(hi?65:33);++x){
            unsigned got=model.mapCells[(y&(hi?63:31))*128+(x&(hi?127:63))];
            if(got!=Expected(x,y)){if(report)fprintf(stderr,"cell %u,%u: %04x, not %04x\n",x,y,got,Expected(x,y));return false;}}
        return true;};
    auto view=[&](const char* what){Check(matches(true),what);};
    view("the first view: every cell");
    Check(model.mapX==0 && model.mapY==0 && (model.barFlags&1),"at the top left, the bars over it");
    h->Render(pixels.data());
    Check(pixels[(8*2+3)*256+(8*2+3)]==model.mapColors[1*4+1] && pixels[(8*8+3)*256+(8*2+3)]!=pixels[(8*9+3)*256+(8*2+3)],"rendered: the fill (palette 1's colour 1) and the stamp fill");

    pad(16,30); // Right, a pixel a frame
    unsigned walked=model.mapX;
    printf("walked %u px\n",walked);
    Check(walked>=16 && walked<=40,"Right scrolls a pixel a frame");
    view("the columns that came into view");
    pad(16|2,90); // B: runs past chunk A's east edge into B, the 64-wide map's second screen
    printf("ran to %u px\n",model.mapX);
    Check(model.mapX>=256,"running east: the next chunk, x past 256");
    view("the east chunk's columns, in the second screen");
    Check(h->WritePPM("build/sgb/map.ppm"),"screenshot");

    auto box=[&](){std::string b;for(unsigned i=0;i<model.boxRows;++i)b+=Chars(model.boxLines[i])+"|";return b;};
    auto settings=[&](){key(0x83);key(0x83);key(10); // SETTINGS: FULL SCREEN ... RESOLUTION (an SGB's)
        Check(box().find("| FULL SCREEN|")!=std::string::npos && box().find(" RESOLUTION|")!=std::string::npos,"SETTINGS: FULL SCREEN first, RESOLUTION on an SGB");};
    pad(8,4); // Start: the host's menu, over the map the SNES keeps
    Check(model.mapMode==1 && model.boxWidth,"Start: the menu over the map");
Check(box().find("| FILE| EDIT| SETTINGS| HELP| CLOSE|")!=std::string::npos,"FILE, EDIT, SETTINGS, HELP, CLOSE");
    Check(model.bars[1].chars.size() && Chars(model.bars[1]).find("chunk 1")!=std::string::npos,"the footer: where the view is");
    Check(h->WritePPM("build/sgb/map-menu.ppm"),"menu screenshot");
    settings();key(10); // FULL SCREEN
    for(waited=0;waited<600 && !(model.mapMode==2 && !model.boxWidth);++waited)Frames(core,1);
    Check(model.mapMode==2 && !model.boxWidth,"Full screen: the map without the bars");

    pad(8,4);settings();key(0x82);key(10); // RESOLUTION: in a map, 256x224 and 512x448
    Check(box().find("| 256x224| 512x448|")!=std::string::npos,"RESOLUTION in the map viewer: 256x224, 512x448");
    key(0x83);key(10);
    waited=0;
    for(;waited<3000 && !(model.mapMode==(2|SGBFS_MAP_HIRES) && matches(false));++waited)Frames(core,1);
    printf("512x448 sent: %u GB frames\n",waited);
    Check(model.mapMode==(2|SGBFS_MAP_HIRES),"512x448: MAP 2 at 512x448");
    Check(m->Read(syms.at("_resolution"))==2,"saved as the RESOLUTION setting");
    view("512x448: every cell of 65x57");
    Check(h->WritePPM("build/sgb/map-hires.ppm"),"512x448 screenshot");
    unsigned east=model.mapX;
    pad(128|2,150); // Down, running: past the chunk's south edge, the 64-row map's second half
    printf("512x448 ran to %u,%u px\n",model.mapX,model.mapY);
    Check(model.mapY>=256 && model.mapX==east,"512x448 running south: the next chunk, y past 256");
    view("512x448: the rows that came into view, in the second half");
    pad(16|2,60); // and east: the next screen of the 128-wide map
    view("512x448: the columns that came into view");
    pad(8,4);settings();key(0x82);key(10);key(0x82);key(10); // RESOLUTION > 256x224
    for(waited=0;waited<3000 && !(model.mapMode==2 && matches(false));++waited)Frames(core,1);
    Check(model.mapMode==2 && m->Read(syms.at("_resolution"))==0,"256x224 again");
    view("256x224 again: every cell");

    pad(8,4);key(0x82);key(10); // CLOSE
    for(unsigned i=0;i<300 && model.mapMode;++i)Frames(core,1);
    Frames(core,180);
    Check(model.mapMode==0 && selected().find("Test.gbmap")!=std::string::npos,"Close: the browser's text again");
    printf("SGB fullscreen map view passed\n");
}
