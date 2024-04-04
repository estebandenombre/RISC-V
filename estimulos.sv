package especificaciones;
parameter tamanyo=32;

class RCSG;
  rand bit [31:0] read_data;
  rand bit [31:0] instruction;
  constraint last {instruction[1:0]==2'b11;}
  constraint R {instruction[6:2]==5'b01100;}
  constraint I {instruction[6:2]==5'b00100;}
  constraint S {instruction[6:2]==5'b01000;}
  constraint L {instruction[6:2]==5'b00000;}
  constraint B {instruction[6:2]==5'b11000;}
  constraint Auipc {instruction[6:2]==5'b00101;}
  constraint Lui {instruction[6:2]==5'b01101;}
  constraint Jal {instruction[6:2]==5'b11011;}
  constraint Jalr {instruction[6:2]==5'b11001;}
  constraint instrucciones {instruction[6:0] dist {7'b0110011:=2,7'b0010011:=2,7'b0100011:=2,7'b0000011:=2,7'b1100011:=2,7'b0010111:=2,7'b0110111:=2,7'b1101111:=2,7'b1100111:=2};}
endclass;

class Scoreboard;
  reg [31:0] imm,read_address,address,imm_ideal,read_address_ideal,address_ideal;//no se si poner instruction...
  virtual test_if.monitor mports;
  
  function new (virtual test_if.monitor mpuertos);
  begin
    this.mports = mpuertos;
  end
  endfunction
   
  task monitor_output;
   begin
     while (1)
       begin       
         @(mports.md);
           begin
         	 imm_ideal=mports.md.imm_ideal;//OBTENER EL INMEDIATO DEL IDEAL
             read_address_ideal=mports.md.read_address_ideal;//OBTENER EL PC DEL IDEAL
				 address_ideal=mports.md.address_ideal;//OBTENER EL RESULTADO DEL IDEAL
				 
				 imm=mports.md.imm;//OBTENER EL INMEDIATO DEL MULTICYCLE
             read_address=mports.md.read_address;//OBTENER EL PC DEL MULTICYCLE
				 address=mports.md.address;//OBTENER EL RESULTADO DEL MULTICYCLE
				 assert (imm==imm_ideal) else $error("error en el microprocesador: el inmediato es %d y da %d",mports.md.imm,mports.md.imm_ideal);
             assert (read_address==read_address_ideal) else $error("error en el microprocesador: el PC es %d y da %d",mports.md.read_address,mports.md.read_address_ideal);
				 assert (address==address_ideal) else $error("error en el microprocesador: el resultado de la instrucción es %d y da %d",mports.md.address,mports.md.address_ideal);
//             assert (imm==$past(imm_ideal,5)) else $error("error en el microprocesador: el inmediato es %d y da %d",mports.md.imm,mports.md.imm_ideal);
//             assert (read_address==$past(read_address_ideal,5)) else $error("error en el microprocesador: el PC es %d y da %d",mports.md.read_address,mports.md.read_address_ideal);
//				 assert (address==$past(address_ideal,5)) else $error("error en el microprocesador: el resultado de la instrucción es %d y da %d",mports.md.address,mports.md.address_ideal);
			  end
		 end
   end
 endtask     
endclass 

class enviroment;

	virtual test_if.test testar_ports;
   virtual test_if.monitor monitorizar_ports;
	
covergroup COV_Micro @(monitorizar_ports.md);
      Tipos: coverpoint monitorizar_ports.md.instruction[6:2]
      {
        bins B= {5'b11000};
		  bins R= {5'b01100};
		  bins I= {5'b00100};
		  bins L= {5'b00000};
        bins S= {5'b01000};
		  bins JAL= {5'b11011};
		  bins JALR= {5'b11001};
		  bins AUIPC= {5'b00101};
		  bins LUI= {5'b01101};
		  option.at_least =10;
      }
		
		B_format: coverpoint monitorizar_ports.md.instruction[14:12]  iff(monitorizar_ports.md.instruction[6:2]==5'b11000) //obligo a que esté una B para evaluar qué instruccion concreta es
		{
        bins BEQ= {3'b000};
        bins BNE= {3'b001};
		  bins BLT= {3'b100};
        bins BGE= {3'b101};
		  bins BLTU= {3'b110};
		  bins BGEU= {3'b111};
		  option.at_least =10;
      }
      I_format: coverpoint {monitorizar_ports.md.instruction[30],monitorizar_ports.md.instruction[14:12]} iff(monitorizar_ports.md.instruction[6:2]==5'b00100) //obligo a que esté una I para evaluar qué instruccion concreta es
		{
        bins ADDI= {4'b0000};
        bins SLTI= {4'b0010};
		  bins SLTIU= {4'b0011};
        bins XORI= {4'b0100};
		  bins ORI= {4'b0110};
		  bins ANDI= {4'b0111};
		  bins SLLI= {4'b0001};
        bins SRLI= {4'b0101};
		  bins SRAI= {4'b1101};
		  option.at_least =10;
      }
		R_format: coverpoint {monitorizar_ports.md.instruction[30],monitorizar_ports.md.instruction[14:12]} iff(monitorizar_ports.md.instruction[6:2]==5'b01100) //obligo a que esté una I para evaluar qué instruccion concreta es
		{
        bins ADD= {4'b0000};
		  bins SUB= {4'b1000};
        bins SLT= {4'b0010};
		  bins SLTU= {4'b0011};
        bins XOR= {4'b0100};
		  bins OR= {4'b0110};
		  bins AND= {4'b0111};
		  bins SLL= {4'b0001};
        bins SRL= {4'b0101};
		  bins SRA= {4'b1101};
		  option.at_least =10;
      }
endgroup;

//DECLARO OBJETOS
RCSG item;
Scoreboard sb;

//INICIALIZO PUERTOS
function new (virtual test_if.test ports, virtual test_if.monitor mports);
  begin
    testar_ports = ports;
    monitorizar_ports = mports;
	 item=new;
    COV_Micro=new;
    testar_ports.sd.read_address <= 32'd0; 
	 testar_ports.sd.instruction <= 32'd0;
  end
endfunction
  
task muestreo; //inicializo el muestreo para que esté recibiendo y mandando
begin
     fork
      sb.monitor_output;
     join_none
end
endtask  

//task condiciones; //para activar las condiciones restrictivas
//
//endtask
task inicio;
	begin
		item.last.constraint_mode(1);
	end
endtask
task aleatorio;
  while (COV_Micro.get_coverage()<95)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(1);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(0);
			item.I.constraint_mode(0);
			item.S.constraint_mode(0);
			item.L.constraint_mode(0);
			item.B.constraint_mode(0);
			item.Auipc.constraint_mode(0);
			item.Lui.constraint_mode(0);
			item.Jal.constraint_mode(0);
			item.Jalr.constraint_mode(0);
			item.last.constraint_mode(0);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				 @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

task prueba_R;
  while (COV_Micro.Tipos.get_coverage()<10)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(0);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(1);
			item.I.constraint_mode(0);
			item.S.constraint_mode(0);
			item.L.constraint_mode(0);
			item.B.constraint_mode(0);
			item.Auipc.constraint_mode(0);
			item.Lui.constraint_mode(0);
			item.Jal.constraint_mode(0);
			item.Jalr.constraint_mode(0);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				 @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

task prueba_I;
	while (COV_Micro.Tipos.get_coverage()<20)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(0);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(0);
			item.I.constraint_mode(1);
			item.S.constraint_mode(0);
			item.L.constraint_mode(0);
			item.B.constraint_mode(0);
			item.Auipc.constraint_mode(0);
			item.Lui.constraint_mode(0);
			item.Jal.constraint_mode(0);
			item.Jalr.constraint_mode(0);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				 @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

task prueba_S;
	while (COV_Micro.Tipos.get_coverage()<30)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(0);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(0);
			item.I.constraint_mode(0);
			item.S.constraint_mode(1);
			item.L.constraint_mode(0);
			item.B.constraint_mode(0);
			item.Auipc.constraint_mode(0);
			item.Lui.constraint_mode(0);
			item.Jal.constraint_mode(0);
			item.Jalr.constraint_mode(0);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				  @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

task prueba_L;
	while (COV_Micro.Tipos.get_coverage()<40)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(0);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(0);
			item.I.constraint_mode(0);
			item.S.constraint_mode(0);
			item.L.constraint_mode(1);
			item.B.constraint_mode(0);
			item.Auipc.constraint_mode(0);
			item.Lui.constraint_mode(0);
			item.Jal.constraint_mode(0);
			item.Jalr.constraint_mode(0);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				 @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

task prueba_B;
	while (COV_Micro.Tipos.get_coverage()<50)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(0);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(0);
			item.I.constraint_mode(0);
			item.S.constraint_mode(0);
			item.L.constraint_mode(0);
			item.B.constraint_mode(1);
			item.Auipc.constraint_mode(0);
			item.Lui.constraint_mode(0);
			item.Jal.constraint_mode(0);
			item.Jalr.constraint_mode(0);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				 @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

task prueba_Auipc;
	while (COV_Micro.Tipos.get_coverage()<60)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(0);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(0);
			item.I.constraint_mode(0);
			item.S.constraint_mode(0);
			item.L.constraint_mode(0);
			item.B.constraint_mode(0);
			item.Auipc.constraint_mode(1);
			item.Lui.constraint_mode(0);
			item.Jal.constraint_mode(0);
			item.Jalr.constraint_mode(0);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				 @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

task prueba_Lui;
	while (COV_Micro.Tipos.get_coverage()<70)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(0);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(0);
			item.I.constraint_mode(0);
			item.S.constraint_mode(0);
			item.L.constraint_mode(0);
			item.B.constraint_mode(0);
			item.Auipc.constraint_mode(0);
			item.Lui.constraint_mode(1);
			item.Jal.constraint_mode(0);
			item.Jalr.constraint_mode(0);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				 @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

task prueba_Jal;
	while (COV_Micro.Tipos.get_coverage()<80)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(0);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(0);
			item.I.constraint_mode(0);
			item.S.constraint_mode(0);
			item.L.constraint_mode(0);
			item.B.constraint_mode(0);
			item.Auipc.constraint_mode(0);
			item.Lui.constraint_mode(0);
			item.Jal.constraint_mode(1);
			item.Jalr.constraint_mode(0);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				 @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

task prueba_Jalr;
	while (COV_Micro.Tipos.get_coverage()<90)
		begin
			//constraints SIMULTANEO cualquier instruccion
			item.instrucciones.constraint_mode(0);
			//constraints NO SIMULTANEOS
			item.R.constraint_mode(0);
			item.I.constraint_mode(0);
			item.S.constraint_mode(0);
			item.L.constraint_mode(0);
			item.B.constraint_mode(0);
			item.Auipc.constraint_mode(0);
			item.Lui.constraint_mode(0);
			item.Jal.constraint_mode(0);
			item.Jalr.constraint_mode(1);
			//randomizo
			item.randomize();

			assert (item.randomize()) else    $error("randomization failed");
				 @(testar_ports.sd);
				 testar_ports.sd.read_data<= item.read_data;
				 testar_ports.sd.instruction<= item.instruction;
		end
endtask

endclass
endpackage

program estimulos
  (test_if.test testar,
   test_if.monitor monitorizar  
  );                
especificaciones::enviroment casos = new(testar, monitorizar);     //declaración e instanciación objeto 

initial
begin
//casos.muestreo;
//casos.inicio;
casos.prueba_R;
$display("functional coverage de Tipos después prueba_R es %e", casos.COV_Micro.Tipos.get_coverage());
casos.prueba_I;
$display("functional coverage de Tipos después prueba_I es %e", casos.COV_Micro.Tipos.get_coverage());
casos.prueba_S;
$display("functional coverage de Tipos después prueba_S es %e", casos.COV_Micro.Tipos.get_coverage());
casos.prueba_L;
$display("functional coverage de Tipos después prueba_L es %e", casos.COV_Micro.Tipos.get_coverage());
casos.prueba_B;
$display("functional coverage de Tipos después prueba_B es %e", casos.COV_Micro.Tipos.get_coverage());
casos.prueba_Auipc;
$display("functional coverage de Tipos después prueba_Auipc es %e", casos.COV_Micro.Tipos.get_coverage());
casos.prueba_Lui;
$display("functional coverage de Tipos después prueba_Lui es %e", casos.COV_Micro.Tipos.get_coverage());
casos.prueba_Jal;
$display("functional coverage de Tipos después prueba_Jal es %e", casos.COV_Micro.Tipos.get_coverage());
casos.prueba_Jalr;
$display("functional coverage de Tipos después prueba_Jalr es %e", casos.COV_Micro.Tipos.get_coverage()); 
casos.aleatorio;
$display("functional coverage Total después aleatorio es %e", casos.COV_Micro.get_coverage()); 
$stop;
end
endprogram

