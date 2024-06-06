module alu
    import core::*;
    import riscv::*;
(
    input logic clk,
    input core::pipeline_bus_t alu_bus_i,
    output core::pipeline_bus_t alu_bus_o
);

    always_comb begin : arithmetic_unit
        assign alu_bus_o = alu_bus_i;
        

        if(~alu_bus_i.is_branch) begin
            unique case(alu_bus_i.alu_op) 
                core::ALU_ADD: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data + alu_bus_i.imm;
                        end
                        core::R_FORMAT: begin
                            if(alu_bus_i.instr[`ADD_SUB_BIT])
                                alu_bus_o.rd_res =alu_bus_i.rs1_data - alu_bus_i.rs2_data;
                            else 
                                alu_bus_o.rd_res =alu_bus_i.rs1_data + alu_bus_i.rs2_data;
                        end
                    endcase        
                end

                core::ALU_OR: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data | alu_bus_i.imm;
                        end
                        core::R_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data | alu_bus_i.rs2_data;
                        end
                    endcase
                end
                
                core::ALU_AND: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data & alu_bus_i.imm;
                        end
                        core::R_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data & alu_bus_i.rs2_data;
                        end
                    endcase
                end

                core::ALU_XOR: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data ^ alu_bus_i.imm;
                        end
                        core::R_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data ^ alu_bus_i.rs2_data;
                        end
                    endcase
                end

                core::ALU_SLL: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data << alu_bus_i.imm;          
                        end
                        core::R_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data << alu_bus_i.rs2_data;
                        end
                    endcase
                end

                core::ALU_SLT: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin
                            alu_bus_o.rd_res = $signed(alu_bus_i.rs1_data) < $signed(alu_bus_i.imm); 
                        end
                        core::R_FORMAT: begin
                            alu_bus_o.rd_res = $signed(alu_bus_i.rs1_data) < $signed(alu_bus_i.rs2_data);
                        end
                    endcase
                end

                core::ALU_SLTU: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT:begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data < alu_bus_i.imm; 
                        end
                        core::R_FORMAT: begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data < alu_bus_i.rs2_data; 
                        end
                    endcase                    
                end

                core::ALU_SRA_SRL :begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin
                            if(alu_bus_i.instr[`SRA_SRL_bit])
                                alu_bus_o.rd_res = alu_bus_i.rs1_data >> alu_bus_i.imm;
                            else 
                                alu_bus_o.rd_res = alu_bus_i.rs1_data >>> alu_bus_i.imm;          
                        end
                        core::R_FORMAT: begin
                            if(alu_bus_i.instr[`SRA_SRL_bit])
                                alu_bus_o.rd_res = alu_bus_i.rs1_data >> alu_bus_i.rs2_data;
                            else
                                alu_bus_o.rd_res = alu_bus_i.rs1_data >>> alu_bus_i.rs2_data;
                        end
                    endcase                    
                end
    /*
                core::ALU_SRA :begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT :begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data >>> alu_bus_i.imm;          
                        end
                        core::R_FORMAT :begin
                            alu_bus_o.rd_res = alu_bus_i.rs1_data >>> alu_bus_i.rs2_data;
                        end
                    endcase                    
                end
*/
                core::ALU_LUI :begin
                    alu_bus_o.rd_res = $signed(alu_bus_i.imm);
                end

                core::ALU_AUIPC :begin
                    alu_bus_o.rd_res = $signed(alu_bus_i.imm) + alu_bus_i.pc;                   
                end
                core::ALU_NOP: begin
                end
                default: $display("Illegal insts?");
            endcase
        end
        

    end


endmodule