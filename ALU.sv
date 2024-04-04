module ALU (zero,alu_result,op1, op2,alu_control);

input logic [4:0] alu_control;
input logic [31:0] op1,op2;
output logic [31:0] alu_result;
output logic zero;

always_comb
begin

alu_result=32'd0;
zero=1'd0;

case (alu_control)


	
	5'b00000 : begin  //AUIPC, JAL, JALR, ADD, ADDI, SW
				alu_result= op1+op2;
				if (alu_result==32'd0)
					zero=1'd1;
				else 
					zero=1'd0;
			  end
	5'b00100 : begin //SLL Y SLLI
				alu_result=op1<<op2;	
				end
			  
	5'b01000 : begin	//BLT, SLTI Y SLT 
				if(op1<op2)
					begin
					alu_result=32'd1;
					zero=1'd0;
					end
				else 
					begin
					alu_result=32'd0;
					zero=1'd1;
					end
			  end

	5'b01100 : begin	//BLTU, SLTIU, SLTU
				if(op1<op2)
					begin
					alu_result=32'd1;
					zero=1'd0;
					end
				else 
					begin
					alu_result=32'd0;
					zero=1'd1;
					end
			  end
			  
	5'b11100 : begin	//AND, ANDI
				alu_result=op1&op2;
				if (alu_result==32'd0)
					zero=1'd1;
				else 
					zero=1'd0;
			  end		
	
	5'b11000 : begin	//OR, ORI
				alu_result=op1|op2;
				if (alu_result==32'd0)
					zero=1'd1;
				else 
					zero=1'd0;
			  end	
			  
	5'b10000 : begin	//XOR, XORI, BNE
				alu_result=op1^op2;
				if (alu_result==32'd0)
					zero=1'd1;
				else 
					zero=1'd0;
			  end	
		
	5'b11111 : begin	//LUI
				alu_result= op1+op2;
				if (alu_result==32'd0)
					zero=1'd1;
				else 
					zero=1'd0;
			  end
			  
	5'b00010 : begin	//BEQ, SUB
				alu_result= op1-op2;
				if (alu_result==32'd0)
					zero=1'd1;
				else 
					zero=1'd0;
			  end
			  
	5'b10100 : begin //	SRLI, SRL
				alu_result=op1>>op2;	
				end
				
	5'b10110 : begin //	SRAI, SRA
				alu_result=op1>>op2;	
				end
	
	5'b11110 : begin  //BGEU 
				if(op1>=op2)
					begin
					alu_result=32'd1;
					zero=1'd0;
					end
				else 
					begin
					alu_result=32'd0;
					zero=1'd1;
					end
			  end
	
	5'b11010 : begin  //BGE 
				if(op1>=op2)
					begin
					alu_result=32'd1;
					zero=1'd1;
					end
				else 
					begin
					alu_result=32'd0;
					zero=1'd0;
					end
			  end
	
	default : begin alu_result=32'd0;
				 zero=1'd0;
				 end
			  


endcase

end

endmodule


