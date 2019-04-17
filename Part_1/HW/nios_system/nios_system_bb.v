
module nios_system (
	avalon_bridge_acknowledge,
	avalon_bridge_irq,
	avalon_bridge_address,
	avalon_bridge_bus_enable,
	avalon_bridge_byte_enable,
	avalon_bridge_rw,
	avalon_bridge_write_data,
	avalon_bridge_read_data,
	clk_clk,
	ledr_export,
	reset_reset_n);	

	input		avalon_bridge_acknowledge;
	input		avalon_bridge_irq;
	output	[10:0]	avalon_bridge_address;
	output		avalon_bridge_bus_enable;
	output	[1:0]	avalon_bridge_byte_enable;
	output		avalon_bridge_rw;
	output	[15:0]	avalon_bridge_write_data;
	input	[15:0]	avalon_bridge_read_data;
	input		clk_clk;
	output	[9:0]	ledr_export;
	input		reset_reset_n;
endmodule
