module HEX_score_count(clk, score1, score2, score3, score4, hex0out, hex1out, hex2out);
	output reg [6:0] hex0out, hex1out, hex2out;
	reg [3:0] hex0in = 0, hex1in = 0, hex2in = 0;
	reg hex0overflow = 0, hex1overflow = 0;
	input clk, score1, score2, score3, score4;
	
	always @(posedge clk)
		begin
		if (score1) begin
			if (hex0in == 9 && hex0overflow)
			hex0in <= 0;
			else 
			hex0in <= hex0in + 1;
			end
		else if (score2) begin
			if (hex0in == 9 && hex0overflow)
			hex0in <= 1;
			else if (hex0in == 8 && hex0overflow)
			hex0in <= 0;
			else 
			hex0in <= hex0in + 2;
			end
		else if (score3) begin
			if (hex0in == 9 && hex0overflow)
			hex0in <= 2;
			else if (hex0in == 8 && hex0overflow)
			hex0in <= 1;
			else if (hex0in == 7 && hex0overflow)
			hex0in <= 0;
			else 
			hex0in <= hex0in + 3;
			end
		else if (score4) begin
			if (hex0in == 9 && hex0overflow)
			hex0in <= 3;
			else if (hex0in == 8 && hex0overflow)
			hex0in <= 2;
			else if (hex0in == 7 && hex0overflow)
			hex0in <= 1;
			else if (hex0in == 6 && hex0overflow)
			hex0in <= 0;
			else 
			hex0in <= hex0in + 4;
			end
		end
		
	always @(posedge clk)
		begin 
		if (score1 && hex0in == 8) begin
			hex0overflow <= 1;
			end
		else if (score2 & (hex0in == 6 | hex0in == 7)) begin
			hex0overflow <= 1;
			end
		else if (score3 & (hex0in == 4 | hex0in == 5 | hex0in == 6))
			hex0overflow <= 1;
		else if (score4 & (hex0in == 2 | hex0in == 3 | hex0in == 4 | hex0in == 5))
			hex0overflow <= 1;
		else begin
			hex0overflow <= 0;
			end
		end
			
	always @(posedge clk)	
		begin
		if (score1 & hex0in == 8 & hex1in == 9) begin
			hex1overflow <= 1;
			end
		else if (score2 && ((hex0in == 6 & hex1in == 9) | (hex0in == 7 & hex1in == 9))) begin
			hex1overflow <= 1;
			end
		else if (score3 && (hex0in == 4 & hex1in == 9) | (hex0in == 5 & hex1in == 9) | (hex0in == 6 & hex1in == 9))
			hex1overflow <= 1;
		else if (score4 && (hex0in == 2 & hex1in == 9) | (hex0in == 3 & hex1in == 9) | (hex0in == 4 & hex1in == 9) | (hex0in == 5 & hex1in == 9))
			hex1overflow <= 1;
		else begin
			hex1overflow <= 0;
			end
		end
		
//	always @(posedge clk)	
//		begin
//		if (score1 & (hex2in == 9 & hex1in == 9 & hex0in == 8)) begin
//			hex2overflow <= 1;
//			end
//		else if (score2 && (hex2in == 9 & hex1in == 9 & hex0in == 6) | (hex2in == 9 & hex1in == 9 & hex0in == 7))
//			hex2overflow <= 1;
//		else if (score3 && (hex2in == 9 & hex1in == 9 & hex0in == 4) | (hex2in == 9 & hex1in == 9 & hex0in == 6) | (hex2in == 9 & hex1in == 9 & hex0in == 5))
//			hex2overflow <= 1;
//		else if (score4 && (hex2in == 9 & hex1in == 9 & hex0in == 2) | (hex2in == 9 & hex1in == 9 & hex0in == 3) | (hex2in == 9 & hex1in == 9 & hex0in == 4) | (hex2in == 9 & hex1in == 9 & hex0in == 5))
//			hex2overflow <= 1;
//		else begin
//			hex2overflow <= 0;
//			end
//		end
		
	always @(*)
	begin
			case (hex0in[3:0])
				4'b0000: hex0out[6:0] = 7'b1000000;
				4'b0001: hex0out[6:0] = 7'b1111001;
				4'b0010: hex0out[6:0] = 7'b0100100;
				4'b0011: hex0out[6:0] = 7'b0110000;
				4'b0100: hex0out[6:0] = 7'b0011001;
				4'b0101: hex0out[6:0] = 7'b0010010;
				4'b0110: hex0out[6:0] = 7'b0000010;
				4'b0111: hex0out[6:0] = 7'b1111000;
				4'b1000: hex0out[6:0] = 7'b0000000;
				4'b1001: hex0out[6:0] = 7'b0011000;
				4'b1010: hex0out[6:0] = 7'b1000000;
		  endcase
	end
	
	always @(posedge clk)
		begin
		if ((score1 | score2 | score3 | score4) & hex0overflow) begin
			hex1in <= hex1in + 1;
			end
		if (score1 & hex1in == 9 & hex0in == 9) begin
			hex1in <= 0;
			end
		else if (score2 & hex1in == 9 & (hex0in == 9 | hex0in == 8)) begin
			hex1in <= 0;
		end
		else if (score3 & hex1in == 9 & (hex0in == 9 | hex0in == 8 | hex0in == 7)) begin
			hex1in <= 0;
		end
		else if (score4 & hex1in == 9 & (hex0in == 9 | hex0in == 8 | hex0in == 7 | hex0in == 6)) begin
			hex1in <= 0;
		end
	end
		
	always@(*)
	begin
			case (hex1in[3:0])
				4'b0000: hex1out[6:0] = 7'b1000000;
				4'b0001: hex1out[6:0] = 7'b1111001;
				4'b0010: hex1out[6:0] = 7'b0100100;
				4'b0011: hex1out[6:0] = 7'b0110000;
				4'b0100: hex1out[6:0] = 7'b0011001;
				4'b0101: hex1out[6:0] = 7'b0010010;
				4'b0110: hex1out[6:0] = 7'b0000010;
				4'b0111: hex1out[6:0] = 7'b1111000;
				4'b1000: hex1out[6:0] = 7'b0000000;
				4'b1001: hex1out[6:0] = 7'b0011000;
				4'b1010: hex1out[6:0] = 7'b1000000;
		  endcase
	end
	
	always @(posedge clk)
		begin
		if ((score1 | score2 | score3 | score4) & hex1overflow) begin
			hex2in <= hex2in + 1;
			end
		if (hex2in >= 9) begin
			hex2in <= 0;
			end
		end
		
	always@(*)
	begin
		if ((score1 | score2 | score3 | score4))
			begin
			case (hex2in[3:0])
				4'b0000: hex2out[6:0] = 7'b1000000;
				4'b0001: hex2out[6:0] = 7'b1111001;
				4'b0010: hex2out[6:0] = 7'b0100100;
				4'b0011: hex2out[6:0] = 7'b0110000;
				4'b0100: hex2out[6:0] = 7'b0011001;
				4'b0101: hex2out[6:0] = 7'b0010010;
				4'b0110: hex2out[6:0] = 7'b0000010;
				4'b0111: hex2out[6:0] = 7'b1111000;
				4'b1000: hex2out[6:0] = 7'b0000000;
				4'b1001: hex2out[6:0] = 7'b0011000;
				4'b1010: hex2out[6:0] = 7'b1000000;
		  endcase
		  end
	end
		  
//	always @(posedge clk)
//		begin
//		if ((score1 | score2 | score3 | score4) & hex2overflow) begin
//			hex3in <= hex3in + 1;
//			end
//		if (hex3in >= 9) begin
//			hex3in <= 0;
//			end
//		end
//		
//	always@(*)
//	begin
//		if ((score1 | score2 | score3 | score4))
//			begin
//			case (hex3in[3:0])
//				4'b0000: hex3out[6:0] = 7'b1000000;
//				4'b0001: hex3out[6:0] = 7'b1111001;
//				4'b0010: hex3out[6:0] = 7'b0100100;
//				4'b0011: hex3out[6:0] = 7'b0110000;
//				4'b0100: hex3out[6:0] = 7'b0011001;
//				4'b0101: hex3out[6:0] = 7'b0010010;
//				4'b0110: hex3out[6:0] = 7'b0000010;
//				4'b0111: hex3out[6:0] = 7'b1111000;
//				4'b1000: hex3out[6:0] = 7'b0000000;
//				4'b1001: hex3out[6:0] = 7'b0011000;
//				4'b1010: hex3out[6:0] = 7'b1000000;
//		  endcase
//		  end
//  end
endmodule