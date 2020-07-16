// Module:  ex
// File:    ex.v
// Author:  Chen Zheng
// Description:	执行模块
`include "define.v"

module ex(
    input wire  rst,

    input wire[`RegBus]     reg1,
    input wire[`RegBus]     reg2,
    input wire[`AluOpBus]   aluop,
    input wire[`AluSelBus]  alusel,
    input wire[`RegAddrBus] wr_addr,
    input wire              reg_we,

    output reg[`RegBus]     wdata_o,
    output reg[`RegAddrBus] waddr_o,
    output reg              we_o
);
    /*********
    依据aluop对运算子类型进行运算
    **********/
    reg[`RegBus]    logic_output;
    reg[`RegBus]    shift_output;

    always @(*)
    begin
      if(rst == `RstEnable)
      begin
          logic_output = `ZeroWord;
      end
      else begin
          case(aluop)
            `EXE_XOR_OP:
            begin
                logic_output = reg1 ^ reg2;
            end
            `EXE_AND_OP:
            begin
                logic_output = reg1 & reg2;
            end
            `EXE_NOR_OP:
            begin
                logic_output = ~(reg1 | reg2);
            end
            `EXE_OR_OP:
            begin
                logic_output = reg1 | reg2;
            end
            default:
            begin
                logic_output = `ZeroWord;
            end
          endcase
      end
    end

    always @(*)
    begin
      if(rst == `RstEnable)
      begin
          shift_output = `ZeroWord;
      end
      else begin
          case(aluop)
            `EXE_SLL_OP:
            begin
                shift_output = reg2 << reg1[4:0];
            end
            `EXE_SRL_OP:
            begin
                shift_output = reg2 >> reg1[4:0];
            end
            `EXE_SRA_OP:
            begin
                shift_output = ({32{reg2[31]}} << (6'd32-{1'b0, reg1[4:0]})) 
												| reg2 >> reg1[4:0];
            end
            default:
            begin
                shift_output = `ZeroWord;
            end
          endcase
      end
    end


    /*********
    依据alusel对运算结果进行选择
    **********/
    always @(*)
    begin
      we_o = reg_we;
      waddr_o = wr_addr;

      case (alusel)
       `EXE_RES_LOGIC: 
        begin
            wdata_o = logic_output;
        end
       `EXE_RES_SHIFT: 
        begin
            wdata_o = shift_output;
        end
       default 
        begin
            wdata_o = `ZeroWord;    
        end
      endcase
    end

endmodule