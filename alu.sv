module alu (
input logic  [3:0] alu_sel,
input logic signed [31:0] in_A,in_B,
output logic [31:0] alu_result
);


always_comb 
begin

    case(alu_sel)
4'b0000: alu_result = in_A + in_B;                               //add
4'b0001: alu_result = in_A - in_B;                              //sub
4'b0010: alu_result = in_A ^ in_B;                             //xor
4'b0011: alu_result = in_A | in_B;                            //or
4'b0100: alu_result = in_A & in_B;                           //and
4'b0101: alu_result = in_A << in_B;                         //sll
4'b0110: alu_result = in_A >> in_B;                        //srl
4'b0111: alu_result = in_A >>> in_B;                      //sra
4'b1000: alu_result =in_A < in_B;                       //slt
4'b1001: alu_result = $unsigned(in_A) < $unsigned(in_B);// sltu
4'b1010: alu_result = in_B << 12;                      //  lui
4'b1011: alu_result = in_A + (in_B << 12);            // auipc       
default : alu_result = 32'dx;
   endcase
end

endmodule
