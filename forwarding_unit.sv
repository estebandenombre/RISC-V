module forwarding_unit(Rs1_ex,Rs2_ex,MEMRegRd,WBRegRd,RegWrite_mem,RegWrite_wb,ForwardA,ForwardB);
input logic [4:0] Rs1_ex,Rs2_ex,MEMRegRd,WBRegRd;
input logic RegWrite_mem,RegWrite_wb;
output logic [1:0] ForwardA,ForwardB;

always_comb 
begin
if(RegWrite_mem && (MEMRegRd != 0) && (MEMRegRd == Rs1_ex))
begin
ForwardA<=2'b10;
end
if(RegWrite_wb && (WBRegRd != 0) && (WBRegRd == Rs1_ex)) 
begin
ForwardA <= 2'b01;
end
else ForwardA <=2'b00;

if(RegWrite_mem && (MEMRegRd != 0) && (MEMRegRd == Rs2_ex)) 
begin
ForwardB<=2'b10;
end
else if(RegWrite_wb && (WBRegRd != 0) && (WBRegRd == Rs2_ex)) 
begin
ForwardB <= 2'b01;
end
else ForwardB <= 2'b00;
end

endmodule
