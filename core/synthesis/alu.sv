module alu
    import core::*;
    import riscv::*;
(
    input logic clk,
    input core::pipeline_bus_t alu_bus_i,
    output core::pipeline_bus_t alu_bus_o
);
    bit is_mem;
    assign is_mem = ~alu_bus_i.is_branch && alu_bus_i.alu_op == core::ALU_NOP && alu_bus_i.mem_op != core::MEM_NOP;

    always_comb begin : arithmetic_unit
        alu_bus_o.format = alu_bus_i.format;
        alu_bus_o.imm    = alu_bus_i.imm;
        alu_bus_o.mem_op = alu_bus_i.mem_op;
        alu_bus_o.alu_op = alu_bus_i.alu_op;
        alu_bus_o.instr  = alu_bus_i.instr;
        alu_bus_o.rs1    = alu_bus_i.rs1;
        alu_bus_o.rs2    = alu_bus_i.rs2;
        alu_bus_o.rd     = alu_bus_i.rd;
        alu_bus_o.is_branch = alu_bus_i.is_branch;
        alu_bus_o.pc     = alu_bus_i.pc;
        alu_bus_o.pipeline_stall = alu_bus_i.pipeline_stall;
        alu_bus_o.rs1_data = alu_bus_i.rs1_data;
        alu_bus_o.rs2_data = alu_bus_i.rs2_data;
        alu_bus_o.rd_res = 32'b0;
        alu_bus_o.rf_wr_en = 0;
        
        if(~alu_bus_i.is_branch & ~is_mem) begin
            alu_bus_o.rf_wr_en = 1'b1;
            $display("FORMAT :%s\n",alu_bus_i.format.name());
            unique case(alu_bus_i.alu_op) 
                core::ALU_ADD: begin
                    unique case(alu_bus_i.format)
                        core::I_FORMAT: begin
                            $display("HERE??\n");
                            alu_bus_o.rd_res = alu_bus_i.rs1_data + alu_bus_i.imm;
                            $display("RES : %d = RS1 :%d + I :%d\n",alu_bus_o.rd_res,alu_bus_i.rs1_data,alu_bus_i.imm);
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
                    $display("ALU_NOP\n");
                end
                default: $display("Illegal insts?");
            endcase
        end
        

    end


endmodule