// State machine for EE 201L Veritune final project.
// By Chris Li, Grayson Smith, and Carey Zhang.
`timescale 1ns / 1ps

module veritune_sm(Clk, Reset, Addr_Wr, Addr_Rd, En_wr, Data_in, Start,
		Done, Data_wout, Data_rout/*, Data_Re, Data_Im*/);
	// inputs
	input Clk, Reset;
	input [9:0] Addr_Wr, Addr_Rd;
	input En_wr, Start;
	input wire [15:0] Data_in;
	
	// outputs
	output [15:0] Data_wout, Data_rout;//, Data_Re, Data_Im;
	output Done;
	
	// local
	reg [31:0] regarray [0:1023];
	
//	reg signed [31:0] X_Re [1023:0];
	reg signed [31:0] X_Im [1023:0];
	
	// fft outputs
	wire signed [31:0] x_top_re;
	wire signed [31:0] x_top_im;
	wire signed [31:0] x_bot_re;
	wire signed [31:0] x_bot_im;	
	
	// fft internal
	wire signed [31:0] y_top_re;
	wire signed [31:0] y_top_im;
	wire signed [31:0] y_bot_re;
	wire signed [31:0] y_bot_im;
	wire [9:0]  i_top, i_bot;
	wire write_en;
	assign write_en = 1;
	assign x_top_re = regarray[i_top];
	assign x_top_im = regarray[i_top];
	assign x_bot_re = regarray[i_bot];
	assign x_bot_im = regarray[i_bot];
	
	wire [3:0] state;

//------------------------------------------------------------------------- 	
	assign Data_wout = regarray[Addr_Wr];
	assign Data_rout = regarray[Addr_Rd];
//	assign Data_Re = X_Re[Addr_Rd];
//	assign Data_Im = X_Im[Addr_Rd];
//------------------------------------------------------------------------- 
	// Instantiate the Unit Under Test (UUT)
	FFT1024 uut (
		//	Ins
		.Clk(Clk),
		.Reset(Reset),
		.Start(Start),
		.Ack(Start),
		.x_top_re(x_top_re),
		.x_top_im(x_top_im),
		.x_bot_re(x_bot_re),
		.x_bot_im(x_bot_im),
		//	Outs
		.i_top(i_top),
		.i_bot(i_bot),
		.y_top_re(y_top_re),
		.y_top_im(y_top_im),
		.y_bot_re(y_bot_re),
		.y_bot_im(y_bot_im),
		.Done(Done),
		.state(state)
	);


//------------------------------------------------------------------------- 
	// NSL and SM
	always @ (posedge Clk)
	begin : NSL_AND_SM
		if (En_wr)
			regarray[Addr_Wr] <= Data_in;
			
		if (state == 4'd2)	// in Proc state (defined in fft1024.v)
		begin
			if (write_en)
			begin
				regarray[i_top] <= y_top_re;
				X_Im[i_top] <= y_top_im;
				regarray[i_bot] <= y_bot_re;
				X_Im[i_bot] <= y_bot_im; 
			end
		end
	end
endmodule
