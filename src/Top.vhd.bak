-------------------------------------------------------------------------
-- Author: Gregg Guarino Ph.D.
-- Jan. 17, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY lights is
  port (
    ----- Audio -----
    AUD_ADCDAT : in std_logic; 
    AUD_ADCLRCK : inout std_logic;
    AUD_BCLK : inout std_logic;
    AUD_DACDAT : out std_logic;
    AUD_DACLRCK : inout std_logic;
    AUD_XCK : out std_logic;

    ----- CLOCK -----
    CLOCK_50 : in std_logic;
    CLOCK2_50 : in std_logic;
    CLOCK3_50 : in std_logic;
    CLOCK4_50 : in std_logic;

    ----- SDRAM -----
    DRAM_ADDR : out std_logic_vector(12 downto 0);
    DRAM_BA : out std_logic_vector(1 downto 0);
    DRAM_CAS_N : out std_logic;
    DRAM_CKE : out std_logic;
    DRAM_CLK : out std_logic;
    DRAM_CS_N : out std_logic;
    DRAM_DQ : inout std_logic_vector(15 downto 0);
    DRAM_LDQM : out std_logic;
    DRAM_RAS_N : out std_logic;
    DRAM_UDQM : out std_logic;
    DRAM_WE_N : out std_logic;

    ----- I2C for Audio and Video-In -----
    FPGA_I2C_SCLK : out std_logic;
    FPGA_I2C_SDAT : inout std_logic;

    ----- SEG7 -----
    HEX0 : out std_logic_vector(6 downto 0);
    HEX1 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX3 : out std_logic_vector(6 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX5 : out std_logic_vector(6 downto 0);

    ----- KEY -----
    KEY : in std_logic_vector(3 downto 0);

    ----- LED -----
    LEDR : out  std_logic_vector(9 downto 0);

    ----- SW -----
    SW : in  std_logic_vector(9 downto 0);

    ----- GPIO_0, GPIO_0 connect to GPIO Default -----
    GPIO_0 : inout  std_logic_vector(35 downto 0);

    ----- GPIO_1, GPIO_1 connect to GPIO Default -----
    GPIO_1 : inout  std_logic_vector(35 downto 0)
  );
end entity lights;

architecture lights_arch of lights is
  -- signal declarations
  signal led0 : std_logic;
  signal cntr : std_logic_vector(25 downto 0);
  signal ledNios : std_logic_vector(7 downto 0);
  signal reset_n : std_logic;
  signal key0_d1 : std_logic;
  signal key0_d2 : std_logic;
  signal key0_d3 : std_logic;
  signal sw_d1 : std_logic_vector(9 downto 0);
  signal sw_d2 : std_logic_vector(9 downto 0);
  
  component nios_system is
    port (
      clk_clk         : in  std_logic                    := 'X';             -- clk
      reset_reset_n   : in  std_logic                    := 'X';             -- reset_n
      switches_export : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
      leds_export     : out std_logic_vector(7 downto 0)                     -- export
    );
  end component nios_system;
  
begin

  LEDR(9 downto 0) <= "1" & ledNios & led0;
  led0 <= cntr(24);
  
  ----- Syncronize the reset
  synchReset_proc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      key0_d1 <= KEY(0);
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
    end if;
  end process synchReset_proc;
  reset_n <= key0_d3;
  
  ----- Synchronize the pushbutton inputs and increment counter
  synchUserIn_proc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      if (reset_n = '0') then
        cntr <= "00" & x"000000";
        sw_d1 <= "00" & x"00";
        sw_d2 <= "00" & x"00";
      else
        cntr <= cntr + ("00" & x"000001");
        sw_d1 <= SW;
        sw_d2 <= sw_d1;
      end if;
    end if;
  end process synchUserIn_proc;

  ----- Instantiate the nios processor
  u0 : component nios_system
    port map (
      clk_clk         => CLOCK2_50,         --      clk.clk
      reset_reset_n   => reset_n,   --    reset.reset_n
      switches_export => sw_d2(7 downto 0), -- switches.export
      leds_export     => ledNios      --     leds.export
    );

end architecture lights_arch;
