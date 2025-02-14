module top_duv (test_if.duv bus) ; 
parameter size=32;
TOP_total_seg #(.size(size)) top_duv(
  
 .CLK(bus.CLK), .RSTa(bus.RSTa),.instruction_if(bus.instruction),.read_data_mem(bus.read_data),
 .address_mem(bus.address),.read_address(bus.read_address),.write_data(bus.write_data),
 .imm_gen_out_ex(bus.imm), .MemWrite_mem(bus.MemWrite),
 .MemRead_mem(bus.MemRead)

);


endmodule
