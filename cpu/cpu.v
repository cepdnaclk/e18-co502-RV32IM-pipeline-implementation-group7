`include "modules/alu_module/alu.v"

`include "modules/controlUnit_module/control_unit.v"

`include "modules/dataMemory_module/data_memory.v"
`include "modules/dataMemory_module/dcache.v"

`include "modules/hazardHandling_module/alu_hazard_unit.v"
`include "modules/hazardHandling_module/branch_hazard_unit.v"
`include "modules/hazardHandling_module/load_hazard_unit.v"

`include "modules/ImmediateEncoder_module/Immediate_encoder.v"

`include "modules/instructionMemory_module/icache.v"
`include "modules/instructionMemory_module/instr_memory.v"

`include "modules/pipeLine_registers/EX_MEM_pipeline_reg.v"
`include "modules/pipeLine_registers/ID_EX_pipeline_reg.v"
`include "modules/pipeLine_registers/IF_ID_pipeline_reg.v"
`include "modules/pipeLine_registers/MEM_WB_pipeline_reg.v"

`include "modules/regFile_module/reg_file.v"


module CPU(
    input [31:0] INSTRUCTION,
    input CLK,
    input RESET,
    input INS_CACHE_BUSY_WAIT,
    input [31:0] DATA_CACHE_READ_DATA,
    input DATA_CACHE_BUSY_WAIT,
    output reg[31:0] PC,
    output [3:0] memReadEn,
    output [2:0] memWriteEn,
    output [31:0] DATA_CACHE_ADDR,
    output [31:0] DATA_CACHE_DATA,
    output reg insReadEn);
endmodule



