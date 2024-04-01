module alu (output logic [31:0] ALUResult,
            output logic Zero,
            input logic [31:0] SrcA, SrcB,
            input logic [2:0] ALUControl);

always_comb begin
    case (ALUControl)
        3'b000: ALUResult = SrcA + SrcB;
        3'b001: ALUResult = SrcA - SrcB;
        3'b010: ALUResult = SrcA & SrcB;
        3'b011: ALUResult = SrcA | SrcB;
        3'b100: ALUResult = SrcB;
        3'b101: ALUResult = (SrcA < SrcB) ? 32'h00000001 : 32'h00000000;
    endcase

    if (ALUResult == 32'h00000000) Zero = 1'b1;
    else Zero = 1'b0;
end
endmodule