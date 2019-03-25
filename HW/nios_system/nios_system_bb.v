
module nios_system (
	clk_clk,
	hex0_export,
	hex1_export,
	hex2_export,
	hex3_export,
	hex4_export,
	hex5_export,
	pushbuttons_export,
	reset_reset_n,
	servo_controller_0_conduit_end_pwm,
	switches_export);	

	input		clk_clk;
	output	[6:0]	hex0_export;
	output	[6:0]	hex1_export;
	output	[6:0]	hex2_export;
	output	[6:0]	hex3_export;
	output	[6:0]	hex4_export;
	output	[6:0]	hex5_export;
	input	[3:0]	pushbuttons_export;
	input		reset_reset_n;
	output		servo_controller_0_conduit_end_pwm;
	input	[7:0]	switches_export;
endmodule
