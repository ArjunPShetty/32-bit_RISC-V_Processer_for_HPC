`timescale 1ns / 1ps
module Register_File(
    input  wire clk,WE3,
    input  wire [4:0]  A1, A2, A3,
    input  wire [31:0] WD3,
    output wire [31:0] RD1, RD2
);
    reg [31:0] Register [0:31];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) Register[i] = 32'h0;
    end
    always @(posedge clk) begin
        if (WE3 && (A3 != 5'h00))
            Register[A3] <= WD3;
    end
    assign RD1 = (A1 == 5'h00) ? 32'h0 : Register[A1];
    assign RD2 = (A2 == 5'h00) ? 32'h0 : Register[A2];
endmodule