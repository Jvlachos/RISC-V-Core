module mem_stage
    import riscv::*;
    import core::*;
(
   input logic clk,
   input logic rst,
   input core::pipeline_bus_t bus_i,
   input core::mem_cntrl_bus_t mem_cntrl_i,
   output core::pipeline_bus_t mem_bus_o,
   output core::mem_cntrl_bus_t mem_cntrl_o
);

    logic [31:0] rdata;    

    core::mem_cntrl_bus_t store_cntrl;
    core::mem_cntrl_bus_t load_cntrl;
    core::pipeline_bus_t mem2se;
    core::pipeline_bus_t mem2wb;


    load_cntrl load_unit(
        .bus_i(bus_i),
        .mem_cntrl_i(mem_cntrl_i),
        .rdata_i(rdata),
        .mem2se_o(mem2se));

    store_cntrl store_unit(
        .bus_i(bus_i),
        .mem_cntrl_i(mem_cntrl_i),
        .store_cntrl_o(store_cntrl));

    mem_signext mem_signext_inst(
        .bus_i(bus_i),
        .bus_o(mem2wb));


    mem_sync_sp_rvdmem #
    (.DATA_WIDTH(core::DATA_WIDTH),
    .INIT_ZERO(1))
    memory_instance(
        .clk(clk),
        .i_addr(mem_cntrl_i.addr),
        .i_wdata(bus_i.rs2_data),
        .i_wen(store_cntrl.write_en),
        .o_rdata(rdata)
    );



endmodule