module TOP_total_control_de_riesgos (CLK, RSTa ,read_data_mem, instruction_if, read_address, address_mem, write_data,MemWrite_mem,MemRead_mem,imm_gen_out_ex);
parameter size=32;
input CLK, RSTa ;
input [31:0] instruction_if, read_data_mem;
output logic [31:0] read_address, address_mem, write_data, imm_gen_out_ex;
output logic MemWrite_mem, MemRead_mem;


logic [31:0] pc_in, mux_alu,pc_out_id,pc_out_if, pc_out_ex , instruction_id,pc_intermedio_if,pc_intermedio_id,pc_intermedio_ex,pc_intermedio_mem,pc_intermedio_wb,imm_gen_out_id , read_data1_id, read_data2_id,read_data1_ex, read_data2_ex, ALU_result_ex, mux_ram, ALU_result_mem,read_data2_mem, read_data_wb, address_wb,mux_alu1,mux_alu2,sum_peque;
logic MemtoReg_ex,MemtoReg_id,MemtoReg_mem, MemtoReg_wb,ALUSrc_id,ALUSrc_ex, mux_pcin, zero_ex,RegWrite_mem, RegWrite_wb, RegWrite_id, RegWrite_ex, Branch_ex, Branch_id,zero_mem,Branch_mem,MemWrite_ex,MemRead_ex,control_select,PCWrite,IFIDWrite,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite;
logic [4:0] alu_control;
logic [3:0] ALUOp_id, ALUOp_ex,ALUOp;
logic MemWrite_id, MemRead_id;
logic [8:0] instruction_ex;
logic [4:0] instruction_mem,instruction_wb,Rs1_id,Rs2_id,Rd_id,Rs1_ex,Rs2_ex,Rd_ex,Rd_mem,Rd_wb;
logic [1:0] AuipcLui_ex, AuipcLui_id, JalJalr_id, JalJalr_ex, JalJalr_mem, JalJalr_wb,AuipcLui,JalJalr,ForwardA,ForwardB;
logic [13:0]mux_control;




//INSTANCIACION ALU

ALU ALU_inst
(
	.zero(zero_ex) ,	// output  zero_sig
	.alu_result(ALU_result_ex) ,	// output [31:0] alu_result_sig
	.op1(mux_alu1) ,	// input [31:0] op1_sig
	.op2(mux_alu2) ,	// input [31:0] op2_sig
	.alu_control(alu_control) 	// input [4:0] alu_control_sig
);


//INSTANCIACION PC

PC PC_inst
(
	.clk(CLK) ,
	.reset(RSTa) ,	// input  clk_sig
	.pc_entrada(pc_in) ,	// input [31:0] pc_entrada_sig
	.pc_salida(pc_out_if) 	// output [31:0] pc_salida_sig
);


//INSTANCIACION REGISTROS


REGISTERS REGISTERS_inst
(
	.read_reg1(instruction_id[19:15]) ,	// input [4:0] read_reg1_sig
	.read_reg2(instruction_id[24:20]) ,	// input [4:0] read_reg2_sig
	.w_reg(instruction_wb) ,	// input [4:0] w_reg_sig
	.w_data(mux_ram) ,	// input [31:0] w_data_sig
	.read_data1(read_data1_id) ,	// output [31:0] read_data1_sig
	.read_data2(read_data2_id) ,	// output [31:0] read_data2_sig
	.clk(CLK) ,	// input  clk_sig
	.reg_write(RegWrite_wb),
	.reset(RSTa)// input  reg_write_sig
);
defparam REGISTERS_inst.mem_depth = 32;
defparam REGISTERS_inst.size = 32;


ALU_CONTROL ALU_CONTROL_inst
(
	.instruction({instruction_ex[8],instruction_ex[7:5]}) ,	// input [3:0] instruction_sig
	.ALUop(ALUOp_ex) ,	// input [3:0] ALUop_sig
	.alu_control(alu_control) 	// output [4:0] alu_control_sig
);


CONTROL CONTROL_inst
(
	.instruction(instruction_id) ,	// input [6:0] instruction_sig
	.Branch(Branch) ,	// output  Branch_sig
	.MemRead(MemRead) ,	// output  MemRead_sig
	.MemtoReg(MemtoReg) ,	// output  MemtoReg_sig
	.MemWrite(MemWrite) ,	// output  MemWrite_sig
	.ALUSrc(ALUSrc) ,	// output  ALUSrc_sig
	.RegWrite(RegWrite) ,	// output  RegWrite_sig
	.AuipcLui(AuipcLui) ,	// output [1:0] AuipcLui_sig
	.ALUOp(ALUOp) ,	// output [3:0] ALUOp_sig
	.JalJalr(JalJalr) // output  JalJalr_sig 		////////////////////////////////
);

Imm_Gen Imm_Gen_inst
(
	.inst(instruction_id) ,	// input [31:0] inst_sig
	.imm(imm_gen_out_id) 	// output [31:0] imm_sig
);

hazard_detection_unit hazard_detection_unit_inst
(
	.ins(instruction_id) ,	// input [31:0] ins_sig
	.rd(Rd_id) ,	// input [4:0] rd_sig
	.memrd(MemRead_ex) ,	// input  memrd_sig
	.control(control_select) ,	// output  control_sig
	.PCWrite(PCWrite) ,	// output  PCWrite_sig
	.IFIDWrite(IFIDWrite) 	// output  IFIDWrite_sig
);

forwarding_unit forwarding_unit_inst
(
	.Rs1_ex(Rs1_ex) ,	// input [4:0] Rs1_ex_sig
	.Rs2_ex(Rs2_ex) ,	// input [4:0] Rs2_ex_sig
	.MEMRegRd(Rd_mem) ,	// input [4:0] MEMRegRd_sig
	.WBRegRd(Rd_wb) ,	// input [4:0] WBRegRd_sig
	.RegWrite_mem(RegWrite_mem) ,	// input  RegWrite_mem_sig
	.RegWrite_wb(RegWrite_wb) ,	// input  RegWrite_wb_sig
	.ForwardA(ForwardA) ,	// output [1:0] ForwardA_sig
	.ForwardB(ForwardB) 	// output [1:0] ForwardB_sig
);
assign read_address=pc_out_if;
assign address_mem=ALU_result_mem;
assign write_data= read_data2_mem;
assign mux_pcin = Branch_mem & zero_mem;
assign pc_intermedio_if = pc_out_if + 32'd4;
//assign Sum_ex = pc_out_ex + imm_gen_out_ex;?? SE DEJA O SE QUITA??
assign pc_in=JalJalr_mem[1]?(JalJalr_mem[0]?(sum_peque):(ALU_result_mem)):(mux_pcin?(sum_peque):(pc_intermedio_if));	////////////////
assign mux_alu= (ALUSrc_ex)?imm_gen_out_ex:read_data2_ex;
assign mux_ram= JalJalr_wb[1]?pc_intermedio_wb:(MemtoReg_wb?(read_data_wb):(address_wb)); 		////////////////////////
//assign mux_grande=AuipcLui_ex[1] ? (read_data1_ex) : ( AuipcLui_ex[0] ? 32'd0: pc_out_ex);
assign mux_control= (!control_select)?({Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,AuipcLui,ALUOp,JalJalr}):14'd0;
assign Rs1_id=instruction_id[19:15];
assign Rs2_id=instruction_id[24:20];
assign Rd_id=instruction_id[11:7];
assign mux_alu1=ForwardA[1]?(ALU_result_mem):(ForwardA[0]?(mux_ram):(read_data1_ex));
assign mux_alu2=ForwardB[1]?(ALU_result_mem):(ForwardB[0]?(mux_ram):(mux_alu));
assign sum_peque=pc_out_id+imm_gen_out_id;

//Desconcatenación del muxcontrol

assign Branch_id=mux_control[13];
assign MemRead_id=mux_control[12];
assign MemtoReg_id=mux_control[11];
assign MemWrite_id=mux_control[10];
assign ALUSrc_id=mux_control[9];
assign RegWrite_id=mux_control[8];
assign AuipcLui_id=mux_control[7:6];
assign ALUOp_id=mux_control[5:2];
assign JalJalr_id=mux_control[1:0];

always @(negedge CLK or negedge RSTa) //primera etapa
begin
if(!RSTa)
begin
pc_out_id<=0;
instruction_id<=0;
pc_intermedio_id<=0;
end
else if(mux_pcin)
begin
pc_out_id<=0;
instruction_id<=0;
pc_intermedio_id<=0;
end
else
begin
pc_out_id<=pc_out_if;
instruction_id<=instruction_if;
pc_intermedio_id<=pc_intermedio_if;
end
end

always @(negedge CLK or negedge RSTa) //segunda etapa
begin
if(!RSTa)
begin
read_data1_ex<=0;
read_data2_ex<=0;
imm_gen_out_ex<=0;
instruction_ex<=0;
Branch_ex<=0;
MemRead_ex<=0;
MemtoReg_ex<=0;
MemWrite_ex<=0;
RegWrite_ex<=0;
AuipcLui_ex<=0;
ALUSrc_ex<=0;
ALUOp_ex<=0;
JalJalr_ex<=0;
pc_intermedio_ex<=0;
Rs1_ex<=0;
Rs2_ex<=0;
Rd_ex<=0;
end
else if(mux_pcin)
begin
read_data1_ex<=0;
read_data2_ex<=0;
imm_gen_out_ex<=0;
instruction_ex<=0;
Branch_ex<=0;
MemRead_ex<=0;
MemtoReg_ex<=0;
MemWrite_ex<=0;
RegWrite_ex<=0;
AuipcLui_ex<=0;
ALUSrc_ex<=0;
ALUOp_ex<=0;
JalJalr_ex<=0;
pc_intermedio_ex<=0;
Rs1_ex<=0;
Rs2_ex<=0;
Rd_ex<=0;
end
else if(IFIDWrite)
begin
read_data1_ex<=read_data1_id;
read_data2_ex<=read_data2_id;
imm_gen_out_ex<=imm_gen_out_id;
instruction_ex <={instruction_id[30], instruction_id[14:12], instruction_id[11:7]};
Branch_ex<=Branch_id;
MemRead_ex<=MemRead_id;
MemtoReg_ex<=MemtoReg_id;
MemWrite_ex<=MemWrite_id;
RegWrite_ex<=RegWrite_id;
AuipcLui_ex<=AuipcLui_id;
ALUSrc_ex<=ALUSrc_id;
ALUOp_ex<=ALUOp_id;
JalJalr_ex<=JalJalr_id;
pc_intermedio_ex<=pc_intermedio_id;
Rs1_ex<=Rs1_id;
Rs2_ex<=Rs2_id;
Rd_ex<=Rd_id;
end
end

always @(negedge CLK or negedge RSTa) //tercera etapa
begin
if(!RSTa)
begin
ALU_result_mem<=0;
read_data2_mem<=0;
zero_mem<=0;
Branch_mem<=0;
MemWrite_mem<=0;
MemRead_mem<=0;
instruction_mem<=0;
RegWrite_mem <= 0;
MemtoReg_mem<=0;
JalJalr_mem<=0;
pc_intermedio_mem<=0;
Rd_mem<=0;
end
else if(mux_pcin)
begin
ALU_result_mem<=0;
read_data2_mem<=0;
zero_mem<=0;
Branch_mem<=0;
MemWrite_mem<=0;
MemRead_mem<=0;
instruction_mem<=0;
RegWrite_mem <= 0;
MemtoReg_mem<=0;
JalJalr_mem<=0;
pc_intermedio_mem<=0;
Rd_mem<=0;
end
else
begin
ALU_result_mem<=ALU_result_ex;
read_data2_mem<=read_data2_ex;
zero_mem<=zero_ex;
Branch_mem<=Branch_ex;
MemWrite_mem<=MemWrite_ex;
MemRead_mem<=MemRead_ex;
instruction_mem<=instruction_ex[4:0];
RegWrite_mem <= RegWrite_ex;
MemtoReg_mem<=MemtoReg_ex;
JalJalr_mem<=JalJalr_ex;
pc_intermedio_mem<=pc_intermedio_ex;
Rd_mem<=Rd_ex;
end
end

always @(negedge CLK or negedge RSTa) //cuarta etapa
begin
if(!RSTa)
begin
RegWrite_wb <= 0;
read_data_wb <= 0;
address_wb <= 0;
instruction_wb <= 0;
MemtoReg_wb <= 0;
JalJalr_wb<=0;
pc_intermedio_wb<=0;
Rd_wb<=0;
end
else 
begin
RegWrite_wb <= RegWrite_mem;
read_data_wb <= read_data_mem;
address_wb <= address_mem;
instruction_wb <= instruction_mem;
MemtoReg_wb <= MemtoReg_mem;
JalJalr_wb<=JalJalr_mem;
pc_intermedio_wb<=pc_intermedio_mem;
Rd_wb<=Rd_mem;
end
end

endmodule 