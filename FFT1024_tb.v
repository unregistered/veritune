`timescale 1ns / 1ps

module FFT1024_tb_v;
	parameter PRE = 32;
		
	reg Clk;
	reg Reset, Start, Ack;
	reg signed [PRE-1:0] X_Re [1023:0];
	reg signed [PRE-1:0] X_Im [1023:0];
	integer timestamp;
	
	// Outputs
	wire [3:0] state;
	wire Done;
	wire signed [31:0] x_top_re;
	wire signed [31:0] x_top_im;
	wire signed [31:0] x_bot_re;
	wire signed [31:0] x_bot_im;	
	
	// Internal
	wire signed [31:0] y_top_re;
	wire signed [31:0] y_top_im;
	wire signed [31:0] y_bot_re;
	wire signed [31:0] y_bot_im;
	wire [9:0]  i_top, i_bot;
	
	wire signed [31:0] x0, x1, x2, x3, x4, x5, x6, x7;
	assign x0 = X_Re[0];
	assign x1 = X_Re[1];
	assign x2 = X_Re[2];
	assign x3 = X_Re[3];
	assign x4 = X_Re[4];
	assign x5 = X_Re[5];
	assign x6 = X_Re[6];
	assign x7 = X_Re[7];
	assign x_top_re = X_Re[i_top];
	assign x_top_im = X_Im[i_top];
	assign x_bot_re = X_Re[i_bot];
	assign x_bot_im = X_Im[i_bot];
	
	
	// Instantiate the Unit Under Test (UUT)
	FFT1024 uut (
		//	Ins
		.Clk(Clk),
		.Reset(Reset),
		.Start(Start),
		.Ack(Ack),
		.x_top_re(X_Re[i_top]),
		.x_top_im(X_Im[i_top]),
		.x_bot_re(X_Re[i_bot]),
		.x_bot_im(X_Im[i_bot]),
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
	
	//	Here's how to use the butterfly unit
	always @(posedge Clk)
	begin
		timestamp <= timestamp + 1;
		case(state)
			4'd1: //Done
			begin
				$display("X[0]=%d + i%d", X_Re[0], X_Im[0]);
				$display("X[1]=%d + i%d", X_Re[1], X_Im[1]);
				$display("X[2]=%d + i%d", X_Re[2], X_Im[2]);
				$display("X[3]=%d + i%d", X_Re[3], X_Im[3]);
				$display("X[4]=%d + i%d", X_Re[4], X_Im[4]);
				$display("X[5]=%d + i%d", X_Re[5], X_Im[5]);
				$display("X[6]=%d + i%d", X_Re[6], X_Im[6]);
				$display("X[7]=%d + i%d", X_Re[7], X_Im[7]);
				Ack = 1;
			end
			4'd2: //Proc
			begin
				$display("Time: %d", timestamp);
				$display("  i_top %b i_bot %b", i_top, i_bot);
				$display("  x_top_re %d x_bot_re %d", X_Re[i_top], X_Re[i_bot]);
				$display("  y_top %d + i%d y_bot %d + i%d", y_top_re, y_top_im, y_bot_re, y_bot_im);
				X_Re[i_top] <= y_top_re;
				X_Im[i_top] <= y_top_im;
				X_Re[i_bot] <= y_bot_re;
				X_Im[i_bot] <= y_bot_im;
			end
		endcase
	end
	
	//	Just setup
	initial
	begin
		timestamp = 0;
		Start = 0;
		Reset = 0;
		Ack = 0;
		#10
		Reset = 1;
		#200
		// FFT
X_Re[0]=32'd0;X_Re[4]=-32'd202;X_Re[2]=-32'd2459;X_Re[6]=-32'd1021;X_Re[1]=32'd202;X_Re[5]=32'd1248;X_Re[3]=32'd618;X_Re[7]=-32'd820;
X_Im[0]=32'd0; X_Im[1]=-32'd0; X_Im[2]=-32'd0; X_Im[3]=-32'd0; X_Im[4]=32'd0; X_Im[5]=32'd0; X_Im[6]=32'd0; X_Im[7]=-32'd0;
		#10
		Reset = 0;
		#10
		
		Start = 1;
		#130
		Start = 0;
	end

endmodule