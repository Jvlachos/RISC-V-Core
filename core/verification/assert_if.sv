module assert_if (
    input  logic clk,
    input  logic rst,
    input  logic [core::DATA_WIDTH-1:0] wdata_i,
    input  logic [core::DATA_BYTES-1:0] wen_i,
    input  logic pc_incr_en_i,
    output logic [31:0] instr_o,
    output logic [31:0] pc_o,
    input core::br_cntrl_bus_t br_bus_i,
    input core::btb_entry_t btb_entry_i,
    input bit prediction_i
);

    bit entry_found;
    bit branch_instr;
    bit target_jump_en;
    logic [6:0] op;
    assign entry_found = btb_entry_i.i_addr != '0;
    assign op = instr_o[6:0];
    assign branch_instr = op == riscv::B_OP ||  op == riscv::JAL_OP || op == riscv::JALR_OP; 
    assign target_jump_en = entry_found & prediction_i & ~br_bus_i.mispredict & branch_instr & pc_incr_en_i;

    property btb_jump;
        @(posedge clk)
        target_jump_en |=> pc_o == btb_entry_i.target_addr; 
    endproperty

   property pc_not_incr;
    @(posedge clk)
    ~pc_incr_en_i |=> $stable(pc_o);
   endproperty

   property pc_incr ;
    @(posedge clk)
    pc_incr_en_i |=> $past(pc_o) != pc_o;
   endproperty

   property btb_entry_found;
    @(posedge clk)
    entry_found && btb_entry_i.i_addr != '0;
   endproperty

   property pc_next;
    @(posedge clk)
    ~br_bus_i.mispredict && ~target_jump_en && pc_incr_en_i |=> pc_o == $past(pc_o)+4;
   endproperty

  

    assert property(btb_jump);
    assert property(pc_not_incr);
    assert property(pc_incr);
    assert property(btb_entry_found);
    assert property(pc_next);

endmodule