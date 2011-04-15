module FFT8_LUT_Re(address, coefficient);
	input [2:0] address;
	//output [15:0] coefficient;
	
	output reg [15:0] coefficient;
	
	always @ (address)
	begin
		case(address)
		0: coefficient = 16'd00000000001000;
		1: coefficient = 16'd00000000000707;
		2: coefficient = 16'd00000000000000;
		3: coefficient = -16'd0000000000707;
		4: coefficient = -16'd0000000001000;
		5: coefficient = -16'd0000000000707;
		6: coefficient = 16'd00000000000000;
		7: coefficient = 16'd00000000000707;
		endcase
	end

endmodule;

module FFT8_LUT_Im(address, coefficient);
	input [2:0] address;
	//output [15:0] coefficient;
	
	output reg [15:0] coefficient;
	
	always @ (address)
	begin
		case(address)
		0: coefficient = 16'd00000000000000;
		1: coefficient = -16'd0000000000707;
		2: coefficient = -16'd0000000001000;
		3: coefficient = -16'd0000000000707;
		4: coefficient = 16'd00000000000000;
		5: coefficient = 16'd00000000000707;
		6: coefficient = 16'd00000000001000;
		7: coefficient = 16'd00000000000707;
		endcase
	end

endmodule