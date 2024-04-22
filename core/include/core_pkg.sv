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

    typedef enum logic [2:0]{
        I_FORMAT = 3'b000,
        R_FORMAT = 3'b001,
        U_FORMAT = 3'b010,
        S_FORMAT = 3'b011,
        NOP      = 3'b100
    } formats_t ;

    typedef enum logic [2:0]{
        LB = 3'b000,
        LH = 3'b001,
        LW = 3'b010,
        LBU= 3'b011,
        LHU= 3'b100,
        SB = 3'b101,
        SH = 3'b110,
        SW = 3'b111
    } MEM_OP_t;


    typedef struct packed {
        MEM_OP_t mem_op;
        ALU_OP_t alu_op;
        formats_t format;
        logic [31:0] instr;
        logic [31:0] imm;
        logic [4:0] rs1;
        logic [4:0] rs2;
        logic [4:0] rd;
        logic [31:0] pc;

    } pipeline_bus_t;

endpackage