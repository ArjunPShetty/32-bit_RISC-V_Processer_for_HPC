module execute_cycle(clk, rst,RegWriteE,ALUSrcE, MemWriteE, ResultSrcE,
BranchE, ALUControlE, RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE, PCPlus4E, PCSrcE, PCTargetE,
RegWriteM, MemWriteM,ResultSrcM,RD_M, PCPlus4M, WriteDataM, ALU_ResultM, ResultW,
ForwardA_E, ForwardB_E);

input clk, rst, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
output PCSrcE,RegWriteM, MemWriteM, ResultSrcM;
input [2:0] ALUControlE;
input [4:0] RD_E;
input [31:0] PCE, PCPlus4E,ResultW,RD1_E, RD2_E, Imm_Ext_E;
input [1:0] ForwardA_E, ForwardB_E;
output [4:0] RD_M;
output [31:0] PCPlus4M, WriteDataM, ALU_ResultM, PCTargetE;

wire [31:0] Src_A,Src_B_interim,Src_B,ResultE;
wire ZeroE;
reg RegWriteE_r,MemWriteE_r,ResultSrcE_r;
reg [4:0] RD_E_r;
reg [31:0] PCPlus4E_r,RD2_E_r,ResultE_r;

Mux_3_by_1 srca_mux (.a(RD1_E),.b(ResultW),.c(ALU_ResultM),.s(ForwardA_E),.d(Src_A));
Mux_3_by_1 srcb_mux (.a(RD2_E),.b(ResultW),.c(ALU_ResultM),.s(ForwardB_E),.d(Src_B_interim));
Mux alu_src_mux (.a(Src_B_interim),.b(Imm_Ext_E),.s(ALUSrcE),.c(Src_B));
ALU alu (.A(Src_A),.B(Src_B),.Result(ResultE),.ALUControl(ALUControlE),.OverFlow(),
        .Carry(),.Zero(ZeroE),.Negative()
        );
PC_Adder branch_adder (.a(PCE),.b(Imm_Ext_E),.c(PCTargetE));

assign PCSrcE = ZeroE & BranchE;
assign RegWriteM = RegWriteE_r;
assign MemWriteM = MemWriteE_r;
assign ResultSrcM = ResultSrcE_r;
assign RD_M = RD_E_r;
assign PCPlus4M = PCPlus4E_r;
assign WriteDataM = RD2_E_r;
assign ALU_ResultM = ResultE_r;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        RegWriteE_r  <= 1'b0;
        MemWriteE_r  <= 1'b0;
        ResultSrcE_r <= 1'b0;
        RD_E_r <= 5'h00;
        PCPlus4E_r <= 32'h00000000;
        RD2_E_r    <= 32'h00000000;
        ResultE_r  <= 32'h00000000;
    end
    else begin
        RegWriteE_r  <= RegWriteE;
        MemWriteE_r  <= MemWriteE;
        ResultSrcE_r <= ResultSrcE;
        RD_E_r <= RD_E;
        PCPlus4E_r <= PCPlus4E;
        RD2_E_r    <= Src_B_interim;
        ResultE_r  <= ResultE;
    end
end
endmodule