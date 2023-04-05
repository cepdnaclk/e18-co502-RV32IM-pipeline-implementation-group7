// Create FORWARD module
module FORWARD(DATA2, RESULT);
	input [7:0] DATA2;
	output [7:0] RESULT;
	
	assign #1 RESULT = DATA2;
endmodule


// Create FORWARD module
module ADD(DATA1, DATA2, RESULT);
	input [7:0] DATA1, DATA2;
	output [7:0] RESULT;
	
	assign #2 RESULT = (DATA1 + DATA2);
endmodule


// Create FORWARD module
module AND(DATA1, DATA2, RESULT);
	input [7:0] DATA1, DATA2;
	output [7:0] RESULT;
	
	assign #1 RESULT = (DATA1 & DATA2);
endmodule


// Create FORWARD module
module OR(DATA1, DATA2, RESULT);
	input [7:0] DATA1, DATA2;
	output [7:0] RESULT;
	
	assign #1 RESULT = (DATA1 | DATA2);
endmodule

// Define module shifter which shifts 1 bit
module shifter(IN2, IN1, IN0, S, L, R, OUT);
	input IN2, IN1, IN0, S, L, R;
	output OUT;

	and (OUT0, L, IN0);
	and (OUT1, S, IN1);
	and (OUT2, R, IN2);

	or (OUT, OUT0, OUT1, OUT2);
endmodule

// Define module shifter2 which shifts 1 bit with considering rotate and arithmatic
module shifter2(IN2, IN1, IN0, S, L, R, A, C, OUT);
	input IN2, IN1, IN0, S, L, R, A, C;
	output OUT;

	not (INV_C, C);

	and (OUT0, L, IN0);
	and (OUT1, S, IN1);
	and (OUT2, R, INV_C, A, IN1);
	and (OUT3, R, C, IN2);

	or (OUT, OUT0, OUT1, OUT2, OUT3);
endmodule

// Define decode2X4 which is a 2 to 4 demultiplexer
module decoder2X4(SHIFTOP, L, R, A, C);
	input [1:0] SHIFTOP;
	output L, R, A, C;

	not (A1, SHIFTOP[1]);
	not (A0, SHIFTOP[0]);

	and #1 (L, A1, A0);
	and #1 (R, A1, SHIFTOP[0]);
	and #1 (A,  SHIFTOP[1], A0);
	and #1 (C, SHIFTOP[1], SHIFTOP[0]);
endmodule

// Define common 4 Level shiftUnit for all sll, arl, sra and ror
module Level4_shifter(DATA, SHIFT, L, A, C, OUT);
	// begin port declaration
	input [7:0] DATA;
	input [3:0] SHIFT;
	input L, A, C;

	output [7:0] OUT;
	// end port declaraion

	wire [7:0] OUT1, OUT2, OUT3;

	wire [3:0] LS, RS, S;

	not ( R, L);

	and n_and_L [3:0] (LS, L, SHIFT);
	and n_and_R [3:0] (RS, R, SHIFT);
	not n_not [3:0] ( S, SHIFT);

	// Level 1
	shifter2 shifter0_7(DATA[0], DATA[7], DATA[6], S[0], LS[0], RS[0], A, C, OUT1[7]);
	shifter n_shifter0_6to1 [5:0] (DATA[7:2], DATA[6:1], DATA[5:0], S[0], LS[0], RS[0], OUT1[6:1]);
	shifter shifter0_0(DATA[1], DATA[0],    1'b0, S[0], LS[0], RS[0], OUT1[0]);

	// Level 2
	shifter2 shifter1_7(OUT1[1], OUT1[7], OUT1[5], S[1], LS[1], RS[1], A, C, OUT2[7]);
	shifter2 shifter1_6(OUT1[0], OUT1[6], OUT1[4], S[1], LS[1], RS[1], A, C, OUT2[6]);
	shifter n_shifter1_5to2 [3:0] (OUT1[7:4], OUT1[5:2], OUT1[3:0], S[1], LS[1], RS[1], OUT2[5:2]);
	shifter shifter1_1(OUT1[3], OUT1[1],    1'b0, S[1], LS[1], RS[1], OUT2[1]);
	shifter shifter1_0(OUT1[2], OUT1[0],    1'b0, S[1], LS[1], RS[1], OUT2[0]);

	// Level 3
	shifter2 n_shifter2_7to4 [3:0] (OUT2[3:0], OUT2[7:4], OUT2[3:0], S[2], LS[2], RS[2], A, C, OUT3[7:4]);
	shifter  n_shifter2_3to0 [3:0] (OUT2[7:4], OUT2[3:0],    1'b0, S[2], LS[2], RS[2], OUT3[3:0]);

	// Level 4
	shifter2 n_shifter3_7to0 [7:0] (OUT3, OUT3,   1'b0, S[3], LS[3], RS[3], A, C, OUT);
endmodule

// Define Shift unit
module shiftUnit(DATA1, DATA2, RESULT);
	input [7:0]	DATA1, DATA2;
	output [7:0]	RESULT;

	wire [3:0] SHIFT;
	wire L;
	
	// Decode SHIFTOP
	decoder2X4 decoder2X4_(DATA2[7:6], L_, R_, A, C);

	or (or_OUT, R_, A, C);
	not (not_OUT, or_OUT);
	and (L, L_, not_OUT);

	Level4_shifter Level4_shifter_(DATA1, DATA2[3:0], L, A, C, RESULT);
endmodule