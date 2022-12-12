module data_mem(
input logic clk,mem_we,
input logic [2:0] data_type,
input logic [31:0] mem_adress,
input logic [31:0] wr_data,
output logic [31:0] data_out );

logic [31:0] data_mem [0:256];
logic [31:0] adress1;

assign  adress1 = mem_adress >> 2;
always @(posedge clk)
begin
  
       if(mem_we)
     begin
          case(data_type)
          
          3'b000 : data_mem[adress1] <= wr_data; //sw
          3'b001 :
               begin
                   case(mem_adress[1])     //shw

                    1'b0:  data_mem[adress1][15:0] <= wr_data[15:0];    
                    1'b1:  data_mem[adress1][31:16] <= wr_data[15:0];
                   endcase
                end
                                                       
          3'b010 :
                begin
                  case(mem_adress[1:0])     // sb
                    
                    2'b00: data_mem[adress1][7:0] <= wr_data[7:0]; 
                    2'b01: data_mem[adress1][15:8] <= wr_data[7:0]; 
                    2'b10: data_mem[adress1][23:16] <= wr_data[7:0];
                    2'b11: data_mem[adress1][31:24] <= wr_data[7:0];
                   endcase
                 end                                                             
          default : {data_mem[mem_adress]} <= {data_mem[mem_adress]} ;

          endcase
      end
end

always_comb  
begin
   
      case(data_type)
   
      3'b000 : data_out = data_mem[adress1]; //lw
      3'b001 :
           begin
               case(mem_adress[1])

               1'b0:  data_out = {{16{data_mem[adress1][15]}},data_mem[adress1][15:0]};     //lh
               1'b1:  data_out = {{16{data_mem[adress1][31]}},data_mem[adress1][31:16]};
                endcase
            end

      3'b010 :
            begin
               case(mem_adress[1:0]) 
                
               2'b00:  data_out = {{24{data_mem[adress1][7]}},data_mem[adress1][7:0]};   //lb
               2'b01:  data_out = {{24{data_mem[adress1][15]}},data_mem[adress1][15:8]};
               2'b10:  data_out = {{24{data_mem[adress1][23]}},data_mem[adress1][23:16]}; 
               2'b11:  data_out = {{24{data_mem[adress1][31]}},data_mem[adress1][31:24]};  
               endcase
             end
                
      3'b011 : 
                begin
               case(mem_adress[1])

               1'b0:  data_out = {{16{1'b0}},data_mem[adress1][15:0]};     //lhu
               1'b1:  data_out = {{16{1'b0}},data_mem[adress1][31:16]};
                endcase
            end

      3'b100 : 
                begin
               case(mem_adress[1:0]) 
                
               2'b00:  data_out = {{24{1'b0}},data_mem[adress1][7:0]};   //lbu
               2'b01:  data_out = {{24{1'b0}},data_mem[adress1][15:8]};
               2'b10:  data_out = {{24{1'b0}},data_mem[adress1][23:16]}; 
               2'b11:  data_out = {{24{1'b0}},data_mem[adress1][31:24]};  
               endcase
             end

      default : data_out = 32'd0 ;
     endcase
end
endmodule
