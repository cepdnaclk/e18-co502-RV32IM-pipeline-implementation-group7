module RV32IM_ALU_tb;

reg [31:0] op1;
reg [31:0] op2;
reg [2:0] funct3;
reg [6:0] funct7;
reg [1:0] opcode;
wire [31:0] result;
wire zero;
wire carry;
wire overflow;

RV32IM_ALU dut (
    .op1(op1),
    .op2(op2),
    .funct3(funct3),
    .funct7(funct7),
    .opcode(opcode),
    .result(result),
    .zero(zero),
    .carry(carry),
    .overflow(overflow)
);

initial begin
    // Test ADD instruction
    op1 = 32'h00000001;
    op2 = 32'h00000002;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    opcode = 2'b00;
    #10;
    if (result !== 32'h00000003 || zero !== 0 || carry !== 0 || overflow !== 0) $display("ADD instruction failed");

    // Test SLTI instruction
    op1 = 32'h00000001;
    op2 = 32'h00000002;
    funct3 = 3'b010;
    funct7 = 7'b0000000;
    opcode = 2'b01;
    #10;
    if (result !== 1 || zero !== 0 || carry !== 0 || overflow !== 0) $display("SLTI instruction failed");

    // Test SLTIU instruction
    op1 = 32'hFFFFFFFF;
    op2 = 32'h00000001;
    funct3 = 3'b011;
    funct7 = 7'b0000000;
    opcode = 2'b01;
    #10;
    if (result !== 0 || zero !== 1 || carry !== 0 || overflow !== 0) $display("SLTIU instruction failed");

    // Test XOR instruction
    op1 = 32'hAAAAAAAA;
    op2 = 32'h55555555;
    funct3 = 3'b100;
    funct7 = 7'b0000000;
    opcode = 2'b00;
    #10;
    if (result !== 32'hFFFFFFFF || zero !== 0 || carry !== 0 || overflow !== 0) $display("XOR instruction failed");

    // Test ORI instruction
    op1 = 32'hAAAAAAAA;
    op2 = 32'h0000FFFF;
    funct3 = 3'b110;
    funct7 = 7'b0000000;
    opcode = 2'b01;
    #10;
    if (result !== 32'hAAAAAAAA || zero !== 0 || carry !== 0 || overflow !== 0) $display("ORI instruction failed");

    // Test ANDI instruction
    op1 = 32'hAAAAAAAA;
    op2 = 32'h0000FFFF;
    funct3 = 3'b111;
    funct7 = 7'b0000000;
    opcode = 2'b01;
    #10;
    if (result !== 32'h0000AAAA || zero !== 0 || carry !== 0 || overflow !== 0) $display("ANDI instruction failed");

    $display("All tests passed");
    $finish;
end

endmodule
