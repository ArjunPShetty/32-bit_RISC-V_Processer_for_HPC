`timescale 1ns / 1ps
module PC_Module(
    input  wire clk,rst_n,
    input  wire[31:0] PC_Next,
    output reg[31:0] PC
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) PC <= 32'h0000_0000;
        else 
         PC <= PC_Next;
    end
endmodule