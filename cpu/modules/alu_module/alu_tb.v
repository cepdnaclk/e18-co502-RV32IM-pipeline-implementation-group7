
/*
    Testbench for RV32IM_ALU module
*/
`include "alu.v"

module alu_tb;

    // Declare inputs
    reg [31:0] DATA1, DATA2;  // data inputs
    reg [4:0] ALU_OP;         // 5 bit ALU_OP control signal

    // Declare output
    wire [31:0] RESULT;

    // Instantiate the module under test
    alu myalu(DATA1, DATA2, RESULT, ALU_OP);

    // Define task for test case
    task run_test;
        input [31:0] expected_result;
        input [4:0] opcode;
        input [31:0] data1, data2;

        reg [3:0] opname;
        localparam UNKNOWN_OPCODE = 5'd32;

        // Initialize inputs and reset signal
        begin
            DATA1 = data1;         // data 1
            DATA2 = data2;         // data 2
            ALU_OP = opcode;       // opcode ALU_OP

            #4;
            // If there an error, display the error message
            if (RESULT !== expected_result) $error($sformatf("Test case FAILED for opcode %05b", opcode));


            // else display the result
            $display($sformatf("Test case PASSED\nData1 = %d\nData2 = %d\nResult = %d\nExpected Result = %d", DATA1, DATA2, RESULT, expected_result));
        end
    endtask

    // Call task for each test case
    initial begin
        $display("\nTest Addition operation");
        run_test(15, 5'b00000, 10, 5);

        $display("\nTest Substartion operation");
        run_test(5, 5'b00010, 10, 5);

        $display("\nTest Substartion operation");
        run_test(40, 5'b00100, 10, 2);

        $display("\nTest Substartion operation");
        run_test(1, 5'b01000, 5, 10);

        $display("\nTest Substartion operation");
        run_test(0, 5'b01100, -10, 5);

        $display("\nTest Substartion operation");
        run_test(32'hFFFFFFFF, 5'b10000, 32'h0F0F0F0F, 32'hF0F0F0F0);

        $display("\nTest Substartion operation");
        run_test(32'h01234567, 5'b10100, 32'h12345678, 4);
    end

endmodule