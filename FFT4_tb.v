`timescale 1ns / 1ps

module FFT4_tb_v;
	parameter PRE = 16;
		
	reg Clk;
	reg Reset, Start;
	reg signed [PRE:0] X [3:0];
	
	// Outputs
	wire signed [2*PRE:0] Y_Re [3:0];
	wire signed [2*PRE:0] Y_Im [3:0];
	wire signed [PRE:0] X_out [3:0];
	assign X_out[0] = X[0];
	assign X_out[1] = X[1];
	assign X_out[2] = X[2];
	assign X_out[3] = X[3];
	
	// Instantiate the Unit Under Test (UUT)
	FFT4 uut (
		.X0(X[0]),
		.X1(X[1]), 
		.X2(X[2]), 
		.X3(X[3]),
		.Y0_Re(Y_Re[0]), 
		.Y1_Re(Y_Re[1]), 
		.Y2_Re(Y_Re[2]), 
		.Y3_Re(Y_Re[3]), 
		.Y0_Im(Y_Im[0]), 
		.Y1_Im(Y_Im[1]),
		.Y2_Im(Y_Im[2]),
		.Y3_Im(Y_Im[3])
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
		X[0] = 16'd0;
		X[1] = -16'd406;
		X[2] = -16'd4915;
		X[3] = -16'd2044;
		#50	 
		$display("Results 1:");
		$display("Y[0] expected %d+i%d got %d+i%d", -482739591, 0, Y_Re[0], Y_Im[0]);
		$display("Y[1] expected %d+i%d got %d+i%d", 322112716, 107370905, Y_Re[1], Y_Im[1]);
		$display("Y[2] expected %d+i%d got %d+i%d", -161485842, 0, Y_Re[2], Y_Im[2]);
		$display("Y[3] expected %d+i%d got %d+i%d", 322112716, -107370905, Y_Re[3], Y_Im[3]);
		#100
		X[0] = 16'd406;
		X[1] = 16'd2496;
		X[2] = 16'd1238;
		X[3] = -16'd1638;	  
		#50
		$display("Results 2:");
		$display("Y[0] expected %d+i%d got %d+i%d", 164062743, 0, Y_Re[0], Y_Im[0]);
		$display("Y[1] expected %d+i%d got %d+i%d", -054544420, 271004165, Y_Re[1], Y_Im[1]);
		$display("Y[2] expected %d+i%d got %d+i%d", 051538034, 0, Y_Re[2], Y_Im[2]);
		$display("Y[3] expected %d+i%d got %d+i%d", -054544420, -271004165, Y_Re[3], Y_Im[3]);
	end

endmodule