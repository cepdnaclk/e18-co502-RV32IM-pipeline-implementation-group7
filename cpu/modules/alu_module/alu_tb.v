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

        reg acceptable_output;

        // Initialize inputs and reset signal
        begin
            DATA1 = data1;         // data 1
            DATA2 = data2;         // data 2
            ALU_OP = opcode;       // opcode ALU_OP

            // Wait for a few cycles for the output to stabilize
            #4;

            // If there's an error, display the error message
            if (RESULT !== expected_result)
            begin
                $error($sformatf("Test case FAILED for opcode %05b", opcode));
                acceptable_output = 1'b0;
            end
            else
            begin
                acceptable_output = 1'b1;
            end

            // Otherwise, display the result
            $display($sformatf("Test case PASSED\nData1 = %d\nData2 = %d\nResult = %d\nExpected Result = %d", DATA1, DATA2, RESULT, expected_result));

            #1;
            acceptable_output = 1'b0;
        end
    endtask

    // Call task for each test case
    initial begin

        $dumpfile("simulation.vcd");  // Specify the name of the VCD file
        $dumpvars(0, alu_tb);

        $display("\nTest case (ADD)");
        run_test(15, 5'b00000, 10, 5);

        $display("\nTest case (SUB)");
        run_test(3, 5'b00010, 8, 5);

        $display("\nTest case (SLL)");
        run_test(20, 5'b00100, 5, 2);

        $display("\nTest case (SLT)");
        run_test(1, 5'b01000, -5, 5);

        $display("\nTest case (SLTU)");
        run_test(0, 5'b01100, -5, 5);

        $display("\nTest case (XOR)");
        run_test(7, 5'b10000, 10, 13);

        $display("\nTest case (SRL)");
        run_test(5, 5'b10100, 40, 3);

        $display("\nTest case (SRA)");
        run_test(-5, 5'b10110, -40, 3);

        $display("\nTest case (OR)");
        run_test(15, 5'b11000, 10, 13);

        $display("\nTest case (AND)");
        run_test(8, 5'b11100, 10, 13);

        $display("\nTest case (MUL)");
        run_test(30, 5'b00001, 5, 6);

        $display("\nTest case (MULH)");
        run_test(0, 5'b00101, 5, 6);

        $display("\nTest case (MULHU)");
        run_test(3, 5'b01001, 4294967295, 2);

        $display("\nTest case (MULHSU)");
        run_test(-3, 5'b01101, -4294967295, 2);

        $display("\nTest case (DIV)");
        run_test(2, 5'b10001, 10, 4);

        $display("\nTest case (DIVU)");
        run_test(0, 5'b10101, -10, 4);

        $display("\nTest case (REM)");
        run_test(2, 5'b11001, 10, 4);

        $display("\nTest case (REMU)");
        run_test(2, 5'b11101, -10, 4);
    end

endmodule
