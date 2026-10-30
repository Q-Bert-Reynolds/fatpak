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

ifeq ($(OS), Windows_NT)
PYTHON	  = python
MOD2GBT   = $(BIN_DIR)/mod2gbt.exe
else
PYTHON	  = python3
MOD2GBT   = $(BIN_DIR)/mod2gbt
endif

C_SOURCES = $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/**/*.c) $(wildcard $(DATA_DIR)/**/*.c) 
C_HEADERS = $(wildcard $(SRC_DIR)/*.h) $(wildcard $(SRC_DIR)/**/*.h)
C_ASM     = $(join $(dir $(C_SOURCES)), $(patsubst %.c, _%.asm, $(notdir $(C_SOURCES))))

all: clean assets assemble run

code: assemble run

_%.asm: %.c $(C_HEADERS)
	@mkdir -p $(BUILD_DIR)
	sdcc $< -msm83 --asm=rgbds --opt-code-size --no-peep --peep-file peephole.def $(DEFINES) --disable-warning 218 -S -o $@

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
	$(PYTHON) sgb_border.py img/default_sgb_border.png img/default_sgb_border.asm
	$(PYTHON) translate.py 
	$(PYTHON) maps.py

clean:
	@rm -rf $(BUILD_DIR)
	@rm -f $(ROM_FILE) 
