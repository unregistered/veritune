`timescale 1ns / 1ps

module fft_sm_tb_v;

	reg Clk;
	reg Reset, Start, Ack;
	reg [7:0] Inspect;
	wire [15:0] Result;
	
	fft_sm uut (
    .Clk(Clk), 
    .Reset(Reset), 
    .Start(Start), 
    .Inspect(Inspect), 
    .Result(Result), 
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
	
	always @(posedge Clk)
	begin:INSPECT
		reg signed [15:0] sResult;
		if(Ready)
		begin
			Start = 1;
		end
		if(Done)
		begin
			$display("Done.");
		end
	end
	
	initial
	begin
		#200
		Inspect = 8'd0;
		#100 
		Reset = 0;
	end
	
endmodule