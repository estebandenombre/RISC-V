module PC  (clk, reset, pc_entrada, pc_salida);

input logic [31:0] pc_entrada;
input logic clk, reset;
output logic [31:0] pc_salida;
 
initial
begin
pc_salida=32'd0;
end

always @(posedge clk or negedge reset)
  begin
	if (!reset)
		pc_salida=32'd0;
	else
		pc_salida=pc_entrada;     
  end
  
endmodule 


