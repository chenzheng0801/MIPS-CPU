// Module:  openmips_soc
// File:    openmips_soc.v
// Author:  Chen Zheng
// Description: SOC片上系统

`include "define.v"
`include "openmips.v"
`include "inst_rom.v"

module openmips_soc(
    input wire clk,
    input wire rst
);
    wire [`InstBus] inst;
    
    wire[`InstAddrBus]inst_addr;
    wire ce;

    openmips openmips0(
        .clk(clk), .rst(rst),
        .inst(inst),
        .inst_addr(inst_addr), .ce(ce)
    );
    inst_rom inst_rom0(
        .ce(ce),
        .addr(inst_addr), .inst(inst)
    );
endmodule