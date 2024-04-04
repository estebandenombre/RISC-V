module TOP_total (CLK, RSTa ,read_data, instruction, read_address, imm, address, write_data,MemWrite,MemRead);
parameter size=32;
input CLK, RSTa;
input [size-1:0] read_data, instruction;
output logic [size-1:0] read_address, address, write_data,imm;
output logic MemWrite, MemRead;

logic [size-1:0] pc_in, pc_out, pc_intermedio, Sum, read_data1, read_data2, ALU_result, mux_ram, mux_grande, mux_alu;
logic MemtoReg, ALUSrc, mux_pcin, zero, RegWrite, Branch;
logic [4:0] alu_control;
logic [1:0] AuipcLui,JalJalr;
logic [3:0] ALUOp;




//INSTANCIACION ALU

ALU ALU_inst
(
	.zero(zero) ,	// output  zero_sig
	.alu_result(ALU_result) ,	// output [31:0] alu_result_sig
	.op1(mux_grande) ,	// input [31:0] op1_sig
	.op2(mux_alu) ,	// input [31:0] op2_sig
	.alu_control(alu_control) 	// input [4:0] alu_control_sig
);


//INSTANCIACION PC

PC PC_inst
(
	.clk(CLK) ,
	.reset(RSTa) ,	// input  clk_sig
	.pc_entrada(pc_in) ,	// input [31:0] pc_entrada_sig
	.pc_salida(pc_out) 	// output [31:0] pc_salida_sig
);


//INSTANCIACION REGISTROS


REGISTERS REGISTERS_inst
(
	.read_reg1(instruction[19:15]) ,	// input [4:0] read_reg1_sig
	.read_reg2(instruction[24:20]) ,	// input [4:0] read_reg2_sig
	.w_reg(instruction[11:7]) ,	// input [4:0] w_reg_sig
	.w_data(mux_ram) ,	// input [31:0] w_data_sig
	.read_data1(read_data1) ,	// output [31:0] read_data1_sig
	.read_data2(read_data2) ,	// output [31:0] read_data2_sig
	.clk(CLK) ,	// input  clk_sig
	.reg_write(RegWrite), 	// input  reg_write_sig
	.reset(RSTa)
);
defparam REGISTERS_inst.mem_depth = 32;
defparam REGISTERS_inst.size = 32;


ALU_CONTROL ALU_CONTROL_inst
(
	.instruction({instruction[30],instruction[14:12]}) ,	// input [3:0] instruction_sig
	.ALUop(ALUOp) ,	// input [3:0] ALUop_sig
	.alu_control(alu_control) 	// output [4:0] alu_control_sig
);


CONTROL CONTROL_inst
(
	.instruction(instruction) ,	// input [6:0] instruction_sig
	.Branch(Branch) ,	// output  Branch_sig
	.MemRead(MemRead) ,	// output  MemRead_sig
	.MemtoReg(MemtoReg) ,	// output  MemtoReg_sig
	.MemWrite(MemWrite) ,	// output  MemWrite_sig
	.ALUSrc(ALUSrc) ,	// output  ALUSrc_sig
	.RegWrite(RegWrite) ,	// output  RegWrite_sig
	.AuipcLui(AuipcLui) ,	// output [1:0] AuipcLui_sig
	.ALUOp(ALUOp) ,	// output [3:0] ALUOp_sig
	.JalJalr(JalJalr) // output  JalJalr_sig
);

Imm_Gen Imm_Gen_inst
(
	.inst(instruction) ,	// input [31:0] inst_sig
	.imm(imm) 	// output [31:0] imm_sig
);


assign read_address=pc_out;
assign address=ALU_result;
assign write_data= read_data2;
assign mux_pcin= Branch & zero;

 
assign pc_intermedio = pc_out + 32'd4;
assign Sum= pc_out + imm; 
assign pc_in=JalJalr[1]?(JalJalr[0]?(Sum):(ALU_result)):(mux_pcin?(Sum):(pc_intermedio));
assign mux_alu= ALUSrc?(imm):(read_data2);
assign mux_ram= JalJalr[1]?pc_intermedio:(MemtoReg?(read_data):(ALU_result));
assign mux_grande=AuipcLui[1]?(read_data1):(AuipcLui[0]?(32'd0):(pc_out));

endmodule 