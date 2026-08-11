module ALU(A, B, Result, ALUControl, OverFlow, Carry, Zero, Negative);

input [31:0] A, B;
input [2:0] ALUControl;
output reg [31:0] Result;
output Carry, OverFlow, Zero, Negative;
reg Cout;
wire [31:0] Sum;

assign Sum = (ALUControl[0] == 1'b0) ? (A + B) :(A + ((~B) + 1));
assign OverFlow = ((Sum[31] ^ A[31]) &(~(ALUControl[0] ^ B[31] ^ A[31])) & (~ALUControl[1]));

assign Carry = ((~ALUControl[1]) & Cout);
assign Zero = &(~Result);
assign Negative = Result[31];

always @(*) 
begin
    if (ALUControl == 3'b000) 
    begin
        {Cout, Result} = {1'b0, Sum};
    end
    else if (ALUControl == 3'b001) 
    begin
        {Cout, Result} = {1'b0, Sum};
    end
    else if (ALUControl == 3'b010) begin
        Cout = 1'b0;
        Result = A & B;
    end
    else if (ALUControl == 3'b011) begin
        Cout = 1'b0;
        Result = A | B;
    end
    else if (ALUControl == 3'b101) begin
        Cout = 1'b0;
        Result = {31'b0, Sum[31]};
    end
    else begin
        Cout = 1'b0;
        Result = 32'b0;
    end
end
endmodule