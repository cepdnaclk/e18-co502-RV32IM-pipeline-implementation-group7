`include "control_unit.v"


module control_unit_tb;

  // Parameters
  parameter WIDTH = 32;

  // Inputs
  reg [WIDTH-1:0] INSTRUCTION;
  reg RESET;

  // Outputs
  wire OP1_SEL;
  wire OP2_SEL;
  wire REG_WRITE_EN;
  wire [2:0] IMM_SEL;
  wire [3:0] BR_SEL;
  wire [4:0] ALU_OP;
  wire [2:0] MEM_WRITE;
  wire [3:0] MEM_READ;
  wire [1:0] REG_WRITE_SEL;

  // Instantiate the unit under test (UUT)
  control_unit UUT (
    .INSTRUCTION(INSTRUCTION),
    .RESET(RESET),
    .OP1_SEL(OP1_SEL),
    .OP2_SEL(OP2_SEL),
    .REG_WRITE_EN(REG_WRITE_EN),
    .IMM_SEL(IMM_SEL),
    .BR_SEL(BR_SEL),
    .ALU_OP(ALU_OP),
    .MEM_WRITE(MEM_WRITE),
    .MEM_READ(MEM_READ),
    .REG_WRITE_SEL(REG_WRITE_SEL)
  );

    // Define task for test case
    task run_test;
        input expected_op1_sel;
        input expected_op2_sel;
        input expected_reg_write_en;
        input [2:0] expected_imm_sel;
        input [3:0] expected_br_sel;
        input [4:0] expected_alu_op;
        input [2:0] expected_mem_write;
        input [3:0] expected_mem_read;
        input [1:0] expected_reg_write_sel;
        input [WIDTH-1:0] instruction;

        reg has_error;


        // Initialize inputs and reset signal
        begin
            INSTRUCTION = instruction;
            has_error = 1'b0;

            // Wait for a few cycles for the output to stabilize
            #5;
                if (OP1_SEL !== expected_op1_sel)
                begin
                    $error("Mismatch: OP1_SEL");
                    $display("Expected Value = %b, Actual Value = %b", expected_op1_sel, OP1_SEL);
                    has_error = 1'b1;
                end


                if (OP2_SEL !== expected_op2_sel)
                begin
                    $error("Mismatch: OP2_SEL");
                    $display("Expected Value = %b, Actual Value = %b", expected_op2_sel, OP2_SEL);
                    has_error = 1'b1;
                end


                if (REG_WRITE_EN !== expected_reg_write_en)
                begin
                    $error("Mismatch: REG_WRITE_EN");
                    $display("Expected Value = %b, Actual Value = %b", expected_reg_write_en, REG_WRITE_EN);
                    has_error = 1'b1;
                end


                if (IMM_SEL !== expected_imm_sel && INSTRUCTION[6:0] !== 7'b0110011)
                begin
                    $error("Mismatch: IMM_SEL");
                    $display("Expected Value = %b, Actual Value = %b", expected_imm_sel, IMM_SEL);
                    has_error = 1'b1;
                end


                if (BR_SEL[3] === expected_br_sel[3])
                begin
                    if(BR_SEL[3] === 1'b1 && BR_SEL[2:0] !== expected_br_sel[2:0])
                    begin
                        $error("Mismatch: BR_SEL");
                        $display("Expected Value = %b, Actual Value = %b", expected_br_sel, BR_SEL);
                        has_error = 1'b1;
                    end
                end
                else
                begin
                    $error("Mismatch: BR_SEL");
                    $display("Expected Value = %b, Actual Value = %b", expected_br_sel, BR_SEL);
                    has_error = 1'b1;
                end


                if (ALU_OP !== expected_alu_op)
                begin
                    $error("Mismatch: ALU_OP");
                    $display("Expected Value = %b, Actual Value = %b", expected_alu_op, ALU_OP);
                    has_error = 1'b1;
                end


                if (MEM_WRITE[2] === expected_mem_write[2])
                begin
                    if (MEM_WRITE[2] === 1'b1 && MEM_WRITE[1:0] !== expected_mem_write[1:0])
                    begin
                        $error("Mismatch: MEM_WRITE");
                        $display("Expected Value = %b, Actual Value = %b", expected_mem_write, MEM_WRITE);
                        has_error = 1'b1;
                    end
                end
                else
                begin
                    $error("Mismatch: MEM_WRITE");
                    $display("Expected Value = %b, Actual Value = %b", expected_mem_write, MEM_WRITE);
                    has_error = 1'b1;
                end


                if (MEM_READ[3] === expected_mem_read[3])
                begin
                    if(MEM_READ[3] === 1'b1 && MEM_READ[2:0] !== expected_mem_read[2:0])
                    begin
                        $error("Mismatch: MEM_READ");
                        $display("Expected Value = %b, Actual Value = %b", expected_mem_read, MEM_READ);
                        has_error = 1'b1;
                    end
                end
                else
                begin
                    $error("Mismatch: MEM_READ");
                    $display("Expected Value = %b, Actual Value = %b", expected_mem_read, MEM_READ);
                    has_error = 1'b1;
                end


                if (REG_WRITE_SEL !== expected_reg_write_sel)
                begin
                    $error("Mismatch: REG_WRITE_SEL");
                    $display("Expected Value = %b, Actual Value = %b", expected_reg_write_sel, REG_WRITE_SEL);
                    has_error = 1'b1;
                end


                if (has_error === 1'b0)
                    $display("Test Passed");
            #1;
        end
    endtask

    // Call task for each test case
    initial begin

        $dumpfile("simulation.vcd");  // Specify the name of the VCD file
        $dumpvars(0, control_unit_tb);

        #5; // delay 1st clk posedge
        #2; // delay instruction fetch

        // Test RV32I instructions

        $display("\nTest case 1(LUI)");
        run_test(1'b0, 1'b1, 1'b1, 3'b011, 4'b0000, 5'b11111, 3'b000, 4'b0000, 2'b01, 32'b00100000000100010000_00010_0110111);

        $display("\nTest case 2(AUIPC)");
        run_test(1'b1, 1'b1, 1'b1, 3'b011, 4'b0000, 5'b00000, 3'b000, 4'b0000, 2'b11, 32'b00100000000100010000_00010_0010111);

        $display("\nTest case 3(JAL)");
        run_test(1'b1, 1'b1, 1'b1, 3'b100, 4'b1010, 5'b00000, 3'b000, 4'b0000, 2'b11, 32'b00100000000100010000_00010_1101111);

        $display("\nTest case 4(JALR)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b1010, 5'b00000, 3'b000, 4'b0000, 2'b11, 32'b001000000001_00010_000_00010_1100111);
        
        $display("\nTest case 5(BEQ)");
        run_test(1'b1, 1'b1, 1'b0, 3'b010, 4'b1000, 5'b00010, 3'b0xx, 4'b0xxx, 2'b01, 32'b0010000_00001_00010_000_00010_1100011);
                
        $display("\nTest case 6(BNE)");
        run_test(1'b1, 1'b1, 1'b0, 3'b010, 4'b1001, 5'b00010, 3'b0xx, 4'b0xxx, 2'b01, 32'b0010000_00001_00010_001_00010_1100011);
                
        $display("\nTest case 7(BLT)");
        run_test(1'b1, 1'b1, 1'b0, 3'b010, 4'b1100, 5'b00010, 3'b0xx, 4'b0xxx, 2'b01, 32'b0010000_00001_00010_100_00010_1100011);
                
        $display("\nTest case 8(BGE)");
        run_test(1'b1, 1'b1, 1'b0, 3'b010, 4'b1101, 5'b00010, 3'b0xx, 4'b0xxx, 2'b01, 32'b0010000_00001_00010_101_00010_1100011);
                
        $display("\nTest case 9(BLTU)");
        run_test(1'b1, 1'b1, 1'b0, 3'b010, 4'b1110, 5'b00010, 3'b0xx, 4'b0xxx, 2'b01, 32'b0010000_00001_00010_110_00010_1100011);
                
        $display("\nTest case 10(BGEU)");
        run_test(1'b1, 1'b1, 1'b0, 3'b010, 4'b1111, 5'b00010, 3'b0xx, 4'b0xxx, 2'b01, 32'b0010000_00001_00010_111_00010_1100011);  
                        
        $display("\nTest case 11(LB)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b00000, 3'b0xx, 4'b1000, 2'b00, 32'b001000000001_00010_000_00010_0000011);
                                
        $display("\nTest case 12(LH)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b00000, 3'b0xx, 4'b1001, 2'b00, 32'b001000000001_00010_001_00010_0000011);   
                                
        $display("\nTest case 13(LW)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b00000, 3'b0xx, 4'b1010, 2'b00, 32'b001000000001_00010_010_00010_0000011);   
                                
        $display("\nTest case 14(LBU)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b00000, 3'b0xx, 4'b1100, 2'b00, 32'b001000000001_00010_100_00010_0000011);   
                                
        $display("\nTest case 15(LHU)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b00000, 3'b0xx, 4'b1101, 2'b00, 32'b001000000001_00010_101_00010_0000011);

        $display("\nTest case 16(SB)");
        run_test(1'b0, 1'b1, 1'b0, 3'b001, 4'b0xxx, 5'b00000, 3'b100, 4'b0xxx, 2'b01, 32'b0010000_00001_00010_000_00010_0100011);

        $display("\nTest case 17(SH)");
        run_test(1'b0, 1'b1, 1'b0, 3'b001, 4'b0xxx, 5'b00000, 3'b101, 4'b0xxx, 2'b01, 32'b0010000_00001_00010_001_00010_0100011);

        $display("\nTest case 18(SW)");
        run_test(1'b0, 1'b1, 1'b0, 3'b001, 4'b0xxx, 5'b00000, 3'b110, 4'b0xxx, 2'b01, 32'b0010000_00001_00010_010_00010_0100011);

        $display("\nTest case 19(ADDI)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b00000, 3'b0xx, 4'b0xxx, 2'b01, 32'b001000000001_00010_000_00010_0010011);

        $display("\nTest case 20(SLTI)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b001000, 3'b0xx, 4'b0xxx, 2'b01, 32'b001000000001_00010_010_00010_0010011);

        $display("\nTest case 21(SLTIU)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b01100, 3'b0xx, 4'b0xxx, 2'b01, 32'b001000000001_00010_011_00010_0010011);

        $display("\nTest case 22(XORI)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b10000, 3'b0xx, 4'b0xxx, 2'b01, 32'b001000000001_00010_100_00010_0010011);

        $display("\nTest case 23(ORI)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b11000, 3'b0xx, 4'b0xxx, 2'b01, 32'b001000000001_00010_110_00010_0010011);

        $display("\nTest case 24(ANDI)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b11100, 3'b0xx, 4'b0xxx, 2'b01, 32'b001000000001_00010_111_00010_0010011);

        $display("\nTest case 25(SLLI)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b00100, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_001_00010_0010011);

        $display("\nTest case 26(SRLI)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b10100, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_101_00010_0010011);

        $display("\nTest case 27(SRAI)");
        run_test(1'b0, 1'b1, 1'b1, 3'b000, 4'b0xxx, 5'b10110, 3'b0xx, 4'b0xxx, 2'b01, 32'b0100000_00001_00010_101_00010_0010011);

        $display("\nTest case 28(ADD)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b00000, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_000_00010_0110011);

        $display("\nTest case 29(SUB)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b00010, 3'b0xx, 4'b0xxx, 2'b01, 32'b0100000_00001_00010_000_00010_0110011);

        $display("\nTest case 30(SLL)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b00100, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_001_00010_0110011);

        $display("\nTest case 31(SLT)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b01000, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_010_00010_0110011);

        $display("\nTest case 32(SLTU)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b01100, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_011_00010_0110011);

        $display("\nTest case 33(XOR)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b10000, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_100_00010_0110011);

        $display("\nTest case 34(SRL)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b10100, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_101_00010_0110011);

        $display("\nTest case 35(SRA)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b10110, 3'b0xx, 4'b0xxx, 2'b01, 32'b0100000_00001_00010_101_00010_0110011);

        $display("\nTest case 36(OR)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b11000, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_110_00010_0110011);

        $display("\nTest case 37(AND)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b11100, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000000_00001_00010_111_00010_0110011);


        // Test extended M instructions


        $display("\nTest case 38(MUL)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b00001, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000001_00001_00010_000_00010_0110011);

        $display("\nTest case 39(MULH)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b00101, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000001_00001_00010_001_00010_0110011);

        $display("\nTest case 40(MULHSU)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b01101, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000001_00001_00010_010_00010_0110011);

        $display("\nTest case 41(MULHU)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b01001, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000001_00001_00010_011_00010_0110011);

        $display("\nTest case 41(DIV)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b10001, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000001_00001_00010_100_00010_0110011);

        $display("\nTest case 41(DIVU)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b10101, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000001_00001_00010_101_00010_0110011);

        $display("\nTest case 41(REM)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b11001, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000001_00001_00010_110_00010_0110011);

        $display("\nTest case 41(REMU)");
        run_test(1'b0, 1'b0, 1'b1, 3'bxxx, 4'b0xxx, 5'b11101, 3'b0xx, 4'b0xxx, 2'b01, 32'b0000001_00001_00010_111_00010_0110011);


        // Finish simulation
        #10 $finish;
    end

endmodule
