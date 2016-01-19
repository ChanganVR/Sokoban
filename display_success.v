module display_success(clk, success, digit_anode_w, segment_w);
	input wire clk;
	input wire success;
	output wire [7:0] digit_anode_w;
	output wire [7:0] segment_w;
	
	reg    [7:0]   digit_anode;//位选anode大一倍
	reg    [7:0]   segment;
	reg    [12:0]  cnt=0;
	reg    [3:0]   num;

	assign digit_anode_w = digit_anode;
	assign segment_w = segment;
	
	always @(posedge clk)begin
		case(cnt[12:10])//count在分配扫描位选的时候也要多一位
			3'b000:begin//S
				digit_anode <= 8'b11111110;
				if(success)
					segment <= 8'b10010010;
				else 
					segment <= 8'b11111111;
			end
			3'b001:begin//U
				digit_anode <= 8'b11111101;
				if(success)
					segment <= 8'b11000001;
				else 
					segment <= 8'b11111111;
			end
			3'b010:begin//C
				digit_anode <= 8'b11111011;
					if(success)
						segment <= 8'b11000110;
					else 
						segment <= 8'b11111111;
			end
			3'b011:begin//C
				digit_anode <= 8'b11110111;
					if(success)
						segment <= 8'b11000110;
					else 
						segment <= 8'b11111111;
			end
			3'b100:begin//E
				digit_anode <= 8'b11101111;
					if(success)
						segment <= 8'b10000110;
					else 
						segment <= 8'b11111111;
			end
			3'b101:begin//S
				digit_anode <= 8'b11011111;
					if(success)
						segment <= 8'b10010010;
					else 
						segment <= 8'b11111111;		
			end
			3'b110:begin//S
				digit_anode <= 8'b10111111;
					if(success)
						segment <= 8'b10010010;
					else 
						segment <= 8'b11111111;
			end
			3'b111:begin
				digit_anode <= 8'b01111111;
				segment <= 8'b11111111;
			end
		endcase	
	end

	always@(posedge clk) begin
			cnt<=cnt+1;
	end
endmodule
