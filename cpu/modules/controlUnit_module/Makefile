# Makefile for compiling and running control_unit_tb.v

# Verilog compiler and simulator (modify these according to your setup)
VERILOG_COMPILER = iverilog
SIMULATOR = vvp
WAVEFORM_VIEWER = gtkwave

# Target file
TARGET = control_unit_tb

# Verilog source files
VERILOG_FILES = $(TARGET).v

.PHONY: all clean run wave

all: run

compile: $(VERILOG_FILES)
	$(VERILOG_COMPILER) -o $(TARGET).vvp $(VERILOG_FILES)

run: compile
	$(SIMULATOR) $(TARGET).vvp

wave: simulation.vcd
	$(WAVEFORM_VIEWER) simulation.gtkw

clean:
	rm -f *.vvp *.vcd *.v.out

