// Game Boy hardware registers for CC programs. Each is a volatile byte: every access in the
// source is one access on the bus, in order.
#ifndef CC_HARDWARE_H
#define CC_HARDWARE_H
#define CC_REG(address) (*(volatile unsigned char*)(address))
#define rP1   CC_REG(0xFF00)
#define rSB   CC_REG(0xFF01)
#define rSC   CC_REG(0xFF02)
#define rDIV  CC_REG(0xFF04)
#define rTIMA CC_REG(0xFF05)
#define rTMA  CC_REG(0xFF06)
#define rTAC  CC_REG(0xFF07)
#define rIF   CC_REG(0xFF0F)
#define rNR52 CC_REG(0xFF26)
#define rLCDC CC_REG(0xFF40)
#define rSTAT CC_REG(0xFF41)
#define rSCY  CC_REG(0xFF42)
#define rSCX  CC_REG(0xFF43)
#define rLY   CC_REG(0xFF44)
#define rLYC  CC_REG(0xFF45)
#define rDMA  CC_REG(0xFF46)
#define rBGP  CC_REG(0xFF47)
#define rOBP0 CC_REG(0xFF48)
#define rOBP1 CC_REG(0xFF49)
#define rWY   CC_REG(0xFF4A)
#define rWX   CC_REG(0xFF4B)
#define rKEY1 CC_REG(0xFF4D)
#define rVBK  CC_REG(0xFF4F)
#define rBCPS CC_REG(0xFF68)
#define rBCPD CC_REG(0xFF69)
#define rOCPS CC_REG(0xFF6A)
#define rOCPD CC_REG(0xFF6B)
#define rSVBK CC_REG(0xFF70)
#define rIE   CC_REG(0xFFFF)
#define LCDC_ON 0x80
#define LCDC_BG_8000 0x10
#define LCDC_BG_ON 0x01
#define VRAM_TILES ((volatile unsigned char*)0x8000)
#define VRAM_MAP0 ((volatile unsigned char*)0x9800)
#endif
