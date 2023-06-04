# ALU Module

This repository contains an Arithmetic Logic Unit (ALU) module implemented in Verilog. The ALU supports the RV32IM instruction set architecture.

## Description

The ALU module performs various arithmetic and logic operations based on the control signals provided. It supports the following instructions:

- ADD
- SUB
- SLL
- SLT
- SLTU
- XOR
- SRL
- SRA
- OR
- AND
- MUL
- MULH
- MULHU
- MULHSU
- DIV
- DIVU
- REM
- REMU

The module takes two 32-bit data inputs (DATA1 and DATA2) and a 5-bit control signal (SELECT). The result of the operation is stored in the 32-bit output (RESULT).

## Usage

### Prerequisites

- [Icarus Verilog](http://iverilog.icarus.com/) (Verilog compiler and simulator)
- [GTKWave](http://gtkwave.sourceforge.net/) (Waveform viewer)

### Running the Simulation

1. Clone this repository to your local machine.

```shell
git clone <repository_url>
```

2. Navigate to the repository directory.

```shell
git cd <module_directory>
```

3. Open the Makefile and modify the VERILOG_COMPILER, SIMULATOR, and WAVEFORM_VIEWER variables if necessary.
4. Compile the Verilog files and generate the executable.

```shell
make compile
```

5. Run the simulation.

```shell
git run
```

The simulation will execute and display the test results in the terminal.

###Viewing the Waveform
To view the waveform generated during the simulation:

1. Make sure you have GTKWave installed on your system.

2. Open the configured waveform file simulation.gtkw.

```shell
make wave
```

GTKWave will open with the waveform displayed.

###Testbench
The alu_tb.v file contains a testbench for the ALU module. It includes test cases for various instructions. You can modify or add test cases as needed.

Make sure to replace `<repository_url>` and `<module_directory>` with the actual URL and directory of your GitHub repository.

default
`<repository_url>` `git@github.com:cepdnaclk/e18-co502-RV32IM-pipeline-implementation-group7.git`
`<module_directory>` `cd e18-co502-RV32IM-pipeline-implementation-group7/cpu/modules/alu_module`
