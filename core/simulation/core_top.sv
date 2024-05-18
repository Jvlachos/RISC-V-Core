`define CLK_PERIOD 5

module core_top;
    import core::*;
    import riscv::*;
    logic clk = 1;
    logic rst = 0;
    logic [core::DATA_WIDTH-1:0] instruction;
    logic [core::DATA_WIDTH-1:0] wdata;
    logic [core::DATA_BYTES-1:0] wen = 0;
    logic pc_incr = 0;
    logic [31:0] pc;

    always# (`CLK_PERIOD) clk = ~clk;
    core::pipeline_bus_t bus;

    if_stage if_s(
    .clk(clk),
    .rst(rst),
    .wdata_i(wdata),
    .wen_i(wen),
    .pc_incr_en_i(pc_incr),
    .instr_o(instruction),
    .pc_o(pc));

    //decoder_tb dec_s(.clk(clk),.rst(rst),.instruction_i(instruction));
    id_stage id_s(
        .clk(clk),
        .rst(rst),
        .instruction_i(instruction),
        .pc_i(pc),
        .id_bus_o(bus));

    initial begin
        @(posedge clk);
        rst = 1;
        @(posedge clk);

        $finish;
    end

endmodule