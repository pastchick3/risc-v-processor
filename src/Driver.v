module Driver ();
    reg clk;
    
    Processor processor (
        .clk(clk)
    );

    initial
        begin
            $dumpfile("./Processor.vcd");
            $dumpvars(0, processor);

            clk = 1;
            for (integer i = 0; i < 63; i = i + 1) begin
                #1 clk = ~clk;
            end
            #1 $finish;
        end
endmodule
