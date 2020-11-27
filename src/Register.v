module Register (
    input clk,
    input write_enable,
    input [4:0] read_addr_1,
    input [4:0] read_addr_2,
    input [4:0] write_addr,
    input [7:0] write_data,
    output [7:0] read_data_1,
    output [7:0] read_data_2
);
    reg [7:0] mem [0:31];
    initial begin
        for (integer i = 0; i < 32; i = i + 1) begin
            mem[i] = 0;
        end
    end

    assign read_data_1 = mem[read_addr_1];
    assign read_data_2 = mem[read_addr_2];

    always @(posedge clk) begin
        if (write_enable) begin
            mem[write_addr] <= write_data;
        end
    end
endmodule
