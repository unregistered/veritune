/***
 * 4 Point Fast Fourier Transform using the Cooley Tukey Algorithm
 * 
 * Precision: 16-bit precision, inputs from 0-65535
 */

module FFT8(Clk,
						X0, X1, X2, X3, X4, X5, X6, X7,
						Y0_Re, Y1_Re, Y2_Re, Y3_Re, Y4_Re, Y5_Re, Y6_Re, Y7_Re
						);
						
	// Inputs
	input Clk;
	input X0, X1, X2, X3, X4, X5, X6, X7;

	// Outputs
	output Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7;

	// LUT
endmodule