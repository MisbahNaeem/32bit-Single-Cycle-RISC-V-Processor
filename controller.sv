module controller(
input logic [31:0] inst,
input logic breq,brlt,
output logic memwen,asel,bsel,brun,regwen,pcsel,
output logic [1:0] wbsel,
output logic[3:0] alusel,
output logic [2:0] immsel,d_mode
);

always_comb
begin
     case(inst[6:0])
  7'b 0110011 : //r type
   begin
          wbsel  = 2'b01 ;
          memwen = 1'b0  ;
          asel   = 1'b0  ;
          bsel   = 1'b0  ;
          brun   = 1'b0  ;
          regwen = 1'b1  ;
          immsel = 3'd0  ;
          pcsel  = 1'b0  ;
          d_mode  = 3'd0 ;
       case(inst[14:12])
       3'h0:
              case(inst[31:25])
              7'h00 : 
                      alusel = 4'b 0000 ;  //add
              7'h20 : 
                      alusel = 4'b 0001 ; // sub
              endcase
       3'h4 :
               alusel = 4'b 0010 ;        //xor
       3'h6 : 
               alusel = 4'b 0011 ;       //or
       3'h7 :
               alusel = 4'b 0100 ;      //and
       3'h1 :
               alusel = 4'b 0101 ;     //sll
       3'h5 :
              case(inst[31:25])
              7'h00 : 
                      alusel = 4'b 0110 ; //srl
              7'h20 : 
                      alusel = 4'b 0111 ; //sra
              endcase
       
       3'h2 :
               alusel = 4'b 1000 ;        //slt
       3'h3 :
               alusel = 4'b 1001 ;       //sltu
       endcase
    end
   7'b 0010011 :  //i type arithmatic
      begin
          wbsel  = 2'b01 ;
          memwen = 1'b0  ;
          asel   = 1'b0  ;
          bsel   = 1'b1  ;
          brun   = 1'b0  ;
          regwen = 1'b1  ;
          immsel = 3'd0  ;
          pcsel  = 1'b0  ;
          d_mode  = 3'd0  ;
    
            case(inst[14:12])
                  
             3'h0:
         
                     alusel = 4'b 0000 ;  //addi     
             3'h4 :
                     alusel = 4'b 0010 ;        //xori
             3'h6 : 
                     alusel = 4'b 0011 ;       //ori
             3'h7 :
                     alusel = 4'b 0100 ;      //andi
             3'h1 :
                     begin
                        alusel = 4'b 0101 ;     //slli
                        immsel = 3'd1  ;
                     end
                   
             3'h5 :
                   case(inst[31:25])
                        7'h00:
                           begin
                                alusel = 4'b 0110 ; //srli
                                immsel = 3'd1  ;
                            end
                         7'h20:
                           begin
                                alusel = 4'b 0111 ; //srai
                                immsel = 3'd1  ;
                            end
                   endcase
             3'h2 :
                      alusel = 4'b 1000 ;        //slti
             3'h3 :
                      alusel = 4'b 1001 ;       //sltui
          endcase
              
     end 

   7'b 0000011 :   //load
         begin
          wbsel  = 2'b00 ;
          memwen = 1'b0  ;
          asel   = 1'b0  ;
          bsel   = 1'b1  ;
          brun   = 1'b0  ;
          regwen = 1'b1  ;
          immsel = 3'd0  ;
          pcsel  = 1'b0  ;
         d_mode  = 3'd0  ;
       alusel = 4'b 0000 ;  //add adress calculation
            
           case(inst[14:12])
                  
             3'h0:
                    d_mode = 3'd2 ;   //lb
             3'h1:
             
                    d_mode = 3'd1 ;  //lh
             3'h2:
                    d_mode = 3'd0 ; //lw
             3'h4:
                    d_mode = 3'd4 ; //lbu
             3'h5:
                    d_mode = 3'd3 ;//lhu
             endcase
         end

   7'b 0100011 :  // store
         begin

          wbsel  = 2'b00 ;
          memwen = 1'b1  ;
          asel   = 1'b0  ;
          bsel   = 1'b1  ;
          brun   = 1'b0  ;
          regwen = 1'b0  ;
          immsel = 3'd2  ;
          pcsel  = 1'b0  ;
         d_mode  = 3'd0  ;
       alusel = 4'b 0000 ;  //add adress calculation
            
           case(inst[14:12])

             3'h0:        
                    d_mode = 3'd 2 ;  //sb
             
             3'h1:        
                    d_mode = 3'd 1 ;  //sh
             
             3'h2:        
                    d_mode = 3'd 0 ;  // sw
           endcase
        end
     7'b 1100011 :       // branch instruction
         begin
          wbsel  = 2'b00 ;
          memwen = 1'b0  ;
          asel   = 1'b1  ;
          bsel   = 1'b1  ;
          brun   = 1'b0  ;
          regwen = 1'b0  ;
          immsel = 3'd3  ;  //b type imm
          pcsel  = 1'b0  ;
         d_mode  = 3'd0  ;
       alusel = 4'b 0000 ;  //add pc+imm calculation
            
           case(inst[14:12])
            
              3'h0:     //breq   
                   begin
                         if(breq)
                          pcsel  = 1'b1  ;  //pc = alu_result
                         else
                          pcsel  = 1'b0  ;  
                    end
              3'h1:    //bne    
                   begin
                         if(breq == 1'b0)
                          pcsel  = 1'b1  ;  //pc = alu_result
                          else
                          pcsel = 1'b0 ;
                    end
             3'h4:      //blt  
                   begin
                         if(brlt == 1'b1)
                          pcsel  = 1'b1  ;  //pc = alu_result
                          else
                          pcsel = 1'b0 ;
                    end
             3'h5:      //bge  
                   begin
                         if(brlt == 1'b0)
                          pcsel  = 1'b1  ;  //pc = alu_result
                          else
                          pcsel = 1'b0 ;
                    end
             3'h6:      //bltu
                   begin
                         brun   = 1'b1  ;
                        
                         if(brlt == 1'b1)
                          pcsel  = 1'b1  ;  //pc = alu_result
                          else
                          pcsel = 1'b0 ;
                    end
            3'h7:      //bgeu  
                   begin
                         brun   = 1'b1  ;
                        
                         if(brlt == 1'b0)
                          pcsel  = 1'b1  ;  //pc = alu_result
                          else
                          pcsel = 1'b0 ;
                    end
            endcase
        end

     7'b 1101111 :       // jump instruction
         begin
          wbsel  = 2'b10 ;    // rd = pc+4
          memwen = 1'b0  ;
          asel   = 1'b1  ;
          bsel   = 1'b1  ;
          brun   = 1'b0  ;
          regwen = 1'b1  ;
          immsel = 3'd5  ;   // j type imm
          pcsel  = 1'b1  ;  // pc = alu_result
         d_mode  = 3'd0  ;
       alusel = 4'b 0000 ;  //add pc+imm calculation
        end 
           
     7'b 1100111 :       // jalr instruction
         begin
          wbsel  = 2'b10 ;    // rd = pc+4
          memwen = 1'b0  ;
          asel   = 1'b0  ;    //rs1
          bsel   = 1'b1  ;
          brun   = 1'b0  ;
          regwen = 1'b1  ;
          immsel = 3'd0  ;  //i_type imm
          pcsel  = 1'b1  ;  // pc = alu_result
         d_mode  = 3'd0  ;
       alusel = 4'b 0000 ;  //add rs1+imm calculation
        end 
   
     7'b 0110111 :       // lui instruction
         begin
          wbsel  = 2'b01 ;    // rd = alu
          memwen = 1'b0  ;
          asel   = 1'b0  ;    
          bsel   = 1'b1  ;   // imm
          brun   = 1'b0  ;
          regwen = 1'b1  ;
          immsel = 3'd4  ;  //u_type imm
          pcsel  = 1'b0  ;  // pc = pc_incremennted
         d_mode  = 3'd0  ;
       alusel = 4'b 1010 ;  //lui imm<<12
        end 

     7'b 0010111 :       // auipc instruction
         begin
          wbsel  = 2'b01 ;    // rd = alu
          memwen = 1'b0  ;
          asel   = 1'b1  ;    //pc
          bsel   = 1'b1  ;   // imm
          brun   = 1'b0  ;
          regwen = 1'b1  ;
          immsel = 3'd4  ;  //u_type imm
          pcsel  = 1'b0  ;  // pc = pc_incremennted
         d_mode  = 3'd0  ;
       alusel = 4'b 1011 ;  //auipc imm<<12
        end 
        
  endcase
end
endmodule
