module InstMem (
    input [4:0] addr,
    output [31:0] inst
);
    // Since the program counter is updated at the very beginning of
    // each clock cycle to make sure every signal and register from
    // the last clock cycle is stable, we deliberately load the
    // instruction memory from address 1 instead of 0 so the processing
    // logic for the first clock cycle is consist with all the remaining
    // clock cycles.
    reg [31:0] mem [0:32];
    initial mem[0] = 0;
    initial $readmemb("./program.obj", mem, 1);

    assign inst = mem[addr];
endmodule
