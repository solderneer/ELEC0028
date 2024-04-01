`timescale 1ns/1ps
`include "program_counter.sv"

module program_counter_tb;

  // Inputs
  logic [31:0] PCTarget;
  logic [31:0] ALUResult;
  logic [1:0] PCSrc;
  logic Reset;
  logic CLK;

  // Outputs
  logic [31:0] PC;
  logic [31:0] PCPlus4;

  // Instantiate the module under test
  program_counter dut (
    .PC(PC),
    .PCPlus4(PCPlus4),
    .PCTarget(PCTarget),
    .ALUResult(ALUResult),
    .PCSrc(PCSrc),
    .Reset(Reset),
    .CLK(CLK)
  );

  // Clock generator
  always begin
    CLK = 0;
    #5;
    CLK = 1;
    #5;
  end

  // Test stimulus
  initial begin

    $dumpfile("out/program_counter_tb.vcd"); // Dump variable changes in the vcd file
    $dumpvars(0, program_counter_tb); // Specifies which variables to dump in the vcd file
    $monitor("t = %3d, PC = %h, PCPlus4 = %h", $time, PC, PCPlus4);
    
    // Initialization test
    Reset = 1;
    PCTarget = 32'h00000000;
    ALUResult = 32'h00000000;
    PCSrc = 2'b00;

    #10;

    if(PC == 32'h00000000 && PCPlus4 == 32'h00000004)
        $display("Initialization Test passed");
    else
        $display("Initialization Test failed");

    // Plus 4 test
    Reset = 0;

    #10;

    if(PC == 32'h00000004 && PCPlus4 == 32'h00000008)
        $display("Plus 4 Test passed");
    else
        $display("Plus 4 Test failed");

    // Set PCTarget
    Reset = 0;
    PCTarget = 32'h0000000F;
    ALUResult = 32'h00000000;
    PCSrc = 2'b01;

    #10;

    if(PC == 32'h0000000F && PCPlus4 == 32'h00000013)
        $display("Set PCTarget Test passed");
    else
        $display("Set PCTarget Test failed");

    // Set ALUResult
    Reset = 0;
    PCTarget = 32'h00000000;
    ALUResult = 32'h000000FF;
    PCSrc = 2'b10;

    #10;

    if(PC == 32'h000000FF && PCPlus4 == 32'h00000103)
        $display("Set ALUResult Test passed");
    else
        $display("Set ALUResult Test failed");

    // Reset test
    Reset = 1;
    PCTarget = 32'h00000000;
    ALUResult = 32'h00000000;
    PCSrc = 2'b00;

    #10;

    if(PC == 32'h00000000 && PCPlus4 == 32'h00000004)
        $display("Reset Test passed");
    else
        $display("Reset Test failed");

    $finish;
  end

endmodule