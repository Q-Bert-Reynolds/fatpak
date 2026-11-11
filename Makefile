LANGUAGE  = EN#EN ES FR IT PT DE JA
DEFINES   = -D LANG_$(LANGUAGE)

GAME_NAME = GBCOS
ROM_NAME  = $(GAME_NAME).BIN
ROM_FILE  = $(BIN_DIR)/$(ROM_NAME)
SYM_FILE  = $(BIN_DIR)/$(GAME_NAME).sym

SRC_DIR   = src
DATA_DIR  = data
BIN_DIR   = bin
BUILD_DIR = build
SD_MOUNT ?= /media/qbertreynolds/GAMEBOY

ifeq ($(OS), Windows_NT)
PYTHON	  = python
else
PYTHON	  = python3
endif

C_SOURCES = $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/**/*.c) $(wildcard $(DATA_DIR)/**/*.c)
C_HEADERS = $(wildcard $(SRC_DIR)/*.h) $(wildcard $(SRC_DIR)/**/*.h)
# included by C sources, not compiled on their own
C_LIBS    = $(wildcard $(SRC_DIR)/*/lib/*.c) $(wildcard $(SRC_DIR)/*/lib/*.h)
# Preserve raw output: page placement and cross-module call resolution run together.
C_RAW     = $(patsubst %.c,$(BUILD_DIR)/c/%.asm,$(C_SOURCES))

.PHONY: all code modules assemble run assets clean

all: clean assets assemble run

code: assemble run

# Module SDK/host headers: module_build.py rewrites them only when their content changes.
MODULE_HEADERS = $(BUILD_DIR)/modules/sdk.h $(BUILD_DIR)/modules/modules.h
MODULE_INPUTS  = module_build.py utils.py modules/abi.json modules/modules.json $(SRC_DIR)/constants.asm

$(MODULE_HEADERS): $(MODULE_INPUTS)
	$(PYTHON) module_build.py --headers

$(BUILD_DIR)/c/%.asm: %.c $(C_HEADERS) $(C_LIBS) $(MODULE_HEADERS) $(wildcard modules/*.h)
	@mkdir -p $(dir $@)
	sdcc $< -msm83 --asm=rgbds --opt-code-size --dataseg WRAM0 --no-peep --peep-file peephole.def $(DEFINES) --disable-warning 218 -S -o $@
	@sed -i 's/^\t\.byte /\tDB /' $@ # SDCC writes long constants as .byte

$(SRC_DIR)/constants.h: $(SRC_DIR)/constants.asm build.py
	$(PYTHON) build.py

modules: $(SRC_DIR)/constants.h $(MODULE_HEADERS)
	$(PYTHON) module_build.py

assemble: modules $(C_RAW)
	@mkdir -p $(BUILD_DIR) $(BIN_DIR)
	$(PYTHON) bank_split.py --build-dir $(BUILD_DIR) $(C_SOURCES)
	$(PYTHON) ingame_menu.py
	rgbasm $(DEFINES) -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.asm
	rgblink -l pages.link -m $(BUILD_DIR)/main.map -n $(SYM_FILE) -o $(ROM_FILE) $(BUILD_DIR)/main.o
	$(PYTHON) check_pages.py $(BUILD_DIR)/main.map
	$(PYTHON) check_module_abi.py $(SYM_FILE) $(C_SOURCES)
	rgbfix -v -c -s -j -t GBXOS -i KRKZ -l 0x33 -m 0 -r 0 -p 255 $(ROM_FILE)
ifneq ($(ROM_FILE),$(BIN_DIR)/GBCOS.BIN)
	cp $(ROM_FILE) $(BIN_DIR)/GBCOS.BIN
endif
	$(PYTHON) data_file.py $(BIN_DIR)/EDITOR.DAT
	@if mountpoint -q "$(SD_MOUNT)"; then \
		cp $(BIN_DIR)/GBCOS.BIN "$(SD_MOUNT)/GBCSYS/GBCOS.BIN" && \
		cp $(BIN_DIR)/EDITOR.DAT "$(SD_MOUNT)/GBCSYS/EDITOR.DAT" && \
		mkdir -p "$(SD_MOUNT)/GBCSYS/MODULES" && \
		cp $(BIN_DIR)/MODULES/*.MOD "$(SD_MOUNT)/GBCSYS/MODULES/" && \
		sync -f "$(SD_MOUNT)/GBCSYS/GBCOS.BIN" && \
		sync -f "$(SD_MOUNT)/GBCSYS/EDITOR.DAT" && \
		echo "Copied GBCOS.BIN, EDITOR.DAT and modules to mounted GAMEBOY card"; \
	fi

run:
ifeq ($(OS), Windows_NT)
	taskkill -im bgb.exe -f -fi "STATUS eq RUNNING"
	start "$(ROM_FILE)"
else
# 	open $(ROM_FILE)
# 	sameboy $(ROM_FILE)
	gearboy $(ROM_FILE) $(SYM_FILE)
endif

assets:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BIN_DIR)

	$(PYTHON) build.py 
	$(PYTHON) img2rgbds.py
	$(PYTHON) fonts.py
	$(PYTHON) keywords.py
	$(PYTHON) sgb_border.py
	$(PYTHON) translate.py 

clean:
	@rm -rf $(BUILD_DIR)
	@rm -f $(ROM_FILE) 
