module pipeline_tb();

reg clk,rst;

Pipeline_top uut (.clk(clk),.rst(rst));
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end
initial begin
    rst = 1'b0;
    #20;
    rst = 1'b1;
    #600;
    $finish;
end

initial begin
    $monitor(
        "Time=%t | rst=%b | clk=%b",
        $time, rst,clk
);
end
endmodule