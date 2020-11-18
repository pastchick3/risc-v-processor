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
    wire [1:0] alu_ctrl;
    wire reg_write_select;
    wire branch;
    wire [4:0] branch_offset;
    
    wire [7:0] reg_read_data_1;
    wire [7:0] reg_read_data_2;
    wire [7:0] data_read_data;

    wire [7:0] alu_out;
    wire [7:0] reg_write_mux_out;
    wire zero;

    Decoder decoder (
        .inst(inst_reg),
        .reg_write_enable(reg_write_enable),
        .reg_read_addr_1(reg_read_addr_1),
        .reg_read_addr_2(reg_read_addr_2),
        .reg_write_addr(reg_write_addr),
        .data_write_enable(data_write_enable),
        .data_addr(data_addr),
        .alu_ctrl(alu_ctrl),
        .reg_write_select(reg_write_select),
        .branch(branch),
        .branch_offset(branch_offset)
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
        .write_data(reg_write_mux_out),
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

    Mux reg_write_mux (
        .select(reg_write_select),
        .in_1(data_read_data),
        .in_2(alu_out),
        .out(reg_write_mux_out)
    );

    ALU alu (
        .ctrl(alu_ctrl),
        .in_1(reg_read_data_1),
        .in_2(reg_read_data_2),
        .out(alu_out),
        .zero(zero)
    );
    
    always @(posedge clk) begin
        if (branch & zero) begin
            pc = pc + branch_offset;
        end else begin
            pc = pc + 1;
        end
        inst_reg = inst;
    end
endmodule
