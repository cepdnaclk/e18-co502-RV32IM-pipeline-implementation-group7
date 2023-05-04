module control_unit(INSTRUCTION, OP1_SEL, OP2_SEL, REG_WRITE_EN, IMM_SEL, BR_SEL, ALU_OP, MEM_WRITE, MEM_READ, REG_WRITE_SEL);
	// Begin port declaration
	// Inputs	
	input [31:0] INSTRUCTION;
	input RESET; // Wires

	// Outputs
    output OP1_SEL, OP2_SEL, REG_WRITE_EN;
	output [2:0] IMM_SEL;
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
                All SB-Type(BEQ, BNE, BLT, BGE, BLTU, BGEU)
                
                    instructions
    */
    assign OP1_SEL = (opcode == 7'b0010111) | (opcode == 7'b1101111) | (opcode == 7'b1100011);


    /* 
        set operand 2 singnal.
        Need to high operand 2 singnal in,
                All I-type (16 Instructions),
                U-Type (AUIPC,LUI),
                All S-type (SB, SH, SW),
                All SB-Type(BEQ, BNE, BLT, BGE, BLTU, BGEU)

                    instructions
    */
    assign OP2_SEL = (opcode == 7'b0000011) | (opcode == 7'b0010011) | (opcode == 7'b0010111) | (opcode == 7'b0100011) | (opcode == 7'b0110111) | (opcode == 7'b1100111) | (opcode == 7'b1101111) | (opcode == 7'b1100011) ;

    /* 
        set register file write enable signal.
        Need to high REG_WRITE_EN singnal except following instructions,
                All S-type (SB, SH, SW),
                All SB-Type(BEQ, BNE, BLT, BGE, BLTU, BGEU)
    */
    assign REG_WRITE_EN =  ~((opcode == 7'b0100011) | (opcode == 7'b1100011)) ;    


    /* 
        set Immediate control signal (3 bit control bus).

        Type     IMM_SEL[2:0]

        I-type      000
        S-type      001
        SB-type     010
        U-type      011
        UJ-type     100

    */

    assign IMM_SEL[2:0] =   (opcode == 7'b0010011) ? 3'b000 : // I-type (ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI)
                            (opcode == 7'b0000011) ? 3'b000 : // I-type (LB, LH, LW, LBU, LHU)
                            (opcode == 7'b1100111) ? 3'b000 : // I-type (JALR)
                            (opcode == 7'b0100011) ? 3'b001 : // S-type (SB, SH, SW)
                            (opcode == 7'b1100011) ? 3'b010 : // SB-type (BEQ, BNE, BLT, BGE, BLTU, BGEU)
                            (opcode == 7'b0110111) ? 3'b011 : // U-type (LUI)
                            (opcode == 7'b0010111) ? 3'b011 : // U-type (AUIPC)
                            (opcode == 7'b1101111) ? 3'b100 : 3'bxxx ; // UJ-type (JAL)


    /* 
        set Branch control signal (4 bit control bus).
        BR_SEL[3] is high when instruction is JAL, JALR or SB-type
        BR_SEL[2:0] is 3'b010 if instruction is JAL or JALR
        otherwise funct3 vaue

                    instructions
    */
    assign BR_SEL[3] = (opcode == 7'b1100111) | (opcode == 7'b1101111) |  (opcode == 7'b1100011);
    assign BR_SEL[2:0] = ((opcode == 7'b1100111) || (opcode == 7'b1101111))?3'b010:funct3;


    /* 
        set alu control signal (5 bit control bus).
        Need to low operand 1 singnal in,
                

                    instructions
    */
    assign ALU_OP[4:0] =    ({opcode, funct3, funct7} == {7'b0110011, 3'b000, 7'b0000000}) ? 5'b00000 :
                            ({opcode, funct3, funct7} == {7'b0110011, 3'b000, 7'b0100000}) ? 5'b00010 :
                            ({opcode, funct3, funct7} == {7'b0110011, 3'b001, 7'b0000000}) ? 5'b00100 :
                            ({opcode, funct3, funct7} == {7'b0110011, 3'b010, 7'b0000000}) ? 5'b01000 :
                            ({opcode, funct3, funct7} == {7'b0110011, 3'b011, 7'b0000000}) ? 5'b01100 :
                            ({opcode, funct3, funct7} == {7'b0110011, 3'b100, 7'b0000000}) ? 5'b10000 :
                            ({opcode, funct3, funct7} == {7'b0110011, 3'b101, 7'b0000000}) ? 5'b10100 :
                            ({opcode, funct3, funct7} == {7'b0110011, 3'b101, 7'b0100000}) ? 5'b10110 :
                            ({opcode, funct3, funct7} == {7'b0110011, 3'b110, 7'b0000000}) ? 5'b11000 :
                            ({opcode, funct3, funct7} == {7'b0110011, 3'b111, 7'b0000000}) ? 5'b11100 :
                            ({opcode, funct3} == {7'b0110011, 3'b000}) ? 5'b00001 :
                            ({opcode, funct3} == {7'b0110011, 3'b001}) ? 5'b00101 :
                            ({opcode, funct3} == {7'b0110011, 3'b010}) ? 5'b01101 :
                            ({opcode, funct3} == {7'b0110011, 3'b011}) ? 5'b01001 :
                            ({opcode, funct3} == {7'b0110011, 3'b100}) ? 5'b10001 :
                            ({opcode, funct3} == {7'b0110011, 3'b101}) ? 5'b10101 :
                            ({opcode, funct3} == {7'b0110011, 3'b110}) ? 5'b11001 :
                            ({opcode, funct3} == {7'b0110011, 3'b111}) ? 5'b11101 :
                            ({opcode} == {7'b0000011}) ? 5'b00000 : // loads
                            ({opcode} == {7'b0100011}) ? 5'b00000 : // store type
                            ({opcode} == {7'b1100011}) ? 5'b00000 : // conditional brnach type
                            ({opcode} == {7'b0010111}) ? 5'b00000 : // Auipc
                            ({opcode} == {7'b1101111}) ? 5'b00000 : // JAL
                            ({opcode} == {7'b1100111}) ? 5'b00000 : // JALR
                            ({opcode} == {7'b0110111}) ? 5'b11111 : // LUI
                            ({opcode, funct3} == {7'b0010011, 3'b000}) ? 5'b00000 :
                            ({opcode, funct3} == {7'b0010011, 3'b010}) ? 5'b01000 :
                            ({opcode, funct3} == {7'b0010011, 3'b011}) ? 5'b01100 :
                            ({opcode, funct3} == {7'b0010011, 3'b100}) ? 5'b10000 :
                            ({opcode, funct3} == {7'b0010011, 3'b110}) ? 5'b11000 :
                            ({opcode, funct3} == {7'b0010011, 3'b111}) ? 5'b11100 :
                            ({opcode, funct3, funct7} == {7'b0010011, 3'b001, 7'b0000000}) ? 5'b00100 :
                            ({opcode, funct3, funct7} == {7'b0010011, 3'b101, 7'b0000000}) ? 5'b10100 :
                            ({opcode, funct3, funct7} == {7'b0010011, 3'b101, 7'b0100000}) ? 5'b10110 : 5'bxxxxx;




    /* 
        set Memory write control signal (3 bit control bus).
        Need to low operand 1 singnal in,
                Set signal according to S type
                    instructions
    */
    assign MEM_WRITE[2] = (opcode == 7'b0100011);
    assign MEM_WRITE[1:0] = funct3[1:0];

    
    /* 
        set Memory Read control signal (4 bit control bus).
        Need to low operand 1 singnal in,
            All Load-type 

                    instructions
    */
    assign MEM_READ[3] = (opcode == 7'b0000011);
    assign MEM_READ[2:0] = funct3;

    /* 
        set Register file write control signal (4 bit control bus).
        Need to low operand 1 singnal in,
            All Load-type
            AUIPC
            JAL
            JALR

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