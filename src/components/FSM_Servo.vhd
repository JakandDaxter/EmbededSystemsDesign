-------------------------------------------------------------------------------
-- Servo State Machine
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
     

entity FSM_Servo is 

    port (
          clk                                           : in   std_logic;
          reset                                         : in   std_logic;
          Address_for_mems                              : out  std_logic_vector(1 downto 0);
          Execute_btn_sync,Saves,Writes,Recalls         : in   std_logic;--this is coming fromm the rising edge synchronizer
          LED_display                                   : out  std_logic_vector(4 downto 0);--this is just to show the state on the LED display so we know what state we are in
          write_en,recall,save                          : out  std_logic;
          Address_for_mems                              : out  std_logic_vector(1 downto 0)
          
          );

end FSM_Servo;

architecture beh of FSM_Servo is
    
-- signal declarations

constant Read_w        		: std_logic_vector(4 downto 0):= "00001";--signal for State Read_working
constant Write_w_no_op      : std_logic_vector(4 downto 0):= "00010";--signal for State Write_w_no_op
constant Write_w      		: std_logic_vector(4 downto 0):= "00100";--signal for Sum state
constant Write_s     		: std_logic_vector(4 downto 0):= "01000";--signal for Subtract State
constant Read_s    	 		: std_logic_vector(4 downto 0):= "10000";--signal for Subtract State

signal writer,recalling,saving      :std_logic;
signal  Address_for_mem             :std_logic_vector(1 downto 0); --i set this ot the repsected address i want to write to

signal Present_State     		: std_logic_vector(3 downto 0);--current state
signal Next_State       	    : std_logic_vector(3 downto 0);--next state

BEGIN


-- state register

The_Default_Process :process(clk,reset,Present_State,Next_State,Saves,Writes,Recalls)

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
          
         
          LED_display <= Present_State;
          
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
                                             