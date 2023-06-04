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

    //writting the values to a register
    //this runs only on positive clock edges
    always @ (posedge CLK) begin
        //resetting the registers
        //if the reset = 1, then all the registers are set to 0
        if (RESET)
        begin  
            #1 for (i = 0; i < 32; i = i + 1)
                REGISTER[i] = 32'd0;
        end
        //if the write = 1 and reset = 0, the given register will be written with the given value
        if (WRITE & !RESET) 
        begin
            #1 REGISTER[INADDRESS] = IN;
        end
    end

	initial
	begin
		$dumpfile("simulation.vcd");
		for(i = 0; i < 32; i = i + 1)
		begin
			$dumpvars(1, REGISTER[i]);
		end
	end
endmodule
