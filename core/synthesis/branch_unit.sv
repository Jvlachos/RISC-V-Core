
module branch_unit 
    import core::*;
    import riscv::*;
(
    input core::pipeline_bus_t bus_i,
    output logic flush_o,
    output core::br_cntrl_bus_t br_bus_o,
    input logic [31:0] rs1_in_i,
    input logic [31:0] rs2_in_i,
    output logic [31:0] rd_o
);

    
    assign flush_o = br_bus_o.is_taken & bus_i.is_branch; 
    

    always_comb begin : blockName
        rd_o = 32'b0;
        br_bus_o.is_taken       = 1'b0;
        br_bus_o.branch_target  = 32'b0;
        br_bus_o.i_addr = '0;
        if (bus_i.is_branch) begin 
            if(bus_i.alu_op[4:3] == core::BRANCH_PRFX) begin
                br_bus_o.branch_target = bus_i.pc + bus_i.imm;
                br_bus_o.i_addr = bus_i.pc[core::ADDR_WIDTH+1:2];
                unique case (bus_i.alu_op)
                    core::ALU_BEQ:begin
                        br_bus_o.is_taken = rs1_in_i == rs2_in_i;
                    end
                    core::ALU_BNE:begin
                       // $display("%0d\n != %0d\n",rs1_in_i,rs2_in_i);
                        br_bus_o.is_taken = rs1_in_i != rs2_in_i;
                    end
                    core::ALU_BLT:begin
                        br_bus_o.is_taken = $signed(rs1_in_i) < $signed(rs2_in_i);
                    end
                    core::ALU_BGE:begin
                        br_bus_o.is_taken = $signed(rs1_in_i) >= $signed(rs2_in_i);
                    end
                    core::ALU_BGEU:begin
                        br_bus_o.is_taken = rs1_in_i >= rs2_in_i;
                    end
                    core::ALU_BLTU:begin
                        br_bus_o.is_taken = rs1_in_i < rs2_in_i;
                    end
                endcase
            end
            else if (bus_i.alu_op[4:3] == core::J_PRFX) begin
                if(bus_i.alu_op == core::ALU_JAL) begin
                    br_bus_o.is_taken = 1'b1;
                    br_bus_o.branch_target = bus_i.pc + bus_i.imm;
                    rd_o = bus_i.pc + 4;
                   // $display("Jal target : 0x%h + 0x%h = 0x%h\n",rs1_in_i,bus_i.imm,br_bus_o.branch_target);
                //br_bus_o.branch_target[0] = 1'b0;
                end
                else begin
                    br_bus_o.is_taken = 1'b1;
                    rd_o = bus_i.pc + 4;
                    br_bus_o.branch_target = rs1_in_i + bus_i.imm;
                    br_bus_o.branch_target[0] = 1'b0;
                end
                
            end
        end
        else begin
            ;
        end
    end
    
  

endmodule