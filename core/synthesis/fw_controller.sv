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
        fw_cntrl.stage = core::NONE_STAGE;
        fw_cntrl.regs  = core::RS_NONE;
        fw_cntrl.rs1 = core::NONE_STAGE;
        fw_cntrl.rs2 = core::NONE_STAGE;
        $display("RD EX :%0d\n RS1_ID : %0d\n RS2_ID : %0d\n",rd_ex,rs1_id,rs2_id);

        fw_from_mem = (rd_ex != '0) && ((rs1_id == rd_ex) || (rs2_id == rd_ex)) 
        &&  ex_bus_i.mem_op[MEM_OP_BITS-1] != core::LOAD_PRFX; 
        
        fw_from_wb  = (rd_mem!= '0) && ((rs1_id == rd_mem)|| (rs2_id == rd_mem))
        && mem_bus_i.mem_op[MEM_OP_BITS-1]!= core::LOAD_PRFX;

        
        if(fw_from_mem & fw_from_wb) begin
            fw_cntrl.stage = core::MW_STAGES;
        end
        else if(fw_from_mem)
            fw_cntrl.stage = core::MEM_STAGE;
        else if(fw_from_wb)
            fw_cntrl.stage = core::WB_STAGE;
        else 
            fw_cntrl.stage = core::NONE_STAGE;

        if(fw_cntrl.stage == core::MEM_STAGE) begin
            fw_cntrl.regs = rs1_id == rd_ex && rs2_id == rd_ex ?
            core::RS1_RS2 : rs1_id == rd_ex ? core::RS1 : core::RS2; 
            fw_cntrl.rs1 = core::MEM_STAGE;
            fw_cntrl.rs2 = core::MEM_STAGE;
        end
        else if(fw_cntrl.stage == core::WB_STAGE) begin
            fw_cntrl.regs = rs1_id == rd_mem && rs2_id == rd_mem ?
            core::RS1_RS2 : rs1_id == rd_mem ? core::RS1 : core::RS2; 
            fw_cntrl.rs1 = core::WB_STAGE;
            fw_cntrl.rs2 = core::WB_STAGE;

        end
        else if(fw_cntrl.stage == core::MW_STAGES) begin
            if(rs1_id == rd_ex) begin
                fw_cntrl.regs = core::RS1_RS2;
                fw_cntrl.rs1  = core::MEM_STAGE;
                fw_cntrl.rs2  = core::WB_STAGE;
            end
            else if(rs1_id == rd_mem) begin
                fw_cntrl.regs = core::RS1_RS2;
                fw_cntrl.rs1 = core::WB_STAGE;
                fw_cntrl.rs2 = core::MEM_STAGE;
            end
            else
                assert(0);
            
            
        end
        else begin
            fw_cntrl.regs = core::RS_NONE; 
            fw_cntrl.rs1  = core::NONE_STAGE;
            fw_cntrl.rs2  = core::NONE_STAGE;
        end
    end


    always_ff @(posedge clk,negedge rst ) begin : blockName
        if(~rst)
            fw_cntrl_o <= '0;
        else begin
            fw_cntrl_o <= fw_cntrl;
            $display("FW : %s\n",fw_cntrl.stage.name);
        end
    end



    
    
endmodule