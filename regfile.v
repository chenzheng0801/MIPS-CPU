// Module:  regfile
// File:    regfile.v
// Author:  Chen Zheng
// Description: 寄存器文件

`include "define.v"

module regfile(
	input wire	clk,
	input wire	rst,
	
	//写端口
	input	wire	we,
	input	wire	[`RegAddrBus]	waddr,
	input	wire	[`RegBus]		wdata,
	
	//读端口1
	input	wire	re1,
	input	wire	[`RegAddrBus]	raddr1,
	output	reg		[`RegBus]		rdata1,	
	
	//读端口2
	input	wire	re2,
	input	wire	[`RegAddrBus]	raddr2,
	output	reg		[`RegBus]		rdata2
);
	reg [`RegBus]	regs[0:`RegNum-1];
	
	//写寄存器
	integer i;
	always @(posedge clk)
	begin
		if(rst == `RstEnable) 
		begin
			for(i = 0; i < `RegNum; i=i+1)
			begin
				regs[i] <= `ZeroWord;
			end
		end
		else 
		begin
			if(we == `WriteEnable && waddr != `NOPRegAddr)
				regs[waddr] <= wdata;
		end
	end
	
	//读端口1寄存器
	always @(*)
	begin
		if(rst == `RstEnable)
			rdata1 = `ZeroWord;
		else if(raddr1 == `NOPRegAddr)
			rdata1 = `ZeroWord;
		else if(re1 == `ReadEnable && we == `WriteEnable && waddr == raddr1)
			rdata1 = wdata;
		else if(re1 == `ReadEnable )
			rdata1 = regs[raddr1];
		else
			rdata1 = `ZeroWord;
	end

	//读端口2寄存器
	always @(*)
	begin
		if(rst == `RstEnable)
			rdata2 = `ZeroWord;
		else if(raddr2 == `NOPRegAddr)
			rdata2 = `ZeroWord;
		else if(re2 == `ReadEnable && we == `WriteEnable && waddr == raddr2)
			rdata2 = wdata;
		else if(re2 == `ReadEnable )
			rdata2 = regs[raddr1];
		else
			rdata2 = `ZeroWord;
	end	
endmodule