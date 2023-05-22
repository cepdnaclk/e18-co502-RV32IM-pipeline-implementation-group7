module if_id_pipeline_reg(
    input [31:0] in_instruction, // Input instruction from instruction memory
    input [31:0] in_pc, // Input program counter value from program counter module
    output reg [31:0] out_instruction, // Output instruction to decode stage
    output reg [31:0] out_pc, // Output program counter value to program counter module
    input clk, // Clock signal
    input reset, // Reset signal
    input busy_wait // Stall signal to hold pipeline stage
);

    // RESET output registers on active reset
    always @(*) begin
        if (reset) begin
            #1; // Delay to allow reset signal to settle
            out_instruction = 32'dx; // Set out_instruction to 'x' value
            out_pc = 32'dx; // Set out_pc to 'x' value
        end
    end

    // Write input values to output registers on positive edge of clock signal
    always @(posedge clk) begin
        #0; // Delay to synchronize with other stages
        if (!busy_wait && !reset) begin
            out_instruction <= in_instruction; // Write in_instruction to out_instruction
            out_pc <= in_pc; // Write in_pc to out_pc
        end
    end

endmodule


// module if_id_pipeline_reg(
//     IN_INSTRUCTION, 
//     IN_PC, 
//     OUT_INSTRUCTION, 
//     OUT_PC, 
//     CLK, 
//     RESET, 
//     BUSYWAIT);

//     //declare the ports
//     input [31:0] IN_INSTRUCTION, IN_PC;
//     input CLK, RESET, BUSYWAIT;
//     output reg [31:0] OUT_INSTRUCTION, OUT_PC;

//     //RESETTING output registers
//     always @ (*) begin
//         if (RESET) begin
//             #1;
//             OUT_PC = 32'dx;
//             OUT_INSTRUCTION = 32'dx;
//         end
//     end

//     //Writing the input values to the output registers, 
//     //when the RESET is low and when the CLOCK is at a positive edge and BUSYWAIT is low 
//     always @(posedge CLK)
//     begin
//         #0;
//         if (!BUSYWAIT) begin
//             OUT_PC <= IN_PC;
//             OUT_INSTRUCTION <= IN_INSTRUCTION;
//         end
//     end

// endmodule

// module if_id_pipeline_reg(
//     input [31:0] instruction_in, // input instruction from instruction memory
//     input [31:0] pc_in, // input program counter value from program counter module
//     output reg [31:0] instruction_out, // output instruction to decode stage
//     output reg [31:0] pc_out, // output program counter value to program counter module
//     input clk, // clock signal
//     input reset, // reset signal
//     input busy_wait // stall signal to hold pipeline stage
// );

//     // RESET output registers on active reset
//     always @(*) begin
//         if (reset) begin
//             #1; // delay to allow reset signal to settle
//             instruction_out = 32'dx; // set instruction_out to 'x' value
//             pc_out = 32'dx; // set pc_out to 'x' value
//         end
//     end

//     // Write input values to output registers on positive edge of clock signal
//     always @(posedge clk) begin
//         #0; // delay to synchronize with other stages
//         if (!busy_wait && !reset) begin
//             instruction_out <= instruction_in; // write instruction_in to instruction_out
//             pc_out <= pc_in; // write pc_in to pc_out
//         end
//     end

// endmodule
