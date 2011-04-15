`timescale 1ns / 1ps

module FFT8_LUT_tb_v;

	reg Clk;
	reg Reset, Start;
	reg [2:0] address;
	
	wire [15:0] coeff_real;
	wire [15:0] coeff_imag;
	
	// Instantiate the Unit Under Test (UUT)
	FFT8_LUT_Re uut1 (
		.address(address),
		.coefficient(coeff_real)
	);
	
	FFT8_LUT_Im uut2 (
		.address(address),
		.coefficient(coeff_imag)
	);
	
	initial
	begin
		Clk = 0; // Initialize clock
	end
	
	// Keep clock running
	always
	begin
		#10; 
		Clk = ~ Clk; 
	end
	
	initial
	begin
		#200
		address = 3'b000;
		#50
		address = 3'b001;
		#50
		address = 3'b010;
		#50
		address = 3'b011;
		#50
		address = 3'b100;
		#50
		address = 3'b101;
		#50
		address = 3'b110;
		#50
		address = 3'b111;
	end

endmodule