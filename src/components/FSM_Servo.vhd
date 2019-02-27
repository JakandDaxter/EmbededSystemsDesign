-------------------------------------------------------------------------------
--Servo state machine
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

     

entity FSM_Servo is 

    port (
          clk                                           : in   std_logic;
          reset                                         : in   std_logic;
          enable		                                : in   std_logic; --start the servo process
		  Write_enable		                            : in   std_logic; --program in the max and min values when this is  a 1
		  Period		                                : in   std_logic; 
		  AngleCount		                            : in   std_logic;  
          state											: out  std_logic_vector(5 downto 0)
          );
        
end FSM_Servo;

architecture beh of FSM_Servo is

--CONSTANTS

constant MinAngle				: std_logic_vector(7 downto 0):= X"0000C350"; --45
constant MaxAngle				: std_logic_vector(7 downto 0):= X"000186A0"; --135   

constant Int_right            	: std_logic_vector(3 downto 0):= "0001";
constant Int_left      			: std_logic_vector(3 downto 0):= "0010";   
constant Sweep_Right     		: std_logic_vector(3 downto 0):= "0100";
constant Sweep_Left     		: std_logic_vector(3 downto 0):= "1000";


-- signal declarations


signal Present_State     		: std_logic_vector(5 downto 0);--current state
signal Next_State       	    : std_logic_vector(5 downto 0);--next state

BEGIN


-- state register

The_Default_Process :process(clk,reset,Present_State,Next_State)

      BEGIN
            if (reset = '1') then --active high reset switch
            
              Present_State <= Int_right;-- A is the default state after reset
              
              elsif (clk'event and clk = '1') then --gott wait for the clck to be one in order to change states anyway, make sure the program knows it
    
          Present_State <= Next_State;--goes to the next state
      
            end if;
            
          end process;
          
--*****************************************************************************************************************************--  
-- next state logic
    process(Next_State, Present_State, Int_right,Int_left,Sweep_Right,Sweep_Left) --We lookin at the present_state, and the cases within the present state and putting them to the next state
    
        begin
            
          --give it default values so it doesnt cry
          
         
          state <= Present_State;
          
              Next_State <= Present_State; --this is just so we dont latch anything, dont want the board to catch on fire
              
--*****************************************************************************************************************************--  
         
          Case Present_state IS --WE LOOKIN AT THE CASES (states) WITHIN the present state
          
--------------------------------- 
--if the write inable is a one

            When Int_right =>     
      
              if(Key3_Lock = '0') THEN
          
                  Next_State <= Int_left; 
            
              end if; --end that if cause there isnt any other states we go to 
            
---------------------------------------          
              When Int_left =>
        
                if(verfiedMin = '1') THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Sweep_Right;
            
                end if;
------------------------------------------
          
              When Sweep_Right =>
        
                if(Key2_Lock = '1') THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Sweep_Left;
            
                end if;
------------------------------------------  

                    When Sweep_Left =>
					                 
                    if(verfiedMax = '1') THEN --this is the flag i will set to a 1 in the C program to let program know that the max value fits the criteria
											--if it holds true then let the program now that we can start the servo process.
                    	Start_Servo <= "1";
						
                        Next_State <= Sweep_Right;
						
					else
						
						Next_State <= Input_Min;
                    
                    end if;
                    
------------------------------------------                     
                                when others =>
      
                                        Next_State <= Sweep_Right; --this is our default state, we always going back to it
      
                    END CASE;
                                      
                                      
                        END PROCESS;
                        
--*****************************************************************************************************************************--
--*****************************************************************************************************************************--  
--*****************************************************************************************************************************--  

                                                      
end beh;                                     
                                             