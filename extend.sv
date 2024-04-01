module extend (output logic [31:0] ImmExt,
                input logic [31:0] Instr,
                input logic [2:0] ImmSrc);

logic [11:0] ISlice_1;
logic [19:0] I_Extend;

logic [4:0] SSlice_1;
logic [6:0] SSlice_2;
logic [19:0] S_Extend;

logic [3:0] BSlice_1;
logic [5:0] BSlice_2;
logic BSlice_3;
logic BSlice_4;
logic [22:0] B_Extend;

logic [9:0] JSlice_1;
logic JSlice_2;
logic [7:0] JSlice_3;
logic JSlice_4;
logic [20:0] J_Extend;

logic [19:0] USlice_1;

assign ISlice_1 = Instr[31:20];
assign I_Extend = {20{Instr[31]}};

assign SSlice_1 = Instr[11:7];
assign SSlice_2 = Instr[31:25];
assign S_Extend = {20{Instr[31]}};

assign BSlice_1 = Instr[11:8];
assign BSlice_2 = Instr[30:25];
assign BSlice_3 = Instr[7];
assign BSlice_4 = Instr[31];
assign B_Extend = {23{Instr[31]}};

assign JSlice_1 = Instr[30:21];
assign JSlice_2 = Instr[20];
assign JSlice_3 = Instr[19:12];
assign JSlice_4 = Instr[21];
assign J_Extend = {20{Instr[21]}};

assign USlice_1 = Instr[31:12];

// Implement decoding for the 6 RISC-V instructions that use immediate values
always_comb begin
    case (ImmSrc)
        // R-Type is a do not care so can be excluded
        3'b000: ImmExt = {I_Extend, ISlice_1}; // I-type
        3'b001: ImmExt = {S_Extend, SSlice_2, SSlice_1}; // S-type
        3'b010: ImmExt = {B_Extend, BSlice_4, BSlice_3, BSlice_2, BSlice_1, 1'b0}; // B-type
        3'b011: ImmExt = {J_Extend, JSlice_4, JSlice_3, JSlice_2, JSlice_1, 1'b0}; // J-type
        3'b100: ImmExt = {USlice_1, 12'h000}; // U-type
        default: ImmExt = 32'h00000000;
    endcase
end

endmodule