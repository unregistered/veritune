// State machine for EE 201L Veritune final project.
// By Chris Li, Grayson Smith, and Carey Zhang.
`timescale 1ns / 1ps

module veritune_sm(Clk, Reset, Rec, Stop, Play, Freq, Audio_In, q_I, q_Rec, q_Stop, q_Play, Audio_Out);
	// inputs
	input Clk, Reset, Rec, Stop, Play;
	input [7:0] Freq;
	input Audio_In;
	
	// outputs
	output reg Audio_Out;
	// store current state
	output q_I, q_Rec, q_Stop, q_Play;
	reg [3:0] state;
	assign {q_Play, q_Stop, q_Rec, q_I} = state;
	
	localparam I = 4'b0001, REC = 4'b0010, STOP = 4'b0100, PLAY = 4'b1000, UNK = 4'bXXXX;

	// NSL and SM
	always @ (posedge Clk, posedge Reset)
	begin : NSL_AND_SM
		if (Reset)
		begin : RESET
			state <= I;
		end
		else
		case (state)
			I:
			begin
				// state transition logic
				if (Rec)
					state <= REC;
			end
			REC:
			begin
				// state transition logic
				if (Stop)
					state <= STOP;
					
				// clear data first?
				// store data from audio input
			end
			STOP:
			begin
				// state transition logic
				if (Play)
					state <= PLAY;
					
				// just wait? or do frequency shift here?
			end
			PLAY:
			begin
				// state transition logic
				if (Stop)
					state <= STOP;
					
				// do frequency shift?
				// drive audio output
			end
			default:
				state <= UNK;
		endcase
	end 
endmodule
