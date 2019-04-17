	nios_system u0 (
		.avalon_bridge_acknowledge (<connected-to-avalon_bridge_acknowledge>), // avalon_bridge.acknowledge
		.avalon_bridge_irq         (<connected-to-avalon_bridge_irq>),         //              .irq
		.avalon_bridge_address     (<connected-to-avalon_bridge_address>),     //              .address
		.avalon_bridge_bus_enable  (<connected-to-avalon_bridge_bus_enable>),  //              .bus_enable
		.avalon_bridge_byte_enable (<connected-to-avalon_bridge_byte_enable>), //              .byte_enable
		.avalon_bridge_rw          (<connected-to-avalon_bridge_rw>),          //              .rw
		.avalon_bridge_write_data  (<connected-to-avalon_bridge_write_data>),  //              .write_data
		.avalon_bridge_read_data   (<connected-to-avalon_bridge_read_data>),   //              .read_data
		.clk_clk                   (<connected-to-clk_clk>),                   //           clk.clk
		.ledr_export               (<connected-to-ledr_export>),               //          ledr.export
		.reset_reset_n             (<connected-to-reset_reset_n>)              //         reset.reset_n
	);

