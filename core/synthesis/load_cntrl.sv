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
        mem2se_o.mem_op = bus_i.mem_op;
        mem2se_o.alu_op   = bus_i.alu_op;
        mem2se_o.format   = bus_i.format;
        mem2se_o.is_branch= bus_i.is_branch;
        mem2se_o.instr    = bus_i.instr;
        mem2se_o.imm      = bus_i.imm;
        mem2se_o.rs1      = bus_i.rs1;
        mem2se_o.rs2      = bus_i.rs2;
        mem2se_o.rd       = bus_i.rd;
        mem2se_o.rs1_data = bus_i.rs1_data;
        mem2se_o.rs2_data = bus_i.rs2_data;
        mem2se_o.pc       = bus_i.pc;
        mem2se_o.rf_wr_en = bus_i.rf_wr_en;
        mem2se_o.pipeline_stall = bus_i.pipeline_stall;
        
        if(bus_i.mem_op != core::MEM_NOP && bus_i.mem_op[MEM_OP_BITS-1] == core::LOAD_PRFX)begin
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
            mem2se_o.rd_res = bus_i.rd_res;
        end
    
    end

    
endmodule