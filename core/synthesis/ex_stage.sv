module ex_stage 
    import core::*;
(
    input logic clk,
    input logic rst,
    input core::pipeline_bus_t bus_i,
    input core::fw_cntrl_bus_t fw_cntrl_i,
    input core::bypass_bus_t mem_bypass_i,
    input core::bypass_bus_t wb_bypass_i,
    output core::pipeline_bus_t ex_bus_o,
    output logic flush_o,
    output core::br_cntrl_bus_t br_bus_o,
    output core::mem_cntrl_bus_t ex2mem_o
);

    bit pipeline_stalled;
    core::pipeline_bus_t ex_bus;
    core::mem_cntrl_bus_t ex2mem;
    core::bypass_bus_t curr_bypass;

    assign curr_bypass = fw_cntrl_i.stage == core::MEM_STAGE ? mem_bypass_i :
    fw_cntrl_i.stage == core::WB_STAGE ? wb_bypass_i : '0;
    logic [31:0] rd_branch; 

    memory_unit mem_unit_instance(
        .bus_i(bus_i),
        .mem_bus(ex2mem));

    alu alu_instance(
     .clk(clk),
     .alu_bus_i(bus_i),
     .alu_bus_o(ex_bus));


    branch_unit branch_unit_instance(
        .bus_i(bus_i),
        .flush_o(flush_o),
        .br_bus_o(br_bus_o),
        .rd_o(rd_branch));


    always_ff @( posedge clk,negedge rst ) begin  
       if(~rst) begin
            ex_bus_o[core::BUS_BITS-1:0] <= '0;
            ex_bus_o.mem_op <= core::MEM_NOP;
            ex_bus_o.alu_op <= core::ALU_NOP;
            ex_bus_o.format <= core::NOP;
            ex_bus_o.instr <= riscv::I_NOP;
            ex2mem_o <= '0;
       end
        else
            $display("BYP : %s\n",fw_cntrl_i.stage.name());
            ex_bus_o <= ex_bus;
            ex_bus_o.rd_res <= bus_i.is_branch ? rd_branch : ex_bus.rd_res;
            ex2mem_o <= ex2mem;
    end


endmodule