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
        CLK = 1'b1;
        
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("reg_file_wavedata.vcd");
		$dumpvars(0, reg_file_tb);
        
        // assign values with time to input signals to see output 
        RESET = 1'b0;
        WRITE = 1'b0;
        
        #10
        RESET = 1'b1;
        OUT1ADDRESS = 5'd0;
        OUT2ADDRESS = 5'd4;
        
        #10
        RESET = 1'b0;
        
        #10
        INADDRESS = 4'd2;
        IN = 32'd95;
        WRITE = 1'b1;
        
        #10
        WRITE = 1'b0;
        
        #10
        OUT1ADDRESS = 5'd2;
        
        #10
        INADDRESS = 5'd1;
        IN = 32'd28;
        WRITE = 1'b1;
        OUT1ADDRESS = 5'd1;
        
        #10
        WRITE = 1'b0;
        
        #10
        INADDRESS = 5'd4;
        IN = 32'd6;
        WRITE = 1'b1;
        
        #10
        IN = 32'd15;
        WRITE = 1'b1;
        
        #10
        WRITE = 1'b0;
        
        #6
        INADDRESS = 5'd1;
        IN = 32'd50;
        WRITE = 1'b1;
        
        #5
        WRITE = 1'b0;
        
        #10
        $finish;
    end
    
    // clock signal generation
    always
        #8 CLK = ~CLK;
        

endmodule