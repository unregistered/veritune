/***
 * 4 Point Fast Fourier Transform
 * 
 * Precision: 16-bit precision, inputs from 0-65535. All factors scalled by 65535.
 */

module FFT4(X0, X1, X2, X3,
						Y0_Re, Y1_Re, Y2_Re, Y3_Re, 
						Y0_Im, Y1_Im, Y2_Im, Y3_Im
						);
	parameter PRE = 16;
						
	// Inputs
	input signed [PRE:0] X0, X1, X2, X3;
	wire signed [PRE:0] X [3:0];
	assign X[0] = X0;
	assign X[1] = X1;
	assign X[2] = X2;
	assign X[3] = X3;

	// Outputs
	reg signed [2*PRE:0] Y_Re [3:0];
	reg signed [2*PRE:0] Y_Im [3:0];
	output wire [2*PRE:0] Y0_Re, Y1_Re, Y2_Re, Y3_Re, Y0_Im, Y1_Im, Y2_Im, Y3_Im;
	assign Y0_Re = Y_Re[0];
	assign Y1_Re = Y_Re[1];
	assign Y2_Re = Y_Re[2];
	assign Y3_Re = Y_Re[3];
	assign Y0_Im = Y_Im[0];
	assign Y1_Im = Y_Im[1];
	assign Y2_Im = Y_Im[2];
	assign Y3_Im = Y_Im[3];
	
	// Internal
	reg [4:0] address;
	wire[PRE:0] coeff_real;
	wire[PRE:0] coeff_imag;
	integer k,n;

	// LUT
	function signed [PRE:0] twiddle;
		input [1:0] k, n;	
		input is_im;
		begin
			case({is_im, k, n})
				/* Real */
				5'd0: twiddle = 16'd65535; // k = 0, n = 0
				5'd1: twiddle = 16'd65535; // k = 0, n = 1
				5'd2: twiddle = 16'd65535; // k = 0, n = 2
				5'd3: twiddle = 16'd65535; // k = 0, n = 3
				5'd4: twiddle = 16'd65535; // k = 1, n = 0
				5'd5: twiddle = 16'd0; // k = 1, n = 1
				5'd6: twiddle = -16'd65535; // k = 1, n = 2
				5'd7: twiddle = 16'd0; // k = 1, n = 3
				5'd8: twiddle = 16'd65535; // k = 2, n = 0
				5'd9: twiddle = -16'd65535; // k = 2, n = 1
				5'd10: twiddle = 16'd65535; // k = 2, n = 2
				5'd11: twiddle = -16'd65535; // k = 2, n = 3
				5'd12: twiddle = 16'd65535; // k = 3, n = 0
				5'd13: twiddle = 16'd0; // k = 3, n = 1
				5'd14: twiddle = -16'd65535; // k = 3, n = 2
				5'd15: twiddle = 16'd0; // k = 3, n = 3
				/* Imag */
				5'd16: twiddle = 16'd0; // k = 0, n = 0
				5'd17: twiddle = 16'd0; // k = 0, n = 1
				5'd18: twiddle = 16'd0; // k = 0, n = 2
				5'd19: twiddle = 16'd0; // k = 0, n = 3
				5'd20: twiddle = 16'd0; // k = 1, n = 0
				5'd21: twiddle = 16'd65535; // k = 1, n = 1
				5'd22: twiddle = 16'd0; // k = 1, n = 2
				5'd23: twiddle = -16'd65535; // k = 1, n = 3
				5'd24: twiddle = 16'd0; // k = 2, n = 0
				5'd25: twiddle = 16'd0; // k = 2, n = 1
				5'd26: twiddle = 16'd0; // k = 2, n = 2
				5'd27: twiddle = 16'd0; // k = 2, n = 3
				5'd28: twiddle = 16'd0; // k = 3, n = 0
				5'd29: twiddle = -16'd65535; // k = 3, n = 1
				5'd30: twiddle = 16'd0; // k = 3, n = 2
				5'd31: twiddle = 16'd65535; // k = 3, n = 3
			endcase
		end
	endfunction
	
	always @ (X0, X1, X2, X3)
	begin
		Y_Re[0] = 0;
		Y_Re[1] = 0;
		Y_Re[2] = 0;
		Y_Re[3] = 0;
		Y_Im[0] = 0;
		Y_Im[1] = 0;
		Y_Im[2] = 0;
		Y_Im[3] = 0;
		for(k=0; k<4; k=k+1)
		begin
			for(n=0; n<4; n=n+1)
			begin
				Y_Re[k] = Y_Re[k] + X[n]*twiddle(k[1:0], n[1:0], 0);
				Y_Im[k] = Y_Im[k] + X[n]*twiddle(k[1:0], n[1:0], 1);
				//$display("k=%d n=%d Y_Re=%d Y_Im=%d X=%d coeff=%d + i%d", k, n, Y_Re[k], Y_Im[k], X[n], twiddle(k[1:0], n[1:0], 0), twiddle(k[1:0], n[1:0], 1));
			end
		end
		//$display("Y_Re = %p Y_Im = %p", Y_Re, Y_Im);
		
	end	
endmodule