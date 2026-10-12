`timescale 1ns / 1ps
module ALU_Decoder(
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,op,
    output reg  [3:0] ALUControl
);
    wire is_rtype = (op == 7'b0110011);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0000;
            2'b01: ALUControl = 4'b0001;
            2'b10: begin
                case (funct3)
                    3'b000: ALUControl = (is_rtype && funct7[5]) ? 4'b0001 : 4'b0000;
                    3'b001: ALUControl = 4'b0111;
                    3'b010: ALUControl = 4'b0101;
                    3'b011: ALUControl = 4'b0110;
                    3'b100: ALUControl = 4'b0100;
                    3'b101: ALUControl = funct7[5] ? 4'b1001 : 4'b1000;
                    3'b110: ALUControl = 4'b0011;
                    3'b111: ALUControl = 4'b0010;
                    default: ALUControl = 4'b0000;
                endcase
            end
            default: ALUControl = 4'b0000;
        endcase
    end
endmodule