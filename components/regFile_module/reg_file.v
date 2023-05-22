module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);

    //create the 8x8 register array
    reg [31:0] REGISTER[0:31];

    //declaring ports
    input [31:0] IN;
    input [4:0] OUT1ADDRESS, OUT2ADDRESS, INADDRESS;
    input WRITE, CLK, RESET;
    output [31:0] OUT1, OUT2;

    //variable to count the iterations in loops
    integer i;

    //reading the registers
    //this runs always when the register values changes or when the register outaddress changes
    assign #2 OUT1 = REGISTER[OUT1ADDRESS];
    assign #2 OUT2 = REGISTER[OUT2ADDRESS];

<<<<<<< HEAD
    //resetting the registers
    always @ (*) begin
        //if the reset = 1, then all the registers are set to 0
        if (RESET) begin  
            #2 for (i = 0; i < 32; i = i + 1)
                REGISTER[i] = 32'd0;
        end
    end

    //writting the values to a register
    //this runs only on positive clock edges
    // always @ (*) begin
    always @ (posedge CLK) begin
        #1
        //if the write = 1 and reset = 0, the given register will be written with the given value
        // TODO: NOP support
        if (WRITE & !RESET & INADDRESS != 0) begin
            REGISTER[INADDRESS] = IN;
        end
    end

endmodule


// ------------------------------------------------------------------
// module reg_file(
// 					IN, 
// 					OUT1, 
// 					OUT2, 
// 					INADDRESS, 
// 					OUT1ADDRESS, 
// 					OUT2ADDRESS, 
// 					WRITE, 
// 					CLK, 
// 					RESET
// 				);

// 	// Begin port declaration
// 	// Inputs	
// 	input [31:0] IN;
// 	input [4:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
// 	input WRITE, CLK, RESET; // Wires

// 	// Outputs
// 	output reg [31:0] OUT1, OUT2;
// 	// End port declaration

// 	// Declare 8x8 register as vector
// 	reg [31:0] regFile [0:31];

//     integer i;

	
// 	assign #2 OUT1 = regFile[OUT1ADDRESS];
// 	assign #2 OUT2 = regFile[OUT2ADDRESS];

// 	// Execute the following block when rising edge of CLK
// 	always@(posedge CLK)
// 	begin
// 		// // Reset the register if the RESET signal is high
// 		// if ( RESET == 1 )
// 		// begin

// 		// 	// Write 0 for all registers
// 		// 	for ( i = 0; i < 32; i = i + 1)
// 		// 	begin
// 		// 		regFile[i] = 32'b0;
// 		// 	end
// 		// end
=======
			#2
			// Write 0 for all registers
			for ( i = 0; i < 32; i = i + 1)
			begin
				regFile[i] = 32'b0;
			end
		end
>>>>>>> e57e5ab14690bca5a698533f7eabe64fe8b3ea2a
		
// 		// If the WRITE signal is high and RESET signal is low, write the given input data(IN) into related register(the register given by INADDRESS)
// 		// else if ( WRITE == 1)
// 		#1 
// 		if (WRITE & !RESET & INADDRESS!=0)
// 		begin
// 			// Write the register with 1 time unit delay
// 			regFile[INADDRESS] = IN;
// 		end
// 	end

// 	// If any of varible is changed assign relavant values from the registers to the OUT1 and OUT2
// 	always@(*)
// 	begin
// 		// Reset the register if the RESET signal is high
// 		if ( RESET )
// 		begin

<<<<<<< HEAD
// 			// Write 0 for all registers
// 			#2 for ( i = 0; i < 32; i = i + 1)
// 			begin
// 				regFile[i] = 32'b0;
// 			end
// 		end

// 		// #2
// 		// OUT1 = regFile[OUT1ADDRESS];
// 		// OUT2 = regFile[OUT2ADDRESS];
// 	end

// 	// initial
// 	// begin
// 	// 	$dumpfile("cpu_wavedata_with_regFile.vcd");
// 	// 	for(i = 0; i < 32; i = i + 1)
// 	// 	begin
// 	// 		$dumpvars(1,regFile[i]);
// 	// 	end
// 	// end
// endmodule




// module reg_file(
// 					IN, 
// 					OUT1, 
// 					OUT2, 
// 					INADDRESS, 
// 					OUT1ADDRESS, 
// 					OUT2ADDRESS, 
// 					WRITE, 
// 					CLK, 
// 					RESET
// 				);

// 	// Begin port declaration
// 	// Inputs	
// 	input [31:0] IN;
// 	input [4:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
// 	input WRITE, CLK, RESET; // Wires

// 	// Outputs
// 	output reg [31:0] OUT1, OUT2;
// 	// End port declaration

// 	// Declare 8x8 register as vector
// 	reg [31:0] regFile [0:31];

//     integer i;

// 	// Execute the following block when rising edge of CLK
// 	always@(posedge CLK)
// 	begin
// 		// Reset the register if the RESET signal is high
// 		if ( RESET == 1 )
// 		begin

// 			// Write 0 for all registers
// 			for ( i = 0; i < 32; i = i + 1)
// 			begin
// 				regFile[i] = 32'b0;
// 			end
// 		end
		
// 		// If the WRITE signal is high and RESET signal is low, write the given input data(IN) into related register(the register given by INADDRESS)
// 		else if ( WRITE == 1)
// 		begin
// 			// Write the register with 1 time unit delay
// 			#1 regFile[INADDRESS] = IN;
// 		end
// 	end

// 	// If any of varible is changed assign relavant values from the registers to the OUT1 and OUT2
// 	always@(*)
// 	begin
// 		#2
// 		OUT1 = regFile[OUT1ADDRESS];
// 		OUT2 = regFile[OUT2ADDRESS];
// 	end

// 	// initial
// 	// begin
// 	// 	$dumpfile("cpu_wavedata_with_regFile.vcd");
// 	// 	for(i = 0; i < 32; i = i + 1)
// 	// 	begin
// 	// 		$dumpvars(1,regFile[i]);
// 	// 	end
// 	// end
// endmodule
=======
	initial
	begin
		$dumpfile("cpu_wavedata_with_regFile.vcd");
		for(i = 0; i < 32; i = i + 1)
		begin
			$dumpvars(1,regFile[i]);
		end
	end
endmodule
>>>>>>> e57e5ab14690bca5a698533f7eabe64fe8b3ea2a
