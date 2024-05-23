module if_stage
    import core::*;
(
    input  logic clk,
    input  logic rst,
    input  logic [core::DATA_WIDTH-1:0] wdata_i,
    input  logic [core::DATA_BYTES-1:0] wen_i,
    input  logic pc_incr_en_i,
    output logic [31:0] instr_o,
    output logic [31:0] pc_o
);

    mem_sync_sp 
    #(.INIT_FILE("/home/dvlachos/project/RISC-V-Core/code/ihex/code.hex"),
      .ADDR_WIDTH(core::ADDR_WIDTH),
      .DEPTH(core::DEPTH),
      .DATA_WIDTH(core::DATA_WIDTH),
      .DATA_BYTES(core::DATA_BYTES))
    i_mem (
    .clk(clk),
    .i_addr(pc_o[core::ADDR_WIDTH+1:2]),
    .i_wdata(wdata_i),
    .i_wen(wen_i),
    .o_rdata(instr_o));


    logic [31:0] pc;
    always_comb begin  
        pc = 'h100;

        if(pc_incr_en_i) begin 
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