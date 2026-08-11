module hazard_unit(rst, RegWriteM,RegWriteW, RD_M,RD_W,Rs1_E,Rs2_E,ForwardAE,ForwardBE );

input rst,RegWriteM, RegWriteW;
input [4:0] RD_M, RD_W, Rs1_E, Rs2_E;
output reg [1:0] ForwardAE,ForwardBE;

always @(*) 
begin
    if (!rst)
        ForwardAE = 2'b00;
    else if ((RegWriteM == 1'b1) && (RD_M != 5'h00) && (RD_M == Rs1_E))
        ForwardAE = 2'b10;
    else if ((RegWriteW == 1'b1) && (RD_W != 5'h00) && (RD_W == Rs1_E))
        ForwardAE = 2'b01;
    else
        ForwardAE = 2'b00;
end
always @(*) begin
    if (!rst)
        ForwardBE = 2'b00;
    else if ((RegWriteM == 1'b1) && (RD_M != 5'h00) && (RD_M == Rs2_E))
        ForwardBE = 2'b10;
    else if ((RegWriteW == 1'b1) && (RD_W != 5'h00) && (RD_W == Rs2_E))
        ForwardBE = 2'b01;
    else
        ForwardBE = 2'b00;
end
endmodule