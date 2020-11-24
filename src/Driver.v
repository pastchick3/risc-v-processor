`define pipelined

module Driver ();
    reg clk;
    
    `ifdef pipelined
        PipelinedProcessor processor (
            .clk(clk)
        );
    `else
        SingleCycleProcessor processor (
            .clk(clk)
        );
    `endif
    
    initial begin
        $dumpfile("./Processor.vcd");
        $dumpvars(0, processor);
        clk = 1;
        for (integer i = 0; i < 63; i = i + 1) begin
            #1 clk = ~clk;
        end
        #1 $finish;
    end
endmodule
