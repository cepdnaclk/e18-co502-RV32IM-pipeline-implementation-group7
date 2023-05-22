module id_ex_pipeline_reg(
    input [4:0] in_alu_op, in_instruction,
    input [2:0] in_branch_jump,
    input [1:0] in_wb_sel, in_data1alusel, in_data2alusel, in_data1bjsel, in_data2bjsel,
    input [3:0] in_read_write,
    input [31:0] in_pc, in_data1, in_data2, in_immediate,
    input in_datamemsel, in_reg_write_en, clk, reset, busy_wait,
    output reg [4:0] out_alu_op, out_instruction,
    output reg [2:0] out_branch_jump,
    output reg [1:0] out_wb_sel, out_data1alusel, out_data2alusel, out_data1bjsel, out_data2bjsel,
    output reg [3:0] out_read_write,
    output reg [31:0] out_pc, out_data1, out_data2, out_immediate,
    output reg out_datamemsel, out_reg_write_en
);

    // RESET output registers on active reset
    always @(*) begin
        if (reset) begin
            #1; // Delay to allow reset signal to settle
            out_instruction = 5'dx; // Set out_instruction to 'x' value
            out_pc = 32'dx; // Set out_pc to 'x' value
            out_data1 = 32'dx; // Set out_data1 to 'x' value
            out_data2 = 32'dx; // Set out_data2 to 'x' value
            out_immediate = 32'dx; // Set out_immediate to 'x' value
            out_data1alusel = 2'dx; // Set out_data1alusel to 'x' value
            out_data2alusel = 2'dx; // Set out_data2alusel to 'x' value
            out_data1bjsel = 2'dx; // Set out_data1bjsel to 'x' value
            out_data2bjsel = 2'dx; // Set out_data2bjsel to 'x' value
            out_alu_op = 4'dx; // Set out_alu_op to 'x' value
            out_branch_jump = 3'dx; // Set out_branch_jump to 'x' value
            out_datamemsel = 1'dx; // Set out_datamemsel to 'x' value
            out_read_write = 4'dx; // Set out_read_write to 'x' value
            out_wb_sel = 2'dx; // Set out_wb_sel to 'x' value
            out_reg_write_en = 1'dx; // Set out_reg_write_en to 'x' value
        end
    end

    // Write input values to output registers on positive edge of clock signal
    always @(posedge clk) begin
        #0; // Delay to synchronize with other stages
        if (!busy_wait) begin
            out_instruction <= in_instruction;
            out_pc <= in_pc;
            out_data1 <= in_data1;
            out_data2 <= in_data2;
            out_immediate <= in_immediate;
            out_data1alusel <= in_data1alusel;
            out_data2alusel <= in_data2alusel;
            out_data1bjsel <= in_data1bjsel;
            out_data2bjsel <= in_data2bjsel;
            out_alu_op <= in_alu_op;
            out_branch_jump <= in_branch_jump;
            out_datamemsel <= in_datamemsel;
            out_read_write <= in_read_write;
            out_wb_sel <= in_wb_sel;
            out_reg_write_en <= in_reg_write_en;
        end
    end

endmodule


// module id_ex_pipeline_reg(
//     IN_INSTRUCTION, // INSTRUCTION [11:7]
//     IN_PC,
//     IN_DATA1, 
//     IN_DATA2, 
//     IN_IMMEDIATE,
//     IN_DATA1ALUSEL,
//     IN_DATA2ALUSEL,
//     IN_DATA1BJSEL,
//     IN_DATA2BJSEL,
//     IN_ALU_OP,
//     IN_BRANCH_JUMP,
//     IN_DATAMEMSEL,
//     IN_READ_WRITE,
//     IN_WB_SEL,
//     IN_REG_WRITE_EN,
//     OUT_INSTRUCTION,
//     OUT_PC,
//     OUT_DATA1,
//     OUT_DATA2,
//     OUT_IMMEDIATE, 
//     OUT_DATA1ALUSEL,
//     OUT_DATA2ALUSEL,
//     OUT_DATA1BJSEL,
//     OUT_DATA2BJSEL,
//     OUT_ALU_OP,
//     OUT_BRANCH_JUMP,
//     OUT_DATAMEMSEL,
//     OUT_READ_WRITE,
//     OUT_WB_SEL,
//     OUT_REG_WRITE_EN,
//     CLK, 
//     RESET,
//     BUSYWAIT);

//     //declare the ports
//     input [4:0] IN_ALU_OP, IN_INSTRUCTION;
//     input [2:0] IN_BRANCH_JUMP;
//     input [1:0] IN_WB_SEL, IN_DATA1ALUSEL, IN_DATA2ALUSEL, IN_DATA1BJSEL, IN_DATA2BJSEL;
//     input [3:0] IN_READ_WRITE;
    
//     input [31:0] IN_PC,
//             IN_DATA1,
//             IN_DATA2,
//             IN_IMMEDIATE;   
                
//     input IN_DATAMEMSEL,
//         IN_REG_WRITE_EN,
//         CLK, 
//         RESET, 
//         BUSYWAIT;

//     output reg [4:0] OUT_ALU_OP, OUT_INSTRUCTION;
//     output reg [2:0] OUT_BRANCH_JUMP;
//     output reg [1:0] OUT_WB_SEL, OUT_DATA1ALUSEL, OUT_DATA2ALUSEL, OUT_DATA1BJSEL, OUT_DATA2BJSEL;
//     output reg [3:0] OUT_READ_WRITE;
 
//     output reg [31:0] OUT_PC,
//                     OUT_DATA1,
//                     OUT_DATA2,
//                     OUT_IMMEDIATE; 

//     output reg OUT_DATAMEMSEL,
//             OUT_REG_WRITE_EN;

//     //RESETTING output registers
//     always @ (*) begin
//         if (RESET) begin
//             #1;
//             OUT_INSTRUCTION = 5'dx;
//             OUT_PC = 32'dx;
//             OUT_DATA1 = 32'dx;
//             OUT_DATA2 = 32'dx;
//             OUT_IMMEDIATE =  32'dx;
//             OUT_DATA1ALUSEL = 2'dx;
//             OUT_DATA2ALUSEL = 2'dx;
//             OUT_DATA1BJSEL = 2'dx;
//             OUT_DATA2BJSEL = 2'dx;
//             OUT_ALU_OP = 4'dx;
//             OUT_BRANCH_JUMP = 3'dx;
//             OUT_DATAMEMSEL  = 1'dx;
//             OUT_READ_WRITE = 4'dx;
//             OUT_WB_SEL = 2'dx;
//             OUT_REG_WRITE_EN = 1'dx;
//         end
//     end

//     //Writing the input values to the output registers, 
//     //when the RESET is low and when the CLOCK is at a positive edge and BUSYWAIT is low 
//     always @(posedge CLK)
//     begin
//         #0;
//         if (!BUSYWAIT) begin
//             OUT_INSTRUCTION <= IN_INSTRUCTION;
//             OUT_PC <= IN_PC;
//             OUT_DATA1 <= IN_DATA1;
//             OUT_DATA2 <= IN_DATA2;
//             OUT_IMMEDIATE <=  IN_IMMEDIATE;
//             OUT_DATA1ALUSEL <= IN_DATA1ALUSEL;
//             OUT_DATA2ALUSEL <= IN_DATA2ALUSEL;
//             OUT_DATA1BJSEL <= IN_DATA1BJSEL;
//             OUT_DATA2BJSEL <= IN_DATA2BJSEL;
//             OUT_ALU_OP <= IN_ALU_OP;
//             OUT_BRANCH_JUMP <= IN_BRANCH_JUMP;
//             OUT_DATAMEMSEL  <= IN_DATAMEMSEL;
//             OUT_READ_WRITE <= IN_READ_WRITE;
//             OUT_WB_SEL <= IN_WB_SEL;
//             OUT_REG_WRITE_EN <= IN_REG_WRITE_EN;
//         end
//     end

// endmodule