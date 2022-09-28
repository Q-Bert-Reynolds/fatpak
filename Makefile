VERSION   = DEMO#DEMO AWAY HOME
LANGUAGE  = ES#EN ES
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

C_SOURCES = $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/**/*.c) $(wildcard $(DATA_DIR)/**/*.c) 

all: $(C_SOURCES)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BIN_DIR)
	
	rgbasm $(DEFINES) -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.asm
	rgblink -m $(BUILD_DIR)/main.map -n $(SYM_FILE) -o $(ROM_FILE) $(BUILD_DIR)/main.o
	rgbfix -jvcs -k 01 -l 0x33 -m 0x1B -p 255 -t $(GAME_NAME) $(ROM_FILE)

ifeq ($(OS), Windows_NT)
	taskkill -im bgb.exe -f -fi "STATUS eq RUNNING"
	start "$(ROM_FILE)"
else
	open $(ROM_FILE)
endif

$(C_SOURCES): 
	@mkdir -p $(BUILD_DIR)
	sdcc $@ -msm83 --asm=rgbds $(DEFINES) -S -o $(patsubst %.c, $(dir $@)_%.asm, $(notdir $@))

clean:
	@rm -rf $(BUILD_DIR)
