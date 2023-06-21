`timescale  1ns/100ps

module Load_use_hazard_unit (
    input CLK,
    input RESET,
    input LOAD_SIG,
    input [4:0] MEM_Rd,
    input [4:0] ALU_RS1,
    input [4:0] ALU_RS2,
    output reg FRWD_RS1_WB,
    output reg FRWD_RS2_WB,
    output reg BUBBLE
);

wire [4:0] ALU_RS1_XNOR,ALU_RS2_XNOR;
wire RS1_COMPARING,RS2_COMPARING,BUBBLE_WR;

assign #1 ALU_RS1_XNOR=(MEM_Rd~^ALU_RS1);
assign #1 ALU_RS2_XNOR=(MEM_Rd~^ALU_RS2);
assign #1 RS1_COMPARING= (&ALU_RS1_XNOR);
assign #1 RS2_COMPARING= (&ALU_RS2_XNOR);
assign #1 BUBBLE_WR=RS1_COMPARING | RS2_COMPARING;

always @(posedge CLK) begin
    #1
    if (LOAD_SIG)
    begin
        FRWD_RS1_WB=RS1_COMPARING;
        FRWD_RS2_WB=RS2_COMPARING;
        BUBBLE=BUBBLE_WR;
    end
    else begin
        FRWD_RS1_WB=1'b0;
        FRWD_RS2_WB=1'b0;
        BUBBLE=1'b0;    
    end
    
end

always @(RESET) begin
    if (RESET) begin
        FRWD_RS1_WB=1'b0;
        FRWD_RS2_WB=1'b0;
        BUBBLE=1'b0;
    end
end
endmodule