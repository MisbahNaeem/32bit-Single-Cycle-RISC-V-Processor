module branch_comp(
input logic brun,
input logic signed [31:0] in_A,in_B,
output  logic breq,brlt
);


always_comb
begin

  if(brun)
      begin
         if($unsigned(in_A) < $unsigned(in_B))
           brlt = 1 ;
         else
           brlt = 0 ;
      end
 else
      begin

       if(in_A == in_B)
        
            breq = 1;
        else
        
             breq= 0;

         if(in_A < in_B)

           brlt = 1 ;
         else

           brlt = 0 ;

       end
    
end
endmodule

