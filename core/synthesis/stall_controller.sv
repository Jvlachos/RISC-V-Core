module stall_controller 
    import riscv::*;
    import core::*;
(
    input logic [31:0] instr_i,
    input core::pipeline_bus_t exmem_bus_i,
    input  bit unlock_i,
    output bit stall_o,
    input logic [2:0] format_i  
);
    core::formats_t format;
    riscv::instruction_t instruction;
    assign instruction = riscv::instruction_t'(instr_i);
    assign format = core::formats_t'(format_i);
    logic [4:0] ld_rd;

    always_comb begin
        ld_rd = 5'b0;
        stall_o = 1'b0;
        if(instruction.instruction != riscv::I_NOP && exmem_bus_i.instr[6:0] == riscv::L_OP  ) begin
            ld_rd = exmem_bus_i.rd;
            unique  case(format_i)
                core::I_FORMAT: begin
                    stall_o = ld_rd!=0 && ld_rd == instruction.itype.rs1; 
                end
                core::S_FORMAT: begin
                    stall_o = (ld_rd == instruction.stype.rs1) || (ld_rd == instruction.stype.rs2);
                end
                core::U_FORMAT: begin
                    ;
                end
                core::R_FORMAT: begin
                    stall_o = (ld_rd == instruction.rtype.rs1) || (ld_rd == instruction.rtype.rs2);
                end
                core::B_FORMAT: begin
                    stall_o = (ld_rd == instruction.btype.rs1) || (ld_rd == instruction.btype.rs2);
                end
                core::J_FORMAT: begin
                    if(instruction.instruction[6:0] == core::ALU_JALR) begin
                        stall_o = ld_rd == instruction.itype.rs1;
                    end
                    else begin
                        ;
                    end
                end
                core::NOP: begin
                    ;
                end
            endcase
            $display("STALL : %0b\n",stall_o);
        end
        else begin
            ;
        end
    end
    
endmodule