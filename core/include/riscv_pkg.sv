

package riscv;

    typedef enum  { 
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
    } instruction_t;

    localparam  LUI_OP   =   7'b0110111;  
    localparam  AUI_OP   =   7'b0010111;

    localparam  JAL_OP   =   7'b1101111;
    localparam  JALR_OP  =   7'b1100111;

    localparam  B_OP     =   7'b1100011;
    localparam  BEQ_F3   =   3'b000;
    localparam  BNE_F3   =   3'b001;
    localparam  BLT_F3   =   3'b100;
    localparam  BGE_F3   =   3'b101;
    localparam  BLTU_F3  =   3'b110;
    localparam  BGEU_F3  =   3'b111;

    localparam  L_OP     =   7'b0000011;

    localparam  S_OP     =   7'b0100011;

    localparam  I_OP     =   7'b0010011;
    localparam  ADDI_F3  =   3'b000;
    localparam  SLTI_F3  =   3'b010;
    localparam  SLTIU_F3 =   3'b011;
    localparam  XORI_F3  =   3'b100;
    localparam  ORI_F3   =   3'b110;
    localparam  ANDI_F3  =   3'b111;
    localparam  SLLI_F3  =   3'b001;
    localparam  SLLI_F7  =   7'b0000000;
    localparam  SRLI_SRAI=   3'b101;
    localparam  SRLI_func=   7'b0000000;
    localparam  SRAI_func=   7'b0100000;


    localparam  RR_OP   =    7'b0110011;
    localparam  ADD_SUB =    3'b000;
    localparam  SLL     =    3'b001;
    localparam  SLT     =    3'b010;
    localparam  SLTU    =    3'b011;
    localparam  XOR     =    3'b100;
    localparam  SRL_SRA =    3'b101;
    localparam  OR      =    3'b110;
    localparam  AND     =    3'b111;
    localparam  ADD_func=    7'b0000000;
    localparam  SUB_func=    7'b0100000;
    localparam  SRL_func=    7'b0000000;
    localparam  SRA_func=    7'b0100000;

    localparam  E_OP    =    7'b1110011;
    localparam  ECALL_i =    12'b000000000000;
    localparam  EBR_i   =    12'b000000000001;
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

    function automatic logic [31:0] store(logic [4:0] rs1,logic [4:0] rs2,logic [6:0] imm,logic [4:0] offset,logic [1:0] size);
        return {imm,rs2,rs1,{1'b0,size},offset,S_OP};        
    endfunction

    function automatic logic [31:0] load(logic [11:0] imm,logic [4:0] rs,logic [4:0] rd,logic [1:0] size,logic sign);
        return {imm,rs,{sign,size},rd,L_OP};        
    endfunction




endpackage

