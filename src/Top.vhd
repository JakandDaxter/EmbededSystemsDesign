library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY Top is
  port (

    ----- CLOCK -----
    CLOCK2_50 : in std_logic;

    ----- KEY -----
    KEY : in std_logic_vector(3 downto 0);

    ----- LED -----
    LEDR : out  std_logic_vector(7 downto 0)

  );
end entity Top;

architecture rtl of Top is
  -- signal declarations
  signal led0 : std_logic;
  signal cntr : std_logic_vector(25 downto 0);
  signal ledNios : std_logic_vector(7 downto 0);
  signal reset_n : std_logic;
  signal key0_d1 : std_logic;
  signal key0_d2 : std_logic;
  signal key0_d3 : std_logic;
  
	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X'; -- clk
			led_export         : out std_logic_vector(7 downto 0);        -- export
			pushbuttons_export : in  std_logic                    := 'X'; -- export
			reset_reset_n      : in  std_logic                    := 'X'  -- reset_n
		);
	end component nios_system;
  
begin

  
  ----- Syncronize the reset
  synchReset_proc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      key0_d1 <= KEY(0);
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
    end if;
  end process synchReset_proc;
  reset_n <= key0_d3;
  

  	u0 : component nios_system
		port map (
			clk_clk            => CLOCK2_50,       --         clk.clk
			led_export         => LEDR,         	--         led.export
			pushbuttons_export => KEY(1), 				-- pushbuttons.export
			reset_reset_n      => reset_n      		--       reset.reset_n
		);
		

end architecture rtl;
