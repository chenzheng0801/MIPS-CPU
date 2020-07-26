// Module:  id
// File:    id.v
// Author:  Chen Zheng
// Description:	解码模块
`include "define.v"
`define OpcodeIndex		31:26		//指令中op码
`define OpcodeBus		5:0			//op码位宽
`define Reg1Index		25:21		//指令中第一源寄存器位置
`define Reg2Index		20:16		//指令中第二源寄存器位置
`define Reg3Index		15:11		//指令中目标寄存器位置
`define ImmIndex		15:0		//立即数指令中位置
`define HalfZeroWord	16'h0000	//32位指令的半字
`define FunCodeIndex	5:0			//功能码索引
`define FunCodeBus		5:0			//功能码位宽


module id(
	input wire	rst,

	//ex写回信息
	input wire[`RegBus]		ex_wreg_data,
	input wire				ex_we,
	input wire[`RegAddrBus]	ex_wreg_addr,

	//mem写回信息
	input wire[`RegBus]		mem_wreg_data,
	input wire				mem_we,
	input wire[`RegAddrBus]	mem_wreg_addr,
	
	//指令信息输入
	input wire[`InstAddrBus]	pc_id,
	input wire[`InstBus]		inst_id,
	
	//与regfile交互，读取数据
	output reg				reg1_re,
	output reg				reg2_re,
	output reg[`RegAddrBus]	reg1_addr,
	output reg[`RegAddrBus]	reg2_addr,
	
	input wire[`RegBus]		reg1_data,
	input wire[`RegBus]		reg2_data,
	
	//送到执行阶段的信息
	output reg[`AluOpBus]	aluop_o,
	output reg[`AluSelBus]	alusel_o,
	output reg[`RegBus]		reg1_o,
	output reg[`RegBus]		reg2_o,
	output reg[`RegAddrBus]	wr_addr_o,		//要写入的寄存器地址
	output reg				reg_we_o		//写有效
);
	
	wire [`OpcodeBus] op_code	=  inst_id[`OpcodeIndex];
	wire [4:0]		  op1_code	=  inst_id[10:6];
	wire [4:0]		  op2_code  =  inst_id[20:16];
	wire [4:0]		  op3_code  =  inst_id[25:21];
	wire [`FunCodeBus]fun_code	=  inst_id[`FunCodeIndex];

	//regfile 
	wire [`RegAddrBus]	inst_reg1_addr = inst_id[`Reg1Index];
	wire [`RegAddrBus]	inst_reg2_addr = inst_id[`Reg2Index];
	wire [`RegAddrBus]	inst_reg3_addr = inst_id[`Reg3Index];
	
	reg instvalid;
	reg	[`RegBus]	imm;	//立即数
	
	
	always @(*)
	begin
		if(rst == `RstEnable)
		begin
			aluop_o = `EXE_NOP_OP;
			alusel_o = `EXE_RES_NOP;
			reg1_re = `ReadDisable;
			reg2_re = `ReadDisable;
			reg1_addr =	`NOPRegAddr;
			reg2_addr = `NOPRegAddr;
			wr_addr_o = `NOPRegAddr;
			reg_we_o = `WriteDisable;
			instvalid = `InstValid;				
			imm = `ZeroWord;			
		end
		else begin
			aluop_o = `EXE_NOP_OP;
			alusel_o = `EXE_RES_NOP;
			reg1_re = `ReadDisable;
			reg2_re = `ReadDisable;
			reg1_addr =	`NOPRegAddr;
			reg2_addr = `NOPRegAddr;
			wr_addr_o = `NOPRegAddr;
			reg_we_o = `WriteDisable;
			instvalid = `InstInValid;					
			imm = `ZeroWord;
			case(op_code)
				`OPCODE_SPECIAL: begin
					case (op1_code)
						5'b00000:begin
							case (fun_code)
								`FUNCODE_NOR:begin
									alusel_o = `EXE_RES_LOGIC;
									aluop_o = `EXE_NOR_OP;
									reg1_re = `ReadEnable;
									reg1_addr =	inst_reg1_addr;
									reg2_re = `ReadEnable;
									reg2_addr = inst_reg2_addr;
									wr_addr_o = inst_reg3_addr;
									reg_we_o = `WriteEnable;
									instvalid = `InstValid;
								end
								`FUNCODE_AND:begin
									alusel_o = `EXE_RES_LOGIC;
									aluop_o = `EXE_AND_OP;
									reg1_re = `ReadEnable;
									reg1_addr =	inst_reg1_addr;
									reg2_re = `ReadEnable;
									reg2_addr = inst_reg2_addr;
									wr_addr_o = inst_reg3_addr;
									reg_we_o = `WriteEnable;
									instvalid = `InstValid;
								end
								`FUNCODE_OR:begin
									alusel_o = `EXE_RES_LOGIC;
									aluop_o = `EXE_OR_OP;
									reg1_re = `ReadEnable;
									reg1_addr =	inst_reg1_addr;
									reg2_re = `ReadEnable;
									reg2_addr = inst_reg2_addr;
									wr_addr_o = inst_reg3_addr;
									reg_we_o = `WriteEnable;
									instvalid = `InstValid;
								end
								`FUNCODE_XOR:begin
									alusel_o = `EXE_RES_LOGIC;
									aluop_o = `EXE_XOR_OP;
									reg1_re = `ReadEnable;
									reg1_addr =	inst_reg1_addr;
									reg2_re = `ReadEnable;
									reg2_addr = inst_reg2_addr;
									wr_addr_o = inst_reg3_addr;
									reg_we_o = `WriteEnable;
									instvalid = `InstValid;
								end
								`FUNCODE_SLLV:begin
									alusel_o = `EXE_RES_SHIFT;
									aluop_o = `EXE_SLL_OP;
									reg1_re = `ReadEnable;
									reg1_addr =	inst_reg1_addr;
									reg2_re = `ReadEnable;
									reg2_addr = inst_reg2_addr;
									wr_addr_o = inst_reg3_addr;
									reg_we_o = `WriteEnable;
									instvalid = `InstValid;
								end
								`FUNCODE_SRAV:begin
									alusel_o = `EXE_RES_SHIFT;
									aluop_o = `EXE_SRA_OP;
									reg1_re = `ReadEnable;
									reg1_addr =	inst_reg1_addr;
									reg2_re = `ReadEnable;
									reg2_addr = inst_reg2_addr;
									wr_addr_o = inst_reg3_addr;
									reg_we_o = `WriteEnable;
									instvalid = `InstValid;
								end
								`FUNCODE_SRLV:begin
									alusel_o = `EXE_RES_SHIFT;
									aluop_o = `EXE_SRL_OP;
									reg1_re = `ReadEnable;
									reg1_addr =	inst_reg1_addr;
									reg2_re = `ReadEnable;
									reg2_addr = inst_reg2_addr;
									wr_addr_o = inst_reg3_addr;
									reg_we_o = `WriteEnable;
									instvalid = `InstValid;
								end
								`FUNCODE_SYNC:begin
									aluop_o = `EXE_NOP_OP;
									alusel_o = `EXE_RES_NOP;
									reg1_re = `ReadDisable;
									reg2_re = `ReadDisable;
									reg1_addr =	`NOPRegAddr;
									reg2_addr = `NOPRegAddr;
									wr_addr_o = `NOPRegAddr;
									reg_we_o = `WriteDisable;
									instvalid = `InstValid;				
									imm = `ZeroWord;
								end
								default: begin
								end
							endcase
						end
					endcase

					if(op3_code == 5'b00000)
					begin
						case (fun_code)
							`FUNCODE_SLL:begin
								alusel_o = `EXE_RES_SHIFT;
								aluop_o = `EXE_SLL_OP;
								reg1_re = `ReadDisable;
								reg1_addr =	`NOPRegAddr;
								reg2_re = `ReadEnable;
								reg2_addr = inst_reg2_addr;
								wr_addr_o = inst_reg3_addr;
								reg_we_o = `WriteEnable;
								instvalid = `InstValid;
								imm[4:0] = inst_id[10:6];
							end
							`FUNCODE_SRA:begin
								alusel_o = `EXE_RES_SHIFT;
								aluop_o = `EXE_SRA_OP;
								reg1_re = `ReadDisable;
								reg1_addr =	`NOPRegAddr;
								reg2_re = `ReadEnable;
								reg2_addr = inst_reg2_addr;
								wr_addr_o = inst_reg3_addr;
								reg_we_o = `WriteEnable;
								instvalid = `InstValid;
								imm[4:0] = inst_id[10:6];
							end
							`FUNCODE_SRL:begin
								alusel_o = `EXE_RES_SHIFT;
								aluop_o = `EXE_SRL_OP;
								reg1_re = `ReadDisable;
								reg1_addr =	`NOPRegAddr;
								reg2_re = `ReadEnable;
								reg2_addr = inst_reg2_addr;
								wr_addr_o = inst_reg3_addr;
								reg_we_o = `WriteEnable;
								instvalid = `InstValid;
								imm[4:0] = inst_id[10:6];				  
							end
							default: begin
							end
						endcase
					end
				end
				`OPCODE_LUI: begin
					aluop_o = `EXE_OR_OP;
					alusel_o = `EXE_RES_LOGIC;
					reg1_re = `ReadEnable;
					reg2_re = `ReadDisable;
					reg1_addr =	inst_reg1_addr;
					reg2_addr = inst_reg2_addr;
					wr_addr_o = inst_reg2_addr;		//注意指令中第二个位置就是写回的指令地址
					reg_we_o = `WriteEnable;
					instvalid = `InstValid;
					imm = {inst_id[`ImmIndex], `HalfZeroWord};
				end
				`OPCODE_ANDI: begin
					aluop_o = `EXE_AND_OP;
					alusel_o = `EXE_RES_LOGIC;
					reg1_re = `ReadEnable;
					reg2_re = `ReadDisable;
					reg1_addr =	inst_reg1_addr;
					reg2_addr = inst_reg2_addr;
					wr_addr_o = inst_reg2_addr;		//注意指令中第二个位置就是写回的指令地址
					reg_we_o = `WriteEnable;
					instvalid = `InstValid;
					imm = {`HalfZeroWord, inst_id[`ImmIndex]};
				end
				`OPCODE_XORI: begin
					aluop_o = `EXE_XOR_OP;
					alusel_o = `EXE_RES_LOGIC;
					reg1_re = `ReadEnable;
					reg2_re = `ReadDisable;
					reg1_addr =	inst_reg1_addr;
					reg2_addr = inst_reg2_addr;
					wr_addr_o = inst_reg2_addr;		//注意指令中第二个位置就是写回的指令地址
					reg_we_o = `WriteEnable;
					instvalid = `InstValid;
					imm = {`HalfZeroWord, inst_id[`ImmIndex]};
				end
				`OPCODE_ORI: begin
					aluop_o = `EXE_OR_OP;
					alusel_o = `EXE_RES_LOGIC;
					reg1_re = `ReadEnable;
					reg2_re = `ReadDisable;
					reg1_addr =	inst_reg1_addr;
					reg2_addr = inst_reg2_addr;
					wr_addr_o = inst_reg2_addr;		//注意ori指令中第二个位置就是写回的指令地址
					reg_we_o = `WriteEnable;
					instvalid = `InstValid;
					imm = {`HalfZeroWord, inst_id[`ImmIndex]};
				end
				`OPCODE_PREF: begin
					aluop_o = `EXE_NOP_OP;
					alusel_o = `EXE_RES_NOP;
					reg1_re = `ReadDisable;
					reg2_re = `ReadDisable;
					reg1_addr =	`NOPRegAddr;
					reg2_addr = `NOPRegAddr;
					wr_addr_o = `NOPRegAddr;
					reg_we_o = `WriteDisable;
					instvalid = `InstValid;				
					imm = `ZeroWord;
				end				
				default begin
				end
			endcase
		end		
	end
	/******************************************************
				第一个源操作数的确定
	**********************************************************/
	always @(*)
	begin
		if(rst == `RstEnable)
			reg1_o = `ZeroWord;
		else if(reg1_re == `ReadEnable && ex_we == `WriteEnable
				&& reg1_addr == ex_wreg_addr)
			reg1_o = ex_wreg_data;
		else if(reg1_re == `ReadEnable && mem_we == `WriteEnable
				&& reg1_addr == mem_wreg_addr)
			reg1_o = mem_wreg_data;
		else if(reg1_re == `ReadEnable)
			reg1_o = reg1_data;
		else if(reg1_re == `ReadDisable)
			reg1_o = imm;
		else 
			reg1_o = `ZeroWord;
	end
	/******************************************************
				第二个源操作数的确定
	**********************************************************/
	always @(*)
	begin
		if(rst == `RstEnable)
			reg2_o = `ZeroWord;
		else if(reg2_re == `ReadEnable && ex_we == `WriteEnable
				&& reg2_addr == ex_wreg_addr)
			reg2_o = ex_wreg_data;
		else if(reg2_re == `ReadEnable && mem_we == `WriteEnable
				&& reg2_addr == mem_wreg_addr)
			reg2_o = mem_wreg_data;
		else if(reg2_re == `ReadEnable)
			reg2_o = reg2_data;
		else if(reg2_re == `ReadDisable)
			reg2_o = imm;
		else 
			reg2_o = `ZeroWord;
	end
endmodule