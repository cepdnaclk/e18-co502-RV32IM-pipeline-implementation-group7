/*
    Immediate selection and sign extend Unit for RV32IM processor
*/
module Immediate_encoder (
    input [31:0] INSTRUCTION,
    input [2:0] IMM_SEL,

    output reg [31:0] IMMEDIATE
);

    always @(*) begin
        #3;
        case (IMM_SEL)
            3'b000: IMMEDIATE = {{21{INSTRUCTION[31]}}, INSTRUCTION[30:20]}; // I_type
            3'b001: IMMEDIATE = {{21{INSTRUCTION[31]}}, {INSTRUCTION[30:25], INSTRUCTION[11:7]}}; // S_type
            3'b010: IMMEDIATE = {{20{INSTRUCTION[31]}}, INSTRUCTION[7], INSTRUCTION[30:25], INSTRUCTION[11:8], {1'b0}}; // B_type
            3'b011: IMMEDIATE = {INSTRUCTION[31:12], {12{1'b0}}}; // U_type
            3'b100: IMMEDIATE = {{12{INSTRUCTION[31]}}, INSTRUCTION[19:12], INSTRUCTION[20], INSTRUCTION[30:21], {1'b0}}; // J_type
        endcase
    end

endmodule
