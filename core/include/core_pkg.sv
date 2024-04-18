package core;
    typedef enum logic [3:0] 
    {
        ALU_ADD = 4'b0000,
        ALU_SUB,
        ALU_AND,
        ALU_OR,
        ALU_XOR,
        ALU_SLL,
        ALU_SLT,
        ALU_SLTU,
        ALU_SRL,
        ALU_SRA,
        ALU_LUI,
        ALU_AUIPC,
        ALU_BGE,
        ALU_BLT   
    } ALU_OP_t;


endpackage