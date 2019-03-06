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
use work.components_include.all;

entity Top is

    port (

      ---- PWM Output ----
 
    	PWM : out std_logic;

      ----- CLOCK -----
	 
      CLOCK_50 : in std_logic;


      ----- KEY -----
      KEY : in std_logic_vector(3 downto 0) --remeber to use key(0) for reset
	    
  	 );
	                  
end Top;  

architecture ServoMotor of Top  is 
--------------------------------------
--Signals
--------------------------------------
constant MinAngle				: std_logic_vector(31 downto 0):= X"0000C350"; --45
constant MaxAngle				: std_logic_vector(31 downto 0):= X"000186A0"; --135 

Signal  Min_raw           		:std_logic_vector(31 downto 0); -- sends in the raw data
Signal  Max_raw           		:std_logic_vector(31 downto 0); -- sends in the raw data

Signal  Raw_input               :std_logic_vector(7 downto 0); -- raw data

Signal  Min_sync           		:std_logic_vector(31 downto 0); -- sends in the raw data
Signal  Max_sync           		:std_logic_vector(31 downto 0); -- sends in the raw data



signal  STATE_S					:std_logic_vector(3 downto 0); --will handle the state so that i know when to enable the servo interrupt

signal  Write_enable    		:std_logic; --will be set to a one depening on the state from the angle statemachine

signal  Address_for_mem 		:std_logic_vector(1 downto 0); --i set this to the respected address i want to write to
 
signal  Read_Data 		        :std_logic_vector(31 downto 0); --comes out of memory
signal  Stored_Data       		:std_logic_vector(31 downto 0); --goes into memory
signal  Disable					:std_logic;


signal  Double_Dab_Ones       	:std_logic_vector(3 downto 0);
signal  Double_Dab_Tens       	:std_logic_vector(3 downto 0);
signal  Double_Dab_Hundres    	:std_logic_vector(3 downto 0);

signal reset_n 					:std_logic;
signal key0_d1 					:std_logic;
signal key0_d2 					:std_logic;
signal key0_d3 					:std_logic;

--Signals to interconnect port maps--
signal servoenable 					    :std_logic;  ---the signal to start the servo
signal Interruptmax 					:std_logic;
signal interruptmin 					:std_logic;
signal ActivePeriod 					:std_logic;

-- signal minverified 						:std_logic :='1';
-- signal maxverified 						:std_logic :='1';

--signal extended_data						:std_logic_vector(11 downto 0);



BEGIN --We begin the ARCHITECTUREE

--****************************************--  
--****************************************--  
--****************************************--


We_talking_about_Addresses_here: Process(Address_for_mem,STATE_S,Write_enable,Min_sync,Max_sync)

                                 BEGIN
                                 
							Case STATE_S IS
								
								WHEN "1110" => --int right
								
									IF (Write_enable = '1') THEN
									
										Address_for_mem <="00";
									 
									 else
	 									Address_for_mem <="00"; --just read from here
										
										end if;
										
								WHEN "1101" => --int left
								
									IF (Write_enable = '1') THEN
									
										Address_for_mem <="01";
										
									else
										
										Address_for_mem <="01"; --just read from here
										
											end if;
													
											WHEN OTHERS => Address_for_mem <="00";
											
										end case;	
										
									end process;

--****************************************--
We_talking_about_storage_here: Process(Address_for_mem,STATE_S,Write_enable,Min_sync,Max_sync)

                                 BEGIN
                                 
							Case STATE_S IS
							
								WHEN "1110" => --when in the verfied min stage stage
								
								IF (Write_enable = '1') THEN
									     
										 Stored_Data <= Min_sync;
									 
									 else
											
											Stored_Data <= Min_sync;
										
										end if;
								
								WHEN "1101" => --when in the verfied max stage
									
									IF (Write_enable = '1') THEN
										
										Stored_Data <= Max_sync;
									
									else
										
										Stored_Data <= Max_sync;
											
											end if;		
											
											WHEN OTHERS => Stored_Data <= Min_sync;
										
										end case;	
									
									end process; 
									
--****************************************-- 
--****************************************-- 
--****************************************--  
--****************************************-- 

--put the memory port map here

Memory_for_display: memory
--this is for the switches for the operation

    Port Map(
                clk      => CLOCK_50,
                we       => write_enable,       --send a 1 if you wanna save data into address 10 else your reading from the working 00
                addr     => Address_for_mem,    --the working memory is 00 so the write enable is a 0
                din      => Stored_Data,                --its been through the process
                dout     => Read_Data     --this is the info we want to display
        );


--****************************************--  
--****************************************-- 
--****************************************--
--****************************************--
----- Synchronize the reset
		synchReset_proc : process (CLOCK_50) begin
		  if (rising_edge(CLOCK_50)) then
		    key0_d1 <= KEY(0);
		    key0_d2 <= key0_d1;
		    key0_d3 <= key0_d2;
		  end if;
		end process synchReset_proc;
		reset_n <= key0_d3;

--****************************************--

A_Synchonizer: synchronizer8bit

    Port Map(     
                clk         => CLOCK_50,      
                reset       => reset_n,      
                async_in    => Min_raw,      
                sync_out    => Min_sync   --use this      
  
        );
    
--****************************************--

B_Synchonizer: synchronizer8bit

    Port Map( 
    
                clk         => CLOCK_50,      
                reset       => reset_n,      
                async_in    => Max_raw,      
                sync_out    => Max_sync    --use this         

        );
--*******************************************************************************************************************************************************************************--
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************-- 

--****************************************--
The_State_MachineF: FSM_Servo

    Port Map(  
			clk          				=>  CLOCK_50,
			reset              			=>  reset_n,
			Write_en                	=>  Write_enable,           
            Max_Interrupt        		=>  Interruptmax,
            Min_Interrupt        		=>  Interruptmin,
			state                  	    =>  STATE_S               
          );
--****************************************--		  
 Timing_Counter: generic_counter_Time
 		Port Map(
		
		clk               =>   CLOCK_50,
		reset             =>   reset_n,
		output            =>   ActivePeriod
		
		);
 --****************************************--		
Angle_Counter: generic_counter_Angle
		Port Map(
		clk                =>   CLOCK_50,
		reset              =>   reset_n,
		Timer              =>   ActivePeriod,
		Max_Interrupt      =>   Interruptmax,
		state	           =>   STATE_S,
		Min_Interrupt      =>   interruptmin,
		PWM                =>   PWM
		);
--*******************************************************************************************************************************************************************************--
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************-- 
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
      
        
end ServoMotor;