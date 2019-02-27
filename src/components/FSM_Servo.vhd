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
		  Write_enMin									: in   std_logic; --write enable min
		  Write_enMax									: in   std_logic; --write enable max
		  Period		                                : in   std_logic; --flag to let us know that the period is counting so we can=
		  AngleCount		                            : in   std_logic;  
          state											: out  std_logic_vector(5 downto 0)
          );
        
end FSM_Servo;

architecture beh of FSM_Servo is

--CONSTANTS

constant MinAngle						: std_logic_vector(7 downto 0):= X"0000C350"; --45
constant MaxAngle						: std_logic_vector(7 downto 0):= X"000186A0"; --135   

constant Interrupt_right            	: std_logic_vector(3 downto 0):= "1110";
constant Interrupt_left      			: std_logic_vector(3 downto 0):= "1101";   
constant Sweep_Right     				: std_logic_vector(3 downto 0):= "1011";
constant Sweep_Left     				: std_logic_vector(3 downto 0):= "0111";

-- signal declarations

signal Present_State     				: std_logic_vector(5 downto 0);--current state
signal Next_State       	    		: std_logic_vector(5 downto 0);--next state

BEGIN


-- state register

The_Default_Process :process(clk,reset,Present_State,Next_State)

      BEGIN
            if (reset = '1') then --active high reset switch
            
              Present_State <= Sweep_Right;-- A is the default state after reset
              
              elsif (clk'event and clk = '1') then --gott wait for the clck to be one in order to change states anyway, make sure the program knows it
    
          Present_State <= Next_State;--goes to the next state
      
            end if;
            
          end process;
          
--*****************************************************************************************************************************--  
-- next state logic
    process(Next_State, Present_State,Interrupt_right,Interrupt_left,Sweep_Right,Sweep_Left) --We lookin at the present_state, and the cases within the present state and putting them to the next state
    
        begin
            
          --give it default values so it doesnt cry
          
         
          state <= Present_State;
          
              Next_State <= Present_State; --this is just so we dont latch anything, dont want the board to catch on fire
              
--*****************************************************************************************************************************--  
         
          Case Present_state IS --WE LOOKIN AT THE CASES (states) WITHIN the present state
          
--------------------------------- 
--if the write inable is a one

            When Sweep_Right =>     
      
              if("the PW count is less than the max") THEN
          
                  Next_State <= Interrupt_right; 
            
              end if; --end that if cause there isnt any other states we go to 
            
---------------------------------------          
              When Interrupt_right =>
        
                if("the PW count is equal to the max") THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Sweep_Left;
            
                end if;
------------------------------------------
          
              When Sweep_Left =>
        
                if("the PW count is greater than the min") THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Interrupt_left;
            
                end if;
------------------------------------------  

                    When Interrupt_left =>
					                 
                    if("the PW count is equal to the min") THEN --this is the flag i will set to a 1 in the C program to let program know that the max value fits the criteria
						
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
                                             