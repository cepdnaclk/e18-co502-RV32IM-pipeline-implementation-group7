module Alu_hazard_unit (
    input CLK,
    input RESET,
    input [4:0] DEST_MEM,
    input [4:0] DEST_ALU,
    input [4:0] RS1_ID, 
    input [4:0] RS2_ID, 
    output reg ENABLE_RS1_MEM_STAGE, 
    output reg ENABLE_RS2_MEM_STAGE, 
    output reg ENABLE_RS1_WB_STAGE, 
    output reg ENABLE_RS2_WB_STAGE
);

wire [4:0] ALU_RS1_XNOR,ALU_RS2_XNOR,MEM_RS1_XNOR,MEM_RS2_XNOR;
wire ALU_RS1_COMPARING,ALU_RS2_COMPARING,MEM_RS1_COMPARING,MEM_RS2_COMPARING;

assign #1 ALU_RS1_XNOR=(DEST_ALU~^RS1_ID);
assign #1 ALU_RS2_XNOR=(DEST_ALU~^RS2_ID);

assign #1 MEM_RS1_XNOR=(DEST_MEM~^RS1_ID);
assign #1 MEM_RS2_XNOR=(DEST_MEM~^RS2_ID);

assign #1 ALU_RS1_COMPARING= (&ALU_RS1_XNOR);
assign #1 ALU_RS2_COMPARING= (&ALU_RS2_XNOR);

assign #1 MEM_RS1_COMPARING= (&MEM_RS1_XNOR);
assign #1 MEM_RS2_COMPARING= (&MEM_RS2_XNOR);


always @(posedge CLK) begin
    #1
    ENABLE_RS1_MEM_STAGE=ALU_RS1_COMPARING;
    ENABLE_RS2_MEM_STAGE=ALU_RS2_COMPARING;

    ENABLE_RS1_WB_STAGE=MEM_RS1_COMPARING;
    ENABLE_RS2_WB_STAGE=MEM_RS2_COMPARING;
end

always @(RESET) begin
	if(RESET==1'b1) begin
        #1
        ENABLE_RS1_MEM_STAGE=1'b0;
        ENABLE_RS2_MEM_STAGE=1'b0;
        ENABLE_RS1_WB_STAGE=1'b0;
        ENABLE_RS2_WB_STAGE=1'b0;	                        
	end
end

    
endmodule