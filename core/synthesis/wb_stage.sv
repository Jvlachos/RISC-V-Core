module wb_stage 
    import riscv::*;
    import core::*;
(
    input logic clk,
    input logic rst,
    input core::pipeline_bus_t bus_i,
    output core::pipeline_bus_t wb_bus_o,
    output bit unlock_o
);

    core::pipeline_bus_t wb2all;
    assign wb2all = bus_i;

    always_ff @( posedge clk,negedge rst ) begin : blockName
       if(~rst) begin
            wb_bus_o[core::BUS_BITS-1:0] <= '0;
            wb_bus_o.mem_op <= core::MEM_NOP;
            wb_bus_o.alu_op <= core::ALU_NOP;
            wb_bus_o.format <= core::NOP;
            wb_bus_o.instr <= riscv::I_NOP;
            unlock_o <= 1'b0;
        end
        else begin
            wb_bus_o <= wb2all;
            unlock_o <= bus_i.mem_op == core::LW;
        end
    end

    
endmodule