-------------------------------------------------------------------------------
--THE TOP
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
LIBRARY ieee;
use ieee.std_logic_1164.all;   
USE ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.my_components.all;

ENTITY TOP is
    PORT(
    clk             : in std_logic;
    push_button     : in std_logic_vector(1 downto 0);
    out_p,out_n     : out std_logic
    );
end TOP;

architecture beh of TOP is
    
    --how to know i have 5 cycles
    signal   cyclesflag                     : std_logic;
    constant cycles                         : std_logic_vector(15 downto 0) := X"3FFF";
    --used for sychonization
    signal key0_d1 					  				:std_logic;
    signal key0_d2 									:std_logic;
    signal key0_d3 									:std_logic;
    --signals for use of code
    signal reset                             :std_logic; --remeber active high
    signal push_btn                          :std_logic; --push_button(1)
    
BEGIN --

-----------------------------------------------

--Synchonize the reset here
synchReset_proc : process (clk) 
BEGIN    
  if (rising_edge(clk)) then 
    key0_d1 <= push_button(0);
    key0_d2 <= key0_d1;
    key0_d3 <= key0_d2;
  end if;
end process synchReset_proc;
-----------------------------

reset <= key0_d3;

--rising edge shconrizer portmap
PushButton1: rising_edge_synchronizer 
  port map(
    clk               => clk,
    reset             => reset,
    input             => push_button(1),
    edge              => push_btn
  );
-------------------------------

--counter portmap
Cycleing5: counter 
    port map(
      clk               => clk,
      reset             => reset,
      enable            => push_btn,
      flag              => cyclesflag
    );
-------------------------------

--Differential Output, one output per process... 

--out_p
DifferentialProcess_P: process(clk,reset,cyclesflag)
BEGIN

    if(reset = '1') then
        
        out_p <= '0';
        
    elsif(clk'event and clk = '1') then
        
        if(cyclesflag = '1') then
            
            out_p <= '1';
            
            else
            
                out_p <= '0';
        end if;
        
    end if;

END PROCESS;
------------
--out_n
DifferentialProcess_n: process(clk,reset,cyclesflag)
BEGIN

    if(reset = '1') then
        
        out_n <= '1';
        
    elsif(clk'event and clk = '1') then
        
        if(cyclesflag = '1') then
            
            out_n <= '0';
            
        else
        
            out_n <= '1';
            
        end if;
        
    end if;

END PROCESS;


end beh;