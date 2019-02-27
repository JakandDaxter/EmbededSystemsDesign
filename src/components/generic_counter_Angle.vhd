-------------------------------------------------------------------------------
-- Dr. Kaputa
-- generic counter demo
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;      

entity generic_counter_Angle is
  port (
    clk             : in   std_logic; 
    reset           : in   std_logic;
	Angle1			: in   std_logic_vector(7 downto 0); --min angle			
	Angle2			: in   std_logic_vector(7 downto 0): --max angle
	Time            : in   std_logic; --whether or not im in the sweep state, then start the count
	Max_Interrupt	: out  std_logic; --the interrupt that will become a one when the PW count made it to the max
	Min_Interrupt	: out  std_logic --the interrupt that will become a one when the PW count made it to the min
	PWM           	: out  std_logic; -- will be a one when ever the count has not reached the bounds
  );  
end generic_counter_Angle;  

architecture beh of generic_counter_Angle  is

constant MinAngle				: std_logic_vector(7 downto 0):= X"0000C350"; --45
constant MaxAngle				: std_logic_vector(7 downto 0):= X"000186A0"; --135 	

signal Anglemin					: std_logic_vector(7 downto 0);
signal Anglemax					: std_logic_vector(7 downto 0);

--so we have our max count, we will count and sweep to the right until we reach the max count, after we reach it, then we need to subtract 
--until we meet the min angle. Subtract from the max angle and compare to the min angle, and when equal to. change to sweep right.

signal Angle_Count				: std_logic_vector(7 downto 0); --respected counting signal


begin
	
Anglemin <= Angle1; --taking the minimum angle and storing in a signal
	
Anglemax <= Angle2; --taking the maximum angle and storing it into a signal

	
process(clk,reset,Angle_Count)
  begin
    if (reset = '1') then 
		
      Angle_Count <= 0;
	  
      PWM <= '0';
	  
    	elsif (clk'event and clk = '1') then
      
	  	  if (Time = '1') then -- sweep write first
		
			  if (Angle_Count < Anglemax) then
        
				  Angle_Count <= Angle_Count + 1;
				  
				  PWM <= '1';
				  
				  Max_Interrupt <= '0';
      
	  		else
        
				Angle_Count <= '0';
				
				Max_Interrupt <= '1';
        
				PWM <= '0';
				
			elsif(Max_Interrupt = '1') then
				
  			  if (Angle_Count > Anglemin) then
        
  				  	Angle_Count <= Angle_Count - 1;
				  
  				  	PWM <= '1';
				  
  				  	Min_Interrupt <= '0';
      
  	  				else
        
  						Angle_Count <= '0';
				
  						Min_Interrupt <= '1';
        
  						PWM <= '0';
				end if;
				
	  	  end if; 
    
		end if;
		
	end if;
  
  	end process;

end beh;