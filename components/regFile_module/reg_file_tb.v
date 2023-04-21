`timescale 1ns/1ns
`include "./reg_file.v"

module reg_file_tb;

	// Declare inputs
	reg [31:0] IN;
	reg [4:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
	reg WRITE, CLK, RESET;

    // Declare outputs
	wire [31:0] OUT1, OUT2;

	// Instantiate the reg_file module
	// reg_file uut(
	// 	.IN(IN), 
	// 	.INADDRESS(INADDRESS), 
	// 	.OUT1(OUT1), 
	// 	.OUT2(OUT2), 
	// 	.OUT1ADDRESS(OUT1ADDRESS), 
	// 	.OUT2ADDRESS(OUT2ADDRESS), 
	// 	.WRITE(WRITE), 
	// 	.CLK(CLK), 
	// 	.RESET(RESET)
	// );

	reg_file uut(
		IN, 
		OUT1, 
		OUT2, 
		INADDRESS, 
		OUT1ADDRESS, 
		OUT2ADDRESS, 
		WRITE, 
		CLK, 
		RESET
	);

	// Generate a clock signal
	always #10 CLK = ~CLK;

	// // Initialize inputs and reset
	// initial begin
	// 	CLK = 0;
	// 	IN = 0;
	// 	INADDRESS = 0;
	// 	OUT1ADDRESS = 0;
	// 	OUT2ADDRESS = 0;
	// 	WRITE = 0;
	// 	RESET = 1;
	// 	#20 RESET = 0;
	// end

	// Write values to the register
	task write_reg;
		input [31:0] data;
		input [4:0] address;
		begin
			IN = data;
			INADDRESS = address;
			WRITE = 1;
			#10 WRITE = 0;
		    $display("Testbench success for Write values to the register.");
		end
	endtask

	// Check values in the register
	task check_reg;
		// input [4:0] address1;
		input [4:0] address1, address2;
		input [31:0] expected_value1, expected_value2;
		begin
			OUT1ADDRESS = address1;
			OUT2ADDRESS = address2;
			// #20 assert (OUT1 == expected_value1) && (OUT2 == expected_value2) else $error("Mismatch detected!");
            if (OUT1 !== expected_value1 || OUT2 !== expected_value2) 
            begin
                $display("out1 : %h | out2 : %h | expected1 : %h | expected2 : %h", OUT1, OUT2, expected_value1, expected_value2);
			    // $display("Mismatch detected at address %0d or %0d. Expected: %h, %h; Actual: %h, %h", address1, address2, expected_value1, expected_value2, OUT1, OUT2);
			    $error("Mismatch detected!");
            end 
            
            else 
            begin
                $display("Testbench success for Check values in the register.");
            end

		    // $display("Testbench success for Check values in the register.");
		end
	endtask

	// Write and check register values
	initial
	begin

        CLK = 0;
        IN = 0;
        INADDRESS = 0;
        OUT1ADDRESS = 0;
        OUT2ADDRESS = 0;
        WRITE = 0;
        RESET = 1;
        #20 RESET = 1;

		// write_reg(data, reg);
		write_reg(32'h12345678, 5); // Write value 0x12345678 to register at address 5
		write_reg(32'h9ABCDEF0, 10); // Write value 0x9ABCDEF0 to register at address 10

		// check_reg();
		check_reg(5, 10, 32'h12345678, 32'h9ABCDEF0); // Check that register at address 0 contains value 0x00000000
		// check_reg(32'h00000000, 10, 10); // Check that register at address 10 contains value 0x9ABCDEF0
		$display("Testbench complete.");
		$finish;
	end

endmodule
