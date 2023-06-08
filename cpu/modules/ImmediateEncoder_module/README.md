---
# Immediate Encoder Module
---

The Immediate Encoder module is designed for a RV32IM processor architecture. Its purpose is to perform immediate selection and sign extension for different instruction formats.

## Description

The module takes an input instruction (INSTRUCTION) and an immediate selection signal (IMM_SEL), and produces the corresponding immediate value with appropriate sign extension (IMMEDIATE).

he module supports five different encoding types based on the IMM_SEL input, which correspond to different instruction formats in the RV32IM architecture:

1. I_type: This encoding type is used for immediate instructions. The module extracts the immediate value from bits 30 to 20 of the instruction and sign extends it using the most significant bit (MSB) of the immediate.

2. S_type: This encoding type is used for store instructions. The module combines bits 30 to 25 and bits 11 to 7 of the instruction to form the immediate value, and then sign extends it using the MSB.

3. B_type: This encoding type is used for branch instructions. The module constructs the immediate value by concatenating the bits 7, 30 to 25, bits 11 to 8, and a zero bit, and performs sign extension using the MSB.

4. U_type: This encoding type is used for upper immediate instructions. The module extracts bits 31 to 12 of the instruction and appends twelve zero bits to form the immediate value.

5. J_type: This encoding type is used for jump instructions. The module combines the bits 19 to 12, bit 20, bits 30 to 21, and a zero bit to form the immediate value, and performs sign extension using the MSB.

The Immediate Encoder module utilizes a combinational logic block (always @(\*)) to perform the immediate selection and sign extension based on the selected encoding type. It uses a case statement to handle the different encoding types and assigns the appropriate values to the IMMEDIATE output.

By using this module, the RV32IM processor can efficiently decode and extend immediate values for various instruction formats, enabling proper execution of instructions within the architecture.

## Usage

### Prerequisites

- [Icarus Verilog](http://iverilog.icarus.com/) (Verilog compiler and simulator)
- [GTKWave](http://gtkwave.sourceforge.net/) (Waveform viewer)

### Running the Simulation

1. Clone this repository to your local machine.

```shell
git clone git@github.com:cepdnaclk/e18-co502-RV32IM-pipeline-implementation-group7.git
```

2. Navigate to the module directory.

```shell
cd e18-co502-RV32IM-pipeline-implementation-group7/cpu/modules/ImmediateEncoder_module
```

3. Open the Makefile and modify the VERILOG_COMPILER, SIMULATOR, and WAVEFORM_VIEWER variables if necessary.
4. Compile the Verilog files and generate the executable.

```shell
make compile
```

5. Run the simulation.

```shell
make run
```

The simulation will execute and display the test results in the terminal.

### Viewing the Waveform

To view the waveform generated during the simulation:

1. Make sure you have GTKWave installed on your system.

2. Open the configured waveform file simulation.gtkw.

```shell
make wave
```

GTKWave will open with the configured waveform displayed.

### Testbench

The reg_file_tb.v file contains a testbench for the reg_file module. It includes test cases for various instructions. You can modify or add test cases as needed.
