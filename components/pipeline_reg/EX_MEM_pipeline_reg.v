module ex_mem_pipeline_reg(
    input [4:0] in_instruction, // INSTRUCTION [11:7]
    input [31:0] in_pc,
    input [31:0] in_alu_result,
    input [31:0] in_data2,
    input [31:0] in_immediate,
    input in_datamemsel,
    input [3:0] in_read_write,
    input [1:0] in_wb_sel,
    input in_reg_write_en,
    input clk,
    input reset,
    input busy_wait,
    output reg [4:0] out_instruction,
    output reg [31:0] out_pc,
    output reg [31:0] out_alu_result,
    output reg [31:0] out_data2,
    output reg [31:0] out_immediate,
    output reg out_datamemsel,
    output reg [3:0] out_read_write,
    output reg [1:0] out_wb_sel,
    output reg out_reg_write_en
);

    // RESET output registers on active reset
    always @(*) begin
        if (reset) begin
            #1; // Delay to allow reset signal to settle
            out_instruction = 5'dx; // Set out_instruction to 'x' value
            out_pc = 32'dx; // Set out_pc to 'x' value
            out_alu_result = 32'dx; // Set out_alu_result to 'x' value
            out_data2 = 32'dx; // Set out_data2 to 'x' value
            out_immediate = 32'dx; // Set out_immediate to 'x' value
            out_datamemsel = 1'bx; // Set out_datamemsel to 'x' value
            out_read_write = 4'dx; // Set out_read_write to 'x' value
            out_wb_sel = 2'bx; // Set out_wb_sel to 'x' value
            out_reg_write_en = 1'bx; // Set out_reg_write_en to 'x' value
        end
    end

    // Write input values to output registers on positive edge of clock signal
    always @(posedge clk) begin
        #0; // Delay to synchronize with other stages
        if (!busy_wait && !reset) begin
            out_instruction <= #1 in_instruction; // Write in_instruction to out_instruction
            out_pc <= #1 in_pc; // Write in_pc to out_pc
            out_alu_result <= #1 in_alu_result; // Write in_alu_result to out_alu_result
            out_data2 <= #1 in_data2; // Write in_data2 to out_data2
            out_immediate <= #1 in_immediate; // Write in_immediate to out_immediate
            out_datamemsel <= #1 in_datamemsel; // Write in_datamemsel to out_datamemsel
            out_read_write <= #1 in_read_write; // Write in_read_write to out_read_write
            out_wb_sel <= #1 in_wb_sel; // Write in_wb_sel to out_wb_sel
            out_reg_write_en <= #1 in_reg_write_en; // Write in_reg_write_en to out_reg_write_en
        end
    end

endmodule