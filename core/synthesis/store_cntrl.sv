module store_cntrl 
    import riscv::*;
    import core::*;
(
    input core::pipeline_bus_t bus_i,
    input core::mem_cntrl_bus_t mem_cntrl_i,
    output core::mem_cntrl_bus_t store_cntrl_o
);

    always_comb begin : store_unit
        store_cntrl_o.addr = mem_cntrl_i.addr;
        store_cntrl_o.r_data = mem_cntrl_i.r_data;
        store_cntrl_o.w_data = mem_cntrl_i.w_data;
        store_cntrl_o.write_en = '0;
        if(bus_i.mem_op != core::MEM_NOP && bus_i.mem_op[MEM_OP_BITS-1] == core::STORE_PRFX) begin
            unique case(bus_i.mem_op)
                core::SB:begin
                    store_cntrl_o.write_en = 4'b0001;
                end
                core::SH:begin
                    store_cntrl_o.write_en = 4'b0011;
                end
                core::SW:begin
                    store_cntrl_o.write_en = 4'b1111;
                end
            endcase 
        end
        else begin
            ;
        end
    end



endmodule