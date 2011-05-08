module fft_sm(
	input wire Clk,
	input wire Reset,
	input wire Start,
	input wire [7:0] Inspect,
	
	output reg [3:0] Inspect_0, Inspect_1, Inspect_2, Inspect_3,
	output wire ActivateSSD,
	output wire Ready,
	output wire Done
);
	reg signed [31:0] X_Re [255:0];
	reg signed [31:0] X_Im [255:0];
	wire [9:0] i_top, i_bot;
	wire [31:0] y_top_re, y_top_im, y_bot_re, y_bot_im;
	reg [31:0] x_top_re, x_top_im, x_bot_re, x_bot_im;
	wire [3:0] fft_state;
	reg [3:0] state;	
	
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
	
	
	//FFT1024 FFT (
	//	.Clk(Clk),
	//	.Reset(Reset),
	//	.Start(Start),
	//	.Ack(1'b0),
	//	.x_top_re(x_top_re),
	//	.x_top_im(x_top_im),
	//	.x_bot_re(x_bot_re),
	//	.x_bot_im(x_bot_im),
  //
	//	.i_top(i_top),
	//	.i_bot(i_bot),
	//	.y_top_re(y_top_re),
	//	.y_top_im(y_top_im),
	//	.y_bot_re(y_bot_re),
	//	.y_bot_im(y_bot_im),
	//	.Done(Done),
	//	.state(fft_state)
	//);
	
	// Allow user to explore
	always @(posedge Clk)
	begin
		if(ActivateSSD)
		begin
			{Inspect_3, Inspect_2, Inspect_1, Inspect_0} = X_Re[Inspect][15:0];
			$display("Actual value %b", X_Re[Inspect]);
			
		end
	end
	
	// Write back
	always @(posedge Clk)
	begin
		if(state == PROC)
		begin
			//X_Re[i_top] = y_top_re;
			//X_Im[i_top] = y_top_im;
			//X_Re[i_bot] = y_bot_re;
			//X_Im[i_bot] = y_bot_im;
			//x_top_re = X_Re[i_top];
			//x_top_im = X_Im[i_top];
			//x_bot_re = X_Re[i_bot];
			//x_bot_im = X_Im[i_bot];
			
		end
		else if(state == INIT)
		begin
			X_Re[init_addr] <= x_re_init;
			X_Im[init_addr] <= 32'd0;
		end
	end
	
	always @ (posedge Clk)
	begin
		if(Reset)
		begin
			state <= INIT;
			init_addr <= 0;			
		end
		else
		begin
			case(state)
				INIT:
				begin
					if(init_addr == 255)
						state <= IDLE;
					else
					begin
						init_addr <= init_addr + 1;
						state <= INIT;
					end
					
				end
			
				IDLE:
				begin
					if(Start)
						state <= PROC;
					else
						state <= IDLE;
				end
			
				PROC:
				begin
					if(Done)
						state <= DONE;
					else
						state <= PROC;
				end
			
				DONE:
				begin
					// Stay till reset
					state <= DONE;
				end
			
				default: state <= UNK;
			endcase
		end
	end
endmodule