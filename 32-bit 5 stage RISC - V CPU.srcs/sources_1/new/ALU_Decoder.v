module ALU_Decoder(ALUOp, funct3, funct7, op, ALUControl);

input [1:0] ALUOp;
input [2:0] funct3;
input [6:0] funct7, op;
output reg [2:0] ALUControl;

always @(*) begin
    if (ALUOp == 2'b00)
        ALUControl = 3'b000;
    else if (ALUOp == 2'b01)
        ALUControl = 3'b001;
    else if ((ALUOp == 2'b10) && (funct3 == 3'b000) && ({op[5], funct7[5]} == 2'b11))
        ALUControl = 3'b001;
    else if ((ALUOp == 2'b10) && (funct3 == 3'b000) && ({op[5], funct7[5]} != 2'b11))
        ALUControl = 3'b000;
    else if ((ALUOp == 2'b10) && (funct3 == 3'b010))
        ALUControl = 3'b101;
    else if ((ALUOp == 2'b10) && (funct3 == 3'b110))
        ALUControl = 3'b011;
    else if ((ALUOp == 2'b10) && (funct3 == 3'b111))
        ALUControl = 3'b010;
    else
        ALUControl = 3'b000;
end
endmodule