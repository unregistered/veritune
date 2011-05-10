module fft_sm(
	input wire Clk,
	input wire Reset,
	input wire Start,
	input wire [7:0] Inspect,
	
	output reg [15:0] Result,
	output wire ActivateSSD,
	output wire Ready,
	output wire Done,
	output reg Overflow
);

	wire [3:0] fft_state;
	reg [3:0] state;	
	reg [3:0] substate;
	
	assign Ready = state[2];
	assign ActivateSSD = state[2] || state[0];
	
	// Initial values
	wire signed [31:0] x_re_init;
	reg [9:0] init_addr;
	fft_sm_initial_lut initial_lut (
		.n(init_addr),
		.x_re(x_re_init)
	);
	localparam INIT = 4'b1000, IDLE = 4'b0100, PROC = 4'b0010, DONE = 4'b0001, UNK = 4'bXXXX;
	localparam MOVE = 4'b1000, READ = 4'b0100, COMP = 4'b0010, WRITE = 4'b0001;
	
	// Dual port ram
	wire [31:0] dout_top, dout_bot;
	reg [7:0] addr_top, addr_bot;
	wire signed [31:0] din_top_re, din_top_im, din_bot_re, din_bot_im;
	wire signed [31:0] dout_top_re, dout_top_im, dout_bot_re, dout_bot_im;
	reg WE_top, WE_bot;
	//assign WE_top = state[3] || (state[1] && substate[0]);
	//assign WE_bot = state[1] && substate[0];
	dualport_ram ram2port (
	  .Clk(Clk), 
	  .WE_top(WE_top),
		.WE_bot(WE_bot),
		.Reset(Reset),
	  .addr_top(addr_top), 
	  .addr_bot(addr_bot), 
	  .din_top_re(din_top_re), 
		.din_top_im(din_top_im),
	  .din_bot_re(din_bot_re), 
		.din_bot_im(din_bot_im),
	  .dout_top_re(dout_top_re), 
		.dout_top_im(dout_top_im),
	  .dout_bot_re(dout_bot_re),
		.dout_bot_im(dout_bot_im)
	);
	
	
	wire step;
	reg  Start_FFT;
	wire [9:0] i_top, i_bot, twiddle_address;
	reg  signed [31:0] x_top_re, x_top_im, x_bot_re, x_bot_im;
	wire signed [31:0] y_top_re, y_top_im, y_bot_re, y_bot_im;
	reg  signed [31:0] x_top_re_tmp, x_top_im_tmp, x_bot_re_tmp, x_bot_im_tmp;
	fft_butterfly_unit butterfly_unit1 (
		.address(twiddle_address),
		.x_top_re(x_top_re),
		.x_top_im(x_top_im),
		.x_bot_re(x_bot_re),
		.x_bot_im(x_bot_im),
  	
		.y_top_re(y_top_re),
		.y_top_im(y_top_im),
		.y_bot_re(y_bot_re),
		.y_bot_im(y_bot_im)
	);
	fft_pointers pointers (
		.Clk(substate[3]),
		.Reset(Reset),
		.Start(Start_FFT),
		.Ack(1'b0),
		
  	.address(twiddle_address),
		.i_top(i_top),
		.i_bot(i_bot),
		.Done(Done),
		.state(fft_state)
	);
	
	assign din_top_re = (state == INIT) ? x_re_init : y_top_re;
	assign din_top_im = y_top_im;
	assign din_bot_re = y_bot_re;
	assign din_bot_im = y_bot_im;
	
	// State transitions
	always @ (posedge Clk)
	begin
		if(Reset)
		begin
			state <= INIT;
			substate <= MOVE;
			init_addr <= 0;			
			addr_bot = 0;
			addr_top = 0;
			x_top_re = 0;
			x_top_im = 0;
			x_bot_re = 0;
			x_bot_im = 0;
			Overflow = 0;
			WE_top = 1;
			WE_bot = 0;
		end
		else
		begin
			case(state)
				INIT:
				begin
					Start_FFT = 1;
					WE_top = 1;
					if(init_addr == 255)
					begin
						state <= IDLE;
					end
					else
					begin
						state <= INIT;
						init_addr <= init_addr + 1;
					end
					
					//
					// RTL
					//
					addr_top = init_addr + 1;
					
				end
			
				IDLE:
				begin
					WE_top = 0;
					if(Start)
						state <= PROC;
					else
						state <= IDLE;
					
					// 
					// RTL
					//
					addr_top = Inspect;
					Result = dout_top_re[15:0];
					
				end
			
				PROC:
				begin
					if(Done)
						state <= DONE;
					else
						state <= PROC;
						
					//
					// RTL
					//
					$display("SUBSTATE %d", substate);

					case(substate)
						MOVE: // Move the fft pointers, prepare the addr pointers for a synchronous read
						begin
							WE_top = 0;
							WE_bot = 0;
							if(fft_state == PROC)
								substate <= READ;
							else // Wait till the FFT is ready
								substate <= WRITE;
							$display("  i_top %d i_bot %d substate %d fft_state %d twiddle %d", i_top, i_bot, substate, fft_state, twiddle_address);
							addr_top = i_top;
							addr_bot = i_bot;
							
						end
						READ: // Read from the synchronous RAM and store into registers
						begin
							x_top_re_tmp <= dout_top_re;
							x_top_im_tmp <= dout_top_im;
							x_bot_re_tmp <= dout_bot_re;
							x_bot_im_tmp <= dout_bot_im;
							$display("  First Read");
							
							substate <= COMP;
						end
						COMP: // Compute
						begin
							x_top_re = dout_top_re;
							x_top_im = dout_top_im;
							x_bot_re = dout_bot_re;
							x_bot_im = dout_bot_im;
							WE_top = 1; WE_bot = 1;				
							
							substate <= WRITE;
						end
						WRITE: // Write
						begin
							WE_top = 0; WE_bot = 0;
							substate <= MOVE;
							$display("    Writing");
						end
						default: substate <= MOVE;
					endcase
					
				end
			
				DONE:
				begin
					// Stay till reset
					state <= DONE;
					
					// 
					// RTL
					//
					addr_top = Inspect;
					Result = dout_top_re[15:0];
					Overflow = ~((dout_top_re[31:16] == 16'hffff) || (dout_top_re[31:16] == 16'h0));
				end
			
				default: state <= UNK;
			endcase
		end
	end
endmodule