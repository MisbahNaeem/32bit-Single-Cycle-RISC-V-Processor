module reg_file(
input logic clk,rst,reg_we,
input logic [4:0] rs1,rs2,rd,
input logic [31:0] data_in,
output logic[31:0]  out_A,out_B);

logic [31:0] reg_file [0:31];
integer i;

always @ (posedge clk, negedge rst)
begin
        if(!rst)
    begin 
          for(i=0;i<32;i++)
             reg_file[i] <= 32'd0;
    end
       else if(reg_we)
    begin
         if(rd == 5'b 00000)
           reg_file[rd] <= 32'd0;//reserve x0 as 0 
         else
          reg_file[rd] <= data_in; //write data at  rd position
    end             
end

assign out_A = reg_file[rs1];//read output1
assign out_B = reg_file[rs2];//read output 2

endmodule 
