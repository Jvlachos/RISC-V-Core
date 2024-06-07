module memory_unit 
    import riscv::*;
    import core::*;
(
    input core::pipeline_bus_t bus_i,
    output core::mem_cntrl_bus_t mem_bus
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
            if(bus_i.mem_op[0] == core::STORE_PRFX) begin
                mem_bus.addr= bus_i.imm + bus_i.rs1_data;
            end
            else begin
                mem_bus.addr = bus_i.imm + bus_i.rs1_data;
            end       
        end
        
    end
    
endmodule