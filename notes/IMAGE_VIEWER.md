# Image viewer (PNG)

[Architecture](ARCHITECTURE.md) · [Modules](MODULES.md) · [EverDrive compatibility](EVERDRIVE.md) · [TODO](TODO.md)

This document details the architectural exploration and implementation plan for
viewing PNG images in FatPak on DMG, CGB, and SGB hardware.

It analyzes two architectural approaches:
1. **In-OS Loadable Module (`.MOD`)**: Running as a Page 13 overlay within FatPak OS.
2. **Standalone Viewer Game (`VIEWER.GBC`) via SRAM Injection**: Abusing the
   EverDrive cartridge SRAM loading system to pass image data from the SD card
   to a dedicated Game Boy Color application.

---

## 1. Architectural Trade-offs

| Criterion | In-OS Module (`.MOD`) | Standalone Game (`VIEWER.GBC`) via SRAM |
| :--- | :--- | :--- |
| **Code budget** | Strict 7,424 bytes (`$1D00` in Page 13) | Unlimited (up to 7.5 MiB ROM) |
| **Sliding window** | Contends for PSRAM window blocks | Full 32 KiB internal CGB WRAM (Banks 1–4) |
| **SD card access** | Requires complex file streaming ABI | OS stages file to SRAM before launch |
| **Rendering** | Constrained by OS state and display mode | Full CGB double-speed CPU, dedicated HDMA |
| **Exit / Return** | Returns synchronously to caller | Soft-reset to `WarmMain` or cart-button menu |
| **Feasibility** | Unrealistic for full PNG/DEFLATE | **Recommended and fully feasible** |

### Why the In-OS Module Path is Blocked for Full PNG
- **Code size limit:** Page 13 (`$A000-$BCFF`, 7,424 bytes) must contain code,
  constants, and BSS. A compliant DEFLATE/inflate engine, dynamic Huffman table
  builders, PNG chunk parser, 5 scanline unfilter algorithms, color quantizer,
  and interactive viewport cannot fit in 7.4 KB under SDCC.
- **Missing File ABI:** The module ABI currently has zero filesystem hooks.
  Adding streaming reads (`ModFileOpen`, `ModFileRead`) is difficult because
  FatFs shares a single 512-byte sector buffer that cannot be clobbered.
- **Window RAM limits:** PNG DEFLATE allows LZ77 back-references up to 32 KiB.
  DMG only has 8 KiB of internal WRAM. Buffering 32 KiB requires managing
  external PSRAM window blocks during decompression.

---

## 2. Standalone Viewer & SRAM Abuse Architecture

### The Hardware Boundary
When FatPak launches a game (`GameLaunch` in `src/game/launch.asm`), it writes
the target mapper to `$BD07` and resets the Game Boy. The EverDrive FPGA locks
into standard MBC mode (e.g. MBC5), **permanently hiding EverDrive registers
(`$BD00-$BD0F`) and blocking SD card SPI access**.

A standalone game cannot read the SD card. However, **the OS has full control
over cartridge battery-backed SRAM immediately before the mapper lock**.

```
                        SD Card (FatFs)
                               │
                 [1] Reads "photo.png" via FatFs
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ FatPak OS (Loader & Staging)                                │
│                                                             │
│   [2] Enable Save RAM: rEDX_CONFIG |= 2                     │
│   [3] Stream Image Header + raw PNG to SaveRamBlock(0..N)   │
│   [4] Stage VIEWER.GBC to PSRAM ($0000-$3bff)               │
│   [5] Trigger GameLaunch() with MBC5 + 128 KiB RAM          │
└─────────────────────────────────────────────────────────────┘
                               │
                               │ [6] Mapper Lock & Reset ($BD07)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ Standalone Application: VIEWER.GBC                          │
│                                                             │
│   - MBC5 + 128 KiB Battery RAM                              │
│   - Enables SRAM ($0000 <- $0A)                             │
│   - Reads header & raw PNG directly from $A000-$BFFF        │
│   - Switches banks via $4000 (Banks 0–15) to stream bytes   │
│   - Decompresses DEFLATE & renders to Game Boy VRAM         │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. SRAM Protocol Specification

An MBC5 cartridge with RAM size `$04` has **128 KiB of SRAM** divided into
16 banks of 8 KiB (256 sectors of 512 bytes).

### Bank 0: Image Container Header (`$A000-$BFFF`)

| Offset | Size | Field | Description |
| :--- | :--- | :--- | :--- |
| `$0000` | 4 | `Magic` | ASCII `'V'`, `'I'`, `'E'`, `'W'` (`$56, $49, $45, $57`) |
| `$0004` | 1 | `Version` | Protocol version (`$01`) |
| `$0005` | 1 | `Flags` | Bit 0: Fit-to-screen default; Bit 1: CGB double-speed hint |
| `$0006` | 4 | `FileSize` | 32-bit little-endian byte count of the raw PNG payload |
| `$000A` | 2 | `PayloadBank` | Starting SRAM bank for raw PNG (Bank 1 = `$0001`) |
| `$000C` | 2 | `PayloadAddr` | Starting address within bank (`$A000`) |
| `$000E` | 64 | `Filename` | Null-terminated Latin-1 / UTF-8 original filename |
| `$004E` | 2 | `CRC16` | CRC-16/CCITT checksum of the header |
| `$0050` | 8112 | `Reserved` | Space for thumbnail preview or pre-calculated palettes |

### Banks 1–15: Raw PNG Payload
- **Usable capacity:** $15 \times 8\text{ KiB} = 120\text{ KiB}$.
- The raw PNG file (including chunks `IHDR`, `PLTE`, `IDAT`, `IEND`) is streamed
  linearly across Banks 1 through 15.
- The viewer accesses the stream by writing the desired bank (1–15) to
  `$4000-$5FFF` and reading from `$A000-$BFFF`.

---

## 4. FatPak OS Integration

### Browser Detection (`src/browser/browser.c`)
In `src/browser/browser.c`, detect `.png` files alongside ROM checks:
```c
if (IsGame(entry.name)) {
  LaunchGame(path);
  path[length] = 0;
  drawn = LIST_ALL;
  continue;
} else if (IsImage(entry.name)) {
  LaunchImageViewer(path);
  path[length] = 0;
  drawn = LIST_ALL;
  continue;
}
```

### Staging Logic (`src/game/loader.c`)
1. **Preserve Editor State:** Call `FileSaveSwap()` so text buffer and settings
   persist.
2. **Open PNG via FatFs:** Check file existence and verify `f_size(&file) <= 120 * 1024`.
3. **Write Bank 0 Header:**
   ```c
   SaveRamBlock(0, 1);
   memcpy(WINDOW, &header, sizeof(header));
   SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
   ```
4. **Stream Sectors into SRAM:**
   Stream 512-byte sectors from the file into `SaveRamBlock(16 + i, 1)` (each
   SRAM bank is 16 sectors).
5. **Launch Viewer:** Call `LaunchGame("/GBCSYS/VIEWER.GBC")`.

---

## 5. Standalone Viewer Application (`VIEWER.GBC`)

### Cartridge Header
- **Cartridge Type:** MBC5+RAM+BATTERY (`$1B` at `$0147`).
- **RAM Size:** 128 KiB (`$04` at `$0149`).
- **CGB Flag:** `$80` at `$0143` (supports both CGB and DMG).

### CGB WRAM Allocation
CGB provides 32 KiB of internal WRAM across 8 banks:
- **WRAM0 (`$C000-$CFFF`, 4 KiB):** Fixed variables, stack, joypad state,
  rendering parameters.
- **WRAM Banks 1–4 (`$D000-$DFFF`, 16 KiB switched):** Circular sliding window
  (32 KiB) for DEFLATE back-references (`distance <= 32768`).
- **WRAM Bank 5:** Current and previous scanline unfilter buffers ($160 \times 3 = 480$
  bytes each for 160 px RGB; $<1$ KiB total).
- **WRAM Bank 6:** Dynamic Huffman decode trees and bitstream input buffer.
- **WRAM Bank 7:** Quantized 2bpp tile conversion buffer.

### Streaming Byte Reader
A simple reader abstraction switches SRAM banks transparently:
```c
static unsigned char sram_bank = 1;
static unsigned int sram_addr = 0xA000;

unsigned char NextPngByte(void) {
  unsigned char byte;
  *(volatile unsigned char*)0x4000 = sram_bank; // Switch MBC5 SRAM bank
  byte = *(volatile unsigned char*)sram_addr;
  if (++sram_addr >= 0xC000) {
    sram_addr = 0xA000;
    ++sram_bank;
  }
  return byte;
}
```

### Decoding & Display Pipeline
1. **PNG Chunks:** Validate 8-byte PNG signature; extract dimensions, depth,
   and color type from `IHDR`. Read `PLTE` palette if indexed.
2. **Inflate Engine:**
   - Bit-level reader pulling bytes via `NextPngByte()`.
   - Dynamic Huffman tree builder for code length, literal/length, and distance
     alphabets.
   - LZ77 reference resolution using the 32 KiB circular window in WRAM Banks 1–4.
3. **Scanline Unfiltering:**
   - Filters: None (0), Sub (1), Up (2), Average (3), Paeth (4).
   - Reconstructs pixels on the fly into WRAM Bank 5.
4. **Quantization & Rendering:**
   - **DMG:** RGB $\to$ Luminance ($Y = (2R + 5G + B) \gg 3$), dithered to 4
     shades using an ordered 4×4 Bayer matrix.
   - **CGB:** Convert to 15-bit BGR555; quantize each 8×8 block into 4 colors;
     assign to one of the 8 background palettes using color-distance heuristics.
5. **Navigation & Controls:**
   - **D-Pad:** Pan viewport across the image.
   - **A Button:** Toggle Zoom (1:1 pixel view $\leftrightarrow$ fit to screen).
   - **B Button / Start + Select:** Soft return to FatPak OS.

---

## 6. Returning to FatPak OS

When the user exits `VIEWER.GBC`:
1. The viewer disables interrupts and blanks the LCD during VBlank.
2. It executes a resident handoff stub that selects EverDrive OS mapping
   (`$BD06 = $00`).
3. It jumps to FatPak's `WarmMain` (`$0000` / `$01E0`), restoring the file
   browser immediately without a cold reboot cycle.
4. Alternatively, the physical EverDrive cartridge button opens FatPak's
   in-game menu (`notes/GAME_MENU.md`) to select "Return to OS".

---

## 7. Next Steps & Checklist

- [ ] Add `IsImage()` extension check in `src/game/loader.c`.
- [ ] Implement `ImageSramStage(path)` in `src/game/loader.c` to write Bank 0
  header and raw PNG sectors into battery RAM.
- [ ] Scaffold `VIEWER.GBC` repository/subproject with RGBDS (MBC5 + 128 KiB RAM).
- [ ] Implement SM83-optimized `inflate` and scanline unfilter routines.
- [ ] Implement DMG Bayer dithering and CGB 8-palette tile quantization.
- [ ] Add D-pad viewport navigation and soft return to `WarmMain`.
