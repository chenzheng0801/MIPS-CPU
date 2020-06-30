// Module:  if_id
// File:    if_id.v
// Author:  Chen Zheng
// Description: 取指、解码流水线组
`include "define.v"

module if_id(
	input 	wire	rst,
	input 	wire	clk,
	
	//取值阶段
	input 	wire	[`InstAddrBus]	if_pc,
	input 	wire	[`InstBus]		if_inst,
	
	//译码阶段
	output	reg		[`InstAddrBus]	id_pc,
	output	reg		[`InstBus]		id_inst
);
	
	always @(posedge clk)
	begin
		if(rst == `RstEnable)
		begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end
		else
		begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
endmodule