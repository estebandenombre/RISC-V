module top_ideal (test_if.ideal bus) ; 
parameter size=32;
TOP_total #(.size(size)) top_ideal(
  
 .CLK(bus.CLK), .RSTa(bus.RSTa),.instruction(bus.instruction),.read_data(bus.read_data),
 .address(bus.address_ideal),.read_address(bus.read_address_ideal),.write_data(bus.write_data_ideal),
 .imm(bus.imm_ideal), .MemWrite(bus.MemWrite_ideal),
 .MemRead(bus.MemRead_ideal)

);


endmodule
