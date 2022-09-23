VERSION   = DEMO#DEMO AWAY HOME
LANGUAGE  = en#es
GAME_NAME = BEISBOL_$(VERSION)
ROM_NAME  = $(GAME_NAME).gbc
ROM_FILE  = $(BIN_DIR)/$(ROM_NAME)
SYM_FILE  = $(BIN_DIR)/$(GAME_NAME).sym

SRC_DIR   = ./src
DATA_DIR  = ./data
MUSIC_DIR = ./music
BIN_DIR   = ./bin
BUILD_DIR = ./build

C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
GEN_ASM   = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.asm,$(C_SOURCES))

all: $(GEN_ASM)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BIN_DIR)
	
	rgbasm -D _$(VERSION) -D LANGUAGE=\"$(LANGUAGE)\" -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.asm
	rgblink -m $(BUILD_DIR)/main.map -n $(SYM_FILE) -o $(ROM_FILE) $(BUILD_DIR)/main.o
	rgbfix -jvcs -k 01 -l 0x33 -m 0x1B -p 255 -t $(GAME_NAME) $(ROM_FILE)

ifeq ($(OS), Windows_NT)
	taskkill -im bgb.exe -f -fi "STATUS eq RUNNING"
	start "$(ROM_FILE)"
else
	open $(ROM_FILE)
endif

$(GEN_ASM): $(C_SOURCES)
	@mkdir -p $(BUILD_DIR)
	sdcc "$<" -msm83 --asm=rgbds -S -o "$@"

clean:
	@rm -rf $(BUILD_DIR)
