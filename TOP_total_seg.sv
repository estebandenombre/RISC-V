module TOP_total_seg (CLK, RSTa ,read_data_mem, instruction_if, read_address, address_mem, write_data,MemWrite_mem,MemRead_mem,imm_gen_out_ex);

parameter size=32;
input CLK, RSTa ;
input [31:0] instruction_if, read_data_mem;
output logic [31:0] read_address, address_mem, write_data, imm_gen_out_ex;
output logic MemWrite_mem, MemRead_mem;


logic [31:0] pc_in, pc_out_id,pc_out_if, pc_out_ex , instruction_id,pc_intermedio_if,pc_intermedio_id,pc_intermedio_ex,pc_intermedio_mem,pc_intermedio_wb, Sum_ex, Sum_mem, imm_gen_out_id , read_data1_id, read_data2_id,read_data1_ex, read_data2_ex, ALU_result_ex, mux_ram, mux_grande, mux_alu, ALU_result_mem,read_data2_mem, read_data_wb, address_wb;
logic MemtoReg_ex,MemtoReg_id,MemtoReg_mem, MemtoReg_wb, ALUSrc_ex,ALUSrc_id, mux_pcin, zero_ex,RegWrite_mem, RegWrite_wb, RegWrite_id, RegWrite_ex, Branch_ex, Branch_id,zero_mem,Branch_mem,MemWrite_ex,MemRead_ex;
logic [4:0] alu_control;
logic [3:0] ALUOp_id, ALUOp_ex;
logic MemWrite_id, MemRead_id;
logic [8:0] instruction_ex;
logic [4:0] instruction_mem,instruction_wb;
logic [1:0] AuipcLui_ex, AuipcLui_id, JalJalr_id, JalJalr_ex, JalJalr_mem, JalJalr_wb;





//INSTANCIACION ALU

ALU ALU_inst
(
	.zero(zero_ex) ,	// output  zero_sig
	.alu_result(ALU_result_ex) ,	// output [31:0] alu_result_sig
	.op1(mux_grande) ,	// input [31:0] op1_sig
	.op2(mux_alu) ,	// input [31:0] op2_sig
	.alu_control(alu_control) 	// input [4:0] alu_control_sig
);


//INSTANCIACION PC

PC PC_inst
(
	.clk(CLK) ,
	.reset(RSTa) ,	
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
	.reg_write(RegWrite_wb),// input  reg_write_sig
	.reset(RSTa)
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
	.Branch(Branch_id) ,	// output  Branch_sig
	.MemRead(MemRead_id) ,	// output  MemRead_sig
	.MemtoReg(MemtoReg_id) ,	// output  MemtoReg_sig
	.MemWrite(MemWrite_id) ,	// output  MemWrite_sig
	.ALUSrc(ALUSrc_id) ,	// output  ALUSrc_sig
	.RegWrite(RegWrite_id) ,	// output  RegWrite_sig
	.AuipcLui(AuipcLui_id) ,	// output [1:0] AuipcLui_sig
	.ALUOp(ALUOp_id) ,	// output [3:0] ALUOp_sig
	.JalJalr(JalJalr_id) // output  JalJalr_sig 		////////////////////////////////me cago en la puta
);

Imm_Gen Imm_Gen_inst
(
	.inst(instruction_id) ,	// input [31:0] inst_sig
	.imm(imm_gen_out_id) 	// output [31:0] imm_sig
);


assign read_address=pc_out_if;
assign address_mem=ALU_result_mem;
assign write_data= read_data2_mem;
assign mux_pcin = Branch_mem & zero_mem;

 
assign pc_intermedio_if = pc_out_if + 32'd4;
assign Sum_ex = pc_out_ex + imm_gen_out_ex;
assign pc_in=JalJalr_mem[1]?(JalJalr_mem[0]?(Sum_mem):(ALU_result_mem)):(mux_pcin?(Sum_mem):(pc_intermedio_if));	////////////////
assign mux_alu= (ALUSrc_ex)?imm_gen_out_ex:read_data2_ex;
assign mux_ram= JalJalr_wb[1]?pc_intermedio_wb:(MemtoReg_wb?(read_data_wb):(address_wb)); 		////////////////////////
assign mux_grande=AuipcLui_ex[1] ? (read_data1_ex) : ( AuipcLui_ex[0] ? 32'd0: pc_out_ex);

always @(negedge CLK) //primera etapa
begin
pc_out_id<=pc_out_if;
instruction_id<=instruction_if;
pc_intermedio_id<=pc_intermedio_if;
end

always @(negedge CLK) //segunda etapa
begin
pc_out_ex<=pc_out_id;
read_data1_ex<=read_data1_id;
read_data2_ex<=read_data2_id;
imm_gen_out_ex<=imm_gen_out_id;
instruction_ex <={instruction_id[30], instruction_id[14:12], instruction_id[11:7]};
Branch_ex<=Branch_id;
MemRead_ex<=MemRead_id;
MemtoReg_ex<=MemtoReg_id;
MemWrite_ex<=MemWrite_id;
ALUSrc_ex<=ALUSrc_id;
RegWrite_ex<=RegWrite_id;
AuipcLui_ex<=AuipcLui_id;
ALUOp_ex<=ALUOp_id;
JalJalr_ex<=JalJalr_id;
pc_intermedio_ex<=pc_intermedio_id;
end

always @(negedge CLK) //tercera etapa
begin
Sum_mem <= Sum_ex;
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
end

always @(negedge CLK) //cuarta etapa
begin
RegWrite_wb <= RegWrite_mem;
read_data_wb <= read_data_mem;
address_wb <= address_mem;
instruction_wb <= instruction_mem;
MemtoReg_wb <= MemtoReg_mem;
JalJalr_wb<=JalJalr_mem;
pc_intermedio_wb<=pc_intermedio_mem;

end


endmodule 