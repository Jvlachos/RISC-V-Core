module mem_stage
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

    logic [31:0] rdata;    
    logic [31:0] addr;
   // assign addr = exmemop[MEM_OP_BITS-1] == core::LOAD_PRFX ? ld_addr : bus_i.mem_addr;
    
    
    core::mem_cntrl_bus_t store_cntrl;
    core::pipeline_bus_t mem2se;
    core::pipeline_bus_t mem2wb;
    
    always_ff@(posedge clk,negedge rst) begin
        if(~rst) 
            addr <= '0;
        else
            addr <= mem_cntrl_i.addr;
    end
    

    load_cntrl load_unit(
        .bus_i(bus_i),
        .rdata_i(rdata),
        .mem2se_o(mem2se),
        .addr(addr));

    store_cntrl store_unit(
        .bus_i(mem_cntrl_i),
        .store_cntrl_o(store_cntrl));

    mem_signext mem_signext_inst(
        .bus_i(mem2se),
        .bus_o(mem2wb),
        .bp_o(mem_bp_o),
        .addr_offset_i(addr[1:0]));


    mem_sync_sp_rvdmem #
    (.DATA_WIDTH(core::DATA_WIDTH),
    .INIT_FILE("/home/dvlachos/project/RISC-V-Core/code/ihex/codemem.hex"))
    memory_instance(
        .clk(clk),
        .i_addr(mem_cntrl_i.addr),
        .i_wdata(store_cntrl.w_data),
        .i_wen(store_cntrl.write_en),
        .o_rdata(rdata)
    );

    always_ff @( posedge clk,negedge rst ) begin : blockName
       if(~rst) begin
            mem_bus_o[core::BUS_BITS-1:0] <= '0;
            mem_bus_o.mem_op <= core::MEM_NOP;
            mem_bus_o.alu_op <= core::ALU_NOP;
            mem_bus_o.format <= core::NOP;
            mem_bus_o.instr <= riscv::I_NOP;
            mem_bus_o <= '0;
        end    
        else begin
            mem_bus_o <= mem2wb;
        end
    end

endmodule