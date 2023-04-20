module RV32IM_ALU (
    input [31:0] op1,
    input [31:0] op2,
    input [2:0] funct3,
    input [6:0] funct7,
    input [1:0] opcode,
    output [31:0] result,
    output zero,
    output carry,
    output overflow
);

reg [31:0] result;
reg zero;
reg carry;
reg overflow;

always @(*) begin
    case(opcode)
        3'b000: begin // R-type instruction
            case(funct3)
                3'b000: result = op1 + op2; // ADD
                3'b001: result = op1 << (op2[4:0]); // SLL
                3'b010: result = (op1 < op2) ? 1 : 0; // SLT
                3'b011: result = (op1 < op2) ? 1 : 0; // SLTU
                3'b100: result = op1 ^ op2; // XOR
                3'b101: begin // SRL or SRA
                    if(funct7[5] == 1) // SRA
                        result = $signed(op1) >>> (op2[4:0]);
                    else // SRL
                        result = op1 >> (op2[4:0]);
                end
                3'b110: result = op1 | op2; // OR
                3'b111: result = op1 & op2; // AND
            endcase
            
            // set flags
            zero = (result == 0) ? 1 : 0;
            carry = 0; // not used in R-type instructions
            overflow = 0; // not used in R-type instructions
        end
        3'b001: begin // I-type instruction
            case(funct3)
                3'b000: result = op1 + op2; // ADDI
                3'b010: result = op1 < op2; // SLTI
                3'b011: result = op1 < op2; // SLTIU
                3'b100: result = op1 ^ op2; // XORI
                3'b110: result = op1 | op2; // ORI
                3'b111: result = op1 & op2; // ANDI
                default: result = op1; // default is to do nothing
            endcase
            
            // set flags
            zero = (result == 0) ? 1 : 0;
            carry = 0; // not used in I-type instructions
            overflow = 0; // not used in I-type instructions
        end
        3'b011: begin // U-type instruction (LUI)
            result = {op2[31:12], 12'h0}; // set top 20 bits to immediate value, bottom 12 bits to 0
            
            // set flags
            zero = (result == 0) ? 1 : 0;
            carry = 0; // not used in U-type instructions
            overflow = 0; // not used in U-type instructions
        end
        3'b110: begin // UJ-type instruction (JAL)
            result = op1 + 4; // PC + 4
            
            // set flags
            zero = 0; // not used in UJ-type
            // set flags
            zero = (result == 0) ? 1 : 0;
            carry = 0; // not used in S-type instructions
            overflow = 0; // not used in S-type instructions
        end
    endcase
end

endmodule