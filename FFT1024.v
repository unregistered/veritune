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
	input wire [32*1024-1:0] x_re_packed,
	input wire [32*1024-1:0] x_im_packed,
	output reg [3:0] state,
	output wire Done,
	output wire [32*1024-1:0] y_re_packed,
	output wire [32*1024-1:0] y_im_packed
);
	//	Params
	parameter N		= 32;
	parameter M		= 5;
	
	//	Inputs
	reg signed [31:0] x_re [1023:0];
	reg signed [31:0] x_im [1023:0];
	
	//	States
	localparam INIT = 4'b1000, LOAD = 4'b0100, PROC = 4'b0010, DONE = 4'b0001, UNK = 4'bXXXX;
	wire Init, Load, Proc;
	assign {Init, Load, Proc, Done} = state;
	
	//	Output
	assign y_re_packed = { x_re[1023], x_re[1022], x_re[1021], x_re[1020], x_re[1019], x_re[1018], x_re[1017], x_re[1016], x_re[1015], x_re[1014], x_re[1013], x_re[1012], x_re[1011], x_re[1010], x_re[1009], x_re[1008], x_re[1007], x_re[1006], x_re[1005], x_re[1004], x_re[1003], x_re[1002], x_re[1001], x_re[1000], x_re[999], x_re[998], x_re[997], x_re[996], x_re[995], x_re[994], x_re[993], x_re[992], x_re[991], x_re[990], x_re[989], x_re[988], x_re[987], x_re[986], x_re[985], x_re[984], x_re[983], x_re[982], x_re[981], x_re[980], x_re[979], x_re[978], x_re[977], x_re[976], x_re[975], x_re[974], x_re[973], x_re[972], x_re[971], x_re[970], x_re[969], x_re[968], x_re[967], x_re[966], x_re[965], x_re[964], x_re[963], x_re[962], x_re[961], x_re[960], x_re[959], x_re[958], x_re[957], x_re[956], x_re[955], x_re[954], x_re[953], x_re[952], x_re[951], x_re[950], x_re[949], x_re[948], x_re[947], x_re[946], x_re[945], x_re[944], x_re[943], x_re[942], x_re[941], x_re[940], x_re[939], x_re[938], x_re[937], x_re[936], x_re[935], x_re[934], x_re[933], x_re[932], x_re[931], x_re[930], x_re[929], x_re[928], x_re[927], x_re[926], x_re[925], x_re[924], x_re[923], x_re[922], x_re[921], x_re[920], x_re[919], x_re[918], x_re[917], x_re[916], x_re[915], x_re[914], x_re[913], x_re[912], x_re[911], x_re[910], x_re[909], x_re[908], x_re[907], x_re[906], x_re[905], x_re[904], x_re[903], x_re[902], x_re[901], x_re[900], x_re[899], x_re[898], x_re[897], x_re[896], x_re[895], x_re[894], x_re[893], x_re[892], x_re[891], x_re[890], x_re[889], x_re[888], x_re[887], x_re[886], x_re[885], x_re[884], x_re[883], x_re[882], x_re[881], x_re[880], x_re[879], x_re[878], x_re[877], x_re[876], x_re[875], x_re[874], x_re[873], x_re[872], x_re[871], x_re[870], x_re[869], x_re[868], x_re[867], x_re[866], x_re[865], x_re[864], x_re[863], x_re[862], x_re[861], x_re[860], x_re[859], x_re[858], x_re[857], x_re[856], x_re[855], x_re[854], x_re[853], x_re[852], x_re[851], x_re[850], x_re[849], x_re[848], x_re[847], x_re[846], x_re[845], x_re[844], x_re[843], x_re[842], x_re[841], x_re[840], x_re[839], x_re[838], x_re[837], x_re[836], x_re[835], x_re[834], x_re[833], x_re[832], x_re[831], x_re[830], x_re[829], x_re[828], x_re[827], x_re[826], x_re[825], x_re[824], x_re[823], x_re[822], x_re[821], x_re[820], x_re[819], x_re[818], x_re[817], x_re[816], x_re[815], x_re[814], x_re[813], x_re[812], x_re[811], x_re[810], x_re[809], x_re[808], x_re[807], x_re[806], x_re[805], x_re[804], x_re[803], x_re[802], x_re[801], x_re[800], x_re[799], x_re[798], x_re[797], x_re[796], x_re[795], x_re[794], x_re[793], x_re[792], x_re[791], x_re[790], x_re[789], x_re[788], x_re[787], x_re[786], x_re[785], x_re[784], x_re[783], x_re[782], x_re[781], x_re[780], x_re[779], x_re[778], x_re[777], x_re[776], x_re[775], x_re[774], x_re[773], x_re[772], x_re[771], x_re[770], x_re[769], x_re[768], x_re[767], x_re[766], x_re[765], x_re[764], x_re[763], x_re[762], x_re[761], x_re[760], x_re[759], x_re[758], x_re[757], x_re[756], x_re[755], x_re[754], x_re[753], x_re[752], x_re[751], x_re[750], x_re[749], x_re[748], x_re[747], x_re[746], x_re[745], x_re[744], x_re[743], x_re[742], x_re[741], x_re[740], x_re[739], x_re[738], x_re[737], x_re[736], x_re[735], x_re[734], x_re[733], x_re[732], x_re[731], x_re[730], x_re[729], x_re[728], x_re[727], x_re[726], x_re[725], x_re[724], x_re[723], x_re[722], x_re[721], x_re[720], x_re[719], x_re[718], x_re[717], x_re[716], x_re[715], x_re[714], x_re[713], x_re[712], x_re[711], x_re[710], x_re[709], x_re[708], x_re[707], x_re[706], x_re[705], x_re[704], x_re[703], x_re[702], x_re[701], x_re[700], x_re[699], x_re[698], x_re[697], x_re[696], x_re[695], x_re[694], x_re[693], x_re[692], x_re[691], x_re[690], x_re[689], x_re[688], x_re[687], x_re[686], x_re[685], x_re[684], x_re[683], x_re[682], x_re[681], x_re[680], x_re[679], x_re[678], x_re[677], x_re[676], x_re[675], x_re[674], x_re[673], x_re[672], x_re[671], x_re[670], x_re[669], x_re[668], x_re[667], x_re[666], x_re[665], x_re[664], x_re[663], x_re[662], x_re[661], x_re[660], x_re[659], x_re[658], x_re[657], x_re[656], x_re[655], x_re[654], x_re[653], x_re[652], x_re[651], x_re[650], x_re[649], x_re[648], x_re[647], x_re[646], x_re[645], x_re[644], x_re[643], x_re[642], x_re[641], x_re[640], x_re[639], x_re[638], x_re[637], x_re[636], x_re[635], x_re[634], x_re[633], x_re[632], x_re[631], x_re[630], x_re[629], x_re[628], x_re[627], x_re[626], x_re[625], x_re[624], x_re[623], x_re[622], x_re[621], x_re[620], x_re[619], x_re[618], x_re[617], x_re[616], x_re[615], x_re[614], x_re[613], x_re[612], x_re[611], x_re[610], x_re[609], x_re[608], x_re[607], x_re[606], x_re[605], x_re[604], x_re[603], x_re[602], x_re[601], x_re[600], x_re[599], x_re[598], x_re[597], x_re[596], x_re[595], x_re[594], x_re[593], x_re[592], x_re[591], x_re[590], x_re[589], x_re[588], x_re[587], x_re[586], x_re[585], x_re[584], x_re[583], x_re[582], x_re[581], x_re[580], x_re[579], x_re[578], x_re[577], x_re[576], x_re[575], x_re[574], x_re[573], x_re[572], x_re[571], x_re[570], x_re[569], x_re[568], x_re[567], x_re[566], x_re[565], x_re[564], x_re[563], x_re[562], x_re[561], x_re[560], x_re[559], x_re[558], x_re[557], x_re[556], x_re[555], x_re[554], x_re[553], x_re[552], x_re[551], x_re[550], x_re[549], x_re[548], x_re[547], x_re[546], x_re[545], x_re[544], x_re[543], x_re[542], x_re[541], x_re[540], x_re[539], x_re[538], x_re[537], x_re[536], x_re[535], x_re[534], x_re[533], x_re[532], x_re[531], x_re[530], x_re[529], x_re[528], x_re[527], x_re[526], x_re[525], x_re[524], x_re[523], x_re[522], x_re[521], x_re[520], x_re[519], x_re[518], x_re[517], x_re[516], x_re[515], x_re[514], x_re[513], x_re[512], x_re[511], x_re[510], x_re[509], x_re[508], x_re[507], x_re[506], x_re[505], x_re[504], x_re[503], x_re[502], x_re[501], x_re[500], x_re[499], x_re[498], x_re[497], x_re[496], x_re[495], x_re[494], x_re[493], x_re[492], x_re[491], x_re[490], x_re[489], x_re[488], x_re[487], x_re[486], x_re[485], x_re[484], x_re[483], x_re[482], x_re[481], x_re[480], x_re[479], x_re[478], x_re[477], x_re[476], x_re[475], x_re[474], x_re[473], x_re[472], x_re[471], x_re[470], x_re[469], x_re[468], x_re[467], x_re[466], x_re[465], x_re[464], x_re[463], x_re[462], x_re[461], x_re[460], x_re[459], x_re[458], x_re[457], x_re[456], x_re[455], x_re[454], x_re[453], x_re[452], x_re[451], x_re[450], x_re[449], x_re[448], x_re[447], x_re[446], x_re[445], x_re[444], x_re[443], x_re[442], x_re[441], x_re[440], x_re[439], x_re[438], x_re[437], x_re[436], x_re[435], x_re[434], x_re[433], x_re[432], x_re[431], x_re[430], x_re[429], x_re[428], x_re[427], x_re[426], x_re[425], x_re[424], x_re[423], x_re[422], x_re[421], x_re[420], x_re[419], x_re[418], x_re[417], x_re[416], x_re[415], x_re[414], x_re[413], x_re[412], x_re[411], x_re[410], x_re[409], x_re[408], x_re[407], x_re[406], x_re[405], x_re[404], x_re[403], x_re[402], x_re[401], x_re[400], x_re[399], x_re[398], x_re[397], x_re[396], x_re[395], x_re[394], x_re[393], x_re[392], x_re[391], x_re[390], x_re[389], x_re[388], x_re[387], x_re[386], x_re[385], x_re[384], x_re[383], x_re[382], x_re[381], x_re[380], x_re[379], x_re[378], x_re[377], x_re[376], x_re[375], x_re[374], x_re[373], x_re[372], x_re[371], x_re[370], x_re[369], x_re[368], x_re[367], x_re[366], x_re[365], x_re[364], x_re[363], x_re[362], x_re[361], x_re[360], x_re[359], x_re[358], x_re[357], x_re[356], x_re[355], x_re[354], x_re[353], x_re[352], x_re[351], x_re[350], x_re[349], x_re[348], x_re[347], x_re[346], x_re[345], x_re[344], x_re[343], x_re[342], x_re[341], x_re[340], x_re[339], x_re[338], x_re[337], x_re[336], x_re[335], x_re[334], x_re[333], x_re[332], x_re[331], x_re[330], x_re[329], x_re[328], x_re[327], x_re[326], x_re[325], x_re[324], x_re[323], x_re[322], x_re[321], x_re[320], x_re[319], x_re[318], x_re[317], x_re[316], x_re[315], x_re[314], x_re[313], x_re[312], x_re[311], x_re[310], x_re[309], x_re[308], x_re[307], x_re[306], x_re[305], x_re[304], x_re[303], x_re[302], x_re[301], x_re[300], x_re[299], x_re[298], x_re[297], x_re[296], x_re[295], x_re[294], x_re[293], x_re[292], x_re[291], x_re[290], x_re[289], x_re[288], x_re[287], x_re[286], x_re[285], x_re[284], x_re[283], x_re[282], x_re[281], x_re[280], x_re[279], x_re[278], x_re[277], x_re[276], x_re[275], x_re[274], x_re[273], x_re[272], x_re[271], x_re[270], x_re[269], x_re[268], x_re[267], x_re[266], x_re[265], x_re[264], x_re[263], x_re[262], x_re[261], x_re[260], x_re[259], x_re[258], x_re[257], x_re[256], x_re[255], x_re[254], x_re[253], x_re[252], x_re[251], x_re[250], x_re[249], x_re[248], x_re[247], x_re[246], x_re[245], x_re[244], x_re[243], x_re[242], x_re[241], x_re[240], x_re[239], x_re[238], x_re[237], x_re[236], x_re[235], x_re[234], x_re[233], x_re[232], x_re[231], x_re[230], x_re[229], x_re[228], x_re[227], x_re[226], x_re[225], x_re[224], x_re[223], x_re[222], x_re[221], x_re[220], x_re[219], x_re[218], x_re[217], x_re[216], x_re[215], x_re[214], x_re[213], x_re[212], x_re[211], x_re[210], x_re[209], x_re[208], x_re[207], x_re[206], x_re[205], x_re[204], x_re[203], x_re[202], x_re[201], x_re[200], x_re[199], x_re[198], x_re[197], x_re[196], x_re[195], x_re[194], x_re[193], x_re[192], x_re[191], x_re[190], x_re[189], x_re[188], x_re[187], x_re[186], x_re[185], x_re[184], x_re[183], x_re[182], x_re[181], x_re[180], x_re[179], x_re[178], x_re[177], x_re[176], x_re[175], x_re[174], x_re[173], x_re[172], x_re[171], x_re[170], x_re[169], x_re[168], x_re[167], x_re[166], x_re[165], x_re[164], x_re[163], x_re[162], x_re[161], x_re[160], x_re[159], x_re[158], x_re[157], x_re[156], x_re[155], x_re[154], x_re[153], x_re[152], x_re[151], x_re[150], x_re[149], x_re[148], x_re[147], x_re[146], x_re[145], x_re[144], x_re[143], x_re[142], x_re[141], x_re[140], x_re[139], x_re[138], x_re[137], x_re[136], x_re[135], x_re[134], x_re[133], x_re[132], x_re[131], x_re[130], x_re[129], x_re[128], x_re[127], x_re[126], x_re[125], x_re[124], x_re[123], x_re[122], x_re[121], x_re[120], x_re[119], x_re[118], x_re[117], x_re[116], x_re[115], x_re[114], x_re[113], x_re[112], x_re[111], x_re[110], x_re[109], x_re[108], x_re[107], x_re[106], x_re[105], x_re[104], x_re[103], x_re[102], x_re[101], x_re[100], x_re[99], x_re[98], x_re[97], x_re[96], x_re[95], x_re[94], x_re[93], x_re[92], x_re[91], x_re[90], x_re[89], x_re[88], x_re[87], x_re[86], x_re[85], x_re[84], x_re[83], x_re[82], x_re[81], x_re[80], x_re[79], x_re[78], x_re[77], x_re[76], x_re[75], x_re[74], x_re[73], x_re[72], x_re[71], x_re[70], x_re[69], x_re[68], x_re[67], x_re[66], x_re[65], x_re[64], x_re[63], x_re[62], x_re[61], x_re[60], x_re[59], x_re[58], x_re[57], x_re[56], x_re[55], x_re[54], x_re[53], x_re[52], x_re[51], x_re[50], x_re[49], x_re[48], x_re[47], x_re[46], x_re[45], x_re[44], x_re[43], x_re[42], x_re[41], x_re[40], x_re[39], x_re[38], x_re[37], x_re[36], x_re[35], x_re[34], x_re[33], x_re[32], x_re[31], x_re[30], x_re[29], x_re[28], x_re[27], x_re[26], x_re[25], x_re[24], x_re[23], x_re[22], x_re[21], x_re[20], x_re[19], x_re[18], x_re[17], x_re[16], x_re[15], x_re[14], x_re[13], x_re[12], x_re[11], x_re[10], x_re[9], x_re[8], x_re[7], x_re[6], x_re[5], x_re[4], x_re[3], x_re[2], x_re[1], x_re[0]};
	assign y_im_packed = { x_im[1023], x_im[1022], x_im[1021], x_im[1020], x_im[1019], x_im[1018], x_im[1017], x_im[1016], x_im[1015], x_im[1014], x_im[1013], x_im[1012], x_im[1011], x_im[1010], x_im[1009], x_im[1008], x_im[1007], x_im[1006], x_im[1005], x_im[1004], x_im[1003], x_im[1002], x_im[1001], x_im[1000], x_im[999], x_im[998], x_im[997], x_im[996], x_im[995], x_im[994], x_im[993], x_im[992], x_im[991], x_im[990], x_im[989], x_im[988], x_im[987], x_im[986], x_im[985], x_im[984], x_im[983], x_im[982], x_im[981], x_im[980], x_im[979], x_im[978], x_im[977], x_im[976], x_im[975], x_im[974], x_im[973], x_im[972], x_im[971], x_im[970], x_im[969], x_im[968], x_im[967], x_im[966], x_im[965], x_im[964], x_im[963], x_im[962], x_im[961], x_im[960], x_im[959], x_im[958], x_im[957], x_im[956], x_im[955], x_im[954], x_im[953], x_im[952], x_im[951], x_im[950], x_im[949], x_im[948], x_im[947], x_im[946], x_im[945], x_im[944], x_im[943], x_im[942], x_im[941], x_im[940], x_im[939], x_im[938], x_im[937], x_im[936], x_im[935], x_im[934], x_im[933], x_im[932], x_im[931], x_im[930], x_im[929], x_im[928], x_im[927], x_im[926], x_im[925], x_im[924], x_im[923], x_im[922], x_im[921], x_im[920], x_im[919], x_im[918], x_im[917], x_im[916], x_im[915], x_im[914], x_im[913], x_im[912], x_im[911], x_im[910], x_im[909], x_im[908], x_im[907], x_im[906], x_im[905], x_im[904], x_im[903], x_im[902], x_im[901], x_im[900], x_im[899], x_im[898], x_im[897], x_im[896], x_im[895], x_im[894], x_im[893], x_im[892], x_im[891], x_im[890], x_im[889], x_im[888], x_im[887], x_im[886], x_im[885], x_im[884], x_im[883], x_im[882], x_im[881], x_im[880], x_im[879], x_im[878], x_im[877], x_im[876], x_im[875], x_im[874], x_im[873], x_im[872], x_im[871], x_im[870], x_im[869], x_im[868], x_im[867], x_im[866], x_im[865], x_im[864], x_im[863], x_im[862], x_im[861], x_im[860], x_im[859], x_im[858], x_im[857], x_im[856], x_im[855], x_im[854], x_im[853], x_im[852], x_im[851], x_im[850], x_im[849], x_im[848], x_im[847], x_im[846], x_im[845], x_im[844], x_im[843], x_im[842], x_im[841], x_im[840], x_im[839], x_im[838], x_im[837], x_im[836], x_im[835], x_im[834], x_im[833], x_im[832], x_im[831], x_im[830], x_im[829], x_im[828], x_im[827], x_im[826], x_im[825], x_im[824], x_im[823], x_im[822], x_im[821], x_im[820], x_im[819], x_im[818], x_im[817], x_im[816], x_im[815], x_im[814], x_im[813], x_im[812], x_im[811], x_im[810], x_im[809], x_im[808], x_im[807], x_im[806], x_im[805], x_im[804], x_im[803], x_im[802], x_im[801], x_im[800], x_im[799], x_im[798], x_im[797], x_im[796], x_im[795], x_im[794], x_im[793], x_im[792], x_im[791], x_im[790], x_im[789], x_im[788], x_im[787], x_im[786], x_im[785], x_im[784], x_im[783], x_im[782], x_im[781], x_im[780], x_im[779], x_im[778], x_im[777], x_im[776], x_im[775], x_im[774], x_im[773], x_im[772], x_im[771], x_im[770], x_im[769], x_im[768], x_im[767], x_im[766], x_im[765], x_im[764], x_im[763], x_im[762], x_im[761], x_im[760], x_im[759], x_im[758], x_im[757], x_im[756], x_im[755], x_im[754], x_im[753], x_im[752], x_im[751], x_im[750], x_im[749], x_im[748], x_im[747], x_im[746], x_im[745], x_im[744], x_im[743], x_im[742], x_im[741], x_im[740], x_im[739], x_im[738], x_im[737], x_im[736], x_im[735], x_im[734], x_im[733], x_im[732], x_im[731], x_im[730], x_im[729], x_im[728], x_im[727], x_im[726], x_im[725], x_im[724], x_im[723], x_im[722], x_im[721], x_im[720], x_im[719], x_im[718], x_im[717], x_im[716], x_im[715], x_im[714], x_im[713], x_im[712], x_im[711], x_im[710], x_im[709], x_im[708], x_im[707], x_im[706], x_im[705], x_im[704], x_im[703], x_im[702], x_im[701], x_im[700], x_im[699], x_im[698], x_im[697], x_im[696], x_im[695], x_im[694], x_im[693], x_im[692], x_im[691], x_im[690], x_im[689], x_im[688], x_im[687], x_im[686], x_im[685], x_im[684], x_im[683], x_im[682], x_im[681], x_im[680], x_im[679], x_im[678], x_im[677], x_im[676], x_im[675], x_im[674], x_im[673], x_im[672], x_im[671], x_im[670], x_im[669], x_im[668], x_im[667], x_im[666], x_im[665], x_im[664], x_im[663], x_im[662], x_im[661], x_im[660], x_im[659], x_im[658], x_im[657], x_im[656], x_im[655], x_im[654], x_im[653], x_im[652], x_im[651], x_im[650], x_im[649], x_im[648], x_im[647], x_im[646], x_im[645], x_im[644], x_im[643], x_im[642], x_im[641], x_im[640], x_im[639], x_im[638], x_im[637], x_im[636], x_im[635], x_im[634], x_im[633], x_im[632], x_im[631], x_im[630], x_im[629], x_im[628], x_im[627], x_im[626], x_im[625], x_im[624], x_im[623], x_im[622], x_im[621], x_im[620], x_im[619], x_im[618], x_im[617], x_im[616], x_im[615], x_im[614], x_im[613], x_im[612], x_im[611], x_im[610], x_im[609], x_im[608], x_im[607], x_im[606], x_im[605], x_im[604], x_im[603], x_im[602], x_im[601], x_im[600], x_im[599], x_im[598], x_im[597], x_im[596], x_im[595], x_im[594], x_im[593], x_im[592], x_im[591], x_im[590], x_im[589], x_im[588], x_im[587], x_im[586], x_im[585], x_im[584], x_im[583], x_im[582], x_im[581], x_im[580], x_im[579], x_im[578], x_im[577], x_im[576], x_im[575], x_im[574], x_im[573], x_im[572], x_im[571], x_im[570], x_im[569], x_im[568], x_im[567], x_im[566], x_im[565], x_im[564], x_im[563], x_im[562], x_im[561], x_im[560], x_im[559], x_im[558], x_im[557], x_im[556], x_im[555], x_im[554], x_im[553], x_im[552], x_im[551], x_im[550], x_im[549], x_im[548], x_im[547], x_im[546], x_im[545], x_im[544], x_im[543], x_im[542], x_im[541], x_im[540], x_im[539], x_im[538], x_im[537], x_im[536], x_im[535], x_im[534], x_im[533], x_im[532], x_im[531], x_im[530], x_im[529], x_im[528], x_im[527], x_im[526], x_im[525], x_im[524], x_im[523], x_im[522], x_im[521], x_im[520], x_im[519], x_im[518], x_im[517], x_im[516], x_im[515], x_im[514], x_im[513], x_im[512], x_im[511], x_im[510], x_im[509], x_im[508], x_im[507], x_im[506], x_im[505], x_im[504], x_im[503], x_im[502], x_im[501], x_im[500], x_im[499], x_im[498], x_im[497], x_im[496], x_im[495], x_im[494], x_im[493], x_im[492], x_im[491], x_im[490], x_im[489], x_im[488], x_im[487], x_im[486], x_im[485], x_im[484], x_im[483], x_im[482], x_im[481], x_im[480], x_im[479], x_im[478], x_im[477], x_im[476], x_im[475], x_im[474], x_im[473], x_im[472], x_im[471], x_im[470], x_im[469], x_im[468], x_im[467], x_im[466], x_im[465], x_im[464], x_im[463], x_im[462], x_im[461], x_im[460], x_im[459], x_im[458], x_im[457], x_im[456], x_im[455], x_im[454], x_im[453], x_im[452], x_im[451], x_im[450], x_im[449], x_im[448], x_im[447], x_im[446], x_im[445], x_im[444], x_im[443], x_im[442], x_im[441], x_im[440], x_im[439], x_im[438], x_im[437], x_im[436], x_im[435], x_im[434], x_im[433], x_im[432], x_im[431], x_im[430], x_im[429], x_im[428], x_im[427], x_im[426], x_im[425], x_im[424], x_im[423], x_im[422], x_im[421], x_im[420], x_im[419], x_im[418], x_im[417], x_im[416], x_im[415], x_im[414], x_im[413], x_im[412], x_im[411], x_im[410], x_im[409], x_im[408], x_im[407], x_im[406], x_im[405], x_im[404], x_im[403], x_im[402], x_im[401], x_im[400], x_im[399], x_im[398], x_im[397], x_im[396], x_im[395], x_im[394], x_im[393], x_im[392], x_im[391], x_im[390], x_im[389], x_im[388], x_im[387], x_im[386], x_im[385], x_im[384], x_im[383], x_im[382], x_im[381], x_im[380], x_im[379], x_im[378], x_im[377], x_im[376], x_im[375], x_im[374], x_im[373], x_im[372], x_im[371], x_im[370], x_im[369], x_im[368], x_im[367], x_im[366], x_im[365], x_im[364], x_im[363], x_im[362], x_im[361], x_im[360], x_im[359], x_im[358], x_im[357], x_im[356], x_im[355], x_im[354], x_im[353], x_im[352], x_im[351], x_im[350], x_im[349], x_im[348], x_im[347], x_im[346], x_im[345], x_im[344], x_im[343], x_im[342], x_im[341], x_im[340], x_im[339], x_im[338], x_im[337], x_im[336], x_im[335], x_im[334], x_im[333], x_im[332], x_im[331], x_im[330], x_im[329], x_im[328], x_im[327], x_im[326], x_im[325], x_im[324], x_im[323], x_im[322], x_im[321], x_im[320], x_im[319], x_im[318], x_im[317], x_im[316], x_im[315], x_im[314], x_im[313], x_im[312], x_im[311], x_im[310], x_im[309], x_im[308], x_im[307], x_im[306], x_im[305], x_im[304], x_im[303], x_im[302], x_im[301], x_im[300], x_im[299], x_im[298], x_im[297], x_im[296], x_im[295], x_im[294], x_im[293], x_im[292], x_im[291], x_im[290], x_im[289], x_im[288], x_im[287], x_im[286], x_im[285], x_im[284], x_im[283], x_im[282], x_im[281], x_im[280], x_im[279], x_im[278], x_im[277], x_im[276], x_im[275], x_im[274], x_im[273], x_im[272], x_im[271], x_im[270], x_im[269], x_im[268], x_im[267], x_im[266], x_im[265], x_im[264], x_im[263], x_im[262], x_im[261], x_im[260], x_im[259], x_im[258], x_im[257], x_im[256], x_im[255], x_im[254], x_im[253], x_im[252], x_im[251], x_im[250], x_im[249], x_im[248], x_im[247], x_im[246], x_im[245], x_im[244], x_im[243], x_im[242], x_im[241], x_im[240], x_im[239], x_im[238], x_im[237], x_im[236], x_im[235], x_im[234], x_im[233], x_im[232], x_im[231], x_im[230], x_im[229], x_im[228], x_im[227], x_im[226], x_im[225], x_im[224], x_im[223], x_im[222], x_im[221], x_im[220], x_im[219], x_im[218], x_im[217], x_im[216], x_im[215], x_im[214], x_im[213], x_im[212], x_im[211], x_im[210], x_im[209], x_im[208], x_im[207], x_im[206], x_im[205], x_im[204], x_im[203], x_im[202], x_im[201], x_im[200], x_im[199], x_im[198], x_im[197], x_im[196], x_im[195], x_im[194], x_im[193], x_im[192], x_im[191], x_im[190], x_im[189], x_im[188], x_im[187], x_im[186], x_im[185], x_im[184], x_im[183], x_im[182], x_im[181], x_im[180], x_im[179], x_im[178], x_im[177], x_im[176], x_im[175], x_im[174], x_im[173], x_im[172], x_im[171], x_im[170], x_im[169], x_im[168], x_im[167], x_im[166], x_im[165], x_im[164], x_im[163], x_im[162], x_im[161], x_im[160], x_im[159], x_im[158], x_im[157], x_im[156], x_im[155], x_im[154], x_im[153], x_im[152], x_im[151], x_im[150], x_im[149], x_im[148], x_im[147], x_im[146], x_im[145], x_im[144], x_im[143], x_im[142], x_im[141], x_im[140], x_im[139], x_im[138], x_im[137], x_im[136], x_im[135], x_im[134], x_im[133], x_im[132], x_im[131], x_im[130], x_im[129], x_im[128], x_im[127], x_im[126], x_im[125], x_im[124], x_im[123], x_im[122], x_im[121], x_im[120], x_im[119], x_im[118], x_im[117], x_im[116], x_im[115], x_im[114], x_im[113], x_im[112], x_im[111], x_im[110], x_im[109], x_im[108], x_im[107], x_im[106], x_im[105], x_im[104], x_im[103], x_im[102], x_im[101], x_im[100], x_im[99], x_im[98], x_im[97], x_im[96], x_im[95], x_im[94], x_im[93], x_im[92], x_im[91], x_im[90], x_im[89], x_im[88], x_im[87], x_im[86], x_im[85], x_im[84], x_im[83], x_im[82], x_im[81], x_im[80], x_im[79], x_im[78], x_im[77], x_im[76], x_im[75], x_im[74], x_im[73], x_im[72], x_im[71], x_im[70], x_im[69], x_im[68], x_im[67], x_im[66], x_im[65], x_im[64], x_im[63], x_im[62], x_im[61], x_im[60], x_im[59], x_im[58], x_im[57], x_im[56], x_im[55], x_im[54], x_im[53], x_im[52], x_im[51], x_im[50], x_im[49], x_im[48], x_im[47], x_im[46], x_im[45], x_im[44], x_im[43], x_im[42], x_im[41], x_im[40], x_im[39], x_im[38], x_im[37], x_im[36], x_im[35], x_im[34], x_im[33], x_im[32], x_im[31], x_im[30], x_im[29], x_im[28], x_im[27], x_im[26], x_im[25], x_im[24], x_im[23], x_im[22], x_im[21], x_im[20], x_im[19], x_im[18], x_im[17], x_im[16], x_im[15], x_im[14], x_im[13], x_im[12], x_im[11], x_im[10], x_im[9], x_im[8], x_im[7], x_im[6], x_im[5], x_im[4], x_im[3], x_im[2], x_im[1], x_im[0]};
	
	//	Internal
	reg [4:0] i;
	reg [9:0] j, k;
	wire signed [15:0] twiddle_re, twiddle_im;
	wire signed [31:0] top_re, top_im;
	wire signed [63:0] bot_re, bot_im;
	
	wire [9:0] TERM_I, TERM_J, TERM_K, n_blocks, n_passes, address, i_top, i_bot;
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
	
	//		Intermediates
	//		Complex multiplication (a+bi)(c+di) = (ac-bd)+i(ad+bc)
	assign ac = x_re[i_bot]*twiddle_re;
	assign bd = x_im[i_bot]*twiddle_im;
	assign ad = x_re[i_bot]*twiddle_im;
	assign bc = x_im[i_bot]*twiddle_re;
	
	assign top_re = x_re[i_top];
	assign top_im = x_im[i_top];
	
	assign bot_re = (ac-bd);
	assign bot_im = (ad+bc);
		
	//	Twiddle LUT
	FFT8_LUT FFTLUT (
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
				//	Out: LOAD
				INIT:
				begin
					{i,j,k} <= 0;
					if(Start)
						state <= LOAD;
					else
						state <= INIT;
				end
			
			
				//	State: Load
				//	Inc: INIT
				//	Out: PROC
				LOAD:
				begin
					//
					//	Bit Reversal is required for in-place algorithms.  The unpacking happens here too.
					//
					//	Decimal index -> Binary -> Reverse Binary -> New decimal index
					//	          9   -> 01001  -> 10010          -> 18
					//
					//	See ee201_sequential_FFT.m
					//
					x_re[0]<=x_re_packed[31:0]; 
					x_re[1]<=x_re_packed[543:512]; x_re[2]<=x_re_packed[287:256]; x_re[3]<=x_re_packed[799:768]; x_re[4]<=x_re_packed[159:128]; x_re[5]<=x_re_packed[671:640]; x_re[6]<=x_re_packed[415:384]; x_re[7]<=x_re_packed[927:896]; x_re[8]<=x_re_packed[95:64]; x_re[9]<=x_re_packed[607:576]; x_re[10]<=x_re_packed[351:320]; x_re[11]<=x_re_packed[863:832]; x_re[12]<=x_re_packed[223:192]; x_re[13]<=x_re_packed[735:704]; x_re[14]<=x_re_packed[479:448]; x_re[15]<=x_re_packed[991:960]; x_re[16]<=x_re_packed[63:32]; x_re[17]<=x_re_packed[575:544]; x_re[18]<=x_re_packed[319:288]; x_re[19]<=x_re_packed[831:800]; x_re[20]<=x_re_packed[191:160]; x_re[21]<=x_re_packed[703:672]; x_re[22]<=x_re_packed[447:416]; x_re[23]<=x_re_packed[959:928]; x_re[24]<=x_re_packed[127:96]; x_re[25]<=x_re_packed[639:608]; x_re[26]<=x_re_packed[383:352]; x_re[27]<=x_re_packed[895:864]; x_re[28]<=x_re_packed[255:224]; x_re[29]<=x_re_packed[767:736]; x_re[30]<=x_re_packed[511:480]; x_re[31]<=x_re_packed[1023:992];
					x_im[0]<=x_im_packed[31:0]; 
					x_im[1]<=x_im_packed[543:512]; x_im[2]<=x_im_packed[287:256]; x_im[3]<=x_im_packed[799:768]; x_im[4]<=x_im_packed[159:128]; x_im[5]<=x_im_packed[671:640]; x_im[6]<=x_im_packed[415:384]; x_im[7]<=x_im_packed[927:896]; x_im[8]<=x_im_packed[95:64]; x_im[9]<=x_im_packed[607:576]; x_im[10]<=x_im_packed[351:320]; x_im[11]<=x_im_packed[863:832]; x_im[12]<=x_im_packed[223:192]; x_im[13]<=x_im_packed[735:704]; x_im[14]<=x_im_packed[479:448]; x_im[15]<=x_im_packed[991:960]; x_im[16]<=x_im_packed[63:32]; x_im[17]<=x_im_packed[575:544]; x_im[18]<=x_im_packed[319:288]; x_im[19]<=x_im_packed[831:800]; x_im[20]<=x_im_packed[191:160]; x_im[21]<=x_im_packed[703:672]; x_im[22]<=x_im_packed[447:416]; x_im[23]<=x_im_packed[959:928]; x_im[24]<=x_im_packed[127:96]; x_im[25]<=x_im_packed[639:608]; x_im[26]<=x_im_packed[383:352]; x_im[27]<=x_im_packed[895:864]; x_im[28]<=x_im_packed[255:224]; x_im[29]<=x_im_packed[767:736]; x_im[30]<=x_im_packed[511:480]; x_im[31]<=x_im_packed[1023:992];
																																							
					//	End Bit Reversal
					state <= PROC;					
				end
			
			
				//	State: Processing
				//	Inc: LOAD
				//	Out: DONE
				PROC:
				begin
					$display("Pass %d Block %d Butterflies %d and %d (i_top %d i_bot %d)", i, j, k, k+n_butterflies/2, i_top, i_bot);
					$display("  --> address %d twiddle %d+i%d", address, twiddle_re, twiddle_im);
					$display("  --> x[i_top] %d + %d i; x[i_bot] %d+%d i", x_re[i_top], x_im[i_top], x_re[i_bot], x_im[i_bot]);
					$display("  --> ac=%d bd=%d ad=%d bc=%d", ac, bd, ad, bc);
					$display("    --> top_re %d top_im %d", top_re, top_im);
					$display("    --> bot_re %d bot_im %d", bot_re, bot_im);
					$display("    --> topim %d botim %d botim>>15 %d nextval %d", top_im, bot_im, bot_im>>15, top_im - (bot_im>>15));
				
			
				
				
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
					//$display("    i_top %d i_bot %d address %d twiddle %d + i %d", i_top, i_bot, address, twiddle_re, twiddle_im);
					x_re[i_top] <= top_re + (bot_re >> 15);
					x_im[i_top] <= top_im + (bot_im >> 15);
					x_re[i_bot] <= top_re - (bot_re >> 15);
					x_im[i_bot] <= top_im - (bot_im >> 15);
					//state <= DONE;
				end
			
			
				//	State: Done
				//	Inc: PROC
				//	Out: DONE
				DONE:
				begin					
					if(Ack)
					begin
						$display("Done.");
						$display("X0 %d + i %d", x_re[0], x_im[0]);
						$display("X1 %d + i %d", x_re[1], x_im[1]);
						$display("X2 %d + i %d", x_re[2], x_im[2]);
						$display("X3 %d + i %d", x_re[3], x_im[3]);
						$display("X4 %d + i %d", x_re[4], x_im[4]);
						$display("X5 %d + i %d", x_re[5], x_im[5]);
						$display("X6 %d + i %d", x_re[6], x_im[6]);
						$display("X7 %d + i %d", x_re[7], x_im[7]);
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