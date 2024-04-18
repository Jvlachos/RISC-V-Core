`include "../include/riscv_pkg.sv"
`include "../include/core_pkg.sv"
module decoder
    import core::*;
    import riscv::*;
 (
   input logic clk,
   input logic rst, 
   input logic [31:0] instruction_i,
   output logic [4:0] rs1_o,
   output logic [4:0] rs2_o,
   output logic [4:0] rd_o,
   output logic [4:0] alu_op_o
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
               riscv::ADDI_F3: begin  
                  alu_op_o = core::ALU_ADD;
                  $display("addi %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               end
               riscv::SLTI_F3: begin
                  alu_op_o = core::ALU_SLT;
                  $display("slti %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               end
               riscv::SLTIU_F3:  begin
                  alu_op_o = core::ALU_SLT;
                  $display("sltiu %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               end
               riscv::XORI_F3: begin 
                  alu_op_o = core::ALU_XOR;
                  $display("xori %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               end
               riscv::ORI_F3: begin   
                  alu_op_o = core::ALU_OR;
                  $display("ori %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               end
               riscv::ANDI_F3:  begin
                  alu_op_o = core::ALU_AND; 
                  $display("andi %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               end
               riscv::SLLI_F3: begin
                  alu_op_o = core::ALU_SLL;
                  $display("slli %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
               end

               riscv::SRLI_SRAI: begin 
                  case(instruction.instruction[31:25])
                     riscv::SRAI_func :begin
                        alu_op_o = core::ALU_SRA;
                        $display("srai %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
                     end
                     riscv::SRLI_func :begin 
                        alu_op_o = core::ALU_SRL;
                        $display("srli %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
                     end
                     default: $display("Illegal srli_srai fun\n");
                  endcase
               end 
               default: $display("Illegal I-Format Instruction!\n");
            endcase
          end

         riscv::S_OP: begin 
            rs1_o = instruction.stype.rs1;
            rs2_o  = instruction.stype.rs2;
            rs1_t = riscv::reg_t'(rs1_o);
            rs2_t  = riscv::reg_t'(rs2_o);
            case(instruction.stype.funct3)
              
               {riscv::SIGNED, riscv::BYTE}:$display("sb %s,%0d(%s)\n", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}), rs1_t.name);
               {riscv::SIGNED, riscv::HWORD}:$display("sh %s,%0d(%s)\n", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}), rs1_t.name);
               {riscv::SIGNED, riscv::WORD}:$display("sw %s,%0d(%s)\n", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}), rs1_t.name);
               default:$display("Illegal store?\n");
            endcase
          end          
         riscv::L_OP: begin 
            rs1_o = instruction.itype.rs1;
            rd_o  = instruction.itype.rd;
            rs1_t = riscv::reg_t'(rs1_o);
            rd_t  = riscv::reg_t'(rd_o);
            case(instruction.itype.funct3)
               {riscv::SIGNED,riscv::BYTE}:$display("lb %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);
               {riscv::SIGNED,riscv::HWORD}:$display("lh %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);
               {riscv::SIGNED,riscv::WORD}:$display("lw %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);
               {riscv::UNSIGNED,riscv::BYTE}:$display("lbu %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);
               {riscv::UNSIGNED,riscv::HWORD}:$display("lhu %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);

               default:$display("Illegal load?\n");            
            endcase
         end
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