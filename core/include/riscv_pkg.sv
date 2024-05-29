

package riscv;

    typedef enum logic { 
        SIGNED = 1'b0,
        UNSIGNED = 1'b1
    } sign_t;

    typedef enum logic[1:0]{
        BYTE = 2'b00,
        HWORD =2'b01,
        WORD  =2'b10 
    } size_t;


    typedef enum logic [4:0] {
        x[0:31]
    } reg_t;

    typedef struct packed {
        logic [31:25] funct7;    
        logic [24:20] rs2;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7]  rd;
        logic [6:0]   opcode;
    } rtype_t;
    
    typedef struct packed {
        logic [31:20] imm;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7]  rd;
        logic [6:0]   opcode;    
    } itype_t;
    
    typedef struct packed {
        logic [31:25] imm;
        logic [24:20] rs2;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7]  imm_2;
        logic [6:0]   opcode;
    } stype_t;

    typedef struct packed {
        logic [31:25] imm;
        logic [24:20] rs2;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7]  imm_2;
        logic [6:0]   opcode;
    } btype_t;


    typedef struct packed {
        logic [31:12] imm;
        logic [11:7]  rd;
        logic [6:0]   opcode;     
    } utype_t;
    
    typedef union packed {
        logic [31:0] instruction;
        rtype_t rtype;
        itype_t itype;
        stype_t stype;
        utype_t utype;
        btype_t btype;
    } instruction_t;

    localparam  LUI_OP   =   7'b0110111;  
    localparam  AUI_OP   =   7'b0010111;

    localparam  JAL_OP   =   7'b1101111;
    localparam  JALR_OP  =   7'b1100111;

    localparam  B_OP     =   7'b1100011;

    typedef enum logic [2:0] {    
    BEQ_F3   =   3'b000,
    BNE_F3   =   3'b001,
    BLT_F3   =   3'b100,
    BGE_F3   =   3'b101,
    BLTU_F3  =   3'b110,
    BGEU_F3  =   3'b111
    } B_F3_t; 

    localparam  L_OP     =   7'b0000011;

    localparam  S_OP     =   7'b0100011;

    localparam  I_OP     =   7'b0010011;

    typedef enum logic [2:0] {
    ADDI_F3  =   3'b000,
    SLTI_F3  =   3'b010,
    SLTIU_F3 =   3'b011,
    XORI_F3  =   3'b100,
    ORI_F3   =   3'b110,
    ANDI_F3  =   3'b111,
    SLLI_F3  =   3'b001,
    SRLI_SRAI=   3'b101

    } I_F3_t;

    localparam  SLLI_F7  =   7'b0000000;
    localparam  SRLI_func=   7'b0000000;
    localparam  SRAI_func=   7'b0100000;
    `define SRA_SRL_bit 30 
    

    localparam  RR_OP   =    7'b0110011;
    typedef enum logic [2:0]{
    ADD_SUB =    3'b000,
    SLL     =    3'b001,
    SLT     =    3'b010,
    SLTU    =    3'b011,
    XOR     =    3'b100,
    SRL_SRA =    3'b101,
    OR      =    3'b110,
    AND     =    3'b111
    } R_F3_t;

    localparam  ADD_SRL_func=    7'b0000000;
    localparam  SUB_SRA_func=    7'b0100000;
    `define     ADD_SUB_BIT 30

    localparam  E_OP    =    7'b1110011;
    localparam  ECALL_i =    12'b000000000000;
    localparam  EBR_i   =    12'b000000000001;

    function automatic logic [31:0] gen_rr(logic [4:0] rs2,logic [4:0] rs1,R_F3_t f3,logic [4:0] rd ,logic select);
        logic [6:0] f7 = ((f3 == ADD_SUB || f3 == SRL_SRA) && select) ? SUB_SRA_func : ADD_SRL_func;
        return {f7,rs2,rs1,f3,rd,RR_OP};
    endfunction

    function automatic logic [31:0] gen_btype(logic [4:0] rs1,logic [4:0] rs2,B_F3_t f3,logic [6:0] imm,logic [4:0] imm_2);
        $display("Im1 : %b Im2 : %b\n",imm,imm_2);
        return {imm,rs2,rs1,f3,imm_2,B_OP};
    endfunction

    //I Format Generation
    function automatic logic [31:0] addi(logic [4:0] rd,logic [4:0] rs,logic [11:0] imm);
        return {imm,rs,ADDI_F3,rd,I_OP};        
    endfunction

    function automatic logic [31:0] slti(logic [4:0] rd,logic [4:0] rs,logic [11:0] imm);
        return {imm,rs,SLTI_F3,rd,I_OP};        
    endfunction

    
    function automatic logic [31:0] sltiu(logic [4:0] rd,logic [4:0] rs,logic [11:0] imm);
        return {imm,rs,SLTIU_F3,rd,I_OP};        
    endfunction

    
    function automatic logic [31:0] xori(logic [4:0] rd,logic [4:0] rs,logic [11:0] imm);
        return {imm,rs,XORI_F3,rd,I_OP};        
    endfunction

    function automatic logic [31:0] ori(logic [4:0] rd,logic [4:0] rs,logic [11:0] imm);
        return {imm,rs,ORI_F3,rd,I_OP};        
    endfunction

    function automatic logic [31:0] andi(logic [4:0] rd,logic [4:0] rs,logic [11:0] imm);
        return {imm,rs,ANDI_F3,rd,I_OP};        
    endfunction

     function automatic logic [31:0] slli(logic [4:0] rd,logic [4:0] rs,logic [4:0] shamt);
        return {SLLI_F7,shamt,rs,SLLI_F3,rd,I_OP};        
    endfunction
        
    function automatic logic [31:0] srli(logic [4:0] rd,logic [4:0] rs,logic [4:0] shamt);
        return {SRLI_func,shamt,rs,SRLI_SRAI,rd,I_OP};        
    endfunction

    function automatic logic [31:0] srai(logic [4:0] rd,logic [4:0] rs,logic [4:0] shamt);
        return {SRAI_func,shamt,rs,SRLI_SRAI,rd,I_OP};        
    endfunction

    function automatic logic [31:0] store(logic [4:0] rs2,logic [4:0] rs1,logic [6:0] imm,logic [4:0] offset,logic [1:0] size);
        return {imm,rs2,rs1,{1'b0,size},offset,S_OP};        
    endfunction

    function automatic logic [31:0] load(logic [11:0] imm,logic [4:0] rd,logic [4:0] rs,logic [1:0] size,logic sign);
        return {imm,rs,{sign,size},rd,L_OP};        
    endfunction

    function automatic logic [31:0] store_num(logic [4:0] rs2,logic [4:0] rs1,logic [11:0] num,logic [1:0] size);
        logic [6:0] imm;
        logic [4:0] offset;
        imm = num[11:5];
        offset = num [4:0];
        return {imm,rs2,rs1,{1'b0,size},offset,S_OP};        
    endfunction

    function automatic print_r(string id,reg_t rs2,reg_t rs1,reg_t rd);
        $display("%s %s,%s,%s\n",id,rd,rs1,rs2);
    endfunction

    function automatic get_rr_str(string id,reg_t rs2,reg_t rs1,reg_t rd);
        return {id,",",rs2.name(),",",rs1.name(),",",rd.name()};
    endfunction

    function automatic string get_instr_str(string id,string arg1,string arg2,string arg3);
        return {id,",",arg1,",",arg2,",",arg3};
    endfunction

    

  function automatic decode_instr(logic [31:0] instr);
        riscv::instruction_t instruction;
        riscv::reg_t rs1_t;
        riscv::reg_t rs2_t;
        riscv::reg_t rd_t;
        instruction = riscv::instruction_t'(instr); 
        $display("Instruction : ");
        case (instruction.instruction[6:0])
            riscv::I_OP: begin
                rs1_t = riscv::reg_t'(instruction.itype.rs1);
                rd_t  = riscv::reg_t'(instruction.itype.rd);

                //bus

                unique case (instruction.itype.funct3)
                riscv::ADDI_F3: begin  
                    if(instruction.itype.rs1 == 5'b0 &&  instruction.itype.rd == 5'b0 && instruction.itype.imm ==0 )
                        $display("NOP\n");
                    else begin;
                       $display("addi %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                    end
                end
                riscv::SLTI_F3: begin
                    $display("slti %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                end
                riscv::SLTIU_F3:  begin
                    $display("sltiu %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                end
                riscv::XORI_F3: begin 
                    $display("xori %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                end
                riscv::ORI_F3: begin   
                    $display("ori %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                end
                riscv::ANDI_F3:  begin
                    $display("andi %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                end
                riscv::SLLI_F3: begin
                    $display("slli %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                end

                riscv::SRLI_SRAI: begin 
                    case(instruction.instruction[31:25])
                        riscv::SRAI_func :begin
                            $display("srai %s,%s,%d\n",rd_t.name(),rs1_t.name(),$signed(instruction.itype.imm));
                        end
                        riscv::SRLI_func :begin 
                            $display("srli %s,%s,%d\n",rd_t.name(),rs1_t.name(),instruction.itype.imm);
                        end
                        default: $display("Illegal srli_srai fun\n");
                    endcase
                end 
                default: $display("Illegal I-Format Instruction!\n");
                endcase
            end

            riscv::S_OP: begin 
                rs1_t = riscv::reg_t'(instruction.stype.rs1);
                rs2_t  = riscv::reg_t'(instruction.stype.rs2);

                case(instruction.stype.funct3)
                
                {riscv::SIGNED, riscv::BYTE}: begin 
                    $display("sb %s,%0d(%s)\n", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}), rs1_t.name);
                end
                {riscv::SIGNED, riscv::HWORD}:begin
                    $display("sh %s,%0d(%s)\n", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}), rs1_t.name);
                end
                {riscv::SIGNED, riscv::WORD}: begin 
                    $display("sw %s,%0d(%s)\n", rs2_t.name, $signed({instruction.stype.imm, instruction.stype.imm_2}), rs1_t.name);
                end
                default:$display("Illegal store?\n");
                endcase
            end          
            riscv::L_OP: begin 
                rs1_t = riscv::reg_t'(instruction.itype.rs1);
                rd_t  = riscv::reg_t'(instruction.itype.rd);
                case(instruction.itype.funct3)
                {riscv::SIGNED,riscv::BYTE}:begin
                    $display("lb %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);
                end
                {riscv::SIGNED,riscv::HWORD}:begin 
                    $display("lh %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);
                end
                {riscv::SIGNED,riscv::WORD}:begin 
                    $display("lw %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);
                end
                {riscv::UNSIGNED,riscv::BYTE}:begin 
                    $display("lbu %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);
                end
                {riscv::UNSIGNED,riscv::HWORD}:begin 
                    $display("lhu %s,%0d(%s)\n", rd_t.name, instruction.itype.imm, rs1_t.name);
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



    endfunction
endpackage


  