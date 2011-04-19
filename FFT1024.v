/***
 * 1024 Point Radix 2 Decimation in Time Fast Fourier Transform
 * 
 * Precision: 16-bit precision, inputs from -32767 to 32767. All factors scalled by 32767.
 */
module FFT1024(
	input wire Clk,
	input wire Reset,
	input wire Start,
	input wire signed [15:0] x_re,
	input wire signed [15:0] x_im,
	output reg Done
);
	
	//
	// Bit Reversal is required for in-place algorithms
	//
	wire signed [10:0] X;
	assign X[0] = x_re[0];
	
	// End Bit Reversal
	
	//
	// State 
	//
	always @ (posedge Clk)
	begin
		
	end
	

endmodule