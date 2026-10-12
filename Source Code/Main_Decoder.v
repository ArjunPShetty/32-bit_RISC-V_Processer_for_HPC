`timescale 1ns / 1ps
module Main_Decoder(
    input  wire [6:0] Op,
    output reg RegWrite, ALUSrc, MemWrite,Branch, Jump, Jalr, AUIPC, UsesRs1, UsesRs2,
    output reg  [2:0] ImmSrc,
    output reg  [1:0] ResultSrc, ALUOp
);
    always @(*) begin
        RegWrite  = 1'b0; ALUSrc   = 1'b0; MemWrite = 1'b0;
        Branch    = 1'b0; Jump     = 1'b0; Jalr     = 1'b0; AUIPC = 1'b0;
        UsesRs1   = 1'b0; UsesRs2  = 1'b0;
        ImmSrc    = 3'b000;
        ResultSrc = 2'b00;
        ALUOp     = 2'b00;

        case (Op)
            7'b0110011: begin // R-type
                RegWrite = 1'b1; UsesRs1 = 1'b1; UsesRs2 = 1'b1;
                ResultSrc = 2'b00; ALUOp = 2'b10;
            end
            7'b0010011: begin // I-type ALU
                RegWrite = 1'b1; ALUSrc = 1'b1; UsesRs1 = 1'b1;
                ImmSrc = 3'b000; ResultSrc = 2'b00; ALUOp = 2'b10;
            end
            7'b0000011: begin // LW
                RegWrite = 1'b1; ALUSrc = 1'b1; UsesRs1 = 1'b1;
                ImmSrc = 3'b000; ResultSrc = 2'b01; ALUOp = 2'b00;
            end
            7'b0100011: begin // SW
                ALUSrc = 1'b1; MemWrite = 1'b1; UsesRs1 = 1'b1; UsesRs2 = 1'b1;
                ImmSrc = 3'b001; ALUOp = 2'b00;
            end
            7'b1100011: begin // Branch
                Branch = 1'b1; UsesRs1 = 1'b1; UsesRs2 = 1'b1;
                ImmSrc = 3'b010; ALUOp = 2'b01;
            end
            7'b1101111: begin // JAL
                RegWrite = 1'b1; Jump = 1'b1;
                ImmSrc = 3'b011; ResultSrc = 2'b10;
            end
            7'b1100111: begin // JALR
                RegWrite = 1'b1; ALUSrc = 1'b1; Jump = 1'b1; Jalr = 1'b1;
                UsesRs1 = 1'b1;
                ImmSrc = 3'b000; ResultSrc = 2'b10;
            end
            7'b0110111: begin // LUI
                RegWrite = 1'b1;
                ImmSrc = 3'b100; ResultSrc = 2'b11;
            end
            7'b0010111: begin // AUIPC
                RegWrite = 1'b1; AUIPC = 1'b1; ALUSrc = 1'b1;
                ImmSrc = 3'b100; ResultSrc = 2'b00;
            end
            default: ;
        endcase
    end
endmodule
