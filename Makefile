.PHONY: build run wave run_all clean

# Tools
IVERILOG = iverilog
VVP = vvp

# Directories
SRC_DIR = src
TB_DIR = tb
SIM_DIR = sim
BUILD_DIR = build

# --- SINGLE RUN CONFIG ---
TOP ?= cpu_tb
SRC_FILES := $(wildcard $(SRC_DIR)/*.v)
TB_FILE := $(TB_DIR)/$(TOP).v

# --- BATCH RUN CONFIG ---
TB_FILES := $(wildcard $(TB_DIR)/*.v)
TB_NAMES := $(patsubst $(TB_DIR)/%.v,%,$(TB_FILES))

# ==========================
# TARGET 1: Single Module Run
# ==========================
build:
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	$(IVERILOG) -g2012 -o $(BUILD_DIR)/$(TOP) $(TB_FILE) $(SRC_FILES)

run: build
	@echo "Running single testbench: $(TOP)"
	$(VVP) $(BUILD_DIR)/$(TOP)
	@if exist *.vcd ( \
		echo ------------------------------------------------------- & \
		echo [33mWARNING[0m: Batch .vcd files found in root! & \
		echo Moving all files to $(SIM_DIR)/ for a clean workspace. & \
		echo ------------------------------------------------------- & \
		move /y *.vcd $(SIM_DIR)\ >nul \
	)
wave: run
	@echo "Launching GTKWave for $(TOP)..."
	@wsl -d Arch gtkwave /mnt/c/Users/Kurama/Desktop/VLSI/8-bit-SAP1/$(SIM_DIR)/$(TOP).vcd

# ==========================
# TARGET 2: Batch All Modules
# ==========================
# ==========================
# TARGET 2: Batch All Modules
# ==========================
run_all:
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	@if not exist $(SIM_DIR) mkdir $(SIM_DIR)
	@$(foreach tb,$(TB_NAMES), \
		echo Simulating $(tb)... && \
		$(IVERILOG) -g2012 -o $(BUILD_DIR)/$(tb) $(TB_DIR)/$(tb).v $(SRC_FILES) && \
		$(VVP) $(BUILD_DIR)/$(tb) || exit /b 1; \
	)
	@if exist *.vcd ( \
		echo ------------------------------------------------------- & \
		echo [33mWARNING[0m: Batch .vcd files found in root! & \
		echo Moving all files to $(SIM_DIR)/ for a clean workspace. & \
		echo ------------------------------------------------------- & \
		move /y *.vcd $(SIM_DIR)\ >nul \
	)
# ==========================
# Utilities
# ==========================
clean:
	@if exist $(BUILD_DIR) rmdir /s /q $(BUILD_DIR)
	@if exist $(SIM_DIR) rmdir /s /q $(SIM_DIR)
	@if exist *.vcd del /q *.vcd