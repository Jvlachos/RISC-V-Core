module id_stage 
    import riscv::*;
    import core::*;
(
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_i,
    output logic [4:0] rs1_o,
    output logic [4:0] rs2_o,
    output logic [4:0] rd_o,
    output core::ALU_OP_t alu_op_o,
    output logic [31:0] immediate_o
);
    logic [2:0] format;
    decoder ins_decoder(
    .clk(clk),
    .rst(rst),
    .instruction_i(instruction_i),
    .rs1_o(rs1_o),
    .rs2_o(rs2_o),
    .rd_o(rd_o),
    .alu_op_o(alu_op_o),
    .format_o(format));

    imm_generator im_gen(
        .instr_i(instruction_i),
        .format_i(format),
        .imm_o(immediate_o)
    );


endmodule