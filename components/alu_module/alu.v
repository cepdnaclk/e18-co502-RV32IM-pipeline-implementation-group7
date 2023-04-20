/*
    Arithmatic Logic Unit for RV32IM processor
*/

module alu (DATA1, DATA2, RESULT, SELECT);

    // Declare inputs
    input [31:0] DATA1, DATA2;  // data inputs
    input [4:0] SELECT;         // 5 bit select control singal

    // Declare output
    output [31:0] RESULT;

    reg [31:0] RESULT;


    // Declare 18 inner 32 wire buses for internal operations
    wire [31:0] INNER_BUS_ADD, 
                INNER_BUS_SUB,
                INNER_BUS_AND, 
                INNER_BUS_OR, 
                INNER_BUS_FWD,
                INNER_BUS_XOR, 
                INNER_BUS_MUL, 
                INNER_BUS_MULHSU, 
                INNER_BUS_MULHU, 
                INNER_BUS_SLL, 
                INNER_BUS_SRL, 
                INNER_BUS_SRA,
                INNER_BUS_SLT,
                INNER_BUS_SLTU,
                INNER_BUS_DIV,
                INNER_BUS_DIVU, 
                INNER_BUS_REM, 
                INNER_BUS_REMU;

    // Declare 1 inner 64 wire buses for internal operations
    wire [63:0] INNER_BUS_MULH;

    /*
        ALU calculations
        Behavioural modeling is used in programming

        TODOs:
            Need to assign delay times
    */

    // RV32I alu instructions

    // basic calculations
    assign INNER_BUS_ADD = DATA1 + DATA2;
    assign INNER_BUS_SUB = DATA1 - DATA2;
    assign INNER_BUS_AND =  DATA1 & DATA2;
    assign INNER_BUS_OR =  DATA1 | DATA2;
    assign INNER_BUS_FWD = DATA2;
    assign INNER_BUS_XOR =  DATA1 ^ DATA2;

    // Shift instructions
    assign INNER_BUS_SLL = DATA1 << DATA2;
    assign INNER_BUS_SRL = DATA1 >> DATA2;
    assign INNER_BUS_SRA = DATA1 >>> DATA2;

    // set less than instructions
    assign INNER_BUS_SLT = ($signed(DATA1) < $signed(DATA2)) ? 1'b1 : 1'b0;
    assign INNER_BUS_SLTU = ($unsigned(DATA1) < $unsigned(DATA2)) ? 1'b1 : 1'b0;

    // Multiply instructions
    assign INNER_BUS_MUL = DATA1 * DATA2;
    assign INNER_BUS_MULH = DATA1 * DATA2;
    assign INNER_BUS_MULHSU = $signed(DATA1) * $unsigned(DATA2);
    assign INNER_BUS_MULHU = $unsigned(DATA1) * $unsigned(DATA2);
    
    // Division instructions
    assign INNER_BUS_DIV = $signed(DATA1) / $signed(DATA1);
    assign INNER_BUS_DIVU = $unsigned(DATA1) / $unsigned(DATA2);
    assign INNER_BUS_REM = $signed(DATA1) % $signed(DATA1);
    assign INNER_BUS_REMU = $unsigned(DATA1) % $unsigned(DATA1);

    always @(*)
    begin
        case(SELECT)
            5'b00000: RESULT = INNER_BUS_ADD; 
            5'b00010: RESULT = INNER_BUS_SUB; 
            5'b00100: RESULT = INNER_BUS_SLL; 
            5'b01000: RESULT = INNER_BUS_SLT; 
            5'b01100: RESULT = INNER_BUS_SLTU; 
            5'b10000: RESULT = INNER_BUS_XOR; 
            5'b10100: RESULT = INNER_BUS_SRL; 
            5'b10110: RESULT = INNER_BUS_SRA; 
            5'b11000: RESULT = INNER_BUS_OR; 
            5'b11100: RESULT = INNER_BUS_AND; 
            5'b00001: RESULT = INNER_BUS_MUL; 
            5'b00101: RESULT = INNER_BUS_MULH[63:32]; 
            5'b01001: RESULT = INNER_BUS_MULHU; 
            5'b01101: RESULT = INNER_BUS_MULHSU; 
            5'b10001: RESULT = INNER_BUS_DIV; 
            5'b10101: RESULT = INNER_BUS_DIVU; 
            5'b11001: RESULT = INNER_BUS_REM; 
            5'b11101: RESULT = INNER_BUS_REMU; 
                
            default:  RESULT = 0 ;  
                                
        endcase
    end

endmodule