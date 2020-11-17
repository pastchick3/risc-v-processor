module Processor (
    input clk
);
    reg [4:0] pc = 0;
    reg [31:0] inst_reg = 0;

    wire [31:0] inst;
    wire reg_write_enable;
    wire [4:0] reg_read_addr_1;
    wire [4:0] reg_read_addr_2;
    wire [4:0] reg_write_addr;
    wire data_write_enable;
    wire [4:0] data_addr;
    
    wire [7:0] reg_read_data_1;
    wire [7:0] reg_read_data_2;
    wire [7:0] data_read_data;

    Decoder decoder (
        .inst(inst_reg),
        .reg_write_enable(reg_write_enable),
        .reg_read_addr_1(reg_read_addr_1),
        .reg_read_addr_2(reg_read_addr_2),
        .reg_write_addr(reg_write_addr),
        .data_write_enable(data_write_enable),
        .data_addr(data_addr)
    );

    InstMem inst_mem (
        .addr(pc),
        .inst(inst)
    );

    Register register (
        .clk(clk),
        .write_enable(reg_write_enable),
        .read_addr_1(reg_read_addr_1),
        .read_addr_2(reg_read_addr_2),
        .write_addr(reg_write_addr),
        .write_data(data_read_data),
        .read_data_1(reg_read_data_1),
        .read_data_2(reg_read_data_2)
    );

    DataMem data_mem (
        .clk(clk),
        .write_enable(data_write_enable),
        .addr(data_addr),
        .write_data(reg_read_data_1),
        .read_data(data_read_data)
    );
    
    always @(posedge clk) begin
        inst_reg <= inst;
        pc <= pc + 1;
    end
endmodule