--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*********  Copyright 2018, Rochester Institute of Technology  ***************
--*****************************************************************************
--
--       LAB NAME:  Custom Component demo
--
--      FILE NAME:  custom_component_demo.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--      This is the top level VHDL for the custom IP demo.  It does not do
--      anything interesting. It reads four input switches from the DE1 board.
--      It then passes on three of those to the custom component to
--      address an internal memory location.  It displays the lower 10
--      bits of the value of the internal memory location (given by the custom
--      IP) on the red leds. If the user chooses an address > 8, the invalid
--      signal is set high indicating an error condition.
--
--  REVISION HISTORY
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 09/07/18 | JWC  | 1.0 | 
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY custom_component_demo IS
  PORT(CLOCK_50  : IN    std_logic;
       KEY       : IN    std_logic_vector(0 DOWNTO 0);
       SW        : IN    std_logic_vector(3 DOWNTO 0);
       LEDR      : OUT   std_logic_vector(9 DOWNTO 0)
       );
END custom_component_demo;

ARCHITECTURE Structure OF custom_component_demo IS

  -----------------------------------------------------------------------------
  -- define components: get nios_system component from nios_system_inst.vhd file
  -----------------------------------------------------------------------------
  component nios_system is
		port (
			clk_clk            : in  std_logic                     := 'X';             -- clk
			reset_reset_n      : in  std_logic                     := 'X';             -- reset_n
			custom_ip_ext_addr : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- ext_addr
			custom_ip_ext_data : out std_logic_vector(31 downto 0);                    -- ext_data
			custom_ip_invalid  : in  std_logic                     := 'X'              -- invalid
		);
	end component nios_system;

  -----------------------------------------------------------------------------
  -- define internal signals
  -----------------------------------------------------------------------------
  SIGNAL address : std_logic_vector(2 DOWNTO 0);
  SIGNAL data    : std_logic_vector(31 DOWNTO 0);
  SIGNAL invalid : std_logic;

BEGIN

  --this process makes sure that the user has only chosen an address between
  --0 and 7 and assigns the address the value of the switches if valid
  check_add : PROCESS(SW)
  BEGIN
    IF (SW > "0111") THEN
      invalid <= '1';
      address <= "000";
    ELSE
      invalid <= '0';
       -- read the switches
      address <= SW(2 DOWNTO 0);
    END IF;
  END PROCESS;

   --output 16 bits on the LEDs
  LEDR <= data(9 DOWNTO 0);

--instantiate and port map the NIOS II component. 
u0 : component nios_system
		port map (
			clk_clk            => CLOCK_50,            --       clk.clk
			reset_reset_n      => KEY(0),      --     reset.reset_n
			custom_ip_ext_addr => address, -- custom_ip.ext_addr
			custom_ip_ext_data => data, --          .ext_data
			custom_ip_invalid  => invalid   --          .invalid
		);
END ARCHITECTURE Structure;
