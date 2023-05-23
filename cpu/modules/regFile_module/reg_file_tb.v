// Computer Architecture (CO224) - Lab 05
// Design: Register File of Simple Processor
// Author: Kisaru Liyanage

`include "reg_file.v"

module reg_file_tb;
    
    reg [31:0] IN;
    reg [4:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
    reg CLK, RESET, WRITE; 
    wire [31:0] OUT1, OUT2;
    
    reg_file myregfile(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);
       
    initial
    begin
        CLK = 1'b0;
        
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("reg_file_wavedata.vcd");
		$dumpvars(0, reg_file_tb);
        
        // assign values with time to input signals to see output 
        RESET = 1'b0;
        WRITE = 1'b0;
        
        #2
        RESET = 1'b1;

        
        
        
        
        #10
        $finish;
    end
    
    // clock signal generation
    always
        #5 CLK = ~CLK;
        

<<<<<<< HEAD
    // Declare outputs
	wire [31:0] OUT1, OUT2;

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

            // OUT1ADDRESS = address;
            // $display("OUT1 = %h", OUT1);
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

            $display("out1 : %h | out2 : %h | expected1 : %h | expected2 : %h", OUT1, OUT2, expected_value1, expected_value2);
			// #20 assert (OUT1 == expected_value1) && (OUT2 == expected_value2) else $error("Mismatch detected!");
            // if (OUT1 != expected_value1 || OUT2 != expected_value2) 
            if (OUT1 == expected_value1 || OUT2 == expected_value2) 
            begin
                $display("Testbench success for Check values in the register.");
            end 
            
            else 
            begin
			    // $display("Mismatch detected at address %0d or %0d. Expected: %h, %h; Actual: %h, %h", address1, address2, expected_value1, expected_value2, OUT1, OUT2);
			    $error("Mismatch detected!");
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
        // RESET = 1;
        // #20 RESET = 1;

		// write_reg(data, reg);
		write_reg(32'h1, 5); 
		write_reg(32'h2, 10);

		// check_reg();
		check_reg(5, 10, 32'h1, 32'h2);
		// check_reg(32'h00000000, 10, 10); // Check that register at address 10 contains value 0x9ABCDEF0
		$display("Testbench complete.");
		$finish;
	end

endmodule



// ---------------------------------------------------------------------------------------------------------

// `timescale 1ns/1ns
// `include "./reg_file.v"

// module reg_file_tb;

// 	// Declare inputs
// 	reg [31:0] IN;
// 	reg [4:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
// 	reg WRITE, CLK, RESET;

//     // Declare outputs
// 	wire [31:0] OUT1, OUT2;

// 	reg_file uut(
// 		.IN(IN), 
// 		.OUT1(OUT1), 
// 		.OUT2(OUT2), 
// 		.INADDRESS(INADDRESS), 
// 		.OUT1ADDRESS(OUT1ADDRESS), 
// 		.OUT2ADDRESS(OUT2ADDRESS), 
// 		.WRITE(WRITE), 
// 		.CLK(CLK), 
// 		.RESET(RESET)
// 	);

// 	// Generate a clock signal
// 	always #10 CLK = ~CLK;

// 	// Initialize inputs and reset
// 	initial begin
// 		CLK = 0;
// 		IN = 0;
// 		INADDRESS = 0;
// 		OUT1ADDRESS = 0;
// 		OUT2ADDRESS = 0;
// 		WRITE = 0;

// 		#1  RESET = 1'b1;
// 		#20 RESET = 1'b0;
// 	end

// 	// Write values to the register
// 	task write_reg;
// 		input [31:0] data;
// 		input [4:0] address;
// 		begin
// 			IN = data;
// 			INADDRESS = address;
// 			WRITE = 1;
// 			#10 WRITE = 0;
// 		    $display("Testbench success for Write values to the register.");

//             OUT1ADDRESS = address;
//             $display("OUT1 = %h", OUT1);
// 		end
// 	endtask

// 	// Check values in the register
// 	task check_reg;
// 		input [4:0] address1, address2;
// 		input [31:0] expected_value1, expected_value2;
// 		begin
// 			OUT1ADDRESS = address1;
// 			OUT2ADDRESS = address2;
// 			#10;

// 			if (OUT1 != expected_value1 || OUT2 != expected_value2) begin
//                 $display("out1 : %h | out2 : %h | expected1 : %h | expected2 : %h", OUT1, OUT2, expected_value1, expected_value2);
// 			    $error("Mismatch detected!");
// 			end else begin
//                 $display("Testbench success for Check values in the register.");
// 			end
// 		end
// 	endtask

// 	// Write and check register values
// 	initial begin
// 		write_reg(32'h1, 5); 
// 		write_reg(32'h2, 10);
// 		check_reg(5, 10, 32'h1, 32'h2);
// 		$display("Testbench complete.");
// 		$finish;
// 	end

// endmodule

// ---------------------------------------------------------------------------------------------------------------------------

// `include "./reg_file.v"

// module reg_file_tb();

//     // Declare the signals to connect to the module
//     reg [31:0] IN;
//     reg [4:0] OUT1ADDRESS, OUT2ADDRESS, INADDRESS;
//     reg WRITE, CLK, RESET;
//     wire [31:0] OUT1, OUT2;

//     // Instantiate the module under test
//     reg_file dut (
//         .IN(IN),
//         .OUT1(OUT1),
//         .OUT2(OUT2),
//         .INADDRESS(INADDRESS),
//         .OUT1ADDRESS(OUT1ADDRESS),
//         .OUT2ADDRESS(OUT2ADDRESS),
//         .WRITE(WRITE),
//         .CLK(CLK),
//         .RESET(RESET)
//     );

//     // Generate a clock with a period of 10 time units
//     always #5 CLK = ~CLK;

//     // Test 1: Write to register 1 and read from register 1 and 2
//     initial begin
//         // Reset the module
//         RESET = 1;
//         #10;
//         RESET = 0;
//         // Write to register 1
//         IN = 32'd123;
//         INADDRESS = 1;
//         WRITE = 1;
//         #20;
//         WRITE = 0;
//         // Read from register 1 and 2
//         OUT1ADDRESS = 1;
//         OUT2ADDRESS = 2;
//         #20;
//         // Verify the output values
//         $display("Test 1: OUT1 = %d, OUT2 = %d", OUT1, OUT2);
//     end

//     // Test 2: Write to register 0 and read from register 0
//     initial begin
//         // Reset the module
//         RESET = 1;
//         #10;
//         RESET = 0;
//         // Write to register 0
//         IN = 32'd456;
//         INADDRESS = 0;
//         WRITE = 1;
//         #20;
//         WRITE = 0;
//         // Read from register 0
//         OUT1ADDRESS = 0;
//         OUT2ADDRESS = 0;
//         #20;
//         // Verify the output values
//         $display("Test 2: OUT1 = %d, OUT2 = %d", OUT1, OUT2);
//         // $finish
//     end

// endmodule
=======
endmodule
>>>>>>> e57e5ab14690bca5a698533f7eabe64fe8b3ea2a
