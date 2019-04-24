--------------------------------------------------------------------------------------------------------
-- This module is designed to interface between an Avalon bridge from a nios II system and
-- an external RAM
--------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity RAM_controller is
	PORT( clk                : in  std_logic                     := 'X';             -- clk
			reset_n            : in  std_logic                     := 'X';             -- reset_n
         ---- Bridge Interface 
			bridge_acknowledge : out  std_logic                     := 'X';             -- acknowledge
			bridge_irq         : out  std_logic                     := 'X';             -- irq
			bridge_address     : in std_logic_vector(10 downto 0);                    -- address
			bridge_bus_enable  : in std_logic;                                        -- bus_enable
			bridge_byte_enable : in std_logic_vector(1 downto 0);                     -- byte_enable
			bridge_rw          : in std_logic;                                        -- rw (0 = write, 1= read)
			bridge_write_data  : in std_logic_vector(15 downto 0);                    -- write_data
			bridge_read_data   : out  std_logic_vector(15 downto 0) := (others => 'X');  -- read_data
			---- RAM interface
			ram_address		: out STD_LOGIC_VECTOR (10 DOWNTO 0);
			ram_data		   : out STD_LOGIC_VECTOR (15 DOWNTO 0);
			ram_wren		   : out STD_LOGIC ;
			ram_q		      : in STD_LOGIC_VECTOR (15 DOWNTO 0));
end RAM_controller;

architecture behavior of RAM_controller is

	signal bus_enable_d1 : std_logic;
   signal bus_enable_d2 : std_logic;
	signal address       : std_logic_vector(10 downto 0);

	begin
		ram_wren <= (not bridge_rw) and bridge_bus_enable;   --write to the external ram when it is enabled for write
		ram_address <= bridge_address(10 downto 1) & bridge_byte_enable(1);  --allow for reads and writes by bytes
		ram_data <= bridge_write_data;
		bridge_read_data <= ram_q;
		
		ack_process : process(clk, reset_n) --this creates the acknowledge after the enable
			begin
				if (reset_n = '0') then
					bus_enable_d1 <= '0';
					bus_enable_d2 <= '0';
					bridge_acknowledge <= '0';
				elsif (rising_edge(clk)) then
					bus_enable_d1 <= bridge_bus_enable;
					bus_enable_d2 <= bus_enable_d1;
					if ((bus_enable_d1 = '1') and (bus_enable_d2 = '0')) then
						bridge_acknowledge <= '1';
					else
						bridge_acknowledge <= '0';
					end if;
				end if;
			end process;
end behavior;