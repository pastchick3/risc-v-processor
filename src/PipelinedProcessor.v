module PipelinedProcessor (
    input clk
);
    // The program counter
    reg [4:0] pc = 0;

    // Control signals used by the instruction decoder
    wire [31:0] inst;
    wire reg_write_enable;
    wire [4:0] reg_read_addr_1;
    wire [4:0] reg_read_addr_2;
    wire [4:0] reg_write_addr;
    wire data_write_enable;
    wire [4:0] data_read_addr;
    wire [4:0] data_write_addr;
    wire [1:0] alu_ctrl;
    wire reg_write_select;
    wire branch;
    wire [4:0] branch_offset;
    
    // Signals used by other modules
    wire [7:0] reg_read_data_1;
    wire [7:0] reg_read_data_2;
    wire [7:0] data_read_data;
    wire [7:0] alu_out;
    wire [7:0] reg_write_mux_out;
    wire zero;

    // IF/ID pipeline registers
    reg [4:0] if_id_pc = 0;
    reg [31:0] if_id_inst = 0;

    // ID/EX pipeline registers
    reg [4:0] id_ex_pc = 0;
    reg [4:0] id_ex_reg_read_addr_1 = 0;
    reg [4:0] id_ex_reg_read_addr_2 = 0;
    reg [7:0] id_ex_reg_read_data_1 = 0;
    reg [7:0] id_ex_reg_read_data_2 = 0;
    reg id_ex_reg_write_enable = 0;
    reg [4:0] id_ex_reg_write_addr = 0;
    reg id_ex_data_write_enable = 0;
    reg [4:0] id_ex_data_read_addr = 0;
    reg [4:0] id_ex_data_write_addr = 0;
    reg [1:0] id_ex_alu_ctrl = 0;
    reg id_ex_reg_write_select = 0;
    reg id_ex_branch = 0;
    reg [4:0] id_ex_branch_offset = 0;

    // EX/MEM pipeline registers
    reg [7:0] ex_mem_reg_read_data_1 = 0;
    reg ex_mem_reg_write_enable = 0;
    reg [4:0] ex_mem_reg_write_addr = 0;
    reg ex_mem_data_write_enable = 0;
    reg [4:0] ex_mem_data_read_addr = 0;
    reg [4:0] ex_mem_data_write_addr = 0;
    reg ex_mem_reg_write_select = 0;
    reg [7:0] ex_mem_alu_out = 0;

    // MEM/WB pipeline registers
    reg mem_wb_reg_write_enable = 0;
    reg [4:0] mem_wb_reg_write_addr = 0;
    reg mem_wb_reg_write_select = 0;
    reg [7:0] mem_wb_alu_out = 0;
    reg [7:0] mem_wb_data_read_data = 0;

    // WB pipeline registers
    reg [7:0] wb_reg_write_mux_out = 0;
    reg wb_reg_write_enable = 0;
    reg [4:0] wb_reg_write_addr = 0;

    // Data hazard control signals
    wire [1:0] forward_1;
    wire [1:0] forward_2;
    wire stall;

    wire [7:0] alu_in_1_mux_out;
    wire [7:0] alu_in_2_mux_out;

    Decoder decoder (
        .inst(if_id_inst),
        .reg_write_enable(reg_write_enable),
        .reg_read_addr_1(reg_read_addr_1),
        .reg_read_addr_2(reg_read_addr_2),
        .reg_write_addr(reg_write_addr),
        .data_write_enable(data_write_enable),
        .data_read_addr(data_read_addr),
        .data_write_addr(data_write_addr),
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
        .write_enable(mem_wb_reg_write_enable),
        .read_addr_1(reg_read_addr_1),
        .read_addr_2(reg_read_addr_2),
        .write_addr(mem_wb_reg_write_addr),
        .write_data(reg_write_mux_out),
        .read_data_1(reg_read_data_1),
        .read_data_2(reg_read_data_2)
    );

    DataMem data_mem (
        .clk(clk),
        .write_enable(ex_mem_data_write_enable),
        .read_addr(ex_mem_data_read_addr),
        .write_addr(ex_mem_data_write_addr),
        .write_data(ex_mem_reg_read_data_1),
        .read_data(data_read_data)
    );

    Mux2 reg_write_mux (
        .select(mem_wb_reg_write_select),
        .in_1(mem_wb_data_read_data),
        .in_2(mem_wb_alu_out),
        .out(reg_write_mux_out)
    );

    Mux4 alu_in_1_mux (
        .select(forward_1),
        .in_1(id_ex_reg_read_data_1),
        .in_2(ex_mem_alu_out),
        .in_3(reg_write_mux_out),
        .in_4(wb_reg_write_mux_out),
        .out(alu_in_1_mux_out)
    );

    Mux4 alu_in_2_mux (
        .select(forward_2),
        .in_1(id_ex_reg_read_data_2),
        .in_2(ex_mem_alu_out),
        .in_3(reg_write_mux_out),
        .in_4(wb_reg_write_mux_out),
        .out(alu_in_2_mux_out)
    );

    ALU alu (
        .ctrl(id_ex_alu_ctrl),
        .in_1(alu_in_1_mux_out),
        .in_2(alu_in_2_mux_out),
        .out(alu_out),
        .zero(zero)
    );

    DataHazardCtrl data_hazard_ctrl (
        .clk(clk),
        .ex_mem_reg_write_enable(ex_mem_reg_write_enable),
        .ex_mem_reg_write_addr(ex_mem_reg_write_addr),
        .mem_wb_reg_write_enable(mem_wb_reg_write_enable),
        .mem_wb_reg_write_addr(mem_wb_reg_write_addr),
        .wb_reg_write_enable(wb_reg_write_enable),
        .wb_reg_write_addr(wb_reg_write_addr),
        .id_ex_reg_read_addr_1(id_ex_reg_read_addr_1),
        .id_ex_reg_read_addr_2(id_ex_reg_read_addr_2),
        .id_ex_reg_write_enable(id_ex_reg_write_enable),
        .id_ex_reg_write_select(id_ex_reg_write_select),
        .id_ex_reg_write_addr(id_ex_reg_write_addr),
        .if_id_inst(if_id_inst),
        .forward_1(forward_1),
        .forward_2(forward_2),
        .stall(stall)
    );
    
    always @(posedge clk) begin
        // The program counter is updated in the very beginning of
        // each clock cycle to make sure every signal and register
        // from the last clock cycle is stable. See `InstMem.v` for
        // more information.
        if (id_ex_branch & zero) begin
            pc <= id_ex_pc + id_ex_branch_offset * 2;

            // Flush IF/ID pipeline registers.        
            if_id_pc <= 0;
            if_id_inst <= 0;

            // Flush ID/EX pipeline registers.
            id_ex_pc <= 0;
            id_ex_reg_read_addr_1 <= 0;
            id_ex_reg_read_addr_2 <= 0;
            id_ex_reg_read_data_1 <= 0;
            id_ex_reg_read_data_2 <= 0;
            id_ex_reg_write_enable <= 0;
            id_ex_reg_write_addr <= 0;
            id_ex_data_write_enable <= 0;
            id_ex_data_read_addr <= 0;
            id_ex_data_write_addr <= 0;
            id_ex_alu_ctrl <= 0;
            id_ex_reg_write_select <= 0;
            id_ex_branch <= 0;
            id_ex_branch_offset <= 0;
        end else if (stall) begin
            pc <= pc;
       
            if_id_pc <= if_id_pc;
            if_id_inst <= if_id_inst;

            id_ex_pc <= 0;
            id_ex_reg_read_addr_1 <= 0;
            id_ex_reg_read_addr_2 <= 0;
            id_ex_reg_read_data_1 <= 0;
            id_ex_reg_read_data_2 <= 0;
            id_ex_reg_write_enable <= 0;
            id_ex_reg_write_addr <= 0;
            id_ex_data_write_enable <= 0;
            id_ex_data_read_addr <= 0;
            id_ex_data_write_addr <= 0;
            id_ex_alu_ctrl <= 0;
            id_ex_reg_write_select <= 0;
            id_ex_branch <= 0;
            id_ex_branch_offset <= 0;
        end else begin
            pc <= pc + 1;

            // Load IF/ID pipeline registers.        
            if_id_pc <= pc;
            if_id_inst <= inst;

            // Load ID/EX pipeline registers.
            id_ex_pc <= if_id_pc;
            id_ex_reg_read_addr_1 <= reg_read_addr_1;
            id_ex_reg_read_addr_2 <= reg_read_addr_2;
            id_ex_reg_read_data_1 <= reg_read_data_1;
            id_ex_reg_read_data_2 <= reg_read_data_2;
            id_ex_reg_write_enable <= reg_write_enable;
            id_ex_reg_write_addr <= reg_write_addr;
            id_ex_data_write_enable <= data_write_enable;
            id_ex_data_read_addr <= data_read_addr;
            id_ex_data_write_addr <= data_write_addr;
            id_ex_alu_ctrl <= alu_ctrl;
            id_ex_reg_write_select <= reg_write_select;
            id_ex_branch <= branch;
            id_ex_branch_offset <= branch_offset;
        end

        // Load EX/MEM pipeline registers.
        ex_mem_reg_read_data_1 <= alu_in_1_mux_out; // forwarded
        ex_mem_reg_write_enable <= id_ex_reg_write_enable;
        ex_mem_reg_write_addr <= id_ex_reg_write_addr;
        ex_mem_data_write_enable <= id_ex_data_write_enable;
        ex_mem_data_read_addr <= id_ex_data_read_addr;
        ex_mem_data_write_addr <= id_ex_data_write_addr;
        ex_mem_reg_write_select <= id_ex_reg_write_select;
        ex_mem_alu_out <= alu_out;

        // Load MEM/WB pipeline registers.
        mem_wb_reg_write_enable <= ex_mem_reg_write_enable;
        mem_wb_reg_write_addr <= ex_mem_reg_write_addr;
        mem_wb_reg_write_select <= ex_mem_reg_write_select;
        mem_wb_alu_out <= ex_mem_alu_out;
        mem_wb_data_read_data <= data_read_data;

        // Load WB pipeline registers.
        wb_reg_write_mux_out <= reg_write_mux_out;
        wb_reg_write_enable = mem_wb_reg_write_enable;
        wb_reg_write_addr = mem_wb_reg_write_addr;
    end
endmodule
