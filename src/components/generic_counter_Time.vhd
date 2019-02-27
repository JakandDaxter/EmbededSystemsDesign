-------------------------------------------------------------------------------
-- Dr. Kaputa
-- generic counter demo
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;      

entity generic_counter_Time is
  generic (
    max_count       : integer := 3
  );
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    output          : out std_logic
  );  
end generic_counter_Time;  

architecture beh of generic_counter_Time  is

signal count_sig    : integer range 0 to max_count := 0;

begin
	
process(clk,reset)
  begin
    if (reset = '0') then 
      count_sig <= 0;
      output <= '0';
    elsif (clk'event and clk = '1') then
      if (count_sig = max_count) then
          count_sig = '0';
          output <= '0';
      else
          count_sig <= count_sig + 1;
          output <= '1';
      end if; 
    end if;
  end process;
  
end beh;