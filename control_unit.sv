module control_unit (output logic [1:0] PCSrc, 
                    output logic [1:0] ResultSrc,
                    output logic MemWrite, ALUSrc, RegWrite,
                    output logic [2:0] ALUControl,
                    output logic [2:0] ImmSrc,
                    input logic [31:0] Instr,
                    input logic Zero);

// R-type instruction opcode
parameter [6:0] OPCODE_R = 7'b0110011;

// add instruction
parameter [2:0] FUNCT3_ADD = 3'h0;
parameter [6:0] FUNCT7_ADD = 7'h00;

// subtract instruction
parameter [2:0] FUNCT3_SUB = 3'h0;
parameter [6:0] FUNCT7_SUB = 7'h20;

// or instruction
parameter [2:0] FUNCT3_OR = 3'h6;
parameter [6:0] FUNCT7_OR = 7'h00;

// and instruction
parameter [2:0] FUNCT3_AND = 3'h7;
parameter [6:0] FUNCT7_AND = 7'h00;

// slt instruction
parameter [2:0] FUNCT3_SLT = 3'h2;
parameter [6:0] FUNCT7_SLT = 7'h00;

// I-type instruction opcode
parameter [6:0] OPCODE_I = 7'b0010011;

// addi instruction
parameter [2:0] FUNCT3_ADDI = 3'h0;

// ori instruction
parameter [2:0] FUNCT3_ORI = 3'h6;

// andi instruction
parameter [2:0] FUNCT3_ANDI = 3'h7;

// lw instruction
parameter [6:0] OPCODE_L = 7'b0000011;
parameter [2:0] FUNCT3_LW = 3'h2;

// sw instruction
parameter [6:0] OPCODE_S = 7'b0100011;
parameter [2:0] FUNCT3_SW = 3'h2;

// beq instruction
parameter [6:0] OPCODE_B = 7'b1100011;
parameter [2:0] FUNCT3_BEQ = 3'h0;

// jal instruction
parameter [6:0] OPCODE_JAL = 7'b1101111;

// jalr instruction
parameter [6:0] OPCODE_JALR = 7'b1100111;
parameter [2:0] FUNCT3_JALR = 3'h0;

// lui instruction
parameter [6:0] OPCODE_LUI = 7'b0110111;

// Split instruction into opcode, funct3 and funct7
logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;

assign opcode = Instr[6:0];
assign funct3 = Instr[14:12];
assign funct7 = Instr[31:25];

// Enter your code here
always_comb begin
    case (opcode)
        // R-type instructions
        OPCODE_R: begin
            case (funct3)
                FUNCT3_ADD: begin
                    case (funct7)
                        FUNCT7_ADD: begin
                            PCSrc = 2'b00;
                            ResultSrc = 2'b00;
                            MemWrite = 0;
                            ALUSrc = 0;
                            RegWrite = 1;
                            ALUControl = 3'b000;
                            ImmSrc = 3'b000;
                        end
                        FUNCT7_SUB: begin
                            PCSrc = 2'b00;
                            ResultSrc = 2'b00;
                            MemWrite = 0;
                            ALUSrc = 0;
                            RegWrite = 1;
                            ALUControl = 3'b001;
                            ImmSrc = 3'b000;
                        end
                    endcase
                end
                FUNCT3_AND: begin
                    PCSrc = 2'b00;
                    ResultSrc = 2'b00;
                    MemWrite = 0;
                    ALUSrc = 0;
                    RegWrite = 1;
                    ALUControl = 3'b010;
                    ImmSrc = 3'b000;
                end
                FUNCT3_OR: begin
                    PCSrc = 2'b00;
                    ResultSrc = 2'b00;
                    MemWrite = 0;
                    ALUSrc = 0;
                    RegWrite = 1;
                    ALUControl = 3'b011;
                    ImmSrc = 3'b000;
                end
                FUNCT3_SLT: begin
                    PCSrc = 2'b00;
                    ResultSrc = 2'b00;
                    MemWrite = 0;
                    ALUSrc = 0;
                    RegWrite = 1;
                    ALUControl = 3'b101;
                    ImmSrc = 3'b000;
                end
            endcase
        end
        OPCODE_I: begin
            case (funct3)
                FUNCT3_ADDI: begin
                    PCSrc = 2'b00;
                    ResultSrc = 2'b00;
                    MemWrite = 0;
                    ALUSrc = 1;
                    RegWrite = 1;
                    ALUControl = 3'b000;
                    ImmSrc = 3'b000;
                end
                FUNCT3_ORI: begin
                    PCSrc = 2'b00;
                    ResultSrc = 2'b00;
                    MemWrite = 0;
                    ALUSrc = 1;
                    RegWrite = 1;
                    ALUControl = 3'b011;
                    ImmSrc = 3'b000;
                end
                FUNCT3_ANDI: begin
                    PCSrc = 2'b00;
                    ResultSrc = 2'b00;
                    MemWrite = 0;
                    ALUSrc = 1;
                    RegWrite = 1;
                    ALUControl = 3'b010;
                    ImmSrc = 3'b000;
                end
            endcase
        end
        OPCODE_L: begin
            case (funct3)
                FUNCT3_LW: begin
                    PCSrc = 2'b00;
                    ResultSrc = 2'b01;
                    MemWrite = 0;
                    ALUSrc = 1;
                    RegWrite = 1;
                    ALUControl = 3'b000;
                    ImmSrc = 3'b000;
                end
            endcase
        end
        OPCODE_S: begin
            case (funct3)
                FUNCT3_SW: begin
                    PCSrc = 2'b00;
                    ResultSrc = 2'b00;
                    MemWrite = 1;
                    ALUSrc = 1;
                    RegWrite = 0;
                    ALUControl = 3'b000;
                    ImmSrc = 3'b001;
                end
            endcase
        end
        OPCODE_B: begin
            case (funct3)
                FUNCT3_BEQ: begin
                    PCSrc = {1'b0, Zero};
                    ResultSrc = 2'b00;
                    MemWrite = 0;
                    ALUSrc = 0;
                    RegWrite = 0;
                    ALUControl = 3'b001;
                    ImmSrc = 3'b010;
                end
            endcase
        end
        OPCODE_JAL: begin
            PCSrc = 2'b01;
            ResultSrc = 2'b10;
            MemWrite = 0;
            ALUSrc = 0;
            RegWrite = 1;
            ALUControl = 3'b000;
            ImmSrc = 3'b011;
        end
        OPCODE_JALR: begin
            case (funct3)
                FUNCT3_JALR: begin
                    PCSrc = 2'b10;
                    ResultSrc = 2'b10;
                    MemWrite = 0;
                    ALUSrc = 1;
                    RegWrite = 1;
                    ALUControl = 3'b000;
                    ImmSrc = 3'b000;
                end
            endcase
        end
        OPCODE_LUI: begin
            PCSrc = 2'b00;
            ResultSrc = 2'b00;
            MemWrite = 0;
            ALUSrc = 1;
            RegWrite = 1;
            ALUControl = 3'b100;
            ImmSrc = 3'b100;
        end
    default: begin
        PCSrc = 2'b00;
        ResultSrc = 2'b00;
        MemWrite = 0;
        ALUSrc = 0;
        RegWrite = 0;
        ALUControl = 3'b000;
        ImmSrc = 3'b000;
    end
    endcase
end

endmodule