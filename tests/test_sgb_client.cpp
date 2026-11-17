// Real OS/bootstrap/LCD transport; the optional Gearboy branch supplies the SNES test double.
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iterator>
#include <map>
#include <string>
#include <vector>
#include <sys/stat.h>
#include <unistd.h>
#include "GearboyCore.h"
#include "SGB.h"
bool g_mcp_stdio_mode=true;
static std::vector<u16> pixels(256*224);
static void Check(bool b,const char* msg){if(!b){fprintf(stderr,"FAIL: %s\n",msg);exit(1);}}
static std::vector<u8> Read(const std::string& p){std::ifstream f(p,std::ios::binary);return std::vector<u8>((std::istreambuf_iterator<char>(f)),{});}
static void Write(const std::string& p,const std::vector<u8>& b){std::ofstream f(p,std::ios::binary);f.write((const char*)b.data(),b.size());Check(f.good(),"write SD fixture");}
static std::map<std::string,unsigned> Symbols(const char* p){std::map<std::string,unsigned> r;FILE* f=fopen(p,"r");Check(f,"symbols");char line[512],name[256];unsigned b,a;while(fgets(line,sizeof(line),f))if(sscanf(line,"%x:%x %255s",&b,&a,name)==3)r[name]=a;fclose(f);return r;}
static void Frames(GearboyCore& c,unsigned n){s16 a[AUDIO_BUFFER_SIZE];while(n--){int count=0;c.RunToVBlank(pixels.data(),a,&count);}}
static std::string Text(Memory* m,unsigned at){std::string s;for(unsigned i=0;i<128 && m->Read(at+i);++i)s+=char(m->Read(at+i));return s;}
static bool Contains(FatPakSGBHost* h,const std::string& text){for(const auto& r:h->GetModel().rows){std::string s(r.chars.begin(),r.chars.end());if(s.find(text)!=std::string::npos)return true;}return false;}
static void Fallback(const char* image,const std::map<std::string,unsigned>& syms,const char* data,const char* module,
                     const std::vector<u8>& file,unsigned mode) {
    char dir[]="/tmp/fatpak-client-fallback-XXXXXX";Check(mkdtemp(dir),"fallback SD");
    std::string root(dir);mkdir((root+"/GBCSYS").c_str(),0700);mkdir((root+"/GBCSYS/MODULES").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));Write(root+"/GBCSYS/MODULES/SGBBOOT.MOD",Read(module));
    if(mode) {auto b=file;if(mode==1)b.back()^=1;Write(root+"/GBCSYS/SGB.DAT",b);}
    GearboyCore c;c.Init();c.SetForceSGB(true);c.SetEverdriveFolder(dir);
    if(mode!=2)c.GetSGB()->GetFatPakHost()->Configure(FatPakSGBHost::TerminalV1);
    Check(c.LoadROM(image,false),"fallback OS");Frames(c,1800);
    auto m=c.GetMemory();
    Check(!(m->Read(syms.at("sys_info"))&4) && m->Read(syms.at("_screen_rows"))==18,"missing/corrupt/HELLO-timeout preserves GB geometry");
    Check(!m->Read(syms.at("_overlay_live")),"bootstrap rollback restores renderer");
    auto original=Read(image);
    for(unsigned p=syms.at("_RenderOverlayStart");p<syms.at("_RenderOverlayEnd");++p)
        Check(m->Read(p)==original[p],"bootstrap renderer bytes restored");
    printf("SGB fallback %u passed\n",mode);
}
int main(int n,char** v){
    Check(n==6,"arguments: OS symbols EDITOR.DAT SGB.DAT SGBBOOT.MOD");
    char dir[]="/tmp/fatpak-client-XXXXXX";Check(mkdtemp(dir),"SD");std::string root(dir);mkdir((root+"/GBCSYS").c_str(),0700);mkdir((root+"/GBCSYS/MODULES").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(v[3]));Write(root+"/GBCSYS/SGB.DAT",Read(v[4]));Write(root+"/GBCSYS/MODULES/SGBBOOT.MOD",Read(v[5]));
    std::string text="int counter = 1;\n// a comment\n";for(unsigned i=2;i<82;++i)text+="int line"+std::to_string(i)+" = 1;\n";Write(root+"/sample.c",std::vector<u8>(text.begin(),text.end()));
    auto syms=Symbols(v[2]);GearboyCore core;core.Init();core.SetForceSGB(true);core.SetEverdriveFolder(dir);
    core.GetSGB()->GetFatPakHost()->Configure(FatPakSGBHost::TerminalV1);Check(core.LoadROM(v[1],false),"load OS");
    Check(core.GetSGB()->GetFatPakHost()->SetRecording("build/sgb/client.fph"),"record real frontend LCD stream");
    auto h=core.GetSGB()->GetFatPakHost();auto m=core.GetMemory();
    Frames(core,2000);
    printf("boot PC=%04x sys=%02x geometry=%u host=%d good=%u bad=%u error=%s fault=%u row=%u pending=%u ack=%u mailbox=%u/%u/%u/%u file=%s\n",
        core.GetProcessor()->GetState()->PC->GetValue(),m->Read(syms.at("sys_info")),m->Read(syms.at("_screen_rows")),h->Active(),h->Good(),h->Bad(),h->LastError().c_str(),
        m->Read(syms.at("fs_fault")),m->Read(syms.at("fs_row")),m->Read(syms.at("fs_pending")),m->Read(syms.at("fs_ack")),
        h->GetMailbox()[0],h->GetMailbox()[1],h->GetMailbox()[2],h->GetMailbox()[3],Text(m,syms.at("_file_name")).c_str());
    if(m->Read(syms.at("fs_fault"))) {
        std::vector<u8> page(1920);for(unsigned i=0;i<page.size();++i)page[i]=m->ReadCGBLCDRAM(0x8000+i,false);
        Write("build/sgb/client-rejected.page",page);
    }
    Check(m->Read(syms.at("sys_info"))&4,"bootstrap activates fullscreen");
    Check(m->Read(syms.at("_screen_rows"))==28 && !m->Read(syms.at("fs_fault")),"wide geometry without transport fault");
    Check(h->Good()>1 && Contains(h,"sample.c"),"browser renders through v1 LCD pages");
    auto key=[&](unsigned code,unsigned mods=0){Check(h->Inject(1,code,mods),"inject key");Frames(core,180);};
    key(0x83);key(10);Frames(core,300);
    Check(Text(m,syms.at("_file_name")).find("sample.c")!=std::string::npos,"open browser file using mailbox keys");
    Check(Contains(h,"counter"),"editor text rows");
    key('Z');Check(Contains(h,"Zint"),"typed text reflected in terminal model");
    key('s',2);Frames(core,300);
    auto saved=Read(root+"/sample.c");Check(!saved.empty() && saved[0]=='Z',"Ctrl-S saves the actual SD file");
    for(unsigned i=0;i<30;++i)Check(h->Inject(1,0x83,0),"queue scroll burst");
    Frames(core,1800);
    Check(Contains(h,"line30"),"scroll burst advances the text viewport");
    key(0x81,1);
    bool selected=false;for(const auto& row:h->GetModel().rows) selected|=row.start!=row.end;
    Check(selected,"shift selection has pixel boundaries");
    Check(!m->Read(syms.at("fs_fault")),"no transport timeout");
    Check(h->WritePPM("build/sgb/client-reference.ppm"),"reference image");
    puts("SGB client bootstrap/browser/open/type/save/scroll/selection passed");
    for(unsigned mode=0;mode<3;++mode)Fallback(v[1],syms,v[3],v[5],Read(v[4]),mode);
}
