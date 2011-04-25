/***
 * 1024 Point Radix 2 Decimation in Time Fast Fourier Transform
 * 
 * Precision: 16-bit precision, inputs from -32767 to 32767. All factors scalled by 32767.
 * 
 */
module FFT1024(
	input wire Clk,
	input wire Reset,
	input wire Start,
	input wire Ack,
	input wire signed [31:0] x_top_re,
	input wire signed [31:0] x_top_im,
	input wire signed [31:0] x_bot_re,
	input wire signed [31:0] x_bot_im,
	// real index of requested input
	output wire [9:0] i_top,
	output wire [9:0] i_bot,
	output reg [3:0] state,
	output wire Done,
	output wire signed [31:0] y_top_re,
	output wire signed [31:0] y_top_im,
	output wire signed [31:0] y_bot_re,
	output wire signed [31:0] y_bot_im
	//output wire Overflow
);
	//	Params
	parameter N		= 1024;
	parameter M		= 10;
	
	//	States
	localparam INIT = 4'b1000, LOAD = 4'b0100, PROC = 4'b0010, DONE = 4'b0001, UNK = 4'bXXXX;
	wire Init, Load, Proc;
	assign {Init, Load, Proc, Done} = state;
	
	//	Internal
	reg [4:0] i;
	reg [9:0] j, k;
	wire signed [15:0] twiddle_re, twiddle_im;
	wire signed [31:0] top_re, top_im;
	wire signed [31:0] bot_re, bot_im;
	
	wire [9:0] TERM_I, TERM_J, TERM_K, n_blocks, n_passes, address;
	wire [10:0] n_butterflies;
	wire signed [63:0] ac, bd, ad, bc;
	assign n_passes = M;
	assign n_blocks = 1 << M-i-1;
	assign n_butterflies = 1 << i+1;
	
	assign TERM_I = n_passes-1;
	assign TERM_J = n_blocks-1;
	assign TERM_K = n_butterflies/2-1;
	
	//		Address for the twiddle
	assign address = n_blocks*k;
	//		Array indicies
	assign i_top = n_butterflies*j+k;
	assign i_bot = i_top + n_butterflies/2;
	
	//
	//	Bit Reversal is required for in-place algorithms.  
	//
	//	Decimal index -> Binary -> Reverse Binary -> New decimal index
	//	          9   -> 01001  -> 10010          -> 18
	//
	
	
	
	//		Intermediates
	//		Complex multiplication (a+bi)(c+di) = (ac-bd)+i(ad+bc)
	assign ac = x_bot_re*twiddle_re;
	assign bd = x_bot_im*twiddle_im;
	assign ad = x_bot_re*twiddle_im;
	assign bc = x_bot_im*twiddle_re;
	
	assign top_re = x_top_re;
	assign top_im = x_top_im;
	
	assign bot_re = (ac-bd)>>15;
	assign bot_im = (ad+bc)>>15;
	
	assign y_top_re = top_re + (bot_re);
	assign y_top_im = top_im + (bot_im);
	assign y_bot_re = top_re - (bot_re);
	assign y_bot_im = top_im - (bot_im);
		
	//	Twiddle LUT
	FFT1024_LUT LUT (
		.n(address[9:0]),
		.twiddle({twiddle_re, twiddle_im})
	);
	
	//
	//	State Machine
	//
	always @ (posedge Clk, posedge Reset)
	begin
		if (Reset)
		begin
			state <= INIT;
		end
		else
		begin
			case(state)
				//	State: Init
				//	Inc: DONE, UNK
				//	Out: PROC
				INIT:
				begin
					{i,j,k} <= 0;
					if(Start)
						state <= PROC;
					else
						state <= INIT;
				end			
			
				//	State: Processing
				//	Inc: INIT
				//	Out: DONE
				PROC:
				begin
					$display("--Pass %d Block %d Butterflies %d and %d (i_top %d i_bot %d)", i, j, k, k+n_butterflies/2, i_top, i_bot);
					$display("----address %d twiddle %d+i%d", address, twiddle_re, twiddle_im);
					$display("----x[i_top] %d + %d i; x[i_bot] %d+%d i", x_top_re, x_top_im, x_bot_re, x_bot_im);
					$display("----ac=%d bd=%d ad=%d bc=%d", ac, bd, ad, bc);
					$display("------top_re %d top_im %d", top_re, top_im);
					$display("------bot_re %d bot_im %d", bot_re, bot_im);
					$display("----outputs y_top %d+i%d y_bot %d+i%d", y_top_re, y_top_im, y_bot_re, y_bot_im);
					
				
					//
					//	Counters
					//	i	=0:10-1						Current Pass
					//	j	=0:2^(10-i-1)-1		Current Block
					//	k	=0:2^i-1					Current Butterfly
					//
					
					k <= k+1;
					//	Unless
					if ( k == TERM_K )
					begin
						k <= 0;
						j <= j+1;
					end
					
					if ( j == TERM_J && k == TERM_K )
					begin
						j <= 0;
						i <= i+1;
					end
					
					//	Terminal condition
					if ( i == TERM_I && j == TERM_J && k == TERM_K)
						state <= DONE;
					
					//
					//	Variables
					//	i_top								Index of top butterfly
					//	i_bot								Index of bottom butterfly
					//	address							Points to twiddle factor (2^(m-1-i))*k+1
					//	twiddle_re/im				Twiddle factor from the LUT
					//
					
				end
			
			
				//	State: Done
				//	Inc: PROC
				//	Out: DONE
				DONE:
				begin					
					if(Ack)
					begin
						$display("Done. Awaiting ACK.");
						state <= INIT;
					end
					else
						state <= DONE;
				end
			
			
				default: state <= UNK;
			endcase
		end
	end
	

endmodule