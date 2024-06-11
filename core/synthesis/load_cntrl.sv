module load_cntrl 
    import riscv::*;
    import core::*;
(
    input core::pipeline_bus_t bus_i,
    input core::mem_cntrl_bus_t mem_cntrl_i,
    input logic [31:0] rdata_i,
    output core::pipeline_bus_t mem2se_o
);
    always_comb begin
        assign mem2se_o = bus_i;
        if(bus_i.mem_op != core::MEM_NOP && bus_i.mem_op[0] == core::LOAD_PRFX)begin
           unique case(bus_i.mem_op)
                core::LB:begin
                    mem2se_o.rd_res[7:0] = rdata_i [7:0]; 
                end
                core::LH:begin
                    mem2se_o.rd_res[15:0] = rdata_i[15:0];
                end
                core::LW:begin
                    mem2se_o.rd_res = rdata_i;
                end
                core::LBU:begin
                    mem2se_o.rd_res [7:0] = rdata_i[7:0];
                end
                core::LHU:begin
                    mem2se_o.rd_res[15:0] = rdata_i[7:0];
                end
            endcase 
        
        end
        else begin 
            ;
        end
    
    end

    
endmodule