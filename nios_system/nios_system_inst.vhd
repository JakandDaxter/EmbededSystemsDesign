	component nios_system is
		port (
			clk_clk            : in  std_logic                     := 'X';             -- clk
			custom_ip_ext_addr : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- ext_addr
			custom_ip_ext_data : out std_logic_vector(31 downto 0);                    -- ext_data
			custom_ip_invalid  : in  std_logic                     := 'X';             -- invalid
			reset_reset_n      : in  std_logic                     := 'X'              -- reset_n
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk            => CONNECTED_TO_clk_clk,            --       clk.clk
			custom_ip_ext_addr => CONNECTED_TO_custom_ip_ext_addr, -- custom_ip.ext_addr
			custom_ip_ext_data => CONNECTED_TO_custom_ip_ext_data, --          .ext_data
			custom_ip_invalid  => CONNECTED_TO_custom_ip_invalid,  --          .invalid
			reset_reset_n      => CONNECTED_TO_reset_reset_n       --     reset.reset_n
		);

