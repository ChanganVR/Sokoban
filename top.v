`timescale 1ns / 1ps

module top(clk, btn_in, hsync, vsync, vga_r, vga_g, vga_b, anode, segment);
input clk;
input [3:0]btn_in;
output hsync, vsync;
output wire [2:0] vga_r;
output wire [2:0] vga_g;
output wire [1:0] vga_b;
output wire [7:0] anode;
output wire [7:0] segment;

wire [3:0] btn_out;
pbdebounce m0(clk, btn_in[0], btn_out[0]);
pbdebounce m1(clk, btn_in[1], btn_out[1]);
pbdebounce m2(clk, btn_in[2], btn_out[2]);
pbdebounce m3(clk, btn_in[3], btn_out[3]);

//---------------------------------------//map initialization
parameter player = 2;//green
parameter wall = 1;//blue
parameter dot = 4;//red
parameter box = 3;//teal
parameter road = 0;//black

reg [2:0] dots [0:9][0:7];
initial
	dots = {
3'd1,3'd1,3'd1,3'd1,3'd1,3'd1,3'd1,3'd1,
3'd1,3'd1,3'd1,3'd2,3'd0,3'd1,3'd1,3'd1,
3'd1,3'd0,3'd3,3'd0,3'd4,3'd4,3'd1,3'd1,
3'd1,3'd0,3'd1,3'd0,3'd4,3'd4,3'd1,3'd1,
3'd1,3'd0,3'd1,3'd3,3'd1,3'd1,3'd1,3'd1,
3'd1,3'd0,3'd1,3'd0,3'd0,3'd0,3'd1,3'd1,
3'd1,3'd0,3'd0,3'd0,3'd3,3'd0,3'd1,3'd1,
3'd1,3'd1,3'd0,3'd3,3'd0,3'd0,3'd1,3'd1,
3'd1,3'd1,3'd0,3'd0,3'd1,3'd1,3'd1,3'd1,
3'd1,3'd1,3'd1,3'd1,3'd1,3'd1,3'd1,3'd1};

integer i;
integer j;
/*initial //initialization for simulation
begin
	i = 0;
	repeat(8)
	begin
		j = 0;
		repeat(10)
		begin
			dots[j][i] = 3'b000;
			j = j + 1;
		end
	end
	i = 0;
	repeat(10)
	begin
		dots[i][0] = 3'b001;
		i = i + 1;
	end
	i = 0;
	repeat(10)
	begin
		dots[i][6] = 3'b001;
		i = i + 1;
	end
	i = 0;
	repeat(10)
	begin
		dots[i][7] = 3'b001;
		i = i + 1;
	end
	i = 0;
	repeat(8)
	begin
		dots[0][i] = 3'b001;
		i = i + 1;
	end
	repeat(8)
	begin
		dots[9][i] = 3'b001;
		i = i + 1;
	end
	dots[1][1] = 3'b001;
	dots[1][3] = 3'b001;
	dots[3][2] = 3'b001;
	dots[4][2] = 3'b001;
	dots[5][2] = 3'b001;
	dots[1][5] = 3'b001;
	dots[1][3] = 3'b010;
	dots[7][1] = 3'b001;
	dots[8][1] = 3'b001;
	dots[8][4] = 3'b001;
	dots[8][5] = 3'b001;
	dots[3][4] = 3'b100;
	dots[3][5] = 3'b100;
	dots[4][4] = 3'b100;
	dots[4][5] = 3'b100;
	dots[2][2] = 3'b011;
	dots[4][3] = 3'b011;
	dots[7][3] = 3'b011;
	dots[6][4] = 3'b011;
end*/

integer playerX;
integer playerY;
initial
begin
playerX = 1;
playerY = 3;
end

//----------------------------------------//move module
wire ismove;
assign ismove = btn_out[3] && btn_out[2] && btn_out[1] && btn_out[0];

wire clk_1ms;
timer_1ms t1(clk, clk_1ms);

reg clk_2ms;
always @ (posedge clk_1ms) clk_2ms = ~clk_2ms;
reg clk_4ms;
always @ (posedge clk_2ms) clk_4ms = ~clk_4ms;
reg clk_8ms;
always @ (posedge clk_4ms) clk_8ms = ~clk_8ms;
reg clk_16ms;
always @ (posedge clk_8ms) clk_16ms = ~clk_16ms;
reg clk_32ms;
always @ (posedge clk_16ms) clk_32ms = ~clk_32ms;
reg clk_64ms;
always @ (posedge clk_32ms) clk_64ms = ~clk_64ms;
reg clk_128ms;
always @ (posedge clk_64ms) clk_128ms = ~clk_128ms;

always @ (posedge clk_128ms)begin
if(~ismove)begin
case(btn_out)
4'b1110: begin//up
	if(dots[playerX][playerY-1] == 3'b000 || dots[playerX][playerY-1] == 3'b100)begin
		dots[playerX][playerY] = 3'b000;
		playerY = playerY - 1;
		dots[playerX][playerY] = 3'b010;
		end
	else if(dots[playerX][playerY - 1] == 3'b011 && dots[playerX][playerY-2] == 3'b000)begin
		dots[playerX][playerY] = 3'b000;
		dots[playerX][playerY-2] = 3'b011;
		playerY = playerY - 1;
		dots[playerX][playerY] = 3'b010;
		end
	if(dots[2][4] == 3'b000) dots[2][4] = 3'b100;
	if(dots[2][5] == 3'b000) dots[2][5] = 3'b100;
	if(dots[3][4] == 3'b000) dots[3][4] = 3'b100;
	if(dots[3][5] == 3'b000) dots[3][5] = 3'b100;
end
4'b1011: begin//down
	if(dots[playerX][playerY+1] == 3'b000 || dots[playerX][playerY+1] == 3'b100)begin
		dots[playerX][playerY] = 3'b000;
		playerY = playerY + 1;
		dots[playerX][playerY] = 3'b010;
		end
	else if(dots[playerX][playerY + 1] == 3'b011 && (dots[playerX][playerY + 2] == 3'b000 || dots[playerX][playerY + 2] == 3'b100))begin
		dots[playerX][playerY] = 3'b000;
		dots[playerX][playerY+2] = 3'b011;
		playerY = playerY + 1;
		dots[playerX][playerY] = 3'b010;
		end
	if(dots[2][4] == 3'b000) dots[2][4] = 3'b100;
	if(dots[2][5] == 3'b000) dots[2][5] = 3'b100;
	if(dots[3][4] == 3'b000) dots[3][4] = 3'b100;
	if(dots[3][5] == 3'b000) dots[3][5] = 3'b100;
end
4'b1101: begin//left
	if(dots[playerX-1][playerY] == 3'b000 || dots[playerX-1][playerY] == 3'b100)begin
		dots[playerX][playerY] = 3'b000;
		playerX = playerX - 1;
		dots[playerX][playerY] = 3'b010;
		end
	else if(dots[playerX-1][playerY] == 3'b011 && (dots[playerX-2][playerY] == 3'b000 || dots[playerX-2][playerY] == 3'b100))begin
		dots[playerX][playerY] = 3'b000;
		dots[playerX-2][playerY] = 3'b011;
		playerX = playerX - 1;
		dots[playerX][playerY] = 3'b010;
		end
	if(dots[2][4] == 3'b000) dots[2][4] = 3'b100;
	if(dots[2][5] == 3'b000) dots[2][5] = 3'b100;
	if(dots[3][4] == 3'b000) dots[3][4] = 3'b100;
	if(dots[3][5] == 3'b000) dots[3][5] = 3'b100;
end
4'b0111:	begin//right
	if(dots[playerX+1][playerY] == 3'b000 || dots[playerX+1][playerY] == 3'b100)begin
		dots[playerX][playerY] = 3'b000;
		playerX = playerX + 1;
		dots[playerX][playerY] = 3'b010;
		end
	else if(dots[playerX+1][playerY] == 3'b011 && (dots[playerX+2][playerY] == 3'b000 || dots[playerX+2][playerY] == 3'b100))begin
		dots[playerX][playerY] = 3'b000;
		dots[playerX+2][playerY] = 3'b011;
		playerX = playerX + 1;
		dots[playerX][playerY] = 3'b010;
		end
	if(dots[2][4] == 3'b000) dots[2][4] = 3'b100;
	if(dots[2][5] == 3'b000) dots[2][5] = 3'b100;
	if(dots[3][4] == 3'b000) dots[3][4] = 3'b100;
	if(dots[3][5] == 3'b000) dots[3][5] = 3'b100;
end
endcase
end//ismove end
end//always end

assign success = (dots[2][4] == box) && (dots[2][5] == box) && (dots[3][4] == box) && (dots[3][5] == box);

display_success s1(clk, success, anode, segment);

//----------------------------------------//display module
reg [9:0] count_x;
reg [9:0] count_y;
reg clk_25m;

initial 
begin 
	count_x <= 10'd0;
	count_y <= 10'd0;
end

always @(posedge clk)
	clk_25m = ~clk_25m;

parameter HSO = 96;//horizontal sync offset
parameter HBP = 48;//horizontal back porch
parameter HAL = 640;//horizontal active line
parameter HFP = 16;//horizontal front porch

parameter VSO = 2;//vertical sync offset
parameter VBP = 33;//vertical back porch
parameter VAL = 480;//vertical active line
parameter VFP = 10;//vertical front porch

parameter length = 64;
parameter width = 60;
parameter height_sum_px = 38400;

always @(posedge clk_25m)
begin
	count_x = count_x + 1;
	if(count_x >= HSO + HBP + HAL + HFP)
	begin
		count_x = 0;
		count_y = count_y + 1;
		if (count_y >= VSO + VBP + VAL + VFP)
			count_y = 0;
	end
end

assign vsync = (count_y >= VSO) ? 1'b1 : 1'b0;
assign hsync = (count_x >= HSO) ? 1'b1 : 1'b0;

wire valid;
assign valid = count_x >= HSO + HBP && count_x <= HSO + HBP + HAL && count_y >= VSO + VBP && count_y <= VSO + VBP + VAL;

integer count_i;
integer count_j;

always @(posedge clk_25m)
begin
if(count_x < HSO && count_y < VSO)
begin
	count_i <= 0;
	count_j <= 0;
	i <= 0;
	j <= 0;
end
else if(valid) 
begin
	count_i <= count_i + 1;
	count_j <= count_j + 1;
	if(count_i == length)
	begin
		count_i <= 0;
		i <= i + 1;
		if(i == 10)
			i <= 0;
	end
	if(count_j == height_sum_px)
	begin
		count_j <= 0;
		j <= j + 1;
		if(j == 8)
			j <= 0;
	end
end
else if(!valid)
begin
	count_i <= 0;
	i <= 0;
end
end

reg [2:0] type;
reg[7:0] vga_rgb;

/*
RGB = 000  	黑色	RGB = 100	红色
	 = 001  	蓝色	    = 101	紫色
	 = 010	绿色		 = 110	黄色
	 = 011	青色		 = 111	白色
*/

always @(posedge clk_25m)
begin
	if(i <= 9 && j <= 7)
		type = dots[i][j];
	if(!valid) vga_rgb <= 8'b0;
	else
	begin
		case(type)
		road://road
		begin
			vga_rgb[7:5] <= 3'b0;
			vga_rgb[4:2] <= 3'b0;
			vga_rgb[1:0] <= 2'b0;
		end
		wall://wall
		begin
			vga_rgb[7:5] <= 3'b0;
			vga_rgb[4:2] <= 3'b0;
			vga_rgb[1:0] <= 2'b1;
		end
		player://player
		begin
			vga_rgb[7:5] <= 3'b0;
			vga_rgb[4:2] <= 3'b1;
			vga_rgb[1:0] <= 2'b0;
		end
		box://box
		begin
			vga_rgb[7:5] <= 3'b0;
			vga_rgb[4:2] <= 3'b1;
			vga_rgb[1:0] <= 2'b1;
		end
		dot://dot
		begin
			vga_rgb[7:5] <= 3'b1;
			vga_rgb[4:2] <= 3'b0;
			vga_rgb[1:0] <= 2'b0;
		end
		default: ;
		endcase
	end
end

assign vga_r = vga_rgb[7:5];
assign vga_g = vga_rgb[4:2];
assign vga_b = vga_rgb[1:0];

endmodule
