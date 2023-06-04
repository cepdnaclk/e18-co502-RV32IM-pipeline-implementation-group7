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
