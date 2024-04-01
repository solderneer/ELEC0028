# Makefile for Verilog projects using Icarus Verilog

# Variables
OUT_DIR := out

# Compiler and flags
IVERILOG := iverilog
VVP := vvp
GTKWAVE := gtkwave
FLAGS := -g 2012

# Find all testbench files in the tb/ directory
TESTBENCHES := $(wildcard ./*_tb.sv)
# Target names are derived from testbench names
TARGETS := $(patsubst ./%.sv, $(OUT_DIR)/%.vvp, $(TESTBENCHES))
# VCD files corresponding to the targets
VCD_FILES := $(patsubst ./%.sv, $(OUT_DIR)/%.vcd, $(TESTBENCHES))

# Default target: compile and simulate all testbenches
all: $(TARGETS)

# Rule to compile and simulate a testbench
$(OUT_DIR)/%.vvp: ./%.sv
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) $(FLAGS) -o $(OUT_DIR)/$*.vvp $<
	$(VVP) $(OUT_DIR)/$*.vvp -lxt2

# Clean target to remove output files
clean:
	rm -rf $(OUT_DIR)/*

# Help target to display makefile usage
help:
	@echo "Usage:"
	@echo "  make             # Compile and simulate all testbenches"
	@echo "  make clean       # Remove all compiled and simulation outputs"
	@echo "  make help        # Display this help message"

.PHONY: all clean help sim

