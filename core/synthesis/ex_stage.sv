module ex_stage 
    import core::*;
(
    input logic clk,
    input logic rst,
    input core::pipeline_bus_t bus_i,
    output core::pipeline_bus_t ex_bus_o 
);

    core::pipeline_bus_t ex_bus;
    
    alu alu_instance(
     .clk(clk),
     .alu_bus_i(bus_i),
     .alu_bus_o(ex_bus));


    always_ff @( posedge clk,negedge rst ) begin  
       if(~rst)
            ex_bus_o <= 0;
        else
            ex_bus_o <= ex_bus; 
    end

endmodule