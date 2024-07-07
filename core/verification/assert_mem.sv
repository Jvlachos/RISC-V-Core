module moduleName
import riscv::*;
import core::*;
 (
    input logic clk,
   input logic rst,
   input core::pipeline_bus_t bus_i,
   input core::mem_cntrl_bus_t mem_cntrl_i,
   output core::pipeline_bus_t mem_bus_o,
   output core::bypass_bus_t mem_bp_o
);
    
    property ld_check;
    @(posedge clk)
    ($past(mem_cntrl_i.addr) != mem_cntrl_i.addr) |-> $past(rdata) != rdata; 
    endproperty

endmodule