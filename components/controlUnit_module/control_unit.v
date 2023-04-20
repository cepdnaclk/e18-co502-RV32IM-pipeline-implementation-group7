module control_unit(INSTRUCTION, OP1_SEL, OP2_SEL, REG_WRITE_EN, IMM_SEL, BR_SEL, ALU_SEL, MEM_WRITE, MEM_READ, REG_WRITE_SEL);
	// Begin port declaration
	// Inputs	
	input [31:0] INSTRUCTION;
	input RESET; // Wires

	// Outputs
    output OP1_SEL, OP2_SEL, REG_WRITE_EN;
	output [2:0] IMM_SEL;
    output [2:0] BR_SEL;
    output [4:0] ALU_SEL;
    output [1:0] MEM_WRITE;
    output [1:0] MEM_READ;
    output [1:0] REG_WRITE_SEL;

	// End port declaration

    // decoded instructions to opcode and function codes
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = INSTRUCTION[6:0];
    assign funct3 = INSTRUCTION[14:12];
    assign funct7 = INSTRUCTION[31:25];

endmodule