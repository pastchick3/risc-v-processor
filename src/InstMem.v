module InstMem (
    input [4:0] addr,
    output [31:0] inst
);
    reg [31:0] mem [0:32];

    initial $readmemb("./program.obj", mem, 1);

    assign inst = mem[addr];
endmodule
