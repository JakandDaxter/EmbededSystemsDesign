	nios_system u0 (
		.clk_clk                    (<connected-to-clk_clk>),                    //            clk.clk
		.reset_reset_n              (<connected-to-reset_reset_n>),              //          reset.reset_n
		.avalon_bridge0_acknowledge (<connected-to-avalon_bridge0_acknowledge>), // avalon_bridge0.acknowledge
		.avalon_bridge0_irq         (<connected-to-avalon_bridge0_irq>),         //               .irq
		.avalon_bridge0_address     (<connected-to-avalon_bridge0_address>),     //               .address
		.avalon_bridge0_bus_enable  (<connected-to-avalon_bridge0_bus_enable>),  //               .bus_enable
		.avalon_bridge0_byte_enable (<connected-to-avalon_bridge0_byte_enable>), //               .byte_enable
		.avalon_bridge0_rw          (<connected-to-avalon_bridge0_rw>),          //               .rw
		.avalon_bridge0_write_data  (<connected-to-avalon_bridge0_write_data>),  //               .write_data
		.avalon_bridge0_read_data   (<connected-to-avalon_bridge0_read_data>),   //               .read_data
		.avalon_bridge1_acknowledge (<connected-to-avalon_bridge1_acknowledge>), // avalon_bridge1.acknowledge
		.avalon_bridge1_irq         (<connected-to-avalon_bridge1_irq>),         //               .irq
		.avalon_bridge1_address     (<connected-to-avalon_bridge1_address>),     //               .address
		.avalon_bridge1_bus_enable  (<connected-to-avalon_bridge1_bus_enable>),  //               .bus_enable
		.avalon_bridge1_byte_enable (<connected-to-avalon_bridge1_byte_enable>), //               .byte_enable
		.avalon_bridge1_rw          (<connected-to-avalon_bridge1_rw>),          //               .rw
		.avalon_bridge1_write_data  (<connected-to-avalon_bridge1_write_data>),  //               .write_data
		.avalon_bridge1_read_data   (<connected-to-avalon_bridge1_read_data>)    //               .read_data
	);

