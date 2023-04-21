module control_unit(INSTRUCTION, OP1_SEL, OP2_SEL, REG_WRITE_EN, IMM_SEL, BR_SEL, ALU_OP, MEM_WRITE, MEM_READ, REG_WRITE_SEL);
	// Begin port declaration
	// Inputs	
	input [31:0] INSTRUCTION;
	input RESET; // Wires

	// Outputs
    output OP1_SEL, OP2_SEL, REG_WRITE_EN;
	output [3:0] IMM_SEL;
    output [3:0] BR_SEL;
    output [4:0] ALU_OP;
    output [2:0] MEM_WRITE;
    output [3:0] MEM_READ;
    output [1:0] REG_WRITE_SEL;

	// End port declaration

    wire func3_SEl;

    // decoded instructions to opcode and function codes
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = INSTRUCTION[6:0];
    assign funct3 = INSTRUCTION[14:12];
    assign funct7 = INSTRUCTION[31:25];


    /* 
        set operand 1 singnal.
        Need to high operand 1 singnal in,
                AUIPC
                JAL
                JALR

                    instructions
    */
    assign OP1_SEL = (opcode == 7'b0010111) | (opcode == 7'b1101111) | (opcode == 7'b1100111) | (opcode == 7'b1100011);


    /* 
        set operand 2 singnal.
        Need to high operand 1 singnal in,
                All I-type (LB. LH, LW, LBU, LHU),
                All immediate,
                AUIPC,
                All S-type (SB, SH, SW),
                LUI,
                JAL,
                JALR,
                All Branch instrunctions(BEQ, BNE, BLT, BGE, BLTU, BGEU)

                    instructions
    */
    assign OP2_SEL = (opcode == 7'b0000011) | (opcode == 7'b0010011) | (opcode == 7'b0010111) | (opcode == 7'b0100011) | (opcode == 7'b0110111) | (opcode == 7'b1100111) | (opcode == 7'b1101111) | (opcode == 7'b1100011) ;

    /* 
        set register file write enable signal.
        Need to low operand 1 singnal in,
                All S-type (SB, SH, SW),

                    instructions
    */
    assign REG_WRITE_EN = (opcode == 7'b0100011);


    /* 
        set Immediate control signal (4 bit control bus).
        Need to low operand 1 singnal in,

                    instructions
    */
    assign IMM_SEL[3] = ({opcode, funct3} == {7'b0000011, 3'b100}) | 
                                 ({opcode, funct3} == {7'b0000011, 3'b101}) | 
                                 ({opcode, funct3} == {7'b0010011, 3'b011}) | 
                                 ({opcode, funct3, funct7} == {7'b0110011, 3'b011, 7'b0000000}) | 
                                 ({opcode, funct3, funct7} == {7'b0110011, 3'b010, 7'b0000001}) | 
                                 ({opcode, funct3, funct7} == {7'b0110011, 3'b011, 7'b0000001}) | 
                                 ({opcode, funct3, funct7} == {7'b0110011, 3'b111, 7'b0000001});

    assign IMM_SEL[2:0] =  (opcode == 7'b0000011) ? 3'b010 : 
                                    (opcode == 7'b0010111) ? 3'b000 :
                                    (opcode == 7'b0100011) ? 3'b100 : 
                                    (opcode == 7'b0110111) ? 3'b000 : 
                                    (opcode == 7'b1101111) ? 3'b001 : 
                                    (opcode == 7'b1100111) ? 3'b010 : 
                                    (opcode == 7'b1100011) ? 3'b011 : 
                                    ({opcode, funct3} == {7'b0010011, 3'bx01}) ? 3'b101 : 
                                    (opcode == 7'b0010011) ? 3'b010 : 3'bxxx;


    /* 
        set Branch control signal (4 bit control bus).
        Need to low operand 1 singnal in,

                    instructions
    */
    assign BR_SEL[3] = (opcode == 7'b1100111) | (opcode == 7'b1101111) |  (opcode == 7'b1100011);
    assign BR_SEL[2:0] = ((opcode == 7'b1100111) || (opcode == 7'b1101111))?3'b010:funct3;


    /* 
        set alu control signal (5 bit control bus).
        Need to low operand 1 singnal in,
                

                    instructions
    */
    assign func3_SEl = (opcode == 7'b0010111) | (opcode == 7'b1101111) | (opcode == 7'b0100011) | (opcode == 7'b0000011) | (opcode == 7'b1100011);

    mux2to1 funct3_mux (funct3, 3'b000, func3_SEl, ALU_OP[2:0]);

    assign ALU_OP[4] = ({opcode, funct3, funct7} == {7'b0010011, 3'b101, 7'b0100000}) | ({opcode, funct3, funct7} == 
    {7'b0110011, 3'b000, 7'b0100000}) | ({opcode, funct3, funct7} == {7'b0110011, 3'b101, 7'b0100000}) | (opcode == 7'b0110111);

    assign ALU_OP[3] = ({opcode, funct7} == 14'b01100110000001) | (opcode == 7'b0110111);


    /* 
        set Memory write control signal (3 bit control bus).
        Need to low operand 1 singnal in,
                

                    instructions
    */
    assign MEM_WRITE[2] = (opcode == 7'b100011);
    assign MEM_WRITE[1:0] = funct3[1:0];

    
    /* 
        set Memory Read control signal (4 bit control bus).
        Need to low operand 1 singnal in,
            All I-type 

                    instructions
    */
    assign MEM_READ[3] = (opcode == 7'b0000011);
    assign MEM_READ[2:0] = funct3;

    /* 
        set Register file write control signal (4 bit control bus).
        Need to low operand 1 singnal in,
            All I-type 

                    instructions
    */
    assign REG_WRITE_SEL[0] = ~(opcode == 7'b0000011);
    assign REG_WRITE_SEL[1] = (opcode == 7'b0010111) | (opcode == 7'b1101111) | (opcode == 7'b1100111);



endmodule

module mux2to1(DATA1, DATA2, SELECT, RESULT);

    // Port declaration starts
    input [2:0] DATA1, DATA2;
    input SELECT;

    output reg [2:0] RESULT;
    // Port declaration ends

    always @(*)
    begin
        if( SELECT == 1'b1)
        begin
        RESULT = DATA1;
        end
        else
        begin
            RESULT = DATA2;
        end
    end

endmodule