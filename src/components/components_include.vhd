-------------------------------------------------------------------------------
-- THE COMPONENTS
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--****************************************************************************--
PACKAGE MY_MAJESTIC_COMPONENTS IS --the name of the file shoud be MY_MAJESTIC_COMPONENTS



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

COMPONENT synchronizer2bit IS
        port (
                clk               : in std_logic;
                reset             : in std_logic;
                async_in          : in  std_logic_vector(1 downto 0);
                sync_out          : out  std_logic_vector(1 downto 0)
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

COMPONENT FSM  IS

  port (
          clk                                           : in   std_logic;
          reset                                         : in   std_logic;
         Execute_btn_sync,Saves,Writes,Recalls          : in   std_logic;--this is coming fromm the rising edge synchronizer
          LED_display                                   : out  std_logic_vector(3 downto 0);--this is just to show the state on the LED display so we know what state we are in
          
          write_en,recall,save                          : out  std_logic;
          Address_for_mems                              : out  std_logic_vector(1 downto 0)
                  
          );
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

COMPONENT ALU IS
            port (
                    clk           : in  std_logic;
                    reset         : in  std_logic;
                    a             : in  std_logic_vector(7 downto 0); 
                    b             : in  std_logic_vector(7 downto 0);
                    op            : in  std_logic_vector(1 downto 0); -- 00: add, 01: sub, 10: mult, 11: div
                    result        : out std_logic_vector(7 downto 0)
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
COMPONENT BCD_Display IS

    PORT(
          clk   : IN STD_LOGIC;
          reset : IN STD_LOGIC;
          Bin   :IN STD_LOGIC_VECTOR(3 downto 0);                             
          Hex   :OUT STD_LOGIC_VECTOR(6 downto 0)
      );
      
END COMPONENT;

--********-----****--------------*************-----------************-------**********---
END MY_MAJESTIC_COMPONENTS; --ending the file 
