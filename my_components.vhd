-------------------------------------------------------------------------------
--THE COMPONENts
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package my_components is
    
component rising_edge_synchronizer is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end component;

component counter is 
  port (
      clk 					: IN STD_LOGIC;
      reset 				: IN STD_LOGIC;
      enable                : IN STD_LOGIC; --this is the pushbutton1
      flag 					: OUT STD_LOGIC 
  );
end component;

end my_components;