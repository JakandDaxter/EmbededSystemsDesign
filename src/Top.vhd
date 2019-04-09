-------------------------------------------------------------------------------
-- Aliana Tejeda
-- Top
--(  )_(  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Top is

    port (

      ---- Result Output ----
 
      Result : out std_logic_vector(15 downto 0); --remeber to use key(0) for reset

      ----- CLOCK -----
	 
      CLOCK_50 : in std_logic;
      
      ----- Input -----
      A : in std_logic_vector(15 downto 0); --remeber to use key(0) for reset
      
      B : in std_logic_vector(15 downto 0); --remeber to use key(0) for reset


      ----- KEY -----
      KEY : in std_logic_vector(3 downto 0) --remeber to use key(0) for reset
	    
  	 );
	                  
end Top;  

architecture TimeQuest_demo of Top  is 
--------------------------------------
--Component
--------------------------------------
Component Synchronizer is

		  port (
  
    clk               : in std_logic;
    
    reset             : in std_logic;
    
    async_in          : in  std_logic_vector(15 downto 0);
    
    sync_out          : out  std_logic_vector(15 downto 0)
    
  );
  
  end component Synchronizer;
--------------------------------------
--Signals
--------------------------------------
Signal  A_sync           		:std_logic_vector(15 downto 0); -- sends in the raw data
Signal  B_sync           		:std_logic_vector(15 downto 0); -- sends in the raw data

Signal  Temp                   	:std_logic_vector(15 downto 0); -- sends in the raw data

signal reset_n 					:std_logic;
signal key0_d1 					:std_logic;
signal key0_d2 					:std_logic;
signal key0_d3 					:std_logic;


BEGIN --We begin the ARCHITECTUREE									
--****************************************-- 
--****************************************-- 
--****************************************--  
--****************************************-- 

----- Synchronize the reset
		synchReset_proc : process (CLOCK_50,KEY(0)) begin

		  if (rising_edge(CLOCK_50)) then
              
		    key0_d1 <= KEY(0);
            
		    key0_d2 <= key0_d1;
		    
            key0_d3 <= key0_d2;
		  
          end if;
		
        end process synchReset_proc;

        reset_n <= key0_d3;

--****************************************--

A_Synchonizer: Synchronizer

    Port Map(     
                clk         => CLOCK_50,      
                reset       => reset_n,      
                async_in    => A,      
                sync_out    => A_sync   --use this      
  
        );
    
--****************************************--

B_Synchonizer: Synchronizer

    Port Map( 
    
                clk         => CLOCK_50,      
                reset       => reset_n,      
                async_in    => B,      
                sync_out    => B_sync    --use this         

        );
--****************************************--

Temp <= A_sync + B_sync;  --here is the addition

Result_Synchonizer: Synchronizer

    Port Map( 
    
                clk         => CLOCK_50,      
                reset       => reset_n,      
                async_in    => Temp,      --temporary home for the combination result
                sync_out    => Result    --output        

        );	        	
--*******************************************************************************************************************************************************************************--
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************-- 
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
      
        
end TimeQuest_demo ;