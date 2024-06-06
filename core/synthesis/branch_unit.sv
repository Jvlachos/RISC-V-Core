
module branch_unit 
    import core::*;
    import riscv::*;
(
    input pipeline_bus_t bus_i,
    output logic flush_o,
    output core::br_cntrl_bus_t br_bus_o,
    output logic [31:0] rd_o
);

    
    assign flush_o = br_bus_o.is_taken & bus_i.is_branch; 


    always_comb begin : blockName
        rd_o = 32'b0;
        br_bus_o.is_taken       = 1'b0;
        br_bus_o.branch_target  = 32'b0;
        if (bus_i.is_branch) begin 
            if(bus_i.alu_op[4:3] == core::BRANCH_PRFX) begin
                br_bus_o.branch_target = bus_i.pc + bus_i.imm;
                unique case (bus_i.alu_op)
                    core::ALU_BEQ:begin
                        br_bus_o.is_taken = bus_i.rs1_data == bus_i.rs2_data;
                    end
                    core::ALU_BNE:begin
                        br_bus_o.is_taken = bus_i.rs1_data != bus_i.rs2_data;
                    end
                    core::ALU_BLT:begin
                        br_bus_o.is_taken = $signed(bus_i.rs1_data) < $signed(bus_i.rs2_data);
                    end
                    core::ALU_BGE:begin
                        br_bus_o.is_taken = $signed(bus_i.rs1_data) >= $signed(bus_i.rs2_data);
                    end
                    core::ALU_BGEU:begin
                        br_bus_o.is_taken = bus_i.rs1_data > bus_i.rs2_data;
                    end
                    core::ALU_BLTU:begin
                        br_bus_o.is_taken = bus_i.rs1_data < bus_i.rs2_data;
                    end
                endcase
            end
            else if (bus_i.alu_op[4:3] == core::J_PRFX) begin
                if(bus_i.alu_op == core::ALU_JAL) begin
                    br_bus_o.is_taken = 1'b1;
                    br_bus_o.branch_target = bus_i.pc + bus_i.imm;
                   // $display("Jal target : 0x%h + 0x%h = 0x%h\n",bus_i.rs1_data,bus_i.imm,br_bus_o.branch_target);
                //br_bus_o.branch_target[0] = 1'b0;
                end
                else begin
                    br_bus_o.is_taken = 1'b1;
                    rd_o = bus_i.pc + 4;
                    br_bus_o.branch_target = bus_i.pc + bus_i.imm;
                    br_bus_o.branch_target[0] = 1'b0;
                end
                
            end
        end
        else begin
            ;
        end
    end
    
  

endmodule