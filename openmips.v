// Module:  openmips
// File:    openmips.v
// Author:  Chen Zheng
// Description:	内存写回寄存器流水线组
`include "define.v"
`include "pc_reg.v"
`include "if_id.v"
`include "id.v"
`include "regfile.v"
`include "id_ex.v"
`include "ex.v"
`include "ex_mem.v"
`include "mem.v"
`include "mem_wb.v"


module openmips(
    input wire clk,
    input wire rst,
    input wire [`InstBus] inst,
    
    output wire[`InstAddrBus]inst_addr,
    output wire ce
    
);
    /**PC模块连接并实例化**/
    pc_reg pc_reg0( .clk(clk), .rst(rst), .pc(inst_addr), .ce(ce));


    
    /**IF/ID模块连接并实例化**/
    wire[`InstAddrBus] id_pc;
    wire[`InstBus]     id_inst;

    if_id if_id0( 
        .clk(clk), .rst(rst), .if_pc(inst_addr),
         .if_inst(inst), .id_pc(id_pc), .id_inst(id_inst)
    );

    

    /**连接ID模块并实例化**/
    //id输出信息
    wire[`AluOpBus]     aluop;
    wire[`AluSelBus]    alusel;
    wire[`RegBus]       reg1_ops;
    wire[`RegBus]       reg2_ops;
    wire[`RegAddrBus]   wr_addr;
    wire                reg_we;
    //regfile信息
    wire    reg1_read;
    wire    reg2_read;
    wire[`RegAddrBus]   reg1_addr;
    wire[`RegAddrBus]   reg2_addr;
    wire[`RegBus]       reg1_data;
    wire[`RegBus]       reg2_data;

    //ex模块写回信息
    wire[`RegBus]       ex_wreg_data_id;
    wire[`RegAddrBus]   ex_wreg_addr_id;
    wire                ex_we_id;
    
    //mem模块写回信息
    wire[`RegBus]       mem_wreg_data_id;
    wire[`RegAddrBus]   mem_wreg_addr_id;
    wire                mem_we_id;  

    id id0(
        .rst(rst), 
        .pc_id(id_pc), .inst_id(id_inst),
        
        //ex写回信息
        .ex_wreg_data(ex_wreg_data_id),
        .ex_we(ex_we_id),
        .ex_wreg_addr(ex_wreg_addr_id),

	    //mem写回信息
        .mem_wreg_data(mem_wreg_data_id),
        .mem_we(mem_we_id),
        .mem_wreg_addr(mem_wreg_addr_id),

        /**与regfile交互**/
        //输出
        .reg1_re(reg1_read), .reg2_re(reg2_read), 
        .reg1_addr(reg1_addr), .reg2_addr(reg2_addr),
        //输入
        .reg1_data(reg1_data), .reg2_data(reg2_data),

        //送往id/ex模块的输出
        .aluop_o(aluop), .alusel_o(alusel), .reg1_o(reg1_ops), .reg2_o(reg2_ops),
        .wr_addr_o(wr_addr), .reg_we_o(reg_we)
    );
    
    //Regfile模块实例化
    
    //写回信号 输入（来自wb模块的输出）
    wire[`RegAddrBus] wb_reg_addr_regfile0;
    wire wb_reg_we_regfile0;
    wire[`RegBus]     wb_reg_data_regfile0;

    regfile regfile0(
        .clk(clk), .rst(rst),

        .we(wb_reg_we_regfile0),
        .waddr(wb_reg_addr_regfile0),
        .wdata(wb_reg_data_regfile0),

        .re1(reg1_read), .raddr1(reg1_addr), .rdata1(reg1_data),
        .re2(reg2_read), .raddr2(reg2_addr), .rdata2(reg2_data)
    );



    /**连接ID/EX模块并实例化**/
    wire[`AluOpBus]       aluop_ex;
    wire[`AluSelBus]      alusel_ex;
    wire[`RegBus]         reg1_ex;
    wire[`RegBus]         reg2_ex;
    wire[`RegAddrBus]     wr_addr_ex;
    wire                  reg_we_ex;
    id_ex id_ex0(
        .clk(clk), .rst(rst),

        .aluop_id(aluop), .alusel_id(alusel),
        .reg1_id(reg1_ops), .reg2_id(reg2_ops),
        .wr_addr_id(wr_addr), .we_reg_id(reg_we),

        .aluop_ex(aluop_ex), .alusel_ex(alusel_ex),
        .reg1_ex(reg1_ex), .reg2_ex(reg2_ex),
        .wr_addr_ex(wr_addr_ex), .reg_we_ex(reg_we_ex)
    );



    /**连接EX模块并实例化**/
    wire[`RegBus]     ex_wdata;
    wire[`RegAddrBus] ex_addr;
    wire              ex_we;
    ex ex0(
        .rst(rst),
        .reg1(reg1_ex), .reg2(reg2_ex),
        .aluop(aluop_ex), .alusel(alusel_ex),
        .wr_addr(wr_addr_ex), .reg_we(reg_we_ex),

        .wdata_o(ex_wdata), .waddr_o(ex_addr), .we_o(ex_we)
    );
    //写回id解码模块
    assign ex_wreg_data_id = ex_wdata;
    assign ex_wreg_addr_id = ex_addr;
    assign ex_we_id = ex_we;


     /**连接EX/MEM模块并实例化**/
    wire[`RegBus]     mem_wdata;
    wire[`RegAddrBus] mem_addr;
    wire              mem_we;
    ex_mem ex_mem0(
        .clk(clk), .rst(rst),

        .ex_wdata(ex_wdata), .ex_addr(ex_addr), .ex_we(ex_we),

        .mem_wdata(mem_wdata), .mem_addr(mem_addr), .mem_we(mem_we)
    );



    /**连接MEM模块并实例化**/
    wire[`RegBus]     mem_wdata_o;
    wire[`RegAddrBus] mem_addr_o;
    wire              mem_we_o;
    mem mem0(
        .rst(rst),

        .wdata(mem_wdata), .addr(mem_addr), .we(mem_we),

        .wdata_o(mem_wdata_o), .waddr_o(mem_addr_o), .we_o(mem_we_o)
    );
    //写回id解码模块
    assign mem_wreg_data_id = mem_wdata_o;
    assign mem_wreg_addr_id = mem_addr_o;
    assign mem_we_id = mem_we_o;



    /**连接MEM/WB模块并实例化**/
    wire[`RegAddrBus] wb_reg_addr;
    wire wb_reg_we;
    wire[`RegBus]     wb_reg_data;

    mem_wb mem_wb0(
        .clk(clk), .rst(rst),
        
        .mem_wdata(mem_wdata_o), .mem_we(mem_we_o), .mem_waddr(mem_addr_o),
        
        .wb_wdata(wb_reg_data), .wb_we(wb_reg_we), .wb_waddr(wb_reg_addr)
    );
     //连接回寄存器模块
     assign wb_reg_addr_regfile0 = wb_reg_addr;
     assign wb_reg_we_regfile0 = wb_reg_we;
     assign wb_reg_data_regfile0 = wb_reg_data;
endmodule