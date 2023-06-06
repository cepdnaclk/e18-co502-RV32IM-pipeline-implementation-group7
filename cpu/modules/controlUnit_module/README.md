# Control Unit Module

This module is a control unit implementation in Verilog. It decodes instructions and generates control signals for the different components of a processor. The module is designed to support the RV32IM instruction set architecture.

## Description

The Control Unit module is a key component of a processor implementation written in Verilog. Its purpose is to decode instructions and generate control signals necessary for coordinating the various components of the processor. This module is designed to support the RV32IM instruction set architecture.

### Inputs and Outputs

#### Inputs:

- `INSTRUCTION` (32 bits): The instruction being processed.
- `RESET`: A control signal used to reset the module.

#### Outputs:

- `OP1_SEL`, `OP2_SEL`, `REG_WRITE_EN`: Control signals used for operand selection and register write enable.
- `IMM_SEL[2:0]`: A 3-bit control bus signal used for immediate value selection.
- `BR_SEL[3:0]`: A 4-bit control bus signal used for branch control.
- `ALU_OP[4:0]`: A 5-bit control bus signal used for ALU operation selection.
- `MEM_WRITE[2:0]`: A 3-bit control bus signal used for memory write control.
- `MEM_READ[3:0]`: A 4-bit control bus signal used for memory read control.
- `REG_WRITE_SEL[1:0]`: A 2-bit control bus signal used for register write control.

### Functionality

The Control Unit module performs the following tasks:

1. Instruction Decoding: It extracts the opcode, funct3, and funct7 values from the input `INSTRUCTION` using bitwise operations. These values are used to identify the instruction type and its specific requirements.

2. Operand Selection: The module determines the appropriate operand selection signals based on the opcode value. The `OP1_SEL` signal is set to high for instructions like AUIPC, JAL, and all SB-Type instructions (e.g., BEQ, BNE, BLT, BGE, BLTU, BGEU). The `OP2_SEL` signal is set to high for instructions such as all I-type instructions, U-type instructions (AUIPC, LUI), and all S-type instructions.

3. Register Write Enable: The `REG_WRITE_EN` signal is generated to control the register file write operation. It is set to high for all instructions except S-type instructions and SB-Type instructions.

4. Immediate Selection: The module determines the appropriate immediate selection signals (`IMM_SEL[2:0]`) based on the opcode value. The immediate selection signals determine the type of immediate value used in the instruction (e.g., I-type, S-type, SB-type, U-type, UJ-type).

5. Branch Control: The module generates the branch control signals (`BR_SEL[3:0]`) for controlling branching operations. The `BR_SEL[3]` signal is set to high for instructions like JAL, JALR, and SB-type instructions. For JAL and JALR instructions, the `BR_SEL[2:0]` signal is set to 3'b010. For other instructions, the `BR_SEL[2:0]` signal takes the value of the funct3 field.

6. ALU Operation Selection: The module determines the appropriate ALU operation control signals (`ALU_OP[4:0]`) based on the opcode, funct3, and funct7 values. It maps specific combinations of opcode, funct3, and funct7 values to the corresponding ALU operation code. The control signals cover various arithmetic, logical, and bitwise operations.

7. Memory Write Control: The module generates the memory write control signals (`MEM_WRITE[2:0]`) based on the opcode and funct3 values.

## Usage

### Prerequisites

- [Icarus Verilog](http://iverilog.icarus.com/) (Verilog compiler and simulator)
- [GTKWave](http://gtkwave.sourceforge.net/) (Waveform viewer)

### Running the Simulation

1. Clone this repository to your local machine.

```shell
git clone git@github.com:cepdnaclk/e18-co502-RV32IM-pipeline-implementation-group7.git
```

2. Navigate to the repository directory.

```shell
cd e18-co502-RV32IM-pipeline-implementation-group7/cpu/modules/controlUnit_module
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

The control_unit_tb.v file contains a testbench for the control unit module. It includes test cases for various instructions. You can modify or add test cases as needed.
