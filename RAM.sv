module

RAM #(parameter mem_depth=1024, parameter size=32)
(
input clk, memwrite, 
input [size-1:0] write_data,
input [$clog2(mem_depth-1)-1:0] address, 
output logic [size-1:0] read_data
);

logic [size-1:0] mem [mem_depth-1 :0];

initial begin
//	$readmemh("W:/ISDIGI/FASE3/TAREA3/datos.list",mem);
	$readmemh("C:/Users/pablo/OneDrive/Escritorio/TAREA3/TAREA3/datos.list",mem);
end

always @(negedge clk)
  begin
	if (memwrite==1'b1)
        mem[address]<=write_data;  
  end
  
always_comb
	begin
		 read_data=mem[address];  	  
   end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
//  
//ejemplo_evaluar_ram:assert property (@(posedge clock)  (wren&&wraddress==rdaddress)##1!wren&&$stable(rdaddress)|->NO_BYPASS);
//
//
//operacion_lectura:assert property (@(posedge clock)  !$stable(rdaddress)&&!wren|->lectura);
//
//operacion_escritura:assert property (@(posedge clock)  wren|->escritura);
//sequence escritura;
// logic [7:0] dataux;
// logic [4:0] addaux;
//  (1, dataux=data_in, addaux=wraddress) ##1 (mem[addaux]===dataux) ;
//endsequence
//sequence lectura;
// logic [7:0] aux;
//  (1, aux=mem[rdaddress]) ##1 (data_out===aux) ;
//endsequence
//sequence NO_BYPASS;
// logic [7:0] aux, aux2;
//  (1, aux=data_in, aux2=mem[rdaddress]) ##1 (data_out===aux2) ##1 (data_out===aux) ;
//endsequence
//
endmodule 

