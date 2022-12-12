module imm_gen (
input logic [2:0] imm_sel,
input logic [24:0] imm,
output logic[31:0] extended_imm);
always_comb
begin
       case(imm_sel)

  3'b 000 : extended_imm = {{20{imm[24]}}, imm[24:13]};                                         // I_type arithmatic instruction
  3'b 001 : extended_imm = {{27{1'b0}}, imm[17:13]};                                           // I_type shift instruction                                 
  3'b 010 : extended_imm = {{20{1'b0}}, imm[24:18], imm[4:0]};                               // s_type instruction
  3'b 011 : extended_imm = {{19{imm[24]}}, imm[24],imm[0], imm[23:18], imm[4:1], 1'b0};     //b_type instruction
  3'b 100 : extended_imm = {{12{imm[24]}}, imm[24:5]};                                     // U_type instruction
  3'b 101 : extended_imm = {{11{imm[24]}}, imm[24], imm[12:5], imm[13], imm[23:14], 1'b0};// j_type instruction
   default : extended_imm  = {32{ 1'b0}};   
        endcase
           
end
endmodule


