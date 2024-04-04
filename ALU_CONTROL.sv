module ALU_CONTROL 
(
input [3:0]instruction, //viene del inmediato
input [3:0]ALUop,
output logic [4:0]alu_control
);
always_comb 
begin
	case (ALUop)
		4'b0000:begin //L format (LW)	
						alu_control=5'b00000;
				  end
		4'b0010:begin //I format
						case(instruction[2:0])
								3'b000:begin //ADDI
											alu_control=5'b00000;
										 end
								3'b001:begin //SLLI
											alu_control=5'b00100;
										 end
								3'b010:begin //SLTI
											alu_control=5'b01000;
										 end
								3'b011:begin //SLTIU
											alu_control=5'b01100;
										 end
								3'b100:begin //XORI
											alu_control=5'b10000;
										end
								3'b101:begin //SRLI O SRAI
											if (instruction[3]==0)
												alu_control=5'b10100; //SRLI
											else
												alu_control=5'b10110;  //SRAI
										 end
								3'b110:begin //ORI
											alu_control=5'b11000;
										 end
								3'b111:begin //ANDI
											alu_control=5'b11100;
										 end
								default : begin 
											alu_control=5'b00000;
											 end			 							
						endcase
				  end
		4'b0011:begin //AUIPC
						alu_control=5'b00000;
				  end
		4'b0100:begin //S format (SW)
						alu_control=5'b00000;
				  end
		4'b0110:begin //R format
						case(instruction[2:0])
								3'b000:begin //ADD y SUB
											if (instruction[3]==0)
												alu_control=5'b00000;
											else
												alu_control=5'b00010;
										 end
								3'b001:begin //SLL
											alu_control=5'b00100;
										 end
								3'b010:begin //SLT
											alu_control=5'b01000;
										 end
								3'b011:begin //SLTU
											alu_control=5'b01100;
										 end
								3'b100:begin //XOR
											alu_control=5'b10000;
										 end
								3'b101:begin //SRL o SRA
										   if (instruction[3]==0)
												alu_control=5'b10100;
											else
												alu_control=5'b10110;
										 end
								3'b110:begin //OR
											alu_control=5'b11000;
										 end
								3'b111:begin //AND
											alu_control=5'b11100;
										 end 
								default : begin 
											alu_control=5'b00000;
											 end			 							
						endcase
				  end
		4'b0111:begin //LUI
						alu_control=5'b11111;
				  end
		4'b1101:begin //JALR Y JAL
						if(instruction[2:0]==3'b000) //JALR
								alu_control=5'b00000;
						else     //JAL
								alu_control=5'b00000;
				  end
		4'b1100:begin //B format
						case(instruction[2:0])
								3'b000:begin //BEQ o JALR
											alu_control=5'b00010;
										 end
								3'b001:begin //BNE
											alu_control=5'b10000;
										 end
								3'b100:begin //BLT
											alu_control=5'b01000;
										 end		 
								3'b101:begin //BGE
											alu_control=5'b11010;
										 end
								3'b110:begin //BLTU
											alu_control=5'b01100;
										 end
								3'b111:begin //BGEU
											alu_control=5'b11110;
										 end 
										 
								default : begin 
											alu_control=5'b00000;
											 end			 							
						endcase
				  end	
		default : begin 
						alu_control=5'b00000;
					 end
	endcase		  
end
endmodule
