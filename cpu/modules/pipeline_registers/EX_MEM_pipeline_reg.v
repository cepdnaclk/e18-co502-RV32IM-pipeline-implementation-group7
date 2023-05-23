module ex_mem_pipeline_reg(
    input [4:0] IN_DESTINATION_REG_ADDRESS,
    input [31:0] IN_PC, IN_ALU_OUT,IN_DATA2, 
    input [2:0] IN_MEM_WRITE,
    input [3:0] IN_MEM_READ,
    input [1:0] IN_REG_WRITE_SEL,
    input IN_REG_WRITE_EN,
    input CLK, RESET, BUSY_WAIT,

    output reg [4:0] OUT_DESTINATION_REG_ADDRESS,
    output reg [31:0] OUT_PC, OUT_ALU_OUT,OUT_DATA2, 
    output reg [2:0] OUT_MEM_WRITE,
    output reg [3:0] OUT_MEM_READ,
    output reg [1:0] OUT_REG_WRITE_SEL,
    output reg OUT_REG_WRITE_EN
    );

    // RESET output registers on active reset
    always @(*) begin
        if (RESET) begin
            #1; // Delay to allow reset signal to settle
            OUT_DESTINATION_REG_ADDRESS = 5'dx;
            OUT_PC = 32'dx;
            OUT_ALU_OUT = 32'dx;
            OUT_DATA2 = 32'dx;
            OUT_MEM_WRITE = 3'dx;
            OUT_MEM_READ = 4'dx;
            OUT_REG_WRITE_SEL = 2'dx;
            OUT_REG_WRITE_EN = 1'dx;
        end
    end

    // Write input values to output registers on positive edge of clock signal
    always @(posedge CLK) begin
        #1; // Delay to synchronize with other stages
        if (!BUSY_WAIT && !RESET) begin
            OUT_DESTINATION_REG_ADDRESS <= IN_DESTINATION_REG_ADDRESS;
            OUT_PC <= IN_PC;
            OUT_ALU_OUT <= IN_ALU_OUT;
            OUT_DATA2 <= IN_DATA2;
            OUT_MEM_WRITE <= IN_MEM_WRITE;
            OUT_MEM_READ <= IN_MEM_READ;
            OUT_REG_WRITE_SEL <= IN_REG_WRITE_SEL;
            OUT_REG_WRITE_EN <= IN_REG_WRITE_EN;
        end
    end

endmodule