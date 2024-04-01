module program_counter (output logic [31:0] PC, PCPlus4,
                        input logic [31:0] PCTarget, ALUResult,
                        input logic [1:0] PCSrc, 
                        input logic Reset, CLK);

// Internal wire for PCNext
logic [31:0] PCNext;

// Create PCPlus4
assign PCPlus4 = PC + 4;

// Multiplexer based on PCSrc
always_comb begin
    case (PCSrc)
        2'b00: PCNext = PCPlus4;
        2'b01: PCNext = PCTarget;
        2'b10: PCNext = ALUResult;
    endcase  
end

// Register to clock PCNext into PC with synchronous active-HIGH reset
always_ff @ (posedge CLK) begin
    if (Reset) PC <= 32'h00000000;
    else PC <= PCNext;
end

endmodule

