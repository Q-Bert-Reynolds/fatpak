VERSION   = DEMO#DEMO AWAY HOME
LANGUAGE  = EN#EN ES
DEFINES   = -D _$(VERSION) -D LANG_$(LANGUAGE) 

GAME_NAME = BEISBOL_$(VERSION)
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

all: clean assets assemble run

$(C_SOURCES): 
	@mkdir -p $(BUILD_DIR)
	sdcc $@ -msm83 --asm=rgbds --opt-code-size --peep-file peephole.def $(DEFINES) --disable-warning 218 -S -o $(patsubst %.c, $(dir $@)_%.asm, $(notdir $@))

assemble: $(C_SOURCES)
	rgbasm $(DEFINES) -w -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.asm
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

	$(PYTHON) mod2gbt.py
	$(PYTHON) img2rgbds.py
	$(PYTHON) roledex.py
	$(PYTHON) moves.py
	$(PYTHON) items.py
	$(PYTHON) translate.py 

clean:
	@rm -rf $(BUILD_DIR)
	@rm -f $(ROM_FILE) 
