// Module:  mem_wb
// File:    mem_wb.v
// Author:  Chen Zheng
// Description:	内存写回寄存器流水线组
`include "define.v"

module mem_wb(
    input wire  clk,
    input wire  rst,

    input wire[`RegBus]     mem_wdata,
    input wire              mem_we,
    input wire[`RegAddrBus] mem_waddr,

    output reg[`RegBus]     wb_wdata,
    output reg              wb_we,
    output reg[`RegAddrBus] wb_waddr
);
    always @(posedge clk)
    begin
      if(rst == `RstEnable)
      begin
        wb_waddr = `NOPRegAddr;
        wb_wdata = `ZeroWord;
        wb_we = `WriteDisable;    
      end
      else begin
        wb_waddr = mem_waddr;
        wb_wdata = mem_wdata;
        wb_we = mem_we;         
      end
    end
endmodule