module mem_signext (
    input core::pipeline_bus_t bus_i,
    output core::pipeline_bus_t bus_o
);

    always_comb begin 
        assign bus_o = bus_i;
        if(bus_i.mem_op != core::MEM_NOP && bus_i.mem_op[0] == core::LOAD_PRFX) begin
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
    end
    
endmodule