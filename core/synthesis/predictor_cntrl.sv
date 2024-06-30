module predictor_cntrl
    import  core::*;
(
    input logic clk,
    input logic rst,
    input core::br_cntrl_bus_t br_cntrl_i,
    input  bit is_branch_i,
    input  logic [core::ADDR_WIDTH-1:0] read_addr_i,
    output bit prediction_o,
);

    localparam DH = 1;

    logic [core::COUNTER_TABLE_BITS-1:0] addr;
    core::GHR_t GHR_ff;
    logic [core::GHR_SIZE-1:0] ghr;
    core::cntr_table_entry_t cntr_table [0:core::COUNTER_TABLE_SZ-1];
    core::cntr_pattern_t curr_state;
    core::cntr_pattern_t next_state;
    bit taken = br_cntrl_i.is_taken;
    assign addr = {GHR.GHR,read_addr_i[1:0]};
    assign #DH prediction_o = cntr_table[addr].counter[1];
    bit update;
    always @(posedge clk,negedge rst) begin
 //     for(int i = 0; i <32; i++) begin
   //     $display("REG %0d\n DATA %0d\n",i,rf[i]);
     // end
        if(~rst)
            GHR_ff <= '0
        else if(is_branch_i & update) begin
            cntr_table[addr].counter <= next_state;
            GHR_ff <= ghr;
        end
    end


    always_comb begin
        curr_state = cntr_table[addr].counter;
        next_state = core::STRONGLY_NOT_TAKEN;
        ghr = '0;
        if(is_branch_i) begin
            ghr = GHR_ff << 1;
            ghr[0] = taken;
            unique case (curr_state)
                core::STRONGLY_NOT_TAKEN:begin
                    next_state = taken ? core::WEAKLY_NOT_TAKEN : core::STRONGLY_NOT_TAKEN;   
                end
                core::WEAKLY_NOT_TAKEN:begin
                    next_state = taken ? core::WEAKLY_TAKEN : core::STRONGLY_NOT_TAKEN;
                end
                core::WEAKLY_TAKEN: begin
                    next_state = taken ? core::STRONGLY_TAKEN : core::WEAKLY_NOT_TAKEN;
                end
                core::STRONGLY_TAKEN: begin
                    next_state = taken ? core::STRONGLY_TAKEN : core::WEAKLY_TAKEN;
                end 
                
            endcase
        end
    end    
    
endmodule