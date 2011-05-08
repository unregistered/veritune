`timescale 1ns / 1ps

module fft_sm_tb_v;

	reg Clk;
	reg Reset, Start, Ack;
	reg [7:0] Inspect;
	wire [3:0] Inspect_0, Inspect_1, Inspect_2, Inspect_3;
	
	fft_sm uut (
    .Clk(Clk), 
    .Reset(Reset), 
    .Start(Start), 
    .Inspect(Inspect), 
    .Inspect_0(Inspect_0), 
    .Inspect_1(Inspect_1), 
    .Inspect_2(Inspect_2), 
    .Inspect_3(Inspect_3), 
		.ActivateSSD(),
		.Ready(Ready),
    .Done(Done)
   );

	initial
	begin
		Clk = 0; // Initialize clock
		Start = 0;
		Reset = 1;
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
		Reset = 0;
		Inspect = 8'd0;
		#50
		Inspect = 8'd1;
		#50
		Inspect = 8'd2;
		#50
		Inspect = 8'd3;
	end
	
endmodule