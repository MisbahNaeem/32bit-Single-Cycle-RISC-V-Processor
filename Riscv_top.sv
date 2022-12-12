module riscv_top (
input logic clk, rst);

//intermediate wires

logic[31:0] data_out,alu_result,input1,input2,dataA,dataB,extended_imm,instr,pc,wb;

logic mem_wen,asel,bsel,brun,regwen,pcsel,pcsel1,breq,brlt;  //control signals
logic [1:0] wbsel;
logic[3:0] alu_sel;
logic [2:0] immsel,d_mode;

/////module insenseation  //////

data_mem  d_mem (.clk(clk),.mem_we(mem_wen),.data_type(d_mode),.mem_adress(alu_result),.wr_data(dataB),.data_out(data_out));
alu        alu  (.alu_sel(alu_sel),.in_A(input1),.in_B(input2),.alu_result(alu_result));
imm_gen   imm_g (.imm_sel(immsel),.imm(instr[31:7]),.extended_imm(extended_imm));
branch_comp B_comp(.brun(brun),.in_A(dataA),.in_B(dataB),.breq(breq),.brlt(brlt));
reg_file    R_F (.clk(clk),.rst(rst),.reg_we(regwen),.rs1(instr[19:15]),.rs2(instr[24:20]),.rd(instr[11:7]),.data_in(wb),.out_A(dataA),.out_B(dataB));
inst_mem i_mem (.pc(pc),.instr(instr));
//decomp decomp (.in_inst(instr),.out_inst(updated_inst),.pcsel1(pcsel1));
pc pci(.clk(clk),.rst(rst),.pc_sel(pcsel),.alu_result(alu_result),.pc(pc));

controller contr(.inst(instr),.breq(breq),.brlt(brlt),.memwen(mem_wen),.asel(asel),.bsel(bsel),.brun(brun),.regwen(regwen),.pcsel(pcsel),.wbsel(wbsel),.alusel(alu_sel),.immsel(immsel),.d_mode(d_mode));

/// write back to reg file mux

always_comb
begin
      case(wbsel) //write back..after data memory
 
  2'b00 : wb = data_out ;
  2'b01 : wb = alu_result ;
  2'b10 : wb = pc+4 ;
 default : wb = 32'dx;
        endcase
end

/// ALU input mux 

assign input1 = asel? pc : dataA ;
assign input2 = bsel? extended_imm: dataB ;

//// pc mux

assign incr_pc = pcsel1 ? (pc+32'd2) : (pc+32'd4) ;

endmodule