`define CLK_PERIOD 5


module decoder_tb;
	import riscv::*;
	logic clk=1;
	logic rst=0;
	logic [4:0] rs1_o;
	logic [4:0] rs2_o;
	logic [4:0] rd_o;
	logic [31:0] instruction_o;
	always# (`CLK_PERIOD) clk = ~clk;
	riscv::reg_t register;	
	
	decoder d(.clk(clk),.rst(rst),.instruction_i(instruction_o),.rs1_o(rs1_o),.rs2_o(rs2_o),.rd_o(rd_o));
	initial begin
		
		logic [31:0] in = riscv::addi(5'b00000,5'b00001,12);
		logic [31:0] lhu = riscv::load(12,riscv::x1,riscv::x2,riscv::HWORD,riscv::UNSIGNED);
		@(posedge clk);
		@(posedge clk);

		instruction_o = riscv::addi(riscv::x0,riscv::x0,0);
		@(posedge clk);
		@(posedge clk);



		$finish;
    end

	task display_instr(logic [31:0] ins);
		riscv::instruction_t instruction ; 

		riscv::reg_t rs1;
		riscv::reg_t rs2;
		riscv::reg_t rd;
		instruction = riscv::instruction_t'(ins);
		$display("op : %b\n",ins[6:0]);
		case (instruction.instruction[6:0])
			riscv::I_OP:begin

				rs1 = riscv::reg_t'(instruction.itype.rs1);		
				rd = riscv::reg_t'(instruction.itype.rd);
				

				$display("Immediate: %d\nrs1: %s\nfunct3: %b\nrd: %s\nop: %b\n",instruction.itype.imm,
				rs1.name(),instruction.itype.funct3,
				rd.name(),instruction.itype.opcode) ;
			end
			riscv::L_OP:
			begin

				rs1 = riscv::reg_t'(instruction.itype.rs1);	
				rd = riscv::reg_t'(instruction.itype.rd);	
			 	$display("Immediate: %d\nrs1: %s\nfunct3: %b\nrd: %s\nop: %b\n",instruction.itype.imm,
				rs1.name(),instruction.itype.funct3,
				rd.name(),instruction.itype.opcode) ;
			end
			riscv::S_OP:
			begin
				
				rs1 = riscv::reg_t'(instruction.stype.rs1);	
				rs2 = riscv::reg_t'(instruction.stype.rs2);	
			  	$display("Immediate1: %d\nrs2: %s\nrs1: %s\nfunc3: %b\nImmediate2: %b\nop: %b\n",instruction.stype.imm,
				rs2.name(),rs1.name(),
				instruction.stype.funct3,instruction.stype.imm_2,instruction.stype.opcode);
			end
			riscv::RR_OP:begin  

				rs1 = riscv::reg_t'(instruction.rtype.rs1);	
				rs2 = riscv::reg_t'(instruction.rtype.rs2);		
				rd = riscv::reg_t'(instruction.rtype.rd);	
				$display("funct7: %d\nrs2: %s\nrs1: %s\nfunc3: %b\nrd: %s\nop: %b\n",instruction.rtype.funct7,
				rs2.name(),rs1.name(),
				instruction.rtype.funct3,rd.name(),instruction.stype.opcode);
			end
			default: $display("nothing? \n");
		endcase

	endtask

endmodule
