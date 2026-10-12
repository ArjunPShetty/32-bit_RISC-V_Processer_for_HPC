`timescale 1ns / 1ps
module Control_Unit_Top(
    input  wire [6:0] Op, funct7,
    input  wire [2:0] funct3,
    output wire RegWrite, ALUSrc, MemWrite,Branch, Jump, Jalr, AUIPC, UsesRs1, UsesRs2,
    output wire [2:0] ImmSrc,
    output wire [1:0] ResultSrc,
    output wire [3:0] ALUControl
);
    wire [1:0] ALUOp;
    Main_Decoder main (
        .Op(Op), .RegWrite(RegWrite), .ALUSrc(ALUSrc), .MemWrite(MemWrite),
        .Branch(Branch), .Jump(Jump), .Jalr(Jalr), .AUIPC(AUIPC),
        .UsesRs1(UsesRs1), .UsesRs2(UsesRs2),
        .ImmSrc(ImmSrc), .ResultSrc(ResultSrc), .ALUOp(ALUOp)
    );

    ALU_Decoder alu_dec (
        .ALUOp(ALUOp), .funct3(funct3), .funct7(funct7),
        .op(Op), .ALUControl(ALUControl)
    );
endmodule