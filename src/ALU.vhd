-------------------------------------------------------------------------------
--THE MATHS
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;   

entity alu is
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    a             : in  std_logic_vector(7 downto 0);--8 bit input switch
    b             : in  std_logic_vector(7 downto 0);--8 bit input switches
    op            : in  std_logic_vector(1 downto 0); -- 00: add, 01: sub, 10: mult, 11: div
    result        : out std_logic_vector(7 downto 0)--8 bit output
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
      if (op = "00") then--add
        result  <= std_logic_vector(unsigned(a) + unsigned(b));
      elsif (op = "01") then--subtract
        result  <= std_logic_vector(unsigned(a) - unsigned(b));
      elsif (op = "10") then--multiply
        result_temp  <= std_logic_vector(unsigned(a) * unsigned(b));
        result <= result_temp(7 downto 0);
      elsif (op = "11") then--divide
        result_temp  <= std_logic_vector(unsigned("00000000" & a) / unsigned("00000000" & b));
        result <= result_temp(7 downto 0);
      end if;
    end if;
  end process;
end beh;