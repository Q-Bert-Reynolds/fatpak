// Execute the actual overlay loader on the GB CPU, without the SGB test host.
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
#include "Memory.h"
#include "Processor.h"
bool g_mcp_stdio_mode=true;
static std::vector<u16> frame(256*224);
static void Check(bool ok,const char* what) { if(!ok) { fprintf(stderr,"FAIL: %s\n",what);exit(1); } }
static std::vector<u8> Read(const char* path) { std::ifstream f(path,std::ios::binary);Check(f.good(),"fixture");return std::vector<u8>((std::istreambuf_iterator<char>(f)),{}); }
static void Write(const std::string& p,const std::vector<u8>& b) { std::ofstream f(p,std::ios::binary);f.write((const char*)b.data(),b.size());Check(f.good(),"write fixture"); }
static std::map<std::string,unsigned> Symbols(const char* path) {
    std::map<std::string,unsigned> r;FILE* f=fopen(path,"r");Check(f,"symbols");char line[512],name[256];unsigned bank,at;
    while(fgets(line,sizeof(line),f))if(sscanf(line,"%x:%x %255s",&bank,&at,name)==3)r[name]=at;
    fclose(f);return r;
}
static unsigned Call(GearboyCore& c,unsigned address) {
    auto cpu=c.GetProcessor()->GetState();auto m=c.GetMemory();
    cpu->SP->SetValue(0xCB10);m->Write(0xCB10,0xFF);m->Write(0xCB11,0x7F);
    *cpu->Halt=false;*cpu->IME=false;cpu->PC->SetValue(address);
    for(unsigned i=0;i<20000000 && cpu->PC->GetValue()!=0x7FFF;++i) {
        unsigned ticks=0;c.RunCycle(frame.data(),ticks);
        if(i%3000==2999){s16 a[AUDIO_BUFFER_SIZE];int n=0;c.EndFrame(a,&n);}
    }
    if(cpu->PC->GetValue()!=0x7FFF)fprintf(stderr,"stalled %04x PC=%04x\n",address,cpu->PC->GetValue());
    Check(cpu->PC->GetValue()==0x7FFF,"overlay call returns");return cpu->AF->GetValue()>>8;
}
static void Test(const char* image,const char* sym,const char* data,const char* fixture,bool color) {
    auto syms=Symbols(sym);auto ovl=Read(fixture);auto rom=Read(image);
    char directory[]="/tmp/fatpak-overlay-XXXXXX";Check(mkdtemp(directory),"SD");std::string root(directory);mkdir((root+"/GBCSYS").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));
    GearboyCore core;core.Init();core.SetEverdriveFolder(directory);Check(core.LoadROM(image,!color),"load OS");
    for(int i=0;i<600;++i){s16 a[AUDIO_BUFFER_SIZE];int n=0;core.RunToVBlank(frame.data(),a,&n);}
    auto m=core.GetMemory();m->Write(0xFFFF,0);Call(core,syms.at("RenderWaitDMA"));m->Write(0xFF40,0);
    auto word=[&](unsigned at,unsigned n){m->Write(at,n);m->Write(at+1,n>>8);};
    auto block=[&](unsigned n){m->Write(0xBD03,n>>8);m->Write(0xBD02,n);};
    auto byte=[&](const char* name){return m->Read(syms.at(name));};
    auto call=[&](const char* name){return Call(core,syms.at(name));};
    unsigned start=syms.at("_RenderOverlayStart"),end=syms.at("_RenderOverlayEnd"),req=syms.at("_overlay_request");
    std::vector<u8> original;for(unsigned p=start;p<end;++p)original.push_back(m->Read(p));
    // Envelope begins at offset 507 to straddle PSRAM sectors.
    auto stage=[&](const std::vector<u8>& b){m->Write(0xBD06,4);for(unsigned i=0;i<b.size();++i){block(0x3B00+(i+507)/512);m->Write(0xBE00+(i+507)%512,b[i]);}word(req,0x3B00);word(req+2,507);block(0x0109);m->Write(0xBD06,6);};
    auto unchanged=[&](){for(unsigned i=0;i<original.size();++i)Check(m->Read(start+i)==original[i],"renderer intact");};
    stage(ovl);m->Write(0xFFFF,1);Check(call("_OverlayInstall")==2,"refuse live interrupts");m->Write(0xFFFF,0);unchanged();
    auto bad=ovl;bad[16]^=1;stage(bad);Check(call("_OverlayInstall")==1,"CRC fails before write");unchanged();
    bad=ovl;bad[6]^=1;stage(bad);Check(call("_OverlayInstall")==1,"host binding rejects");unchanged();
    bad=ovl;bad[9]=0xA0;stage(bad);Check(call("_OverlayInstall")==1,"outside fixed interval rejects");unchanged();
    stage(ovl);Check(call("_OverlayInstall")==0,"install");Check(byte("_overlay_live")==1,"live state");
    Check(m->Read(0xBD02)==9 && m->Read(0xBD03)==1 && m->Read(0xBD06)==6,"window/config restored");
    Check(Call(core,start)==42,"installed code executes");Check(call("_OverlayInstall")==2,"nested install refused");
    // Corrupt the backup: restoration must fail closed, then permit a repaired retry.
    m->Write(0xBD06,4);block(0x3B90);unsigned first=m->Read(0xBE00);m->Write(0xBE00,first^1);
    Check(call("_OverlayRestore")==3 && byte("_overlay_live"),"bad backup cannot be restored");
    block(0x3B90);m->Write(0xBE00,first);Check(call("_OverlayRestore")==0,"restore verified backup");unchanged();
    Check(!byte("_overlay_live") && call("_OverlayRestore")==0,"restore idempotent");
    stage(Read((std::string(fixture)+".full").c_str()));
    Check(call("_OverlayInstall")==0 && Call(core,start)==42,"full renderer interval replaced and executable");
    Check(call("_OverlayRestore")==0,"full renderer interval restore");unchanged();
    printf("%s overlay install/execute/reject/restore passed\n",color?"CGB":"DMG");
}
int main(int n,char** v){Check(n==5,"arguments");Test(v[1],v[2],v[3],v[4],false);Test(v[1],v[2],v[3],v[4],true);}
