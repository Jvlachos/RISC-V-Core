module if_stage
    import core::*;
(
    input  logic clk,
    input  logic rst,
    input  logic [core::DATA_WIDTH-1:0] wdata_i,
    input  logic [core::DATA_BYTES-1:0] wen_i,
    input  logic pc_incr_en_i,
    output logic [31:0] instr_o,
    output logic [31:0] pc_o,
    input core::br_cntrl_bus_t br_bus_i
);

    logic [31:0] pc;
    mem_sync_sp 
    #(.INIT_FILE("/home/dvlachos/project/RISC-V-Core/code/ihex/code.hex"),
      .ADDR_WIDTH(core::ADDR_WIDTH),
      .DEPTH(core::DEPTH),
      .DATA_WIDTH(core::DATA_WIDTH),
      .DATA_BYTES(core::DATA_BYTES))
    i_mem (
    .clk(clk),
    .i_addr(pc[core::ADDR_WIDTH+1:2]),
    .i_wdata(wdata_i),
    .i_wen(wen_i),
    .o_rdata(instr_o));


    always_comb begin  
        pc = 'h100;

        if(br_bus_i.is_taken) begin
            pc = br_bus_i.branch_target;
        end
        else if(pc_incr_en_i) begin 
            pc = pc_o + 4;            
        end
        else begin
            pc = pc_o;
        end
    end

    always_ff @(posedge clk,negedge rst ) begin  
        if(~rst) begin
            pc_o <= 'h100;
        end
        else begin
            pc_o <= pc;
        end

    end
    
endmodule