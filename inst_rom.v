// Module:  inst_rom
// File:    inst_rom.v
// Author:  Chen Zheng
// Description: 指令存储器


`include "define.v"

module inst_rom(
	input wire ce,
	input wire [`InstAddrBus] addr,
	output reg [`InstBus] inst
);
	reg [`InstBus]	rom[0:`InstMemSize-1];

	initial $readmemh("inst_rom.data", rom);

	always @(*)
	begin
		if(ce == `ChipEnable) 
			inst <= rom[addr[`InstMemSizeLog2+1:2]];
		else 
			inst <= `ZeroWord;
	end
	
endmodule