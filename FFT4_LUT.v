module FFT4_LUT_Re(k, n, twiddle);
	input [1:0] k;
	input [1:0] n;
	
	wire [3:0] address;
	assign address = {k, n};
	
	output reg [16:0] twiddle;
	
	always @ (address)
	begin
		$display("LUT address=%d, k=%d, n=%d", address, k, n);
		case(address)
			4'd0: twiddle = 16'd65535; // k = 0, n = 0
			4'd1: twiddle = 16'd65535; // k = 0, n = 1
			4'd2: twiddle = 16'd65535; // k = 0, n = 2
			4'd3: twiddle = 16'd65535; // k = 0, n = 3
			4'd4: twiddle = 16'd65535; // k = 1, n = 0
			4'd5: twiddle = 16'd0; // k = 1, n = 1
			4'd6: twiddle = -16'd65535; // k = 1, n = 2
			4'd7: twiddle = 16'd0; // k = 1, n = 3
			4'd8: twiddle = 16'd65535; // k = 2, n = 0
			4'd9: twiddle = -16'd65535; // k = 2, n = 1
			4'd10: twiddle = 16'd65535; // k = 2, n = 2
			4'd11: twiddle = -16'd65535; // k = 2, n = 3
			4'd12: twiddle = 16'd65535; // k = 3, n = 0
			4'd13: twiddle = 16'd0; // k = 3, n = 1
			4'd14: twiddle = -16'd65535; // k = 3, n = 2
			4'd15: twiddle = 16'd0; // k = 3, n = 3
		endcase
	end

endmodule

module FFT4_LUT_Im(k, n, twiddle);
	input [1:0] k;
	input [1:0] n;
	
	wire [3:0] address;
	assign address = {k, n};
	
	output reg [16:0] twiddle;	
	
	always @ (address)
	begin
		case(address)
			4'd0: twiddle = 16'd0; // k = 0, n = 0
			4'd1: twiddle = 16'd0; // k = 0, n = 1
			4'd2: twiddle = 16'd0; // k = 0, n = 2
			4'd3: twiddle = 16'd0; // k = 0, n = 3
			4'd4: twiddle = 16'd0; // k = 1, n = 0
			4'd5: twiddle = 16'd65535; // k = 1, n = 1
			4'd6: twiddle = 16'd0; // k = 1, n = 2
			4'd7: twiddle = -16'd65535; // k = 1, n = 3
			4'd8: twiddle = 16'd0; // k = 2, n = 0
			4'd9: twiddle = 16'd0; // k = 2, n = 1
			4'd10: twiddle = 16'd0; // k = 2, n = 2
			4'd11: twiddle = 16'd0; // k = 2, n = 3
			4'd12: twiddle = 16'd0; // k = 3, n = 0
			4'd13: twiddle = -16'd65535; // k = 3, n = 1
			4'd14: twiddle = 16'd0; // k = 3, n = 2
			4'd15: twiddle = 16'd65535; // k = 3, n = 3
		endcase
	end

endmodule