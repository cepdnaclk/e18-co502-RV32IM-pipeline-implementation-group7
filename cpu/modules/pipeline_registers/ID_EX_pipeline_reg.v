module ID_EX_pipeline_reg(
    input [4:0] IN_DESTINATION_REG_ADDRESS, IN_ALU_OP,
    input [31:0] IN_PC, IN_DATA1, IN_DATA2, IN_IMMEDIATE,
    input [3:0] IN_BR_SEL, IN_MEM_READ,
    input [2:0] IN_MEM_WRITE,
    input [1:0] IN_REG_WRITE_SEL,
    input IN_OP1_SEL, IN_OP2_SEL, IN_REG_WRITE_EN,
    input CLK, RESET, BUSY_WAIT,

    output reg [4:0] OUT_DESTINATION_REG_ADDRESS, OUT_ALU_OP,
    output reg [31:0] OUT_PC, OUT_DATA1, OUT_DATA2, OUT_IMMEDIATE,
    output reg [3:0] OUT_BR_SEL, OUT_MEM_READ,
    output reg [2:0] OUT_MEM_WRITE,
    output reg [1:0] OUT_REG_WRITE_SEL,
    output reg OUT_OP1_SEL, OUT_OP2_SEL, OUT_REG_WRITE_EN
);

    // RESET output registers on active reset
    always @(*) begin
        if (RESET) begin
            #1; // Delay to allow reset signal to settle
            OUT_DESTINATION_REG_ADDRESS = 5'dX;
            OUT_ALU_OP = 5'dx;
            OUT_PC = 32'dx;
            OUT_DATA1 = 32'dx;
            OUT_DATA2 = 32'dx;
            OUT_IMMEDIATE = 32'dx;
            OUT_BR_SEL = 4'dx;
            OUT_MEM_READ = 4'dx;
            OUT_MEM_WRITE = 3'dx;
            OUT_REG_WRITE_SEL = 2'dx;
            OUT_OP1_SEL = 1'dx;
            OUT_OP2_SEL = 1'dx;
            OUT_REG_WRITE_EN = 1'dx;
        end
    end

    // Write input values to output registers on positive edge of clock signal
    always @(posedge CLK) begin
        #1; // Delay to synchronize with other stages
        if (!BUSY_WAIT && !RESET) begin
            OUT_DESTINATION_REG_ADDRESS <= IN_DESTINATION_REG_ADDRESS;
            OUT_ALU_OP <= IN_ALU_OP;
            OUT_PC <= IN_PC;
            OUT_DATA1 <= IN_DATA1;
            OUT_DATA2 <= IN_DATA2;
            OUT_IMMEDIATE <= IN_IMMEDIATE;
            OUT_BR_SEL <= IN_BR_SEL;
            OUT_MEM_READ <= IN_MEM_READ;
            OUT_MEM_WRITE <= IN_MEM_WRITE;
            OUT_REG_WRITE_SEL <= IN_REG_WRITE_SEL;
            OUT_OP1_SEL <= IN_OP1_SEL;
            OUT_OP2_SEL <= IN_OP2_SEL;
            OUT_REG_WRITE_EN = IN_REG_WRITE_EN;
        end
    end

endmodule