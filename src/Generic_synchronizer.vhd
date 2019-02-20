-------------------------------------------------------------------------------
--THE Synchronizer
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;    
--Synchronizer ensures that the inputs go in at the same time
entity Generic_synchronizer is
 generic (
    bits    : integer := 8
  );
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    async_in          : in  std_logic_vector(bits-1 downto 0);--8 bit input
    sync_out          : out  std_logic_vector(bits-1 downto 0)--8 bit output
  );
end Generic_synchronizer;

architecture beh of Generic_synchronizer is
-- signal declarations
signal flop1     : std_logic_vector(bits-1 downto 0);
signal flop2     : std_logic_vector(bits-1 downto 0);

begin 
double_flop :process(reset,clk,async_in)
  begin
    if reset = '1' then
      flop1 <=(others => '0');--has to be 8 bits because of the 8 bit input  := (others => '0')--to fill if you don't know the value;
      flop2 <=(others => '0');--has to be 8 bits because of the 8 bit input   := (others => '0');

--at the rising edge of the clk, the input aync_in goes in a register to output the first signal flop1.
--Then that output becomes the new input for the new ouput of flop2 in which is also a signal
    elsif rising_edge(clk) then
      flop1 <= async_in;--async in is the input
      flop2 <= flop1;
    end if;
end process;
sync_out <= flop2;
end beh; 