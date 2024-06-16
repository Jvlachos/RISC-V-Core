module wb_stage 
    import riscv::*;
    import core::*;
(
    input logic clk,
    input logic rst,
    input core::pipeline_bus_t bus_i,
    output core::pipeline_bus_t wb_bus_o,
    output bit unstall_o,
    output core::bypass_bus_t wb_bp_o);

    assign wb_bp_o.rd = bus_i.rd_res;
    assign wb_bp_o.rd_addr = bus_i.rd;
    assign wb_bus_o = bus_i;

    always_ff @( posedge clk) begin 
            unstall_o <= bus_i.pipeline_stall;
    end

    
endmodule