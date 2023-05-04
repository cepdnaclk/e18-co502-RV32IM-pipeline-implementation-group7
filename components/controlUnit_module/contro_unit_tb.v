// Computer Architecture (CO224) - Lab 05
// Design: Register File of Simple Processor
// Author: Kisaru Liyanage

`include "control_unit.v"

module control_unit_tb;
    
    reg [31:0] INSTRUCTION;

    wire OP1_SEL, OP2_SEL, REG_WRITE_EN;
	wire [3:0] IMM_SEL;
    wire [3:0] BR_SEL;
    wire [4:0] ALU_OP;
    wire [2:0] MEM_WRITE;
    wire [3:0] MEM_READ;
    wire [1:0] REG_WRITE_SEL;
    
    control_unit mycontrol_unit(INSTRUCTION, OP1_SEL, OP2_SEL, REG_WRITE_EN, IMM_SEL, BR_SEL, ALU_OP, MEM_WRITE, MEM_READ, REG_WRITE_SEL);
       
    initial
    begin
        CLK = 1'b1;
        
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("reg_file_wavedata.vcd");
		$dumpvars(0, control_unit_tb);

        $finish;
    end
    
    // clock signal generation
    always
        #8 CLK = ~CLK;
        

endmodule