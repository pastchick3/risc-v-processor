module Decoder (
    input [31:0] inst,
    output reg reg_write_enable,
    output reg [4:0] reg_read_addr_1,
    output reg [4:0] reg_read_addr_2,
    output reg [4:0] reg_write_addr,
    output reg data_write_enable,
    output reg [4:0] data_addr
);
    always @(inst) begin
        casex ({inst[31:25], inst[14:12], inst[6:0]})
            17'bXXXXXXX_011_0000011: begin
                reg_write_enable <= 1'b1;
                reg_read_addr_1 <= 4'b0000;
                reg_read_addr_2 <= 4'b0000;
                reg_write_addr <= inst[11:7];
                data_write_enable <= 1'b0;
                data_addr <= inst[19:15] + inst[24:20];
            end
            // 17'b0000000_000_0110011: alu_ctrl <= 0; // add
            // 17'b0100000_000_0110011: alu_ctrl <= 1; // sub
            default: ;
        endcase
    end
endmodule
