
module nios_system (
	clk_clk,
	reset_reset_n,
	avalon_bridge0_acknowledge,
	avalon_bridge0_irq,
	avalon_bridge0_address,
	avalon_bridge0_bus_enable,
	avalon_bridge0_byte_enable,
	avalon_bridge0_rw,
	avalon_bridge0_write_data,
	avalon_bridge0_read_data,
	avalon_bridge1_acknowledge,
	avalon_bridge1_irq,
	avalon_bridge1_address,
	avalon_bridge1_bus_enable,
	avalon_bridge1_byte_enable,
	avalon_bridge1_rw,
	avalon_bridge1_write_data,
	avalon_bridge1_read_data);	

	input		clk_clk;
	input		reset_reset_n;
	input		avalon_bridge0_acknowledge;
	input		avalon_bridge0_irq;
	output	[10:0]	avalon_bridge0_address;
	output		avalon_bridge0_bus_enable;
	output	[1:0]	avalon_bridge0_byte_enable;
	output		avalon_bridge0_rw;
	output	[15:0]	avalon_bridge0_write_data;
	input	[15:0]	avalon_bridge0_read_data;
	input		avalon_bridge1_acknowledge;
	input		avalon_bridge1_irq;
	output	[10:0]	avalon_bridge1_address;
	output		avalon_bridge1_bus_enable;
	output	[1:0]	avalon_bridge1_byte_enable;
	output		avalon_bridge1_rw;
	output	[15:0]	avalon_bridge1_write_data;
	input	[15:0]	avalon_bridge1_read_data;
endmodule
