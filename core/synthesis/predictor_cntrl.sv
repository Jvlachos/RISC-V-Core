module predictor_cntrl
    import  core::*;
(
    input logic clk,
    input logic rst,
    input core::br_cntrl_bus_t br_cntrl_i,
    input  bit is_branch_i,
    input  logic [31:0] read_addr_i,
    output bit prediction_o
);

    localparam DH = 1;

    logic [core::COUNTER_TABLE_BITS-1:0] r_addr;
    logic [core::COUNTER_TABLE_BITS-1:0] w_addr;
    logic [core::GHR_SIZE-1:0] GHR_ff;
    logic [core::GHR_SIZE-1:0] ghr;
    core::cntr_table_entry_t cntr_table [0:core::COUNTER_TABLE_SZ-1];
    core::cntr_pattern_t curr_state;
    core::cntr_pattern_t next_state;
    bit taken;
    assign taken = br_cntrl_i.is_taken;
    
    assign r_addr = {GHR_ff[2:0],read_addr_i[6:0]};
    assign w_addr = {GHR_ff[2:0],br_cntrl_i.i_addr[6:0]};


    assign #DH prediction_o = cntr_table[r_addr].counter[1];
    always @(posedge clk,negedge rst) begin
        if(~rst)
            GHR_ff <= '0;
        else if(is_branch_i) begin
            cntr_table[w_addr].counter <= next_state;
            GHR_ff <= ghr;
            $display("COUNTER %b GHR %b ADDR %0d PC : %x Taken : %0b\n ",next_state,ghr,w_addr,br_cntrl_i.i_addr,taken);
        end
    end


    always_comb begin
        curr_state = cntr_table[w_addr].counter;
        //next_state = core::STRONGLY_NOT_TAKEN;
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
    

    initial begin
        for(int i = 0; i < core::COUNTER_TABLE_SZ; i++) begin
            cntr_table[i] = '0;
        end
    end
endmodule