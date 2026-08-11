module Instruction_Memory(rst, A,RD);

input rst;
input [31:0] A;
output [31:0] RD;
reg [31:0] mem [1023:0];

assign RD = (!rst) ? 32'h00000000 : mem[A[31:2]];
integer i;
initial begin

    for (i = 0; i < 1024; i = i + 1)
        mem[i] = 32'h00000000;
    $readmemh("memfile.mem", mem);
end
endmodule