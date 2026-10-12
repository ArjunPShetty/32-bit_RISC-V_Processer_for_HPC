`timescale 1ns / 1ps
module fetch_cycle(
    input  wire clk, rst_n,StallF, FlushD, PCSrcE,
    input  wire [31:0] PCTargetE,
    output wire [31:0] InstrD, PCD, PCPlus4D
);
    wire [31:0] PCF, PCPlus4F, InstrF, PC_Next;

    Mux PC_MUX (.a(PCPlus4F), .b(PCTargetE), .s(PCSrcE), .c(PC_Next));
    PC_Module PC (.clk(clk), .rst_n(rst_n), .PC_Next(PC_Next), .PC(PCF));
    Instruction_Memory IMEM (.rst_n(rst_n), .A(PCF), .RD(InstrF));
    PC_Adder PC_adder (.a(PCF), .b(32'h0000_0004), .c(PCPlus4F));

    reg [31:0] InstrF_r, PCF_r, PCPlus4F_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            InstrF_r   <= 32'h0000_0013;
            PCF_r      <= 32'h0;
            PCPlus4F_r <= 32'h0;
        end else if (FlushD) begin
            InstrF_r   <= 32'h0000_0013;
            PCF_r      <= PCF;
            PCPlus4F_r <= PCPlus4F;
        end else if (!StallF) begin
            InstrF_r   <= InstrF;
            PCF_r      <= PCF;
            PCPlus4F_r <= PCPlus4F;
        end
    end

    assign InstrD   = InstrF_r;
    assign PCD      = PCF_r;
    assign PCPlus4D = PCPlus4F_r;
endmodule