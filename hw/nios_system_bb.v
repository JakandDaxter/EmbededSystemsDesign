
module nios_system (
	clk_clk,
	leds_export,
	pushbuttons_export,
	reset_reset_n);	

	input		clk_clk;
	output	[7:0]	leds_export;
	input		pushbuttons_export;
	input		reset_reset_n;
endmodule
