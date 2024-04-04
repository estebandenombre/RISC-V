module CONTROL 
(
input [6:0]instruction, //opcode
output logic Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,
output logic [1:0] AuipcLui,JalJalr,
output logic [3:0] ALUOp
);
//0110011 R format
//0010011 I format
//0000011 L format
//0100011 S format
//1100011 B format
//0110111 Lui
//0010111 Auipc
//1101111 Jal
//1100111 Jalr
always_comb 
begin
	case (instruction)
		7'b0110011:begin 	//R format
						Branch=0;MemRead=0;MemtoReg=0;ALUOp=4'b0110;MemWrite=0;
						ALUSrc=0;RegWrite=1;AuipcLui=2'b10;JalJalr=2'b00;
					  end
		7'b0010011:begin	//I format
						Branch=0;MemRead=0;MemtoReg=0;ALUOp=4'b0010;MemWrite=0;
						ALUSrc=1;RegWrite=1;AuipcLui=2'b10;JalJalr=2'b00;
					  end
		7'b0000011:begin	//L format
						Branch=0;MemRead=1;MemtoReg=1;ALUOp=4'b0000;MemWrite=0;
						ALUSrc=1;RegWrite=1;AuipcLui=2'b10;JalJalr=2'b00;
					  end
		7'b0100011:begin	//S format
						Branch=0;MemRead=0;MemtoReg=0;ALUOp=4'b0100;MemWrite=1;
						ALUSrc=1;RegWrite=0;AuipcLui=2'b10;JalJalr=2'b00;
					  end
		7'b1100011:begin	//B format
						Branch=1;MemRead=0;MemtoReg=0;ALUOp=4'b1100;MemWrite=0;
						ALUSrc=0;RegWrite=0;AuipcLui=2'b10;JalJalr=2'b00;
					  end
		7'b0110111:begin	//Lui
						Branch=0;MemRead=0;MemtoReg=0;ALUOp=4'b0111;MemWrite=0;
						ALUSrc=1;RegWrite=1;AuipcLui=2'b01;JalJalr=2'b00;
					  end
		7'b0010111:begin	//Auipc
						Branch=0;MemRead=0;MemtoReg=0;ALUOp=4'b0011;MemWrite=0;
						ALUSrc=1;RegWrite=1;AuipcLui=2'b00;JalJalr=2'b00;
					  end
		7'b1101111:begin	//Jal
						Branch=0;MemRead=0;MemtoReg=0;ALUOp=4'b1101;MemWrite=0;
						ALUSrc=0;RegWrite=1;AuipcLui=2'b10;JalJalr=2'b11;
					  end
		7'b1100111:begin	//Jalr
						Branch=0;MemRead=0;MemtoReg=0;ALUOp=4'b1101;MemWrite=0;
						ALUSrc=1;RegWrite=1;AuipcLui=2'b10;JalJalr=2'b10;
					  end	
		default : begin Branch=0;MemRead=0;MemtoReg=0;ALUOp=4'b0000;MemWrite=0;
						ALUSrc=0;RegWrite=0;AuipcLui=2'b00;JalJalr=2'b00;
				 end		  
	endcase
end
endmodule
