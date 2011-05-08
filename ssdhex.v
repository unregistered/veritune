module ssdhex(
	input wire Clk,
	input wire Reset,
	input wire [3:0] SSD0,
	input wire [3:0] SSD1,
	input wire [3:0] SSD2,
	input wire [3:0] SSD3,
	input wire Active,
	output wire [3:0] Enables,
	output reg [7:0] Cathodes
);
	wire [1:0]	ssdscan_clk;
	reg [26:0]	DIV_CLK;
	reg [3:0] SSD;
	
	// Clock division
	always @ (posedge Clk, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
      else
			// just incrementing makes our life easier
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	
	assign ssdscan_clk = DIV_CLK[18:17];	
	assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1	= !(~(ssdscan_clk[1]) && (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2	= !((ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3	= !((ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	assign Enables = {An3, An2, An1, An0};
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
				  2'b00: SSD = SSD0;
				  2'b01: SSD = SSD1;
				  2'b10: SSD = SSD2;
				  2'b11: SSD = SSD3;
		endcase 
	end
	
	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		if(Active)
		begin
			case (SSD) // in this solution file the dot points are made to glow by making Dp = 0
				4'b0000: Cathodes = 8'b00000011; // 0
				4'b0001: Cathodes = 8'b10011111; // 1
				4'b0010: Cathodes = 8'b00100101; // 2
				4'b0011: Cathodes = 8'b00001101; // 3
				4'b0100: Cathodes = 8'b10011001; // 4
				4'b0101: Cathodes = 8'b01001001; // 5
				4'b0110: Cathodes = 8'b01000001; // 6
				4'b0111: Cathodes = 8'b00011111; // 7
				4'b1000: Cathodes = 8'b00000001; // 8
				4'b1001: Cathodes = 8'b00001001; // 9
				4'b1010: Cathodes = 8'b00010000; // A
				4'b1011: Cathodes = 8'b11000000; // B
				4'b1100: Cathodes = 8'b01100010; // C
				4'b1101: Cathodes = 8'b10000100; // D
				4'b1110: Cathodes = 8'b01100000; // E
				4'b1111: Cathodes = 8'b01110000; // F 
				default: Cathodes = 8'bXXXXXXXX; // default is not needed as we covered all cases
			endcase
		end
		else
			Cathodes = 8'b11111111;
	end	
	
endmodule