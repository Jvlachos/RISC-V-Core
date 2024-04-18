`include "../include/riscv_pkg.sv"
module decoder
    import riscv::*;
 (
   input logic clk,
   input logic rst, 
   input logic [31:0] instruction_i,
   output logic [4:0] rs1_o,
   output logic [4:0] rs2_o,
   output logic [4:0] rd_o
);
   riscv::instruction_t instruction;
   assign instruction = riscv::instruction_t'(instruction_i); 
   riscv::reg_t rs1_t;
   riscv::reg_t rs2_t;
   riscv::reg_t rd_t;

   always_comb begin : instr_decoder
       case (instruction.instruction[6:0])
         riscv::I_OP: begin
            rs1_o = instruction.itype.rs1;
            rd_o  = instruction.itype.rd;
            rs1_t = riscv::reg_t'(rs1_o);
            rd_t  = riscv::reg_t'(rd_o);

            unique case (instruction.itype.funct3)
               riscv::ADDI_F3:   $display("addi %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               riscv::SLTI_F3:   $display("slti %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               riscv::SLTIU_F3:  $display("sltiu %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               riscv::XORI_F3:   $display("xori %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               riscv::ORI_F3:    $display("ori %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               riscv::ANDI_F3:   $display("andi %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               riscv::SLLI_F3:   $display("slli %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);

               riscv::SRLI_SRAI: begin 
                  case(instruction.instruction[31:25])
                     riscv::SRAI_func : $display("srai %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
                     riscv::SRLI_func :$display("srli %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
                     default: $display("Illegal srli_srai fun\n");
                  endcase
               end 
               default: $display("Illegal I-Format Instruction!\n");
            endcase
          end

         riscv::S_OP: begin ; end          
         riscv::L_OP: begin ; end
         riscv::LUI_OP: begin; end
         riscv::AUI_OP: begin; end
         riscv::JAL_OP: begin; end
         riscv::JALR_OP: begin; end
         riscv::B_OP: begin; end
         riscv::RR_OP: begin; end
         riscv::E_OP: begin; end
         default: $display("Illegal Instruction!\n");
      endcase
   end





endmodule