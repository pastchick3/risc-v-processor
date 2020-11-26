module DataHazardCtrl (
    input clk,
    input ex_mem_reg_write_enable,
    input [4:0] ex_mem_reg_write_addr,
    input mem_wb_reg_write_enable,
    input [4:0] mem_wb_reg_write_addr,
    input wb_reg_write_enable,
    input [4:0] wb_reg_write_addr,
    input [4:0] id_ex_reg_read_addr_1,
    input [4:0] id_ex_reg_read_addr_2,
    input id_ex_reg_write_enable,
    input id_ex_reg_write_select,
    input [4:0] id_ex_reg_write_addr,
    input [31:0] if_id_inst,
    output reg [1:0] forward_1,
    output reg [1:0] forward_2,
    output reg stall
);
    always @(*) begin
        // ALU input 1
        if (ex_mem_reg_write_enable
            && (ex_mem_reg_write_addr != 0)
            && (ex_mem_reg_write_addr == id_ex_reg_read_addr_1)) begin
            // EX hazard
            forward_1 = 2'b01;
        end else if (mem_wb_reg_write_enable
            && (mem_wb_reg_write_addr != 0)
            && (mem_wb_reg_write_addr == id_ex_reg_read_addr_1)) begin
            // MEM hazard
            forward_1 = 2'b10;
        end else if (wb_reg_write_enable
            && (wb_reg_write_addr != 0)
            && (wb_reg_write_addr == id_ex_reg_read_addr_1)) begin
            // WB hazard
            forward_1 = 2'b11;
        end else begin
            // No hazard
            forward_1 = 2'b00;
        end

        // ALU input 2
        if (ex_mem_reg_write_enable
            && (ex_mem_reg_write_addr != 0)
            && (ex_mem_reg_write_addr == id_ex_reg_read_addr_2)) begin
            // EX hazard
            forward_2 = 2'b01;
        end else if (mem_wb_reg_write_enable
            && (mem_wb_reg_write_addr != 0)
            && (mem_wb_reg_write_addr == id_ex_reg_read_addr_2)) begin
            // MEM hazard
            forward_2 = 2'b10;
        end else if (wb_reg_write_enable
            && (wb_reg_write_addr != 0)
            && (wb_reg_write_addr == id_ex_reg_read_addr_2)) begin
            // WB hazard
            forward_2 = 2'b11;
        end else begin
            // No hazard
            forward_2 = 2'b00;
        end

        // Stall the pipeline if there is an instruction that reads a
        // register following a load instruction that operates on the
        // same register.
        if ((id_ex_reg_write_enable && !id_ex_reg_write_select)
            && ((id_ex_reg_write_addr == if_id_inst[19:15])
            || (id_ex_reg_write_addr == if_id_inst[24:20]))) begin
            stall = 1'b1;
        end else begin
            stall = 1'b0;
        end
    end
endmodule
