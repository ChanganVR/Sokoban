`timescale 1ns / 1ps
module pbdebounce
	(input wire clk,
	input wire button,
	output wire pbreg);
	
	reg pbreg_r;
	reg [7:0] pbshift;
	wire clk_1ms;
	timer_1ms m0(clk, clk_1ms);
	always@(posedge clk_1ms) //button至少要持续8ms才能被当作一次有效的按键
	begin
		pbshift = pbshift<<1;//左移1位
		pbshift[0] = ~button;
		if (pbshift == 0)
			pbreg_r = 0;
		if (pbshift == 8'hFF)// pbshift八位全为1
			pbreg_r = 1;
	end
	assign pbreg = ~pbreg_r;
endmodule

