module FFT8_LUT(n, twiddle);
	input [9:0] n;
		
	output reg [31:0] twiddle;
	
	always @ (n)
	begin
		case(n)
		3'd0  : twiddle = { 16'd32767   ,  16'd0       }; //i=0  n=8  twiddle= 1               + i 0
		3'd1  : twiddle = { 16'd23170   , -16'd23170   }; //i=1  n=8  twiddle= 7.071068e-01    + i -7.071068e-01
		3'd2  : twiddle = { 16'd0       , -16'd32767   }; //i=2  n=8  twiddle= 6.123234e-17    + i -1
		3'd3  : twiddle = {-16'd23170   , -16'd23170   }; //i=3  n=8  twiddle= -7.071068e-01   + i -7.071068e-01
		default: twiddle = 'bX;
		endcase
	end

endmodule