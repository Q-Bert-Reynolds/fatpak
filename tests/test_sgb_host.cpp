// Phase 3: execute the real Phase 0b Game Boy transport in Gearboy's opt-in host.
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iterator>
#include <vector>
#include "GearboyCore.h"
#include "SGB.h"
bool g_mcp_stdio_mode=true;
static void Check(bool b,const char* what) { if(!b) { fprintf(stderr,"FAIL: %s\n",what); std::exit(1); } }
int main(int argc,char** argv) {
    Check(argc==5,"arguments: bench.gb bench.bin recording SGB.DAT");
    GearboyCore core; core.Init(); core.SetForceSGB(true);
    core.GetSGB()->GetFatPakHost()->Configure(FatPakSGBHost::BenchV0);
    Check(core.LoadROM(argv[1],false),"load bench ROM");
    auto host=core.GetSGB()->GetFatPakHost();
    Check(host->SetRecording(argv[3]),"start frame/packet recording");
    std::vector<u16> frame(256*224); s16 audio[AUDIO_BUFFER_SIZE];
    unsigned frames=0;
    for(;frames<2500;++frames) {
        int n=0; core.RunToVBlank(frame.data(),audio,&n);
        auto memory=core.GetMemory();
        if(memory->Read(0xC100)==6 || memory->Read(0xC100)==0xE1) break;
    }
    printf("bench: frames=%u phase=%02X stage=%02X host good=%u bad=%u uploaded=%u error=%s\n",frames,
        core.GetMemory()->Read(0xC100),core.GetMemory()->Read(0xC130),host->Good(),host->Bad(),host->UploadBytes(),host->LastError().c_str());
    Check(core.GetMemory()->Read(0xC100)==6,"bench completes all four stages without timeout");
    Check(core.GetMemory()->Read(0xC130)==4,"bench final stage");
    Check(host->Good()==66 && host->Bad()>0,"66 valid pages and intentional checksum rejection");
    std::ifstream f(argv[2],std::ios::binary); std::vector<uint8_t> blob((std::istreambuf_iterator<char>(f)),{});
    Check(blob.size()==4096 && host->UploadBytes()==4096,"one complete DATA_TRN upload");
    Check(std::equal(blob.begin(),blob.end(),host->GetWRAM().begin()+0x10000),"all 4096 uploaded bytes match SNES payload");
    Check(host->Entry()==0x7F0000,"JUMP enters uploaded entry");
    Check(host->VerifyDataFile(argv[4]),"SGB.DAT metadata/CRC and every uploaded program/font byte");
    host->SetRecording("");
    FatPakSGBHost replay;
    Check(replay.Replay(argv[3]),"replay recorded packet/LCD stream");
    Check(replay.Good()==host->Good() && replay.Bad()==host->Bad() && replay.Frames()==host->Frames(),"replay matches original counters");
    Check(replay.GetWRAM()==host->GetWRAM() && replay.GetMailbox()==host->GetMailbox(),"replay matches WRAM/mailbox");
    puts("Gearboy FatPak host bench and replay passed");
}
