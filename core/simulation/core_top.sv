
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
   
    int cycle_no = 0;
/*
    if_stage if_s(
    .clk(clk),
    .rst(rst),
    .wdata_i(wdata),
    .wen_i(wen),
    .pc_incr_en_i(pc_incr),
    .instr_o(instruction),
    .pc_o(pc));
*/
    //decoder_tb dec_s(.clk(clk),.rst(rst),.instruction_i(instruction));
    id_stage id_s(
        .clk(clk),
        .rst(rst),
        .instruction_i(instruction),
        .pc_i(pc),
        .id_bus_o(id_bus),
        .flush_i(pipeline_flush));

    ex_stage ex_s(
        .clk(clk),
        .rst(rst),
        .bus_i(id_bus),
        .ex_bus_o(ex_bus),
        .flush_o(pipeline_flush),
        .br_bus_o(br_bus)
    );
    integer i_index; 

    initial begin
        db_i_mem[0] = riscv::addi(5,1,14);
        db_i_mem[1] = riscv::gen_btype(1,2,riscv::BEQ_F3,10,1);
        db_i_mem[2] = riscv::slti(2,2,5);
        db_i_mem[3] = riscv::ori(1,2,5);
        db_i_mem[4] = riscv::xori(1,2,5);
        i_index = 0;
        @(posedge clk);

        rst = 1;
        repeat(10) begin
            pc_incr = 0;
            #5;
            instruction = db_i_mem[i_index];
            @(posedge clk);
            cycle_no ++;
            pc_incr = 0;
            #5;
            display_side();
            //display_bus(id_bus,"ID");
            //display_bus(ex_bus,"EX");
            $display("\n ---------------------------------------------------- \n");
            #5;
            i_index++;
        end
        $finish;
    end

    task display_bus(pipeline_bus_t curr_bus,string msg);
        $display("Cycle : %d Stage : %s\n",cycle_no,msg);
        riscv::decode_instr(curr_bus.instr);
        $display("\nMemOp: %s\nAluOp: %s\nFormat: %s\nImm: %d\nRs1: %d\nRs2: %d\nRd: %d\nPc: 0x%h\nRs1 data: 0x%h\nRs2 data: 0x%h\nRd data: 0x%d\n",
        curr_bus.mem_op.name(),curr_bus.alu_op.name(),
        curr_bus.format.name(),$signed(curr_bus.imm),curr_bus.rs1,curr_bus.rs2,curr_bus.rd,curr_bus.pc,
        curr_bus.rs1_data,curr_bus.rs2_data,$signed(curr_bus.rd_res));
    endtask

    task display_side();
        $display("Cycle : %d\n",cycle_no);
        $write("\t\tID\t\t\t|\t\t\tEX\t\t\n");
        riscv::decode_instr(id_bus.instr);
        $write("\t\t\t");
        riscv::decode_instr(ex_bus.instr);
        $write("\nMemOp: %s\t\t\t\t|\t\t MemOp: %s\nAluOp: %s\t\t\t\t|\t\t AluOp: %s\n",
        id_bus.mem_op.name(),ex_bus.mem_op.name(),id_bus.alu_op.name(),ex_bus.alu_op.name());

    endtask

endmodule