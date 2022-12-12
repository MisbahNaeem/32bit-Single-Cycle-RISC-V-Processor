module inst_mem (input logic [31:0] pc,output logic [31:0] instr);
logic [31:0] inst_mem [0:1000];
logic [31:0] adress;
always_comb
begin
      adress = pc >> 2;//pc right shift by 2 ...divide the pc by 4 
      case(adress)
      0: instr = 32'h00240413;//addi x8,x8,2
      1: instr=  32'h00448493;
      2: instr = 32'h00160613;
      3: instr = 32'h00360693;
      4: instr = 32'h00380813;
      5: instr = 32'h00588893; 
      //R type
       6: instr = 32'h009400B3;
       7: instr = 32'h40848133;
       8: instr = 32'h009421B3;
       9: instr = 32'h40945233;
       10: instr = 32'h009462B3;
       11: instr = 32'h00944333;
       12: instr = 32'h009473B3;
   
       13: instr = 32'h00C6B023;
       14: instr = 32'h0006B503;
      
       15: instr = 32'h41088933;//sub x18,x17,x16
       endcase
end
endmodule