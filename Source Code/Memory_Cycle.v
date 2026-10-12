`timescale 1ns / 1ps
module memory_cycle(
    input  wire clk, rst_n,RegWriteM, MemWriteM,
    input  wire [1:0]ResultSrcM,
    input  wire [4:0]RD_M,
    input  wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM, Imm_ExtM,
    output wire RegWriteW,
    output wire [1:0]ResultSrcW,
    output wire [4:0]RD_W,
    output wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW, Imm_ExtW
);
    wire [31:0] ReadDataM;
    Data_Memory dmem (
        .clk(clk), .rst_n(rst_n), .WE(MemWriteM),
        .A(ALU_ResultM), .WD(WriteDataM), .RD(ReadDataM)
    );

    reg RegWriteM_r;
    reg [1:0] ResultSrcM_r;
    reg [4:0] RD_M_r;
    reg [31:0] PCPlus4M_r, ALU_ResultM_r, ReadDataM_r, Imm_ExtM_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            RegWriteM_r   <= 1'b0;
            ResultSrcM_r  <= 2'b00;
            RD_M_r        <= 5'h0;
            PCPlus4M_r    <= 32'h0;
            ALU_ResultM_r <= 32'h0;
            ReadDataM_r   <= 32'h0;
            Imm_ExtM_r    <= 32'h0;
        end else begin
            RegWriteM_r   <= RegWriteM;
            ResultSrcM_r  <= ResultSrcM;
            RD_M_r        <= RD_M;
            PCPlus4M_r    <= PCPlus4M;
            ALU_ResultM_r <= ALU_ResultM;
            ReadDataM_r   <= ReadDataM;
            Imm_ExtM_r    <= Imm_ExtM;
        end
    end

    assign RegWriteW   = RegWriteM_r;
    assign ResultSrcW  = ResultSrcM_r;
    assign RD_W        = RD_M_r;
    assign PCPlus4W    = PCPlus4M_r;
    assign ALU_ResultW = ALU_ResultM_r;
    assign ReadDataW   = ReadDataM_r;
    assign Imm_ExtW    = Imm_ExtM_r;
endmodule