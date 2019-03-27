library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity top_level_tb is
end top_level_tb;

architecture arch of top_level_tb is

component Top is
  Port(

  ---- PWM Output ----

	PWM : out std_logic;

  ----- CLOCK -----
 
  CLOCK_50 : in std_logic;

  ----- SEG7 -----
  --HEX5 : out std_logic_vector(6 downto 0);
  --HEX4 : out std_logic_vector(6 downto 0);
  --HEX3 : out std_logic_vector(6 downto 0);
  --HEX2 : out std_logic_vector(6 downto 0); -- use this to show the degree symbol


  ----- KEY -----
  KEY : in std_logic_vector(3 downto 0) --remeber to use key(0) for reset

  ----- LED -----
  --LEDR : out  std_logic_vector(9 downto 0);

  ----- SW -----
  --SW : in  std_logic_vector(9 downto 0) 
   
);
end component; 

signal 			Button									: std_logic_vector(3 downto 0):= "1111";

signal 			LEDS									: std_logic_vector(9 downto 0);

signal 			switch_sig                      		: std_logic_vector(9 downto 0):= "0000000000"; 
  
signal  	    Hex_5,Hex_4,Hex_3,Hex_2            			: std_logic_vector(6 downto 0);

constant 		period                       			: time := 20 ns; 
                                             
signal clk                            					: std_logic:= '0';
signal reset                          					: std_logic:= '0';--active low reset

signal pwm                          					: std_logic:= '0';--active low reset


begin

--bcd iteration
-- sequential_tb : process
--     begin
--       report "****************** sequential testbench start ****************";
--       wait for 80 ns;
--
-- 		 wait for 100 ns;
--
-- 		 wait for 100 ns;
--
-- 		 wait for 100 ns;
--
--
--
--   end process;

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process;

-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset <= '1';--active low reset
    wait;
end process;

--button process




uut: Top
  port map(
  CLOCK_50                   =>  clk,
  --HEX5                       =>  Hex_5,
  --HEX4                       =>  Hex_4,
  --HEX3                       =>  Hex_3,
  --HEX2		             =>  Hex_2,
  KEY		             =>  Button,
  --LEDR			     =>  LEDS,
  --SW			     =>  switch_sig,
  PWM                  	     =>  pwm 

  );
end arch;