package core;
    
    typedef enum  logic [1:0] { 
        BRANCH_PRFX = 2'b00,
        ARITHM_PRFX = 2'b01
    } alu_prefix_t;

    typedef enum  logic {
        LOAD_PRFX  = 1'b0,
        STORE_PRFX = 1'b1
    } mem_prefix_t;

    typedef enum logic [4:0] 
    {
        ALU_BEQ         = 5'b00000,
        ALU_BNE         = 5'b00001,
        ALU_LUI         = 5'b00010,
        //ALU_SRL        = 5'b00011,
        ALU_BLT         = 5'b00100,
        ALU_BGE         = 5'b00101,
        ALU_BLTU        = 5'b00110,
        ALU_BGEU        = 5'b00111,
        ALU_ADD         = 5'b01000, //BEQ 1 000
        ALU_SLL         = 5'b01001, // BNE 1 001
        ALU_SLT         = 5'b01010,
        ALU_SLTU        = 5'b01011,
        ALU_XOR         = 5'b01100,
        ALU_SRA_SRL     = 5'b01101,
        ALU_OR          = 5'b01110,
        ALU_AND         = 5'b01111,
        ALU_AUIPC       = 5'b10000,
        ALU_NOP         = 5'b10010  
    } ALU_OP_t;

    typedef enum logic [2:0]{
        I_FORMAT = 3'b000,
        R_FORMAT = 3'b001,
        U_FORMAT = 3'b010,
        S_FORMAT = 3'b011,
        B_FORMAT = 3'b100,
        J_FORMAT = 3'b101,
        NOP      = 3'b111
    } formats_t ;

    typedef enum logic [3:0]{
        LB = 4'b0000,
        LH = 4'b0001,
        LW = 4'b0010,
        LBU= 4'b0100,
        LHU= 4'b0101,
        SB = 4'b1000,
        SH = 4'b1001,
        SW = 4'b1010,
        MEM_NOP= 4'b1111
    } MEM_OP_t;


    typedef struct packed {
        MEM_OP_t mem_op;
        ALU_OP_t alu_op;
        bit is_branch;
        formats_t format;
        logic [31:0] instr;
        logic [31:0] imm;
        logic [4:0] rs1;
        logic [4:0] rs2;
        logic [4:0] rd;
        logic [31:0] rd_res;
        logic [31:0] rs1_data;
        logic [31:0] rs2_data;
        logic [31:0] pc;
    } pipeline_bus_t;
    



    localparam DEPTH = 4096 ;
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam DATA_WIDTH =32;
    localparam DATA_BYTES = DATA_WIDTH/8;



endpackage