/*
    This is test bench for immediate encoder module
*/

`include "Immediate_encoder.v"

module Immediate_encoder_tb;
    // Testbench inputs
    reg [31:0] INSTRUCTION;
    reg [2:0] IMM_SEL;
    

    // Testbench outputs
    wire [31:0] IMMEDIATE;

    // Instantiate the module under test
    Immediate_encoder dut (
        .INSTRUCTION(INSTRUCTION),
        .IMM_SEL(IMM_SEL),
        .IMMEDIATE(IMMEDIATE)
    );

    // Define task for test case
    task run_test;
        input [31:0] expected_immediate, instruction;
        input [2:0] imm_sel;

        // Apply inputs and check outputs
        begin
            INSTRUCTION = instruction;
            IMM_SEL = imm_sel;

            #4;  // Wait for some cycles

            if (IMMEDIATE !== expected_immediate)
            begin
                $display("Test case FAILED");
                $display("Expected IMMEDIATE = %b, Actual IMMEDIATE = %b", expected_immediate, IMMEDIATE);
            end else begin
                $display("Test case PASSED");
            end
        end
    endtask

    // Call task for each test case
    initial begin

        $dumpfile("simulation.vcd");  // Specify the name of the VCD file
        $dumpvars(0, Immediate_encoder_tb);

        // Initialize inputs


        // Test case 1 I-type (addi x1, x2, 1871)
        $display("\nTest case 1 I-type (addi x1, x2, 1871)");
        run_test(32'b00000000000000000000011101001111, 32'b011101001111_00010_000_00001_0010011, 3'b000);


        // Test case 2 S-type (sw x1, 60(x2))
        $display("\nTest case 2 S-type (sw x1, 60(x2))");
        run_test(32'b00000000000000000000000000111100, 32'b0000001_00001_00010_010_11100_0000011, 3'b001);
        
        
        // Test case 3 B-type (beq x1, x2, 1200)
        $display("\nTest case 3 S-type (beq x1, x2, 1200)");
        run_test(32'b0000_0000_0000_0000_0000_0100_1011_0000, 32'b0100101_00001_00010_000_1000_0_1100011, 3'b010);

                
        // Test case 4 U-type (lui x1, 180146176)
        $display("\nTest case 4 S-type (lui x1, 180146176)");
        run_test(32'b0000_1010_1011_1100_1101_0000_0000_0000, 32'b00001010101111001101_00001_0110111, 3'b011);

                
        // Test case 5 J-type (jal x1, 996394)
        $display("\nTest case 5 S-type (jal x1, 996394)");
        run_test(32'b0000_0000_0000_0001_0101_0111_1001_1010, 32'b01111001101000010101_00001_1101111, 3'b100);       

        // Finish simulation
        #10 $finish;
    end

endmodule
