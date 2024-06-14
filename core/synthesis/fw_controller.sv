module fw_controller 
    import riscv::*;
    import core::*;
(
    input logic clk,
    input logic rst,
    input core::pipeline_bus_t id_bus_i,
    input core::pipeline_bus_t ex_bus_i,
    input core::pipeline_bus_t mem_bus_i,
    output core::fw_cntrl_bus_t fw_cntrl_o   
);

    core::fw_cntrl_bus_t fw_cntrl;
    logic [4:0] rs1_id,rs2_id;
    logic [4:0] rd_ex,rd_mem;
    bit fw_from_mem;
    bit fw_from_wb;
    //if mem stage has a load
    always_comb begin : fw
        rs1_id = id_bus_i.rs1;
        rs2_id = id_bus_i.rs2;
        rd_ex  = ex_bus_i.rd;
        rd_mem = mem_bus_i.rd;

        fw_from_mem = (rd_ex != '0) && ((rs1_id == rd_ex) || (rs2_id == rd_ex));
        fw_from_wb  = (rd_mem!= '0) && ((rs1_id == rd_mem)|| (rs2_id == rd_mem));

        fw_cntrl.stage = ~fw_from_mem & ~fw_from_wb ? core::NONE_STAGE :
        fw_from_mem ? core::MEM_STAGE : core::WB_STAGE;

        if(fw_cntrl.stage == core::MEM_STAGE) begin
            fw_cntrl.regs = rs1_id == rd_ex && rs2_id == rd_ex ?
            core::RS1_RS2 : rs1_id == rd_ex ? core::RS1 : core::RS2; 
        end
        else if(fw_cntrl.stage == core::WB_STAGE) begin
            fw_cntrl.regs = rs1_id == rd_mem && rs2_id == rd_mem ?
            core::RS1_RS2 : rs1_id == rd_mem ? core::RS1 : core::RS2; 
        end
        else
            fw_cntrl.regs = core::RS_NONE; 
    end


    always_ff @(posedge clk,negedge rst ) begin : blockName
        if(~rst)
            fw_cntrl_o <= '0;
        else
            fw_cntrl_o <= fw_cntrl;
    end



    
    
endmodule