___
# RV32IM PIPELINE IMPLEMENTATION : GROUP-03
___

## About
This repository contains an implementation of a pipelined processor that supports the RV32IM instruction set architecture. The pipeline implementation is written in Verilog HDL and that supports hazard detection and forwarding to ensure correct and efficient execution of instructions.

The processor supports all RV32IM instructions, including R-type, I-type, U-type, and J-type instructions. The implementation also includes an ALU module that performs arithmetic and logical operations on operands according to the instruction being executed.

The repository includes a testbench module that enables users to verify the correct behavior of the processor using a set of test instructions. The testbench simulates the execution of these instructions and checks the results against expected values to ensure correct functionality of the processor.
* 
* This implementation is intended as a reference for those interested in learning about the RV32IM instruction set architecture and processor design using Verilog HDL.

## Part 1 (Planning)
* Describe the instructions
* Clearly identify instruction encoding formats
* Clearly identify opcodes 
* Draw a pipeline diagram with datapath and control
* Clearly identify hardware units
* Clearly identify signals


## Part 2 (Hardware Units)
* Integer ALU
* Register File
* Control Unit

## Part 3 (Integration)
Integrate your pipelined processor, which includes...
* Datapath
* Control
* Instruction/data memory and caching
* Assembler
* Test programs


## Please refer the instructions in below URL:
* https://projects.ce.pdn.ac.lk/docs/how-to-add-a-project
