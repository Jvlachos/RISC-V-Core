module assert_id 
import core::*;
import riscv::*;
(
     input logic clk,
    input logic rst,
    input logic [31:0] instruction_i,
    input  logic [31:0] pc_i,
    input  core::pipeline_bus_t wb_bus_i,
    output core::pipeline_bus_t id_bus_o,
    input logic flush_i,
    input bit stall_i,
    output logic[2:0] format_o,
    output core::pipeline_bus_t id2fw_cntrl_o,
    input bit prediction_i,
    input core::btb_entry_t btb_entry_i);


    property flush_check;
    @(posedge clk)
    flush_i |=> id_bus_o.mem_op == core::MEM_NOP && id_bus_o.alu_op == core::ALU_NOP;
    endproperty

    property stall_check;
    @(posedge clk)
    stall_i |=> id_bus_o.mem_op == core::MEM_NOP && id_bus_o.alu_op == core::ALU_NOP && id_bus_o.pipeline_stall == 1;
    endproperty

    property i_nop;
    @(posedge clk)
    instruction_i == riscv::I_NOP |=> id_bus_o.instr == riscv::I_NOP;
    endproperty

    property mem_op;
    @(posedge clk)
    id_bus.mem_op != core::MEM_NOP |=> id_bus_o.alu_op == core::ALU_NOP;
    endproperty
    
    property alu_op;
    @(posedge clk)
    id_bus.alu_op != core::ALU_NOP |=> id_bus_o.mem_op == core::MEM_NOP;
    endproperty

    assert property(mem_op);
    assert property(alu_op);
    assert property(flush_check);
    assert property(stall_check);
    assert property(i_nop);
    

endmodule