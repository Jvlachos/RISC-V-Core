module ex_fw_sel 
    import core::*;
(
    input core::pipeline_bus_t bus_i,
    input core::fw_cntrl_bus_t fw_cntrl_i,
    input core::bypass_bus_t bypass_i,
    output logic [31:0] rs1_in_o,
    output logic [31:0] rs2_in_o
);


    always_comb begin : blockName
        rs1_in_o = 32'b0;
        rs2_in_o = 32'b0;

        if(fw_cntrl_i.stage != core::NONE_STAGE)begin
            assert (fw_cntrl_i.regs != core::RS_NONE) 
            else   begin
                $display("ERROR : RS NONE & STAGE!=NONE\n");
                $finish;
            end
            if(fw_cntrl_i.regs == core::RS1) begin
                rs1_in_o = bypass_i.rd;
                rs2_in_o = bus_i.rs2_data;
            end
            else if(fw_cntrl_i.regs == core::RS2) begin
                rs1_in_o = bus_i.rs1_data;
                rs2_in_o = bypass_i.rd;
            end
            else begin
                rs1_in_o = bypass_i.rd;
                rs2_in_o = bypass_i.rd;
            end
        end
        else begin
            rs1_in_o = bus_i.rs1_data;
            rs2_in_o = bus_i.rs2_data;  
        end


    end
    
endmodule