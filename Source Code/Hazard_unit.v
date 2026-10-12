`timescale 1ns / 1ps
module hazard_unit(
    input  wire rst_n,RegWriteM, RegWriteW,
    input  wire [4:0]  RD_M, RD_W, Rs1_E, Rs2_E, Rs1_D, Rs2_D, RD_E,
    input  wire UsesRs1D, UsesRs2D,ResultSrcE_load, PCSrcE,
    output reg  [1:0]  ForwardAE, ForwardBE,
    output reg StallF, StallD, FlushD, FlushE
);
    //  EX forwarding 
    always @(*) begin
        if (!rst_n) ForwardAE = 2'b00;
        else if (RegWriteM && (RD_M != 5'h0) && (RD_M == Rs1_E))   ForwardAE = 2'b10;
        else if (RegWriteW && (RD_W != 5'h0) && (RD_W == Rs1_E))   ForwardAE = 2'b01;
        else ForwardAE = 2'b00;
    end
    always @(*) begin
        if (!rst_n) ForwardBE = 2'b00;
        else if (RegWriteM && (RD_M != 5'h0) && (RD_M == Rs2_E))   ForwardBE = 2'b10;
        else if (RegWriteW && (RD_W != 5'h0) && (RD_W == Rs2_E))   ForwardBE = 2'b01;
        else ForwardBE = 2'b00;
    end

    // Qualified load-use stall
    wire lwStall = ResultSrcE_load && (RD_E != 5'h0) && ((UsesRs1D && (Rs1_D == RD_E))
     ||(UsesRs2D && (Rs2_D == RD_E)));

    always @(*) begin
        if (!rst_n) begin
            StallF = 1'b0; StallD = 1'b0;
            FlushD = 1'b0; FlushE = 1'b0;
        end else begin
            StallF = lwStall;
            StallD = lwStall;
            FlushE = lwStall | PCSrcE;
            FlushD = PCSrcE;
        end
    end
endmodule