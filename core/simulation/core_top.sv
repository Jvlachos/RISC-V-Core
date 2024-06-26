
`define CLK_PERIOD 20


module core_top;
    import core::*;
    import riscv::*;
    logic clk = 1;
    logic rst = 0;
    logic [core::DATA_WIDTH-1:0] instruction;
    logic [core::DATA_WIDTH-1:0] wdata;
    logic [core::DATA_BYTES-1:0] wen = 0;
    logic pc_incr = 0;
    logic [31:0] db_i_mem [31:0]; 
    logic [31:0] pc;
    logic pipeline_flush;
    always# (`CLK_PERIOD) clk = ~clk;
    core::pipeline_bus_t id_bus;
    core::pipeline_bus_t ex_bus;
    core::br_cntrl_bus_t br_bus;
    core::mem_cntrl_bus_t mem_cntrl;
    core::pipeline_bus_t mem_bus;
    core::pipeline_bus_t wb_bus;
    core::pipeline_bus_t id2fw;
    bit stall;
    bit pipeline_stalled;
    logic [2:0] format;
    bit unstall;
    int cycle_no = 0;
    core::fw_cntrl_bus_t fw_cntrl;
    core::bypass_bus_t mem_bypass;
    core::bypass_bus_t wb_bypass;
    core::bypass_bus_t wb_bp_late;
    core::pipeline_bus_t wb_late;    
    logic [31:0] ld_addr;
    core::MEM_OP_t exmemop;
    assign exmemop = id_bus.mem_op;

    fw_controller fw_control(
        .clk(clk),
        .rst(rst),
        .id_bus_i(id2fw),
        .ex_bus_i(id_bus),
        .mem_bus_i(ex_bus),
        .wb_bus_i(wb_bus),
        .wb_late_bus_i(wb_late),
        .fw_cntrl_o(fw_cntrl));    

    stall_controller stall_cntrl(
        .clk(clk),
        .rst(rst),
        .instr_i(instruction),
        .exmem_bus_i(id_bus),
        .unstall_i(unstall),
        .stall_o(stall),
        .format_i(format),
        .pipeline_stalled_i(id_bus.pipeline_stall),
        .pipeline_stalled_o(pipeline_stalled));

    if_stage if_s(
    .clk(clk),
    .rst(rst),
    .wdata_i(wdata),
    .wen_i(wen),
    .pc_incr_en_i(~stall),
    .instr_o(instruction),
    .pc_o(pc),
    .br_bus_i(br_bus));
    //decoder_tb dec_s(.clk(clk),.rst(rst),.instruction_i(instruction));
    id_stage id_s(
        .clk(clk),
        .rst(rst),
        .instruction_i(instruction),
        .pc_i(pc),
        .wb_bus_i(wb_bus),
        .id_bus_o(id_bus),
        .flush_i(pipeline_flush),
        .stall_i(stall),
        .format_o(format),
        .id2fw_cntrl_o(id2fw));

    ex_stage ex_s(
        .clk(clk),
        .rst(rst),
        .bus_i(id_bus),
        .fw_cntrl_i(fw_cntrl),
        .mem_bypass_i(mem_bypass),
        .wb_bypass_i(wb_bypass),
        .wb_late_bypass_i(wb_bp_late),
        .ex_bus_o(ex_bus),
        .flush_o(pipeline_flush),
        .br_bus_o(br_bus),
        .ex2mem_o(mem_cntrl),
        .ld_addr(ld_addr));

    mem_stage mem_s(
        .clk(clk),
        .rst(rst),
        .bus_i(ex_bus),
        .mem_cntrl_i(mem_cntrl),
        .mem_bus_o(mem_bus),
        .mem_bp_o(mem_bypass));
        
    wb_stage wb_s(
        .clk(clk),
        .rst(rst),
        .bus_i(mem_bus),
        .wb_bus_o(wb_bus),
        .unstall_o(unstall),
        .wb_bp_o(wb_bypass),
        .wb_late_o(wb_late),
        .wb_bp_late_o(wb_bp_late));

    integer i_index; 

    initial begin
        db_i_mem[0] = riscv::addi(5,1,14);
        db_i_mem[1] = riscv::load(12,7,6,0,0);
        db_i_mem[2] = riscv::addi(2,7,5);
        db_i_mem[3] = riscv::ori(1,2,5);
        db_i_mem[4] = riscv::xori(1,2,5);
        i_index = 0;
        @(posedge clk);

        rst = 1;
        while(1) begin
            
           // pc_incr = 1;
//            instruction = db_i_mem[i_index];
            @(posedge clk);
//            cycle_no ++;
            //pc_incr = 0;
           // #5;
            //display_side();
            display_bus(id_bus,"ID/EX");
            display_bus(ex_bus,"EX/MEM");
            display_bus(mem_bus,"MEM/WB");
            display_bus(wb_late,"WB/ALL");
            $display("\n ---------------------------------------------------- \n");
            i_index++;
        end
        $finish;
    end

    always @(posedge clk) begin
        cycle_no <= cycle_no + 1;
        //if(cycle_no > 1000)
          //  $finish;
    end

    task display_bus(pipeline_bus_t curr_bus,string msg);
        $display("Cycle : %0d Stage : %s\n",cycle_no,msg);
        riscv::decode_instr(curr_bus.instr);
        $display("\nMemOp: %s\nAluOp: %s\nFormat: %s\nImm: %d\nRs1: %d\nRs2: %d\nRd: %d\nPc: 0x%h\nRs1 data: %0d\nRs2 data: %0d\nRd data: %0d\nRF: %0b\nBR: 0x%h\nST: 0x%0h\n",
        curr_bus.mem_op.name(),curr_bus.alu_op.name(),
        curr_bus.format.name(),$signed(curr_bus.imm),curr_bus.rs1,curr_bus.rs2,curr_bus.rd,curr_bus.pc,
        $signed(curr_bus.rs1_data),$signed(curr_bus.rs2_data),$signed(curr_bus.rd_res),curr_bus.rf_wr_en,br_bus.branch_target,mem_cntrl.w_data);
    endtask

    task display_side();
        $display("Cycle : %d\n",cycle_no);
        $write("\t\tID\t\t\t|\t\t\tEX\t\t\t|\t\t\tMEM\t\t\t\n");
        riscv::decode_instr(id_bus.instr);
        $write("\t\t\t");
        riscv::decode_instr(ex_bus.instr);
        $write("\nMemOp: %s\t\t\t\t|\t\t MemOp: %s|\t\t MemOp: %s\nAluOp: %s\t\t\t\t|\t\t AluOp: %s\nPC: 0x%h\t\t\t\t|\t\t PC: 0x%h\n",
        id_bus.mem_op.name(),ex_bus.mem_op.name(),mem_bus.mem_op.name(),id_bus.alu_op.name(),ex_bus.alu_op.name(),id_bus.pc,ex_bus.pc);

    endtask

endmodule