`timescale 1ns / 1ps

module FFT1024_tb_v;
	parameter PRE = 32;
		
	reg Clk;
	reg Reset, Start, Ack;
	reg signed [PRE-1:0] X_Re [1023:0];
	reg signed [PRE-1:0] X_Im [1023:0];
	integer timestamp;
	
	// Outputs
	wire [3:0] state;
	wire Done;
	wire signed [31:0] x_top_re;
	wire signed [31:0] x_top_im;
	wire signed [31:0] x_bot_re;
	wire signed [31:0] x_bot_im;	
	wire signed [31:0] x0, x1, x2, x3, x4, x5, x6, x7;
	assign x0 = X_Re[0];
	assign x1 = X_Re[1];
	assign x2 = X_Re[2];
	assign x3 = X_Re[3];
	assign x4 = X_Re[4];
	assign x5 = X_Re[5];
	assign x6 = X_Re[6];
	assign x7 = X_Re[7];	
	
	// Internal
	wire signed [31:0] y_top_re;
	wire signed [31:0] y_top_im;
	wire signed [31:0] y_bot_re;
	wire signed [31:0] y_bot_im;
	wire [9:0]  i_top, i_bot;
	assign x_top_re = X_Re[i_top];
	assign x_top_im = X_Im[i_top];
	assign x_bot_re = X_Re[i_bot];
	assign x_bot_im = X_Im[i_bot];
	
		
	
	// Instantiate the Unit Under Test (UUT)
	FFT1024 uut (
		//	Ins
		.Clk(Clk),
		.Reset(Reset),
		.Start(Start),
		.Ack(Ack),
		.x_top_re(X_Re[i_top]),
		.x_top_im(X_Im[i_top]),
		.x_bot_re(X_Re[i_bot]),
		.x_bot_im(X_Im[i_bot]),
		//	Outs
		.i_top(i_top),
		.i_bot(i_bot),
		.y_top_re(y_top_re),
		.y_top_im(y_top_im),
		.y_bot_re(y_bot_re),
		.y_bot_im(y_bot_im),
		.Done(Done),
		.state(state)
	);
	
	
	initial
	begin
		Clk = 0; // Initialize clock
		Start = 0;
		Reset = 0;
	end
	
	// Keep clock running
	always
	begin
		#20; 
		Clk = ~ Clk; 
	end
	
	//	Here's how to use the butterfly unit
	always @(posedge Clk)
	begin
		timestamp <= timestamp + 1;
		case(state)
			4'd1: //Done
			begin
				$display("X[0]=%d + i%d", X_Re[0], X_Im[0]);
				$display("X[1]=%d + i%d", X_Re[1], X_Im[1]);
				$display("X[2]=%d + i%d", X_Re[2], X_Im[2]);
				$display("X[3]=%d + i%d", X_Re[3], X_Im[3]);
				$display("X[4]=%d + i%d", X_Re[4], X_Im[4]);
				$display("X[5]=%d + i%d", X_Re[5], X_Im[5]);
				$display("X[6]=%d + i%d", X_Re[6], X_Im[6]);
				$display("X[7]=%d + i%d", X_Re[7], X_Im[7]);
				Ack = 1;
			end
			4'd2: //Proc
			begin
				$display("Time: %d", timestamp);
				$display("  i_top %b i_bot %b", i_top, i_bot);
				$display("  x_top_re %d x_bot_re %d", X_Re[i_top], X_Re[i_bot]);
				$display("  y_top %d + i%d y_bot %d + i%d", y_top_re, y_top_im, y_bot_re, y_bot_im);
				X_Re[i_top] <= y_top_re;
				X_Im[i_top] <= y_top_im;
				X_Re[i_bot] <= y_bot_re;
				X_Im[i_bot] <= y_bot_im;
			end
		endcase
	end
	
	//	Just setup
	initial
	begin
		timestamp = 0;
		Start = 0;
		Reset = 0;
		Ack = 0;
		#10
		Reset = 1;
		#200
		// FFT
		X_Re[0]=32'd0; X_Re[128]=-32'd202; X_Re[64]=-32'd2459; X_Re[192]=-32'd1021; X_Re[32]=32'd202; X_Re[160]=32'd1248; X_Re[96]=32'd618; X_Re[224]=-32'd820; X_Re[16]=-32'd1021; X_Re[144]=-32'd2459; X_Re[80]=-32'd4123; X_Re[208]=-32'd4728; X_Re[48]=-32'd5939; X_Re[176]=-32'd6241; X_Re[112]=-32'd2459; X_Re[240]=-32'd416; X_Re[8]=-32'd1248; X_Re[136]=-32'd2459; X_Re[72]=32'd0; X_Re[200]=32'd2459; X_Re[40]=32'd4123; X_Re[168]=32'd5939; X_Re[104]=32'd4930; X_Re[232]=32'd4123; X_Re[24]=32'd2660; X_Re[152]=32'd1853; X_Re[88]=32'd0; X_Re[216]=-32'd2055; X_Re[56]=-32'd3114; X_Re[184]=-32'd1248; X_Re[120]=-32'd202; X_Re[248]=-32'd618; X_Re[4]=-32'd2459; X_Re[132]=-32'd3114; X_Re[68]=-32'd2459; X_Re[196]=-32'd2459; X_Re[36]=-32'd1021; X_Re[164]=-32'd1853; X_Re[100]=-32'd618; X_Re[228]=32'd820; X_Re[20]=32'd1853; X_Re[148]=32'd1853; X_Re[84]=32'd820; X_Re[212]=-32'd618; X_Re[52]=32'd820; X_Re[180]=32'd3518; X_Re[116]=32'd4123; X_Re[244]=32'd2660; X_Re[12]=32'd1021; X_Re[140]=32'd202; X_Re[76]=-32'd1021; X_Re[204]=32'd202; X_Re[44]=-32'd202; X_Re[172]=32'd820; X_Re[108]=32'd3921; X_Re[236]=32'd4930; X_Re[28]=32'd5334; X_Re[156]=32'd5334; X_Re[92]=32'd1652; X_Re[220]=32'd0; X_Re[60]=32'd202; X_Re[188]=-32'd202; X_Re[124]=-32'd3114; X_Re[252]=-32'd4123; X_Re[2]=-32'd4123; X_Re[130]=-32'd3720; X_Re[66]=-32'd1652; X_Re[194]=-32'd202; X_Re[34]=-32'd618; X_Re[162]=32'd618; X_Re[98]=32'd2660; X_Re[226]=32'd4728; X_Re[18]=32'd4930; X_Re[146]=32'd3518; X_Re[82]=32'd1652; X_Re[210]=32'd1853; X_Re[50]=32'd3921; X_Re[178]=32'd2459; X_Re[114]=32'd820; X_Re[242]=-32'd416; X_Re[10]=32'd618; X_Re[138]=32'd820; X_Re[74]=32'd1853; X_Re[202]=32'd1853; X_Re[42]=32'd1652; X_Re[170]=32'd820; X_Re[106]=-32'd202; X_Re[234]=-32'd820; X_Re[26]=-32'd1652; X_Re[154]=-32'd4728; X_Re[90]=-32'd3316; X_Re[218]=32'd1450; X_Re[58]=32'd2257; X_Re[186]=32'd1021; X_Re[122]=-32'd202; X_Re[250]=32'd0; X_Re[6]=32'd0; X_Re[134]=32'd2055; X_Re[70]=32'd3114; X_Re[198]=32'd2660; X_Re[38]=32'd3114; X_Re[166]=32'd2257; X_Re[102]=32'd1248; X_Re[230]=32'd618; X_Re[22]=-32'd3114; X_Re[150]=-32'd3518; X_Re[86]=-32'd618; X_Re[214]=32'd1652; X_Re[54]=32'd1652; X_Re[182]=32'd1450; X_Re[118]=32'd416; X_Re[246]=-32'd1853; X_Re[14]=-32'd2257; X_Re[142]=-32'd2459; X_Re[78]=-32'd2660; X_Re[206]=-32'd2459; X_Re[46]=-32'd3518; X_Re[174]=-32'd2913; X_Re[110]=-32'd2257; X_Re[238]=-32'd3316; X_Re[30]=-32'd4930; X_Re[158]=-32'd2459; X_Re[94]=32'd1853; X_Re[222]=32'd2913; X_Re[62]=32'd4123; X_Re[190]=32'd3921; X_Re[126]=32'd1853; X_Re[254]=32'd820; X_Re[1]=32'd2257; X_Re[129]=32'd1652; X_Re[65]=32'd820; X_Re[193]=32'd618; X_Re[33]=32'd1021; X_Re[161]=32'd1652; X_Re[97]=32'd416; X_Re[225]=-32'd2055; X_Re[17]=-32'd2660; X_Re[145]=-32'd2660; X_Re[81]=-32'd3518; X_Re[209]=-32'd3114; X_Re[49]=-32'd3518; X_Re[177]=-32'd3518; X_Re[113]=-32'd3114; X_Re[241]=-32'd202; X_Re[9]=32'd202; X_Re[137]=32'd416; X_Re[73]=32'd1853; X_Re[201]=32'd1853; X_Re[41]=32'd1853; X_Re[169]=32'd2257; X_Re[105]=32'd820; X_Re[233]=-32'd820; X_Re[25]=32'd618; X_Re[153]=32'd1248; X_Re[89]=32'd820; X_Re[217]=-32'd202; X_Re[57]=-32'd618; X_Re[185]=-32'd618; X_Re[121]=32'd1021; X_Re[249]=32'd3114; X_Re[5]=32'd3114; X_Re[133]=32'd3720; X_Re[69]=32'd1248; X_Re[197]=-32'd416; X_Re[37]=-32'd1652; X_Re[165]=-32'd5132; X_Re[101]=-32'd7452; X_Re[229]=-32'd6241; X_Re[21]=-32'd3720; X_Re[149]=-32'd2257; X_Re[85]=-32'd202; X_Re[213]=32'd202; X_Re[53]=-32'd416; X_Re[181]=32'd1450; X_Re[117]=32'd3921; X_Re[245]=32'd4325; X_Re[13]=32'd4930; X_Re[141]=32'd5132; X_Re[77]=32'd4123; X_Re[205]=32'd3518; X_Re[45]=32'd1248; X_Re[173]=-32'd1652; X_Re[109]=-32'd3518; X_Re[237]=-32'd1652; X_Re[29]=32'd618; X_Re[157]=32'd1021; X_Re[93]=32'd1652; X_Re[221]=32'd0; X_Re[61]=-32'd1248; X_Re[189]=-32'd1450; X_Re[125]=-32'd2055; X_Re[253]=-32'd1450; X_Re[3]=-32'd202; X_Re[131]=32'd0; X_Re[67]=32'd416; X_Re[195]=32'd820; X_Re[35]=-32'd618; X_Re[163]=-32'd1652; X_Re[99]=-32'd618; X_Re[227]=32'd1021; X_Re[19]=32'd1652; X_Re[147]=32'd3720; X_Re[83]=32'd2913; X_Re[211]=32'd1248; X_Re[51]=32'd1021; X_Re[179]=32'd1450; X_Re[115]=32'd1021; X_Re[243]=32'd820; X_Re[11]=32'd1450; X_Re[139]=32'd1853; X_Re[75]=32'd2660; X_Re[203]=32'd2055; X_Re[43]=32'd1021; X_Re[171]=-32'd202; X_Re[107]=-32'd416; X_Re[235]=-32'd618; X_Re[27]=-32'd416; X_Re[155]=-32'd1853; X_Re[91]=-32'd3921; X_Re[219]=-32'd4123; X_Re[59]=-32'd3921; X_Re[187]=-32'd3921; X_Re[123]=-32'd2459; X_Re[251]=-32'd1021; X_Re[7]=-32'd1450; X_Re[135]=-32'd416; X_Re[71]=32'd618; X_Re[199]=32'd618; X_Re[39]=32'd1021; X_Re[167]=32'd2660; X_Re[103]=32'd4527; X_Re[231]=32'd4728; X_Re[23]=32'd4123; X_Re[151]=32'd416; X_Re[87]=-32'd820; X_Re[215]=-32'd416; X_Re[55]=32'd416; X_Re[183]=32'd202; X_Re[119]=32'd1021; X_Re[247]=32'd202; X_Re[15]=-32'd1853; X_Re[143]=-32'd4325; X_Re[79]=-32'd5334; X_Re[207]=-32'd5535; X_Re[47]=-32'd4728; X_Re[175]=-32'd2660; X_Re[111]=-32'd202; X_Re[239]=32'd1450; X_Re[31]=32'd1450; X_Re[159]=32'd1021; X_Re[95]=32'd1652; X_Re[223]=32'd1248; X_Re[63]=32'd1021; X_Re[191]=32'd2257; X_Re[127]=32'd2660; X_Re[255]=32'd820; 
		X_Im[0]=32'd0; X_Im[1]=-32'd0; X_Im[2]=-32'd0; X_Im[3]=-32'd0; X_Im[4]=32'd0; X_Im[5]=32'd0; X_Im[6]=32'd0; X_Im[7]=-32'd0; X_Im[8]=-32'd0; X_Im[9]=-32'd0; X_Im[10]=-32'd0; X_Im[11]=-32'd0; X_Im[12]=-32'd0; X_Im[13]=-32'd0; X_Im[14]=-32'd0; X_Im[15]=-32'd0; X_Im[16]=-32'd0; X_Im[17]=-32'd0; X_Im[18]=32'd0; X_Im[19]=32'd0; X_Im[20]=32'd0; X_Im[21]=32'd0; X_Im[22]=32'd0; X_Im[23]=32'd0; X_Im[24]=32'd0; X_Im[25]=32'd0; X_Im[26]=32'd0; X_Im[27]=-32'd0; X_Im[28]=-32'd0; X_Im[29]=-32'd0; X_Im[30]=-32'd0; X_Im[31]=-32'd0; X_Im[32]=-32'd0; X_Im[33]=-32'd0; X_Im[34]=-32'd0; X_Im[35]=-32'd0; X_Im[36]=-32'd0; X_Im[37]=-32'd0; X_Im[38]=-32'd0; X_Im[39]=32'd0; X_Im[40]=32'd0; X_Im[41]=32'd0; X_Im[42]=32'd0; X_Im[43]=-32'd0; X_Im[44]=32'd0; X_Im[45]=32'd0; X_Im[46]=32'd0; X_Im[47]=32'd0; X_Im[48]=32'd0; X_Im[49]=32'd0; X_Im[50]=-32'd0; X_Im[51]=32'd0; X_Im[52]=-32'd0; X_Im[53]=32'd0; X_Im[54]=32'd0; X_Im[55]=32'd0; X_Im[56]=32'd0; X_Im[57]=32'd0; X_Im[58]=32'd0; X_Im[59]=32'd0; X_Im[60]=32'd0; X_Im[61]=-32'd0; X_Im[62]=-32'd0; X_Im[63]=-32'd0; X_Im[64]=-32'd0; X_Im[65]=-32'd0; X_Im[66]=-32'd0; X_Im[67]=-32'd0; X_Im[68]=-32'd0; X_Im[69]=32'd0; X_Im[70]=32'd0; X_Im[71]=32'd0; X_Im[72]=32'd0; X_Im[73]=32'd0; X_Im[74]=32'd0; X_Im[75]=32'd0; X_Im[76]=32'd0; X_Im[77]=32'd0; X_Im[78]=32'd0; X_Im[79]=-32'd0; X_Im[80]=32'd0; X_Im[81]=32'd0; X_Im[82]=32'd0; X_Im[83]=32'd0; X_Im[84]=32'd0; X_Im[85]=32'd0; X_Im[86]=-32'd0; X_Im[87]=-32'd0; X_Im[88]=-32'd0; X_Im[89]=-32'd0; X_Im[90]=-32'd0; X_Im[91]=32'd0; X_Im[92]=32'd0; X_Im[93]=32'd0; X_Im[94]=-32'd0; X_Im[95]=32'd0; X_Im[96]=32'd0; X_Im[97]=32'd0; X_Im[98]=32'd0; X_Im[99]=32'd0; X_Im[100]=32'd0; X_Im[101]=32'd0; X_Im[102]=32'd0; X_Im[103]=32'd0; X_Im[104]=-32'd0; X_Im[105]=-32'd0; X_Im[106]=-32'd0; X_Im[107]=32'd0; X_Im[108]=32'd0; X_Im[109]=32'd0; X_Im[110]=32'd0; X_Im[111]=-32'd0; X_Im[112]=-32'd0; X_Im[113]=-32'd0; X_Im[114]=-32'd0; X_Im[115]=-32'd0; X_Im[116]=-32'd0; X_Im[117]=-32'd0; X_Im[118]=-32'd0; X_Im[119]=-32'd0; X_Im[120]=-32'd0; X_Im[121]=-32'd0; X_Im[122]=32'd0; X_Im[123]=32'd0; X_Im[124]=32'd0; X_Im[125]=32'd0; X_Im[126]=32'd0; X_Im[127]=32'd0; X_Im[128]=32'd0; X_Im[129]=32'd0; X_Im[130]=32'd0; X_Im[131]=32'd0; X_Im[132]=32'd0; X_Im[133]=32'd0; X_Im[134]=32'd0; X_Im[135]=-32'd0; X_Im[136]=-32'd0; X_Im[137]=-32'd0; X_Im[138]=-32'd0; X_Im[139]=-32'd0; X_Im[140]=-32'd0; X_Im[141]=-32'd0; X_Im[142]=-32'd0; X_Im[143]=-32'd0; X_Im[144]=32'd0; X_Im[145]=32'd0; X_Im[146]=32'd0; X_Im[147]=32'd0; X_Im[148]=32'd0; X_Im[149]=32'd0; X_Im[150]=32'd0; X_Im[151]=-32'd0; X_Im[152]=32'd0; X_Im[153]=32'd0; X_Im[154]=32'd0; X_Im[155]=-32'd0; X_Im[156]=-32'd0; X_Im[157]=-32'd0; X_Im[158]=32'd0; X_Im[159]=32'd0; X_Im[160]=32'd0; X_Im[161]=32'd0; X_Im[162]=32'd0; X_Im[163]=-32'd0; X_Im[164]=-32'd0; X_Im[165]=-32'd0; X_Im[166]=-32'd0; X_Im[167]=-32'd0; X_Im[168]=-32'd0; X_Im[169]=-32'd0; X_Im[170]=-32'd0; X_Im[171]=32'd0; X_Im[172]=-32'd0; X_Im[173]=32'd0; X_Im[174]=32'd0; X_Im[175]=32'd0; X_Im[176]=32'd0; X_Im[177]=32'd0; X_Im[178]=32'd0; X_Im[179]=32'd0; X_Im[180]=32'd0; X_Im[181]=-32'd0; X_Im[182]=-32'd0; X_Im[183]=-32'd0; X_Im[184]=32'd0; X_Im[185]=32'd0; X_Im[186]=32'd0; X_Im[187]=32'd0; X_Im[188]=-32'd0; X_Im[189]=-32'd0; X_Im[190]=-32'd0; X_Im[191]=-32'd0; X_Im[192]=-32'd0; X_Im[193]=32'd0; X_Im[194]=32'd0; X_Im[195]=32'd0; X_Im[196]=-32'd0; X_Im[197]=-32'd0; X_Im[198]=-32'd0; X_Im[199]=32'd0; X_Im[200]=32'd0; X_Im[201]=32'd0; X_Im[202]=32'd0; X_Im[203]=32'd0; X_Im[204]=32'd0; X_Im[205]=32'd0; X_Im[206]=32'd0; X_Im[207]=32'd0; X_Im[208]=32'd0; X_Im[209]=32'd0; X_Im[210]=32'd0; X_Im[211]=32'd0; X_Im[212]=32'd0; X_Im[213]=-32'd0; X_Im[214]=-32'd0; X_Im[215]=-32'd0; X_Im[216]=-32'd0; X_Im[217]=-32'd0; X_Im[218]=-32'd0; X_Im[219]=-32'd0; X_Im[220]=-32'd0; X_Im[221]=-32'd0; X_Im[222]=-32'd0; X_Im[223]=-32'd0; X_Im[224]=-32'd0; X_Im[225]=-32'd0; X_Im[226]=32'd0; X_Im[227]=32'd0; X_Im[228]=32'd0; X_Im[229]=32'd0; X_Im[230]=32'd0; X_Im[231]=32'd0; X_Im[232]=32'd0; X_Im[233]=32'd0; X_Im[234]=-32'd0; X_Im[235]=-32'd0; X_Im[236]=32'd0; X_Im[237]=32'd0; X_Im[238]=32'd0; X_Im[239]=32'd0; X_Im[240]=-32'd0; X_Im[241]=-32'd0; X_Im[242]=-32'd0; X_Im[243]=-32'd0; X_Im[244]=-32'd0; X_Im[245]=-32'd0; X_Im[246]=-32'd0; X_Im[247]=32'd0; X_Im[248]=32'd0; X_Im[249]=32'd0; X_Im[250]=32'd0; X_Im[251]=32'd0; X_Im[252]=32'd0; X_Im[253]=32'd0; X_Im[254]=32'd0; X_Im[255]=32'd0; 
		#10
		Reset = 0;
		#10
		
		Start = 1;
		#130
		Start = 0;
	end

endmodule