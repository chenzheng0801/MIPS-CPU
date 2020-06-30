`include "define.v"

module pc_reg(
	input	wire rst,
	input	wire clk,

	output	reg[`InstAddrBus] pc,
	output	reg	ce
);
	always @(posedge clk) begin
		if(rst == `RstEnable)
			begin
				ce <= `ChipDisable;
			end
		else ce <= `ChipEnable;
	end

	always @(posedge clk) begin
		if(ce == `ChipDisable)
			begin
				pc <= `ZeroWord;
			end
		else pc <= pc + 4'h4;
	end
endmodule