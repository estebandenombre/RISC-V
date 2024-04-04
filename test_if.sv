`timescale 1ns/1ps
interface test_if (
  input  bit        CLK  , 
  input   bit      RSTa);
  logic       [31:0] read_data, instruction;
  logic [31:0] read_address, address, write_data,imm, read_address_ideal, address_ideal, write_data_ideal,imm_ideal;
  logic MemWrite, MemRead, MemWrite_ideal, MemRead_ideal;
  


  clocking md @(posedge CLK);
	input #1ns read_address;
	input #1ns address;
	input #1ns write_data;
   input #1ns read_address_ideal;
	input #1ns address_ideal;
	input #1ns write_data_ideal;
	input #1ns MemWrite;
	input #1ns MemRead;
	input #1ns MemWrite_ideal;
   input #1ns MemRead_ideal;
	input #1ns read_data;
	input #1ns instruction;
	input #1ns imm;
	input #1ns imm_ideal;
   endclocking:md;

  clocking sd @(posedge CLK);
   input #2ns read_address;
	input #2ns address;
	input #2ns write_data;
   input #2ns read_address_ideal;
	input #2ns address_ideal;
	input #2ns write_data_ideal;
	input #2ns MemWrite;
	input #2ns MemRead;
	input #2ns MemWrite_ideal;
   input #2ns MemRead_ideal;
	input #2ns imm;
	input #2ns imm_ideal;
	output #2ns read_data;
	output #2ns instruction;
  endclocking:sd;



  	modport monitor (clocking md);
   modport test (clocking sd);
	 modport ideal (
  		input          	CLK      ,
  		input        	RSTa      ,
  		output         read_address_ideal,address_ideal,write_data_ideal,imm_ideal  ,
  		output         MemWrite_ideal,MemRead_ideal   ,
  		input  			read_data,instruction
		);
    modport duv (
  		input          	CLK      ,
  		input        	RSTa      ,
  		output         read_address,address,write_data,imm  ,
  		input         	MemWrite,MemRead   ,
  		input  			read_data,instruction
		);
endinterface
