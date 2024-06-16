module memory_unit 
    import riscv::*;
    import core::*;
(
    input core::pipeline_bus_t bus_i,
    output core::mem_cntrl_bus_t mem_bus,
    input logic [31:0] rs1_in_i
);

    bit is_mem;
    assign is_mem = ~bus_i.is_branch &&
     bus_i.alu_op == core::ALU_NOP   && 
     bus_i.mem_op != core::MEM_NOP; 

    always_comb begin : address_gen
        mem_bus.write_en  = '0;
        mem_bus.addr   = 32'b0;
        mem_bus.r_data = 32'b0;
        mem_bus.w_data = 32'b0;

        if(is_mem) begin
            mem_bus.addr= bus_i.imm + bus_i.rs1_data;
        end
        
    end
    
endmodule