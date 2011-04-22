// Top design for EE 201L Veritune Project
// By Chris Li, Grayson Smith, and Carey Zhang.

`timescale 1ns / 1ps

module veritune_top(ClkPort,
			St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar,
			Sw7, Sw2, Sw1, Sw0,
			Btn0, Btn3,
			//Mic,
			Ld0, Ld1, Ld3, Ld4, Ld5, Ld6, Ld7,
			An0, An1, An2, An3,
			Ca, Cb, Cc, Cd, Ce, Cf, Cg, 
			Dp,
			//Spkr
			);
	/*  INPUTS */
	// Clock & Reset I/O
	input		ClkPort;	
	// Project Specific Inputs
	input		Btn0, Btn3;	
	input		Sw7, Sw2, Sw1, Sw0;
	//input 	Mic;
	
	/*  OUTPUTS */
	// ROM drivers 	
	output 	St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar;
	// Project Specific Outputs
	// LEDs
	output 	Ld0, Ld1, Ld3, Ld4, Ld5, Ld6, Ld7;
	// SSD Outputs
	output 	Cg, Cf, Ce, Cd, Cc, Cb, Ca, Dp;
	output 	An0, An1, An2, An3;
	// Audio
	//output	Spkr;
	
	/*  LOCAL SIGNALS */
	wire			Reset, ClkPort;
	wire			board_clk, sys_clk;
	wire [1:0]	ssdscan_clk;
	reg [26:0]	DIV_CLK;
	
	wire Start_Stop_Pulse;
	wire Done_Shift;
	wire q_I, q_Rec, q_Stop, q_Shift, q_Play;
	reg [7:0] Freq;
	reg [3:0] SSD;
	wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	reg [7:0]  SSD_CATHODES;
//	wire Audio, Mic;
	
	localparam NEG = 4'b1111, BLANK = 4'b1110;

//------------
// CLOCK DIVISION

	// The clock division circuitary works like this:
	//
	// ClkPort ---> [BUFGP2] ---> board_clk
	// board_clk ---> [clock dividing counter] ---> DIV_CLK
	// DIV_CLK ---> [constant assignment] ---> sys_clk; 
	// In most of the designs, we may be actually using the 
	// full-speed 50MHz clock as the system clock (sys_clk)
	BUFGP BUFGP1 (board_clk, ClkPort); 	
	BUFGP BUFGP2 (Reset, Btn3);
	
	// Our clock is too fast (50MHz) for SSD scanning
	// create a series of slower "divided" clocks
	// each successive bit is 1/2 frequency

	always @ (posedge board_clk, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
      else
			// just incrementing makes our life easier
			DIV_CLK <= DIV_CLK + 1'b1;
	end	
	
	// pick a divided clock bit to assign to system clock
	// your decision should not be "too fast" or you will 
	// not see your state machine working one state at a time slowly
	//assign	sys_clk = DIV_CLK[24];

	// Let us use full-speed clock and use single-stepping to 
	// see our the operation of our design 
	assign	sys_clk = board_clk;
	
	// Disable the two memories on the board, since they are not used in this design
	assign {St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar} = {5'b11111};

//------------
// INPUT: SWITCHES & BUTTONS
	// Btn0 as Record, Stop, Play button. Only want debounced single pulse.
	// To make this possible, we need a single clock producing  circuit.

	ee201_debouncer #(.N_dc(24)) ee201_debouncer_2 
        (.CLK(sys_clk), .RESET(Reset), .PB(Btn0), .DPB( ), 
		.SCEN(Start_Stop_Pulse), .MCEN( ), .CCEN( ));
												
//------------
// DESIGN
	always @ (posedge sys_clk, posedge Reset)
	begin
		if(Reset)
		begin
			// Reset frequency inputs
		end
		else
		begin
			
		end
	end
	
	// the state machine module
	veritune_sm veritune_sm_1(
			.Clk(sys_clk),
			.Reset(Reset),
			.Rec(Start_Stop_Pulse),
			.Stop(Start_Stop_Pulse),
			.Play(Start_Stop_Pulse),
			.Done_Shift(Done_Shift),
			.Freq(Freq),
			.Audio_In(Mic),
			.q_I(q_I),
			.q_Rec(q_Rec),
			.q_Stop(q_Stop),
			.q_Shift(q_Shift),
			.q_Play(q_Play),
			.Audio_Out(Spkr)
	);
	
	// shifter module
	shifter shifter_1(
			.Clk(DIV_CLK[24]),
			.Reset(Reset),
			.Start(q_Shift),
			.Done(Done_Shift)
	);

//------------
// OUTPUT: LEDS
	
	assign {Ld7, Ld6, Ld5, Ld4, Ld3} = {q_I, q_Rec, q_Stop, q_Shift, q_Play};
	assign {Ld1, Ld0} = {Reset, Btn0}; // reset is driven by Btn3
	
//------------
// SSD (Seven Segment Display)
	
	assign SSD3 = (Sw7) ? NEG : BLANK;
	assign SSD2 = BLANK;
	assign SSD1 = BLANK;
	assign SSD0 = {1'b0, Sw2, Sw1, Sw0};


	// need a scan clk for the seven segment display 
	// 191Hz (50MHz / 2^18) works well
	// The anode order is changed here. According the SSD order below is also changed.
	assign ssdscan_clk = DIV_CLK[18:17];	
	assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1	= !(1'b0);  // when ssdscan_clk = 01
	assign An2	=  !(1'b0);  // when ssdscan_clk = 10
	assign An3	=  !((ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
				  2'b00: SSD = SSD0;
				  2'b01: SSD = SSD1;
				  2'b10: SSD = SSD2;
				  2'b11: SSD = SSD3;
		endcase 
	end
	
	// and finally convert SSD_num to ssd
	// normally we would convert the output of our 4-bit 4x1 mux
	//	but we have special output sets this time (L_Rbar)

	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES};

	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD) // in this solution file the dot points are made to glow by making Dp = 0
			4'b0000: SSD_CATHODES = 8'b00000011; // 0
			4'b0001: SSD_CATHODES = 8'b10011111; // 1
			4'b0010: SSD_CATHODES = 8'b00100101; // 2
			4'b0011: SSD_CATHODES = 8'b00001101; // 3
			4'b0100: SSD_CATHODES = 8'b10011001; // 4
			4'b0101: SSD_CATHODES = 8'b01001001; // 5
			4'b0110: SSD_CATHODES = 8'b01000001; // 6
			4'b0111: SSD_CATHODES = 8'b00011111; // 7
			4'b1000: SSD_CATHODES = 8'b00000001; // 8
			4'b1001: SSD_CATHODES = 8'b00001001; // 9
			4'b1110: SSD_CATHODES = 8'b11111111; // blank
			4'b1111: SSD_CATHODES = 8'b11111101; // - sign   
			default: SSD_CATHODES = 8'bXXXXXXXX; // default is not needed as we covered all cases
		endcase
	end	
	
endmodule

