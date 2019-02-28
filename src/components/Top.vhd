-------------------------------------------------------------------------------
-- Aliana Tejeda
-- Top
--(  )_(  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Top is

    port (

      ---- PWM Output ----
 
    	PWM : out std_logic;

      ----- CLOCK -----
	 
      CLOCK_50 : in std_logic;

      ----- SEG7 -----
      HEX5 : out std_logic_vector(6 downto 0);
	  HEX4 : out std_logic_vector(6 downto 0);
	  HEX3 : out std_logic_vector(6 downto 0);
	  HEX2 : out std_logic_vector(6 downto 0); -- use this to show the degree symbol


      ----- KEY -----
      KEY : in std_logic_vector(3 downto 0); --remeber to use key(0) for reset

      ----- LED -----
      LEDR : out  std_logic_vector(9 downto 0);

      ----- SW -----
      SW : in  std_logic_vector(7 downto 0) 
	    
  	 );
	                  
end Top;  

architecture ServoMotor of Top  is 
--------------------------------------
--Signals
--------------------------------------
constant MinAngle				: std_logic_vector(7 downto 0):= X"0000C350"; --45
constant MaxAngle				: std_logic_vector(7 downto 0):= X"000186A0"; --135 

Signal  Min_raw           		:std_logic_vector(7 downto 0); -- sends in the raw data
Signal  Max_raw           		:std_logic_vector(7 downto 0); -- sends in the raw data

Signal  Min_sync           		:std_logic_vector(7 downto 0); -- sends in the raw data
Signal  Max_sync           		:std_logic_vector(7 downto 0); -- sends in the raw data


signal  STATE_A					:std_logic_vector(5 downto 0); --will handle the state so that i know when to enable the write
signal  STATE_S					:std_logic_vector(3 downto 0); --will handle the state so that i know when to enable the servo interrupt

signal  Write_enable    		:std_logic; --will be set to a one depening on the state from the angle statemachine

signal  Address_for_mem 		:std_logic_vector(1 downto 0); --i set this to the respected address i want to write to

signal  verfiedMin		        :std_logic; --minimum angle verified from C
signal  verfiedMax		        :std_logic; --maximum angle verified from C
 
signal  Double_Dab_Data 		:std_logic_vector(7 downto 0); --comes out of memory


signal  Double_Dab_Ones       	:std_logic_vector(3 downto 0);
signal  Double_Dab_Tens       	:std_logic_vector(3 downto 0);
signal  Double_Dab_Hundres    	:std_logic_vector(3 downto 0);

BEGIN --We begin the ARCHITECTUREE

--****************************************--  
--****************************************--  
--****************************************--

We_talking_about_Addresses_here: Process(Address_for_mem,STATE_A)

                                 BEGIN
                                 
							Case STATE IS
							WHEN "000100" => --when in the verfied min stage stage
								IF (Write_enable = '1') THEN
									Address_for_mem <="00";
										end if;
									WHEN "100000" => --when in the verfied max stage
									IF (Write_enable = '1') THEN
										Address_for_mem <="01";
											end if;		
											WHEN OTHERS => Address_for_mem <= "00";
										end case;	
									end process;

--****************************************--
--****************************************--  
--****************************************--  
--****************************************--
Just_Sending_Info_Through_Registers1:Process(clk,Reset_enable,input_sync,Min_raw)
                                    BEGIN
                  
                                    if(Reset_enable = '1') THEN
                                        Min_raw <= (others => '0');
                                        ELSIF(clk'event and clk = '1') THEN
                                                    if(STATE_A = "000001") THEN --when in the inputting of the min angle state
														Min_raw <= input_sync;	--have the synced inputed data from the switches go into the raw minimum				
													ELSE					
														Min_raw <= Min_raw ;
															end if;		
									end if;
                           end process;
--****************************************-- 
 
Just_Sending_Info_Through_Registers2:Process(clk,Reset_enable,input_sync,Max_raw)
 
                                BEGIN
                                       if(Reset_enable = '1') THEN      
                                           Max_raw <= (others => '0');
                                        ELSIF(clk'event and clk = '1') THEN
                                            if(STATE_A = "001000") THEN	--when in the inputting of the max angle state
												Max_raw <= input_sync;   --have the synced inputed data from the switches go into the raw maximum
                                            ELSE
                                                Max_raw <= Max_raw;
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
    

--*******************************************************************************************************************************************************************************--
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************-- 

--****************************************--
The_State_Machine: FSM_Servo

    Port Map(  

            clk                 =>  clk,             
            reset               =>  Reset_enable,    
            Execute_btn_sync    =>      
            LED_display         =>  
            write_en            =>
            recall              =>
            save                =>
                                     
          );
--****************************************--		  
The_State_Machine: FSM_Angle

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