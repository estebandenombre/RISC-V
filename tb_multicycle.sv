`timescale 1ns/100ps
module tb_multicycle();
parameter tamanyo=32;
localparam T=20;
	logic CLK,RSTa;
	logic [tamanyo-1:0]address,read_address,write_data,address_ideal,read_address_ideal,write_data_ideal;
	logic MemWrite,MemRead,MemWrite_ideal,MemRead_ideal;

	
test_if interfaz (.CLK(CLK), .RSTa (RSTa));

top_duv duvtop (.bus(interfaz.duv));

top_ideal idealtop (.bus(interfaz.ideal));

estimulos estim1 (.testar(interfaz),.monitorizar(interfaz));

assign address=interfaz.monitor.md.address;
assign read_address=interfaz.monitor.md.read_address;
assign write_data=interfaz.monitor.md.write_data;
assign MemWrite=interfaz.monitor.md.MemWrite;
assign MemRead=interfaz.monitor.md.MemRead;
assign address_ideal=interfaz.monitor.md.address_ideal;
assign read_address_ideal=interfaz.monitor.md.read_address_ideal;
assign write_data_ideal=interfaz.monitor.md.write_data_ideal;
assign MemWrite_ideal=interfaz.monitor.md.MemWrite_ideal;
assign MemRead_ideal=interfaz.monitor.md.MemRead_ideal;

always
begin
	CLK = 1'b0;
	CLK = #50 1'b1;
	#50;
end 

// RESET
initial
begin
  RSTa=1'b1;
  # 1  RSTa=1'b0;
  #99 RSTa = 1'b1;
end 

endmodule
