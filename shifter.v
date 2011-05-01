// Module for shifting frequency. Output DONE signal when done.
// By Chris Li, Grayson Smith, and Carey Zhang.
`timescale 1ns / 1ps
module shifter(Clk, Reset, Start,/*whatever inputs needed*/ Done);
	// Inputs
	input Clk, Reset;
	input Start;
	
	// Outputs
	output reg Done;
	
	// Locals
	reg [2:0] count;
	localparam TERMINAL = 3'b111;
	reg state; // 0 = idle, 1 = counting
	localparam IDLE=1'b0, COUNTING=1'b1;
	
	// Implementation logic
	// Just counting
	always @(posedge Clk, posedge Reset)
	begin
		if (Reset)
		begin
			count <= 0;
			state <= IDLE;
			Done <= 0;
		end
		else
		case (state)
			IDLE:
			begin
				if (Start)
					state<=COUNTING;
				Done <= 0;
				count <= 0;
			end
			COUNTING:
			begin
				if (count == TERMINAL)
				begin
					Done <= 1;
					state <= IDLE;
				end
				count <= count+1;
			end
		endcase
	end

endmodule
