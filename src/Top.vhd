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
    HEX3 : out std_logic_vector(6 downto 0);--make this go blank
    HEX2 : out std_logic_vector(6 downto 0);
    HEX1 : out std_logic_vector(6 downto 0);
    HEX0 : out std_logic_vector(6 downto 0);  


    ----- KEY -----
    KEY : in std_logic_vector(3 downto 0); --remeber to use key(0) for reset


    ----- SW -----
    SW : in  std_logic_vector(7 downto 0) 
	    
  	 );
	                  
end Top;  

architecture ServoMotor of Top  is


--COMPONENT Servo_Controller is
--  port (
--		clk               	     : in   std_logic; 
--		reset_n             		  : in   std_logic;
--      address                   : in std_logic;
--      write                     : in std_logic;
--      writedata                 : in std_logic;
--		PWM           	  	: out  std_logic -- will be a one when ever the count has not reached the bounds
--  );  
--end COMPONENT;
component nios_system is
	port (
		clk_clk                            : in  std_logic                    := 'X';             -- clk
		hex0_export                        : out std_logic_vector(6 downto 0);                    -- export
		hex1_export                        : out std_logic_vector(6 downto 0);                    -- export
		hex2_export                        : out std_logic_vector(6 downto 0);                    -- export
		hex3_export                        : out std_logic_vector(6 downto 0);                    -- export
		hex4_export                        : out std_logic_vector(6 downto 0);                    -- export
		hex5_export                        : out std_logic_vector(6 downto 0);                    -- export
		pushbuttons_export                 : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
		reset_reset_n                      : in  std_logic                    := 'X';             -- reset_n
		servo_controller_0_conduit_end_pwm : out std_logic;                                       -- pwm
		switches_export                    : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
	);
end component nios_system;
--------------------------------------
--Constants
--------------------------------------
constant MinAngle							: std_logic_vector(31 downto 0):= X"0000C350"; --45
constant MaxAngle							: std_logic_vector(31 downto 0):= X"000186A0"; --135 
--Signals

    
signal reset_n 							:std_logic;
signal key0_d1 					  		:std_logic;
signal key0_d2 							:std_logic;
signal key0_d3 							:std_logic;





BEGIN --We begin the ARCHITECTUREE

----- Synchronize the reset

		synchReset_proc : process (CLOCK_50) begin
		  if (rising_edge(CLOCK_50)) then
		    key0_d1 <= KEY(0);
		    key0_d2 <= key0_d1;
		    key0_d3 <= key0_d2;
		  end if;
		end process synchReset_proc;
		reset_n <= key0_d3;
--*******************************************************************************************************************************************************************************--
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************-- 	
--Angle_Counter: Servo_Controller
--        Port Map(
--        clk                 =>   CLOCK_50,
--        reset               =>   reset_n,
--        PWM                 =>   PWM
--        );
u0 : component nios_system
	port map (
		clk_clk                            => CLOCK_50,                            --                            clk.clk
		hex0_export                        => HEX0,                        --                           hex0.export
		hex1_export                        => HEX1,                        --                           hex1.export
		hex2_export                        => HEX2,                        --                           hex2.export
		hex3_export                        => HEX3,                        --                           hex3.export
		hex4_export                        => HEX4,                        --                           hex4.export
		hex5_export                        => HEX5,                        --                           hex5.export
		pushbuttons_export                 => KEY,                 --                    pushbuttons.export
		reset_reset_n                      => reset_n,                      --                          reset.reset_n
		servo_controller_0_conduit_end_pwm => PWM, -- servo_controller_0_conduit_end.pwm
		switches_export                    => SW                     --                       switches.export
	);
--*******************************************************************************************************************************************************************************--
--*******************************************************************************************************************************************************************************-- 
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
--*******************************************************************************************************************************************************************************--  
      
        
end ServoMotor;