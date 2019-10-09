library IEEE;
 
use IEEE.STD_LOGIC_1164.ALL;
  
use IEEE.NUMERIC_STD.ALL; 
 
use IEEE.STD_LOGIC_SIGNED.ALL; 

ENTITY counter  IS

	PORT ( 			
                    clk 					: IN STD_LOGIC;
					reset 				    : IN STD_LOGIC;
                    enable                  : IN STD_LOGIC; --this is the pushbutton1
					flag 					: OUT STD_LOGIC 
		  ); 

END counter;

ARCHITECTURE  beh OF Conversion IS


signal count                                : std_logic_vector(2 downto 0) :="000"; 


BEGIN ---

The_5_Cycle_Count: Process ( reset_n, clk)

BEGIN

	if (reset_n = '1') THEN
	
			count <= "000";

		elsif ((clk'EVENT) AND (clk= '1')) THEN
        
                if(enable = '1')then --if the push button was pushed
		
			        if (count > "101") THEN
            
					    count <= "000";
                        
                        flag <= '0'; --when it reached 5 dont be active

			            else --if it is not greater than 5
            
				            count <= count + '1';
                    
                            flag <= '1'; --active while it counts to 5
                        
                else
                        
                    flag <= '0';
                        
			        END IF;
                    
                END IF;
	END IF;

 END PROCESS;
 

 
END beh;
