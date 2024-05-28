
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
    logic [31:0] pc;

    always# (`CLK_PERIOD) clk = ~clk;
    core::pipeline_bus_t id_bus;
    core::pipeline_bus_t ex_bus;
   
    int cycle_no = 0;

    if_stage if_s(
    .clk(clk),
    .rst(rst),
    .wdata_i(wdata),
    .wen_i(wen),
    .pc_incr_en_i(pc_incr),
    .instr_o(instruction),
    .pc_o(pc));

    //decoder_tb dec_s(.clk(clk),.rst(rst),.instruction_i(instruction));
    id_stage id_s(
        .clk(clk),
        .rst(rst),
        .instruction_i(instruction),
        .pc_i(pc),
        .id_bus_o(id_bus));

    ex_stage ex_s(
        .clk(clk),
        .rst(rst),
        .bus_i(id_bus),
        .ex_bus_o(ex_bus)
    );
    

    initial begin
        @(posedge clk);
    
        rst = 1;
        repeat(10) begin
            pc_incr = 1;
            #5;
            @(posedge clk);
            cycle_no ++;
            pc_incr = 0;
            #5;
            display_bus(id_bus,"ID");
            display_bus(ex_bus,"EX");
            $display("\n ---------------------------------------------------- \n");
            #5;
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


endmodule