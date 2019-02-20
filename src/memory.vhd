-------------------------------------------------------------------------------
--THE MEMOPRY
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      
use ieee.numeric_std.all;

entity memory is 
  generic (addr_width : integer := 2;--4x8 memory 2^2=4, 2^A = N
           data_width : integer := 8);
  port (
    clk               : in std_logic;
    we                : in std_logic;--write enable
    addr              : in std_logic_vector(addr_width - 1 downto 0);--address
    din               : in std_logic_vector(data_width - 1 downto 0);
    dout              : out std_logic_vector(data_width - 1 downto 0)
  );
end memory;

architecture beh of memory is
-- signal declarations
type ram_type is array ((2 ** addr_width -1) downto 0) of std_logic_vector(data_width -1 downto 0);-- type ram_type is array 4 bits of 8 bits
signal RAM : ram_type := (others => (others => '0'));

begin 

process(clk)
begin
  if (clk'event and clk = '1') then
    if (we = '1') then
      RAM(to_integer(unsigned(addr))) <= din;
    end if;
    dout <= RAM(to_integer(unsigned(addr)));
  end if;
end process;

end beh; 