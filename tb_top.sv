module tb_top;
reg clk=1,reset;

//Instantiate Top Level processor module
riscv_top dut(clk,reset);

always #5 clk = ~clk;

initial
begin
	reset = 0;
	#20
	reset = 1;
	#15000;
end

endmodule
