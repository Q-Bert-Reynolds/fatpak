LANGUAGE  = EN#EN ES FR IT PT DE JA
DEFINES   = -D LANG_$(LANGUAGE)

GAME_NAME = TEXT_EDITOR
ROM_NAME  = $(GAME_NAME).gbc
ROM_FILE  = $(BIN_DIR)/$(ROM_NAME)
SYM_FILE  = $(BIN_DIR)/$(GAME_NAME).sym

SRC_DIR   = src
DATA_DIR  = data
MUSIC_DIR = music
BIN_DIR   = bin
BUILD_DIR = build
SD_DIR    = sd
SD_IMAGE  = $(BIN_DIR)/sdcard.img

ifeq ($(OS), Windows_NT)
PYTHON	  = python
MOD2GBT   = $(BIN_DIR)/mod2gbt.exe
else
PYTHON	  = python3
MOD2GBT   = $(BIN_DIR)/mod2gbt
endif

C_SOURCES = $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/**/*.c) $(wildcard $(DATA_DIR)/**/*.c) 
C_HEADERS = $(wildcard $(SRC_DIR)/*.h) $(wildcard $(SRC_DIR)/**/*.h)
# included by C sources, not compiled on their own
C_LIBS    = $(wildcard $(SRC_DIR)/*/lib/*.c) $(wildcard $(SRC_DIR)/*/lib/*.h)
C_ASM     = $(join $(dir $(C_SOURCES)), $(patsubst %.c, _%.asm, $(notdir $(C_SOURCES))))

all: clean assets assemble run

code: assemble run

_%.asm: %.c $(C_HEADERS) $(C_LIBS)
	@mkdir -p $(BUILD_DIR)
	sdcc $< -msm83 --asm=rgbds --opt-code-size --dataseg WRAM0 --no-peep --peep-file peephole.def $(DEFINES) --disable-warning 218 -S -o $@
	@if [ -f $(dir $<)banks.txt ]; then $(PYTHON) bank_split.py $@ $(dir $<)banks.txt; fi

assemble: $(C_ASM)
	rgbasm $(DEFINES) -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.asm
	rgblink -m $(BUILD_DIR)/main.map -n $(SYM_FILE) -o $(ROM_FILE) $(BUILD_DIR)/main.o
	rgbfix -jvcs -k 01 -l 0x33 -m 0x1B -p 255 $(ROM_FILE)

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

ifeq ("$(wildcard $(MOD2GBT))","")
	gcc -o $(MOD2GBT) mod2gbt.c
endif

	$(PYTHON) build.py 
	$(PYTHON) mod2gbt.py
	$(PYTHON) fxhammer.py
	$(PYTHON) img2rgbds.py
	$(PYTHON) fonts.py
	$(PYTHON) sgb_border.py img/default_sgb_border.png img/default_sgb_border.asm
	$(PYTHON) translate.py 

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
