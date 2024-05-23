module alu
    import core::*;
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
                            alu_bus_o.rd_res =alu_bus_i.rs1_data + alu_bus_i.rs2_data;
                        end
                    endcase        
                end

                core::ALU_SUB: begin
                    alu_bus_o.rd_res = alu_bus_i.rs1_data - alu_bus_i.rs2_data;
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
                            
                        end
                        core::R_FORMAT: begin
                        
                        end
                    endcase
                end

                core::ALU_SLT: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin

                        end
                        core::R_FORMAT: begin
                        
                        end
                    endcase
                end

                core::ALU_SLTU: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT:begin

                        end
                        core::R_FORMAT: begin
                        
                        end
                    endcase                    
                end

                core::ALU_SRL :begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin

                        end
                        core::R_FORMAT: begin
                        
                        end
                    endcase                    
                end

                core::ALU_SRA :begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT :begin

                        end
                        core::R_FORMAT :begin
                        
                        end
                    endcase                    
                end

                core::ALU_LUI :begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT :begin

                        end
                        core::R_FORMAT :begin
                        
                        end
                    endcase                    
                end

                core::ALU_AUIPC :begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT :begin

                        end
                        core::R_FORMAT :begin
                        
                        end
                    endcase                    
                end
                core::ALU_NOP: begin
                end
                default: $display("Illegal insts?\n");
            endcase
        end
        

    end


endmodule