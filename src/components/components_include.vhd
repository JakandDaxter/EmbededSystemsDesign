-------------------------------------------------------------------------------
-- THE COMPONENTS
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--****************************************************************************--
PACKAGE components_include IS --the name of the file shoud be components_include



--********-----****--------------*************-----------************-------**********---

COMPONENT rising_edge_synchronizer IS

    port (
            clk                : in std_logic;
            reset              : in std_logic;
            inputy             : in std_logic;
             edge              : out std_logic
          );
end component;

--********-----****--------------*************-----------************-------**********---

COMPONENT synchronizer4bit IS
        port (
                clk               : in std_logic;
                reset             : in std_logic;
                async_in          : in  std_logic_vector(3 downto 0);
                sync_out          : out  std_logic_vector(3 downto 0)
             );
END COMPONENT;

--********-----****--------------*************-----------************-------**********---

COMPONENT synchronizer8bit IS
        port (
                clk               : in  std_logic;
                reset             : in  std_logic;
                async_in          : in  std_logic_vector(7 downto 0);
                sync_out          : out std_logic_vector(7 downto 0)
             );
END COMPONENT;

--********-----****--------------*************-----------************-------**********---

COMPONENT FSM_Angle  IS

  port (  clk                                           : in   std_logic;
          reset                                         : in   std_logic;
          verfiedMin		                            : in   std_logic; --minimum angle verified from C
          verfiedMax		                            : in   std_logic; --maximum angle verified from C
          Write_en									    : out  std_logic; --write enable 
          Start_Servo								    : out  std_logic; --alright, we can use this to debug, this will light up the LED's according to the state and let me know which state i am in
          KEY								            : in   std_logic_vector(3 downto 0); --this is coming fromm the rising edge synchronizer
          state											: out  std_logic_vector(5 downto 0)
          clk                                           : in   std_logic;
          );
END COMPONENT;
--********-----****--------------*************-----------************-------**********---

COMPONENT FSM_Servo  IS

  port ( 
          clk                                           : in   std_logic;
          reset                                         : in   std_logic;
--        enable		                                : in   std_logic; --start the servo process
		  Write_en									    : in   std_logic; --write enable 
--		  Period		                                : in   std_logic; --flag to let us know that the period is counting so we can=
--		  AngleCount		                            : in   std_logic;
	  	  Max_Interrupt									: in   std_logic; --the interrupt that will become a one when the PW count made it to the max
	      Min_Interrupt									: in   std_logic --the interrupt that will become a one when the PW count made it to the min  
          state											: out  std_logic_vector(5 downto 0)
END COMPONENT;

--********-----****--------------*************-----------************-------**********---

COMPONENT BCD IS

PORT(
          clk       : IN STD_LOGIC;
         reset      : IN STD_LOGIC;
          Bin       : IN STD_LOGIC_VECTOR(3 downto 0);                             
          Hex       : OUT STD_LOGIC_VECTOR(6 downto 0)
      );
      
END COMPONENT;

--********-----****--------------*************-----------************-------**********---

COMPONENT memory IS
        generic (addr_width : integer := 2;
                 data_width : integer := 8);
                 port (
                        clk               : in std_logic;
                        we                : in std_logic;
                        addr              : in std_logic_vector(addr_width - 1 downto 0);
                        din               : in std_logic_vector(data_width - 1 downto 0);
                        dout              : out std_logic_vector(data_width - 1 downto 0)
                    );
END COMPONENT;

--********-----****--------------*************-----------************-------**********---

COMPONENT generic_counter_Angle IS
            port (
    clk             : in   std_logic; 
    reset           : in   std_logic;
	Angle1			: in   std_logic_vector(7 downto 0); --min angle			
	Angle2			: in   std_logic_vector(7 downto 0): --max angle
	Time            : in   std_logic; --period
	Max_Interrupt	: out  std_logic; --the interrupt that will become a one when the PW count made it to the max
	Min_Interrupt	: out  std_logic --the interrupt that will become a one when the PW count made it to the min
	PWM           	: out  std_logic; -- will be a one when ever the count has not reached the bounds
	
END COMPONENT;
--********-----****--------------*************-----------************-------**********---

COMPONENT generic_counter_Time IS
  generic (
    max_count       : integer := 1000000
  );
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    output          : out std_logic
  );  
END COMPONENT;

--********-----****--------------*************-----------************-------**********---

COMPONENT double_dabble IS
   Port ( 
           binIN   : in  STD_LOGIC_VECTOR (11 downto 0);
           ones   : out  STD_LOGIC_VECTOR (3 downto 0);
           tens   : out  STD_LOGIC_VECTOR (3 downto 0);
           hundreds : out  STD_LOGIC_VECTOR (3 downto 0)
           --thousands : out  STD_LOGIC_VECTOR (3 downto 0)
          );
END COMPONENT;


--********-----****--------------*************-----------************-------**********---
COMPONENT BCD IS

    PORT(
          clk   : IN STD_LOGIC;
          reset : IN STD_LOGIC;
          Bin   :IN STD_LOGIC_VECTOR(3 downto 0);                             
          Hex   :OUT STD_LOGIC_VECTOR(6 downto 0)
      );
      
END COMPONENT;

--********-----****--------------*************-----------************-------**********---
END components_include; --ending the file 
