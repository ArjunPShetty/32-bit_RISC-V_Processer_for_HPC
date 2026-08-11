`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 22:54:19
// Design Name: 
// Module Name: Data_Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Data_Memory(clk, rst,WE,WD,A, RD);

input clk, rst, WE;
input [31:0] A, WD;
output [31:0] RD;
reg [31:0] mem [1023:0];

always @(posedge clk) begin
    if (WE)
        mem[A[31:2]] <= WD;
end
assign RD = (~rst) ? 32'd0 : mem[A[31:2]];
initial begin
    mem[0] = 32'h00000000;
end
endmodule
