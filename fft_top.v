module fft_top(
	input ClkPort,
	output St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar,
	input Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0,
	input Btn0, Btn1, Btn3,
	output Ld0, Ld1, Ld2, Ld3, Ld4, Ld5, Ld6, Ld7,
	output An0, An1, An2, An3,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp
);

	wire Btn0_db;
	ee201_debouncer #(.N_dc(24)) Btn_0_db (
		.CLK(ClkPort), 
		.RESET(Reset), 
		.PB(Btn0), 
		.DPB( ), 
		.SCEN(Btn0_db), 
		.MCEN( ), 
		.CCEN( )
	); 
	
	wire [3:0] SSD0, SSD1, SSD2, SSD3;
	fft_sm core (
		.Clk(ClkPort),
		.Reset(Btn3),
		.Start(Btn0_db),
		.Inspect({Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0}),
		
		.Result({SSD3, SSD2, SSD1, SSD0}),
		.ActivateSSD(ActivateSSD),
		.Done(Ld0),
		.Ready(Ld1),
		.Overflow(Ld7)
	);
	
	ssdhex ssd (
		.Clk(ClkPort),
		.Reset(Btn3),
		.SSD0(SSD0),
		.SSD1(SSD1),
		.SSD2(SSD2),
		.SSD3(SSD3),
		.Active(ActivateSSD),
		.Enables({An3, An2, An1, An0}),
		.Cathodes({Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp})
	);
	
	// Disable the memories
	assign {St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar} = {5'b11111};
	assign { Ld3, Ld4, Ld5, Ld6, Ld2 } = {5'd0};
	
endmodule