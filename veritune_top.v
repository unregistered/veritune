// Top design for EE 201L Veritune Project
// By Chris Li, Grayson Smith, and Carey Zhang.

//`timescale 1ns / 1ps

module veritune_top(ClkPort,
			St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar,
			Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0,
			//Btn0, Btn1, Btn2, Btn3,
			Btn0, Btn3,
			Ld0, Ld1, Ld2, Ld3, Ld4, Ld5, Ld6, Ld7,
			An0, An1, An2, An3,
			Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
			EppAstb, EppDstb, EppWr, EppDB, EppWait	// EPP communication signals	 
			);
//port declarations

	parameter PRE = 32;

    /*  INPUTS */
	// Clock & Reset I/O
	input		ClkPort;	
	// Project Specific Inputs
//	input Btn0, Btn1, Btn2, Btn3;
	input Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0;
	input		Btn0, Btn3;	
//	input		Sw7, Sw2, Sw1, Sw0;	
	
	/*  OUTPUTS */
	// ROM drivers 	
	output 	St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar;
	// Project Specific Outputs
	// LEDs
	output Ld0, Ld1, Ld2, Ld3, Ld4, Ld5, Ld6, Ld7;
//	output 	Ld0, Ld1, Ld4, Ld5, Ld6, Ld7;
	// SSD Outputs
	output 	Cg, Cf, Ce, Cd, Cc, Cb, Ca, Dp;
	output 	An0, An1, An2, An3;	
	
	//io expansion ports
	input			EppAstb, EppDstb, EppWr;
   inout [7:0]	EppDB;
   output		EppWait;
	
	/*  LOCAL SIGNALS */
	wire		Reset, ClkPort;
	wire		board_clk, sys_clk;
	wire [1:0]	ssdscan_clk;
	reg [26:0]	DIV_CLK;
	
	reg [3:0] SSD;
	wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	reg [7:0]  SSD_CATHODES;
		
	// virtual I/O signals
	
	reg [7:0]  Led;		// 0x01       8 virtual LEDs on the PC I/O Ex GUI
   reg [23:0] LBar;		// 0x02..4   24 lights on the PC I/O Ex GUI light bar
   reg [15:0] Sw;		// 0x05..6   16 switches, bottom row on the PC I/O Ex GUI
   reg [15:0] Btn;
   //reg [31:0] dwOut;
	reg [31:0] dwIn;		// 0x0d..10  32 Bits user input
	
	//File i/o intermediate signals
	reg [7:0] regEppAdr; //address register
   reg [7:0] regVer; //I/O returns the complement of written value
   reg [7:0] busEppInternal; //internal bus (before tristate)
  //------------------------------------------------------------------------------------------------------------------
   wire [9:0]  Addr; // address going to user register file here it is 4 bits
   //reg We; // Write Enable, Read Enable; //control signals to user reg file
   reg  [15:0] Data_to;
	wire [15:0] Data_from; //data to be written to reg file
  //-----------------------------------------------------------------------------------------------------------------  
   reg [20:0] state;    //for the one hot state assignment
   reg [31:0] regarray [0:1023]; //declaration of 16 x 32 bit register array
   reg [3:0] regfile [0:7]; // the register array to manipulate bits
  
	//state declarations
	localparam
	Idle            = 21'd1,       //idle state(1)
	A_Rd_finish     = 21'd2,       //finish reading from address register (2)
	A_Wr_start      = 21'd4,       //start writing to address register(3) 
	A_Wr_finish     = 21'd8,       //finish writing from address register(4)
	Other_Rd_finish = 21'd16,      //finish reading from other than pointer and register array (5)
	Other_Wr_finish = 21'd32,      //finish writing to other than pointer and register array   (6)
	Other_Wr_start  = 21'd64,      //start writing to other than pointer and register array     (7)
	Pntr_Rd_start   = 21'd128,     //start reading the pointer (8)						 
	Pntr_Rd_finish  = 21'd256,     //finish reading the pointer(9)
	Pntr_Wr_start   = 21'd512,     //start writing the pointer(10)
	Pntr_Wr_finish  = 21'd1024,    //finish writing the pointer(11)
	Rd_start_1_8    = 21'd2048,    //start reading register array (12)
	Rd_finish_1_8   = 21'd4096,    //finish reading register array(13)
	Rd_start_9_10   = 21'd8192,    //deals with carriage return and line feed (14)
	Rd_finish_9_10  = 21'd16384,   //deals with carriage return and line feed (15)
	Wr_start_1_8    = 21'd32768,   //start writing register file (16)
	Wr_finish_1_8   = 21'd65536,   //finish writing register array(17)
	Wr_start_9_10   = 21'd131072,  //deals with carriage return and line feed  (18)
	Wr_finish_9_10  = 21'd262144,  //deals with carriage return and line feed (19)
	Inc_nib_count   = 21'd524288,  //increment the nibble counter (20)
	Inc_mem_pntr    = 21'd1048576; //increment the mem_pointer (21)                   
																							
	// constant declarations 
	localparam
	addr_pointer = 8'b00101000, //40 dec - 28 hex
	addr_regfile = 8'b00101001, //41 dec - 29 hex
	NEG = 4'b1111, BLANK = 4'b1110;	// for SSDs

	//intermediate signal declarations
	wire En_A_rd, En_rd, En_A_wr, En_wr, En_pntr_rd, En_pntr_wr, En_other_rd; // all the read and write enable signals
	wire En_reg_wr, En_reg_rd; // read and write signals for register file (temporary)
	reg  Astb_S, Dstb_S, Astb_SS, Dstb_SS; //signals used for double synchronizing address and data strobe
	reg [7:0] D_int1, D_int2, D_int3; //signals used for registering the Eppdata
	reg [7:0] A_int1, A_int2, A_int3; //signals used for registering the EppAddress
	wire wait_Epp; // internal signal used for EppWait;
	reg [9:0] pointer; //pointer to register array
	reg [1:0] i; //internal counter
	reg [2:0] nib_count; //to count the nibbles
	reg [7:0] nib_on_file; //show the nibbles on the file
	wire [9:0] show_addr;

	//intermediate signals for data conversion
	reg [3:0] BINARY, binary_in;
	reg [7:0] ASCII, ascii_out;
	
//---------------------------------------------------------------------------	
	// For FFT
	// For FFT
//	wire signed [PRE-1:0] X_Re [1023:0];
	wire signed [PRE-1:0] X_Im [1023:0];
	// Outputs
	wire Done;
	wire signed [31:0] x_top_re;
	wire signed [31:0] x_top_im;
	wire signed [31:0] x_bot_re;
	wire signed [31:0] x_bot_im;	
	wire signed [31:0] x0, x1, x2, x3, x4, x5, x6, x7;
	assign x0 = regarray[0];
	assign x1 = regarray[1];
	assign x2 = regarray[2];
	assign x3 = regarray[3];
	assign x4 = regarray[4];
	assign x5 = regarray[5];
	assign x6 = regarray[6];
	assign x7 = regarray[7];	
	
	// Internal
	wire signed [31:0] y_top_re;
	wire signed [31:0] y_top_im;
	wire signed [31:0] y_bot_re;
	wire signed [31:0] y_bot_im;
	wire [9:0]  i_top, i_bot;
	assign x_top_re = regarray[i_top];
	assign x_top_im = X_Im[i_top];
	assign x_bot_re = regarray[i_bot];
	assign x_bot_im = X_Im[i_bot];
//-------------------------------------------------------------------------

	// Clk signal travels throughout our design,
	// it is necessary to provide global routing to this signal. 
	// The BUFGPs buffer the input ports and connect them to the global 
	// routing resources in the FPGA.
	BUFGP BUFGP1 (board_clk, ClkPort); 	

	assign Reset = Btn3;
	
	// In this design, we run the core design at full 50MHz clock!
	assign	sys_clk = board_clk;
	
	// Disable the two memories on the board, since they are not used in this design
	assign {St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar} = {5'b11111};
//	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {8{1}}; //disable cathodes
	
    //assign switches to LED's (just like that)	
//	assign {Ld7, Ld6, Ld5, Ld4, Ld3, Ld2, Ld1, Ld0} = {Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0};
	assign {Ld7, Ld6, Ld5, Ld4, Ld3, Ld2, Ld1, Ld0} = {6'b111111, Btn0, Done};
//	assign {An0,An1,An2,An3} = {Btn0,Btn1,Btn2,Btn3};
	
//	// LED assignments
//	assign {Ld7, Ld6, Ld5, Ld4} = {4'b1111};
//	assign {Ld1, Ld0} = {Reset, Btn0}; // reset is driven by Btn3
	
	assign Addr = pointer; //address to the register array
	
	// Epp signals
	// Port signals
	
	assign EppWait = wait_Epp;
	
	//bufif1 EppDB_buf(EppDB, busEppInternal, EppWr);
	assign EppDB = EppWr ? busEppInternal : 8'bZ ;
	
	// Clock division
	always @ (posedge board_clk, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
      else
			// just incrementing makes our life easier
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	
	// SSDs
	assign SSD3 = regarray[show_addr][15:12];
	assign SSD2 = regarray[show_addr][11:8];
	assign SSD1 = regarray[show_addr][7:4];
	assign SSD0 = regarray[show_addr][3:0];
//	assign SSD3 = (~Btn0) ? regarray[show_addr][31:28] : regarray[show_addr][15:12];
//	assign SSD2 = (~Btn0) ? regarray[show_addr][27:24] : regarray[show_addr][11:8];
//	assign SSD1 = (~Btn0) ? regarray[show_addr][23:20] : regarray[show_addr][7:4];
//	assign SSD0 = (~Btn0) ? regarray[show_addr][19:16] : regarray[show_addr][3:0];
	
	// need a scan clk for the seven segment display 
	// 191Hz (50MHz / 2^18) works well
	// The anode order is changed here. According the SSD order below is also changed.
	assign ssdscan_clk = DIV_CLK[18:17];	
	assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1	= !(~(ssdscan_clk[1]) && (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2	= !((ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3	= !((ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	
	
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
			4'b1010: SSD_CATHODES = 8'b00010000; // A
			4'b1011: SSD_CATHODES = 8'b11000000; // B
			4'b1100: SSD_CATHODES = 8'b01100010; // C
			4'b1101: SSD_CATHODES = 8'b10000100; // D
			4'b1110: SSD_CATHODES = 8'b01100000; // E
			4'b1111: SSD_CATHODES = 8'b01110000; // F    
			default: SSD_CATHODES = 8'bXXXXXXXX; // default is not needed as we covered all cases
		endcase
	end	
	
	always @(*) // for busEppInternal
	begin
		if (En_A_rd)
			busEppInternal = regEppAdr;
		else if (En_rd)
		   busEppInternal = nib_on_file; //this is nibble being outputted to file
		else if (En_pntr_rd)
		   busEppInternal = pointer;
		else if (En_other_rd)
         busEppInternal = regVer;    		
		else 
			begin
				case (regEppAdr) 
					'h00: 		busEppInternal = regVer;
					'h01: 		busEppInternal = Led;
					'h02: 		busEppInternal = LBar[7:0];
					'h03: 		busEppInternal = LBar[15:8];
					'h04: 		busEppInternal = LBar[23:16];
					'h0d: 		busEppInternal = dwIn[7:0];
					'h0e: 		busEppInternal = dwIn[15:8];
					'h0f:			busEppInternal = dwIn[23:16];
					default:		busEppInternal = dwIn[31:24]; // i.e for regEppAdr == 'h10
				endcase
			end
	end
    
   //output function logic
	assign En_A_rd = (state == A_Rd_finish)? 1'b1: 1'b0;
	assign En_other_rd =(state == Other_Rd_finish)? 1'b1 : 1'b0;
	assign En_reg_rd = 1'b1; //always read the register file
	assign En_reg_wr = ((state == Wr_start_1_8) ||( state == Wr_finish_1_8))? 1'b1: 1'b0;
	assign En_rd  = ((state == Rd_start_1_8)|| (state == Rd_finish_1_8)) || ((state == Rd_start_9_10) || (state == Rd_finish_9_10)) ? 1'b1: 1'b0;
	assign En_pntr_rd = (state == Pntr_Rd_start) || (state == Pntr_Rd_finish)? 1'b1: 1'b0;
	assign En_A_wr = (state == A_Wr_start)||( state == A_Wr_finish)? 1'b1: 1'b0;
	assign En_wr = (state == Wr_start_9_10)||( state == Wr_finish_9_10)? 1'b1: 1'b0;
	assign En_pntr_wr = (state == Pntr_Wr_start) || (state == Pntr_Wr_finish) ? 1'b1 :1'b0;

   assign wait_Epp = (((((state == A_Wr_start) || (state == Wr_start_9_10))||
                     ((state == Rd_start_9_10) || (state == Pntr_Wr_start)))||
	                  (((state == Pntr_Wr_start) || (state == Pntr_Rd_start)) ||
						   ((state == Idle)||(state == Other_Wr_start))))||
						   (((state == Other_Wr_start)||(state == Wr_start_1_8))||
						   (state == Rd_start_1_8)))? 1'b0 : 1'b1;  //active low signal
	
	assign show_addr = {1'b1, 1'b1, Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0};
	
   always @(*) // for nibble on file
	begin	
		case(nib_count)
			'h8: nib_on_file = 'h0D; //carriage return --0D
			'h9: nib_on_file = 'h0A; //line feed --0A
			default: nib_on_file = ascii_out; //the nibble being read from register array
		endcase
	end
	  
	//**********************************************************************
	always @(*) //for binary to ASCII converter
	begin
		case(BINARY)
			'h0: ascii_out = 'h30;
			'h1: ascii_out = 'h31;
			'h2: ascii_out = 'h32;
			'h3: ascii_out = 'h33;
			'h4: ascii_out = 'h34;
			'h5: ascii_out = 'h35;
			'h6: ascii_out = 'h36;
			'h7: ascii_out = 'h37;
			'h8: ascii_out = 'h38;
			'h9: ascii_out = 'h39;
			default: ascii_out = 'h30;
		endcase
	end
	//**************************************************************************
      
	//**********************************************************************
	always @(*) //for ASCII to binary converter
	begin
		case(ASCII)        
			'h30: binary_in = 'h0;
			'h31: binary_in = 'h1;
			'h32: binary_in = 'h2;
			'h33: binary_in = 'h3;
			'h34: binary_in = 'h4;
			'h35: binary_in = 'h5;
			'h36: binary_in = 'h6;
			'h37: binary_in = 'h7;
			'h38: binary_in = 'h8;
			'h39: binary_in = 'h9;
			default: binary_in = 'h0;
		endcase
	end
	//**************************************************************************
	
	//****************************************************************************
	always @(*) //for writing to file in reverse nibble by nibble
	begin
		case(nib_count)
			'h3: BINARY = Data_from[3:0];
			'h2: BINARY = Data_from[7:4];
			'h1: BINARY = Data_from[11:8];
			default: BINARY = Data_from[15:12];
//			'h7: BINARY = Data_from[3:0];
//			'h6: BINARY = Data_from[7:4];
//			'h5: BINARY = Data_from[11:8];
//			'h4: BINARY = Data_from[15:12];
//			'h3: BINARY = Data_from[19:16];
//			'h2: BINARY = Data_from[23:20];
//			'h1: BINARY = Data_from[27:24];
//			default: BINARY = Data_from[31:28];
//		   'h7: BINARY = Data_from[31:28];
//		   'h6: BINARY = Data_from[27:24];
//		   'h5: BINARY = Data_from[23:20];
//		   'h4: BINARY = Data_from[19:16];
//		   'h3: BINARY = Data_from[15:12];
//		   'h2: BINARY = Data_from[11:8];
//		   'h1: BINARY = Data_from[7:4];
//		   default: BINARY = Data_from[3:0];
		endcase
	end
	//*******************************************************************************
	  
	//*******************************************************************
	//to write to the temporary register file
	always @(posedge sys_clk)
	begin
	   if(En_reg_wr)
			regfile[nib_count] <= binary_in;
	end
	//********************************************************************
	//to write to the target register file
	always @(posedge sys_clk)
	begin
	   if(En_wr)
			regarray[Addr]<= Data_to;
	end
	//***********************************************************************
	//reading from the target register file
	//assign Data_from = regarray[Addr]; //reading continuously
	
	// Epp signals
	// Port signals
   assign EppWait = wait_Epp;
   
   //for double synchronizing to safeguard against metastability
   //###########################################################
   always @(posedge sys_clk, posedge Reset)
	begin: double_sync
	   if (Reset)
	   begin
			Astb_S  <= 1'b1; Dstb_S  <= 1'b1; 
			Astb_SS <= 1'b1; Dstb_SS <= 1'b1;
		end
	   else
	   begin
			Astb_S  <= EppAstb;
			Astb_SS <= Astb_S;
			Dstb_S  <= EppDstb;
			Dstb_SS <= Dstb_S;
	   end
   end
   //##############################################################	
  
  
   //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   //the state machine begins here
	always @ (posedge sys_clk, posedge Reset)
	begin
		if (Reset)
		begin
			state <= Idle;
	      i <= 2'bxx;    
	      pointer <= 0; 
         nib_count <= 0;		 
         D_int1 <= 8'bxxxxxxxx;
		   D_int2 <= 8'bxxxxxxxx;
		   D_int3 <= 8'bxxxxxxxx;
		   A_int1 <= 8'bxxxxxxxx;
		   A_int2 <= 8'bxxxxxxxx;
		   A_int3 <= 8'bxxxxxxxx;
		   ASCII  <= 8'bxxxxxxxx;
         regVer <= 8'bxxxxxxxx;
         regEppAdr <= 8'bxxxxxxxx;		
		end
		else
		begin
      case (state)
			Idle	: 
	      begin
				// CU transitions
				if(~Astb_SS) 
				begin
					if(~EppWr)
						state <= A_Wr_start;
					else
						state <= A_Rd_finish;
				end					
				else
				begin
					if(~Dstb_SS)
					begin
						if(~EppWr)
						begin
							if(regEppAdr == addr_regfile)
								if((nib_count == 3'b101)||(nib_count == 3'b100))
									state <= Wr_start_9_10;
								else
									state <= Wr_start_1_8;
							else
								if(regEppAdr == addr_pointer)
									state <= Pntr_Wr_start;
								else
									state <= Other_Wr_start;	  
						end	 
						else
						begin
						if (regEppAdr == addr_regfile)
							if((nib_count == 3'b101)||(nib_count == 3'b100))
								state <= Rd_start_9_10;
							else
								state <= Rd_start_1_8;	 
						else
							if(regEppAdr == addr_pointer)
								state <= Pntr_Rd_start;
							else
								state <= Other_Rd_finish;	
						end 
					end	
					else						
						if (Astb_SS & Dstb_SS)
							state <= Idle;
				end
				
				//DPU RTL				
				i <= 0;   
			end
			A_Rd_finish:
			begin	
				//CU state transitions
				if (Astb_SS)
					state <= Idle;       
				//DPU RTL
				i <= 0;  
			end				
			A_Wr_start:
			begin          
				// CU state transitions  
				if ( i == 2'b11)
					state <= A_Wr_finish;
				// DPU RTL
				i <= i + 1;
				A_int1 <= EppDB;
				A_int2 <= A_int1;
				A_int3 <= A_int2;
				regEppAdr <= A_int3;
			end
			A_Wr_finish:
			begin		
				//CU state transitions
				if (Astb_SS)
					state <= Idle;
				//DPU RTL
				A_int1 <= EppDB;
				A_int2 <= A_int1;
				A_int3 <= A_int2;
				regEppAdr <= A_int3;
			end	  
			Other_Rd_finish:
			begin            
				//CU state transitions  
				if ( Dstb_SS)
					state <= Idle;
				//DPU RTL
				//NO DPU RTL 
			end		
			Other_Wr_start:
			begin
				//CU state transitions  
				if ( i == 2'b11)
					state <= Other_Wr_finish;
				//DPU RTL
				i <= i + 1;
				D_int1 <= ~(EppDB);  //applicable only for regeppaddr = x00
				D_int2 <= D_int1;
				D_int3 <= D_int2;  
				regEppAdr <= D_int3;
			end		  	
			Other_Wr_finish:
			begin
				//CU state transitions
				if (Dstb_SS)
					state <= Idle;
				//DPU RTL
				D_int1 <= ~(EppDB); //applicable only for regeppaddr = x00
				D_int2 <= D_int1;
				D_int3 <= D_int2;
				regEppAdr <= D_int3;
			end		    
			Pntr_Rd_start:
			begin
				//CU state transitions  
				if ( i == 2'b11)
					state <= Pntr_Rd_finish;
				//DPU RTL
				i <= i + 1;
			end		  
			Pntr_Rd_finish:
			begin
				//CU state transitions  
				if ( Dstb_SS)
					state <= Idle;          
				//DPU RTL
				//NO DPU RTL
			end
			Pntr_Wr_start:
			begin           
				//CU state transitions  
				if ( i == 4'b11)
					state <= Pntr_Wr_finish;                        
				//DPU RTL
				i <= i + 1;
				D_int1 <= EppDB;
				D_int2 <= D_int1;
				D_int3 <= D_int2;
				pointer <= D_int3;
			end
			Pntr_Wr_finish:
			begin           
				//CU state transitions  
				if (Dstb_SS)
					state <= Idle;                        
				//DPU RTL
				D_int1 <= EppDB;
				D_int2 <= D_int1;
				D_int3 <= D_int2;
				pointer <= D_int3;
			end
			Rd_start_1_8:
			begin
				//CU state transitions  
				if ( i == 2'b11)
					state <= Rd_finish_1_8;                    
				//DPU RTL
				i <= i + 1;
			end 	
			Rd_finish_1_8:
			begin 
				//CU state transitions  
				if( Dstb_SS)
					state <= Inc_nib_count;        
				//DPU RTL
				//NO DPU RTL
			end
			Rd_start_9_10:
			begin
				//CU state transitions  
				if ( i == 4'b11)
					state <= Rd_finish_9_10;
				//DPU RTL
				i <= i + 1;
			end	
			Rd_finish_9_10:
			begin
			//CU state transitions  
				if ( Dstb_SS)
					state <= Inc_nib_count;        
				//DPU RTL
				//NO DPU RTL
			end	  
			Wr_start_1_8:
			begin                          
				//CU state transitions  
				if ( i == 4'b11)
					state <= Wr_finish_1_8;
				//DPU RTL
				i <= i + 1;
				D_int1 <= EppDB;
				D_int2 <= D_int1;
				D_int3 <= D_int2; 
				ASCII <= D_int3; //the data read from the file
			end
			Wr_finish_1_8:
			begin           
				//CU state transitions  
				if(Dstb_SS) 
					state <= Inc_nib_count;
				//DPU RTL
				D_int1 <= EppDB;
				D_int2 <= D_int1;
				D_int3 <= D_int2;
				ASCII <=  D_int3; //the data read from the file
			end

			Wr_start_9_10:
			begin
				//CU state transitions  
				if ( i == 4'b11)
					state <= Wr_finish_9_10;            
				//DPU RTL
				i <= i + 1;
				Data_to <= {regfile[0],regfile[1],regfile[2],regfile[3]};
			end
			Wr_finish_9_10:
			begin           
				//CU state transitions  
				if(Dstb_SS) 
					state <= Inc_nib_count;						 
				//DPU RTL
				Data_to <= {regfile[0],regfile[1],regfile[2],regfile[3]};
			end
			Inc_nib_count:
			begin
				//CU state transitions 
				if(nib_count < 3'b101)			 
					state <= Idle;
				else
					state <= Inc_mem_pntr;				            
				//DPU RTL
				nib_count <= nib_count + 1;
			end 
			Inc_mem_pntr:
			begin
				//CU state transitions			
				state <= Idle;        
				//DPU RTL
				pointer <= pointer + 1;
				nib_count <= 0;
			end
			default: state <= Idle;
		endcase
		end
	end
	
	
	FFT1024 uut (
		//	Ins
		.Clk(sys_clk),
		.Reset(Reset),
		.Start(Btn0),
		.Ack(Btn0),
		.x_top_re(regarray[i_top]),
		.x_top_im(X_Im[i_top]),
		.x_bot_re(regarray[i_bot]),
		.x_bot_im(X_Im[i_bot]),
		//	Outs
		.i_top(i_top),
		.i_bot(i_bot),
		.y_top_re(y_top_re),
		.y_top_im(y_top_im),
		.y_bot_re(y_bot_re),
		.y_bot_im(y_bot_im),
		.Done(Done)
	);

endmodule
