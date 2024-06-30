
module btb_cntrl
import core::*;
 #(
  parameter DLEN          = core::DEPTH,
  parameter ALEN          = core::BTB_ENTRY_SIZE
)

(
  input  wire                   clk,

  // Data Access Interface
  input logic [core::ADDR_WIDTH-1:0] read_addr_i,
  input  core::br_cntrl_bus_t   br_cntrl_i,
  output core::btb_entry_t      entry_o,
  input  bit is_branch_i   
 
);

localparam DH = 1;
localparam BTB_WORDS =  ALEN;

//logic [DLEN-1:0] rf [1 : RF_WORDS-1];
core::btb_entry_t btb [0 : BTB_WORDS-1];
logic wen;
logic rm;
logic [core::ADDR_WIDTH-1:0] i_addr;
assign i_waddr = br_cntrl_i.i_addr;

assign wen = br_cntrl_i.is_taken;
assign rm  = ~wen;

always @(posedge clk) begin
 //     for(int i = 0; i <32; i++) begin
   //     $display("REG %0d\n DATA %0d\n",i,rf[i]);
     // end
    if(is_branch_i) begin
      if ( wen ) begin
//        assert(i_waddr != '0) else begin
  //        $display("WRITE TO X0!\n");
    //      $finish;
      //  end
       btb[i_waddr][core::ADDR_WIDTH-1:0] <= br_cntrl_i.i_addr;
       btb[i_waddr][core::BTB_ENTRY_SIZE-1:core::ADDR_WIDTH] <= br_cntrl_i.branch_target;
      end
      else if (rm) 
        btb[i_waddr] <= '0;
    end
end

assign #DH entry_o = btb[read_addr_i];

// alternative #1
//assign #DH o_rdata_a = (i_raddr_a == 0) ? 0 : rf[i_raddr_a];
//assign #DH o_rdata_b = (i_raddr_b == 0) ? 0 : rf[i_raddr_b];
/*
// alternative #2
always_comb begin
  o_rdata_a = 0;
  o_rdata_b = 0;
  if ( i_raddr_a != 0 ) o_rdata_a = rf[i_raddr_a];
  if ( i_raddr_b != 0 ) o_rdata_b = rf[i_raddr_b];


//if      ( i_raddr_a == 0 )            o_rdata_a = 0;
//else if ( i_raddr_a == i_waddr )      o_rdata_a = i_wdata;
//else                                  o_rdata_a = rf[i_raddr_a];
//
//if      ( i_raddr_b == 0 )            o_rdata_b = 0;
//else if ( i_raddr_b == i_waddr )      o_rdata_b = i_wdata;
//else                                  o_rdata_b = rf[i_raddr_b];

end
*/

// not needed for alternatives
initial begin
 for (int i=0 ; i<BTB_WORDS; i++) begin
   btb[i] = '0;
 end
end

endmodule
