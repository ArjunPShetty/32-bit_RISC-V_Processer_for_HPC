`timescale 1ns / 1ps
module Instruction_Memory(
    input  wire rst_n,
    input  wire [31:0] A,
    output wire [31:0] RD
);
    reg [31:0] mem [0:1023];
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 32'h00000013;
        $readmemh("memfile.mem", mem);
    end
    assign RD = rst_n ? mem[A[11:2]] : 32'h0000_0013;
endmodule