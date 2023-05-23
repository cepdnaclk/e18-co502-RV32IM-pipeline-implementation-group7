module mem_wb_pipeline_reg(
    input [4:0] in_instruction, // INSTRUCTION [11:7]
    input [31:0] in_pc_4,
    input [31:0] in_alu_result,
    input [31:0] in_immediate,
    input [31:0] in_dmem_out,
    input [1:0] in_wb_sel,
    input in_reg_write_en,
    input clk,
    input reset,
    input busy_wait,
    output reg [4:0] out_instruction,
    output reg [31:0] out_pc_4,
    output reg [31:0] out_alu_result,
    output reg [31:0] out_immediate,
    output reg [31:0] out_dmem_out,
    output reg [1:0] out_wb_sel,
    output reg out_reg_write_en
);

    // RESET output registers on active reset
    always @(*) begin
        if (reset) begin
            #1; // Delay to allow reset signal to settle
            out_instruction = 5'dx; // Set out_instruction to 'x' value
            out_pc_4 = 32'dx; // Set out_pc_4 to 'x' value
            out_alu_result = 32'dx; // Set out_alu_result to 'x' value
            out_immediate = 32'dx; // Set out_immediate to 'x' value
            out_dmem_out = 32'dx; // Set out_dmem_out to 'x' value
            out_wb_sel = 2'dx; // Set out_wb_sel to 'x' value
            out_reg_write_en = 1'bx; // Set out_reg_write_en to 'x' value
        end
    end

    // Write input values to output registers on positive edge of clock signal
    always @(posedge clk) begin
        #0; // Delay to synchronize with other stages
        if (!reset && !busy_wait) begin
            out_instruction <= #1 in_instruction; // Write in_instruction to out_instruction
            out_pc_4 <= #1 in_pc_4; // Write in_pc_4 to out_pc_4
            out_alu_result <= #1 in_alu_result; // Write in_alu_result to out_alu_result
            out_immediate <= #1 in_immediate; // Write in_immediate to out_immediate
            out_dmem_out <= #1 in_dmem_out; // Write in_dmem_out to out_dmem_out
            out_wb_sel <= #1 in_wb_sel; // Write in_wb_sel to out_wb_sel
            out_reg_write_en <= #1 in_reg_write_en; // Write in_reg_write_en to out_reg_write_en
        end
    end
endmodule