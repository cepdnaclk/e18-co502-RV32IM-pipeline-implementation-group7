/*
    Testbench for RV32IM_ALU module
*/

`include "./alu.v"

module alu_tb;

    // Declare clock and reset signals
    reg clk;
    reg rst_n;

    // Declare inputs
    reg [31:0] DATA1, DATA2;  // data inputs
    reg [4:0] SELECT;         // 5 bit select control signal

    // Declare output
    wire [31:0] RESULT;
    // reg [31:0] RESULT;

    // Instantiate the module under test
    alu myalu(DATA1, DATA2, RESULT, SELECT);
    
    // Create clock signal with 50% duty cycle
    // always #5 clk = ~clk;


    // Initialize inputs and reset signal
    initial begin
        $dumpfile("alu.vcd");
        clk = 0;
        rst_n = 0;
        DATA1 = 0;
        DATA2 = 0;
        SELECT = 0;
        #10 rst_n = 1;

        #5;
        DATA1 = 10;
        DATA2 = 5;
        SELECT = 5'b00000;
        #10;
        if (RESULT !== 15) $error("Test case 1 failed");
        else $display("Test case 1 passed");


        #5;
        DATA1 = 10;
        DATA2 = 5;
        SELECT = 5'b00010;
        #10;
        if (RESULT !== 5) $error("Test case 2 failed");
        else $display("Test case 2 passed");

        #5;
        DATA1 = 10;
        DATA2 = 2;
        SELECT = 5'b00100;
        #10;
        if (RESULT !== 40) $error("Test case 3 failed");
        else $display("Test case 3 passed");

        #5;
        DATA1 = 5;
        DATA2 = 10;
        SELECT = 5'b01000;
        #10;
        if (RESULT !== 1) 
        begin
            $error("Test case 4 failed");
            $display(RESULT);
        end
        else $display("Test case 4 passed");

        #5;
        DATA1 = -10;
        DATA2 = 5;
        SELECT = 5'b01100;
        #10;
        if (RESULT !== 0) $error("Test case 5 failed");
        else $display("Test case 5 passed");

        #5;
        DATA1 = 32'h0F0F0F0F;
        DATA2 = 32'hF0F0F0F0;
        SELECT = 5'b10000;
        #10;
        if (RESULT !== 32'hFFFFFFFF) $error("Test case 6 failed");
        else $display("Test case 6 passed");

        #5;
        DATA1 = 32'h12345678;
        DATA2 = 4;
        SELECT = 5'b10100;
        #10;
        // RESULT = {DATA1[31:DATA2], {DATA2{1'b0}}}; // SRL operation
        if (RESULT !== 32'h01234567) $error("Test case 7 failed");
        else $display("Test case 7 passed");
    end


endmodule