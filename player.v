module player
 (
  CLOCK_50,      // On Board 50 MHz
  // Your inputs and outputs here
        KEY,
        SW,
  // The ports below are for the VGA output.  Do not change.
  VGA_CLK,         // VGA Clock
  VGA_HS,       // VGA H_SYNC
  VGA_VS,       // VGA V_SYNC
  VGA_BLANK_N,      // VGA BLANK
  VGA_SYNC_N,      // VGA SYNC
  VGA_R,         // VGA Red[9:0]
  VGA_G,        // VGA Green[9:0]
  VGA_B         // VGA Blue[9:0]
 );

 input   CLOCK_50;    // 50 MHz
 input   [9:0]   SW;
 input   [3:0]   KEY;
 
 // Declare your inputs and outputs here
 // Do not change the following outputs
 output   VGA_CLK;       // VGA Clock
 output   VGA_HS;     // VGA H_SYNC
 output   VGA_VS;     // VGA V_SYNC
 output   VGA_BLANK_N;    // VGA BLANK
 output   VGA_SYNC_N;    // VGA SYNC
 output [9:0] VGA_R;       // VGA Red[9:0]
 output [9:0] VGA_G;      // VGA Green[9:0]
 output [9:0] VGA_B;       // VGA Blue[9:0]
 
 wire resetn;
 assign resetn = KEY[0];
 assign left = ~KEY[2];
 assign right = ~KEY[1];
 assign fire = ~KEY[3];
 
 // Create the colour, x, y and writeEn wires that are inputs to the controller.
 wire [7:0] xb, transfer_x, e1x, e2x, e3x, e4x;
 wire [6:0] yb, transfer_y, e1y, e2y, e3y, e4y;
 wire [8:0] score;
 wire writeEn, e1_loaded, e2_loaded, e3_loaded, e4_loaded, e1_l_l, e2_l_l, e3_l_l, e4_l_l;
 wire p_l, p_l_l, rng_new_e, erasep, bmm, resetcounter, enemy_color_load, enemy_preload;
 wire load_colourp, load_colourb, readye, resetcp;
 wire readyp, movep, counterenablep;

 // Create an Instance of a VGA controller - there can be only one!
 // Define the number of colours as well as the initial background
 // image file (.MIF) for the controller.
 vga_adapter VGA(
   .resetn(resetn),
   .clock(CLOCK_50),
   .colour(colour),
   .x(x),
   .y(y),
   .plot(writeEn | writeEnb),
   /* Signals for the DAC to drive the monitor. */
   .VGA_R(VGA_R),
   .VGA_G(VGA_G),
   .VGA_B(VGA_B),
   .VGA_HS(VGA_HS),
   .VGA_VS(VGA_VS),
   .VGA_BLANK(VGA_BLANK_N),
   .VGA_SYNC(VGA_SYNC_N),
   .VGA_CLK(VGA_CLK));
  defparam VGA.RESOLUTION = "160x120";
  defparam VGA.MONOCHROME = "FALSE";
  defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
  defparam VGA.BACKGROUND_IMAGE = "black.mif";
   
 // Put your code here. Your code should produce signals x,y,colour and writeEn/plot
 // for the VGA controller, in addition to any other functionality your design may require.
   player_move D0(
  .X_dis(x),
  .Y_dis(y),
  .enemy1_x(e1x),
  .enemy2_x(e2x),
  .enemy3_x(e3x),
  .enemy4_x(e4x),
  .enemy1_y(e1y),
  .enemy2_y(e2y),
  .enemy3_y(e3y),
  .enemy4_y(e4y),
  .enemy1_loaded(e1_loaded),
  .enemy2_loaded(e2_loaded),
  .enemy3_loaded(e3_loaded),
  .enemy4_loaded(e4_loaded),
  .enemy1_location_load(e1_l_l),
  .enemy2_location_load(e2_l_l),
  .enemy3_location_load(e3_l_l),
  .enemy4_location_load(e4_l_l),
  .colour_out(colour),
  .clk(CLOCK_50),
  .enemy_ready(readye),
  .generate_new_enemy(rng_new_e),
  .bullet_make_move(bmm),
  .preload(p_l),
  .player_x(transfer_x),
  .player_y(transfer_y),
  .resetcounter(resetcounter),
  .enemy_color_load(enemy_color_load),
  .enemy_preload(enemy_preload),
  .bullet_x(xb),
  .bullet_y(yb),
  .player_ready(readyp),
  .player_colour_load(load_colourp),
  .bullet_color_load(load_colourb),
  .erase(erasep),
  .resetn(KEY[0]),
  .resetc(resetcp),
  .move(movep),
  .counterenable(counterenablep),
  .player_location_load(p_l_l)
  );
  
 
 player_FSM F0(
  .clk(CLOCK_50), 
  .player_x(transfer_x),
  .player_y(transfer_y),
  .bullet_x(xb),
  .bullet_y(yb),
  .enemy1_x(e1x),
  .enemy2_x(e2x),
  .enemy3_x(e3x),
  .enemy4_x(e4x),
  .enemy1_y(e1y),
  .enemy2_y(e2y),
  .enemy3_y(e3y),
  .enemy4_y(e4y),
  .enemy1_loaded(e1_loaded),
  .enemy2_loaded(e2_loaded),
  .enemy3_loaded(e3_loaded),
  .enemy4_loaded(e4_loaded),
  .enemy1_location_load(e1_l_l),
  .enemy2_location_load(e2_l_l),
  .enemy3_location_load(e3_l_l),
  .enemy4_location_load(e4_l_l),
  .generate_new_enemy(rng_new_e),
  .bullet_make_move(bmm),
  .preload(p_l),
  .enemy_ready(readye),
  .resetcounter(resetcounter),
  .enemy_color_load(enemy_color_load),
  .enemy_preload(enemy_preload),
  .graph(writeEn),
  .erase(erasep),
  .player_ready(readyp),
  .fire(fire),
  .player_colour_load(load_colourp),
  .bullet_color_load(load_colourb),
  .resetc(resetcp),
  .move(movep),
  .counterenable(counterenablep),
  .left(left),
  .right(right),
  .player_location_load(p_l_l),
  .score(score)
  );
    
endmodule

module player_part3(colour, x, y, writeEn, CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3);
 output [2:0] colour;
 output [7:0] x;
 output [6:0] y, HEX0, HEX1, HEX2, HEX3;
 output writeEn;
 input  CLOCK_50;    // 50 MHz
 input [2:0] KEY;
 wire [7:0] xb, transfer_x, e1x, e2x, e3x, e4x;
 wire [6:0] yb, transfer_y, e1y, e2y, e3y, e4y;
 wire [8:0] score;
 wire [3:0] lives;
 wire writeEn, e1_loaded, e2_loaded, e3_loaded, e4_loaded, e1_l_l, e2_l_l, e3_l_l, e4_l_l;
 wire p_l, p_l_l, rng_new_e, erasep, bmm, resetcounter, enemy_color_load, enemy_preload;
 wire load_colourp, load_colourb, readye, resetcp;
 wire readyp, movep, counterenablep;
 
  assign resetn = KEY[0];
 assign left = ~KEY[2];
 assign right = ~KEY[1];
 assign fire = ~KEY[3];
 
   player_move D0(
  .X_dis(x),
  .Y_dis(y),
  .enemy1_x(e1x),
  .enemy2_x(e2x),
  .enemy3_x(e3x),
  .enemy4_x(e4x),
  .enemy1_y(e1y),
  .enemy2_y(e2y),
  .enemy3_y(e3y),
  .enemy4_y(e4y),
  .enemy1_loaded(e1_loaded),
  .enemy2_loaded(e2_loaded),
  .enemy3_loaded(e3_loaded),
  .enemy4_loaded(e4_loaded),
  .enemy1_location_load(e1_l_l),
  .enemy2_location_load(e2_l_l),
  .enemy3_location_load(e3_l_l),
  .enemy4_location_load(e4_l_l),
  .colour_out(colour),
  .clk(CLOCK_50),
  .enemy_ready(readye),
  .generate_new_enemy(rng_new_e),
  .bullet_make_move(bmm),
  .preload(p_l),
  .player_x(transfer_x),
  .player_y(transfer_y),
  .resetcounter(resetcounter),
  .enemy_color_load(enemy_color_load),
  .enemy_preload(enemy_preload),
  .bullet_x(xb),
  .bullet_y(yb),
  .player_ready(readyp),
  .player_colour_load(load_colourp),
  .bullet_color_load(load_colourb),
  .erase(erasep),
  .resetn(KEY[0]),
  .resetc(resetcp),
  .move(movep),
  .counterenable(counterenablep),
  .player_location_load(p_l_l)
  );
  
 
 player_FSM F0(
  .clk(CLOCK_50), 
  .player_x(transfer_x),
  .player_y(transfer_y),
  .bullet_x(xb),
  .bullet_y(yb),
  .enemy1_x(e1x),
  .enemy2_x(e2x),
  .enemy3_x(e3x),
  .enemy4_x(e4x),
  .enemy1_y(e1y),
  .enemy2_y(e2y),
  .enemy3_y(e3y),
  .enemy4_y(e4y),
  .enemy1_loaded(e1_loaded),
  .enemy2_loaded(e2_loaded),
  .enemy3_loaded(e3_loaded),
  .enemy4_loaded(e4_loaded),
  .enemy1_location_load(e1_l_l),
  .enemy2_location_load(e2_l_l),
  .enemy3_location_load(e3_l_l),
  .enemy4_location_load(e4_l_l),
  .generate_new_enemy(rng_new_e),
  .bullet_make_move(bmm),
  .preload(p_l),
  .enemy_ready(readye),
  .resetcounter(resetcounter),
  .enemy_color_load(enemy_color_load),
  .enemy_preload(enemy_preload),
  .graph(writeEn),
  .erase(erasep),
  .player_ready(readyp),
  .fire(fire),
  .player_colour_load(load_colourp),
  .bullet_color_load(load_colourb),
  .resetc(resetcp),
  .move(movep),
  .counterenable(counterenablep),
  .left(left),
  .right(right),
  .player_location_load(p_l_l),
  .score(score),
  .lives(lives)
  );
  
  
  seq_decoder sd4(lives, HEX4);
  
  
endmodule 

module player_move(X_dis, Y_dis, colour_out, clk, enemy_ready, generate_new_enemy, bullet_make_move, player_x, bullet_x, player_y, enemy1_x, enemy2_x, enemy3_x, enemy4_x, enemy1_location_load, enemy2_location_load, enemy3_location_load, enemy4_location_load, enemy1_loaded, enemy2_loaded, enemy3_loaded, enemy4_loaded, resetcounter, enemy1_y, enemy2_y, enemy3_y, enemy4_y, enemy_color_load, bullet_y, enemy_preload, preload, resetn, erase, player_location_load, player_ready, resetc, player_colour_load, bullet_color_load, move, counterenable);
 output  [7:0] X_dis; 
 output  [6:0] Y_dis;
 output reg move = 0;
 output reg player_ready, enemy_ready, generate_new_enemy = 0;
 output reg [2:0] colour_out;
 input [7:0] player_x, bullet_x, enemy1_x, enemy2_x, enemy3_x, enemy4_x;
 input [6:0] player_y, bullet_y, enemy1_y, enemy2_y, enemy3_y, enemy4_y;
 input bullet_make_move, enemy1_location_load, enemy2_location_load, enemy3_location_load, enemy4_location_load, enemy1_loaded, enemy2_loaded, enemy3_loaded, enemy4_loaded;
 reg [26:0] dcounter;
 reg [7:0] trans_x = 0;
 reg [6:0] trans_y = 0;
 reg [3:0] framecounter, generate_enemy_counter;
 reg frame_enable;
 input resetn, clk, enemy_preload, preload, erase, resetc, counterenable, player_location_load, resetcounter;
 reg [3:0] counter = 4'b0;
 reg [5:0] enemy_draw_counter = 6'b0;
 input player_colour_load, bullet_color_load, enemy_color_load;
 reg [5:0] enemycounter;
 reg right_dir, up_dir;
 reg advance_x, advance_y;
 
 assign X_dis = trans_x;
 assign Y_dis = trans_y;
 
always @(posedge clk) begin
	if (player_location_load) begin
	  trans_x = player_x + counter[1:0];
	  trans_y = player_y + counter[3:2];
	end

	else if (bullet_make_move) begin
	  trans_x = bullet_x;
	  trans_y = bullet_y;
	end 
	
	else if (enemy1_location_load && enemy1_loaded) begin
	  trans_x = enemy1_x + enemy_draw_counter[2:0];
	  trans_y = enemy1_y + enemy_draw_counter[5:3];
	end
	
	else if (enemy2_location_load && enemy2_loaded) begin
	  trans_x = enemy2_x + enemy_draw_counter[2:0];
	  trans_y = enemy2_y + enemy_draw_counter[5:3];
	end
	
	else if (enemy3_location_load && enemy3_loaded) begin
	  trans_x = enemy3_x + enemy_draw_counter[2:0];
	  trans_y = enemy3_y + enemy_draw_counter[5:3];
	end
	
	else if (enemy4_location_load && enemy4_loaded) begin
	  trans_x = enemy4_x + enemy_draw_counter[2:0];
	  trans_y = enemy4_y + enemy_draw_counter[5:3];
	end
end 
	 
 always @ (posedge clk) begin
   if (!resetn) 
		begin
			 colour_out <= 3'b0;
		end
   if (player_colour_load) 
		begin
			colour_out <= 3'b010;
		end
	if (bullet_color_load) 
		begin
			colour_out <= 3'b111;
		end
	if (enemy_color_load) 
		begin
			colour_out <= 3'b100;
		end
	if (erase) 
		begin
			colour_out <= 3'b0;
		end
 end

 always @(posedge clk)
	begin
		if (!resetc)
			begin
			   framecounter = 10;
				move = 0;
		   end
		if (counterenable) begin
				if (frame_enable) 
				begin
					if (framecounter != 0) 
					begin
						framecounter = framecounter - 1;
						move = 0;
					end
					else 
					begin
						framecounter = 10;
						move = 1;
					end 
				end
			end
	end
	
always @(posedge clk) //833333
	begin
		if (!resetn) 
			dcounter <= 10;
		else begin
			if (dcounter != 0) begin 
				dcounter <= dcounter - 1;
				frame_enable <= 0;
			end 
			else begin
				dcounter <= 10;
				frame_enable <= 1;
			end
		end
	end
	
always @(posedge clk) //10
	begin
		if (!resetn) 
			generate_enemy_counter <= 5;
		else begin
			if (move) begin
				if (generate_enemy_counter != 0) begin 
					generate_enemy_counter <= generate_enemy_counter - 1;
					generate_new_enemy <= 0;
				end 
				else begin
					generate_enemy_counter <= 5;
					generate_new_enemy <= 1;
				end
			end
		end
	end
	
 always @(posedge clk) begin
	if (counter == 4'b1111)
		player_ready <= 1;
	else 
		player_ready <= 0;
end

 always @(posedge clk) begin
	if (enemy_draw_counter == 6'b111111)
		enemy_ready <= 1;
	else 
		enemy_ready <= 0;
end

 always @(posedge clk) begin
	 if (!resetn | resetcounter) begin
	  enemy_draw_counter <= 6'b0;
	 end
	else if (enemy_preload) begin
		if (enemy_draw_counter != 6'b111111)
		  begin
		  enemy_draw_counter <= enemy_draw_counter+1;
		  end
		 else
		  begin
		  enemy_draw_counter <= 0;
		  end
		end
end

 always @ (posedge clk) begin
 if (!resetn | resetcounter) begin
  counter <= 4'b0;
 end
 else if (preload) begin
   if (counter != 4'b1111)
     begin
     counter <= counter+1;
     end
    else
     begin
     counter<= 0;
     end
   end
 end
  
endmodule


module player_FSM(clk, player_x, bullet_y, bullet_x, player_y, enemy1_loaded, enemy2_loaded, enemy1_location_load, enemy2_location_load, enemy3_location_load, enemy4_location_load, enemy3_loaded, enemy4_loaded, enemy1_x, enemy2_x, enemy3_x, enemy4_x, enemy1_y, enemy2_y, enemy3_y, enemy4_y, generate_new_enemy, enemy_ready, left, right, preload, graph, all_square_drawn, resetcounter, enemy_preload, player_location_load, erase, player_colour_load, bullet_color_load, enemy_color_load, bullet_make_move, counterenable, resetc, move, fire, player_ready, score);
 input clk, fire;
 input move, left, right, player_ready, all_square_drawn, generate_new_enemy, enemy_ready;
 output reg preload, graph, erase, player_colour_load, bullet_color_load, enemy_color_load, resetc, counterenable, player_location_load, bullet_make_move, resetcounter, enemy_preload;
 reg [6:0] current_state, next_state;
 output reg [7:0] player_x, bullet_x, enemy1_x, enemy2_x, enemy3_x, enemy4_x;
 output reg [6:0] player_y, bullet_y, enemy1_y, enemy2_y, enemy3_y, enemy4_y;
 output reg enemy1_loaded = 0, enemy2_loaded = 0, enemy3_loaded = 0, enemy4_loaded = 0;
 output reg enemy1_location_load, enemy2_location_load, enemy3_location_load, enemy4_location_load;
 output reg [8:0] score = 0;
 output reg [3:0] lives = 4'b0011;
 reg resetn = 1, resetdelay, x_pos_load, x_enemy_pos_load, y_pos_load, enable_rng_enemy = 0;
 reg enable, fired = 0, enemy_on_screen = 0;
 reg load_seed;
 wire [15 : 0] enemy_x_coordinate;
 reg [31:0] seed;
 reg enemy_right = 1;
 
 
 localparam [6:0]
  COUNTER_RESET = 0,
  WAIT_PLAYER_LOCATION_LOAD = 1,
  DRAW_PLAYER = 2,
  GENERATE_ENEMY_WAIT = 3,
  GENERATE_ENEMY = 4,
  DRAW_PLAYER_WAIT = 5,
  SET_BULLET_COLOUR = 6,
  WAIT_BULLET_DRAW_LOAD = 7,
  DRAW_BULLET = 8,
  SET_ENEMY_COLOUR = 9,
  WAIT_ENEMY1_LOCATION_LOAD = 10,
  DRAW_ENEMY1 = 11,
  DRAW_ENEMY1_WAIT = 12,
  WAIT_ENEMY2_LOCATION_LOAD = 13,
  DRAW_ENEMY2 = 14,
  DRAW_ENEMY2_WAIT = 15,
  WAIT_ENEMY3_LOCATION_LOAD = 16,
  DRAW_ENEMY3 = 17,
  DRAW_ENEMY3_WAIT = 18,
  WAIT_ENEMY4_LOCATION_LOAD = 19,
  DRAW_ENEMY4 = 20,
  DRAW_ENEMY4_WAIT = 21,
  DRAW_WAIT = 22,
  ERASE_PLAYER = 23,
  ERASE_PLAYER_WAIT = 24,
  WAIT_BULLET_ERASE_LOAD = 25,
  ERASE_BULLET = 26,
  CHECK_IF_ENEMY_ON_SCREEN = 27,
  WAIT_ERASE_ENEMY1_LOAD = 28,
  ERASE_ENEMY1 = 29,
  ERASE_ENEMY1_WAIT = 30,
  WAIT_ERASE_ENEMY2_LOAD = 31,
  ERASE_ENEMY2 = 32,
  ERASE_ENEMY2_WAIT = 33,
  WAIT_ERASE_ENEMY3_LOAD = 34,
  ERASE_ENEMY3 = 35,
  ERASE_ENEMY3_WAIT = 36,
  WAIT_ERASE_ENEMY4_LOAD = 37,
  ERASE_ENEMY4 = 38,
  ERASE_ENEMY4_WAIT = 39,
  UPDATE = 40
  ;
  
  rng rng1(
	.clk(clk),
	.reset(enable_rng_enemy),
	.loadseed_i(load_seed),
	.seed_i(seed[31:0]),
	.number_o(enemy_x_coordinate[15:0]));
	
	always @(posedge clk)
	begin
		if (y_pos_load) 
			begin
				enemy1_y <= 7'b0000000;
				enemy2_y <= 7'b0000000;
				enemy3_y <= 7'b0000000;
				enemy4_y <= 7'b0000000;
			end
			
	   if (x_enemy_pos_load && enemy1_loaded == 0) begin
			enemy1_x <= enemy_x_coordinate[6:0] + enemy_x_coordinate[10:7] + enemy_x_coordinate[13:11];
			enemy1_loaded <= 1;
			end
		else if (x_enemy_pos_load && enemy2_loaded == 0) begin
			enemy2_x <= enemy_x_coordinate[6:0] + enemy_x_coordinate[10:7] + enemy_x_coordinate[13:11];
			enemy2_loaded <= 1;
			end
		else if (x_enemy_pos_load && enemy3_loaded == 0) begin
			enemy3_x <= enemy_x_coordinate[6:0] + enemy_x_coordinate[10:7] + enemy_x_coordinate[13:11];
			enemy3_loaded <= 1;
			end
		else if (x_enemy_pos_load && enemy4_loaded == 0) begin
			enemy4_x <= enemy_x_coordinate[6:0] + enemy_x_coordinate[10:7] + enemy_x_coordinate[13:11];
			enemy4_loaded <= 1;
			end
		if ( enemy1_loaded == 1)
		begin
		   if (enable)
				begin
				enemy1_y <= enemy1_y + 1;
				if (enemy_right)
					enemy1_x <= enemy1_x + 1;
				else
					enemy1_x <= enemy1_x - 1;
				end
		end
		if ( enemy2_loaded == 1)
		begin
		   if (enable)
				begin
				enemy2_y <= enemy2_y + 1;
				if (enemy_right)
					enemy2_x <= enemy2_x + 1;
				else
					enemy2_x <= enemy2_x - 1;
				end
		end
		if ( enemy3_loaded == 1)
		begin
		   if (enable)
				begin
				enemy3_y <= enemy3_y + 1;
				if (enemy_right)
					enemy3_x <= enemy3_x + 1;
				else
					enemy3_x <= enemy3_x - 1;
				end
		end
		if ( enemy4_loaded == 1)
		begin
		   if (enable)
				begin
				enemy4_y <= enemy4_y + 1;
				if (enemy_right)
					enemy4_x <= enemy4_x + 1;
				else
					enemy4_x <= enemy4_x - 1;
				end
		end
	end

	
	always @(posedge clk)
	begin
	  if (x_pos_load)
		   begin
			player_x <= 8'b01110000;
			end
		else
			begin
				if (right && player_x + 4 != 160 && enable)
					player_x <= player_x + 1;
				else if (left && player_x != 0 && enable)
					player_x <= player_x - 1;
			end
	end
	
	always @(posedge clk)
	begin
	   if (y_pos_load)
			begin
		   player_y <= 7'b1110011;
			bullet_y <= player_y;
			end
		else
			begin
				if (bullet_y <= 1)
				   fired <= 0;
				if (fire & !fired) 
					begin
						bullet_x <= player_x + 2;
						bullet_y <= player_y - 2;
						fired <= 1;
					end
				if (fired && enable)
					bullet_y <= bullet_y - 2;
			end

	end
	
	 always @(posedge clk)
  begin
	  if (enemy1_x == 0) 
			begin 
				enemy_right = 1;
			end
		else if (enemy1_x + 8 == 160)
			begin 
				enemy_right = 0;
			end
		if (enemy2_x == 0) 
			begin 
				enemy_right = 1;
			end
		else if (enemy2_x + 8 == 160)
			begin 
				enemy_right = 0;
			end
		if (enemy3_x == 0) 
			begin 
				enemy_right = 1;
			end
		else if (enemy3_x + 8 == 160)
			begin 
				enemy_right = 0;
			end
		if (enemy4_x == 0) 
			begin 
				enemy_right = 1;
			end
		else if (enemy4_x + 8 == 160)
			begin 
				enemy_right = 0;
			end
		if (enemy1_y + 8 == 120)
			begin 
				enemy1_loaded = 0;
				score <= score + 1;
				lives <= lives - 1;
			end
		if (enemy2_y + 8 == 120)
			begin 
				enemy2_loaded = 0;
				score <= score + 1;
				lives <= lives - 1;
			end
		if (enemy3_y + 8 == 120)
			begin 
				enemy3_loaded = 0;
				score <= score + 1;
				lives <= lives - 1;
			end
		if (enemy4_y + 8 == 120)
			begin 
				enemy4_loaded = 0;
				score <= score + 1;
				lives <= lives - 1;
			end
		if (enemy1_x < bullet_x && bullet_x - enemy1_x <= 8 && enemy1_y < bullet_y && bullet_y - enemy1_y <= 8)
		begin
		   fired <= 0;
			enemy1_loaded <= 0;
			score <= score + 1;
      end
		else if (enemy2_x < bullet_x && bullet_x - enemy2_x <= 8 && enemy2_y < bullet_y && bullet_y - enemy2_y <= 8)
		begin
		   fired <= 0;
			enemy2_loaded <= 0;
			score <= score + 2;
      end
		else if (enemy3_x < bullet_x && bullet_x - enemy3_x <= 8 && enemy3_y < bullet_y && bullet_y - enemy3_y <= 8)
		begin
		   fired <= 0;
			enemy3_loaded <= 0;
			score <= score + 3;
      end
		else if (enemy4_x < bullet_x && bullet_x - enemy4_x <= 8 && enemy4_y < bullet_y && bullet_y - enemy4_y <= 8)
		begin
		   fired <= 0;
			enemy4_loaded <= 0;
			score <= score + 4;
      end
		
		if (enemy1_x < player_x && player_x - enemy1_x <= 8)
		   begin
			   if (enemy1_y < player_y && player_y - enemy1_y <= 8)
				   begin
					   enemy1_loaded <= 0;
			         score <= score + 1;
					end
				else if (player_y < enemy1_y && enemy1_y - player_y <= 8)
				   begin
					   enemy1_loaded <= 0;
			         score <= score + 1;
					end
			end
		else if (player_x < enemy1_x && enemy1_x - player_x <= 8)
		   begin
			   if (enemy1_y < player_y && player_y - enemy1_y <= 8)
				   begin
					   enemy1_loaded <= 0;
			         score <= score + 1;
					end
				else if (player_y < enemy1_y && enemy1_y - player_y <= 8)
				   begin
					   enemy1_loaded <= 0;
			         score <= score + 1;
					end
			end
		if (enemy2_x < player_x && player_x - enemy2_x <= 8)
		   begin
			   if (enemy2_y < player_y && player_y - enemy2_y <= 8)
				   begin
					   enemy2_loaded <= 0;
			         score <= score + 2;
					end
				else if (player_y < enemy2_y && enemy2_y - player_y <= 8)
				   begin
					   enemy2_loaded <= 0;
			         score <= score + 2;
					end
			end
		else if (player_x < enemy2_x && enemy2_x - player_x <= 8)
		   begin
			   if (enemy2_y < player_y && player_y - enemy2_y <= 8)
				   begin
					   enemy2_loaded <= 0;
			         score <= score + 2;
					end
				else if (player_y < enemy2_y && enemy2_y - player_y <= 8)
				   begin
					   enemy2_loaded <= 0;
			         score <= score + 2;
					end
			end
		if (enemy3_x < player_x && player_x - enemy3_x <= 8)
		   begin
			   if (enemy3_y < player_y && player_y - enemy3_y <= 8)
				   begin
					   enemy3_loaded <= 0;
			         score <= score + 3;
					end
				else if (player_y < enemy3_y && enemy3_y - player_y <= 8)
				   begin
					   enemy3_loaded <= 0;
			         score <= score + 3;
					end
			end
		else if (player_x < enemy3_x && enemy3_x - player_x <= 8)
		   begin
			   if (enemy3_y < player_y && player_y - enemy3_y <= 8)
				   begin
					   enemy3_loaded <= 0;
			         score <= score + 3;
					end
				else if (player_y < enemy3_y && enemy3_y - player_y <= 8)
				   begin
					   enemy3_loaded <= 0;
			         score <= score + 3;
					end
			end
		if (enemy4_x < player_x && player_x - enemy4_x <= 8)
		   begin
			   if (enemy4_y < player_y && player_y - enemy4_y <= 8)
				   begin
					   enemy4_loaded <= 0;
			         score <= score + 4;
					end
				else if (player_y < enemy4_y && enemy4_y - player_y <= 8)
				   begin
					   enemy4_loaded <= 0;
			         score <= score + 4;
					end
			end
		else if (player_x < enemy4_x && enemy4_x - player_x <= 8)
		   begin
			   if (enemy4_y < player_y && player_y - enemy4_y <= 8)
				   begin
					   enemy4_loaded <= 0;
			         score <= score + 4;
					end
				else if (player_y < enemy4_y && enemy4_y - player_y <= 8)
				   begin
					   enemy4_loaded <= 0;
			         score <= score + 4;
					end
			end
  end
  
 always @(*)
  begin
   case (current_state)
	 COUNTER_RESET : next_state = WAIT_PLAYER_LOCATION_LOAD;
	 WAIT_PLAYER_LOCATION_LOAD : next_state = DRAW_PLAYER;
    DRAW_PLAYER: next_state = player_ready ? GENERATE_ENEMY_WAIT : DRAW_PLAYER; 
	 GENERATE_ENEMY_WAIT: next_state = generate_new_enemy ? GENERATE_ENEMY : DRAW_PLAYER_WAIT;
	 GENERATE_ENEMY: next_state = DRAW_PLAYER_WAIT;
	 DRAW_PLAYER_WAIT: next_state = fired ? SET_BULLET_COLOUR : SET_ENEMY_COLOUR;
	 SET_BULLET_COLOUR: next_state = WAIT_BULLET_DRAW_LOAD;
	 WAIT_BULLET_DRAW_LOAD: next_state = DRAW_BULLET;
	 DRAW_BULLET: next_state = SET_ENEMY_COLOUR;
	 SET_ENEMY_COLOUR: next_state = enemy1_loaded ? WAIT_ENEMY1_LOCATION_LOAD : DRAW_ENEMY1_WAIT;
	 WAIT_ENEMY1_LOCATION_LOAD: next_state = DRAW_ENEMY1;
	 DRAW_ENEMY1: next_state = enemy_ready ? DRAW_ENEMY1_WAIT : DRAW_ENEMY1;
	 DRAW_ENEMY1_WAIT: next_state = enemy2_loaded ? WAIT_ENEMY2_LOCATION_LOAD : DRAW_ENEMY2_WAIT;
	 WAIT_ENEMY2_LOCATION_LOAD: next_state = DRAW_ENEMY2;
	 DRAW_ENEMY2: next_state = enemy_ready ? DRAW_ENEMY2_WAIT : DRAW_ENEMY2;
	 DRAW_ENEMY2_WAIT: next_state = enemy3_loaded ? WAIT_ENEMY3_LOCATION_LOAD : DRAW_ENEMY3_WAIT;
	 WAIT_ENEMY3_LOCATION_LOAD: next_state = DRAW_ENEMY3;
	 DRAW_ENEMY3: next_state = enemy_ready ? DRAW_ENEMY3_WAIT : DRAW_ENEMY3;
	 DRAW_ENEMY3_WAIT: next_state = enemy4_loaded ? WAIT_ENEMY4_LOCATION_LOAD : DRAW_ENEMY4_WAIT;
	 WAIT_ENEMY4_LOCATION_LOAD: next_state = DRAW_ENEMY4;
	 DRAW_ENEMY4: next_state = enemy_ready ? DRAW_ENEMY4_WAIT : DRAW_ENEMY4;
	 DRAW_ENEMY4_WAIT: next_state = DRAW_WAIT;
	 DRAW_WAIT: next_state = move ? ERASE_PLAYER : DRAW_WAIT;
	 ERASE_PLAYER: next_state = player_ready ? ERASE_PLAYER_WAIT : ERASE_PLAYER;
	 ERASE_PLAYER_WAIT: next_state = fired ? WAIT_BULLET_ERASE_LOAD : CHECK_IF_ENEMY_ON_SCREEN;
	 WAIT_BULLET_ERASE_LOAD: next_state = ERASE_BULLET;
	 ERASE_BULLET: next_state = CHECK_IF_ENEMY_ON_SCREEN;
	 CHECK_IF_ENEMY_ON_SCREEN: next_state = enemy1_loaded ? WAIT_ERASE_ENEMY1_LOAD: ERASE_ENEMY1_WAIT;
	 WAIT_ERASE_ENEMY1_LOAD: next_state = ERASE_ENEMY1;
	 ERASE_ENEMY1: next_state = enemy_ready ? ERASE_ENEMY1_WAIT : ERASE_ENEMY1;
	 ERASE_ENEMY1_WAIT: next_state = enemy2_loaded ? WAIT_ERASE_ENEMY2_LOAD : ERASE_ENEMY2_WAIT;
	 WAIT_ERASE_ENEMY2_LOAD: next_state = ERASE_ENEMY2;
	 ERASE_ENEMY2: next_state = enemy_ready ? ERASE_ENEMY2_WAIT : ERASE_ENEMY2;
	 ERASE_ENEMY2_WAIT: next_state = enemy3_loaded ? WAIT_ERASE_ENEMY3_LOAD : ERASE_ENEMY3_WAIT;
	 WAIT_ERASE_ENEMY3_LOAD: next_state = ERASE_ENEMY3;
	 ERASE_ENEMY3: next_state = enemy_ready ? ERASE_ENEMY3_WAIT : ERASE_ENEMY3;
	 ERASE_ENEMY3_WAIT: next_state = enemy4_loaded ? WAIT_ERASE_ENEMY4_LOAD : UPDATE;
	 WAIT_ERASE_ENEMY4_LOAD: next_state = ERASE_ENEMY4;
	 ERASE_ENEMY4: next_state = enemy_ready ? ERASE_ENEMY4_WAIT : ERASE_ENEMY4;
	 ERASE_ENEMY4_WAIT: next_state = UPDATE;
	 UPDATE: next_state = WAIT_PLAYER_LOCATION_LOAD;
    default : next_state = COUNTER_RESET;
   endcase
  end
 
	
 always @(*)
  begin
	resetc = 1;
   x_pos_load = 0;
	x_enemy_pos_load = 0;
   y_pos_load = 0;
   preload = 0;
   graph = 0;
	erase = 0;
	resetdelay = 1;
	enable = 0;
	player_colour_load = 0;
	player_location_load = 0;
	enemy1_location_load = 0;
	enemy2_location_load = 0;
	enemy3_location_load = 0;
	enemy4_location_load = 0;
	bullet_color_load = 0;
	counterenable = 0;
	enable_rng_enemy = 1;
	enemy_preload = 0;
	enemy_color_load = 0;
	bullet_make_move = 0;
	resetcounter = 0;
		
	
   case (current_state)
	COUNTER_RESET: 
		begin
			resetc = 0;
			//fired = 0;
			x_pos_load = 1;
			y_pos_load = 1;
			player_colour_load = 1;
		end
	WAIT_PLAYER_LOCATION_LOAD: 
		begin
			player_location_load = 1;
			player_colour_load = 1;
			resetcounter =1;
		end
	DRAW_PLAYER: 
		begin 
			player_location_load = 1;
			preload = 1;
			graph = 1;
			resetc = 0;
		 end
   GENERATE_ENEMY:
		begin
		x_enemy_pos_load = 1;
		end
   SET_BULLET_COLOUR: 
		begin
		bullet_color_load = 1;
		bullet_make_move = 1;
		end
	SET_ENEMY_COLOUR:
		begin
		enemy_color_load = 1;
		end
	WAIT_ENEMY1_LOCATION_LOAD:
		begin
		enemy1_location_load = 1;
		resetcounter =1;
		end
	WAIT_ENEMY2_LOCATION_LOAD:
		begin
		enemy2_location_load = 1;
		resetcounter =1;
		end
	WAIT_ENEMY3_LOCATION_LOAD:
		begin
		enemy3_location_load = 1;
		resetcounter =1;
		end
	WAIT_ENEMY4_LOCATION_LOAD:
		begin
		enemy4_location_load = 1;
		resetcounter =1;
		end
	DRAW_ENEMY1:
		begin
		enemy1_location_load = 1;
		enemy_preload = 1;
		graph = 1;
		resetc = 0;
		end
	DRAW_ENEMY2:
		begin
		enemy2_location_load = 1;
		enemy_preload = 1;
		graph = 1;
		resetc = 0;
		end
	DRAW_ENEMY3:
		begin
		enemy3_location_load = 1;
		enemy_preload = 1;
		graph = 1;
		resetc = 0;
		end
	DRAW_ENEMY4:
		begin
		enemy4_location_load = 1;
		enemy_preload = 1;
		graph = 1;
		resetc = 0;
		end
	WAIT_ERASE_ENEMY1_LOAD: enemy1_location_load = 1;
	WAIT_ERASE_ENEMY2_LOAD: enemy2_location_load = 1;
	WAIT_ERASE_ENEMY3_LOAD: enemy3_location_load = 1;
	WAIT_ERASE_ENEMY4_LOAD: enemy4_location_load = 1;
	ERASE_ENEMY1: 
		begin
			enemy1_location_load = 1;
			enemy_preload = 1;
			graph = 1;
			erase = 1;
			resetc = 0;
		end
	ERASE_ENEMY2: 
		begin
			enemy2_location_load = 1;
			enemy_preload = 1;
			graph = 1;
			erase = 1;
			resetc = 0;
		end
	ERASE_ENEMY3: 
		begin
			enemy3_location_load = 1;
			enemy_preload = 1;
			graph = 1;
			erase = 1;
			resetc = 0;
		end
	ERASE_ENEMY4: 
		begin
			enemy4_location_load = 1;
			enemy_preload = 1;
			graph = 1;
			erase = 1;
			resetc = 0;
		end
	DRAW_BULLET:
		begin 
			bullet_make_move = 1;
			graph = 1;
			resetc = 0;
		end
	DRAW_WAIT: 
		begin
			erase = 1;
			player_location_load = 1;
			counterenable = 1;
			resetcounter = 1;
		end
	ERASE_PLAYER:
		begin
			player_location_load = 1;
			preload = 1;
			graph = 1;
			erase = 1;
			resetc = 0;
		end
	WAIT_BULLET_DRAW_LOAD: bullet_make_move = 1;
	WAIT_BULLET_ERASE_LOAD: bullet_make_move = 1;
	ERASE_BULLET:
		begin 
			graph = 1;
			erase = 1;
		end
	UPDATE: begin
		enable = 1;
		player_colour_load = 1;
		player_location_load = 1;
		resetcounter =1;
		end
   endcase
    
  end 
  
 always @(posedge clk)
 begin
  if (!resetn) 
   current_state <= COUNTER_RESET;
  else 
   current_state <= next_state;
 end
 
endmodule

module seq_decoder(S, seg);
    input [3:0] S;
    output reg [6:0] seg;
   
    always @(*)
        case (S)
            4'h0: seg = 7'b100_0000;
            4'h1: seg = 7'b111_1001;
            4'h2: seg = 7'b010_0100;
            4'h3: seg = 7'b011_0000;
            4'h4: seg = 7'b001_1001;
            4'h5: seg = 7'b001_0010;
            4'h6: seg = 7'b000_0010;
            4'h7: seg = 7'b111_1000;
            4'h8: seg = 7'b000_0000;
            4'h9: seg = 7'b001_1000;
            4'hA: seg = 7'b000_1000;
            4'hB: seg = 7'b000_0011;
            4'hC: seg = 7'b100_0110;
            4'hD: seg = 7'b010_0001;
            4'hE: seg = 7'b000_0110;
            4'hF: seg = 7'b000_1110;   
            default: seg = 7'h7f;
        endcase
endmodule
