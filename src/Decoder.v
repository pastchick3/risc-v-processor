module Decoder (
    input [31:0] inst,
    output reg reg_write_enable,
    output reg [4:0] reg_read_addr_1,
    output reg [4:0] reg_read_addr_2,
    output reg [4:0] reg_write_addr,
    output reg data_write_enable,
    output reg [4:0] data_read_addr,
    output reg [4:0] data_write_addr,
    output reg [1:0] alu_ctrl,
    output reg reg_write_select,
    output reg branch,
    output reg [4:0] branch_offset
);
    always @(inst) begin
        casex ({inst[31:25], inst[14:12], inst[6:0]})
            17'bXXXXXXX_011_0000011: begin // ld
                reg_write_enable = 1'b1;
                reg_read_addr_1 = 5'b00000;
                reg_read_addr_2 = 5'b00000;
                reg_write_addr = inst[11:7];
                data_write_enable = 1'b0;
                data_read_addr = inst[19:15] + inst[24:20];
                data_write_addr = 5'b00000;
                alu_ctrl = 2'b00;
                reg_write_select = 1'b0;
                branch = 1'b0;
                branch_offset = 5'b00000;
            end
            17'bXXXXXXX_011_0100011: begin // sd
                reg_write_enable = 1'b0;
                reg_read_addr_1 = inst[24:20];
                reg_read_addr_2 = 5'b00000; // The memory base register is always x0.
                reg_write_addr = 5'b00000;
                data_write_enable = 1'b1;
                data_read_addr = 5'b00000;
                data_write_addr = inst[19:15] + inst[11:7];
                alu_ctrl = 2'b00;
                reg_write_select = 1'b0;
                branch = 1'b0;
                branch_offset = 5'b00000;
            end
            17'b0000000_111_0110011: begin // and
                reg_write_enable = 1'b1;
                reg_read_addr_1 = inst[19:15];
                reg_read_addr_2 = inst[24:20];
                reg_write_addr = inst[11:7];
                data_write_enable = 1'b0;
                data_read_addr = 5'b00000;
                data_write_addr = 5'b00000;
                alu_ctrl = 2'b00;
                reg_write_select = 1'b1;
                branch = 1'b0;
                branch_offset = 5'b00000;
            end
            17'b0000000_110_0110011: begin // or
                reg_write_enable = 1'b1;
                reg_read_addr_1 = inst[19:15];
                reg_read_addr_2 = inst[24:20];
                reg_write_addr = inst[11:7];
                data_write_enable = 1'b0;
                data_read_addr = 5'b00000;
                data_write_addr = 5'b00000;
                alu_ctrl = 2'b01;
                reg_write_select = 1'b1;
                branch = 1'b0;
                branch_offset = 5'b00000;
            end
            17'b0000000_000_0110011: begin // add
                reg_write_enable = 1'b1;
                reg_read_addr_1 = inst[19:15];
                reg_read_addr_2 = inst[24:20];
                reg_write_addr = inst[11:7];
                data_write_enable = 1'b0;
                data_read_addr = 5'b00000;
                data_write_addr = 5'b00000;
                alu_ctrl = 2'b10;
                reg_write_select = 1'b1;
                branch = 1'b0;
                branch_offset = 5'b00000;
            end
            17'b0100000_000_0110011: begin // sub
                reg_write_enable = 1'b1;
                reg_read_addr_1 = inst[19:15];
                reg_read_addr_2 = inst[24:20];
                reg_write_addr = inst[11:7];
                data_write_enable = 1'b0;
                data_read_addr = 5'b00000;
                data_write_addr = 5'b00000;
                alu_ctrl = 2'b11;
                reg_write_select = 1'b1;
                branch = 1'b0;
                branch_offset = 5'b00000;
            end
            17'bXXXXXXX_000_1100011: begin // beq
                reg_write_enable = 1'b0;
                reg_read_addr_1 = inst[19:15];
                reg_read_addr_2 = inst[24:20];
                reg_write_addr = 5'b00000;
                data_write_enable = 1'b0;
                data_read_addr = 5'b00000;
                data_write_addr = 5'b00000;
                alu_ctrl = 2'b11;
                reg_write_select = 1'b0;
                branch = 1'b1;
                branch_offset = {inst[25], inst[11:8]} >> 1;
            end
            default: begin
                reg_write_enable = 1'b0;
                reg_read_addr_1 = 5'b00000;
                reg_read_addr_2 = 5'b00000;
                reg_write_addr = 5'b00000;
                data_write_enable = 1'b0;
                data_read_addr = 5'b00000;
                data_write_addr = 5'b00000;
                alu_ctrl = 2'b00;
                reg_write_select = 1'b0;
                branch = 1'b0;
                branch_offset = 5'b00000;
            end
        endcase
    end
endmodule
