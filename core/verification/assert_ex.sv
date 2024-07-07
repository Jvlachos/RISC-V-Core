module assert_ex 
import core::*;
import riscv::*;

(
    input logic clk,
    input logic rst,
    input core::pipeline_bus_t bus_i,
    input core::fw_cntrl_bus_t fw_cntrl_i,
    input core::bypass_bus_t mem_bypass_i,
    input core::bypass_bus_t wb_bypass_i,
    input core::bypass_bus_t wb_late_bypass_i,
    output core::pipeline_bus_t ex_bus_o,
    output logic flush_o,
    output core::br_cntrl_bus_t br_bus_o,
    output core::mem_cntrl_bus_t ex2mem_o,
    output logic [31:0] ld_addr
);

    property br_rd;
    @(posedge clk)
    bus_i.is_branch |=> ex_bus_o.rd_res == ex_bus.rd_res;
    endproperty 


 
endmodule