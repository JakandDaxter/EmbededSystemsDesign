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
--        enable		                                : in   std_logic; --start the servo process
		  Write_en									    : in   std_logic; --write enable 
--		  Period		                                : in   std_logic; --flag to let us know that the period is counting so we can=
--		  AngleCount		                            : in   std_logic;
	  	  Max_Interrupt									: in   std_logic; --the interrupt that will become a one when the PW count made it to the max
	      Min_Interrupt									: in   std_logic; --the interrupt that will become a one when the PW count made it to the min  
          state											: out  std_logic_vector(3 downto 0)
          );
        
end FSM_Servo;

architecture beh of FSM_Servo is

--CONSTANTS

constant MinAngle						: std_logic_vector(31 downto 0):= X"0000C350"; --45
constant MaxAngle						: std_logic_vector(31 downto 0):= X"000186A0"; --135   

signal Interrupt_right            	: std_logic_vector(3 downto 0):= "1110";
signal Interrupt_left      			: std_logic_vector(3 downto 0):= "1101";   
signal Sweep_Right     				: std_logic_vector(3 downto 0):= "1011";
signal Sweep_Left     				: std_logic_vector(3 downto 0):= "0111";

-- signal declarations

signal Present_State     				: std_logic_vector(3 downto 0);--current state
signal Next_State       	    		: std_logic_vector(3 downto 0);--next state

BEGIN


-- state register

The_Default_Process :process(clk,reset,Present_State,Next_State,Sweep_Right)

      BEGIN
            if (reset = '1') then --active high reset switch
            
              Present_State <= Sweep_Right;-- A is the default state after reset
              
              elsif (clk'event and clk = '1') then --gott wait for the clck to be one in order to change states anyway, make sure the program knows it
    
          Present_State <= Next_State;--goes to the next state
      
            end if;
            
          end process;
          
--*****************************************************************************************************************************--  
-- next state logic
    process(Next_State, Present_State,Interrupt_right,Interrupt_left,Sweep_Right,Sweep_Left,Max_Interrupt,Min_Interrupt) --We lookin at the present_state, and the cases within the present state and putting them to the next state
    
        begin
            
          --give it default values so it doesnt cry
          
         
          state <= Present_State;
          
              Next_State <= Present_State; --this is just so we dont latch anything, dont want the board to catch on fire
              
--*****************************************************************************************************************************--  
         
          Case Present_state IS --WE LOOKIN AT THE CASES (states) WITHIN the present state
          
--------------------------------- 
--if the write inable is a one

            When Sweep_Right =>     
      
              if(Max_Interrupt = '1') THEN
          
                  Next_State <= Interrupt_right; 
            
              end if; --end that if cause there isnt any other states we go to 
            
---------------------------------------          
              When Interrupt_right =>
        
                if(Min_Interrupt = '0') THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Sweep_Left;
            
                end if;
------------------------------------------
          
              When Sweep_Left =>
        
                if(Min_Interrupt = '1') THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Interrupt_left;
            
                end if;
------------------------------------------  

                    When Interrupt_left =>
					                 
                    if(Max_Interrupt = '0') THEN --this is the flag i will set to a 1 in the C program to let program know that the max value fits the criteria
						
                        Next_State <= Sweep_Right;
                    
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
                                             