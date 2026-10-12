`timescale 1ns / 1ps
module Pipeline_top(
    input  wire clk,rst_n,
    output wire[15:0] Result_Debug,
    output wire[31:0] Instr_Debug, PC_Debug,        
    output wire RegWrite_Debug   
);
    wire PCSrcE,RegWriteE, ALUSrcE, MemWriteE, BranchE, JumpE, JalrE, AUIPCE,
    RegWriteM, MemWriteM, RegWriteW,StallF, StallD, FlushD, FlushE;
    wire [1:0]  ResultSrcE, ResultSrcM, ResultSrcW,ForwardAE, ForwardBE;
    wire [3:0]  ALUControlE;
    wire [2:0]  funct3E;
    wire UsesRs1D, UsesRs2D;

    wire [4:0]  RD_E, RD_M, RDW, RS1_E, RS2_E;
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D,RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E,
    PCPlus4M, WriteDataM, ALU_ResultM, Imm_ExtM,PCPlus4W, ALU_ResultW, ReadDataW, Imm_ExtW, 
    ResultW;

    wire [4:0]  Rs1_D = InstrD[19:15], Rs2_D = InstrD[24:20];
    wire ResultSrcE_load = (ResultSrcE == 2'b01);

    fetch_cycle Fetch (
        .clk(clk), .rst_n(rst_n),
        .StallF(StallF), .FlushD(FlushD),
        .PCSrcE(PCSrcE), .PCTargetE(PCTargetE),
        .InstrD(InstrD), .PCD(PCD), .PCPlus4D(PCPlus4D)
    );

    decode_cycle Decode (
        .clk(clk), .rst_n(rst_n), .FlushE(FlushE),
        .InstrD(InstrD), .PCD(PCD), .PCPlus4D(PCPlus4D),
        .RegWriteW(RegWriteW), .RDW(RDW), .ResultW(ResultW),
        .UsesRs1D(UsesRs1D), .UsesRs2D(UsesRs2D),
        .RegWriteE(RegWriteE), .ALUSrcE(ALUSrcE), .MemWriteE(MemWriteE),
        .BranchE(BranchE), .JumpE(JumpE), .JalrE(JalrE), .AUIPCE(AUIPCE),
        .ResultSrcE(ResultSrcE), .ALUControlE(ALUControlE), .funct3E(funct3E),
        .RD1_E(RD1_E), .RD2_E(RD2_E), .Imm_Ext_E(Imm_Ext_E),
        .RS1_E(RS1_E), .RS2_E(RS2_E), .RD_E(RD_E),
        .PCE(PCE), .PCPlus4E(PCPlus4E)
    );

    execute_cycle Execute (
        .clk(clk), .rst_n(rst_n),
        .RegWriteE(RegWriteE), .ALUSrcE(ALUSrcE), .MemWriteE(MemWriteE),
        .BranchE(BranchE), .JumpE(JumpE), .JalrE(JalrE), .AUIPCE(AUIPCE),
        .ResultSrcE(ResultSrcE), .ALUControlE(ALUControlE), .funct3E(funct3E),
        .RD_E(RD_E),
        .PCE(PCE), .PCPlus4E(PCPlus4E), .ResultW(ResultW),
        .RD1_E(RD1_E), .RD2_E(RD2_E), .Imm_Ext_E(Imm_Ext_E),
        .ForwardA_E(ForwardAE), .ForwardB_E(ForwardBE),
        .PCSrcE(PCSrcE), .PCTargetE(PCTargetE),
        .RegWriteM(RegWriteM), .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM), .RD_M(RD_M),
        .PCPlus4M(PCPlus4M), .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM), .Imm_ExtM(Imm_ExtM)
    );

    memory_cycle Memory (
        .clk(clk), .rst_n(rst_n),
        .RegWriteM(RegWriteM), .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM), .RD_M(RD_M),
        .PCPlus4M(PCPlus4M), .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM), .Imm_ExtM(Imm_ExtM),
        .RegWriteW(RegWriteW), .ResultSrcW(ResultSrcW),
        .RD_W(RDW),
        .PCPlus4W(PCPlus4W), .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW), .Imm_ExtW(Imm_ExtW)
    );

    writeback_cycle WriteBack (
        .clk(clk), .rst_n(rst_n),
        .ResultSrcW(ResultSrcW),
        .PCPlus4W(PCPlus4W), .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW), .Imm_ExtW(Imm_ExtW),
        .ResultW(ResultW)
    );

    hazard_unit Hazard (
        .rst_n(rst_n),
        .RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
        .RD_M(RD_M), .RD_W(RDW),
        .Rs1_E(RS1_E), .Rs2_E(RS2_E),
        .Rs1_D(Rs1_D), .Rs2_D(Rs2_D), .RD_E(RD_E),
        .UsesRs1D(UsesRs1D), .UsesRs2D(UsesRs2D),
        .ResultSrcE_load(ResultSrcE_load),
        .PCSrcE(PCSrcE),
        .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
        .StallF(StallF), .StallD(StallD),
        .FlushD(FlushD), .FlushE(FlushE)
    );

    assign Result_Debug    = ResultW[15:0];
    assign Instr_Debug     = InstrD;
    assign PC_Debug        = PCD;
    assign RegWrite_Debug  = RegWriteW;
endmodule