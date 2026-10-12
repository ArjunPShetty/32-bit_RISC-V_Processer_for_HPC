`timescale 1ns / 1ps
module Data_Memory(
    input  wire clk, rst_n,WE,
    input  wire [31:0] A, WD,
    output wire [31:0] RD
);
    reg [31:0] mem [0:1023];
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) mem[i] = 32'h0;
    end
    always @(posedge clk) begin
        if (WE) mem[A[11:2]] <= WD;
    end
    assign RD = rst_n ? mem[A[11:2]] : 32'h0;
endmodule