module imm_generator 
    import core::*;
(
    input logic [31:0] instr_i,
    input logic [2:0]  format_i,
    output logic signed [31:0] imm_o
);
    core::formats_t format;
    assign format =  core::formats_t'(format_i);
    always_comb begin : imm_mux
        imm_o = 32'b0;
        //$display("FORMAT %s\n",format.name);
        unique case (format)
            core::I_FORMAT: begin
               imm_o = {{21{instr_i[31]}},instr_i[30:20]};
               //$display("instruction in add %b\n",instr_i);
                //$display("immediate add : %d\n",imm_o);

            end
            core::R_FORMAT: begin
                imm_o = 32'b0;
            end
            core::U_FORMAT:begin
                imm_o = 32'b0;
            end
            core::S_FORMAT:begin
                imm_o ={{21{instr_i[31]}},{instr_i[30:25],instr_i[11:7]}}; 
                //$display("instruction in s %b\n",instr_i);
                //$display("immediate sw : %d\n",imm_o);
            end 
            default: begin
                 imm_o = 32'b0;
            end
        endcase
        
    end

endmodule