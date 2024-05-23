module id_stage 
    import riscv::*;
    import core::*;
(
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_i,
    input  logic [31:0] pc_i,
    output core::pipeline_bus_t id_bus_o);

    core::pipeline_bus_t id_bus;

    decoder ins_decoder(
    .clk(clk),
    .rst(rst),
    .instruction_i(instruction_i),
    .pc_i(pc_i),
    .id_bus_o(id_bus));

 
   
    always_ff @(posedge clk,negedge rst ) begin
        if(~rst) begin
            id_bus_o <= 0;
        end
        else begin
            id_bus_o <= id_bus;
        end
        
    end

endmodule