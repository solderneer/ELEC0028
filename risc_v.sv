`include "instruction_memory.sv"
`include "reg_file.sv"
`include "extend.sv"
`include "alu.sv"
`include "data_memory_and_io.sv"
`include "program_counter.sv"
`include "control_unit.sv"

module risc_v(output logic [31:0] CPUOut,
                input logic [31:0] CPUIn,
                input logic Reset, CLK);

logic [31:0] Instr, WD3, RD1, RD2, SrcA, SrcB, ALUResult, Result, WD, RD, ImmExt, PCTarget, PCNext, PC, PCPlus4;
logic [4:0]  A1, A2, A3;
logic        MemWrite, ALUSrc, RegWrite, Zero;
logic [2:0]  ALUControl;
logic [2:0]  ImmSrc;
logic [1:0]  ResultSrc;
logic [1:0]  PCSrc;

// Enter your code here

// Initialize program_counter
program_counter prog_counter(
    .PC(PC),
    .PCPlus4(PCPlus4),
    .PCTarget(PCTarget),
    .ALUResult(ALUResult),
    .PCSrc(PCSrc),
    .Reset(Reset),
    .CLK(CLK)
);

// Instruction Memory
instruction_memory im (
    .Instr(Instr),
    .PC(PC)
);

// Control Unit
control_unit cu (
    .ALUControl(ALUControl),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ResultSrc(ResultSrc),
    .PCSrc(PCSrc),
    .Instr(Instr),
    .Zero(Zero)
);

// Wire reg file
assign A1 = Instr[19:15];
assign A2 = Instr[24:20];
assign A3 = Instr[11:7];

assign WD3 = Result;
reg_file rf (
    .RD1(RD1),
    .RD2(RD2),
    .WD3(WD3),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .WE3(RegWrite),
    .CLK(CLK)
);

// Extend
extend ex(
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt),
    .Instr(Instr)
);

// ALU
assign SrcA = RD1;
assign SrcB = (ALUSrc) ? ImmExt : RD2;
alu alu_unit(
    .ALUControl(ALUControl),
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

// Create PCTarget
assign PCTarget = PC + ImmExt;

// Data Memory and IO
assign WD = RD2;
data_memory_and_io dmio(
    .RD(RD),
    .WD(WD),
    .WE(MemWrite),
    .A(ALUResult),
    .CLK(CLK),
    .CPUIn(CPUIn),
    .CPUOut(CPUOut)
);

// Result multiplexer
always_comb begin
    case (ResultSrc)
        2'b00: Result = ALUResult;
        2'b01: Result = RD;
        2'b10: Result = PCPlus4;
        2'b11: Result = ALUResult;
    endcase
end


endmodule

