-------------------------------------------------------------------------------
-- arithmatic logic unit
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;     

entity alu is
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    a             : in  std_logic_vector(7 downto 0); 
    b             : in  std_logic_vector(7 downto 0);
    op            : in  std_logic_vector(1 downto 0); -- 00: add, 01: sub, 10: mult, 11: div
    result        : out std_logic_vector(7 downto 0)
  );  
end alu;  

architecture beh of alu  is

signal result_temp : std_logic_vector(15 downto 0);

begin
process(clk,reset)
  begin
    if (reset = '1') then 
      result <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (op = "00") then
        result  <= std_logic_vector(unsigned(a) + unsigned(b));
      elsif (op = "01") then
        result  <= std_logic_vector(unsigned(a) - unsigned(b));
      elsif (op = "10") then
        result_temp  <= std_logic_vector(unsigned(a) * unsigned(b));
        result <= result_temp(7 downto 0); -- only looking at the first 8 bits
      elsif (op = "11") then
        result_temp  <= std_logic_vector(unsigned("00000000" & a) / unsigned("00000000" & b));
        result <= result_temp(7 downto 0); -- only looking at the first 8 bits
      end if;
    end if;
  end process;
end beh;