`timescale 1ns / 1ps
module writeback_cycle(
    input  wire clk, rst_n,
    input  wire[1:0]  ResultSrcW,
    input  wire[31:0] PCPlus4W, ALU_ResultW, ReadDataW, Imm_ExtW,
    output wire [31:0] ResultW
);
    Mux_4_by_1 result_mux (
        .a(ALU_ResultW), .b(ReadDataW),
        .c(PCPlus4W),    .d(Imm_ExtW),
        .s(ResultSrcW),  .e(ResultW)
    );
endmodule