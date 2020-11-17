module InstMem (
    input [4:0] addr,
    output [31:0] inst
);
    reg [31:0] mem [0:31];

    initial $readmemb("./program.obj", mem);

    assign inst = mem[addr];
endmodule
