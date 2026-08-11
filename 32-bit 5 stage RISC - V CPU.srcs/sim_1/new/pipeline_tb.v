`timescale 1ns / 1ps

module pipeline_tb();

    reg clk;
    reg rst;
    integer cycle;

    // Instantiate the top module
    Pipeline_top uut (.clk(clk), .rst(rst));

    // Generate Clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; // 10ns period
    end

    // Reset and Run Sequence
    initial begin
        rst = 1'b0;
        cycle = 0;
        #20;              // Hold reset for 20ns
        rst = 1'b1;       // Release reset
        #600;             // Run for 600ns
        $finish;
    end

    // ------------------- DETAILED CONSOLE LOGGING -------------------
    // This block executes at every positive edge of the clock (every cycle)
    always @(posedge clk) begin
        if (rst) begin
            cycle = cycle + 1;
            
            $display("");
            $display("============= CYCLE %0d =============", cycle);
            
            // 1. FETCH STAGE
            $display("[Fetch]   : PC=0x%08h, Instruction=0x%08h", 
                     uut.PCD, uut.InstrD);

            // 2. DECODE STAGE
            $display("[Decode]  : RS1=%0d, RS2=%0d, RD=%0d, Imm_Ext=0x%08h", 
                     uut.RS1_E, uut.RS2_E, uut.RD_E, uut.Imm_Ext_E);
            $display("          : RegWrite=%b, MemWrite=%b, Branch=%b, ALUControl=%b", 
                     uut.RegWriteE, uut.MemWriteE, uut.BranchE, uut.ALUControlE);

            // 3. EXECUTE STAGE
            // Note: uut.Execute.ResultE is the ALU output immediately after computation
            // uut.ALU_ResultM is that same result after the pipeline register.
            $display("[Execute] : SrcA=0x%08h, SrcB=0x%08h, ALU_Out=0x%08h", 
                     uut.RD1_E, (uut.ALUSrcE ? uut.Imm_Ext_E : uut.RD2_E), uut.Execute.ResultE);
            $display("          : PCSrcE=%b (BranchTaken), PCTarget=0x%08h", 
                     uut.PCSrcE, uut.PCTargetE);

            // 4. MEMORY STAGE
            $display("[Memory]  : ALU_ResultM=0x%08h, WriteDataM=0x%08h, MemWrite=%b", 
                     uut.ALU_ResultM, uut.WriteDataM, uut.MemWriteM);
            $display("          : ReadDataM=0x%08h, RD_M=%0d", 
                     uut.Memory.ReadDataM, uut.RD_M);

            // 5. WRITEBACK STAGE
            $display("[WB]      : ResultW=0x%08h, RD_W=%0d, RegWriteW=%b", 
                     uut.ResultW, uut.RDW, uut.RegWriteW);

            // 6. HAZARD FORWARDING
            $display("[Hazard]  : ForwardAE=%b, ForwardBE=%b", 
                     uut.ForwardAE, uut.ForwardBE);
        end
    end

endmodule