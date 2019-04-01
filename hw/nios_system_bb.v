
module nios_system (
	clk_clk,
	led_export,
	pushbuttons_export,
	reset_reset_n);	

	input		clk_clk;
	output	[7:0]	led_export;
	input		pushbuttons_export;
	input		reset_reset_n;
endmodule
