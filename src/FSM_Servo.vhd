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
		  Write_en									    : out  std_logic; --write enable 
	  	  Max_Interrupt									: in   std_logic; --the interrupt that will become a one when the PW count made it to the max
	      Min_Interrupt									: in   std_logic; --the interrupt that will become a one when the PW count made it to the min  
          state											: out  std_logic_vector(3 downto 0)
          );
        
end FSM_Servo;

architecture beh of FSM_Servo is

--CONSTANTS

constant MinAngle						: std_logic_vector(31 downto 0):= X"0000C350"; --45
constant MaxAngle						: std_logic_vector(31 downto 0):= X"000186A0"; --135   

CONSTANT Interrupt_right            	: std_logic_vector(3 downto 0):= "1110";
CONSTANT Interrupt_left      			: std_logic_vector(3 downto 0):= "1101";   
CONSTANT Sweep_Right     				: std_logic_vector(3 downto 0):= "1011";
CONSTANT Sweep_Left     				: std_logic_vector(3 downto 0):= "0111";

-- signal declarations

signal Present_State     				: std_logic_vector(3 downto 0);--current state
signal Next_State       	    		: std_logic_vector(3 downto 0);--next state

BEGIN


-- state register

The_Default_Process :process(clk,reset,Present_State,Next_State)

      BEGIN
            if (reset = '0') then --active high reset switch
            
              Present_State <= Sweep_Right;-- A is the default state after reset
              
              elsif (clk'event and clk = '1') then --gott wait for the clck to be one in order to change states anyway, make sure the program knows it
    
          Present_State <= Next_State;--goes to the next state
      
            end if;
            
          end process;
          
--*****************************************************************************************************************************--  
-- next state logic
    process(Next_State, Present_State,Max_Interrupt,Min_Interrupt) --We lookin at the present_state, and the cases within the present state and putting them to the next state
    
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
            
			  else
				  
				  Next_State <= Sweep_Right;
              end if; --end that if cause there isnt any other states we go to 
            
---------------------------------------          
              When Interrupt_right =>
        
                --if(Max_Interrupt = '0') THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Sweep_Left;
  			  --else
				  
  				  --Next_State <= Interrupt_right;
                --end if;
------------------------------------------
          
              When Sweep_Left =>
        
                if(Min_Interrupt = '1') THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Interrupt_left;
            
    			  else
				  
    				  Next_State <= Sweep_Left;
                end if;
------------------------------------------  

                    When Interrupt_left =>
					                 
                    --if(Min_Interrupt = '0') THEN --this is the flag i will set to a 1 in the C program to let program know that the max value fits the criteria
						
                        Next_State <= Sweep_Right;
                    
	    			 -- else
				  
	    				  --Next_State <= Interrupt_left;
                    --end if;
                    
------------------------------------------                     
                                when others =>
      
                                        Next_State <= Sweep_Right; --this is our default state, we always going back to it
      
                    END CASE;
                                      
                                      
                        END PROCESS;
 
Write_Enable: Process(Present_state,clk,reset)
	
		begin
          
		 Case Present_state IS
		 
		 When "1110" =>
			
				Write_en <= '1';
		 
		 When "1101" =>
		 
				Write_en <= '1';
		 
		 When "1011" =>
		 
				Write_en <= '0';
		 
		 When "0111" =>
		 
				Write_en <= '0';
		 
		 WHEN OTHERS =>
						
				Write_en <= '0';
		 
	   END CASE; 
END PROCESS;	   
--*****************************************************************************************************************************--
--*****************************************************************************************************************************--  
--*****************************************************************************************************************************--  
		 
end beh;                                     
                                             