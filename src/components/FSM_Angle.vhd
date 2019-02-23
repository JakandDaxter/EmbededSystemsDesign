-------------------------------------------------------------------------------
-- Angle state machine
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
     

entity FSM_Angle is 

    port (
          clk                                           : in   std_logic;
          reset                                         : in   std_logic;
          Angle1		                                : out  std_logic_vector(7 downto 0);
		  Angle2		                                : out  std_logic_vector(7 downto 0);
          KEY								            : in   std_logic_vector(3 downto 0); --this is coming fromm the rising edge synchronizer
          state											: out  std_logic_vector(5 downto 0)
          );
        
end FSM_Angle;

architecture beh of FSM_Angle is

--CONStANTS
constant MinAngle				: std_logic_vector(7 downto 0):= X"0000C350"; --45
constant MaxAngle				: std_logic_vector(7 downto 0):= X"000186A0"; --135   

constant Input_Min        		: std_logic_vector(5 downto 0):= "000001";
constant Key3_Lock      		: std_logic_vector(5 downto 0):= "000010";
constant Verify_min      		: std_logic_vector(5 downto 0):= "000100";
constant Input_Max     			: std_logic_vector(5 downto 0):= "001000";
constant Key2_Lock    	 		: std_logic_vector(5 downto 0):= "010000";
constant Verify_max    	 		: std_logic_vector(5 downto 0):= "100000";

-- signal declarations
signal VerfiedMin				: std_logic; --min value meets the criteria
signal verfiedMax				: std_logic; --max value meets the criteria

signal Present_State     		: std_logic_vector(3 downto 0);--current state
signal Next_State       	    : std_logic_vector(3 downto 0);--next state

BEGIN


-- state register

The_Default_Process :process(clk,reset,Present_State,Next_State,Input_Min,Key3_Lock,Verify_min,Input_Max,Key2_Lock,Verify_max)

      BEGIN
            if (reset = '1') then --active high reset switch
            
              Present_State <= Read_w ;-- A is the default state after reset
              
              elsif (clk'event and clk = '1') then --gott wait for the clck to be one in order to change states anyway, make sure the program knows it
    
          Present_State <= Next_State;--goes to the next state
      
            end if;
            
          end process;
          
--*****************************************************************************************************************************--  
-- next state logic
    process(Next_State , Execute_btn_sync , Present_State) --We lookin at the present_state, and the cases within the present state and putting them to the next state
    
        begin
            
          --give it default values so it doesnt cry
          
         
          state <= Present_State;
          
              Next_State <= Present_State; --this is just so we dont latch anything, dont want the board to catch on fire
              
--*****************************************************************************************************************************--  
         
          Case Present_state IS --WE LOOKIN AT THE CASES (states) WITHIN the present state
          
--*****************************************************************************************************************************-- 
          
            When Read_w => 
      
                writer <= '0';
                
                
      
              if(Execute_btn_sync = '1') THEN
          
                  Next_State <= A_State; 
            
              end if; --end that if cause there isnt any other states we go to 
            
--*****************************************************************************************************************************-- 
            
              When A_State =>
        
                if(Execute_btn_sync = '1') THEN
            
                    Next_State <= B_State;
            
                end if;
                
--*****************************************************************************************************************************-- 
              
                When B_State =>
        
                  if(Execute_btn_sync = '1') THEN
                
                      Next_State <= Product;
                
                  end if;
                  
--*****************************************************************************************************************************-- 

                    When Product =>
                    
                    if(Execute_btn_sync = '1') THEN
                    
                        Next_State <= Operation;
                    
                    end if;
                    
--*****************************************************************************************************************************--                     
                                when others =>
      
                                        Next_State <= Operation; --this is our default state, we always going back to it
      
                    END CASE;
                                      
                                      
                        END PROCESS;
                        
--*****************************************************************************************************************************-- 
 write_en <= writer;
 
 recall <= recalling;
 
 save <= saving;
 
--*****************************************************************************************************************************--  
--*****************************************************************************************************************************--  

                                                      
end beh;                                     
                                             