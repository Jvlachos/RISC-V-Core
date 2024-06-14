module mem_signext 
    import core::*;
(
    input core::pipeline_bus_t bus_i,
    output core::pipeline_bus_t bus_o
);

    always_comb begin 
        bus_o.mem_op = bus_i.mem_op;
        bus_o.alu_op   = bus_i.alu_op;
        bus_o.format   = bus_i.format;
        bus_o.is_branch= bus_i.is_branch;
        bus_o.instr    = bus_i.instr;
        bus_o.imm      = bus_i.imm;
        bus_o.rs1      = bus_i.rs1;
        bus_o.rs2      = bus_i.rs2;
        bus_o.rd       = bus_i.rd;
        bus_o.rs1_data = bus_i.rs1_data;
        bus_o.rs2_data = bus_i.rs2_data;
        bus_o.pc       = bus_i.pc;
        bus_o.rf_wr_en = bus_i.rf_wr_en;
        bus_o.pipeline_stall = bus_i.pipeline_stall;
    

        if(bus_i.mem_op != core::MEM_NOP && bus_i.mem_op[MEM_OP_BITS-1] == core::LOAD_PRFX) begin
            unique case (bus_i.mem_op)
                core::LB:begin
                    bus_o.rd_res = {{24{bus_i.rd_res[7]}},bus_i.rd_res[7:0]};
                end
                core::LH:begin
                    bus_o.rd_res = {{16{bus_i.rd_res[15]}},bus_i.rd_res[15:0]};
                end
                core::LW:begin
                    ;
                end
                core::LBU:begin
                    bus_o.rd_res = {{24{1'b0}},bus_i.rd_res[7:0]};
                end
                core::LHU:begin
                    bus_o.rd_res = {{16{1'b0}},bus_i.rd_res[15:0]};
                end
            endcase
        end
        else
            bus_o.rd_res = bus_i.rd_res;
        
    end
    
endmodule