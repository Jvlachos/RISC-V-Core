module ex_stage 
    import core::*;
(
    input logic clk,
    input logic rst,
    input core::pipeline_bus_t bus_i,
    output core::pipeline_bus_t ex_bus_o,
    output logic flush_o,
    output core::br_cntrl_bus_t br_bus_o
);

    core::pipeline_bus_t ex_bus;
    

    alu alu_instance(
     .clk(clk),
     .alu_bus_i(bus_i),
     .alu_bus_o(ex_bus));


    branch_unit branch_unit_instance(
        .bus_i(bus_i),
        .flush_o(flush_o),
        .br_bus_o(br_bus_o));

    always_ff @( posedge clk,negedge rst ) begin  
       if(~rst) begin
            ex_bus_o[core::BUS_BITS-1:0] <= '0;
            ex_bus_o.mem_op <= core::MEM_NOP;
            ex_bus_o.alu_op <= core::ALU_NOP;
            ex_bus_o.format <= core::NOP;
            ex_bus_o.instr <= riscv::I_NOP;
       end
        else
            ex_bus_o <= ex_bus; 
    end


endmodule