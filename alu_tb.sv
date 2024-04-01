`timescale 1ns/1ps
`include "alu.sv"

module alu_tb;

    // Inputs
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [2:0] ALUControl;

    // Outputs
    logic [31:0] ALUResult;
    logic Zero;

    // Instantiate the module under test
    alu dut (
        .ALUResult(ALUResult),
        .Zero(Zero),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl)
    );

    // Test stimulus
    initial begin
        $dumpfile("out/alu_tb.vcd"); // Dump variable changes in the vcd file
        $dumpvars(0, alu_tb); // Specifies which variables to dump in the vcd file
        $monitor("t = %3d, ALUControl=%b, SrcA=%h, SrcB=%h, ALUResult = %h, Zero = %b", 
                $time, ALUControl, SrcA, SrcB, ALUResult, Zero);

        SrcA = 32'h00000001;
        SrcB = 32'h00000002;
        ALUControl = 3'b000;
        
        #10;

        if(ALUResult == 32'h00000003 && Zero == 0)
            $display("ADD Test passed");
        else
            $display("ADD Test failed");

        SrcA = 32'h00000003;
        SrcB = 32'h00000002;
        ALUControl = 3'b001;

        #10;

        if(ALUResult == 32'h00000001 && Zero == 0)
            $display("SUB Test passed");
        else
            $display("SUB Test failed");

        SrcA = 32'h00000002;
        SrcB = 32'h00000003;
        ALUControl = 3'b001;

        #10;

        if(ALUResult == 32'hffffffff && Zero == 0)
            $display("SUB W/ NEG RESULT Test passed");
        else
            $display("SUB W/ NEG RESULT Test failed");

        SrcA = 32'h00000003;
        SrcB = 32'h00000002;
        ALUControl = 3'b010;

        #10;

        if(ALUResult == 32'h00000002 && Zero == 0)
            $display("AND Test passed");
        else
            $display("AND Test failed");

        SrcA = 32'h00000003;
        SrcB = 32'h00000002;
        ALUControl = 3'b011;

        #10;

        if(ALUResult == 32'h00000003 && Zero == 0)
            $display("OR Test passed");
        else
            $display("OR Test failed");

        SrcA = 32'h00000003;
        SrcB = 32'h00000002;
        ALUControl = 3'b100;

        #10;

        if(ALUResult == 32'h00000002 && Zero == 0)
            $display("B passthrough Test passed");
        else
            $display("B passthrough Test failed");

        SrcA = 32'h00000003;
        SrcB = 32'h00000002;
        ALUControl = 3'b101;

        #10;

        if(ALUResult == 32'h00000000 && Zero == 1) begin
            $display("SLT less than test passed");
            $display("Zero test passed");
        end else begin
            $display("SLT less than test failed");
            $display("Zero test failed");
        end

        SrcA = 32'h00000002;
        SrcB = 32'h00000003;
        ALUControl = 3'b101;

        #10;

        if(ALUResult == 32'h00000001 && Zero == 0)
            $display("SLT greater than passed");
        else
            $display("SLT greater than failed");

        $finish;
    end

endmodule