`timescale 1ns/100ps
module tb_multicycle_basico();
parameter tamanyo=32;
parameter mem_depth=1024;
parameter size=32;
localparam T=20;

reg CLK,RSTa;
logic [size-1:0]read_data,instruction,write_data;
logic MemWrite,MemRead;
logic [31:0] read_address,address,imm;
	
TOP_total_control_de_riesgos i1 (.CLK(CLK),.RSTa(RSTa),.read_data_mem(read_data),.instruction_if(instruction),.read_address(read_address),.address_mem(address),.write_data(write_data),.MemWrite_mem(MemWrite),.MemRead_mem(),.imm_gen_out_ex());

RAM #(.mem_depth(mem_depth),.size(size)) i2 (.clk(CLK),.memwrite(MemWrite),.write_data(write_data),.address(address[11:2]),.read_data(read_data));

ROM #(.mem_depth(mem_depth),.size(size)) i3 (.read_address(read_address[11:2]),.instruction(instruction));

always
begin
	CLK = 1'b0;
	CLK = #10 1'b1;
	#10;
end 

initial
begin
	$display("Starting test...");
	RSTa=0;
	#(T)
	RSTa=1;
	#(T*3000)
	$display("Test finished");
	$stop;
end
endmodule
