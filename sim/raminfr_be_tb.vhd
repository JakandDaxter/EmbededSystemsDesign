-------------------------------------------------------------------------------
-- Jodi-Ann Morgan
-- Lab7 test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity raminfr_be_tb is
end raminfr_be_tb;

architecture arch of raminfr_be_tb is

component raminfr_be is
	PORT(
			clk : IN std_logic;
			reset_n : IN std_logic;
			writebyteenable_n : IN std_logic_vector(3 downto 0);-- These signals will be the port lanes of the memory when you write to the RAM. This means that at least one of and be[*] signals needs to asserted to write into the RAM
			address : IN std_logic_vector(11 DOWNTO 0);
			writedata : IN std_logic_vector(31 DOWNTO 0);
			--
			readdata : OUT std_logic_vector(31 DOWNTO 0)
	);
end component;  

signal 		output        : std_logic:='0';
constant 	period        : time := 20 ns;                                              
signal 		clk           : std_logic := '0';
signal 		reset_n       : std_logic ;--active low reset
signal 		writebyte_en  :std_logic_vector(3 downto 0);
signal 		write_data    :std_logic_vector(31 downto 0);
signal 		read_data     :std_logic_vector(31 downto 0);
signal 		address_sig   :std_logic_vector(11 DOWNTO 0);
--signal position :std_logic_vector(31 downto 0);

begin

-- clock process
clock: process
  begin
	clk <= not clk;
	wait for period/2;
end process; 
-- reset process
async_reset: process
  begin
  reset_n<= '0';
	wait for 2 * period;
	 --wait for period/2;
	reset_n <= '1';
	wait;
end process; 
  
-- Stimuli process.
--your testbench should, at a minimum, verify the byte enables
--and write a ramp test pattern to the entire RAM.
--test for 8 bit, 16(2 bytes) and 32 bits( 4 bytes)
	stimuli: process begin
		wait for 500 ns;
		wait for 100 ns;
		writebyte_en <= "1110"; -- 8 bit(1 byte) we(0)
		write_data<= X"12345678";
		wait for 200 ns;
		writebyte_en <= "1101"; -- 8 bit(1 byte) we(1)
		wait for 200 ns;
		writebyte_en <= "1011"; -- 8 bit(1 byte) we(2)
		
		wait for 200 ns;
		writebyte_en <= "0111"; -- 8 bit(1 byte) we(3)
		
----------Half word (16 bits)
		wait for 200 ns;
		writebyte_en <= "0011"; -- top half
		write_data<= X"ABCDEF90";
		wait for 200 ns;
		writebyte_en <= "1100"; -- bottom half
		
----------word (32 bits)
		wait for 200 ns;
		writebyte_en <= "0000"; -- all active
		write_data<= X"87654321";
		--write_data<= X"ABCDEF90";
		
		

		wait;
	end process;
  
  
uut: raminfr_be
  port map(
	clk 				=> clk,
    reset_n             => reset_n,
    writebyteenable_n   => writebyte_en,
    address             => address_sig,
    writedata           => write_data,
	readdata			=> read_data
  );


end arch;