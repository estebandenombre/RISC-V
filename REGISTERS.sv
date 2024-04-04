module REGISTERS #(parameter mem_depth=32, parameter size=32) (read_reg1, read_reg2, w_reg, w_data, read_data1, read_data2, clk, reg_write,reset);

input [4:0] read_reg1, read_reg2, w_reg;
input clk, reg_write,reset; 
input [31:0] w_data;
output logic [31:0] read_data1, read_data2;


logic [size-1:0] mem[mem_depth-1 :0];

initial begin
//	$readmemh("W:/ISDIGI/FASE3/TAREA3/registers.list",mem);
	$readmemh("C:/Users/pablo/OneDrive/Escritorio/TAREA3/TAREA3/registers.list",mem);
end

always @(negedge clk or negedge reset)
  begin
  if (!reset)
		mem<='{default: '0};
	else
	if (reg_write==1'b1)
		mem[w_reg]<= w_data;     
  end

always_comb 
	begin
		 read_data1 = mem[read_reg1];
		 read_data2 = mem[read_reg2];
   end


endmodule 
