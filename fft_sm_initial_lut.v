module fft_sm_initial_lut(n, x_re);
	input [9:0] n;
		
	output reg [31:0] x_re;
	
	always @ (n)
	begin
		case(n)
		10'd0: x_re = 32'd0;
		10'd128: x_re = -32'd202;
		10'd64: x_re = -32'd2459;
		10'd192: x_re = -32'd1021;
		10'd32: x_re = 32'd202;
		10'd160: x_re = 32'd1248;
		10'd96: x_re = 32'd618;
		10'd224: x_re = -32'd820;
		10'd16: x_re = -32'd1021;
		10'd144: x_re = -32'd2459;
		10'd80: x_re = -32'd4123;
		10'd208: x_re = -32'd4728;
		10'd48: x_re = -32'd5939;
		10'd176: x_re = -32'd6241;
		10'd112: x_re = -32'd2459;
		10'd240: x_re = -32'd416;
		10'd8: x_re = -32'd1248;
		10'd136: x_re = -32'd2459;
		10'd72: x_re = 32'd0;
		10'd200: x_re = 32'd2459;
		10'd40: x_re = 32'd4123;
		10'd168: x_re = 32'd5939;
		10'd104: x_re = 32'd4930;
		10'd232: x_re = 32'd4123;
		10'd24: x_re = 32'd2660;
		10'd152: x_re = 32'd1853;
		10'd88: x_re = 32'd0;
		10'd216: x_re = -32'd2055;
		10'd56: x_re = -32'd3114;
		10'd184: x_re = -32'd1248;
		10'd120: x_re = -32'd202;
		10'd248: x_re = -32'd618;
		10'd4: x_re = -32'd2459;
		10'd132: x_re = -32'd3114;
		10'd68: x_re = -32'd2459;
		10'd196: x_re = -32'd2459;
		10'd36: x_re = -32'd1021;
		10'd164: x_re = -32'd1853;
		10'd100: x_re = -32'd618;
		10'd228: x_re = 32'd820;
		10'd20: x_re = 32'd1853;
		10'd148: x_re = 32'd1853;
		10'd84: x_re = 32'd820;
		10'd212: x_re = -32'd618;
		10'd52: x_re = 32'd820;
		10'd180: x_re = 32'd3518;
		10'd116: x_re = 32'd4123;
		10'd244: x_re = 32'd2660;
		10'd12: x_re = 32'd1021;
		10'd140: x_re = 32'd202;
		10'd76: x_re = -32'd1021;
		10'd204: x_re = 32'd202;
		10'd44: x_re = -32'd202;
		10'd172: x_re = 32'd820;
		10'd108: x_re = 32'd3921;
		10'd236: x_re = 32'd4930;
		10'd28: x_re = 32'd5334;
		10'd156: x_re = 32'd5334;
		10'd92: x_re = 32'd1652;
		10'd220: x_re = 32'd0;
		10'd60: x_re = 32'd202;
		10'd188: x_re = -32'd202;
		10'd124: x_re = -32'd3114;
		10'd252: x_re = -32'd4123;
		10'd2: x_re = -32'd4123;
		10'd130: x_re = -32'd3720;
		10'd66: x_re = -32'd1652;
		10'd194: x_re = -32'd202;
		10'd34: x_re = -32'd618;
		10'd162: x_re = 32'd618;
		10'd98: x_re = 32'd2660;
		10'd226: x_re = 32'd4728;
		10'd18: x_re = 32'd4930;
		10'd146: x_re = 32'd3518;
		10'd82: x_re = 32'd1652;
		10'd210: x_re = 32'd1853;
		10'd50: x_re = 32'd3921;
		10'd178: x_re = 32'd2459;
		10'd114: x_re = 32'd820;
		10'd242: x_re = -32'd416;
		10'd10: x_re = 32'd618;
		10'd138: x_re = 32'd820;
		10'd74: x_re = 32'd1853;
		10'd202: x_re = 32'd1853;
		10'd42: x_re = 32'd1652;
		10'd170: x_re = 32'd820;
		10'd106: x_re = -32'd202;
		10'd234: x_re = -32'd820;
		10'd26: x_re = -32'd1652;
		10'd154: x_re = -32'd4728;
		10'd90: x_re = -32'd3316;
		10'd218: x_re = 32'd1450;
		10'd58: x_re = 32'd2257;
		10'd186: x_re = 32'd1021;
		10'd122: x_re = -32'd202;
		10'd250: x_re = 32'd0;
		10'd6: x_re = 32'd0;
		10'd134: x_re = 32'd2055;
		10'd70: x_re = 32'd3114;
		10'd198: x_re = 32'd2660;
		10'd38: x_re = 32'd3114;
		10'd166: x_re = 32'd2257;
		10'd102: x_re = 32'd1248;
		10'd230: x_re = 32'd618;
		10'd22: x_re = -32'd3114;
		10'd150: x_re = -32'd3518;
		10'd86: x_re = -32'd618;
		10'd214: x_re = 32'd1652;
		10'd54: x_re = 32'd1652;
		10'd182: x_re = 32'd1450;
		10'd118: x_re = 32'd416;
		10'd246: x_re = -32'd1853;
		10'd14: x_re = -32'd2257;
		10'd142: x_re = -32'd2459;
		10'd78: x_re = -32'd2660;
		10'd206: x_re = -32'd2459;
		10'd46: x_re = -32'd3518;
		10'd174: x_re = -32'd2913;
		10'd110: x_re = -32'd2257;
		10'd238: x_re = -32'd3316;
		10'd30: x_re = -32'd4930;
		10'd158: x_re = -32'd2459;
		10'd94: x_re = 32'd1853;
		10'd222: x_re = 32'd2913;
		10'd62: x_re = 32'd4123;
		10'd190: x_re = 32'd3921;
		10'd126: x_re = 32'd1853;
		10'd254: x_re = 32'd820;
		10'd1: x_re = 32'd2257;
		10'd129: x_re = 32'd1652;
		10'd65: x_re = 32'd820;
		10'd193: x_re = 32'd618;
		10'd33: x_re = 32'd1021;
		10'd161: x_re = 32'd1652;
		10'd97: x_re = 32'd416;
		10'd225: x_re = -32'd2055;
		10'd17: x_re = -32'd2660;
		10'd145: x_re = -32'd2660;
		10'd81: x_re = -32'd3518;
		10'd209: x_re = -32'd3114;
		10'd49: x_re = -32'd3518;
		10'd177: x_re = -32'd3518;
		10'd113: x_re = -32'd3114;
		10'd241: x_re = -32'd202;
		10'd9: x_re = 32'd202;
		10'd137: x_re = 32'd416;
		10'd73: x_re = 32'd1853;
		10'd201: x_re = 32'd1853;
		10'd41: x_re = 32'd1853;
		10'd169: x_re = 32'd2257;
		10'd105: x_re = 32'd820;
		10'd233: x_re = -32'd820;
		10'd25: x_re = 32'd618;
		10'd153: x_re = 32'd1248;
		10'd89: x_re = 32'd820;
		10'd217: x_re = -32'd202;
		10'd57: x_re = -32'd618;
		10'd185: x_re = -32'd618;
		10'd121: x_re = 32'd1021;
		10'd249: x_re = 32'd3114;
		10'd5: x_re = 32'd3114;
		10'd133: x_re = 32'd3720;
		10'd69: x_re = 32'd1248;
		10'd197: x_re = -32'd416;
		10'd37: x_re = -32'd1652;
		10'd165: x_re = -32'd5132;
		10'd101: x_re = -32'd7452;
		10'd229: x_re = -32'd6241;
		10'd21: x_re = -32'd3720;
		10'd149: x_re = -32'd2257;
		10'd85: x_re = -32'd202;
		10'd213: x_re = 32'd202;
		10'd53: x_re = -32'd416;
		10'd181: x_re = 32'd1450;
		10'd117: x_re = 32'd3921;
		10'd245: x_re = 32'd4325;
		10'd13: x_re = 32'd4930;
		10'd141: x_re = 32'd5132;
		10'd77: x_re = 32'd4123;
		10'd205: x_re = 32'd3518;
		10'd45: x_re = 32'd1248;
		10'd173: x_re = -32'd1652;
		10'd109: x_re = -32'd3518;
		10'd237: x_re = -32'd1652;
		10'd29: x_re = 32'd618;
		10'd157: x_re = 32'd1021;
		10'd93: x_re = 32'd1652;
		10'd221: x_re = 32'd0;
		10'd61: x_re = -32'd1248;
		10'd189: x_re = -32'd1450;
		10'd125: x_re = -32'd2055;
		10'd253: x_re = -32'd1450;
		10'd3: x_re = -32'd202;
		10'd131: x_re = 32'd0;
		10'd67: x_re = 32'd416;
		10'd195: x_re = 32'd820;
		10'd35: x_re = -32'd618;
		10'd163: x_re = -32'd1652;
		10'd99: x_re = -32'd618;
		10'd227: x_re = 32'd1021;
		10'd19: x_re = 32'd1652;
		10'd147: x_re = 32'd3720;
		10'd83: x_re = 32'd2913;
		10'd211: x_re = 32'd1248;
		10'd51: x_re = 32'd1021;
		10'd179: x_re = 32'd1450;
		10'd115: x_re = 32'd1021;
		10'd243: x_re = 32'd820;
		10'd11: x_re = 32'd1450;
		10'd139: x_re = 32'd1853;
		10'd75: x_re = 32'd2660;
		10'd203: x_re = 32'd2055;
		10'd43: x_re = 32'd1021;
		10'd171: x_re = -32'd202;
		10'd107: x_re = -32'd416;
		10'd235: x_re = -32'd618;
		10'd27: x_re = -32'd416;
		10'd155: x_re = -32'd1853;
		10'd91: x_re = -32'd3921;
		10'd219: x_re = -32'd4123;
		10'd59: x_re = -32'd3921;
		10'd187: x_re = -32'd3921;
		10'd123: x_re = -32'd2459;
		10'd251: x_re = -32'd1021;
		10'd7: x_re = -32'd1450;
		10'd135: x_re = -32'd416;
		10'd71: x_re = 32'd618;
		10'd199: x_re = 32'd618;
		10'd39: x_re = 32'd1021;
		10'd167: x_re = 32'd2660;
		10'd103: x_re = 32'd4527;
		10'd231: x_re = 32'd4728;
		10'd23: x_re = 32'd4123;
		10'd151: x_re = 32'd416;
		10'd87: x_re = -32'd820;
		10'd215: x_re = -32'd416;
		10'd55: x_re = 32'd416;
		10'd183: x_re = 32'd202;
		10'd119: x_re = 32'd1021;
		10'd247: x_re = 32'd202;
		10'd15: x_re = -32'd1853;
		10'd143: x_re = -32'd4325;
		10'd79: x_re = -32'd5334;
		10'd207: x_re = -32'd5535;
		10'd47: x_re = -32'd4728;
		10'd175: x_re = -32'd2660;
		10'd111: x_re = -32'd202;
		10'd239: x_re = 32'd1450;
		10'd31: x_re = 32'd1450;
		10'd159: x_re = 32'd1021;
		10'd95: x_re = 32'd1652;
		10'd223: x_re = 32'd1248;
		10'd63: x_re = 32'd1021;
		10'd191: x_re = 32'd2257;
		10'd127: x_re = 32'd2660;
		10'd255: x_re = 32'd820;
		default: x_re = 'bX;
		endcase
	end

endmodule