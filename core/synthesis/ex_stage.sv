module ex_stage 
    import core::*;
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

    bit pipeline_stalled;
    core::pipeline_bus_t ex_bus;
    core::mem_cntrl_bus_t ex2mem;
   
    logic [31:0] rd_branch; 
    logic [31:0] rs1_in;
    logic [31:0] rs2_in;

    memory_unit mem_unit_instance(
        .bus_i(bus_i),
        .mem_bus(ex2mem),
        .rs1_in_i(rs1_in),
        .rs2_in_i(rs2_in));

    ex_fw_sel fw_sel(
        .bus_i(bus_i),
        .fw_cntrl_i(fw_cntrl_i),
        .mem_bypass_i(mem_bypass_i),
        .wb_bypass_i(wb_bypass_i),
        .wb_bypass_late_i(wb_late_bypass_i),
        .rs1_in_o(rs1_in),
        .rs2_in_o(rs2_in));

    alu alu_instance(
     .clk(clk),
     .alu_bus_i(bus_i),
     .alu_bus_o(ex_bus),
     .rs1_in_i(rs1_in),
     .rs2_in_i(rs2_in),
     .ld_addr(ld_addr));



    branch_unit branch_unit_instance(
        .bus_i(bus_i),
        .flush_o(flush_o),
        .br_bus_o(br_bus_o),
        .rs1_in_i(rs1_in),
        .rs2_in_i(rs2_in),
        .rd_o(rd_branch));


    always_ff @( posedge clk,negedge rst ) begin  
       if(~rst) begin
            ex_bus_o[core::BUS_BITS-1:0] <= '0;
            ex_bus_o.mem_op <= core::MEM_NOP;
            ex_bus_o.alu_op <= core::ALU_NOP;
            ex_bus_o.format <= core::NOP;
            ex_bus_o.instr <= riscv::I_NOP;
//            ex2mem_o <= '0;
       end

        //else if(bus_i.pipeline_stall) begin
            //ex_bus_o[core::BUS_BITS-1:0] <= '0;
            //ex_bus_o.mem_op <= core::MEM_NOP;
            //ex_bus_o.alu_op <= core::ALU_NOP;
            //ex_bus_o.format <= core::NOP;
           // ex_bus_o.instr  <= riscv::I_NOP;
         //   ex_bus_o.pipeline_stall <= 1'b1; 
       // end
        else
            $display("BYP RS1 %0d : %s RS2 %0d : %s\n",fw_cntrl_i.rs1_addr,fw_cntrl_i.rs1.name(),fw_cntrl_i.rs2_addr,fw_cntrl_i.rs2.name());
            ex_bus_o <= ex_bus;
            ex_bus_o.rd_res <= bus_i.is_branch ? rd_branch : ex_bus.rd_res;
           
    end
    
    always_comb begin
        if(bus_i.mem_op == core::MEM_NOP)begin
            ex2mem_o = '0;
        end
        else
            ex2mem_o = ex2mem;

    end
endmodule