`timescale 1ns / 1ps
module decode_cycle(
    input  wire RegWriteW,clk, rst_n,FlushE,
    input  wire [31:0] InstrD, PCD, PCPlus4D, ResultW,      
    input  wire [4:0]  RDW,
    output wire UsesRs1D, UsesRs2D,
    output reg RegWriteE, ALUSrcE, MemWriteE,BranchE, JumpE, JalrE, AUIPCE,
    output reg  [1:0]  ResultSrcE,
    output reg  [3:0]  ALUControlE,
    output reg  [2:0]  funct3E,
    output reg  [31:0] RD1_E, RD2_E, Imm_Ext_E,
    output reg  [4:0]  RS1_E, RS2_E, RD_E,
    output reg  [31:0] PCE, PCPlus4E
);
    wire RegWriteD, ALUSrcD, MemWriteD, BranchD, JumpD, JalrD, AUIPCD;
    wire [1:0]  ResultSrcD;
    wire [2:0]  ImmSrcD;
    wire [3:0]  ALUControlD;
    wire [31:0] RD1_D, RD2_D, Imm_Ext_D;

    Control_Unit_Top control (
        .Op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .RegWrite(RegWriteD), .ALUSrc(ALUSrcD), .MemWrite(MemWriteD),
        .Branch(BranchD), .Jump(JumpD), .Jalr(JalrD), .AUIPC(AUIPCD),
        .UsesRs1(UsesRs1D), .UsesRs2(UsesRs2D),
        .ImmSrc(ImmSrcD), .ResultSrc(ResultSrcD),
        .ALUControl(ALUControlD)
    );

    Register_File rf (
        .clk(clk), .WE3(RegWriteW), .WD3(ResultW),
        .A1(InstrD[19:15]), .A2(InstrD[24:20]), .A3(RDW),
        .RD1(RD1_D), .RD2(RD2_D)
    );

    Sign_Extend ext (
        .In(InstrD), .ImmSrc(ImmSrcD), .Imm_Ext(Imm_Ext_D)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            RegWriteE <= 1'b0; ALUSrcE <= 1'b0; MemWriteE <= 1'b0;
            BranchE <= 1'b0; JumpE <= 1'b0; JalrE <= 1'b0; AUIPCE <= 1'b0;
            ResultSrcE <= 2'b00; ALUControlE <= 4'b0000; funct3E <= 3'b000;
            RD1_E <= 32'h0; RD2_E <= 32'h0; Imm_Ext_E <= 32'h0;
            RS1_E <= 5'h0; RS2_E <= 5'h0; RD_E <= 5'h0;
            PCE <= 32'h0; PCPlus4E <= 32'h0;
        end else if (FlushE) begin
            RegWriteE <= 1'b0; ALUSrcE <= 1'b0; MemWriteE <= 1'b0;
            BranchE <= 1'b0; JumpE <= 1'b0; JalrE <= 1'b0; AUIPCE <= 1'b0;
            ResultSrcE <= 2'b00; ALUControlE <= 4'b0000; funct3E <= 3'b000;
            RD1_E <= 32'h0; RD2_E <= 32'h0; Imm_Ext_E <= 32'h0;
            RS1_E <= 5'h0; RS2_E <= 5'h0; RD_E <= 5'h0;
            PCE <= 32'h0; PCPlus4E <= 32'h0;
        end else begin
            RegWriteE <= RegWriteD; ALUSrcE <= ALUSrcD; MemWriteE <= MemWriteD;
            BranchE <= BranchD; JumpE <= JumpD; JalrE <= JalrD; AUIPCE <= AUIPCD;
            ResultSrcE <= ResultSrcD; ALUControlE <= ALUControlD;
            funct3E <= InstrD[14:12];
            RD1_E <= RD1_D; RD2_E <= RD2_D; Imm_Ext_E <= Imm_Ext_D;
            RS1_E <= InstrD[19:15]; RS2_E <= InstrD[24:20]; RD_E <= InstrD[11:7];
            PCE <= PCD; PCPlus4E <= PCPlus4D;
        end
    end
endmodule