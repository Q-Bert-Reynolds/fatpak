DEFINES   =

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

.PHONY: test-cc test-sgb-ui sgb-kernel test-sgb-kernel test-sgb-client test-sgb-map test-overlays test-sgb-host test-geometry all code modules assemble run assets clean sgb-hello test-sgb-hello sgb-bench test-sgb-bench test-sgb-bench-timeout sgb-handoff test-sgb-handoff sgb-protocol test-sgb-protocol sgb-budget

all: clean assets assemble run

code: assemble run

sgb-kernel:
	$(PYTHON) scripts/sgb_kernel.py

test-sgb-kernel:
	bash tests/run_sgb_kernel.sh

test-sgb-ui:
	SGB_KERNEL_UI=1 bash tests/run_sgb_kernel.sh

test-sgb-client:
	bash tests/run_sgb_client.sh

test-sgb-map:
	bash tests/run_sgb_map.sh
	bash tests/run_sgb_map_kernel.sh

test-overlays:
	bash tests/run_overlays.sh

test-sgb-host:
	bash tests/run_sgb_host.sh

test-geometry:
	bash tests/run_geometry.sh

# the C compiler (modules/cc) on a PC; doesn't touch the OS build or the card
test-cc:
	$(PYTHON) tests/test_cc.py

# Phase 0a is a standalone ROM; it does not rebuild or install the OS.
sgb-hello:
	$(PYTHON) tests/sgb/build.py

test-sgb-hello: sgb-hello
	bash tests/sgb/run.sh hello

sgb-bench:
	$(PYTHON) tests/sgb/build.py bench

test-sgb-bench: sgb-bench
	bash tests/sgb/run.sh bench

test-sgb-bench-timeout: sgb-bench
	SGB_BENCH_TIMEOUT=ack SGB_TEST_SCRIPT="$(CURDIR)/tests/sgb/bench_timeout.lua" bash tests/sgb/run.sh bench
	SGB_BENCH_TIMEOUT=nack SGB_TEST_SCRIPT="$(CURDIR)/tests/sgb/bench_timeout.lua" bash tests/sgb/run.sh bench

sgb-handoff:
	$(PYTHON) tests/sgb/build.py handoff

test-sgb-handoff: sgb-handoff
	bash tests/sgb/run.sh handoff

sgb-protocol:
	$(PYTHON) scripts/sgb_protocol.py

test-sgb-protocol:
	$(PYTHON) scripts/sgb_protocol.py --check
	$(PYTHON) tests/test_sgb_protocol.py

sgb-budget:
	$(PYTHON) scripts/sgb_budget.py

# Module SDK/host headers: scripts/module_build.py rewrites them only when their content changes.
MODULE_HEADERS = $(BUILD_DIR)/modules/sdk.h $(BUILD_DIR)/modules/modules.h
MODULE_INPUTS  = scripts/module_build.py scripts/utils.py modules/abi.json modules/modules.json $(SRC_DIR)/constants.asm

$(MODULE_HEADERS): $(MODULE_INPUTS)
	$(PYTHON) scripts/module_build.py --headers

# The UI's strings: S_* ids for C and modules, bin/LANG/*.DAT (English also goes in EDITOR.DAT)
STRINGS_INPUTS = data/strings/strings.csv $(wildcard data/help/*.txt) scripts/strings.py scripts/ingame_menu.py $(SRC_DIR)/constants.asm $(SRC_DIR)/ui/icons.h
$(SRC_DIR)/strings.h: $(STRINGS_INPUTS)
	$(PYTHON) scripts/strings.py

$(BUILD_DIR)/c/%.asm: %.c $(C_HEADERS) $(SRC_DIR)/strings.h $(C_LIBS) $(MODULE_HEADERS) $(wildcard modules/*.h modules/*/*.h)
	@mkdir -p $(dir $@)
	sdcc $< -msm83 --asm=rgbds --opt-code-size --dataseg WRAM0 --no-peep --peep-file peephole.def $(DEFINES) --disable-warning 218 -S -o $@
	@sed -i 's/^\t\.byte /\tDB /' $@ # SDCC writes long constants as .byte

$(SRC_DIR)/constants.h: $(SRC_DIR)/constants.asm scripts/build.py
	$(PYTHON) scripts/build.py

modules: $(SRC_DIR)/constants.h $(SRC_DIR)/strings.h $(MODULE_HEADERS)
	$(PYTHON) scripts/strings.py
	$(PYTHON) scripts/module_build.py

assemble: sgb-protocol modules $(C_RAW)
	@mkdir -p $(BUILD_DIR) $(BIN_DIR)
	$(PYTHON) scripts/bank_split.py --build-dir $(BUILD_DIR) $(C_SOURCES)
	$(PYTHON) scripts/ingame_menu.py
	rgbasm $(DEFINES) -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.asm
	rgblink -l pages.link -m $(BUILD_DIR)/main.map -n $(SYM_FILE) -o $(ROM_FILE) $(BUILD_DIR)/main.o
	$(PYTHON) scripts/check_pages.py $(BUILD_DIR)/main.map
	$(PYTHON) scripts/check_module_abi.py $(SYM_FILE) $(C_SOURCES)
	rgbfix -v -c -s -j -t GBXOS -i KRKZ -l 0x33 -m 0 -r 0 -p 255 $(ROM_FILE)
ifneq ($(ROM_FILE),$(BIN_DIR)/GBCOS.BIN)
	cp $(ROM_FILE) $(BIN_DIR)/GBCOS.BIN
endif
	$(PYTHON) scripts/keyboard_drivers.py
	$(PYTHON) scripts/data_file.py $(BIN_DIR)/EDITOR.DAT
	cp data/mapview.inc $(BIN_DIR)/MAPVIEW.INC
	$(PYTHON) scripts/sgb_kernel.py
	$(PYTHON) scripts/sgb_data.py --snes $(BUILD_DIR)/sgb/program.bin --fonts $(BUILD_DIR)/sgb/fonts.bin --ext $(BUILD_DIR)/sgb/ext.bin
	@if mountpoint -q "$(SD_MOUNT)"; then \
		cp $(BIN_DIR)/GBCOS.BIN "$(SD_MOUNT)/GBCSYS/GBCOS.BIN" && \
		cp $(BIN_DIR)/EDITOR.DAT "$(SD_MOUNT)/GBCSYS/EDITOR.DAT" && \
		cp $(BIN_DIR)/SGB.DAT "$(SD_MOUNT)/GBCSYS/SGB.DAT" && \
		cp $(BIN_DIR)/MAPVIEW.INC "$(SD_MOUNT)/GBCSYS/MAPVIEW.INC" && \
		mkdir -p "$(SD_MOUNT)/GBCSYS/MODULES" "$(SD_MOUNT)/GBCSYS/LANG" "$(SD_MOUNT)/GBCSYS/DRIVERS" && \
		cp $(BIN_DIR)/MODULES/*.MOD "$(SD_MOUNT)/GBCSYS/MODULES/" && \
		cp $(BIN_DIR)/DRIVERS/*.DRV "$(SD_MOUNT)/GBCSYS/DRIVERS/" && \
		cp $(BIN_DIR)/LANG/*.DAT "$(SD_MOUNT)/GBCSYS/LANG/" && \
		sync -f "$(SD_MOUNT)/GBCSYS/GBCOS.BIN" && \
		sync -f "$(SD_MOUNT)/GBCSYS/EDITOR.DAT" && \
		sync -f "$(SD_MOUNT)/GBCSYS/SGB.DAT" && \
		echo "Copied GBCOS.BIN, EDITOR.DAT, SGB.DAT, MAPVIEW.INC, modules, drivers, and languages to mounted GAMEBOY card"; \
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

	$(PYTHON) scripts/build.py 
	$(PYTHON) scripts/sgb_protocol.py
	$(PYTHON) scripts/img2rgbds.py
	$(PYTHON) scripts/fonts.py
	$(PYTHON) scripts/keywords.py
	$(PYTHON) scripts/sgb_border.py

clean:
	@rm -rf $(BUILD_DIR)
	@rm -f $(ROM_FILE) 
