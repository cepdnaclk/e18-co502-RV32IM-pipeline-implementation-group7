`include "functions.v"	// Include module function

module alu(DATA1, DATA2, RESULT, ZERO, SELECT);

	// Begin port declaration
	input [31:0] DATA1, DATA2;
	input [31:0] SELECT;
	
	output reg [31:0] RESULT;
	output reg ZERO;

	// End port declaration

	// Create separate buses for the outputs from different functions
	wire [31:0] forward_RESULT, add_RESULT, and_RESULT, or_RESULT, shift_RESULT;

	// Create instances of functions(operations)
	FORWARD forward_(DATA2, forward_RESULT);
	ADD add_(DATA1, DATA2, add_RESULT);
	AND and_(DATA1, DATA2, and_RESULT);
	OR or_(DATA1, DATA2, or_RESULT);
	shiftUnit shiftUnit_(DATA1, DATA2, shift_RESULT);

	// If any of input is changed excute the below block
	always@(*)
	begin
		case (SELECT)
			3'b000 : // If the SELECT opereation is FORWARD
			begin
				RESULT = forward_RESULT;
			end

			3'b001 : // If the SELECT opereation is ADD
			begin
				RESULT = add_RESULT;
			end

			3'b010 : // If the SELECT operation is AND
			begin
				RESULT = and_RESULT;
			end

			3'b011 : // If the SELECT operation is OR
			begin
				RESULT = or_RESULT;
			end

			3'b100 : // If the SELECT operation is mult
			begin
			end

			// 3'b101 : // If the SELECT operation is srl or sll
			// begin
			// 	RESULT = shift_RESULT;
			// end
		endcase
	end

	always @(RESULT)
	begin
		if ( RESULT == 8'h00)
		begin
			ZERO = 1'b1;
		end
		else
		begin
			ZERO = 1'b0;
		end
	end
endmodule