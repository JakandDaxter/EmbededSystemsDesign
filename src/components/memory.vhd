-------------------------------------------------------------------------------
-- memory 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      
use ieee.numeric_std.all;

entity memory is 
  generic (addr_width : integer := 2;
           data_width : integer := 8);
  port (
  
    clk               : in std_logic;
    we                : in std_logic;
    addr              : in std_logic_vector(addr_width - 1 downto 0);
    din               : in std_logic_vector(data_width - 1 downto 0);
    dout              : out std_logic_vector(data_width - 1 downto 0)
    
  );
  
end memory;

architecture beh of memory is
-- signal declarations
type ram_type is array ((1 ** (addr_width -1)) downto 0) of std_logic_vector(data_width -1 downto 0);


signal RAM : ram_type := (others => (others => '0')); --just renaming it

begin 

process(clk,we)
begin
  if (clk'event and clk = '1') then
    if (we = '1') then
      RAM(to_integer(unsigned(addr))) <= din; --when execute = '1' the data is written in
    end if;
    dout <= RAM(to_integer(unsigned(addr))); --when at the rising edge of a clock display the data at the given address, not dependent on the write enable
  end if;
end process;

end beh; 