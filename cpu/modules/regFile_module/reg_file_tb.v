`timescale 1ns/1ns

`include "reg_file.v"

module reg_file_tb;
    // Testbench inputs
    reg [31:0] IN;
    reg [4:0] OUT1ADDRESS, OUT2ADDRESS, INADDRESS;
    reg WRITE, CLK, RESET;

    // Testbench outputs
    wire [31:0] OUT1, OUT2;

    // Instantiate the module under test
    reg_file dut (
        .IN(IN),
        .OUT1(OUT1),
        .OUT2(OUT2),
        .INADDRESS(INADDRESS),
        .OUT1ADDRESS(OUT1ADDRESS),
        .OUT2ADDRESS(OUT2ADDRESS),
        .WRITE(WRITE),
        .CLK(CLK),
        .RESET(RESET)
    );

    // Clock generation
    always #5 CLK = ~CLK;

    // Define task for test case
    task run_test;
        input [31:0] expected_out1, expected_out2;
        input [4:0] in_address, out1_address, out2_address;
        input write;
        input [31:0] input_data;

        // Apply inputs and check outputs
        begin
            INADDRESS = in_address;
            OUT1ADDRESS = out1_address;
            OUT2ADDRESS = out2_address;
            WRITE = write;
            IN = input_data;

            #4;  // Wait for some cycles

            if (OUT1 !== expected_out1 || OUT2 !== expected_out2) begin
                $display("Test case FAILED");
                $display("Expected OUT1 = %d, Actual OUT1 = %d", expected_out1, OUT1);
                $display("Expected OUT2 = %d, Actual OUT2 = %d", expected_out2, OUT2);
            end else begin
                $display("Test case PASSED");
            end
        end
    endtask

    // Call task for each test case
    initial begin

        $dumpfile("simulation.vcd");  // Specify the name of the VCD file
        $dumpvars(0, reg_file_tb);

        // Initialize inputs
        CLK = 0;
        RESET = 1'b0;
        #3 RESET = 1'b1;
        #3 RESET = 1'b0;


        // Test case 1
        #2 run_test(0, 0, 0, 0, 1, 1, 10);

        #6 run_test(10, 0, 1, 0, 1, 1, 20);

        #6 run_test(10, 20, 2, 0, 1, 1, 30);

        #6 run_test(20, 30, 3, 1, 2, 1, 40);

        #6 run_test(30, 40, 4, 2, 3, 1, 50);

        // Finish simulation
        #10 $finish;
    end

endmodule
