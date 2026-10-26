module metrics_cntrl 
    import riscv::*;
    import core::*;
(
    input logic clk,
    input logic rst,
    output core::metrics_t metrics_o, 
    input  core::pipeline_bus_t ex_bus,
    input  bit flush_i,
    input core::br_cntrl_bus_t br_cntrl_i
);

    core::metrics_t metrics;
    core::metrics_t metrics_ff;
    bit invalid_instr;
    assign invalid_instr = ex_bus.mem_op == core::MEM_NOP && ex_bus.alu_op == core::ALU_NOP ;
    logic flush_ff;
always_comb begin
    metrics = metrics_ff;
    if (br_cntrl_i.branch_resolved) begin                    // conditional only, once per branch
        metrics.br_metrics.no_conditional = metrics_ff.br_metrics.no_conditional + 1;
        if (br_cntrl_i.mispredict_metrics)
            metrics.br_metrics.mispredictions = metrics_ff.br_metrics.mispredictions + 1;
    end
    if (ex_bus.is_branch && ex_bus.alu_op[4:3] == core::J_PRFX)
        metrics.br_metrics.no_jumps = metrics_ff.br_metrics.no_jumps + 1;
    if (~invalid_instr)
        metrics.total_ins = metrics_ff.total_ins + 1;
end

    always_ff @(posedge clk,negedge rst ) begin : blockName
        if(~rst) begin
            metrics_ff <= '0;
            flush_ff <= 0;
        end
        else begin
            metrics_ff <= metrics;
            flush_ff <= flush_i;
        end

    end

    assign metrics_o = metrics_ff;
endmodule