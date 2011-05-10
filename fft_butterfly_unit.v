//
// The Butterfly Unit is a pice of combinational logic that produces a 
// single butterfly result.
//
//
module fft_butterfly_unit(
	input wire signed [9:0] address,
	input wire signed [31:0] x_top_re,
	input wire signed [31:0] x_top_im,
	input wire signed [31:0] x_bot_re,
	input wire signed [31:0] x_bot_im,
	output reg signed [31:0] y_top_re,
	output reg signed [31:0] y_top_im,
	output reg signed [31:0] y_bot_re,
	output reg signed [31:0] y_bot_im
);
	//	Params
	parameter N		= 256;
	parameter M		= 8;
		
	//	Internal
	wire signed [15:0] twiddle_re, twiddle_im;
	wire signed [31:0] top_re, top_im;
	wire signed [31:0] bot_re, bot_im;
	
	wire signed [63:0] ac, bd, ad, bc;
			
	//		Intermediates
	//		Complex multiplication (a+bi)(c+di) = (ac-bd)+i(ad+bc)
	assign ac = x_bot_re*twiddle_re;
	assign bd = x_bot_im*twiddle_im;
	assign ad = x_bot_re*twiddle_im;
	assign bc = x_bot_im*twiddle_re;
	
	assign top_re = x_top_re;
	assign top_im = x_top_im;
	
	assign bot_re = (ac-bd)>>>15; // Divide by 2^15
	assign bot_im = (ad+bc)>>>15;
	
		
	//	Twiddle LUT
	FFT1024_LUT LUT (
		.n(address[9:0]),
		.twiddle({twiddle_re, twiddle_im})
	);	

	always @ (top_re, bot_re, top_im, bot_im)
	begin
		y_top_re = top_re + (bot_re);
		y_top_im = top_im + (bot_im);
		y_bot_re = top_re - (bot_re);
		y_bot_im = top_im - (bot_im);
		
		$display("----address %d twiddle %d+i%d", address, twiddle_re, twiddle_im);
		$display("----x[i_top] %d + %d i; x[i_bot] %d+%d i", x_top_re, x_top_im, x_bot_re, x_bot_im);
		$display("----ac=%d bd=%d ad=%d bc=%d", ac, bd, ad, bc);
		$display("------top_re %d top_im %d", top_re, top_im);
		$display("------bot_re %d bot_im %d", bot_re, bot_im);
		$display("----outputs y_top %d+i%d y_bot %d+i%d", y_top_re, y_top_im, y_bot_re, y_bot_im);
	end
endmodule