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
static void WaitForFullscreenStartup(GearboyCore& c,const std::map<std::string,unsigned>& syms) {
    auto m=c.GetMemory();
    for(unsigned i=0;i<4000;++i) {
        Frames(c,1);
        if(c.GetSGB()->GetFatPakHost()->Active() && m->Read(syms.at("_screen_rows"))==28)
            Check(m->Read(syms.at("sys_info"))&4,
                  "fullscreen owns VBlank before the initial wide redraw");
    }
}
static void Fallback(const char* image,const std::map<std::string,unsigned>& syms,const char* data,const char* module,
                     const std::vector<u8>& file,unsigned mode) {
    char dir[]="/tmp/fatpak-client-fallback-XXXXXX";Check(mkdtemp(dir),"fallback SD");
    std::string root(dir);mkdir((root+"/GBCSYS").c_str(),0700);mkdir((root+"/GBCSYS/MODULES").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(data));Write(root+"/GBCSYS/MODULES/SGBBOOT.MOD",Read(module));
    if(mode) {auto b=file;if(mode==1)b.back()^=1;Write(root+"/GBCSYS/SGB.DAT",b);}
    GearboyCore c;c.Init();c.SetForceSGB(true);c.SetEverdriveFolder(dir);
    if(mode!=2)c.GetSGB()->GetFatPakHost()->Configure(FatPakSGBHost::TerminalV1);
    Check(c.LoadROM(image,false),"fallback OS");
    WaitForFullscreenStartup(c,syms);
    auto m=c.GetMemory();
    Check(!(m->Read(syms.at("sys_info"))&4) && m->Read(syms.at("_screen_rows"))==18,"missing/corrupt/HELLO-timeout preserves GB geometry");
    Check(!m->Read(syms.at("_overlay_live")),"bootstrap rollback restores renderer");
    auto original=Read(image);
    for(unsigned p=syms.at("_RenderOverlayStart");p<syms.at("_RenderOverlayEnd");++p)
        Check(m->Read(p)==original[p],"bootstrap renderer bytes restored");
    printf("SGB fallback %u passed\n",mode);
}
int main(int n,char** v){
    setvbuf(stdout,nullptr,_IOLBF,0);
    Check(n==6,"arguments: OS symbols EDITOR.DAT SGB.DAT SGBBOOT.MOD");
    char dir[]="/tmp/fatpak-client-XXXXXX";Check(mkdtemp(dir),"SD");std::string root(dir);mkdir((root+"/GBCSYS").c_str(),0700);mkdir((root+"/GBCSYS/MODULES").c_str(),0700);
    Write(root+"/GBCSYS/EDITOR.DAT",Read(v[3]));Write(root+"/GBCSYS/SGB.DAT",Read(v[4]));Write(root+"/GBCSYS/MODULES/SGBBOOT.MOD",Read(v[5]));Write(root+"/GBCSYS/MODULES/HELP.MOD",Read("bin/MODULES/HELP.MOD"));Write(root+"/GBCSYS/MODULES/KEYTEST.MOD",Read("bin/MODULES/KEYTEST.MOD"));
    std::string text="int counter = 1;\n// a comment\n";for(unsigned i=2;i<82;++i)text+="int line"+std::to_string(i)+" = 1;\n";Write(root+"/sample.c",std::vector<u8>(text.begin(),text.end()));
    auto syms=Symbols(v[2]);GearboyCore core;core.Init();core.SetForceSGB(true);core.SetEverdriveFolder(dir);
    core.GetSGB()->GetFatPakHost()->Configure(FatPakSGBHost::TerminalV1);Check(core.LoadROM(v[1],false),"load OS");
    Check(core.GetSGB()->GetFatPakHost()->SetRecording("build/sgb/client.fph"),"record real frontend LCD stream");
    auto h=core.GetSGB()->GetFatPakHost();auto m=core.GetMemory();
    WaitForFullscreenStartup(core,syms);
    printf("boot PC=%04x sys=%02x geometry=%u host=%d good=%u bad=%u error=%s fault=%u row=%u pending=%u ack=%u mailbox=%u/%u/%u/%u file=%s\n",
        core.GetProcessor()->GetState()->PC->GetValue(),m->Read(syms.at("sys_info")),m->Read(syms.at("_screen_rows")),h->Active(),h->Good(),h->Bad(),h->LastError().c_str(),
        m->Read(syms.at("fs_fault")),m->Read(syms.at("fs_row")),m->Read(syms.at("fs_pending")),m->Read(syms.at("fs_ack")),
        h->GetMailbox()[0],h->GetMailbox()[1],h->GetMailbox()[2],h->GetMailbox()[3],Text(m,syms.at("_file_name")).c_str());
    if(m->Read(syms.at("fs_fault"))) {
        std::vector<u8> page(1920);for(unsigned i=0;i<page.size();++i)page[i]=m->ReadCGBLCDRAM(0x8000+i,false);
        Write("build/sgb/client-rejected.page",page);
    }
    Check(m->Read(syms.at("sys_info"))&4,"startup activates fullscreen without menu input");
    {
        const auto file=Read(v[4]);
        auto word32=[&](unsigned at){return unsigned(file[at])|(unsigned(file[at+1])<<8)|(unsigned(file[at+2])<<16)|(unsigned(file[at+3])<<24);};
        unsigned count=word32(14)+word32(18),load=word32(8)&0xffffff;
        const auto& ram=h->GetWRAM();
        for(unsigned i=0;i<count;++i)Check(ram[load-0x7e0000+i]==file[32+i],"bootstrap upload preserves all bytes across cartridge windows");
        for(unsigned i=count;i<((count+4095)&~4095u);++i)Check(!ram[load-0x7e0000+i],"bootstrap pads final DATA_TRN block with zeroes");
        printf("SGB bootstrap upload verified: %u bytes plus final-block padding\n",count);
    }
    Check(m->Read(syms.at("_screen_rows"))==28 && !m->Read(syms.at("fs_fault")),"wide geometry without transport fault");
    Check(h->Good()>1 && Contains(h,"sample.c"),"browser renders through v1 LCD pages");
    if(!std::getenv("SGB_CLIENT_PERF")) {
        // Exercise the resident wait with IE enabled but CPU IME disabled.
        // A pending VBlank cannot run its handler in this calling context.
        auto s=core.GetProcessor()->GetState();
        auto client=Symbols("build/sgb/client.sym");
        unsigned pc=s->PC->GetValue(),sp=s->SP->GetValue(),af=s->AF->GetValue(),
            bc=s->BC->GetValue(),de=s->DE->GetValue(),hl=s->HL->GetValue();
        bool ime=*s->IME,halt=*s->Halt;
        unsigned ie=m->Read(0xffff),flags=m->Read(0xff0f),a=m->Read(0xc100),b=m->Read(0xc101),
            stack0=m->Read((sp-2)&65535),stack1=m->Read((sp-1)&65535);
        unsigned before=m->Read(syms.at("_render_frames"));
        // Exercise the unrolled cache CRC with real SM83 instructions and varied seeds.
        std::vector<u8> source;for(unsigned i=0;i<64;++i)source.push_back(m->Read(0xc140+i));
        unsigned count=m->Read(syms.at("fs_count"));
        for(unsigned sample=0;sample<16;++sample) {
            unsigned expected=sample*0x1111u;
            for(unsigned i=0;i<64;++i) {
                u8 byte=u8((i*73u+sample*19u)^(i>>1));m->Write(0xc140+i,byte);
                expected^=unsigned(byte)<<8;
                for(unsigned bit=0;bit<8;++bit)expected=((expected<<1)^((expected&0x8000)?0x1021:0))&65535;
            }
            m->Write(0xc100,0x18);m->Write(0xc101,0xfe);
            m->Write((sp-2)&65535,0);m->Write((sp-1)&65535,0xc1);
            *s->IME=false;*s->Halt=false;
            s->SP->SetValue((sp-2)&65535);s->PC->SetValue(client.at("FsHashRow"));
            s->HL->SetValue(0xc140);s->DE->SetValue(sample*0x1111u);
            Frames(core,1);
            Check(s->DE->GetValue()==expected && s->HL->GetValue()==0xc180,
                  "unrolled row CRC matches CCITT for all source bytes and preserves its position");
        }
        for(unsigned i=0;i<64;++i)m->Write(0xc140+i,source[i]);
        m->Write(syms.at("fs_count"),count);
        puts("SGB row cache CRC: real CPU matches independent CCITT for 16 seeds/rows");

        m->Write(0xc100,0x18);m->Write(0xc101,0xfe); // return to a bounded test loop
        m->Write((sp-2)&65535,0);m->Write((sp-1)&65535,0xc1);
        before=m->Read(syms.at("_render_frames"));
        m->Write(0xffff,1);*s->IME=false;*s->Halt=false;
        s->SP->SetValue((sp-2)&65535);s->PC->SetValue(client.at("FsFrame"));
        Frames(core,3);
        Check(((m->Read(syms.at("_render_frames"))-before)&255)==1,
            "frame wait publishes status with IE enabled and IME disabled");
        Check(!*s->IME && m->Read(0xffff)==1,"frame wait preserves interrupt masking");
        // Start a delayed frame handler at LY 143 so it covers all of VBlank.
        // Foreground code must notice its counter update without seeing LY 144.
        const unsigned delay_at=0xc120;
        const u8 delay_code[]={0xf5,0x3e,0xff,0x3d,0x20,0xfd,0xf1,0xc3,
            u8(client.at("FsTick")),u8(client.at("FsTick")>>8),
            0x3e,1,0xea,0x31,0xc1,0x18,0xfe,0}; // return marker, then loop
        std::vector<u8> saved_delay;
        for(unsigned i=0;i<sizeof(delay_code);++i) {
            saved_delay.push_back(m->Read(delay_at+i));m->Write(delay_at+i,delay_code[i]);
        }
        m->Write((sp-2)&65535,0x2a);m->Write((sp-1)&65535,0xc1);
        s->SP->SetValue((sp-2)&65535);s->PC->SetValue(client.at("FsFrame"));
        unsigned stat=m->Read(0xff41),lyc=m->Read(0xff45),
            lcd_hi=m->Read(syms.at("rLCDInterrupt")),lcd_lo=m->Read(syms.at("rLCDInterrupt")+1);
        m->Write(syms.at("rLCDInterrupt"),delay_at>>8);
        m->Write(syms.at("rLCDInterrupt")+1,delay_at&255);
        m->Write(0xff45,143);m->Write(0xff41,0x40);
        m->Write(0xffff,2);m->Write(0xff0f,0);*s->IME=true;*s->Halt=false;
        before=m->Read(syms.at("_render_frames"));
        Frames(core,4);
        Check(((m->Read(syms.at("_render_frames"))-before)&255)>=2 && m->Read(0xc131)==1,
              "frame wait returns when interrupt consumes the entire VBlank");
        m->Write(0xff41,stat);m->Write(0xff45,lyc);
        m->Write(syms.at("rLCDInterrupt"),lcd_hi);m->Write(syms.at("rLCDInterrupt")+1,lcd_lo);
        for(unsigned i=0;i<saved_delay.size();++i)m->Write(delay_at+i,saved_delay[i]);
        m->Write(0xc100,a);m->Write(0xc101,b);
        m->Write((sp-2)&65535,stack0);m->Write((sp-1)&65535,stack1);
        s->PC->SetValue(pc);s->SP->SetValue(sp);s->AF->SetValue(af);
        s->BC->SetValue(bc);s->DE->SetValue(de);s->HL->SetValue(hl);
        m->Write(0xff0f,flags);m->Write(0xffff,ie);*s->IME=ime;*s->Halt=halt;
        puts("SGB frame wait: masked IME, overlong VBlank handler and interrupt-state preservation passed");
    }
    {
        auto frame=[&](){return unsigned(m->Read(syms.at("_render_frames"))) |
            (unsigned(m->Read(syms.at("_render_frames")+1))<<8);};
        // Isolate the VBlank clock from intentionally masked SD writes.
        unsigned logging=m->Read(syms.at("fs_log_active"));
        m->Write(syms.at("fs_log_active"),0);
        unsigned before=frame();Frames(core,300);
        unsigned elapsed=(frame()-before)&65535;
        m->Write(syms.at("fs_log_active"),logging);
        Check(elapsed>=299 && elapsed<=301,"fullscreen frame clock carries across low-byte rollover");
    }
    {
        Frames(core,60);
        auto& sample=const_cast<std::array<uint8_t,4>&>(h->GetMailbox());
        Check(!sample[0],"diagnostic sample waits for idle mailbox");
        sample={{uint8_t(m->Read(syms.at("fs_ack"))==127?126:127),39,0x34,0x12}};
        Frames(core,60);
        Check(!sample[0],"GB consumes optional hardware timing sample");
    }
    auto cursor=[&](){return unsigned(m->Read(syms.at("_cursor")))|(unsigned(m->Read(syms.at("_cursor")+1))<<8);};
    auto padTap=[&](unsigned held){
        Check(h->Inject(9,held,held),"inject pad press");Check(h->Inject(9,0,0),"inject pad release");Frames(core,180);
    };
    auto key=[&](unsigned code,unsigned mods=0){Check(h->Inject(1,code,mods),"inject key");Frames(core,180);};
    {
        std::vector<unsigned> selection;
        for(const auto& row:h->GetModel().rows)selection.push_back(unsigned(row.start)|(unsigned(row.end)<<8));
        Check(h->Inject(1,0x83,0),"inject browser Down");
        unsigned elapsed=0;bool changed=false;
        while(elapsed<180 && !changed) {
            Frames(core,1);++elapsed;unsigned row=0;
            for(const auto& value:h->GetModel().rows)changed|=selection[row++]!=(unsigned(value.start)|(unsigned(value.end)<<8));
        }
        Check(changed,"browser Down changes the selected row");
        printf("PERF: browser Down to published highlight: %u GB frames\n",elapsed);
        Frames(core,180-elapsed);
    }
    key(10);Frames(core,300);
    Check(Text(m,syms.at("_file_name")).find("sample.c")!=std::string::npos,"open browser file using mailbox keys");
    Check(Contains(h,"counter"),"editor text rows");
    Check(h->Inject(1,'Z',0),"inject typed character");
    unsigned typed_frames=0;while(typed_frames<180 && !Contains(h,"Zint")){Frames(core,1);++typed_frames;}
    Check(Contains(h,"Zint"),"typed text reflected in terminal model");
    printf("PERF: typed character to published text: %u GB frames\n",typed_frames);
    Frames(core,180-typed_frames);
    for(unsigned i=0;i<120 && !h->GetModel().cursorLook;++i)Frames(core,1);
    if(!h->GetModel().cursorLook || h->GetModel().cursorX!=unsigned(m->Read(syms.at("oam_buffer")+1)-8))
        fprintf(stderr,"cursor SNES x=%u look=%u GB x=%u y=%u\n",h->GetModel().cursorX,h->GetModel().cursorLook,m->Read(syms.at("oam_buffer")+1),m->Read(syms.at("oam_buffer")));
    Check(h->GetModel().cursorLook && h->GetModel().cursorX==unsigned(m->Read(syms.at("oam_buffer")+1)-8),
          "SNES cursor follows left-aligned text without the GB sprite offset");
    if(std::getenv("SGB_CLIENT_PERF"))return 0;
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
    std::vector<u8> body(26*64);
    for(unsigned i=0;i<body.size();++i)body[i]=m->Read(0xD000+i);
    padTap(8);Frames(core,180);
    Check(h->GetModel().boxWidth>0 && h->GetModel().boxRows>=5,"file menu uses BOX overlay");
    unsigned widest=0;
    for(const auto& row:h->GetModel().boxLines){unsigned width=0;for(auto c:row.chars)width+=m->Read(syms.at("FontVWFWidths")+c);if(width>widest)widest=width;}
    Check(h->GetModel().boxWidth==widest+9,"real menu width follows its text metrics plus padding");
    Check(h->GetModel().boxX==(256-h->GetModel().boxWidth)/2,"real menu is centered on the full SNES viewport");
    bool label=false;for(const auto& r:h->GetModel().boxLines){std::string s(r.chars.begin(),r.chars.end());label|=s.find("SETTINGS")!=std::string::npos;}
    Check(label,"BOX_LINE carries actual menu labels");
    for(unsigned i=0;i<body.size();++i)Check(m->Read(0xD000+i)==body[i],"menu storage preserves every visible text row");
    unsigned hi=h->GetModel().boxHi;key(0x83);Check(h->GetModel().boxHi!=hi,"BOX_HI follows selection");
    Check(h->WritePPM("build/sgb/client-menu.ppm"),"menu reference image");
    key(27);Frames(core,180);Check(!h->GetModel().boxWidth,"closing a menu clears only its overlay");
    Check(!m->Read(syms.at("fs_fault")),"menu operations retain transport");
    key(0x90);Frames(core,300);
    {const auto& title=h->GetModel().bars[0].chars;Check(std::string(title.begin(),title.end()).find("TEXT EDITOR")!=std::string::npos,"help module maps its title to the wide bar");}
    for(unsigned r=17;r<27;++r)for(auto c:h->GetModel().rows[r].chars)Check(c==32,"unused wide help rows do not retain document text");
    key(27);Frames(core,300);Check(Contains(h,"line30"),"return from help restores document rows");
    Check(!m->Read(syms.at("fs_fault")),"help module retains transport");
    for(unsigned i=0;i<body.size();++i)body[i]=m->Read(0xD000+i);
    unsigned before_b=m->Read(syms.at("_modified")),before_b_cursor=cursor();
    padTap(2);Check(m->Read(syms.at("_modified"))==before_b && cursor()==before_b_cursor,"B alone does not delete text with keyboard hidden");
    padTap(4);Frames(core,180);
    if(m->Read(syms.at("fs_fault"))){
      std::vector<u8> page(1920);for(unsigned i=0;i<page.size();++i)page[i]=m->ReadCGBLCDRAM(0x8000+i,false);Write("build/sgb/osk-rejected.page",page);
      printf("OSK rejected good=%u bad=%u error=%s seq=%u pending=%u\n",h->Good(),h->Bad(),h->LastError().c_str(),m->Read(syms.at("fs_seq")),m->Read(syms.at("fs_pending")));
    }
    Check(h->GetModel().oskRows==5,"Select opens the OSK");
    Check(h->GetModel().textRows==26 && m->Read(syms.at("_tb_rows"))==26,"OSK leaves the full document viewport intact");
    for(unsigned i=0;i<body.size();++i)Check(m->Read(0xD000+i)==body[i],"opening OSK preserves document row characters");
    padTap(16);Frames(core,60);Check(h->GetModel().oskKey==1,"terminal pad action moves the OSK highlight");
    padTap(1);Frames(core,180);Check(Contains(h,"i2t"),"terminal A action types the selected OSK key");
    unsigned before_delete=cursor();padTap(2);
    Check(cursor()+1==before_delete && !Contains(h,"i2t"),"B deletes only with the keyboard open");
    padTap(32);padTap(64);padTap(1);
    Check(h->GetModel().oskLayer==1,"OSK shift uses the shared layer handler");
    padTap(16);padTap(1);Check(h->GetModel().oskLayer==2,"OSK symbols layer");
    padTap(1);Check(h->GetModel().oskLayer==0,"OSK returns to lower case");
    padTap(4);Frames(core,180);Check(!h->GetModel().oskRows,"Select closes the OSK");
    Check(!m->Read(syms.at("fs_fault")),"OSK operations retain transport");
    unsigned before_page=cursor();
    Check(h->Inject(9,2,2),"hold B");Frames(core,10);
    Check(h->Inject(9,66,64),"B plus Up");
    for(unsigned i=0;i<90 && cursor()==before_page;++i)Frames(core,1);
    Check(h->Inject(9,0,0),"release page navigation");Frames(core,180);
    Check(cursor()<before_page && before_page-cursor()>64,"B plus Up pages instead of deleting or moving one row");
    unsigned before_shift=cursor();
    Check(h->Inject(9,1,1),"hold A");Frames(core,10);
    Check(h->Inject(9,17,16),"A plus Right");
    for(unsigned i=0;i<90 && cursor()==before_shift;++i)Frames(core,1);
    Check(h->Inject(9,0,0),"release selection");Frames(core,180);
    unsigned anchor=unsigned(m->Read(syms.at("_anchor")))|(unsigned(m->Read(syms.at("_anchor")+1))<<8);
    Check(anchor!=cursor(),"A plus direction selects text with keyboard hidden");
    m->Write(syms.at("fs_progress_loaded"),50);m->Write(syms.at("fs_progress_total"),200);
    Frames(core,180);Check(h->GetModel().loaded==25 && h->GetModel().total==100,"GB progress emitter converts sectors to counted KiB");
    m->Write(syms.at("fs_progress_loaded"),0);m->Write(syms.at("fs_progress_total"),0);
    Frames(core,180);Check(!h->GetModel().total,"GB progress emitter clears the progress bar");
    key(0x89);key(0x83);key(0x83);key(10); // SETTINGS
    for(unsigned i=0;i<5;++i)key(0x83);
    key(10);Frames(core,300); // KEYBOARD driver module
    bool test_item=false,snes_item=false;
    for(const auto& r:h->GetModel().boxLines){std::string s(r.chars.begin(),r.chars.end());test_item|=s.find("TEST")!=std::string::npos;snes_item|=s.find("SNES")!=std::string::npos;}
    Check(test_item && !snes_item,"fullscreen keyboard menu retains TEST and hides the BIOS-only SNES mouse bridge");
    key(27);Frames(core,180);Check(!m->Read(syms.at("_module_busy")),"keyboard menu returns to the document");
    Check(!m->Read(syms.at("fs_fault")),"keyboard menu retains transport");
    puts("SGB overlay menu labels/highlight/close, storage, help/return, OSK and progress passed");
    // Delay a real ACK beyond the GB timeout, without changing emulator code.
    // The existing test double's busy commit holds its immutable payload.
    h->SetRecording("");
    Check(h->Inject(1,'V',0),"queue edit for delayed ACK");
    auto& mailbox=const_cast<std::array<uint8_t,4>&>(h->GetMailbox());
    unsigned held=0;
    for(unsigned i=0;i<600;++i){
        if(!held && mailbox[0] && mailbox[1]==6){held=mailbox[0];mailbox[0]|=128;}
        Frames(core,1);
        if(held && m->Read(syms.at("fs_fault")))break;
    }
    Check(held && m->Read(syms.at("fs_fault")) && m->Read(syms.at("fs_pending")),"delayed ACK reaches actual GB page timeout");
    unsigned page=mailbox[3],good=h->Good();
    // Change the GB expectation, keeping the test double's held payload intact.
    // Mutating that payload would make it queue a second copy of the real ACK.
    m->Write(syms.at("fs_seq"),page==255?1:page+1);mailbox[0]=held;
    Frames(core,30);
    Check(m->Read(syms.at("fs_fault")) && m->Read(syms.at("fs_pending")) && h->Good()==good,"wrong-page ACK cannot clear timeout or publish another page");
    m->Write(syms.at("fs_seq"),page);
    Frames(core,300);
    // Recovery can already have published another page at this sampling point.
    // Require forward progress, rather than catching the transport between pages.
    if(m->Read(syms.at("fs_fault")) || h->Good()<=good)
        fprintf(stderr,"late ACK: fault=%u pending=%u page=%u ack=%u mailbox=%u/%u/%u/%u good=%u PC=%04x\n",m->Read(syms.at("fs_fault")),m->Read(syms.at("fs_pending")),m->Read(syms.at("fs_seq")),m->Read(syms.at("fs_ack")),mailbox[0],mailbox[1],mailbox[2],mailbox[3],h->Good(),core.GetProcessor()->GetState()->PC->GetValue());
    Check(!m->Read(syms.at("fs_fault")) && h->Good()>good,"matching late ACK clears timeout and resumes transport");
    good=h->Good();key('W');
    Check(h->Good()>good && Contains(h,"W"),"editing publishes new text after late ACK recovery");
    puts("SGB delayed ACK: actual timeout, wrong-page rejection, late recovery and continued editing passed");
    if(getenv("SGB_CLIENT_NO_LOG")) {
        Frames(core,300);
        Check(!m->Read(syms.at("fs_log_active")) && access((root+"/GBCSYS/SGB.LOG").c_str(),F_OK)!=0,
            "logging-disabled control build does not create or flush a log");
        puts("SGB control build: no SD recorder writes passed");
    } else {
        Frames(core,300);
        auto log=Read(root+"/GBCSYS/SGB.LOG");
        Check(log.size()>=28 && std::string(log.begin(),log.begin()+8)==std::string("SGBLOG1\0",8) && log[10]==12,"hardware log is persisted to SD");
        const auto data=Read(v[4]);
        Check(log[11]==data[26] && log[12]==data[27],"hardware log identifies the loaded SGB.DAT build");
        Check((log.size()-16)%12==0 && log.size()<=8192,"hardware log is bounded and has complete records");
        bool ack=false,write=false,timing=false;
        for(unsigned at=16;at<log.size();at+=12){
            ack|=log[at]==3;write|=log[at]==6;
            timing|=log[at]==39 && log[at+8]==0x34 && log[at+9]==0x12;
        }
        Check(ack && write && timing,"SD log retains ACKs, SD-write timing and SNES telemetry");
        Write("build/sgb/hardware-test.SGB.LOG",log);
        puts("SGB hardware log: durable bounded records, SNES timing sample and ACKs passed");
    }
    for(unsigned mode=0;mode<3;++mode)Fallback(v[1],syms,v[3],v[5],Read(v[4]),mode);
}
