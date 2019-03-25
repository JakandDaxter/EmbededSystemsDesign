library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;      

entity Servo_Controller is
  port (
		clk               	       : in   std_logic; 
		reset_n             	   : in   std_logic;
        address                    : in std_logic;
        write                      : in std_logic;
        writedata                  : in std_logic_vector(31 downto 0);
        irq          	  	       : out  std_logic;
		PWM           	  	       : out  std_logic -- will be a one when ever the count has not reached the bounds
  );  
end Servo_Controller;  

architecture beh of Servo_Controller  is
    
TYPE ram_type IS ARRAY (1 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
SIGNAL Registers : ram_type;          --instance of ram_type  
  
--CONSTANTS
constant MinAngle				: std_logic_vector(31 downto 0):= X"0000C350"; --45
constant MaxAngle				: std_logic_vector(31 downto 0):= X"000186A0"; --135

constant max_count             : integer := 1000000;
constant min_angle_count		: integer:= 50000; 	
constant max_angle_count		: integer:= 100000; 

CONSTANT Interrupt_right            	: std_logic_vector(3 downto 0):= "1110";
CONSTANT Interrupt_left      			: std_logic_vector(3 downto 0):= "1101";   
CONSTANT Sweep_Right     				: std_logic_vector(3 downto 0):= "1011";
CONSTANT Sweep_Left     				: std_logic_vector(3 downto 0):= "0111";

-- signal declarations

signal Present_State     				: std_logic_vector(3 downto 0);--current state
signal Next_State 						: std_logic_vector(3 downto 0);    


signal Max_Interrupt									 : std_logic;
signal Min_Interrupt                            : std_logic;
signal Timer 									 : std_logic;
signal count_sig                        : integer range 0 to max_count := 0;
signal Angle_Count                      : integer range 0 to 1000000 := 0;

BEGIN

	
--$$$$$$$$$$$$$$$$. Incrementing or decrementing the PWM. $$$$$$$$$$$$$$$$$--
process(clk,reset_n,Registers)
  begin
   if (reset_n = '1') then 
		
      Angle_Count <= 50000;
	  
   elsif (clk'event and clk = '1') then
      
			  if (Timer = '1' AND Present_State = "1011") then -- sweep rite first
			
				  if (Angle_Count <= Registers(1)) then
			  
					  Angle_Count <= Angle_Count + 1000;

						end if;
					  
					elsif(Timer = '1' AND Present_State = "0111") Then
					
						if (Angle_Count >= Registers(0)) then
			  
							Angle_Count <= Angle_Count - 1000;
							
							else

							
								Angle_Count <= Angle_Count;

			end if;	
						
		    end if;
				
	  	  end if; 
		  
  	end process;
	
--$$$$$$$$$$$$$$$$. What To Write To The Registers. $$$$$$$$$$$$$$$$$--
PROCESS(clk, reset_n,address,write)
BEGIN
  IF (reset_n = '1') THEN
  
                          Registers(0)    <= MinAngle;

                        Registers(1)    <= MaxAngle;
                        
  ELSIF (clk'event AND clk = '1') THEN
  
    IF (write = '1') THEN
    
        IF(address  = '0') THEN
      
                  Registers(0) <= writedata;
                  
              else
                  
                  Registers(1) <= writedata;
                  
                  END IF;
						

    END IF;
    
  END IF;
  
END PROCESS;
--$$$$$$$$$$$$$$$$$$$. PWM Flag.   $$$$$$$$$$$$$$$$$$$$--	
--process(clk,reset_n,Angle_Count,count_sig,Timer)
--	  begin
--	   if (reset_n = '1') then 
--	  
--	     PWM <= '0';
--	  
--	   elsif (clk'event and clk = '1') then
--      
--				  if (Timer = '0' AND Present_State = "1011") then -- sweep rite first
--			
--					  if (Angle_Count >= count_sig  ) then
--			  
--						  PWM <= '1';
--			
--							else
--			  
--							PWM <= '0';
--					
--						end if;
--						
--					elsif(Timer = '0' AND Present_State = "0111") Then --sweep left	
--				
--						if (Angle_Count >= count_sig) then
--										  
--							PWM <= '1';
--					  
--								else
--			  
--						PWM <= '0';
--
--					end if;	
--			     
--				 end if;
--				
--		  	  end if;
--		  
--	  	end process;           
--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--
PWM <= '1' when (count_sig <= Angle_count) else '0';
--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--
--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--
--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$.         FSM Servo.         $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--

The_Default_Process :process(clk,reset_n,Present_State,Next_State)

      BEGIN
            if (reset_n = '1') then --active high reset_n switch
            
              Present_State <= Sweep_Right;-- A is the default state after reset_n
              
              elsif (clk'event and clk = '1') then --gott wait for the clck to be one in order to change states anyway, make sure the program knows it
    
          Present_State <= Next_State;--goes to the next state
      
            end if;
            
          end process;
          
--*****************************************************************************************************************************--  
-- next state logic
process(Next_State, Present_State,Max_Interrupt,Min_Interrupt,write) --We lookin at the present_state, and the cases within the present state and putting them to the next state
    
        begin
            
          --give it default values so it doesnt cry
          
              Next_State <= Present_State; --this is just so we dont latch anything, dont want the board to catch on fire
              
--*****************************************************************************************************************************--  
         
          Case Present_state IS --WE LOOKIN AT THE CASES (states) WITHIN the present state
          
--------------------------------- 
--if the write inable is a one

            When Sweep_Right =>
				
							irq <= '0';
      
              if(Angle_Count >= Registers(1)) THEN
          
                  Next_State <= Interrupt_right; 
            
			  else
				  
				  Next_State <= Sweep_Right;
				  
              end if; --end that if cause there isnt any other states we go to 
            
---------------------------------------          
              When Interrupt_right =>
				  
					irq <= '1';
        
                if(write = '1' ) THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Sweep_Left;
  			  else
				  
  				  Next_State <= Interrupt_right;
				  
                end if;
------------------------------------------
          
              When Sweep_Left =>
				  
						irq <= '0';
						
                if(Angle_count <= Registers(0)) THEN --this is the flag i will set to a 1 in the C program to let program know that the min value fits the criteria
            
                    Next_State <= Interrupt_left;
            
    			  else
				  
    				  Next_State <= Sweep_Left;
                end if;
------------------------------------------  

                    When Interrupt_left =>
						  
						  irq <= '1';
					                 
                     if(write = '1') THEN --this is the flag i will set to a 1 in the C program to let program know that the max value fits the criteria
						
                        Next_State <= Sweep_Right;
                    
	    			       else
				  
	    				       Next_State <= Interrupt_left;
						  
                            end if;
                      
------------------------------------------                     
                                when others =>
										  
										  irq <= '0';
      
                                        Next_State <= Sweep_Right; --this is our default state, we always going back to it
      
                    END CASE;
                                      
                                      
                        END PROCESS;
 
--*****************************************.  The 20ms Clock Count.  ************************************************--
process(clk,reset_n)
 begin
   if (reset_n = '1') then 
     count_sig <= 0;
     Timer <= '0';
   elsif (clk'event and clk = '1') then
     if (count_sig = max_count) then
         count_sig <= 0;
         Timer <= '1';
     else
	  count_sig <= count_sig + 1;
         Timer <= '0';
     end if; 
   end if;
 end process; 
--*****************************************************************************************************************************--
--process(clk,reset_n,Angle_Count,Timer)
--		  begin
--		   if (reset_n = '1') then 
--		
--		   		irq <= '0';
--	  
--	  
--		   elsif (clk'event and clk = '1') then
--      
--					  if (Timer = '1' AND Present_State = "1011") then -- sweep rite first
--
--						  if (Angle_Count >= max_angle_count) then
--		  
--							  irq <= '1';
--
--							else
--		
--							irq <= '0';
--		
--							end if;
--			
--							elsif(Timer = '1' AND Present_State = "0111") Then	
--	
--							if (Angle_Count <= min_angle_count) then
--							  
--							irq <= '1';
--		  
--								else
--  
--						irq <= '0';
--
--					end if;	
--				    end if;
--	
--			  	  end if;
--		  
--		  	end process;    
--*****************************************************************************************************************************--  
end beh;