module fw_controller 
    import riscv::*;
    import core::*;
(
    input logic clk,
    input logic rst,
    input core::pipeline_bus_t id_bus_i,
    input core::pipeline_bus_t ex_bus_i,
    input core::pipeline_bus_t mem_bus_i,
    input core::pipeline_bus_t wb_bus_i,
    input core::pipeline_bus_t wb_late_bus_i,
    output core::fw_cntrl_bus_t fw_cntrl_o   
);

    core::fw_cntrl_bus_t fw_cntrl;
    logic [4:0] rs1_id,rs2_id;
    logic [4:0] rd_ex,rd_mem,rd_wb,rd_wb_late;
    bit fw_from_mem;
    bit fw_from_wb;
    //if mem stage has a load
    always_comb begin : fw
        //rs1_id = id_bus_i.rs1;
        ///rs2_id = id_bus_i.rs2;
        rs1_id = ex_bus_i.rs1;
        rs2_id = ex_bus_i.rs2;
        rd_ex  = ex_bus_i.rd;
        rd_mem = mem_bus_i.rd;
        rd_wb  = wb_bus_i.rd;
        rd_wb_late = wb_late_bus_i.rd;
        fw_cntrl.stage = core::NONE_STAGE;
        fw_cntrl.regs  = core::RS_NONE;
        fw_cntrl.rs1 = core::NONE_STAGE;
        fw_cntrl.rs2 = core::NONE_STAGE;

        //fw_from_mem = (rd_ex != '0) && ((rs1_id == rd_ex) || (rs2_id == rd_ex)) 
//        && ex_bus_i.rf_wr_en &&  ex_bus_i.mem_op[MEM_OP_BITS-1] != core::LOAD_PRFX; 

        //if(ex_bus_i.mem_op[MEM_OP_BITS-1] != core::LOAD_PRFX) begin
            if((rs1_id == rd_mem && rd_mem!='0) && mem_bus_i.rf_wr_en == 1 ) begin
                fw_cntrl.rs1 = core::MEM_STAGE;
                fw_cntrl.rs1_addr = rd_mem;
            end
            else if((rs1_id == rd_wb && rd_wb !='0) && wb_bus_i.rf_wr_en == 1) begin
                fw_cntrl.rs1 = core::WB_STAGE;
                fw_cntrl.rs1_addr = rd_wb;
            end
            else if((rs1_id == rd_wb_late && rd_wb_late!='0) && wb_late_bus_i.rf_wr_en == 1) begin
                fw_cntrl.rs1 = core::WBLATE_STAGE;
                fw_cntrl.rs1_addr = rd_wb_late;
            end
            else begin
                fw_cntrl.rs1 = core::NONE_STAGE;
                fw_cntrl.rs1_addr = '0;
            end

            if((rs2_id == rd_mem && rd_mem!='0) && mem_bus_i.rf_wr_en == 1) begin
                fw_cntrl.rs2 = core::MEM_STAGE;
                fw_cntrl.rs2_addr = rd_mem;
            end
            else if((rs2_id == rd_wb && rd_wb!='0) && wb_bus_i.rf_wr_en == 1) begin
                fw_cntrl.rs2 = core::WB_STAGE;
                fw_cntrl.rs2_addr = rd_wb;
            end
            else if((rs2_id == rd_wb_late && rd_wb_late!='0) && wb_late_bus_i.rf_wr_en == 1) begin
                fw_cntrl.rs2 = core::WBLATE_STAGE;
                fw_cntrl.rs2_addr = rd_wb_late;
            end
            else begin
                fw_cntrl.rs2 = core::NONE_STAGE;
                fw_cntrl.rs2_addr = '0;
            end
      //  end
       // else begin
        ///    fw_cntrl.rs1_addr = '0;
        //    fw_cntrl.rs2_addr = '0;
        //    fw_cntrl.rs1 = core::NONE_STAGE;
        //    fw_cntrl.rs2 = core::NONE_STAGE;
       // end



       // fw_from_wb  = (rd_mem!= '0) && ((rs1_id == rd_mem || rs1_id == rd_wb)|| (rs2_id == rd_mem || rs2_id == rd_wb)) && (mem_bus_i.rf_wr_en || wb_bus_i.rf_wr_en)
        //&& mem_bus_i.mem_op[MEM_OP_BITS-1]!= core::LOAD_PRFX;
/*        $display("WB : %0d ID : %0d \n",rd_wb,rs1_id);
        
        if((fw_from_mem & fw_from_wb) && rd_ex != rd_mem) begin
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
            
          //  fw_cntrl.regs = (rs1_id == rd_mem && rs2_id == rd_mem) || (rs1_id == rd_wb || rs2_id == rd_wb) ?
            //core::RS1_RS2 : rs1_id == rd_mem || rs1_id == rd_wb ? core::RS1 : core::RS2;
            if(rs1_id == rd_mem && rs2_id == rd_mem) begin
                fw_cntrl.regs = core::RS1_RS2;
            end
            else if(rs1_id == rd_wb && rs2_id == rd_wb) begin
                fw_cntrl.regs = core::RS1_RS2;
            end
            else if(rs1_id == rd_wb && rs2_id == rd_mem) begin
                fw_cntrl.regs = core::RS1_RS2;
            end
            else if(rs2_id == rd_wb && rs1_id == rd_mem) begin
                fw_cntrl.regs = core::RS1_RS2;
            end
            else if(rs1_id == rd_mem || rs1_id == rd_wb) begin
                fw_cntrl.regs = core::RS1;
            end
            else if(rs2_id == rd_mem || rs2_id == rd_wb) begin
                fw_cntrl.regs = core::RS1;
            end
            else
                assert(0);
            

            fw_cntrl.rs1 = core::WB_STAGE;
            fw_cntrl.rs2 = core::WB_STAGE;
            $display("REGS : %s\n",fw_cntrl.regs.name);
        end
        else if(fw_cntrl.stage == core::MW_STAGES) begin
            if(rs1_id == rd_ex) begin
                fw_cntrl.regs = core::RS1_RS2;
                fw_cntrl.rs1  = core::MEM_STAGE;
                fw_cntrl.rs2  = core::WB_STAGE;
            end
            else if(rs1_id == rd_mem || rs1_id == rd_wb) begin
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
        */
    end


//    always_ff @(posedge clk,negedge rst ) begin : blockName
  //      if(~rst)
    //        fw_cntrl_o <= '0;
      //  else begin
        //    fw_cntrl_o <= fw_cntrl;
        //end
    //end
    assign fw_cntrl_o = fw_cntrl;


    
    
endmodule