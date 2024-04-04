module

ROM #(parameter mem_depth=1024, parameter size=32)
( 
input [$clog2(mem_depth)-1:0] read_address, 
output logic [size-1:0] instruction
);

logic [size-1:0] mem [mem_depth-1 :0];

initial begin
//$readmemh("W:/ISDIGI/FASE3/TAREA3/instruction.list",mem);
$readmemh("C:/Users/pablo/OneDrive/Escritorio/TAREA3/TAREA3/instruction.list",mem);
end
  
always_comb
	begin
		 instruction = mem[read_address];  	  
   end

endmodule 

