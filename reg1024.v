module reg1024(
	input wire Clk,
	input wire Reset,
	input wire signed [9:0] i_top,
	input wire signed [9:0] i_bot,
	input wire write_en,
	input wire signed [31:0] x_top_re,
	input wire signed [31:0] x_top_im,
	input wire signed [31:0] x_bot_re,
	input wire signed [31:0] x_bot_im,
	output wire signed [31:0] y_top_re,
	output wire signed [31:0] y_top_im,
	output wire signed [31:0] y_bot_re,
	output wire signed [31:0] y_bot_im
	);
	
	reg signed [31:0] X_Re [1023:0];
	reg signed [31:0] X_Im [1023:0];
	
	// Async Reading
	assign y_top_re = X_Re[i_top];
	assign y_top_im = X_Im[i_top];
	assign y_bot_re = X_Re[i_bot];
	assign y_bot_im = X_Im[i_bot];
	
	always @(posedge Clk)
	begin : WRITE
		//integer i;
		//if(Reset)
		//begin
		//	for(i=0; i<1024; i=i+1)
		//	begin
		//		X_Re[i] = 'bX;
		//		X_Im[i] = 'bX;
		//	end
		//end
		
		if(write_en)
		begin
			X_Re[i_top] <= x_top_re;
			X_Re[i_bot] <= x_bot_re;
			X_Im[i_top] <= x_top_im;
			X_Im[i_bot] <= x_bot_im;
		end
	end
endmodule