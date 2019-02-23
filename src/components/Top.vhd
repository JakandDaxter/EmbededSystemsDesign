-------------------------------------------------------------------------------
-- Aliana Tejeda
-- Top
--(  )_(  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      
USE work.MY_MAJESTIC_COMPONENTS.all;
entity Top is

  port (
        Intput                              : in   std_logic_vector(7 downto 0);
        Operation                           : in   std_logic_vector(1 downto 0);
        reset_btn                           : in   std_logic; --button
        clk                                 : in   std_logic; --internally wired
        Execute                             : in   std_logic; --button for next state
        Memory_Save                         : in   std_logic; --button
        Memory_Recall                       : in   std_logic; --button
        Hex0,Hex1,Hex2,Hex5                 : out  std_logic_Vector(6 downto 0); 
        LED_display                         : out  std_logic_vector(4 downto 0)--this is just to show the state on the LED display so we know what state we are in
        
       );                   
end Top;  

architecture ServoMotor of Top  is 
--------------------------------------
--Signals
--------------------------------------
Signal  _sync          :std_logic_vector(7 downto 0); -- gets the synchronized input
Signal  B_sync          :std_logic_vector(7 downto 0); -- gets the synchronized input
Signal  input_sync      :std_logic_vector(7 downto 0); -- gets the synchronized input

Signal  A_raw           :std_logic_vector(7 downto 0); -- sends in the raw data
Signal  B_raw           :std_logic_vector(7 downto 0); -- sends in the raw data
     
signal  LEDS            :std_logic_vector(3 downto 0); --lets us know what state we are in, we evaluate what to display based on the LEDS value

Signal  Execute_enable  :std_logic; --this is an input synchronized primarily used in FSM

Signal  Save_enable     :std_logic; --this is an input synchronized

Signal  Recall_enable   :std_logic; --this is an input synchronized

Signal  Reset_enable    :std_logic; --this is an input synchronized

signal  Write_enable    :std_logic; --this was created to set the write bit in the memory file

signal  Address_for_mem :std_logic_vector(1 downto 0); --i set this to the respected address i want to write to
signal  operation_sync  :std_logic_vector(1 downto 0); --synchronize the switch input
--signal  OP              :std_logic_vector(1 downto 0); --same thing as listed above
 
signal  DATA            :std_logic_vector(7 downto 0); --comes from the ALU
signal  DATA_EVALUATED  :std_logic_vector(7 downto 0); --goes into memory
signal  ALU_sig         :std_logic_vector(7 downto 0); --i don't think i need this
signal  Double_Dab_Data :std_logic_vector(7 downto 0); --comes out of memory

Signal actual_data		:std_logic_vector(11 downto 0); -- this is going into the double dabble


signal  Double_Dab_Ones       :std_logic_vector(3 downto 0);
signal  Double_Dab_Tens       :std_logic_vector(3 downto 0);
signal  Double_Dab_Hundres    :std_logic_vector(3 downto 0);
signal  Double_Dab_Thousands  :std_logic_vector(3 downto 0);

BEGIN --We begin the ARCHITECTUREE
--****************************************--  
--****************************************--  
--****************************************--
--actual_data <= "0000"&Double_Dab_Data; --this came from the memory
--we read from address 00
--Here we are sending the respected address over to the memory component
-- Depending on the state DATA_EVALUATED gets the information
--****************************************--  
--****************************************--  
--****************************************--
--This_Is_Evaluating_Data: Process (Reset_enable , DATA_EVALUATED , LEDS , A_sync , Double_Dab_Data , B_sync , DATA)

						BEGIN
						
						CASE LEDS IS	
							WHEN "0010" =>		
								DATA_EVALUATED <=  A_sync;											
									WHEN "0100" =>
										DATA_EVALUATED <=  B_sync;
											WHEN "1000" =>
												DATA_EVALUATED <= DATA;
													WHEN OTHERS => DATA_EVALUATED <= DATA_EVALUATED;
								end case;
						end process;
--****************************************--  
--****************************************--  
--****************************************--
--We_talking_about_Addresses_here: Process(Address_for_mem,Save_enable,Recall_enable)

                                 BEGIN
                                 
							Case LEDS IS
							WHEN "0001" =>
								Address_for_mem <="00";
								WHEN "0010" =>
										IF( Save_enable = '1') THEN
											Address_for_mem <= "01";	
											elsif(Recall_enable = '1') THEN
												Address_for_mem <= "01";	
												else
													Address_for_mem <= "00";	
										end if;	
									WHEN "0100" =>
											IF( Save_enable = '1') THEN	
												Address_for_mem <= "01";		
												elsif(Recall_enable = '1') THEN	
													Address_for_mem <= "01";		
													else		
														Address_for_mem <= "00";		
											end if;		
												WHEN "1000" =>
													IF( Save_enable = '1') THEN	
														Address_for_mem <= "01";		
														elsif(Recall_enable = '1') THEN		
															Address_for_mem <= "01";			
														else				
															Address_for_mem <="00";				
													end if;		
											WHEN OTHERS => Address_for_mem <= "00";
										end case;	
									end process;

--****************************************--
--****************************************--  
--****************************************--  
--****************************************--
--Here we are sending the respected enable bit

--We_talking_about_Enabling_here: Process(Write_enable,Save_enable,Recall_enable)

                        BEGIN
                                        
							Case LEDS IS
							WHEN "0001" =>
								Write_enable <='0';
								WHEN "0010" =>
										IF( Save_enable = '1') THEN
											Write_enable <= '1';	
											elsif(Recall_enable = '1') THEN
												Write_enable <= '0';	
												else
													Write_enable <= '0';	
										end if;	
									WHEN "0100" =>
											IF( Save_enable = '1') THEN
												Write_enable <= '1';	
												elsif(Recall_enable = '1') THEN
													Write_enable <= '0';	
													else
														Write_enable <= '0';
											end if;		
										WHEN "1000" =>
												IF(Save_enable = '1') THEN
													Write_enable <= '1';	
												elsif(Recall_enable = '1') THEN
													Write_enable <= '0';	
													else
														Write_enable <= '0';
											end if;	
											WHEN OTHERS => Write_enable <= '0';
										end case;	
									end process;


--****************************************-- 
--
Just_Sending_Info_Through_Registers1:Process(clk,Reset_enable,input_sync,A_raw,DATA)
                                    BEGIN
                  
                                    if(Reset_enable = '1') THEN
                                        A_raw <= (others => '0');
                                        ELSIF(clk'event and clk = '1') THEN
                                                    if(LEDS = "0010") THEN
														A_raw <= input_sync ;					
													ELSE					
														A_raw <= A_raw ;
															end if;		
									end if;
                           end process;
--****************************************-- 
 
Just_Sending_Info_Through_Registers2:Process(clk,Reset_enable,input_sync,B_raw,DATA)
 
                               BEGIN
                                       if(Reset_enable = '1') THEN      
                                           B_raw <= (others => '0');
                                        ELSIF(clk'event and clk = '1') THEN
                                            if(LEDS = "0100") THEN	
												B_raw <= DATA;   
                                            ELSE
                                                B_raw <= B_raw;
											end if;			   
										end if; 
                      end process;

--****************************************--  
--****************************************-- 
--****************************************--  
--****************************************--  
--****************************************-- 

--put the memory port map here

Memory_for_display: memory 
--this is for the switches for the operation

    Port Map(       
                clk      => clk,        
                we       => write_enable,       --send a 1 if you wanna save data into address 10 else your reading from the working 00
                addr     => Address_for_mem,    --the working memory is 00 so the write enable is a 0
                din      => DATA_EVALUATED,                --its been through the process   
                dout     => Double_Dab_Data     --this is the info we want to display          
        );


--****************************************--  
--****************************************-- 
--****************************************--

Operation_Synchonizer: synchronizer4bit 
--this is for the switches for the operation

    Port Map(   clk        => clk,          
                reset      => Reset_enable,       
                async_in   => Operation,       
                sync_out   => operation_sync  --use this    
        );
        
--****************************************--

Frist_Synchonizer: synchronizer8bit

    Port Map(   
    
                clk        => clk,            
                reset      => Reset_enable,       
                async_in   => Intput,       
                sync_out   => input_sync   --use this      

        
            );
    
--****************************************--

A_Synchonizer: synchronizer8bit

    Port Map(     
                clk         => clk,      
                reset       => Reset_enable,      
                async_in    => A_raw,      
                sync_out    => A_sync   --use this      
  
        );
    
--****************************************--

B_Synchonizer: synchronizer8bit

    Port Map( 
    
                clk         => clk,      
                reset       => Reset_enable,      
                async_in    => B_raw,      
                sync_out    => B_sync    --use this         

        );
    
--****************************************--

Button_Synchonizer_EXECUTE: rising_edge_synchronizer

    Port Map( 
    
                clk      => clk,        
                reset    => Reset_enable,        
                inputy   => Execute,        
                edge     => Execute_enable   --use this     

        
        );
    
--****************************************--

Button_Synchonizer_SAVE: rising_edge_synchronizer

    Port Map(
    
                clk     =>  clk,                
                reset   =>  Reset_enable,        
                inputy  =>  Memory_Save,        
                edge    =>  Save_enable     --use this        

        
        ); 
		
--****************************************--

Button_Synchonizer_RECALL: rising_edge_synchronizer

    Port Map(  
    
                clk     =>  clk,                
                reset   =>  Reset_enable,        
                inputy  =>  Memory_Recall,        
                edge    =>  Recall_enable    --use this      

        
        );  
		
--****************************************-- 
 
Button_Synchonizer_RESET: rising_edge_synchronizer

    Port Map(  
    
                clk     =>  clk,                
                reset   =>  Reset_enable,        
                inputy  =>  reset_btn,        
                edge    =>  Reset_enable     --use this     

    
        );

--*******************************************************************************************************************************************************************************--
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************-- 


--****************************************--
The_State_Machine: FSM

    Port Map(  

            clk                 =>  clk,             
            reset               =>  Reset_enable,    
            Execute_btn_sync    =>      
            LED_display         =>  
            write_en            =>
            recall              =>
            save                =>
                                     
          );
          
--*******************************************************************************************************************************************************************************--

LED_display <= LEDS;
 
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************-- 
 
The_Seperation: double_dabble

    Port Map(
               
           binIN     => actual_data, --this is getting the information from the working memory
           ones      => Double_Dab_Ones,
           tens      => Double_Dab_Tens,
           hundreds  => Double_Dab_Hundres
           );

--****************************************--  
--****************************************--  
--****************************************-- 
 
The_Dab_Display0: BCD

    Port Map( 
         
      clk    => clk,
      reset  => Reset_enable,
      Bin    => Double_Dab_Ones,                            
      Hex    => Hex0
      );
--****************************************--

The_Dab_Display1: BCD

    Port Map(
          
        clk   => clk,         
        reset => Reset_enable,
        Bin   => Double_Dab_Tens,                          
        Hex   => Hex1
      );
	  
--****************************************--

The_Dab_Display2: BCD

    Port Map( 
         
            clk   => clk,         
            reset => Reset_enable,
            Bin   => Double_Dab_Hundres,                          
            Hex   => Hex2
      );
	  
--****************************************--

--this is for the display clarity, goes to BCD 
     
The_Dab_Display3: BCD_Display

    Port Map( 
         
            clk   => clk,         
            reset => Reset_enable,
            Bin   => LEDS,                         
            Hex   => Hex5
      );
 
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
      
        
end ServoMotor;