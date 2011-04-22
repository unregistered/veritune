// State machine for EE 201L Veritune final project.
// By Chris Li, Grayson Smith, and Carey Zhang.
`timescale 1ns / 1ps

module veritune_sm(Clk, Reset, Rec, Stop, Play, Done_Shift, Freq, Audio_In, q_I, q_Rec, q_Stop, q_Shift, q_Play, Audio_Out);
	// inputs
	input Clk, Reset, Rec, Stop, Play, Done_Shift;
	input [7:0] Freq;
	input [15:0] Audio_In;
	
	// outputs
	output reg [15:0] Audio_Out;
	// store current state
	output q_I, q_Rec, q_Stop, q_Shift, q_Play;
	reg [3:0] state;
	assign {q_Play, q_Shift, q_Stop, q_Rec, q_I} = state;
	
	// local
	localparam I = 5'b00001, REC = 5'b00010, STOP = 5'b00100, SHIFT = 5'b01000, PLAY = 5'b10000, UNK = 5'bXXXXX;
	localparam LENGTH = 131070;	// 2^17-2, max number of samples -2
	reg [15:0] audio_data[16:0];	// unpacked array of N-bits
	reg [16:0] index;
	reg [16:0] length;	// actually length recorded -1
	
	wire [15:0] fft_in0, fft_in1, fft_in2, fft_in3;
	wire [31:0] fft_outRe0, fft_outRe1, fft_outRe2, fft_outRe3;
	wire [31:0] fft_outIm0, fft_outIm1, fft_outIm2, fft_outIm3;

	FFT4 fft4(
		.X0(fft_in0),
		.X1(fft_in1),
		.X2(fft_in2),
		.X3(fft_in3),
		.Y0_Re(fft_outRe0),
		.Y1_Re(fft_outRe1),
		.Y2_Re(fft_outRe2),
		.Y3_Re(fft_outRe3),
		.Y0_Im(fft_outIm0),
		.Y1_Im(fft_outIm1),
		.Y2_Im(fft_outIm2),
		.Y3_Im(fft_outIm3)
	);

	// NSL and SM
	always @ (posedge Clk, posedge Reset)
	begin : NSL_AND_SM
		if (Reset)
		begin : RESET
			state <= I;
			index <= 0;
		end
		else
		case (state)
			I:
			begin
				// state transition logic
				if (Rec)
					state <= REC;
				index <= 0;	
			end
			REC:
			begin
				// state transition logic
				// TODO: handle if out of memory
				if (Stop || (index==LENGTH))
				begin
					length <= index;
					state <= STOP;
				end
					
				// clear data first?
				
				// store data from audio input
				audio_data[index] <= Audio_In;
				//index <= index+1;
			end
			STOP:
			begin
				// state transition logic
				if (Play)
					state <= SHIFT;
			end
			SHIFT:
			begin
				// state transition logic
				if (Done_Shift)
					state <= PLAY;
					
				index <= 0;
			end
			PLAY:
			begin
				// state transition logic
				if (Stop)// || index==length)
					state <= STOP;
					
				// drive audio output

			end
			default:
				//state <= UNK;
				state <= 5'b11111;
		endcase
	end 
endmodule
