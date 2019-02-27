-------------------------------------------------------------------------------
-- Angle state machine
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

     

entity FSM_Angle is 

    port (
          clk                                           : in   std_logic;
          reset                                         : in   std_logic;
          Angle1		                                : in   std_logic; --minimum angle verified from C
		  Angle2		                                : in   std_logic; --maximum angle verified from C
		  Write_en										: out  std_logic; --write enable
		  Start_Servo								    : out  std_logic; --start the servo state machine enable 
          KEY								            : in   std_logic_vector(3 downto 0); --this is coming fromm the rising edge synchronizer
          state											: out  std_logic_vector(5 downto 0)
          );
        
end FSM_Angle;

architecture beh of FSM_Angle is

--CONStANTS
constant MinAngle				: std_logic_vector(7 downto 0):= X"0000C350"; --45
constant MaxAngle				: std_logic_vector(7 downto 0):= X"000186A0"; --135   

constant Input_Min        		: std_logic_vector(5 downto 0):= "000001";
constant Verify_min      		: std_logic_vector(5 downto 0):= "000100";   --gave each state their ID so i know where i am in the state machine
constant Input_Max     			: std_logic_vector(5 downto 0):= "001000";
constant Verify_max    	 		: std_logic_vector(5 downto 0):= "100000";

-- signal declarations

signal verfiedMin				: std_logic := '0'; --min value meets the criteria set to a 1 else 0
signal verfiedMax				: std_logic := '0'; --max value meets the criteria set to a 1 else 0

signal Key3_Lock      			: std_logic := '1'; --to lock in the minimum value
signal Key2_Lock    	 		: std_logic := '1'; --to lock in the maximum value

signal Start_Servo				: std_logic := '0'; --signal to the let the program nkow the the angles have been verified and that the servo manin application can begin

signal Present_State     		: std_logic_vector(5 downto 0);--current state
signal Next_State       	    : std_logic_vector(5 downto 0);--next state

BEGIN

Key3_Lock <= KEY(3); --to lock in the minimum value

Key2_Lock <= KEY(2); --to lock in the maximum values

-- state register

The_Default_Process :process(clk,reset,Present_State,Next_State)

      BEGIN
            if (reset = '1') then --active high reset switch
            
              Present_State <= Input_Min;-- A is the default state after reset
              
              elsif (clk'event and clk = '1') then --gott wait for the clck to be one in order to change states anyway, make sure the program knows it
    
          Present_State <= Next_State;--goes to the next state
      
            end if;
            
          end process;
          
--*****************************************************************************************************************************--  
-- next state logic
    process(Next_State, Present_State, Input_Min, Verify_min, Input_Max, Verify_max) --We lookin at the present_state, and the cases within the present state and putting them to the next state
    
        begin
            
          --give it default values so it doesnt cry
          
         
          state <= Present_State;
          
              Next_State <= Present_State; --this is just so we dont latch anything, dont want the board to catch on fire
              
--*****************************************************************************************************************************--  
         
          Case Present_state IS --WE LOOKIN AT THE CASES (states) WITHIN the present state
          
--------------------------------- 
--recevie the minimum angle

            When Input_Min =>     
      
              if(Key3_Lock = '0') THEN
          
                  Next_State <= Verify_min; 
            
              end if; --end that if cause there isnt any other states we go to 
            
---------------------------------------          
              When Verify_min =>
        
                if(verfiedMin = '1') THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
           
					Write_en <= '1';  -- also let the write enable bit turn on so that you can store the min value into the register
				
                    Next_State <= Input_Max;
            
                end if;
------------------------------------------
          
              When Input_Max =>
        
                if(Key2_Lock = '0') THEN 
            
                    Next_State <= Verify_max;
            
                end if;
------------------------------------------  

                    When Verify_max =>
					                 
                    if(verfiedMax = '1') THEN --this is the flag i will set to a 1 in the C program to let program know that the max value fits the criteria
						
						Write_en <= '1';  -- also let the write enable bit turn on so that you can store the min value into the register					
						
								--if it holds true then let the program now that we can start the servo process.
                    	Start_Servo <= '1';
						
                        Next_State <= Input_Min;
                    
                    end if;
                    
------------------------------------------                     
                                when others =>
      
                                        Next_State <= Input_Min; --this is our default state, we always going back to it
      
                    END CASE;
                                      
                                      
                        END PROCESS;
                        
--*****************************************************************************************************************************--
--*****************************************************************************************************************************--  
--*****************************************************************************************************************************--  

                                                      
end beh;                                     
                                             