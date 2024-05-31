module id_stage 
    import riscv::*;
    import core::*;
(
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_i,
    input  logic [31:0] pc_i,
    output core::pipeline_bus_t id_bus_o,
    input logic flush_i);

    core::pipeline_bus_t id_bus;
    

    decoder ins_decoder(
    .clk(clk),
    .rst(rst),
    .instruction_i(instruction_i),
    .pc_i(pc_i),
    .id_bus_o(id_bus));

 
    always_ff @(posedge clk,negedge rst ) begin
        if(~rst | flush_i) begin
            $display("Flushing..\n");
            id_bus_o[core::BUS_BITS-1:0] <= '0;
            id_bus_o.mem_op <= core::MEM_NOP;
            id_bus_o.alu_op <= core::ALU_NOP;
            id_bus_o.format <= core::NOP;
            id_bus_o.instr  <= riscv::I_NOP;
        end
        else begin
            id_bus_o <= id_bus;
        end
        
    end

endmodule