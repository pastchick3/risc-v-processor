module DataMem (
    input clk,
    input write_enable,
    input [4:0] addr,
    input [7:0] write_data,
    output [7:0] read_data
);
    reg [7:0] mem [0:31];

    initial $readmemb("./data.mem", mem);

    assign read_data = mem[addr];
    always @(posedge clk) begin
        if (write_enable) begin
            mem[addr] <= write_data;
        end

        // $strobe("MEM: %b %b %b %b", mem[0], mem[1], mem[2], mem[3]);
    end
endmodule
