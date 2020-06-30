// Module:  id_ex
// File:    id_ex.v
// Author:  Chen Zheng
// Description:	解码/执行流水线寄存器组
`include "define.v"

module id_ex(
    input wire      clk,
    input wire      rst,

    input wire[`AluOpBus]       aluop_id,
    input wire[`AluSelBus]      alusel_id,
    input wire[`RegBus]         reg1_id,
    input wire[`RegBus]         reg2_id,
    input wire[`RegAddrBus]     wr_addr_id,
    input wire                  we_reg_id,

    output reg[`AluOpBus]       aluop_ex,
    output reg[`AluSelBus]      alusel_ex,
    output reg[`RegBus]         reg1_ex,
    output reg[`RegBus]         reg2_ex,
    output reg[`RegAddrBus]     wr_addr_ex,
    output reg                  reg_we_ex
);
    always @(posedge clk)
    begin
      if(rst == `RstEnable)
      begin
        aluop_ex    <= `EXE_NOP_OP;
        alusel_ex   <= `EXE_RES_NOP;
        reg1_ex     <= `ZeroWord;
        reg2_ex     <= `ZeroWord;
        wr_addr_ex  <= `NOPRegAddr;
        reg_we_ex   <= `WriteDisable;
      end
      else
      begin
        aluop_ex    <= aluop_id;
        alusel_ex   <= alusel_id;
        reg1_ex     <= reg1_id;
        reg2_ex     <= reg2_id;
        wr_addr_ex  <= wr_addr_id;
        reg_we_ex   <= we_reg_id;
      end
    end
endmodule