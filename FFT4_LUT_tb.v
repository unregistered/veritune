`timescale 1ns / 1ps

module FFT4_LUT_tb_v;

	reg Clk;
	reg Reset, Start;
	reg [3:0] address;
	
	wire [16:0] coeff_real;
	wire [16:0] coeff_imag;
	
	// Instantiate the Unit Under Test (UUT)
	FFT4_LUT_Re uut1 (
		.k(address[3:2]),
		.n(address[1:0]),
		.twiddle(coeff_real)
	);
	
	FFT4_LUT_Im uut2 (
		.k(address[3:2]),
		.n(address[1:0]),
		.twiddle(coeff_imag)
	);
	
	initial
	begin
		Clk = 0; // Initialize clock
	end
	
	// Keep clock running
	always
	begin
		#20; 
		Clk = ~ Clk; 
	end
	
	initial
	begin
		#200
		address = 4'b0000;
		#20          
		address = 4'b0001;
		#20          
		address = 4'b0010;
		#20          
		address = 4'b0011;
		#20          
		address = 4'b0100;
		#20          
		address = 4'b0101;
		#20          
		address = 4'b0110;
		#20          
		address = 4'b0111;
		
		#200
		address = 4'b1000;
		#20          
		address = 4'b1001;
		#20          
		address = 4'b1010;
		#20          
		address = 4'b1011;
		#20          
		address = 4'b1100;
		#20          
		address = 4'b1101;
		#20          
		address = 4'b1110;
		#20          
		address = 4'b1111;
	end

endmodule