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
        

endmodule