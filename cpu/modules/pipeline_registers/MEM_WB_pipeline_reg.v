module mem_wb_pipeline_reg(
    input [4:0] IN_DESTINATION_REG_ADDRESS,
    input [31:0] IN_UPDATED_PC, IN_ALU_OUT, IN_DATA_OUT, 
    input [1:0] IN_REG_WRITE_SEL,
    input IN_REG_WRITE_EN,
    input CLK, RESET, BUSY_WAIT,

    output reg [4:0] OUT_DESTINATION_REG_ADDRESS,
    output reg [31:0] OUT_UPDATED_PC, OUT_ALU_OUT,OUT_DATA_OUT, 
    output reg [1:0] OUT_REG_WRITE_SEL,
    output reg OUT_REG_WRITE_EN
);

    // RESET output registers on active reset
    always @(*) begin
        if (RESET) begin
            #1; // Delay to allow reset signal to settle
            OUT_DESTINATION_REG_ADDRESS <= 5'dx;
            OUT_UPDATED_PC <= 32'dx;
            OUT_ALU_OUT <= 32'dx;
            OUT_DATA_OUT <= 32'dx;
            OUT_REG_WRITE_SEL <= 2'dx;
            OUT_REG_WRITE_EN <= 1'dx;
        end
    end

    // Write input values to output registers on positive edge of clock signal
    always @(posedge CLK) begin
        #1; // Delay to synchronize with other stages
        if (!RESET && !BUSY_WAIT) begin
            OUT_DESTINATION_REG_ADDRESS <= IN_DESTINATION_REG_ADDRESS;
            OUT_UPDATED_PC <= IN_UPDATED_PC;
            OUT_ALU_OUT <= IN_ALU_OUT;
            OUT_DATA_OUT <= IN_DATA_OUT;
            OUT_REG_WRITE_SEL <= IN_REG_WRITE_SEL;
            OUT_REG_WRITE_EN <= IN_REG_WRITE_EN;
        end
    end
endmodule