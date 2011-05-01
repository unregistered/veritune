`timescale 1ns / 1ps

module FFT1024_LUT_tb_v;

	reg Clk;
	reg Reset, Start;
	reg [9:0] address;
	
	wire signed [15:0] coeff_real;
	wire signed [15:0] coeff_imag;
	
	// Instantiate the Unit Under Test (UUT)
	FFT1024_LUT uut1 (
		.n(address[9:0]),
		.twiddle({coeff_real, coeff_imag})
	);
	
	initial
	begin
		Clk = 0; // Initialize clock
	end
	
	// Keep clock running
	always
	begin
		#20; 
		Clk = ~ Clk; 
	end
	
	initial
	begin
		#200
		address = 10'd0;
		#20
		address = 10'd1;
		#20
		address = 10'd2;
		#20
		address = 10'd3;
		#20
		address = 10'd4;
		#20
		address = 10'd5;
		#20
		address = 10'd6;
		#20
		address = 10'd7;
		#20
		address = 10'd8;
		#20
		address = 10'd9;
		#20
		address = 10'd10;
		#20
		address = 10'd11;
		#20
		address = 10'd12;
		#20
		address = 10'd13;
		#20
		address = 10'd14;
		#20
		address = 10'd15;
		#20
		address = 10'd16;
		#20
		address = 10'd17;
		#20
		address = 10'd18;
		#20
		address = 10'd19;
		#20
		address = 10'd20;
		#20
		address = 10'd21;
		#20
		address = 10'd22;
		#20
		address = 10'd23;
		#20
		address = 10'd24;
		#20
		address = 10'd25;
		#20
		address = 10'd26;
		#20
		address = 10'd27;
		#20
		address = 10'd28;
		#20
		address = 10'd29;
		#20
		address = 10'd30;
		#20
		address = 10'd31;
		#20
		address = 10'd32;
		#20
		address = 10'd33;
		#20
		address = 10'd34;
		#20
		address = 10'd35;
		#20
		address = 10'd36;
		#20
		address = 10'd37;
		#20
		address = 10'd38;
		#20
		address = 10'd39;
		#20
		address = 10'd40;
		#20
		address = 10'd41;
		#20
		address = 10'd42;
		#20
		address = 10'd43;
		#20
		address = 10'd44;
		#20
		address = 10'd45;
		#20
		address = 10'd46;
		#20
		address = 10'd47;
		#20
		address = 10'd48;
		#20
		address = 10'd49;
		#20
		address = 10'd50;
		#20
		address = 10'd51;
		#20
		address = 10'd52;
		#20
		address = 10'd53;
		#20
		address = 10'd54;
		#20
		address = 10'd55;
		#20
		address = 10'd56;
		#20
		address = 10'd57;
		#20
		address = 10'd58;
		#20
		address = 10'd59;
		#20
		address = 10'd60;
		#20
		address = 10'd61;
		#20
		address = 10'd62;
		#20
		address = 10'd63;
		#20
		address = 10'd64;
		#20
		address = 10'd65;
		#20
		address = 10'd66;
		#20
		address = 10'd67;
		#20
		address = 10'd68;
		#20
		address = 10'd69;
		#20
		address = 10'd70;
		#20
		address = 10'd71;
		#20
		address = 10'd72;
		#20
		address = 10'd73;
		#20
		address = 10'd74;
		#20
		address = 10'd75;
		#20
		address = 10'd76;
		#20
		address = 10'd77;
		#20
		address = 10'd78;
		#20
		address = 10'd79;
		#20
		address = 10'd80;
		#20
		address = 10'd81;
		#20
		address = 10'd82;
		#20
		address = 10'd83;
		#20
		address = 10'd84;
		#20
		address = 10'd85;
		#20
		address = 10'd86;
		#20
		address = 10'd87;
		#20
		address = 10'd88;
		#20
		address = 10'd89;
		#20
		address = 10'd90;
		#20
		address = 10'd91;
		#20
		address = 10'd92;
		#20
		address = 10'd93;
		#20
		address = 10'd94;
		#20
		address = 10'd95;
		#20
		address = 10'd96;
		#20
		address = 10'd97;
		#20
		address = 10'd98;
		#20
		address = 10'd99;
		#20
		address = 10'd100;
		#20
		address = 10'd101;
		#20
		address = 10'd102;
		#20
		address = 10'd103;
		#20
		address = 10'd104;
		#20
		address = 10'd105;
		#20
		address = 10'd106;
		#20
		address = 10'd107;
		#20
		address = 10'd108;
		#20
		address = 10'd109;
		#20
		address = 10'd110;
		#20
		address = 10'd111;
		#20
		address = 10'd112;
		#20
		address = 10'd113;
		#20
		address = 10'd114;
		#20
		address = 10'd115;
		#20
		address = 10'd116;
		#20
		address = 10'd117;
		#20
		address = 10'd118;
		#20
		address = 10'd119;
		#20
		address = 10'd120;
		#20
		address = 10'd121;
		#20
		address = 10'd122;
		#20
		address = 10'd123;
		#20
		address = 10'd124;
		#20
		address = 10'd125;
		#20
		address = 10'd126;
		#20
		address = 10'd127;
		#20
		address = 10'd128;
		#20
		address = 10'd129;
		#20
		address = 10'd130;
		#20
		address = 10'd131;
		#20
		address = 10'd132;
		#20
		address = 10'd133;
		#20
		address = 10'd134;
		#20
		address = 10'd135;
		#20
		address = 10'd136;
		#20
		address = 10'd137;
		#20
		address = 10'd138;
		#20
		address = 10'd139;
		#20
		address = 10'd140;
		#20
		address = 10'd141;
		#20
		address = 10'd142;
		#20
		address = 10'd143;
		#20
		address = 10'd144;
		#20
		address = 10'd145;
		#20
		address = 10'd146;
		#20
		address = 10'd147;
		#20
		address = 10'd148;
		#20
		address = 10'd149;
		#20
		address = 10'd150;
		#20
		address = 10'd151;
		#20
		address = 10'd152;
		#20
		address = 10'd153;
		#20
		address = 10'd154;
		#20
		address = 10'd155;
		#20
		address = 10'd156;
		#20
		address = 10'd157;
		#20
		address = 10'd158;
		#20
		address = 10'd159;
		#20
		address = 10'd160;
		#20
		address = 10'd161;
		#20
		address = 10'd162;
		#20
		address = 10'd163;
		#20
		address = 10'd164;
		#20
		address = 10'd165;
		#20
		address = 10'd166;
		#20
		address = 10'd167;
		#20
		address = 10'd168;
		#20
		address = 10'd169;
		#20
		address = 10'd170;
		#20
		address = 10'd171;
		#20
		address = 10'd172;
		#20
		address = 10'd173;
		#20
		address = 10'd174;
		#20
		address = 10'd175;
		#20
		address = 10'd176;
		#20
		address = 10'd177;
		#20
		address = 10'd178;
		#20
		address = 10'd179;
		#20
		address = 10'd180;
		#20
		address = 10'd181;
		#20
		address = 10'd182;
		#20
		address = 10'd183;
		#20
		address = 10'd184;
		#20
		address = 10'd185;
		#20
		address = 10'd186;
		#20
		address = 10'd187;
		#20
		address = 10'd188;
		#20
		address = 10'd189;
		#20
		address = 10'd190;
		#20
		address = 10'd191;
		#20
		address = 10'd192;
		#20
		address = 10'd193;
		#20
		address = 10'd194;
		#20
		address = 10'd195;
		#20
		address = 10'd196;
		#20
		address = 10'd197;
		#20
		address = 10'd198;
		#20
		address = 10'd199;
		#20
		address = 10'd200;
		#20
		address = 10'd201;
		#20
		address = 10'd202;
		#20
		address = 10'd203;
		#20
		address = 10'd204;
		#20
		address = 10'd205;
		#20
		address = 10'd206;
		#20
		address = 10'd207;
		#20
		address = 10'd208;
		#20
		address = 10'd209;
		#20
		address = 10'd210;
		#20
		address = 10'd211;
		#20
		address = 10'd212;
		#20
		address = 10'd213;
		#20
		address = 10'd214;
		#20
		address = 10'd215;
		#20
		address = 10'd216;
		#20
		address = 10'd217;
		#20
		address = 10'd218;
		#20
		address = 10'd219;
		#20
		address = 10'd220;
		#20
		address = 10'd221;
		#20
		address = 10'd222;
		#20
		address = 10'd223;
		#20
		address = 10'd224;
		#20
		address = 10'd225;
		#20
		address = 10'd226;
		#20
		address = 10'd227;
		#20
		address = 10'd228;
		#20
		address = 10'd229;
		#20
		address = 10'd230;
		#20
		address = 10'd231;
		#20
		address = 10'd232;
		#20
		address = 10'd233;
		#20
		address = 10'd234;
		#20
		address = 10'd235;
		#20
		address = 10'd236;
		#20
		address = 10'd237;
		#20
		address = 10'd238;
		#20
		address = 10'd239;
		#20
		address = 10'd240;
		#20
		address = 10'd241;
		#20
		address = 10'd242;
		#20
		address = 10'd243;
		#20
		address = 10'd244;
		#20
		address = 10'd245;
		#20
		address = 10'd246;
		#20
		address = 10'd247;
		#20
		address = 10'd248;
		#20
		address = 10'd249;
		#20
		address = 10'd250;
		#20
		address = 10'd251;
		#20
		address = 10'd252;
		#20
		address = 10'd253;
		#20
		address = 10'd254;
		#20
		address = 10'd255;
		#20
		address = 10'd256;
		#20
		address = 10'd257;
		#20
		address = 10'd258;
		#20
		address = 10'd259;
		#20
		address = 10'd260;
		#20
		address = 10'd261;
		#20
		address = 10'd262;
		#20
		address = 10'd263;
		#20
		address = 10'd264;
		#20
		address = 10'd265;
		#20
		address = 10'd266;
		#20
		address = 10'd267;
		#20
		address = 10'd268;
		#20
		address = 10'd269;
		#20
		address = 10'd270;
		#20
		address = 10'd271;
		#20
		address = 10'd272;
		#20
		address = 10'd273;
		#20
		address = 10'd274;
		#20
		address = 10'd275;
		#20
		address = 10'd276;
		#20
		address = 10'd277;
		#20
		address = 10'd278;
		#20
		address = 10'd279;
		#20
		address = 10'd280;
		#20
		address = 10'd281;
		#20
		address = 10'd282;
		#20
		address = 10'd283;
		#20
		address = 10'd284;
		#20
		address = 10'd285;
		#20
		address = 10'd286;
		#20
		address = 10'd287;
		#20
		address = 10'd288;
		#20
		address = 10'd289;
		#20
		address = 10'd290;
		#20
		address = 10'd291;
		#20
		address = 10'd292;
		#20
		address = 10'd293;
		#20
		address = 10'd294;
		#20
		address = 10'd295;
		#20
		address = 10'd296;
		#20
		address = 10'd297;
		#20
		address = 10'd298;
		#20
		address = 10'd299;
		#20
		address = 10'd300;
		#20
		address = 10'd301;
		#20
		address = 10'd302;
		#20
		address = 10'd303;
		#20
		address = 10'd304;
		#20
		address = 10'd305;
		#20
		address = 10'd306;
		#20
		address = 10'd307;
		#20
		address = 10'd308;
		#20
		address = 10'd309;
		#20
		address = 10'd310;
		#20
		address = 10'd311;
		#20
		address = 10'd312;
		#20
		address = 10'd313;
		#20
		address = 10'd314;
		#20
		address = 10'd315;
		#20
		address = 10'd316;
		#20
		address = 10'd317;
		#20
		address = 10'd318;
		#20
		address = 10'd319;
		#20
		address = 10'd320;
		#20
		address = 10'd321;
		#20
		address = 10'd322;
		#20
		address = 10'd323;
		#20
		address = 10'd324;
		#20
		address = 10'd325;
		#20
		address = 10'd326;
		#20
		address = 10'd327;
		#20
		address = 10'd328;
		#20
		address = 10'd329;
		#20
		address = 10'd330;
		#20
		address = 10'd331;
		#20
		address = 10'd332;
		#20
		address = 10'd333;
		#20
		address = 10'd334;
		#20
		address = 10'd335;
		#20
		address = 10'd336;
		#20
		address = 10'd337;
		#20
		address = 10'd338;
		#20
		address = 10'd339;
		#20
		address = 10'd340;
		#20
		address = 10'd341;
		#20
		address = 10'd342;
		#20
		address = 10'd343;
		#20
		address = 10'd344;
		#20
		address = 10'd345;
		#20
		address = 10'd346;
		#20
		address = 10'd347;
		#20
		address = 10'd348;
		#20
		address = 10'd349;
		#20
		address = 10'd350;
		#20
		address = 10'd351;
		#20
		address = 10'd352;
		#20
		address = 10'd353;
		#20
		address = 10'd354;
		#20
		address = 10'd355;
		#20
		address = 10'd356;
		#20
		address = 10'd357;
		#20
		address = 10'd358;
		#20
		address = 10'd359;
		#20
		address = 10'd360;
		#20
		address = 10'd361;
		#20
		address = 10'd362;
		#20
		address = 10'd363;
		#20
		address = 10'd364;
		#20
		address = 10'd365;
		#20
		address = 10'd366;
		#20
		address = 10'd367;
		#20
		address = 10'd368;
		#20
		address = 10'd369;
		#20
		address = 10'd370;
		#20
		address = 10'd371;
		#20
		address = 10'd372;
		#20
		address = 10'd373;
		#20
		address = 10'd374;
		#20
		address = 10'd375;
		#20
		address = 10'd376;
		#20
		address = 10'd377;
		#20
		address = 10'd378;
		#20
		address = 10'd379;
		#20
		address = 10'd380;
		#20
		address = 10'd381;
		#20
		address = 10'd382;
		#20
		address = 10'd383;
		#20
		address = 10'd384;
		#20
		address = 10'd385;
		#20
		address = 10'd386;
		#20
		address = 10'd387;
		#20
		address = 10'd388;
		#20
		address = 10'd389;
		#20
		address = 10'd390;
		#20
		address = 10'd391;
		#20
		address = 10'd392;
		#20
		address = 10'd393;
		#20
		address = 10'd394;
		#20
		address = 10'd395;
		#20
		address = 10'd396;
		#20
		address = 10'd397;
		#20
		address = 10'd398;
		#20
		address = 10'd399;
		#20
		address = 10'd400;
		#20
		address = 10'd401;
		#20
		address = 10'd402;
		#20
		address = 10'd403;
		#20
		address = 10'd404;
		#20
		address = 10'd405;
		#20
		address = 10'd406;
		#20
		address = 10'd407;
		#20
		address = 10'd408;
		#20
		address = 10'd409;
		#20
		address = 10'd410;
		#20
		address = 10'd411;
		#20
		address = 10'd412;
		#20
		address = 10'd413;
		#20
		address = 10'd414;
		#20
		address = 10'd415;
		#20
		address = 10'd416;
		#20
		address = 10'd417;
		#20
		address = 10'd418;
		#20
		address = 10'd419;
		#20
		address = 10'd420;
		#20
		address = 10'd421;
		#20
		address = 10'd422;
		#20
		address = 10'd423;
		#20
		address = 10'd424;
		#20
		address = 10'd425;
		#20
		address = 10'd426;
		#20
		address = 10'd427;
		#20
		address = 10'd428;
		#20
		address = 10'd429;
		#20
		address = 10'd430;
		#20
		address = 10'd431;
		#20
		address = 10'd432;
		#20
		address = 10'd433;
		#20
		address = 10'd434;
		#20
		address = 10'd435;
		#20
		address = 10'd436;
		#20
		address = 10'd437;
		#20
		address = 10'd438;
		#20
		address = 10'd439;
		#20
		address = 10'd440;
		#20
		address = 10'd441;
		#20
		address = 10'd442;
		#20
		address = 10'd443;
		#20
		address = 10'd444;
		#20
		address = 10'd445;
		#20
		address = 10'd446;
		#20
		address = 10'd447;
		#20
		address = 10'd448;
		#20
		address = 10'd449;
		#20
		address = 10'd450;
		#20
		address = 10'd451;
		#20
		address = 10'd452;
		#20
		address = 10'd453;
		#20
		address = 10'd454;
		#20
		address = 10'd455;
		#20
		address = 10'd456;
		#20
		address = 10'd457;
		#20
		address = 10'd458;
		#20
		address = 10'd459;
		#20
		address = 10'd460;
		#20
		address = 10'd461;
		#20
		address = 10'd462;
		#20
		address = 10'd463;
		#20
		address = 10'd464;
		#20
		address = 10'd465;
		#20
		address = 10'd466;
		#20
		address = 10'd467;
		#20
		address = 10'd468;
		#20
		address = 10'd469;
		#20
		address = 10'd470;
		#20
		address = 10'd471;
		#20
		address = 10'd472;
		#20
		address = 10'd473;
		#20
		address = 10'd474;
		#20
		address = 10'd475;
		#20
		address = 10'd476;
		#20
		address = 10'd477;
		#20
		address = 10'd478;
		#20
		address = 10'd479;
		#20
		address = 10'd480;
		#20
		address = 10'd481;
		#20
		address = 10'd482;
		#20
		address = 10'd483;
		#20
		address = 10'd484;
		#20
		address = 10'd485;
		#20
		address = 10'd486;
		#20
		address = 10'd487;
		#20
		address = 10'd488;
		#20
		address = 10'd489;
		#20
		address = 10'd490;
		#20
		address = 10'd491;
		#20
		address = 10'd492;
		#20
		address = 10'd493;
		#20
		address = 10'd494;
		#20
		address = 10'd495;
		#20
		address = 10'd496;
		#20
		address = 10'd497;
		#20
		address = 10'd498;
		#20
		address = 10'd499;
		#20
		address = 10'd500;
		#20
		address = 10'd501;
		#20
		address = 10'd502;
		#20
		address = 10'd503;
		#20
		address = 10'd504;
		#20
		address = 10'd505;
		#20
		address = 10'd506;
		#20
		address = 10'd507;
		#20
		address = 10'd508;
		#20
		address = 10'd509;
		#20
		address = 10'd510;
		#20
		address = 10'd511;
	end

endmodule