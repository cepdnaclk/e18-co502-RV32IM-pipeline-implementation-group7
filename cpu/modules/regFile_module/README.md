___
# Register File Module
___

This module is a register file implementation in Verilog. It provides an 32x32-bit register file that supports read and write operations for RV32IM instruction set architecture.

## Description

The Register file consists of a register array and control logic to enable read and write operations. It has the following features:

- 32 registers, each capable of storing a 32-bit value.
- Separate read and write ports.
- Read operations using 5-bit register addresses.
- Write operations with a 5-bit register address and a 32-bit data input.
- Supports asynchronous read operarion and positive clock edge triggered write and reset operation.

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
cd e18-co502-RV32IM-pipeline-implementation-group7/cpu/modules/regFile_module
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
