module fft_pointers(
	input wire Clk,
	input wire Reset,
	input wire Start,
	input wire Ack,
	output wire [9:0] i_top,
	output wire [9:0] i_bot,
	output wire [9:0] address,
	output wire Done,
	output reg [3:0] state
);
	//	Params
	parameter N		= 256;
	parameter M		= 8;
	
	localparam INIT = 4'b1000, LOAD = 4'b0100, PROC = 4'b0010, DONE = 4'b0001, UNK = 4'bXXXX;
	wire Init, Load, Proc;
	assign {Init, Load, Proc, Done} = state;
	
	//	Internal
	reg [4:0] i;
	reg [9:0] j, k;
	
	wire [9:0] TERM_I, TERM_J, TERM_K, n_blocks, n_passes;
	wire [10:0] n_butterflies;
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
	//	State Machine
	//
	always @ (posedge Clk)
	begin
		if (Reset)
		begin
			state <= INIT;
			{i, j, k} <= 0;			
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