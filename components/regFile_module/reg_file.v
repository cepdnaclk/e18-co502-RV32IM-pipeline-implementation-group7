module reg_file(
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

	// Begin port declaration
	// Inputs	
	input [31:0] IN;
	input [4:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
	input WRITE, CLK, RESET; // Wires

	// Outputs
	output reg [31:0] OUT1, OUT2;
	// End port declaration

	// Declare 8x8 register as vector
	reg [31:0] regFile [0:31];

    integer i;

	// Execute the following block when rising edge of CLK
	always@(posedge CLK)
	begin
		// Reset the register if the RESET signal is high
		if ( RESET == 1 )
		begin

			// Write 0 for all registers
			for ( i = 0; i < 32; i = i + 1)
			begin
				regFile[i] = 32'b0;
			end
		end
		
		// If the WRITE signal is high and RESET signal is low, write the given input data(IN) into related register(the register given by INADDRESS)
		else if ( WRITE == 1)
		begin
			// Write the register with 1 time unit delay
			#1 regFile[INADDRESS] = IN;
		end
	end

	// If any of varible is changed assign relavant values from the registers to the OUT1 and OUT2
	always@(*)
	begin
		#2
		OUT1 = regFile[OUT1ADDRESS];
		OUT2 = regFile[OUT2ADDRESS];
	end

	initial
	begin
		$dumpfile("cpu_wavedata_with_regFile.vcd");
		for(i = 0; i < 32; i = i + 1)
		begin
			$dumpvars(1,regFile[i]);
		end
	end
endmodule