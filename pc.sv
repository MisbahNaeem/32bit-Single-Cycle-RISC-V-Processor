module pc(
input logic clk,rst,
input logic  pc_sel,
input logic [31:0] alu_result,
//input logic [31:0] incr_pc,
output logic [31:0] pc
);


always@( posedge clk ,negedge rst)
begin
        if(!rst)
         pc = 32'd 0;
        else
          case(pc_sel)
       1'b0 : pc = pc+4 ;   
       1'b1 : pc = alu_result;  // alu_result
       default : pc = pc ;
            endcase
              
end
endmodule