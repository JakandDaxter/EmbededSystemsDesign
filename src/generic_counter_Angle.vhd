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
    clk               : in   std_logic; 
    reset             : in   std_logic;
	Timer             : in   std_logic; --period
	state			  : in   std_logic_vector;
	Max_Interrupt	  : out  std_logic; --the interrupt that will become a one when the PW count made it to the max
	Min_Interrupt	  : out  std_logic; --the interrupt that will become a one when the PW count made it to the min
	PWM           	  : out  std_logic -- will be a one when ever the count has not reached the bounds
  );  
end generic_counter_Angle;  

architecture beh of generic_counter_Angle  is

constant MinAngle				: std_logic_vector(31 downto 0):= X"0000C350"; --45
constant MaxAngle				: std_logic_vector(31 downto 0):= X"000186A0"; --135

constant min_angle_count		:integer:= 50000; 	
constant max_angle_count		:integer:= 100000;

--so we have our max count, we will count and sweep to the right until we reach the max count, after we reach it, then we need to subtract 
--until we meet the min angle. Subtract from the max angle and compare to the min angle, and when equal to. change to sweep right.

signal Angle_count : integer range 0 to 50000000 := 0;


begin
	
--Anglemin <= Angle1; --taking the minimum angle and storing in a signal ...state = "1011"
	
--Anglemax <= Angle2; --taking the maximum angle and storing it into a signal  state = "0111"

	
process(clk,reset,Angle_Count)
  begin
   if (reset = '0') then 
		
      Angle_Count <= 0;
	  
      --PWM <= '0';
	  
   elsif (clk'event and clk = '1') then
      
			  if (Timer = '1' AND state = "1011") then -- sweep rite first
			
				  if (Angle_Count < max_angle_count) then
			  
					  Angle_Count <= Angle_Count + 500;

						end if;
					  
					elsif(Timer = '1' AND state = "0111") Then
					
						if (Angle_Count > min_angle_count) then
			  
							Angle_Count <= Angle_Count - 500;
							
							else
							
								Angle_Count <= Angle_Count;

			end if;	
						
		    end if;
				
	  	  end if; -----
		  
  	end process;
	
--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--	
	process(clk,reset,Angle_Count)
	  begin
	   if (reset = '0') then 
	  
	     PWM <= '0';
	  
	   elsif (clk'event and clk = '1') then
      
				  if (Timer = '1' AND state = "1011") then -- sweep rite first
			
					  if (Angle_Count < max_angle_count) then
			  
						  PWM <= '1';
			
						else
			  
							PWM <= '0';
					
						end if;
						
					elsif(Timer = '1' AND state = "0111") Then	
				
						if (Angle_Count > min_angle_count) then
										  
							PWM <= '1';
					  
								else
			  
						PWM <= '0';

					end if;	
			     
				 end if;
				
		  	  end if;
		  
	  	end process;
--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--		
		process(clk,reset,Angle_Count)
		  begin
		   if (reset = '0') then 
		
		   		Max_Interrupt <= '0';
	  
	  
		   elsif (clk'event and clk = '1') then
      
					  if (Timer = '1' AND state = "1011") then -- sweep rite first
			
						  if (Angle_Count < max_angle_count) then
					  
							  Max_Interrupt <= '0';
							  Min_Interrupt <= '0';
			
							else
					
							Max_Interrupt <= '1';
							Min_Interrupt <= '0';
					
							end if;
						
							elsif(Timer = '1' AND state = "0111") Then	
				
							if (Angle_Count > min_angle_count) then
										  
							Min_Interrupt <= '0';
							 Max_Interrupt <= '0';
					  
								else
			  
						Min_Interrupt <= '1';
						 Max_Interrupt <= '0';

					end if;	
				    end if;
				
			  	  end if;
		  
		  	end process;
--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--
end beh;