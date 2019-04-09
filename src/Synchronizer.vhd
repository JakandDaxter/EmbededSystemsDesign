-------------------------------------------------------------------------------
--THE Synchronizer- 
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      

entity Synchronizer is 

  port (
  
    clk               : in std_logic;
    
    reset             : in std_logic;
    
    async_in          : in  std_logic_vector(15 downto 0);
    
    sync_out          : out  std_logic_vector(15 downto 0)
    
  );
  
end Synchronizer;

architecture beh of Synchronizer is
    
-- signal declarations

signal flop1     :std_logic_vector(15 downto 0);

signal flop2     :std_logic_vector(15 downto 0);

begin 

double_flop :process(reset,clk,async_in)

  begin
      
    if reset = '0' then
        
      flop1 <= "0000000000000000";
         
      flop2 <= "0000000000000000";
        
    elsif rising_edge(clk) then
        
      flop1 <= async_in;
      
      flop2 <= flop1;
      
      end if;
      
end process;

sync_out <= flop2;

end beh;