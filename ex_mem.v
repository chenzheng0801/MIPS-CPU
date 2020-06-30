// Module:  ex_mem
// File:    ex_mem.v
// Author:  Chen Zheng
// Description:	执行访存寄存器组
`include "define.v"

module ex_mem(
    input wire      rst,
    input wire      clk,
    input wire[`RegBus]         ex_wdata,
    input wire[`RegAddrBus]     ex_addr,
    input wire      ex_we,

    output reg[`RegBus]         mem_wdata,
    output reg[`RegAddrBus]     mem_addr,
    output reg      mem_we
);
    always @(posedge clk)
    begin
      if(rst == `RstEnable)
      begin
        mem_addr = `NOPRegAddr;
        mem_wdata = `ZeroWord;
        mem_we = `WriteDisable;    
      end
      else begin
        mem_addr = ex_addr;
        mem_wdata = ex_wdata;
        mem_we = ex_we;         
      end
    end
endmodule