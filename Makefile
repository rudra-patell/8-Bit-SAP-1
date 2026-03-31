.PHONY: build run wave run_all clean synth synth_hier schematic netlist stats

# ==========================
# Tools
# ==========================
WSL_RUN = wsl -d arch
IVERILOG = iverilog
VVP = vvp
YOSYS = $(WSL_RUN) yosys
NETSVG = $(WSL_RUN) netlistsvg

# ==========================
# Directories
# ==========================
SRC_DIR = src
TB_DIR = tb
SIM_DIR = sim
BUILD_DIR = build
OUT_DIR = output

# ==========================
# Config
# ==========================
TOP ?= cpu_tb
TOP_MODULE ?= CPU_top

SRC_FILES := $(wildcard $(SRC_DIR)/*.v)
TB_FILE := $(TB_DIR)/$(TOP).v

TB_FILES := $(wildcard $(TB_DIR)/*.v)
TB_NAMES := $(patsubst $(TB_DIR)/%.v,%,$(TB_FILES))

# ==========================
# 1. SIMULATION FLOW
# ==========================

build:
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	$(IVERILOG) -g2012 -o $(BUILD_DIR)/$(TOP) $(TB_FILE) $(SRC_FILES)

run: build
	@echo "Running single testbench: $(TOP)"
	$(VVP) $(BUILD_DIR)/$(TOP)
	@if not exist $(SIM_DIR) mkdir $(SIM_DIR)
	@if exist *.vcd ( \
		echo ------------------------------------------------------- & \
		echo WARNING: Moving .vcd files to $(SIM_DIR)/ & \
		echo ------------------------------------------------------- & \
		move /y *.vcd $(SIM_DIR)\ >nul \
	)

wave: run
	@echo "Launching GTKWave for $(TOP)..."
	@gtkwave $(SIM_DIR)/$(TOP).vcd

# ==========================
# Batch Simulation
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
		echo WARNING: Moving .vcd files to $(SIM_DIR)/ & \
		echo ------------------------------------------------------- & \
		move /y *.vcd $(SIM_DIR)\ >nul \
	)

# ==========================
# 2. YOSYS VISUALIZATION
# ==========================

# FLATTENED VIEW
synth:
	@if not exist $(OUT_DIR) mkdir $(OUT_DIR)
	@echo "Synthesizing Flattened $(TOP_MODULE)..."
	$(YOSYS) -p "read_verilog $(SRC_FILES); hierarchy -check -top $(TOP_MODULE); proc; opt; fsm; opt; flatten; show -format svg -prefix $(OUT_DIR)/flat_$(TOP_MODULE)"

# HIERARCHICAL VIEW
synth_hier:
	@if not exist $(OUT_DIR) mkdir $(OUT_DIR)
	@echo "Synthesizing Hierarchical $(TOP_MODULE)..."
	$(YOSYS) -p "read_verilog $(SRC_FILES); hierarchy -check -top $(TOP_MODULE); proc; opt; show -format svg -prefix $(OUT_DIR)/hier_$(TOP_MODULE) $(TOP_MODULE)"

# BEAUTIFUL SCHEMATIC
schematic:
	@if not exist $(OUT_DIR) mkdir $(OUT_DIR)
	@echo "Generating Professional Schematic for $(TOP_MODULE)..."
	$(YOSYS) -p "read_verilog $(SRC_FILES); synth -top $(TOP_MODULE); splitnets -ports; write_json $(OUT_DIR)/design.json"
	$(NETSVG) $(OUT_DIR)/design.json -o $(OUT_DIR)/$(TOP_MODULE)_schematic.svg

	@echo "Applying SAP-1 Green Theme..."

	@$(WSL_RUN) sed -i 's/<svg /<svg style="background-color:white" /' $(OUT_DIR)/$(TOP_MODULE)_schematic.svg
	@$(WSL_RUN) sed -i 's/stroke:#000/stroke:#008000/g' $(OUT_DIR)/$(TOP_MODULE)_schematic.svg
	@$(WSL_RUN) sed -i 's/stroke:#000000/stroke:#008000/g' $(OUT_DIR)/$(TOP_MODULE)_schematic.svg
	@$(WSL_RUN) sed -i 's/stroke="black"/stroke="#008000"/g' $(OUT_DIR)/$(TOP_MODULE)_schematic.svg
	@$(WSL_RUN) sed -i 's/stroke:black/stroke:#008000/g' $(OUT_DIR)/$(TOP_MODULE)_schematic.svg
	@$(WSL_RUN) sed -i 's/fill="#000"/fill="#008000"/g' $(OUT_DIR)/$(TOP_MODULE)_schematic.svg

# ==========================
# 3. REAL WORK
# ==========================

# GATE-LEVEL NETLIST
netlist:
	@if not exist $(OUT_DIR) mkdir $(OUT_DIR)
	@echo "Generating Gate-Level Verilog for $(TOP_MODULE)..."
	$(YOSYS) -p "read_verilog $(SRC_FILES); hierarchy -check -top $(TOP_MODULE); proc; opt; fsm; opt; techmap; opt; write_verilog -noattr $(OUT_DIR)/$(TOP_MODULE)_netlist.v"

# RESOURCE STATS
stats:
	@echo "Gate Count for $(TOP_MODULE):"
	$(YOSYS) -p "read_verilog $(SRC_FILES); hierarchy -check -top $(TOP_MODULE); proc; opt; fsm; opt; stat"

# ==========================
# CLEAN
# ==========================

clean:
	@if exist $(BUILD_DIR) rmdir /s /q $(BUILD_DIR)
	@if exist $(SIM_DIR) rmdir /s /q $(SIM_DIR)
	@if exist $(OUT_DIR) rmdir /s /q $(OUT_DIR)
	@if exist *.vcd del /q *.vcd