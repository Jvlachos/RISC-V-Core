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

   regfile_2r1w rf(
      .clk(clk),
      .i_raddr_a(id_bus_o.rs1),
      .i_raddr_b(id_bus_o.rs2),
      .i_wen(0),
      .i_waddr(0),
      .i_wdata(0),
      .o_rdata_a(id_bus_o.rs1_data),
      .o_rdata_b(id_bus_o.rs2_data)
   );

   riscv::instruction_t instruction;
   assign instruction = riscv::instruction_t'(instruction_i); 
   riscv::reg_t rs1_t;
   riscv::reg_t rs2_t;
   riscv::reg_t rd_t;
   
   always_comb begin : instr_decoder
      format               =  core::NOP;
      id_bus_o.mem_op      =  core::MEM_NOP;
      id_bus_o.alu_op      =  core::ALU_NOP;
      id_bus_o.format      =  core::NOP;
      id_bus_o.instr       =  instruction_i; 
      id_bus_o.rs1         =  'b0;
      id_bus_o.rs2         =  'b0;
      id_bus_o.rd          =  'b0;
      id_bus_o.is_branch   = 1'b0;
      id_bus_o.rd_res      =  'b0;
      id_bus_o.pc          =  pc_i;
      //instr_str_o          =  " ";

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
                     //instr_str_o = riscv::get_instr_str("addi",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
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
            id_bus_o.rs1 = instruction.stype.rs1;
            id_bus_o.rs2 = instruction.stype.rs2;
            id_bus_o.format = core::S_FORMAT;

            case(instruction.stype.funct3)
              
               {riscv::SIGNED, riscv::BYTE}: begin 
                  id_bus_o.mem_op = core::SB;
                  //instr_str_o = riscv::get_instr_str("sb", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}),{"(",rs1_t.name,")"});
               end
               {riscv::SIGNED, riscv::HWORD}:begin
                  id_bus_o.mem_op = core::SH;
                  //instr_str_o = riscv::get_instr_str("sh", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}),{"(",rs1_t.name,")"});
               end
               {riscv::SIGNED, riscv::WORD}: begin 
                  id_bus_o.mem_op = core::SW;
                  //instr_str_o = riscv::get_instr_str("sw", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}),{"(",rs1_t.name,")"});
               end
               default:$display("Illegal store?\n");
            endcase
          end          
         riscv::L_OP: begin 
            rs1_t = riscv::reg_t'(instruction.itype.rs1);
            rd_t  = riscv::reg_t'(instruction.itype.rd);
            id_bus_o.rs1 = instruction.itype.rs1;
            id_bus_o.rd  = instruction.itype.rd;
            id_bus_o.format = core::I_FORMAT;
            case(instruction.itype.funct3)
               {riscv::SIGNED,riscv::BYTE}:begin
                   id_bus_o.mem_op = core::LB;
                  //instr_str_o = riscv::get_instr_str("lb", rd_t.name, instruction.itype.imm, {"(",rs1_t.name,")"});
               end
               {riscv::SIGNED,riscv::HWORD}:begin 
                  id_bus_o.mem_op = core::LH;
                  //instr_str_o = riscv::get_instr_str("lh", rd_t.name, instruction.itype.imm, {"(",rs1_t.name,")"});
               end
               {riscv::SIGNED,riscv::WORD}:begin 
                  id_bus_o.mem_op = core::LW;
                  //instr_str_o = riscv::get_instr_str("lw", rd_t.name, instruction.itype.imm, {"(",rs1_t.name,")"});
               end
               {riscv::UNSIGNED,riscv::BYTE}:begin 
                  id_bus_o.mem_op = core::LBU;
                  //instr_str_o = riscv::get_instr_str("lbu", rd_t.name, instruction.itype.imm, {"(",rs1_t.name,")"});
               end
               {riscv::UNSIGNED,riscv::HWORD}:begin 
                  id_bus_o.mem_op = core::LHU;
                  //instr_str_o = riscv::get_instr_str("lhu", rd_t.name, instruction.itype.imm, {"(",rs1_t.name,")"});
               end

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
            id_bus_o.rs1 = instruction.rtype.rs1;
            id_bus_o.rd= instruction.rtype.rd;
            id_bus_o.rs2 = instruction.rtype.rs2;
            id_bus_o.format = core::R_FORMAT;
            unique case(instruction.rtype.funct3) 
               riscv::ADD_SUB: begin;
                  case(instruction.rtype.funct7)
                     riscv::ADD_SRL_func:begin;
                        id_bus_o.alu_op = core::ALU_ADD;
                        //instr_str_o = riscv::get_rr_str("add",rs2_t,rs1_t,rd_t);
                     end

                     riscv::SUB_SRA_func:begin;
                        id_bus_o.alu_op = core::ALU_SUB;
                        //instr_str_o = riscv::get_rr_str("sub",rs2_t,rs1_t,rd_t);
                     end

                    default:$display("Illegal add/sub?\n");
                  endcase
               end
               riscv::SLL:begin;
                  id_bus_o.alu_op = core::ALU_SLL;
                  riscv::print_r("sll",rs2_t,rs1_t,rd_t);
               end
               riscv::SLT:begin;
                  id_bus_o.alu_op = core::ALU_SLT;
                  riscv::print_r("slt",rs2_t,rs1_t,rd_t);
               end
               riscv::SLTU:begin;
                  id_bus_o.alu_op = core::ALU_SLTU;
                  riscv::print_r("sltu",rs2_t,rs1_t,rd_t);
               end
               riscv::XOR:begin;
                  id_bus_o.alu_op = core::ALU_XOR;
                  riscv::print_r("xor",rs2_t,rs1_t,rd_t);
               end
               riscv::SRL_SRA:begin;
                  case(instruction.rtype.funct7)
                     riscv::ADD_SRL_func:begin;
                        id_bus_o.alu_op = core::ALU_SRL;
                        riscv::print_r("srl",rs2_t,rs1_t,rd_t);
                     end
                     riscv::SUB_SRA_func:begin;
                        id_bus_o.alu_op = core::ALU_SRA;
                        riscv::print_r("sra",rs2_t,rs1_t,rd_t);
                     end
                     default:$display("Illegal srl/sra?\n");
                  endcase
               end
               riscv::OR:begin;
                  id_bus_o.alu_op = core::ALU_OR;
                  riscv::print_r("or",rs2_t,rs1_t,rd_t);
               end
               riscv::AND:begin;
                  id_bus_o.alu_op = core::ALU_AND;
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