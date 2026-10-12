`timescale 1ns / 1ps
module execute_cycle(
    input  wire clk, rst_n, RegWriteE, ALUSrcE, MemWriteE, BranchE, JumpE, JalrE, AUIPCE,
    input  wire [1:0]ResultSrcE,ForwardA_E, ForwardB_E,
    input  wire [3:0]ALUControlE,
    input  wire [2:0]funct3E,
    input  wire [4:0]RD_E,
    input  wire [31:0] PCE, PCPlus4E, ResultW, RD1_E, RD2_E, Imm_Ext_E,
    output wire  PCSrcE, RegWriteM, MemWriteM,
    output wire [1:0]  ResultSrcM,
    output wire [4:0]  RD_M,
    output wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM, PCTargetE, Imm_ExtM
);
    wire [31:0] Src_A_fwd, Src_A, Src_B_fwd, Src_B, ResultE;
    wire ZeroE, NegativeE;

    //Forwarding muxes 
    Mux_3_by_1 srca_mux (
        .a(RD1_E), .b(ResultW), .c(ALU_ResultM),
        .s(ForwardA_E), .d(Src_A_fwd)
    );
    // AUIPC: force Src_A = PC 
    Mux srca_final_mux (
        .a(Src_A_fwd), .b(PCE), .s(AUIPCE), .c(Src_A)
    );

    Mux_3_by_1 srcb_mux (
        .a(RD2_E), .b(ResultW), .c(ALU_ResultM),
        .s(ForwardB_E), .d(Src_B_fwd)
    );
    Mux alu_src_mux (
        .a(Src_B_fwd), .b(Imm_Ext_E), .s(ALUSrcE), .c(Src_B)
    );

    ALU alu (
        .A(Src_A), .B(Src_B), .Result(ResultE),
        .ALUControl(ALUControlE), .Zero(ZeroE), .Negative(NegativeE)
    );

    //  Branch comparator (uses pre-AUIPC forwarded A) 
    wire [31:0] br_diff = Src_A_fwd - Src_B_fwd;
    wire brEq = (br_diff == 32'h0);
    // Signed: if sign bits differ, sign of A decides; else sign of diff
    wire brLt = (Src_A_fwd[31] ^ Src_B_fwd[31]) ? Src_A_fwd[31] : br_diff[31];
    // Unsigned: A<B iff (A sign=0,B sign=1) or same-sign with diff[31]=1
    wire brLtU = (~Src_A_fwd[31] &  Src_B_fwd[31]) |
                 ((Src_A_fwd[31] ~^ Src_B_fwd[31]) & br_diff[31]);

    reg branch_taken;
    always @(*) begin
        case (funct3E)
            3'b000: branch_taken =  brEq;// BEQ
            3'b001: branch_taken = ~brEq;      // BNE
            3'b100: branch_taken =  brLt;     // BLT
            3'b101: branch_taken = ~brLt;      // BGE
            3'b110: branch_taken =  brLtU;    // BLTU
            3'b111: branch_taken = ~brLtU;  // BGEU
            default: branch_taken = 1'b0;
        endcase
    end

    assign PCSrcE = JumpE | (BranchE & branch_taken);

    // Branch/JAL/JALR target 
    wire [31:0] jalr_target  = (Src_A_fwd + Imm_Ext_E) & 32'hFFFF_FFFE;
    wire [31:0] other_target = PCE + Imm_Ext_E;
    assign PCTargetE = JalrE ? jalr_target : other_target;

    // EX/MEM pipeline register 
    reg RegWriteM_r, MemWriteM_r;
    reg  [1:0] ResultSrcM_r;
    reg  [4:0] RD_M_r;
    reg  [31:0] PCPlus4M_r, WriteDataM_r, ALU_ResultM_r, Imm_ExtM_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            RegWriteM_r <= 1'b0;
            MemWriteM_r <= 1'b0;
            ResultSrcM_r <= 2'b00;
            RD_M_r <= 5'h0;
            PCPlus4M_r <= 32'h0;
            WriteDataM_r <= 32'h0;
            ALU_ResultM_r<= 32'h0;
            Imm_ExtM_r <= 32'h0;
        end else begin
            RegWriteM_r <= RegWriteE;
            MemWriteM_r <= MemWriteE;
            ResultSrcM_r <= ResultSrcE;
            RD_M_r <= RD_E;
            PCPlus4M_r <= PCPlus4E;
            WriteDataM_r <= Src_B_fwd;   // store data (post-forward rs2)
            ALU_ResultM_r <= ResultE;
            Imm_ExtM_r <= Imm_Ext_E;
        end
    end

    assign RegWriteM = RegWriteM_r;
    assign MemWriteM = MemWriteM_r;
    assign ResultSrcM = ResultSrcM_r;
    assign RD_M = RD_M_r;
    assign PCPlus4M = PCPlus4M_r;
    assign WriteDataM = WriteDataM_r;
    assign ALU_ResultM = ALU_ResultM_r;
    assign Imm_ExtM = Imm_ExtM_r;
endmodule