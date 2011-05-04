// State machine for EE 201L Veritune final project.
// By Chris Li, Grayson Smith, and Carey Zhang.
`timescale 1ns / 1ps

module veritune_sm(Clk, Reset, Rec, Stop, Play, Freq, Audio_In, q_I, q_Rec, q_Stop, q_Play, Audio_Out);
	// inputs
	input Clk, Reset, Rec, Stop, Play;
	input [7:0] Freq;
	input [15:0] Audio_In;
	
	// outputs
	output reg [15:0] Audio_Out;
	// store current state
	output q_I, q_Rec, q_Stop, q_Play;
	reg [3:0] state;
	assign {q_Play, q_Stop, q_Rec, q_I} = state;
	
	// local
	localparam I = 4'b0001, REC = 4'b0010, STOP = 4'b0100, PLAY = 4'b1000, UNK = 4'bXXXX;
	localparam LENGTH = 131070;	// 2^17-2, max number of samples -2
	reg [15:0] audio_data[16:0];	// unpacked array of N-bits
	reg [16:0] index;
	reg [16:0] length;	// actually length recorded -1
	
	reg signed [31:0] X_Re [1023:0];
	reg signed [31:0] X_Im [1023:0];
	wire write_en;
	assign write_en = 1;
	
	//	Internal
	wire signed [31:0] y_top_re;
	wire signed [31:0] y_top_im;
	wire signed [31:0] y_bot_re;
	wire signed [31:0] y_bot_im;
	wire [9:0]  i_top, i_bot;
	
	assign x_top_re = X_Re[i_top];
	assign x_top_im = X_Im[i_top];
	assign x_bot_re = X_Re[i_bot];
	assign x_bot_im = X_Im[i_bot];
	
	always @(posedge Clk)
	begin
		if(state == REC)
		begin
			if(write_en == 1)
			begin
				X_Re[i_top] <= y_top_re;
				X_Im[i_top] <= y_top_im;
				X_Re[i_bot] <= y_bot_re;
				X_Im[i_bot] <= y_bot_im;
			end
		end
	end
	

	FFT1024 ButterflyUnit1 (
			.Clk(Clk),
			.Reset(Reset),
			.Start(1),
			.Ack(0),
			.x_top_re(x_top_re),
			.x_top_im(x_top_im),
			.x_bot_re(x_bot_re),
			.x_bot_im(x_bot_im),
			.i_top(i_top),
			.i_bot(i_bot),
			.state(),
			.Done(),
			.y_top_re(y_top_re),
			.y_top_im(y_top_im),
			.y_bot_re(y_bot_re),
			.y_bot_im(y_bot_im)
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
				if (Stop || (index==LENGTH))
				begin
					length <= index;
					state <= STOP;
					
				end
					
				// clear data first?
				//X_Re[i_top] <= y_top_re;
				//X_Im[i_top] <= y_top_im;
				//X_Re[i_bot] <= y_bot_re;
				//X_Im[i_bot] <= y_bot_im;
				
				// store data from audio input
				audio_data[index] <= Audio_In;
				index <= index+1;
			end
			STOP:
			begin
				// state transition logic
				if (Play)
					state <= PLAY;
					
				// just wait? or do frequency shift here?
				index <= 0;
			end
			PLAY:
			begin
				// state transition logic
				if (Stop || index==length)
					state <= STOP;
					
				// do frequency shift?
				
				// drive audio output

			end
			default:
				state <= UNK;
		endcase
	end 
endmodule