module Branch_hazard_unit (
    input [2:0] ID_pc,
    input [2:0] ALU_pc,
    input reset,
    input ID_stage_branch,
    input ALU_stage_branch,
    input ALU_stage_branch_result,
    output reg flush,
    output reg early_prediction_is_branch_taken,
    output reg signal_to_take_branch
);
reg  [1:0] prediction[0:7];


parameter BRANCH_TAKEN_strong = 2'b00, BRANCH_TAKEN_weak =2'b01, BRANCH_NOTTAKEN_weak =2'b10, BRANCH_NOTTAKEN_strong =2'b11;
integer i;
always @(reset) begin
    flush=1'b0;
    for (i =0 ;i<8 ;i++ ) begin
        prediction[i]=2'b00;
    end
end

always @(*) begin
    if (ALU_stage_branch) 
    begin
        case (prediction[ALU_pc])
            BRANCH_TAKEN_strong:
                if (ALU_stage_branch_result)
                begin
                    prediction[ALU_pc]=2'b00;
                    flush=1'b0;
                end
                else 
                begin
                    prediction[ALU_pc]=2'b01;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b1;
                end
            BRANCH_TAKEN_weak:
                if (ALU_stage_branch_result)
                begin
                    prediction[ALU_pc]=2'b00;
                    flush=1'b0;
                end
                else
                begin
                    prediction[ALU_pc]=2'b10;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b1;
                end
            BRANCH_NOTTAKEN_weak:
                if (ALU_stage_branch_result)
                begin
                    prediction[ALU_pc]=2'b01;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b0;
                end
                else
                begin
                    prediction[ALU_pc]=2'b11;
                    flush=1'b0;
                end
            BRANCH_NOTTAKEN_strong:
                if (ALU_stage_branch_result)
                begin
                    prediction[ALU_pc]=2'b10;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b0;
                end
                else 
                begin
                    prediction[ALU_pc]=2'b11;
                    flush=1'b0;
                end
        endcase   
    end
    else begin
        flush = 1'b0;
    end

    
end

//prediction
always @(*) begin
    if (ID_stage_branch) begin
        case (prediction[ID_pc])
            BRANCH_TAKEN_strong:
                signal_to_take_branch=1'b1;
            BRANCH_TAKEN_weak:
                signal_to_take_branch=1'b1;
            BRANCH_NOTTAKEN_weak:
                signal_to_take_branch=1'b0;
            BRANCH_NOTTAKEN_strong:
                signal_to_take_branch=1'b0;
        endcase   
    end
    else begin
        signal_to_take_branch=1'b0;
    end
end
    
endmodule
