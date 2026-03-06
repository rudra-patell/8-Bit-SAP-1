.PHONY: build run wave clean

# tools
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Folders
SRC_DIR = src
TB_DIR = tb
BUILD_DIR = build

TOP = pc_tb

# Gather files
SRC_FILES := $(wildcard $(SRC_DIR)/*.v)
TB_FILE := $(TB_DIR)/$(TOP).v

build:
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	$(IVERILOG) -g2012 -o $(BUILD_DIR)/$(TOP) $(TB_FILE) $(SRC_FILES)

run: build
	$(VVP) $(BUILD_DIR)/$(TOP)

wave: run
	@echo "Launching GTKWave via WSL..."
	wsl -d Arch gtkwave /mnt/c/Users/Kurama/Desktop/VLSI/8-bit-SAP1/$(TOP).vcd

clean:
	@if exist $(BUILD_DIR) rmdir /s /q $(BUILD_DIR)
	@if exist *.vcd del /q *.vcd