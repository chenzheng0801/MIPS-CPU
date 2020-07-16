//**************全局定义**********
`define RstEnable		1'b1			//复位信号有效
`define RstDisable		1'b0			//复位信号有效
`define ChipDisable		1'b0			//芯片禁止使用
`define ChipEnable		1'b1			//芯片启用
`define ZeroWord		32'h00000000	//32位数值零
`define WriteEnable		1'b1			//写有效
`define WriteDisable	1'b0			//写无效
`define ReadEnable		1'b1			//读有效
`define ReadDisable		1'b0			//读无效
`define AluOpBus		7:0				//译码阶段输出的aluop_o宽度
`define AluSelBus		2:0				//译码阶段输出的alusel_o宽度
`define InstValid		1'b1				//指令有效
`define InstInValid		1'b0				//指令无效

//**************具体指令有关的宏定义**********
//OpCode
`define OPCODE_ORI			6'b001101
`define OPCODE_SPECIAL      6'b000000
`define OPCODE_XORI         6'b001110
`define OPCODE_LUI          6'b001111
`define OPCODE_ANDI         6'b001100
`define OPCODE_PREF         6'b110011

//FunCode
`define FUNCODE_SLL         6'b000000
`define FUNCODE_SRA         6'b000011
`define FUNCODE_SRL         6'b000010
`define FUNCODE_SLLV    6'b000100
`define FUNCODE_SRLV    6'b000110
`define FUNCODE_SRAV    6'b000111
`define FUNCODE_AND     6'b100100
`define FUNCODE_OR      6'b100101
`define FUNCODE_XOR     6'b100110
`define FUNCODE_NOR     6'b100111
`define FUNCODE_SYNC    6'b001111

//AluOp
`define EXE_SLL_OP      8'b01111100
`define EXE_SRL_OP      8'b00000010
`define EXE_SRA_OP      8'b00000011

`define EXE_AND_OP      8'b00100100
`define EXE_OR_OP		8'b00100101
`define EXE_XOR_OP      8'b00100110
`define EXE_NOR_OP      8'b00100111
`define EXE_LUI_OP      8'b01011100 

`define EXE_NOP_OP		8'b00000000

//AluSel
`define EXE_RES_LOGIC   3'b001
`define EXE_RES_SHIFT   3'b010

`define EXE_RES_NOP		3'b000

//MEM
`define InstAddrBus 31:0			//ROM地址宽度
`define InstBus 31:0				//ROM指令大小
`define InstMemSize 131072			//ROM实际大小
`define InstMemSizeLog2 17			//ROM实际地址宽度

//*****************与通用寄存器Regfile有关的宏定义**************
`define RegAddrBus	4:0				//Regfile 模块的地址线宽度
`define RegBus		31:0			//Regfile 模块的数据宽度
`define RegNum		32				//Regfile 通用寄存器的数量
`define RegNumlog2	5				//Regfile 通用寄存器地址位数
`define NOPRegAddr	5'b00000		//Regfile 模块的零寄存器地址
