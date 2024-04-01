`timescale 1ns/1ps
`include "control_unit.sv"

module control_unit_tb;

  // Inputs
  logic [31:0] Instr;
  logic Zero;

  // Outputs
  logic [1:0] PCSrc;
  logic [1:0] ResultSrc;
  logic MemWrite, ALUSrc, RegWrite;
  logic [2:0] ALUControl;
  logic [2:0] ImmSrc;

  // Instantiate the control_unit module
  control_unit dut (
    .PCSrc(PCSrc),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUControl(ALUControl),
    .ImmSrc(ImmSrc),
    .Instr(Instr),
    .Zero(Zero)
  );


  // Test stimulus
  initial begin

    $dumpfile("out/control_unit_tb.vcd"); // Dump variable changes in the vcd file
    $dumpvars(0, control_unit_tb); // Specifies which variables to dump in the vcd file
    $monitor("t = %3d, PCSrc = %b, ResultSrc = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b, ALUControl = %b, ImmSrc = %b", 
              $time, PCSrc, ResultSrc, MemWrite, ALUSrc, RegWrite, ALUControl, ImmSrc);

    Instr = 32'h00000033;
    Zero = 0;

    #10;
    
    $display("Test case 1: R-type instruction (add)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 0 || RegWrite != 1 || ALUControl != 3'b000 || ImmSrc != 3'b000)
      $display("Test case 1 failed");
    else
      $display("Test case 1 passed");

    Instr = {4'b0100, 28'h0000033};
    Zero = 0;

     #10;

    $display("%b", Instr[31:25]);

    $display("Test case 2: R-type instruction (sub)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 0 || RegWrite != 1 || ALUControl != 3'b001 || ImmSrc != 3'b000)
      $display("Test case 2 failed");
    else
      $display("Test case 2 passed");

    Instr = 32'h00007033;
    Zero = 0;

    #10;

    $display("Test case 3: R-type instruction (and)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 0 || RegWrite != 1 || ALUControl != 3'b010 || ImmSrc != 3'b000)
      $display("Test case 3 failed");
    else
      $display("Test case 3 passed");

    Instr = 32'h00006033;
    Zero = 0;

    #10;

    $display("Test case 4: R-type instruction (or)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 0 || RegWrite != 1 || ALUControl != 3'b011 || ImmSrc != 3'b000)
      $display("Test case 4 failed");
    else
      $display("Test case 4 passed");

    Instr = 32'h00002033;
    Zero = 0;

    #10;

    $display("Test case 5: R-type instruction (slt)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 0 || RegWrite != 1 || ALUControl != 3'b101 || ImmSrc != 3'b000)
      $display("Test case 5 failed");
    else
      $display("Test case 5 passed");

    Instr = 32'h00000013;
    Zero = 0;

    #10;

    $display("Test case 6: I-type instruction (addi)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 1 || RegWrite != 1 || ALUControl != 3'b000 || ImmSrc != 3'b000)
      $display("Test case 6 failed");
    else
      $display("Test case 6 passed");

    Instr = 32'h00006013;
    Zero = 0;

    #10;

    $display("Test case 7: I-type instruction (ori)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 1 || RegWrite != 1 || ALUControl != 3'b011 || ImmSrc != 3'b000)
      $display("Test case 7 failed");
    else
      $display("Test case 7 passed");

    Instr = 32'h00007013;
    Zero = 0;

    #10;

    $display("Test case 8: I-type instruction (andi)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 1 || RegWrite != 1 || ALUControl != 3'b010 || ImmSrc != 3'b000)
      $display("Test case 6 failed");
    else
      $display("Test case 6 passed");

    Instr = 32'h00002003;
    Zero = 0;

    #10;

    $display("Test case 7: I-type instruction (lw)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b01 || MemWrite != 0 || ALUSrc != 1 || RegWrite != 1 || ALUControl != 3'b000 || ImmSrc != 3'b000)
      $display("Test case 7 failed");
    else
      $display("Test case 7 passed");

    Instr = 32'h00002023;
    Zero = 0;

    #10;

    $display("Test case 8: S-type instruction (sw)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 1 || ALUSrc != 1 || RegWrite != 0 || ALUControl != 3'b000 || ImmSrc != 3'b001)
      $display("Test case 8 failed");
    else
      $display("Test case 8 passed");

    Instr = 32'h00000063;
    Zero = 0;

    #10;

    $display("Test case 9: B-type instruction (beq), Zero = 0");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 0 || RegWrite != 0 || ALUControl != 3'b001 || ImmSrc != 3'b010)
      $display("Test case 9 failed");
    else
      $display("Test case 9 passed");

    Instr = 32'h00000063;
    Zero = 1;

    #10;

    $display("Test case 10: B-type instruction (beq), Zero = 1");
    if (PCSrc != 2'b01 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 0 || RegWrite != 0 || ALUControl != 3'b001 || ImmSrc != 3'b010)
      $display("Test case 10 failed");
    else
      $display("Test case 10 passed");

    Instr = 32'h0000006F;
    Zero = 1;

    #10;

    $display("Test case 11: J-type instruction (jal)");
    if (PCSrc != 2'b01 || ResultSrc != 2'b10 || MemWrite != 0 || ALUSrc != 0 || RegWrite != 1 || ALUControl != 3'b000 || ImmSrc != 3'b011)
      $display("Test case 11 failed");
    else
      $display("Test case 11 passed");

    Instr = 32'h00000067;
    Zero = 1;

    #10;

    $display("Test case 12: J-type instruction (jalr)");
    if (PCSrc != 2'b10 || ResultSrc != 2'b10 || MemWrite != 0 || ALUSrc != 1 || RegWrite != 1 || ALUControl != 3'b000 || ImmSrc != 3'b000)
      $display("Test case 12 failed");
    else
      $display("Test case 12 passed");

    Instr = 32'h00000037;
    Zero = 1;

    #10;

    $display("Test case 13: U-type instruction (lui)");
    if (PCSrc != 2'b00 || ResultSrc != 2'b00 || MemWrite != 0 || ALUSrc != 1 || RegWrite != 1 || ALUControl != 3'b100 || ImmSrc != 3'b100)
      $display("Test case 13 failed");
    else
      $display("Test case 13 passed");

    Instr = 32'h002080B3;
    Zero = 1;

    #10;


    $finish;
  end

endmodule