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
constant MinAngle				: std_logic_vector(31 downto 0):= X"0000C350"; --45
constant MaxAngle				: std_logic_vector(31 downto 0):= X"000186A0"; --135 
constant Degree 				: std_logic_vector(6 downto 0) := "0011000"; --degree symbol

Signal  Min_raw           		:std_logic_vector(31 downto 0); -- sends in the raw data
Signal  Max_raw           		:std_logic_vector(31 downto 0); -- sends in the raw data

Signal  Raw_input               :std_logic_vector(7 downto 0); -- raw data

Signal  Min_sync           		:std_logic_vector(31 downto 0); -- sends in the raw data
Signal  Max_sync           		:std_logic_vector(31 downto 0); -- sends in the raw data

Signal  TimingCount             : integer range 0 to 1000000 := 0; --using this to check the count of the period in the angle counter component to ajust the pulse wdith

signal  STATE_S					:std_logic_vector(3 downto 0); --will handle the state so that i know when to enable the servo interrupt

signal  Write_enable    		:std_logic; --will be set to a one depening on the state from the angle statemachine

signal  Address_for_mem 		:std_logic_vector(1 downto 0); --i set this to the respected address i want to write to
 
signal  Read_Data 		        :std_logic_vector(31 downto 0); --comes out of memory
signal  Stored_Data       		:std_logic_vector(31 downto 0); --goes into memory
signal  Disable					:std_logic;


signal  Double_Dab_Ones       	:std_logic_vector(3 downto 0); --display
signal  Double_Dab_Tens       	:std_logic_vector(3 downto 0); --display
signal  Double_Dab_Hundres    	:std_logic_vector(3 downto 0); --display

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
-- have a process here to change the data from the switches into an integer

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
The_State_MachineA: FSM_Angle

    Port Map(  
			clk        			 		=>  CLOCK_50,
            reset                       =>  reset_n,             
            verfiedMin                  =>  minverified,   
            verfiedMax    		 	    =>  maxverified,    
            Write_en                    =>  Write_enable,
            Start_Servo                 =>  servoenable,
            KEY		                    =>  KEY,
            state		        	    =>  STATE_A          
          );
--****************************************--		  
 Timing_Counter: generic_counter_Time
 		Port Map(
		
		clk               =>   CLOCK_50,
		reset             =>   reset_n,
		counter           =>   TimingCount,
		output            =>   ActivePeriod
		
		);
 --****************************************--		
Angle_Counter: generic_counter_Angle
		Port Map(
		clk                =>   CLOCK_50,
		reset              =>   reset_n,
		Timer              =>   ActivePeriod, --when the timer hits 1 mil
		PeriodCount        =>   TimingCount,
		Max_Interrupt      =>   Interruptmax,
		state	           =>   STATE_S,
		Min_Interrupt      =>   interruptmin,
		PWM                =>   PWM
		);
--*******************************************************************************************************************************************************************************--
--*******************************************************************************************************************************************************************************-- 
The_Seperation: double_dabble

    Port Map(
               
           binIN     =>  --This will be the angle gotten stright form the swithces 8 bit synrhonizer,,,STD_LOGIC_VECTOR (11 downto 0);
           ones      => Double_Dab_Ones,
           tens      => Double_Dab_Tens,
           hundreds  => Double_Dab_Hundres
           );

--****************************************--  
--****************************************--  
--****************************************-- 
 
The_Dab_Display0: BCD

    Port Map( 
         
      clk               => CLOCK_50,
      reset             => reset_n,
      Bin               => Double_Dab_Ones,
	  State_of_angel    => State_A,                            
      Hex               => HEX5
      );
--****************************************--

The_Dab_Display1: BCD

    Port Map(
          
        clk             => CLOCK_50,         
        reset           => reset_n,
        Bin             => Double_Dab_Tens,
		State_of_angel  => State_A,                         
        Hex             => HEX4
      );
	  
--****************************************--
--debating when to display the degree symbl
When_To_Display_Degree: Process(CLOCK_50, reset_n, STATE_A)

BEGIN

        if(reset_n = '0') THEN
        
                HEX2 <= BLANK;
                
            elsif(CLOCK_50'event and CLOCK_50 = '1')
            
            if(STATE_A = "000001") THEN
            
                HEX2 <= Degree;
                
            elsif(STATE_A = "001000")
            
                HEX2 <= Degree;
                
            else
                
                HEX2 <= BLANK;
                
            end if;
        end if;
    end process;
--****************************************--

The_Dab_Display2: BCD

    Port Map( 
         
        clk             => CLOCK_50,         
        reset           => reset_n,
        Bin             => Double_Dab_Hundres,
		State_of_angel  => State_A,                         
        Hex             => HEX3
      );
	  
--****************************************-- 
-- display the state orrcording to the current status of the servo enable or tje angle as default
State_LEDS: Process(CLOCK_50,servoenable,reset_n)
begin
	
    if (reset_n = '0') then 
		
	
	LEDR <= "0000000000";

    elsif (CLOCK_50'event and CLOCK_50 = '1') then
		
      if (servoenable = '1') then
		  
		  LEDR <= "000000" & STATE_S; --display the state of the servo motor

      else
		  
		  	LEDR <= "0000" & STATE_A; --display the state of the angle verification

      end if;
	   
    end if;
	
  end process;
--*******************************************************************************************************************************************************************************-- 
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
      
        
end ServoMotor;