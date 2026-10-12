`timescale 1ns / 1ps
module tb_pipeline;
    reg clk = 0;
    reg rst_n = 0;
    always #5 clk = ~clk;

    Pipeline_top uut (.clk(clk), .rst_n(rst_n));

    int pass_cnt = 0, fail_cnt = 0;
    int unsigned wd = 0;

    always @(posedge clk) begin
        wd++;
        if (wd > 5000) $fatal(1, "TIMEOUT");
    end

    task chk(input int idx, input [31:0] exp, input string nm);
        if (uut.Decode.rf.Register[idx] === exp) begin
            pass_cnt++;
            $display("[PASS] %s x%0d=0x%08x", nm, idx,
                     uut.Decode.rf.Register[idx]);
        end else begin
            fail_cnt++;
            $error("[FAIL] %s x%0d=0x%08x exp 0x%08x",
                   nm, idx, uut.Decode.rf.Register[idx], exp);
        end
    endtask

    initial begin
        rst_n = 0;
        repeat (4) @(posedge clk);
        rst_n = 1;
        repeat (400) @(posedge clk);

        chk(1,32'd5,"ADDI");
        chk(2,32'd3,"ADDI");
        chk(3,32'd8,"ADD");
        chk(4, 32'd2,"SUB");
        chk(5, 32'd1,"AND");
        chk(6,32'd7,"OR");
        chk(7,32'd6,"XOR");
        chk(8,32'd8,"LW");
        chk(10, 32'd42,"BEQ-skip");
        chk(11, 32'h00000034,  "JAL link");
        chk(13, 32'd1,"post-JAL");
        chk(14, 32'hDEADB000,  "LUI");
        // AUIPC now works: x15 = PC_at_AUIPC + imm
        chk(15, 32'h00000048,  "AUIPC");

        $display("PASS=%0d FAIL=%0d", pass_cnt, fail_cnt);
        if (fail_cnt == 0) $finish(0); else $fatal(1, "FAIL");
    end
endmodule