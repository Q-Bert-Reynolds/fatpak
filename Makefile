LANGUAGE  = EN#EN ES FR IT PT DE JA
OS        = 1#1 = EverDrive X OS (/GBCSYS/GBCOS.BIN), 0 = MBC5 cartridge ROM
DEFINES   = -D LANG_$(LANGUAGE)
ifeq ($(OS), 1)
DEFINES  += -D EVERDRIVE_OS
endif
ifeq ($(DIAG), 1)
DEFINES  += -D INGAME_DIAG
endif

GAME_NAME = TEXT_EDITOR
ROM_NAME  = $(GAME_NAME).gbc
ROM_FILE  = $(BIN_DIR)/$(ROM_NAME)
SYM_FILE  = $(BIN_DIR)/$(GAME_NAME).sym

SRC_DIR   = src
DATA_DIR  = data
BIN_DIR   = bin
BUILD_DIR = build
SD_DIR    = sd
SD_IMAGE  = $(BIN_DIR)/sdcard.img

ifeq ($(OS), Windows_NT)
PYTHON	  = python
else
PYTHON	  = python3
endif

C_SOURCES = $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/**/*.c) $(wildcard $(DATA_DIR)/**/*.c) 
C_HEADERS = $(wildcard $(SRC_DIR)/*.h) $(wildcard $(SRC_DIR)/**/*.h)
# included by C sources, not compiled on their own
C_LIBS    = $(wildcard $(SRC_DIR)/*/lib/*.c) $(wildcard $(SRC_DIR)/*/lib/*.h)
C_ASM     = $(join $(dir $(C_SOURCES)), $(patsubst %.c, _%.asm, $(notdir $(C_SOURCES))))

all: clean assets assemble run

code: assemble run

_%.asm: %.c $(C_HEADERS) $(C_LIBS) $(wildcard $(SRC_DIR)/*/*.banks)
	@mkdir -p $(BUILD_DIR)
	sdcc $< -msm83 --asm=rgbds --opt-code-size --dataseg WRAM0 --no-peep --peep-file peephole.def $(DEFINES) --disable-warning 218 -S -o $@
	@sed -i 's/^\t\.byte /\tDB /' $@ # SDCC writes long constants as .byte
ifeq ($(OS), 1)
	@if [ -f $(basename $<).os.banks ]; then $(PYTHON) bank_split.py $@ $(basename $<).os.banks --os; fi
else
	@if [ -f $(dir $<)banks.txt ]; then $(PYTHON) bank_split.py $@ $(dir $<)banks.txt; fi
endif

assemble: $(C_ASM)
	rgbasm $(DEFINES) -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.asm
ifeq ($(OS), 1)
	rgblink -l pages.link -m $(BUILD_DIR)/main.map -n $(SYM_FILE) -o $(ROM_FILE) $(BUILD_DIR)/main.o
	$(PYTHON) check_pages.py $(BUILD_DIR)/main.map
else
	rgblink -m $(BUILD_DIR)/main.map -n $(SYM_FILE) -o $(ROM_FILE) $(BUILD_DIR)/main.o
endif
ifeq ($(OS), 1)
	rgbfix -v -c -s -j -t GBXOS -i KRKZ -l 0x33 -m 0 -r 0 -p 255 $(ROM_FILE)
	cp $(ROM_FILE) $(BIN_DIR)/GBCOS.BIN
	$(PYTHON) data_file.py $(BIN_DIR)/EDITOR.DAT
else
	rgbfix -jvcs -k 01 -l 0x33 -m 0x1B -p 255 $(ROM_FILE)
endif

run:
ifeq ($(OS), Windows_NT)
	taskkill -im bgb.exe -f -fi "STATUS eq RUNNING"
	start "$(ROM_FILE)"
else
# 	open $(ROM_FILE)
# 	sameboy $(ROM_FILE)
	~/Projects/Gearboy/platforms/linux/gearboy $(ROM_FILE) $(SYM_FILE)
endif

assets:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BIN_DIR)

	$(PYTHON) build.py 
	$(PYTHON) fxhammer.py
	$(PYTHON) img2rgbds.py
	$(PYTHON) fonts.py
	$(PYTHON) keywords.py
	$(PYTHON) sgb_border.py img/default_sgb_border.png img/default_sgb_border.asm
	$(PYTHON) translate.py 

# EverDrive X SD test that runs in OS mode, copy to /GBCSYS/GBCOS.BIN on the card (keep the real one)
osdiag:
	@mkdir -p $(BUILD_DIR) $(BIN_DIR)
	rgbasm -o $(BUILD_DIR)/osdiag.o src/osdiag/osdiag.asm
	rgblink -t -n $(BIN_DIR)/GBCOS_DIAG.sym -o $(BIN_DIR)/GBCOS_DIAG.BIN $(BUILD_DIR)/osdiag.o
	$(PYTHON) -c "p='$(BIN_DIR)/GBCOS_DIAG.BIN'; d=bytearray(open(p,'rb').read()); d+=b'\xff'*(131072-len(d)); exec('for c in range(16): d[c*8192+0x1C00:c*8192+0x1C06]=b\'OSDG\'+bytes([c,255-c])'); open(p,'wb').write(d)"
	rgbfix -v -c -s -j -t GBXOS -i KRKZ -l 0x33 -m 0 -r 0 -p 0xFF $(BIN_DIR)/GBCOS_DIAG.BIN

# SD card image for Gearboy's EverDrive X emulation, 64MB MBR + FAT32 with the files in sd/
sdcard:
	@mkdir -p $(BIN_DIR)
	@rm -f $(SD_IMAGE)
	truncate -s 64M $(SD_IMAGE)
	echo 'start=2048, type=c' | /usr/sbin/sfdisk -q $(SD_IMAGE)
	/usr/sbin/mkfs.fat -F 32 --offset 2048 -n TEXTEDITOR $(SD_IMAGE) 64512 > /dev/null
	mcopy -i $(SD_IMAGE)@@1M $(SD_DIR)/* ::

clean:
	@rm -rf $(BUILD_DIR)
	@rm -f $(ROM_FILE) 
