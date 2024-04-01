`timescale 1ns/1ps
`include "extend.sv"

module extend_tb;

  // Inputs
  logic [31:0] Instr;
  logic [2:0] ImmSrc;

  // Outputs
  logic [31:0] ImmExt;

  // Instantiate the extend module
  extend dut (
    .Instr(Instr),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
  );

  // Test stimulus
  initial begin

    $dumpfile("out/extend_tb.vcd"); // Dump variable changes in the vcd file
    $dumpvars(0, extend_tb); // Specifies which variables to dump in the vcd file
    $monitor("t = %3d, ImmSrc = %b, ImmExt = %b", $time, ImmSrc, ImmExt);

    // Test case 1: I-type
    Instr = 32'h12345678;
    ImmSrc = 3'b000;

    #10;

    if(ImmExt == 32'h00000123)
        $display("I-type Test passed");
    else
        $display("I-type Test failed");
    
    ImmSrc = 3'b001;

    #10;

    if(ImmExt == 32'b0000_0000_0000_0000_0000_000100101100)
        $display("S-type Test passed");
    else
        $display("S-type Test failed");

    ImmSrc = 3'b010;

    #10;

    if(ImmExt == 32'b0000_0000_0000_0000_000_0000100101100)
        $display("B-type Test passed");
    else
        $display("B-type Test failed");
    
    ImmSrc = 3'b011;

    #10;

    if(ImmExt == 32'b1111_1111_111_101000101100100100010)
        $display("J-type Test passed");
    else
        $display("J-type Test failed");
    
    ImmSrc = 3'b100;

    #10;

    if(ImmExt == 32'b00010010001101000101_0000_0000_0000)
        $display("U-type Test passed");
    else
        $display("U-type Test failed");

    $finish;
  end

endmodule