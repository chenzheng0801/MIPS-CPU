// Module:  mem
// File:    mem.v
// Author:  Chen Zheng
// Description:	访存模块
`include "define.v"
module mem(
    input wire      rst,

    input wire[`RegBus]         wdata,
    input wire[`RegAddrBus]     addr,
    input wire      we,

    output reg[`RegBus]     wdata_o,
    output reg[`RegAddrBus] waddr_o,
    output reg              we_o
);
    always @(*)
    begin
      if(rst == `RstEnable)
      begin
        waddr_o = `NOPRegAddr;
        wdata_o = `ZeroWord;
        we_o = `WriteDisable;    
      end
      else begin
        waddr_o = addr;
        wdata_o = wdata;
        we_o = we;
      end
    end
endmodule