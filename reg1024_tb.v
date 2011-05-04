`timescale 1ns/1ps

module reg1024_tb;
	reg Clk;
	reg Reset, Start;
	
	//Internal
	reg [9:0] i_top, i_bot;
	reg write_en;
	reg signed [31:0] x_top_re;
	reg signed [31:0] x_top_im;
	reg signed [31:0] x_bot_re;
	reg signed [31:0] x_bot_im;
	wire signed [31:0] y_top_re;
	wire signed [31:0] y_top_im;
	wire signed [31:0] y_bot_re;
	wire signed [31:0] y_bot_im;
	
	reg state; // 0 seeding 1 changing

	reg1024 uut(
		.Clk      (Clk),
		.Reset		(Reset),
		.i_top    (i_top),
		.i_bot    (i_bot),
		.write_en (write_en),
		.x_top_re (x_top_re),
		.x_top_im (x_top_im),
		.x_bot_re (x_bot_re),
		.x_bot_im (x_bot_im),
		.y_top_re (y_top_re),
		.y_top_im (y_top_im),
		.y_bot_re (y_bot_re),
		.y_bot_im (y_bot_im)
	);

	initial
	begin
		Clk = 0; // Initialize clock
		Start = 0;
		Reset = 0;
	end
	
	// Keep clock running
	always
	begin
		#20; 
		Clk = ~ Clk; 
	end
	
	always @(posedge Clk)
	begin
		if(~state) //Seeding data
		begin
			i_top = i_top + 1;
			i_bot = i_bot + 1;
			x_top_re = i_top;
			x_top_im = i_top*2;
			x_bot_re = i_bot;
			x_bot_im = i_bot*2;
		end
		else // Listing Data
		begin
			i_top = i_top + 1;
			i_bot = i_bot + 1;
		end
	end
	
	initial
	begin
		Start = 0;
		Reset = 0;
		#200
		Reset = 1;
		state = 0;		
		#100
		i_top = 0; i_bot = 1;
		write_en = 1;
		#300
		i_top = 0; i_bot = 1;
		write_en = 0;
		state = 1;
	end
endmodule