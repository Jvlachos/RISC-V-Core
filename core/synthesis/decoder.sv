module decoder
    import core::*;
    import riscv::*;
 (
   input logic clk,
   input logic rst, 
   input logic [31:0] instruction_i,
   input  logic [31:0] pc_i,
   output core::pipeline_bus_t id_bus_o
);
   logic [2:0] format;
   imm_generator im_gen(
        .instr_i(instruction_i),
        .format_i(format),
        .imm_o(id_bus_o.imm));

   riscv::instruction_t instruction;
   assign instruction = riscv::instruction_t'(instruction_i); 
   riscv::reg_t rs1_t;
   riscv::reg_t rs2_t;
   riscv::reg_t rd_t;
   
   always_comb begin : instr_decoder
      format = core::NOP;
      id_bus_o.mem_op = core::MEM_NOP;
      id_bus_o.alu_op = core::ALU_NOP;
      id_bus_o.format = core::NOP;
      id_bus_o.instr  = instruction_i; 
      id_bus_o.rs1    = 'bx;
      id_bus_o.rs2    = 'bx;
      id_bus_o.rd     = 'bx;
      id_bus_o.pc     = pc_i;

       case (instruction.instruction[6:0])
         riscv::I_OP: begin
            rs1_t = riscv::reg_t'(instruction.itype.rs1);
            rd_t  = riscv::reg_t'(instruction.itype.rd);
            format = core::I_FORMAT;

            //bus
            id_bus_o.format = core::I_FORMAT;
            id_bus_o.rs1    = instruction.itype.rs1;
            id_bus_o.rd     = instruction.itype.rd;

            unique case (instruction.itype.funct3)
               riscv::ADDI_F3: begin  
                  if(instruction.itype.rs1 == 5'b0 &&  instruction.itype.rd == 5'b0 && instruction.itype.imm ==0 )
                     $display("NOP\n");
                  else begin;
                     id_bus_o.alu_op = core::ALU_ADD;
                     $display("addi %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                  end
               end
               riscv::SLTI_F3: begin
                  id_bus_o.alu_op = core::ALU_SLT;
                  $display("slti %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
               end
               riscv::SLTIU_F3:  begin
                  id_bus_o.alu_op = core::ALU_SLTU;
                  $display("sltiu %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
               end
               riscv::XORI_F3: begin 
                  id_bus_o.alu_op = core::ALU_XOR;
                  $display("xori %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
               end
               riscv::ORI_F3: begin   
                  id_bus_o.alu_op = core::ALU_OR;
                  $display("ori %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
               end
               riscv::ANDI_F3:  begin
                  id_bus_o.alu_op = core::ALU_AND;
                  $display("andi %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
               end
               riscv::SLLI_F3: begin
                  id_bus_o.alu_op = core::ALU_SLL;
                  $display("slli %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
               end

               riscv::SRLI_SRAI: begin 
                  case(instruction.instruction[31:25])
                     riscv::SRAI_func :begin
                        id_bus_o.alu_op = core::ALU_SRA;
                        $display("srai %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                     end
                     riscv::SRLI_func :begin 
                        id_bus_o.alu_op = core::ALU_SRL;
                        $display("srli %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
                     end
                     default: $display("Illegal srli_srai fun\n");
                  endcase
               end 
               default: $display("Illegal I-Format Instruction!\n");
            endcase
          end

         riscv::S_OP: begin 
            format = core::S_FORMAT;
            rs1_t = riscv::reg_t'(instruction.stype.rs1);
            rs2_t  = riscv::reg_t'(instruction.stype.rs2);
            case(instruction.stype.funct3)
              
               {riscv::SIGNED, riscv::BYTE}:$display("sb %s,%0d(%s)\n", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}), rs1_t.name);
               {riscv::SIGNED, riscv::HWORD}:$display("sh %s,%0d(%s)\n", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}), rs1_t.name);
               {riscv::SIGNED, riscv::WORD}:$display("sw %s,%0d(%s)\n", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}), rs1_t.name);
               default:$display("Illegal store?\n");
            endcase
          end          
         riscv::L_OP: begin 
            rs1_t = riscv::reg_t'(instruction.itype.rs1);
            rd_t  = riscv::reg_t'(instruction.itype.rd);
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
         riscv::RR_OP: begin;
            format = core::R_FORMAT;
            rs1_t = riscv::reg_t'(instruction.rtype.rs1);
            rd_t  = riscv::reg_t'(instruction.rtype.rs2);
            rs2_t  = riscv::reg_t'(instruction.rtype.rd);
            unique case(instruction.rtype.funct3) 
               riscv::ADD_SUB: begin;
                  case(instruction.rtype.funct7)
                     riscv::ADD_SRL_func:begin;
                        riscv::print_r("add",rs2_t,rs1_t,rd_t);
                     end

                     riscv::SUB_SRA_func:begin;
                        riscv::print_r("sub",rs2_t,rs1_t,rd_t);
                     end

                    default:$display("Illegal add/sub?\n");
                  endcase
               end
               riscv::SLL:begin;
                  riscv::print_r("sll",rs2_t,rs1_t,rd_t);
               end
               riscv::SLT:begin;
                  riscv::print_r("slt",rs2_t,rs1_t,rd_t);
               end
               riscv::SLTU:begin;
                  riscv::print_r("sltu",rs2_t,rs1_t,rd_t);
               end
               riscv::XOR:begin;
                  riscv::print_r("xor",rs2_t,rs1_t,rd_t);
               end
               riscv::SRL_SRA:begin;
                  case(instruction.rtype.funct7)
                     riscv::ADD_SRL_func:begin;
                        riscv::print_r("srl",rs2_t,rs1_t,rd_t);
                     end
                     riscv::SUB_SRA_func:begin;
                        riscv::print_r("sra",rs2_t,rs1_t,rd_t);
                     end
                     default:$display("Illegal srl/sra?\n");
                  endcase
               end
               riscv::OR:begin;
                  riscv::print_r("or",rs2_t,rs1_t,rd_t);
               end
               riscv::AND:begin;
                  riscv::print_r("and",rs2_t,rs1_t,rd_t);
               end

               default: $display("Illegal Rformat?\n"); 

            endcase
         end
         riscv::E_OP: begin; end
         default: $display("Illegal Instruction!\n");
      endcase
   end





endmodule