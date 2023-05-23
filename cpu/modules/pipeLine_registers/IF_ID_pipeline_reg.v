module IF_ID_pipeline_reg(
    input [31:0] IN_INSTRUCTION, // Input instruction from instruction memory
    input [31:0] IN_PC, // Input program counter value from program counter module
    input CLK, // Clock signal
    input RESET, // RESET signal
    input BUSY_WAIT, // Stall signal to hold pipeline stage
    
    output reg [31:0] OUT_INSTRUCTION, // Output instruction to decode stage
    output reg [31:0] OUT_PC // Output program counter value to program counter module
);

    // RESET output registers on active RESET
    always @(*) begin
        if (RESET) begin
            #1; // Delay to allow RESET signal to settle
            OUT_INSTRUCTION = 32'dx; // Set OUT_INSTRUCTION to 'x' value
            OUT_PC = 32'dx; // Set OUT_PC to 'x' value
        end
    end

    // Write input values to output registers on positive edge of clock signal
    always @(posedge CLK) begin
        #1; // Delay to synchronize with other stages
        if (!BUSY_WAIT && !RESET) begin
            OUT_INSTRUCTION <= IN_INSTRUCTION; // Write IN_INSTRUCTION to OUT_INSTRUCTION
            OUT_PC <= IN_PC; // Write IN_PC to OUT_PC
        end
    end

endmodule