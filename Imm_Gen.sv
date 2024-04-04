module Imm_Gen (inst,imm);

input logic [31:0] inst;
output logic [31:0] imm;

always_comb
	begin
	case (inst[6:2])
	
	5'b11011: begin //Jal
			imm<={{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};
		  end
		  
	5'b11001: begin //JalR
			imm<={{21{inst[31]}},inst[30:20]};
		  end
	
	5'b11000: begin //B
			imm<= {{20{inst[31]}},inst[7],inst[30:25], inst[11:8],1'b0};
		  end
		  
	5'b00000: begin  //L
			imm<={{21{inst[31]}}, inst[30:20]};
		  end
		  
	5'b01000: begin  //S
			imm<= {{21{inst[31]}}, inst[30:25],inst[11:7]};
		  end
		  
	5'b00100: begin  //I
			imm<={{21{inst[31]}}, inst[30:20]};
		  end 
		  
	5'b01101: begin  //LUI
			 imm <= {inst[31:12], 12'd0};
		  end 
		  
	5'b00101: begin  //AUIPC
			 imm <= {inst[31:12], 12'd0};
		  end 
		  default: imm<=32'd0;
	endcase
	end


endmodule 